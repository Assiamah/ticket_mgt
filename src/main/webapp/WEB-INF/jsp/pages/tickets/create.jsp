<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Tickets</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Tickets</a></li>
            <li class="breadcrumb-item active" aria-current="page">My Tickets</li>
          </ol>
        </nav>
      </div>
    </div>

    <div class="row mb-3">
      <div class="col-12">
        <div class="d-flex gap-2">
          <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createTicketModal">
            <i class="ri-draft-line"></i> Create Ticket
          </button>
          <div class="ms-auto">
            <button type="button" class="btn btn-outline-primary" id="refreshTicketsBtn">
              <i class="ri-refresh-line"></i> Refresh
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-3 mb-3">
      <div class="col-md-2">
        <div class="card"><div class="card-body d-flex align-items-center justify-content-between"><div><div class="text-muted">Open</div><div class="fs-5 fw-semibold" id="status_open">0</div></div><i class="ri-record-circle-line text-primary"></i></div></div>
      </div>
      <div class="col-md-2">
        <div class="card"><div class="card-body d-flex align-items-center justify-content-between"><div><div class="text-muted">In Progress</div><div class="fs-5 fw-semibold" id="status_in_progress">0</div></div><i class="ri-run-line text-info"></i></div></div>
      </div>
      <div class="col-md-2">
        <div class="card"><div class="card-body d-flex align-items-center justify-content-between"><div><div class="text-muted">On Hold</div><div class="fs-5 fw-semibold" id="status_on_hold">0</div></div><i class="ri-pause-circle-line text-warning"></i></div></div>
      </div>
      <div class="col-md-2">
        <div class="card"><div class="card-body d-flex align-items-center justify-content-between"><div><div class="text-muted">Resolved</div><div class="fs-5 fw-semibold" id="status_resolved">0</div></div><i class="ri-checkbox-circle-line text-success"></i></div></div>
      </div>
      <div class="col-md-2">
        <div class="card"><div class="card-body d-flex align-items-center justify-content-between"><div><div class="text-muted">Closed</div><div class="fs-5 fw-semibold" id="status_closed">0</div></div><i class="ri-close-circle-line text-secondary"></i></div></div>
      </div>
    </div>

    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header"><p class="text-muted mb-4 col-8">View your organization tickets. Non system owners have view-only actions.</p></div>
          <div class="card-body">
            <div class="table-responsive">
              <table id="tickets-datatable" class="table table-striped dt-responsive w-100">
                <thead>
                  <tr>
                    <th>Ticket #</th>
                    <th>Title</th>
                    <th>Type</th>
                    <th>Priority</th>
                    <th>Description</th>
                    <th>Created By</th>
                    <th>Remarks</th>
                    <th>Status</th>
                    <th>Company Name</th>
                    <th>Assigned To</th>
                    <th>Created Date</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody></tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade modal-blur" id="createTicketModal" tabindex="-1" aria-labelledby="createTicketModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content modern-modal">
        <div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));">
          <div class="d-flex align-items-center gap-3">
            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.10), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);">
              <i class="bi bi-plus-circle-fill text-primary fs-4"></i>
            </div>
            <div>
              <h5 id="createTicketModalLabel" class="mb-0 fw-semibold">Create New Ticket</h5>
              <small class="text-muted">Fill in the details to create a ticket</small>
            </div>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form id="createTicketForm">
            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="organization_id" class="form-label">Organization</label>
                <select id="organization_id" class="form-select"></select>
              </div>
              <div class="col-md-6 mb-3">
                <label for="task_subject" class="form-label">Title <span class="text-danger">*</span></label>
                <input type="text" class="form-control" id="task_subject" required>
              </div>
              <div class="col-md-6 mb-3">
                <label for="priority_id" class="form-label">Priority <span class="text-danger">*</span></label>
                <select id="priority_id" class="form-select" required>
                  <option value="">Select Priority</option>
                </select>
              </div>
              <div class="col-md-6 mb-3">
                <label for="status_id" class="form-label">Status</label>
                <select id="status_id" class="form-select">
                  <option value="">Select Status</option>
                </select>
              </div>
            </div>
            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="task_type" class="form-label">Type<span class="text-danger">*</span></label>
                <select class="form-select" id="task_type" required>
                  <option value="">Select Type</option>
                  <option value="customer-service">Customer Service</option>
                  <option value="it">IT</option>
                  <option value="pur">Purchasing</option>
                </select>
              </div>
              <div class="col-md-6 mb-3">
                <label for="product_id" class="form-label">Product <span class="text-danger">*</span></label>
                <select id="product_id" class="form-select" required>
                  <option value="">Select Product</option>
                </select>
              </div>
            </div>
            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="category_id" class="form-label">Category <span class="text-danger">*</span></label>
                <select id="category_id" class="form-select" required>
                  <option value="">Select Category</option>
                </select>
              </div>
              <div class="col-md-6 mb-3">
                <label for="due_date" class="form-label">Due Date</label>
                <input type="date" class="form-control" id="due_date">
              </div>
            </div>
            <div class="mb-3">
              <label for="task_description" class="form-label">Description <span class="text-danger">*</span></label>
              <textarea class="form-control" id="task_description" rows="4" required></textarea>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-primary" id="createTicketBtn">Create Ticket</button>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="viewTicketModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl">
      <div class="modal-content modern-modal">
        <div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));">
          <div class="d-flex align-items-center gap-3">
            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.08), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);">
              <i class="bi bi-card-text text-primary fs-4"></i>
            </div>
            <div>
              <h5 class="mb-0 fw-semibold">Ticket Details</h5>
              <small class="text-muted">View the ticket and its activity</small>
            </div>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-md-8">
              <div class="card">
                <div class="card-header"><h6 class="card-title mb-0">Ticket Information</h6></div>
                <div class="card-body"><div id="ticketDetailsContent"></div></div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="card">
                <div class="card-header"><h6 class="card-title mb-0">Summary</h6></div>
                <div class="card-body">
                  <p class="mb-2"><strong>Status: </strong> <span id="view_meta_status" class="badge bg-secondary">&nbsp;</span></p>
                  <p class="mb-2"><strong>Priority: </strong> <span id="view_meta_priority" class="badge bg-secondary">&nbsp;</span></p>
                  <p class="mb-2"><strong>Assigned To: </strong> <span id="view_meta_assigned_to" class="text-muted">&nbsp;</span></p>
                  <p class="mb-2"><strong>Created By: </strong> <span id="view_meta_created_by" class="text-muted">&nbsp;</span></p>
                  <p class="mb-0"><strong>Due Date: </strong> <span id="view_meta_due_date" class="text-muted">&nbsp;</span></p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const TICKET_API_BASE = '${pageContext.request.contextPath}/api/tickets';
      const ORG_API = '${pageContext.request.contextPath}/api/organizations';
      let IS_SYSTEM_OWNER = true;
      let allRows = [];
      function safeParseJson(text) { try { return JSON.parse(text); } catch (_) { return null; } }
      function showNotification(message, type = 'success') { Toastify({ text: message, duration: 3000, close: true, gravity: 'top', position: 'right', backgroundColor: type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : type === 'warning' ? '#ffc107' : '#17a2b8' }).showToast(); }

      const table = $('#tickets-datatable').DataTable({
        columns: [
          { data: null, orderable: true, render: function(_, __, row){ return row.task_ticket_no || row.ticket_number || row.ticket_no || ''; } },
          { data: null, orderable: true, render: function(_, __, row){ return row.task_subject || row.title || ''; } },
          { data: 'task_type', render: function(data, type, row){ const cls=getPriorityClass(row.priority_level); return '<span class="badge bg-'+cls+'">'+(data||'')+'</span>'; } },
          { data: null, orderable: true, render: function(_, __, row){ return row.task_priority || row.priority_name || ''; } },
          { data: null, orderable: true, render: function(_, __, row){ return row.task_description || row.description || ''; } },
          { data: 'created_by', orderable: true },
          { data: 'task_remarks', orderable: true },
          { data: null, orderable: true, render: function(_, __, row){ const raw=row.task_status||row.status_name||''; const s = String(raw).toLowerCase()==='assigned' ? 'In Progress' : raw; return s; } },
          { data: null, orderable: true, defaultContent: '', render: function(_, __, row){ return row.created_by_org_name || row.comp_name || row.org_name || row.organization_name || row.company_name || row.company || ''; } },
          { data: null, orderable: true, render: function(_, __, row){ return row.task_assigned_to || row.assigned_to_name || ''; } },
          { data: null, render: function(_, __, row){ const data=row.created_date||row.created_at; return formatDate(data); } },
          { data: null, orderable: false, className: 'text-end', render: function(_, __, row){ return '<div class="d-flex gap-2 justify-content-end"><button type="button" class="btn btn-light-info icon-btn-sm btn-view" data-task-id="'+(row.ticket_id||'')+'" data-task-uid="'+(row.task_uid||'')+'" title="View Ticket"><i class="mdi mdi-eye"></i></button></div>'; } }
        ],
        dom: "<'d-flex align-items-center mb-2'<'btn-left'B><'ms-auto'f>>"+"<'row'<'col-sm-12'tr>>"+"<'row mt-2'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'p>>",
        buttons: [ { extend:'copyHtml5', text:'<i class="mdi mdi-content-copy me-1"></i> Copy', className:'btn btn-sm btn-outline-danger me-1' }, { extend:'csvHtml5', text:'<i class="mdi mdi-file-excel me-1"></i> CSV', className:'btn btn-sm btn-outline-success me-1' }, { extend:'print', text:'<i class="bi bi-printer me-1"></i> Print', className:'btn btn-sm btn-outline-info me-1' } ]
      });

      function getPriorityClass(level){ switch(parseInt(level)){ case 1: return 'danger'; case 2: return 'warning'; case 3: return 'info'; case 4: return 'primary'; case 5: return 'secondary'; default: return 'secondary'; } }
      function getStatusClass(status){ const s=(status||'').toString().toLowerCase(); switch(s){ case 'open': return 'primary'; case 'in progress': return 'info'; case 'on hold': return 'warning'; case 'resolved': return 'success'; case 'closed': return 'secondary'; default: return 'secondary'; } }
      function formatDate(d){ if(!d) return 'N/A'; const dt=new Date(d); return dt.toLocaleDateString('en-US',{year:'numeric',month:'short',day:'numeric',hour:'2-digit',minute:'2-digit'}); }

      async function loadTickets(){ try{ const r=await fetch(TICKET_API_BASE + '/list'); const t=await r.text(); const d=safeParseJson(t)||{}; const rows= Array.isArray(d)? d : (d.tickets||d.data||d.items||d.rows||[]); allRows = Array.isArray(rows)? rows : []; renderTickets(); } catch(e){ console.error('loadTickets error',e); showNotification('Error loading tickets','error'); } }
      function renderTickets(){ table.clear(); table.rows.add(allRows.map(function(r){ const sRaw = r.task_status || r.status_name || ''; if (String(sRaw).toLowerCase()==='assigned') r.status_name = 'In Progress'; return r; })); table.draw(); updateStatusCards(allRows); }
      function updateStatusCards(rows){ const counts={ open:0, 'in progress':0, 'on hold':0, resolved:0, closed:0 }; (rows||[]).forEach(function(r){ let s = String(r.task_status||r.status_name||'').toLowerCase(); if (s==='assigned') s='in progress'; if (counts.hasOwnProperty(s)) counts[s]++; }); const set=(id,v)=>{ const el=document.getElementById(id); if(el) el.textContent=v; }; set('status_open',counts.open); set('status_in_progress',counts['in progress']); set('status_on_hold',counts['on hold']); set('status_resolved',counts.resolved); set('status_closed',counts.closed); }

      $('#tickets-datatable tbody').on('click','tr',function(){ const row=table.row(this).data(); if(!row) return; setPreview(row); });
      document.addEventListener('click', function(e){ const v=e.target.closest('.btn-view'); if(v){ viewTicket(v.dataset.taskId||'', v.dataset.taskUid||''); return; } });

      function setPreview(row){ const num=document.getElementById('preview_ticket_number'); const title=document.getElementById('preview_title'); const st=document.getElementById('preview_status'); const pr=document.getElementById('preview_priority'); if(num) num.textContent=row.task_ticket_no||row.ticket_number||row.ticket_no||''; if(title) title.textContent=row.task_subject||row.title||''; let s = row.task_status||row.status_name||''; if (String(s).toLowerCase()==='assigned') s='In Progress'; if(st){ st.className='badge bg-'+getStatusClass(s); st.textContent=s; } if(pr){ pr.className='badge bg-'+getPriorityClass(row.priority_level); pr.textContent=row.task_priority||row.priority_name||''; } }

      async function viewTicket(taskId, taskUid){ const p=new URLSearchParams(); if(taskId) p.append('task_id',taskId); if(taskUid) p.append('task_uid',taskUid); try{ const r=await fetch(TICKET_API_BASE+'/view',{ method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:p.toString() }); const t=await r.text(); const d=safeParseJson(t)||{}; const payload=d.data||d; if(payload.task_id||payload.task_uid||payload.id){ displayTicketDetails(payload); (new bootstrap.Modal(document.getElementById('viewTicketModal'))).show(); } else { showNotification((d && (d.message||d.error||d.status)) || 'Failed to load ticket','error'); } }catch(e){ console.error('viewTicket error',e); showNotification('Error loading ticket','error'); } }
      function displayTicketDetails(ticket){ const title=ticket.task_subject||ticket.title||''; const number=ticket.task_ticket_no||ticket.ticket_number||''; let statusName=ticket.task_status||ticket.status_name||ticket.status||''; if(String(statusName).toLowerCase()==='assigned') statusName='In Progress'; const priorityName=ticket.task_priority||ticket.priority_name||''; const due=ticket.task_due_date||ticket.due_date||''; const desc=ticket.task_description||ticket.description||''; const content='<h4>'+title+'</h4><div class="row mt-3"><div class="col-md-6"><p><strong>Ticket Number:</strong> '+number+'</p><p><strong>Status:</strong> <span class="badge bg-'+getStatusClass(statusName)+'">'+statusName+'</span></p><p><strong>Priority:</strong> <span class="badge bg-'+getPriorityClass(ticket.priority_level)+'">'+priorityName+'</span></p></div><div class="col-md-5"><p><strong>Due Date:</strong> '+formatDate(due)+'</p></div></div><div class="mt-3"><strong>Description:</strong><p class="mt-2">'+desc+'</p></div>'; document.getElementById('ticketDetailsContent').innerHTML=content; const statusEl=document.getElementById('view_meta_status'); const priorityEl=document.getElementById('view_meta_priority'); const assignedEl=document.getElementById('view_meta_assigned_to'); const createdByEl=document.getElementById('view_meta_created_by'); const dueDateEl=document.getElementById('view_meta_due_date'); if(statusEl){ statusEl.textContent=statusName||'N/A'; statusEl.className='badge bg-'+getStatusClass(statusName||''); } if(priorityEl){ priorityEl.textContent=priorityName||'N/A'; priorityEl.className='badge bg-'+getPriorityClass(ticket.priority_level); } if(assignedEl) assignedEl.textContent=ticket.task_assigned_to||ticket.assigned_to_name||'Unassigned'; if(createdByEl) createdByEl.textContent=ticket.created_by||'Unknown'; if(dueDateEl) dueDateEl.textContent=formatDate(due)||'N/A'; document.getElementById('viewTicketModal').dataset.ticketId = ticket.task_id || ticket.ticket_id || ticket.task_uid || ticket.id || ''; }

      async function loadPriorities(){ try{ const sel=document.getElementById('priority_id'); if(!sel) return; let rows=[]; try{ const r1=await fetch(TICKET_API_BASE + '/priorities/list',{ method:'POST', headers:{'Content-Type':'application/json'}, body:'{}' }); const t1=await r1.text(); const d1=safeParseJson(t1)||{}; rows=Array.isArray(d1)?d1:(d1.priorities||d1.data||[]); }catch(e){ rows=[]; } if(!rows||!rows.length){ try{ const r2=await fetch(TICKET_API_BASE + '/priorities'); const t2=await r2.text(); const d2=safeParseJson(t2)||{}; rows=Array.isArray(d2)?d2:(d2.priorities||d2.data||[]); }catch(e){ rows=[]; } } sel.innerHTML='<option value="">Select Priority</option>'+ (rows||[]).map(function(p){ const id=p.priority_id||p.id||p.code||p.value||p.name; const name=p.name||p.label||p.code||String(id); return '<option value="'+id+'">'+name+'</option>'; }).join(''); }catch(_){} }
      async function loadStatuses(){ try{ const sel=document.getElementById('status_id'); if(!sel) return; let rows=[]; try{ const r1=await fetch(TICKET_API_BASE + '/statuses/list',{ method:'POST', headers:{'Content-Type':'application/json'}, body:'{}' }); const t1=await r1.text(); const d1=safeParseJson(t1)||{}; rows=Array.isArray(d1)?d1:(d1.statuses||d1.data||[]); }catch(e){ rows=[]; } if(!rows||!rows.length){ try{ const r2=await fetch(TICKET_API_BASE + '/statuses'); const t2=await r2.text(); const d2=safeParseJson(t2)||{}; rows=Array.isArray(d2)?d2:(d2.statuses||d2.data||[]); }catch(e){ rows=[]; } } sel.innerHTML='<option value="">Select Status</option>'+ (rows||[]).map(function(s){ const id=s.status_id||s.id||s.code||s.value||s.name; const name=s.name||s.label||s.code||String(id); return '<option value="'+id+'">'+name+'</option>'; }).join(''); }catch(_){} }
      async function loadCategories(){ try{ const sel=document.getElementById('category_id'); if(!sel) return; let rows=[]; try{ const r1=await fetch(TICKET_API_BASE + '/categories/list',{ method:'POST', headers:{'Content-Type':'application/json'}, body:'{}' }); const t1=await r1.text(); const d1=safeParseJson(t1)||{}; rows=Array.isArray(d1)?d1:(d1.categories||d1.data||[]); }catch(e){ rows=[]; } if(!rows||!rows.length){ try{ const r2=await fetch(TICKET_API_BASE + '/categories'); const t2=await r2.text(); const d2=safeParseJson(t2)||{}; rows=Array.isArray(d2)?d2:(d2.categories||d2.data||[]); }catch(e){ rows=[]; } } sel.innerHTML='<option value="">Select Category</option>'+ (rows||[]).map(function(p){ const id=p.category_id||p.id||p.code||p.value||p.name; const name=p.name||p.label||p.code||String(id); return '<option value="'+id+'">'+name+'</option>'; }).join(''); }catch(_){} }
      async function loadOrganizations(){ try{ const r=await fetch(ORG_API); const t=await r.text(); const d=safeParseJson(t)||{}; const rows=Array.isArray(d)?d:(d.organizations||d.data||[]); const sel=document.getElementById('organization_id'); if(sel){ sel.innerHTML='<option value="">Select Organization</option>'+ rows.map(function(o){ const id=o.org_id||o.id; const name=o.org_name||o.name||''; return id? '<option value="'+id+'">'+name+'</option>' : ''; }).join(''); } }catch(_){} }
      async function loadCreateContext(orgId){ try{ const url = orgId? TICKET_API_BASE + '/create_context?org_id='+encodeURIComponent(orgId) : TICKET_API_BASE + '/create_context'; const r=await fetch(url); const t=await r.text(); const d=safeParseJson(t)||{}; const ctx = d.org_context || d.context || {}; IS_SYSTEM_OWNER = !!(ctx && (ctx.is_system_owner===true || String(ctx.is_system_owner).toLowerCase()==='true'));
        const products = Array.isArray(d.products)? d.products : (d.products && d.products.data) ? d.products.data : (d.data && d.data.products) ? d.data.products : [];
        const orgSel=document.getElementById('organization_id'); const prodSel=document.getElementById('product_id');
        if(prodSel){ if(products.length===1){ const p=products[0]; const id=p.product_id||p.id; const name=p.product_name||p.name||''; prodSel.innerHTML = id? '<option value="'+id+'">'+name+'</option>' : '<option value="">Select Product</option>'; prodSel.disabled = true; } else { prodSel.disabled = false; prodSel.innerHTML = '<option value="">Select Product</option>' + products.map(function(p){ const id=p.product_id||p.id; const name=p.product_name||p.name||''; return id? '<option value="'+id+'">'+name+'</option>' : ''; }).join(''); } }
        if(orgSel){ const orgIdVal = ctx && (ctx.org_id || (ctx.org && ctx.org.org_id) || ctx.organization_id || ctx.organizationId);
          const orgNameVal = ctx && (ctx.org_name || (ctx.org && (ctx.org.org_name||ctx.org.name)) || ctx.organization_name || ctx.organizationName);
          if(IS_SYSTEM_OWNER){ orgSel.parentElement.style.display='block'; if(!orgSel.options.length){ await loadOrganizations(); } if(orgId){ orgSel.value = orgId; } orgSel.disabled=false; }
          else { orgSel.parentElement.style.display='block'; orgSel.disabled=true; orgSel.innerHTML = (orgIdVal? ('<option value="'+orgIdVal+'">'+(orgNameVal||'My Organization')+'</option>') : '<option value="">My Organization</option>'); }
        }
      }catch(e){ console.error('loadCreateContext error',e); } }

      async function createTicket(){ if(!validateForm()) return; const subject=document.getElementById('task_subject').value; const desc=document.getElementById('task_description').value; const pr=document.getElementById('priority_id').value; const prSel=document.getElementById('priority_id'); const prName = prSel && prSel.options[prSel.selectedIndex] ? prSel.options[prSel.selectedIndex].text : ''; const statusId=document.getElementById('status_id').value; const payload={ title:subject, description:desc, task_type:document.getElementById('task_type').value, product_id:document.getElementById('product_id').value, category_id:document.getElementById('category_id').value }; if(pr) payload.priority_id=pr; if(prName) payload.priority=prName; if(statusId) payload.status_id=statusId; const due=document.getElementById('due_date').value; if(due) payload.due_date=due; try{ const response=await fetch(TICKET_API_BASE + '/create',{ method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }); const text=await response.text(); const result=safeParseJson(text)||{}; if((result && (result.success===true || result.status==='Success')) && response.ok){ showNotification('Ticket created successfully','success'); (bootstrap.Modal.getInstance(document.getElementById('createTicketModal'))||new bootstrap.Modal(document.getElementById('createTicketModal'))).hide(); document.getElementById('createTicketForm').reset(); loadTickets(); } else { showNotification((result.message||result.error||'Failed to create ticket'),'error'); } }catch(error){ console.error(error); showNotification('Error creating ticket','error'); } }
      function validateForm(){ const f=['task_subject','task_type','task_description','priority_id','product_id','category_id']; for(const id of f){ const el=document.getElementById(id); if(el && !String(el.value||'').trim()){ showNotification('Please fill '+id.replace('_',' '),'error'); return false; } } return true; }

      document.getElementById('refreshTicketsBtn').addEventListener('click', loadTickets);
      $('#createTicketModal').on('shown.bs.modal', async function(){ try{ await loadPriorities(); await loadStatuses(); await loadCategories(); const orgVal = document.getElementById('organization_id') ? document.getElementById('organization_id').value : ''; await loadCreateContext(orgVal || undefined); }catch(_){ } });
      document.getElementById('createTicketBtn').addEventListener('click', createTicket);
      const orgSelEl = document.getElementById('organization_id'); if(orgSelEl) orgSelEl.addEventListener('change', function(){ loadCreateContext(this.value); });
      loadCreateContext(); loadTickets();
    });
  </script>
  </main>
