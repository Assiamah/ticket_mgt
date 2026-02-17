CREATE OR REPLACE FUNCTION tickets_mgt.get_organization_archived_tasks(p_params json) 
  RETURNS json 
  LANGUAGE plpgsql 
 AS $function$ 
 DECLARE 
     v_user_uuid UUID; 
     v_organization_id UUID; 
     v_user_org_id UUID; 
     v_user_full_name TEXT; 
 
     v_from_date DATE; 
     v_to_date DATE; 
     v_search_term TEXT; 
 
     v_page INTEGER; 
     v_limit INTEGER; 
     v_offset INTEGER; 
 
     v_total_count INTEGER := 0; 
     v_tasks JSON; 
 BEGIN 
     -- Extract parameters 
     -- We cast to TEXT first then UUID to be safe, or just UUID if input is valid string
     v_user_uuid := (p_params->>'user_id')::UUID; 
     v_organization_id := (p_params->>'organization_id')::UUID; 
 
     v_from_date := COALESCE((p_params->>'from_date')::DATE, CURRENT_DATE - INTERVAL '90 days'); 
     v_to_date := COALESCE((p_params->>'to_date')::DATE, CURRENT_DATE); 
     v_search_term := p_params->>'search_term'; 
     v_page := COALESCE((p_params->>'page')::INTEGER, 1); 
     v_limit := COALESCE((p_params->>'limit')::INTEGER, 50); 
     v_offset := (v_page - 1) * v_limit; 
 
     -- Validate limit 
     IF v_limit < 1 OR v_limit > 500 THEN 
         v_limit := 50; 
     END IF; 
 
     -- ================== VALIDATE USER AND ORGANIZATION ================== 
     -- Get user's organization to verify access 
     -- FIX 1: Cast unique_id to TEXT to compare with v_user_uuid (which is UUID)
     -- FIX 2: Cast org_id to UUID for v_user_org_id variable assignment
     SELECT org_id::UUID, full_name 
     INTO v_user_org_id, v_user_full_name 
     FROM users.tbl_users 
     WHERE unique_id::TEXT = v_user_uuid::TEXT; 
 
     IF v_user_org_id IS NULL THEN 
         RETURN json_build_object( 
             'success', FALSE, 
             'message', 'User not found', 
             'error_code', 'USER_NOT_FOUND' 
         ); 
     END IF; 
 
     -- Verify the user has access to this organization 
     IF v_user_org_id != v_organization_id THEN 
         RETURN json_build_object( 
             'success', FALSE, 
             'message', 'Access denied to this organization', 
             'error_code', 'ACCESS_DENIED' 
         ); 
     END IF; 
 
     -- ================== FETCH ARCHIVED TASKS ================== 
     BEGIN 
         WITH org_tasks AS ( 
             SELECT 
                 t.task_id, 
                 t.task_uid, 
                 t.task_ticket_no, 
                 t.task_subject, 
                 t.task_description, 
                 COALESCE(s.name, t.task_status) as status, 
                 COALESCE(p.name, t.task_priority) as priority, 
                 c.name as category_name, 
                 pr.product_name, 
                 t.created_date, 
                 t.archived_at, 
                 t.archived_by, 
                 t.task_assigned_to, 
                 t.task_assigned_to_uuid, 
                 au.full_name as assigned_to_name, 
                 au.email as assigned_to_email, 
                 DATE_PART('day', CURRENT_TIMESTAMP - t.archived_at)::INTEGER as days_archived, 
                 ROW_NUMBER() OVER (ORDER BY t.archived_at DESC) AS row_num, 
                 COUNT(*) OVER() AS total_count 
             FROM tickets_mgt.tasks t 
             LEFT JOIN tickets_mgt.statuses s ON t.status_id = s.status_id 
             LEFT JOIN tickets_mgt.priorities p ON t.priority_id = p.priority_id 
             LEFT JOIN tickets_mgt.categories c ON t.category_id = c.category_id 
             LEFT JOIN products.tbl_products pr ON t.product_id = pr.product_id 
             -- FIX 3: Cast both sides to TEXT for JOIN condition
             LEFT JOIN users.tbl_users au ON t.task_assigned_to_uuid::TEXT = au.unique_id::TEXT 
             WHERE t.is_archived = TRUE 
             -- FIX 4: Cast org_id to TEXT to compare with v_organization_id (UUID)
             AND t.org_id::TEXT = v_organization_id::TEXT 
             AND (v_from_date IS NULL OR t.archived_at::DATE >= v_from_date) 
             AND (v_to_date IS NULL OR t.archived_at::DATE <= v_to_date) 
             AND ( 
                 v_search_term IS NULL OR 
                 t.task_subject ILIKE '%' || v_search_term || '%' OR 
                 t.task_ticket_no ILIKE '%' || v_search_term || '%' OR 
                 t.task_description ILIKE '%' || v_search_term || '%' OR 
                 t.archived_by ILIKE '%' || v_search_term || '%' 
             ) 
         ), 
         paginated_tasks AS ( 
             SELECT * 
             FROM org_tasks 
             WHERE row_num > v_offset AND row_num <= v_offset + v_limit 
             ORDER BY row_num 
         ) 
         SELECT 
             COALESCE( 
                 json_agg( 
                     json_build_object( 
                         'task_id', task_id, 
                         'task_uid', task_uid, 
                         'ticket_number', task_ticket_no, 
                         'subject', task_subject, 
                         'description', task_description, 
                         'status', status, 
                         'priority', priority, 
                         'category', category_name, 
                         'product', product_name, 
                         'created_date', created_date, 
                         'archived_at', archived_at, 
                         'archived_by', archived_by, 
                         'assigned_to', json_build_object( 
                             'email', task_assigned_to, 
                             'uuid', task_assigned_to_uuid, 
                             'name', assigned_to_name 
                         ), 
                         'days_archived', days_archived 
                     ) 
                 ), 
                 '[]'::JSON 
             ), 
             COALESCE(MAX(total_count), 0) 
         INTO v_tasks, v_total_count 
         FROM paginated_tasks; 
 
     EXCEPTION WHEN OTHERS THEN 
         RETURN json_build_object( 
             'success', FALSE, 
             'message', 'Database error: ' || SQLERRM, 
             'error_code', 'QUERY_ERROR', 
             'error_detail', SQLERRM 
         ); 
     END; 
 
     -- ================== BUILD RESPONSE ================== 
     RETURN json_build_object( 
         'success', TRUE, 
         'message', 'Successfully retrieved organization archived tasks', 
         'user_info', json_build_object( 
             'full_name', v_user_full_name, 
             'org_id', v_organization_id 
         ), 
         'data', json_build_object( 
             'tasks', COALESCE(v_tasks, '[]'::JSON), 
             'total_count', v_total_count, 
             'page', v_page, 
             'limit', v_limit, 
             'total_pages', CEIL(v_total_count::NUMERIC / v_limit) 
         ) 
     ); 
 END; 
 $function$;