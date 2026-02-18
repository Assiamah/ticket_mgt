/**
 * Ticket management javascript
 */

document.addEventListener('DOMContentLoaded', function() {
    // These should be defined in the JSP before this script is loaded
    const TICKET_API = typeof TICKET_API_BASE !== 'undefined' ? TICKET_API_BASE : (window.CONTEXT_PATH || '') + '/api/tickets';
    const ORGANIZATION_API = typeof ORG_API !== 'undefined' ? ORG_API : (window.CONTEXT_PATH || '') + '/v1/organization_service/get_all_organizations';
    const PRODUCT_API = (window.CONTEXT_PATH || '') + '/api/products';
    
    let IS_SYSTEM_OWNER = true;
    let allRows = [];
    let loadedOrganizations = [];

    // --- Helpers ---
    function safeParseJson(text) { 
        try { return JSON.parse(text); } catch (_) { return null; } 
    }

    function showNotification(message, type = 'success') { 
        if (typeof Toastify !== 'undefined') {
            Toastify({ 
                text: message, 
                duration: 3000, 
                close: true, 
                gravity: 'top', 
                position: 'right', 
                backgroundColor: type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : type === 'warning' ? '#ffc107' : '#17a2b8' 
            }).showToast(); 
        } else {
            alert(message);
        }
    }

    function getPriorityClass(level) { 
        switch(parseInt(level)) { 
            case 1: return 'danger'; 
            case 2: return 'warning'; 
            case 3: return 'info'; 
            case 4: return 'primary'; 
            case 5: return 'secondary'; 
            default: return 'secondary'; 
        } 
    }

    function getStatusClass(status) { 
        const s = (status || '').toString().toLowerCase(); 
        switch(s) { 
            case 'open': return 'success'; 
            case 'in progress': return 'info'; 
            case 'on hold': return 'warning'; 
            case 'resolved': return 'primary'; 
            case 'closed': return 'secondary'; 
            default: return 'secondary'; 
        } 
    }

    function formatDate(d) { 
        if(!d) return 'N/A'; 
        const dt = new Date(d); 
        return dt.toLocaleDateString('en-US', {
            year: 'numeric', 
            month: 'short', 
            day: 'numeric', 
            hour: '2-digit', 
            minute: '2-digit'
        }); 
    }

    // --- DataTable Initialization ---
    let table = null;
    if ($('#tickets-datatable').length > 0) {
        table = $('#tickets-datatable').DataTable({
            columns: [
                { 
                    data: null, 
                    orderable: false, 
                    render: function() { 
                        return '<div class="form-check"><input class="form-check-input row-select" type="checkbox"></div>'; 
                    } 
                },
                { 
                    data: null, 
                    orderable: true, 
                    render: function(_, __, row) { 
                        return '<span class="fw-semibold">' + (row.task_ticket_no || row.ticket_number || row.ticket_no || 'N/A') + '</span>'; 
                    } 
                },
                { 
                    data: null, 
                    orderable: true, 
                    render: function(_, __, row) { 
                        return '<div class="ticket-title">' + (row.task_subject || row.title || 'No Title') + '</div>'; 
                    } 
                },
                { 
                    data: 'task_type', 
                    render: function(data) { 
                        return '<span class="text-muted">' + (data || 'N/A') + '</span>'; 
                    } 
                },
                { 
                    data: null, 
                    orderable: true, 
                    render: function(_, __, row) { 
                        const cls = getPriorityClass(row.priority_level);
                        const name = row.task_priority || row.priority_name || 'Normal';
                        return '<span class="badge bg-light-' + cls + ' text-' + cls + '">' + name + '</span>'; 
                    } 
                },
                { 
                    data: null, 
                    orderable: true, 
                    render: function(_, __, row) { 
                        const raw = row.task_status || row.status_name || 'Open'; 
                        const s = String(raw).toLowerCase() === 'assigned' ? 'In Progress' : raw; 
                        const cls = getStatusClass(s);
                        return '<span class="badge bg-' + cls + '">' + s + '</span>'; 
                    } 
                },
                { 
                    data: null, 
                    orderable: true, 
                    render: function(_, __, row) { 
                        return row.task_assigned_to || row.assigned_to_name || '<span class="text-muted">Unassigned</span>'; 
                    } 
                },
                { 
                    data: 'created_date', 
                    render: function(data, type, row) { 
                        const d = data || row.created_at;
                        if (type === 'display' || type === 'filter') {
                            return formatDate(d);
                        }
                        return d ? new Date(d).getTime() : 0;
                    } 
                },
                { 
                    data: null, 
                    render: function(_, __, row) { 
                        return formatDate(row.task_due_date || row.due_date); 
                    } 
                },
                { 
                    data: null, 
                    orderable: false, 
                    className: 'text-end', 
                    render: function(_, __, row) { 
                        const userRole = (typeof CURRENT_USER_ROLE !== 'undefined' ? CURRENT_USER_ROLE : '').toLowerCase();
                        const isAdmin = userRole.includes('admin') || userRole.includes('manager') || userRole.includes('owner');
                        
                        let actions = '<div class="d-flex gap-2 justify-content-end">';
                        
                        if (isAdmin) {
                            actions += `
                                <button type="button" class="btn btn-light-warning icon-btn-sm btn-assign" 
                                        data-task-id="${row.ticket_id || row.task_id || ''}" 
                                        title="Assign Ticket">
                                    <i class="bi bi-person-plus"></i>
                                </button>
                            `;
                        }
                        
                        actions += `
                                <button type="button" class="btn btn-light-info icon-btn-sm btn-view" 
                                        data-task-id="${row.ticket_id || row.task_id || ''}" 
                                        data-task-uid="${row.task_uid || ''}" title="View Ticket">
                                    <i class="bi bi-eye"></i>
                                </button>
                                <button type="button" class="btn btn-light-primary icon-btn-sm btn-edit" 
                                        data-task-id="${row.ticket_id || row.task_id || ''}" title="Edit Ticket">
                                    <i class="bi bi-pencil"></i>
                                </button>
                            </div>
                        `; 
                        return actions;
                    } 
                }
            ],
            dom: "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                 "<'row'<'col-sm-12'tr>>" +
                 "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            language: {
                search: "_INPUT_",
                searchPlaceholder: "Search tickets...",
                lengthMenu: "_MENU_ items per page",
                paginate: {
                    previous: '<i class="bi bi-chevron-left"></i>',
                    next: '<i class="bi bi-chevron-right"></i>'
                }
            },
            pageLength: 10,
            order: [[7, 'desc']] // Order by created date by default
        });
    }

    // --- Data Loading ---
    async function loadTickets() { 
        if (!table) return; // Skip if table not initialized
        try { 
            const r = await fetch(TICKET_API + '/list'); 
            const t = await r.text(); 
            const d = safeParseJson(t) || {}; 
            const rows = Array.isArray(d) ? d : (d.tickets || d.data || d.items || d.rows || []); 
            allRows = Array.isArray(rows) ? rows : []; 
            renderTickets(); 
        } catch(e) { 
            console.error('loadTickets error', e); 
            showNotification('Error loading tickets', 'error'); 
        } 
    }

    function renderTickets() { 
        if (!table) return;
        table.clear(); 
        
        let filteredRows = allRows;
        const currentUserId = typeof CURRENT_USER_ID !== 'undefined' ? CURRENT_USER_ID : null;
        const pathname = window.location.pathname;

        // 1. Context Filtering (My Tasks / Assigned Jobs)
        if (currentUserId) {
            if (pathname.includes('my_tasks')) {
                filteredRows = allRows.filter(r => 
                    String(r.created_by) === String(currentUserId) || 
                    String(r.assigned_to) === String(currentUserId) ||
                    String(r.assigned_to_id) === String(currentUserId)
                );
            } else if (pathname.includes('assigned_jobs')) {
                filteredRows = allRows.filter(r => 
                    String(r.assigned_to) === String(currentUserId) ||
                    String(r.assigned_to_id) === String(currentUserId)
                );
            }
        }

        // 2. User Filters
        const searchVal = (document.getElementById('tickets_search') || {}).value || '';
        const statusVal = (document.getElementById('filter_status') || {}).value || '';
        const priorityVal = (document.getElementById('filter_priority') || {}).value || '';
        const dateStart = (document.getElementById('filter_start') || {}).value;
        const dateEnd = (document.getElementById('filter_end') || {}).value;
        const unassignedOnly = (document.getElementById('filter_unassigned') || {}).checked;

        if (searchVal || statusVal || priorityVal || dateStart || dateEnd || unassignedOnly) {
            const lowerSearch = searchVal.toLowerCase();
            const startTs = dateStart ? new Date(dateStart).getTime() : null;
            const endTs = dateEnd ? new Date(dateEnd).getTime() + 86400000 : null; // End of day

            filteredRows = filteredRows.filter(r => {
                // Search Text
                if (searchVal) {
                    const text = (
                        (r.ticket_number || r.task_ticket_no || '') + ' ' + 
                        (r.title || r.task_subject || '') + ' ' + 
                        (r.description || r.task_description || '')
                    ).toLowerCase();
                    if (!text.includes(lowerSearch)) return false;
                }

                // Status
                if (statusVal) {
                    const s = String(r.task_status || r.status_name || '').toLowerCase();
                    if (s !== statusVal.toLowerCase()) return false;
                }

                // Priority
                if (priorityVal) {
                    const p = String(r.task_priority || r.priority_name || '').toLowerCase();
                    if (p !== priorityVal.toLowerCase()) return false;
                }

                // Date Range
                if (startTs || endTs) {
                    const d = r.created_date || r.created_at;
                    if (!d) return false;
                    const ts = new Date(d).getTime();
                    if (startTs && ts < startTs) return false;
                    if (endTs && ts > endTs) return false;
                }

                // Unassigned
                if (unassignedOnly) {
                    const assigned = r.task_assigned_to || r.assigned_to_name;
                    if (assigned && assigned !== 'Unassigned') return false;
                }

                return true;
            });
        }

        table.rows.add(filteredRows.map(function(r) { 
            const sRaw = r.task_status || r.status_name || ''; 
            if (String(sRaw).toLowerCase() === 'assigned') r.status_name = 'In Progress'; 
            return r; 
        })); 
        table.draw(); 
        updateStatusCards(filteredRows); 
        
        // Update counts
        const countEl = document.getElementById('ticketCount');
        if (countEl) countEl.textContent = filteredRows.length;
        
        const showingEl = document.getElementById('showingCount');
        if (showingEl) showingEl.textContent = table.page.info().recordsDisplay;
        
        const totalEl = document.getElementById('totalCount');
        if (totalEl) totalEl.textContent = filteredRows.length;
    }

    function updateStatusCards(rows) { 
        const counts = { open: 0, 'in progress': 0, 'on hold': 0, resolved: 0, closed: 0, overdue: 0 }; 
        const now = new Date();

        (rows || []).forEach(function(r) { 
            let s = String(r.task_status || r.status_name || '').toLowerCase(); 
            if (s === 'assigned') s = 'in progress'; 
            if (counts.hasOwnProperty(s)) counts[s]++; 
            
            // Check overdue
            const due = r.task_due_date || r.due_date;
            if (due && new Date(due) < now && s !== 'resolved' && s !== 'closed') {
                counts.overdue++;
            }
        }); 

        const set = (id, v) => { 
            const el = document.getElementById(id); 
            if(el) el.textContent = v; 
        }; 
        
        set('status_open', counts.open); 
        set('status_in_progress', counts['in progress']); 
        set('status_on_hold', counts['on hold']); 
        set('status_resolved', counts.resolved); 
        set('status_closed', counts.closed); 
        set('overdue_tickets', counts.overdue);
    }

    // --- Ticket Operations ---
    async function viewTicket(taskId, taskUid) { 
        const p = new URLSearchParams(); 
        if(taskId) p.append('task_id', taskId); 
        if(taskUid) p.append('task_uid', taskUid); 
        
        try { 
            const r = await fetch(TICKET_API + '/view', { 
                method: 'POST', 
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, 
                body: p.toString() 
            }); 
            const t = await r.text(); 
            const d = safeParseJson(t) || {}; 
            const payload = d.data || d; 
            
            if(payload.task_id || payload.task_uid || payload.id) { 
                displayTicketDetails(payload); 
                const modal = new bootstrap.Modal(document.getElementById('viewTicketModal'));
                modal.show(); 
            } else { 
                showNotification((d && (d.message || d.error || d.status)) || 'Failed to load ticket', 'error'); 
            } 
        } catch(e) { 
            console.error('viewTicket error', e); 
            showNotification('Error loading ticket', 'error'); 
        } 
    }

    function displayTicketDetails(ticket) { 
        const title = ticket.task_subject || ticket.title || ''; 
        const number = ticket.task_ticket_no || ticket.ticket_number || ''; 
        let statusName = ticket.task_status || ticket.status_name || ticket.status || ''; 
        if(String(statusName).toLowerCase() === 'assigned') statusName = 'In Progress'; 
        
        const priorityName = ticket.task_priority || ticket.priority_name || ''; 
        const due = ticket.task_due_date || ticket.due_date || ''; 
        const desc = ticket.task_description || ticket.description || ''; 
        const type = ticket.task_type || 'N/A';
        const assigned = ticket.task_assigned_to || ticket.assigned_to_name || 'Unassigned';
        const createdBy = ticket.created_by || 'Unknown';
        const org = ticket.created_by_org_name || ticket.org_name || 'N/A';
        const createdDate = formatDate(ticket.created_date || ticket.created_at);

        // Populate main content
        const contentEl = document.getElementById('ticketDetailsContent');
        if (contentEl) {
            contentEl.innerHTML = `
                <div class="mb-4">
                    <h4 class="mb-2">${title}</h4>
                    <div class="d-flex gap-2 mb-3">
                        <span class="badge bg-${getStatusClass(statusName)}">${statusName}</span>
                        <span class="badge bg-light-${getPriorityClass(ticket.priority_level)} text-${getPriorityClass(ticket.priority_level)}">${priorityName}</span>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <p class="text-muted mb-1">Ticket Number</p>
                        <p class="fw-semibold">${number}</p>
                    </div>
                    <div class="col-sm-6">
                        <p class="text-muted mb-1">Type</p>
                        <p class="fw-semibold">${type}</p>
                    </div>
                </div>
            `;
        }

        // Populate description
        const descEl = document.getElementById('view_description');
        if (descEl) descEl.textContent = desc;

        // Populate summary items
        const setMeta = (id, val, isBadge = false, cls = '') => {
            const el = document.getElementById(id);
            if (el) {
                el.textContent = val;
                if (isBadge) {
                    el.className = 'summary-value badge ' + cls;
                }
            }
        };

        setMeta('view_ticket_number', number);
        setMeta('view_meta_status', statusName, true, 'bg-' + getStatusClass(statusName));
        setMeta('view_meta_priority', priorityName, true, 'bg-light-' + getPriorityClass(ticket.priority_level) + ' text-' + getPriorityClass(ticket.priority_level));
        setMeta('view_meta_type', type);
        setMeta('view_meta_assigned_to', assigned);
        setMeta('view_meta_created_by', createdBy);
        setMeta('view_meta_organization', org);
        setMeta('view_meta_created_date', createdDate);
        setMeta('view_meta_due_date', formatDate(due));

        // Store ticket ID for actions
        const modal = document.getElementById('viewTicketModal');
        if (modal) {
            modal.dataset.ticketId = ticket.task_id || ticket.ticket_id || '';
            modal.dataset.taskUid = ticket.task_uid || '';
        }
    }

    async function createTicket() { 
        if(!validateForm()) return; 
        
        const payload = { 
            title: document.getElementById('task_subject').value, 
            description: document.getElementById('task_description').value, 
            task_type: document.getElementById('task_type').value, 
            product_id: document.getElementById('product_id').value, 
            category_id: document.getElementById('category_id').value,
            priority_id: document.getElementById('priority_id').value,
            status_id: document.getElementById('status_id').value,
            due_date: document.getElementById('due_date').value,
            organization_id: document.getElementById('organization_id').value,
            org_id: document.getElementById('organization_id').value
        }; 

        if (typeof CURRENT_USER_ID !== 'undefined' && CURRENT_USER_ID) {
            payload.user_id = CURRENT_USER_ID;
            payload.created_by = CURRENT_USER_ID;
        } 

        try { 
            const response = await fetch(TICKET_API + '/create', { 
                method: 'POST', 
                headers: { 'Content-Type': 'application/json' }, 
                body: JSON.stringify(payload) 
            }); 
            const text = await response.text(); 
            const result = safeParseJson(text) || {}; 
            
            if((result && (result.success === true || result.status === 'Success')) && response.ok) { 
                showNotification('Ticket created successfully', 'success'); 
                bootstrap.Modal.getInstance(document.getElementById('createTicketModal')).hide(); 
                document.getElementById('createTicketForm').reset(); 
                loadTickets(); 
            } else { 
                showNotification((result.message || result.error || 'Failed to create ticket'), 'error'); 
            } 
        } catch(error) { 
            console.error(error); 
            showNotification('Error creating ticket', 'error'); 
        } 
    }

    function validateForm() { 
        const requiredFields = ['organization_id', 'task_subject', 'task_type', 'task_description', 'priority_id']; 
        for(const id of requiredFields) { 
            const el = document.getElementById(id); 
            if(el && !String(el.value || '').trim()) { 
                showNotification('Please fill ' + id.replace('_', ' '), 'error'); 
                return false; 
            } 
        } 
        return true; 
    }

    // --- Assign Ticket ---
    async function loadAgents() {
        try {
            const sel = document.getElementById('assign_task_to');
            if (!sel || (sel.children.length > 1 && sel.value)) return; // Already loaded

            const r = await fetch(TICKET_API + '/users_for_assignment');
            const t = await r.text();
            const d = safeParseJson(t) || {};
            const users = Array.isArray(d) ? d : (d.data || d.users || []);
            
            sel.innerHTML = '<option value="">Select Agent</option>' + 
                (Array.isArray(users) ? users : []).map(u => {
                    const id = u.user_uuid || u.id || u.user_id || u.unique_id;
                    const name = u.display_name || u.name || u.email || 'Unknown Agent';
                    return `<option value="${id}">${name}</option>`;
                }).join('');
        } catch (e) {
            console.error('Error loading agents', e);
        }
    }

    function openAssignModal(taskId) {
        // Find row data
        const row = table.rows().data().toArray().find(r => 
            String(r.ticket_id || r.task_id) === String(taskId)
        );
        
        if (!row) return;
        
        const idInput = document.getElementById('assign_task_id');
        const subjInput = document.getElementById('assign_task_subject');
        const prioInput = document.getElementById('assign_task_priority');
        const notesInput = document.getElementById('assign_notes');
        
        if(idInput) idInput.value = taskId;
        if(subjInput) subjInput.value = row.task_subject || row.title || '';
        if(prioInput) prioInput.value = row.priority_name || row.priority || '';
        if(notesInput) notesInput.value = '';
        
        loadAgents();
        
        const modalEl = document.getElementById('assignTicketModal');
        if(modalEl) {
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
        }
    }
    
    async function assignTicket() {
        const taskId = document.getElementById('assign_task_id').value;
        const agentId = document.getElementById('assign_task_to').value;
        
        if (!agentId) {
            showNotification('Please select an agent', 'error');
            return;
        }
        
        try {
            const p = new URLSearchParams();
            p.append('task_id', taskId);
            p.append('user_to_assign_id', agentId);
            
            const r = await fetch(TICKET_API + '/assign_ticket', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: p.toString()
            });
            
            const t = await r.text();
            const d = safeParseJson(t) || {};
            
            if (d.status === 'success' || d.status === 'Success' || d.msg === 'Ticket assigned successfully') {
                showNotification('Ticket assigned successfully', 'success');
                const modalEl = document.getElementById('assignTicketModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if(modal) modal.hide();
                loadTickets();
            } else {
                showNotification((d.message || d.error || 'Failed to assign ticket'), 'error');
            }
        } catch (e) {
            console.error('Error assigning ticket', e);
            showNotification('Error assigning ticket', 'error');
        }
    }

    // --- Select/Option Loading ---
    async function loadOptions(endpoint, elementId, placeholder, idField, nameField) {
        try {
            const sel = document.getElementById(elementId);
            if (!sel) return;

            let rows = [];
            try {
                const r = await fetch(TICKET_API + endpoint, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: '{}'
                });
                const t = await r.text();
                const d = safeParseJson(t) || {};
                rows = Array.isArray(d) ? d : (d.data || d.items || []);
            } catch (e) {
                // Fallback to GET
                const r = await fetch(TICKET_API + endpoint.replace('/list', ''));
                const t = await r.text();
                const d = safeParseJson(t) || {};
                rows = Array.isArray(d) ? d : (d.data || d.items || []);
            }

            sel.innerHTML = `<option value="">${placeholder}</option>` + 
                (rows || []).map(item => {
                    const id = item[idField] || item.id || item.code;
                    const name = item[nameField] || item.name || item.label || String(id);
                    return `<option value="${id}">${name}</option>`;
                }).join('');
        } catch (err) {
            console.error(`Error loading options for ${elementId}`, err);
        }
    }

    async function loadOrganizations() {
        try {
            const r = await fetch(ORGANIZATION_API);
            const t = await r.text();
            const d = safeParseJson(t) || {};
            const rows = Array.isArray(d) ? d : (d.organizations || d.data || []);
            loadedOrganizations = rows; // Save for product lookup
            
            const sel = document.getElementById('organization_id');
            if(sel) {
                sel.innerHTML = '<option value="">Select Organization</option>' + 
                    rows.map(o => `<option value="${o.org_id || o.id}">${o.org_name || o.name || ''}</option>`).join('');
            }
        } catch (_) {}
    }

    function loadProducts(orgId) {
        const sel = document.getElementById('product_id');
        if (!sel) return;
        
        if (!orgId) {
            sel.innerHTML = '<option value="">Select Product</option>';
            return;
        }

        const org = loadedOrganizations.find(o => String(o.org_id || o.id) === String(orgId));
        const products = org ? (org.products || []) : [];
        
        sel.innerHTML = '<option value="">Select Product</option>' + 
            products.map(p => `<option value="${p.product_id || p.id}">${p.product_name || p.name}</option>`).join('');
    }

    // --- Event Listeners ---
    const refreshBtn = document.getElementById('refreshTicketsBtn');
    if (refreshBtn) refreshBtn.addEventListener('click', loadTickets);
    
    const createBtn = document.getElementById('createTicketBtn');
    if (createBtn) createBtn.addEventListener('click', createTicket);
    
    const assignSubmitBtn = document.getElementById('assignTicketBtn');
    if (assignSubmitBtn) assignSubmitBtn.addEventListener('click', assignTicket);

    $('#createTicketModal').on('shown.bs.modal', async function() {
        await Promise.all([
            loadOptions('/priorities/list', 'priority_id', 'Select Priority', 'priority_id', 'name'),
            loadOptions('/statuses/list', 'status_id', 'Select Status', 'status_id', 'name'),
            loadOptions('/categories/list', 'category_id', 'Select Category', 'category_id', 'name'),
            loadOrganizations()
        ]);
    });

    // Global click listener for dynamic elements
    document.addEventListener('click', function(e) {
        const assignBtn = e.target.closest('.btn-assign');
        if (assignBtn) {
            openAssignModal(assignBtn.dataset.taskId);
            return;
        }

        const viewBtn = e.target.closest('.btn-view');
        if (viewBtn) {
            viewTicket(viewBtn.dataset.taskId, viewBtn.dataset.taskUid);
            return;
        }

        const editBtn = e.target.closest('.btn-edit');
        if (editBtn) {
            // Implement edit logic or open edit modal
            console.log('Edit ticket:', editBtn.dataset.taskId);
            return;
        }
    });

    // --- Filter Event Listeners ---
    const applyFiltersBtn = document.getElementById('applyFiltersBtn');
    if (applyFiltersBtn) {
        applyFiltersBtn.addEventListener('click', renderTickets);
    }

    const clearFiltersBtn = document.getElementById('clearFiltersBtn');
    if (clearFiltersBtn) {
        clearFiltersBtn.addEventListener('click', function() {
            document.getElementById('tickets_search').value = '';
            document.getElementById('filter_status').value = '';
            document.getElementById('filter_priority').value = '';
            document.getElementById('filter_start').value = '';
            document.getElementById('filter_end').value = '';
            document.getElementById('filter_unassigned').checked = false;
            renderTickets();
        });
    }

    const searchInput = document.getElementById('tickets_search');
    if (searchInput) {
        searchInput.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') renderTickets();
        });
    }

    const orgSelect = document.getElementById('organization_id');
    if (orgSelect) {
        orgSelect.addEventListener('change', function() {
            loadProducts(this.value);
        });
    }

    // Initial load
    loadTickets();
});
