<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">My Performance</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Analytics</a></li>
            <li class="breadcrumb-item active" aria-current="page">Staff Performance</li>
          </ol>
        </nav>
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

    <div class="card">
      <div class="card-body">
        <div class="table-responsive">
          <table id="staff-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Ticket #</th>
                <th>Title</th>
                <th>Status</th>
                <th>Priority</th>
                <th>Assigned To</th>
                <th>Created</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function(){
      const TICKET_API_BASE = '/api/tickets';
      function safeParseJson(text) { try { return JSON.parse(text); } catch (_) { return null; } }
      function showNotification(message, type){ Toastify({ text: message, duration: 3000, close: true, gravity: 'top', position: 'right', backgroundColor: type==='error'?'#dc3545': type==='warning'?'#ffc107':'#28a745' }).showToast(); }
      function getStatusClass(status){ const s=(status||'').toString().toLowerCase(); switch(s){ case 'open': return 'primary'; case 'in progress': return 'info'; case 'on hold': return 'warning'; case 'resolved': return 'success'; case 'closed': return 'secondary'; default: return 'secondary'; } }
      function getPriorityClass(level){ switch(parseInt(level)){ case 1: return 'danger'; case 2: return 'warning'; case 3: return 'info'; case 4: return 'primary'; case 5: return 'secondary'; default: return 'secondary'; } }
      function formatDate(d){ if(!d) return 'N/A'; const dt=new Date(d); return dt.toLocaleDateString('en-US',{year:'numeric',month:'short',day:'numeric',hour:'2-digit',minute:'2-digit'}); }

      const table = $('#staff-datatable').DataTable({
        columns: [
          { data: null, render: function(_, __, row){ return row.task_ticket_no || row.ticket_number || row.ticket_no || ''; } },
          { data: null, render: function(_, __, row){ return row.task_subject || row.title || ''; } },
          { data: null, render: function(_, __, row){ const s=row.task_status||row.status_name||''; return '<span class="badge bg-'+getStatusClass(s)+'">'+s+'</span>'; } },
          { data: null, render: function(_, __, row){ return row.task_priority || row.priority_name || ''; } },
          { data: null, render: function(_, __, row){ return row.task_assigned_to || row.assigned_to_name || ''; } },
          { data: null, render: function(_, __, row){ return formatDate(row.created_date || row.created_at || ''); } },
          { data: null, className: 'text-end', orderable: false, render: function(_, __, row){ return '<div class="d-flex gap-2 justify-content-end"><button type="button" class="btn btn-light-info icon-btn-sm btn-view" data-task-id="'+(row.ticket_id||'')+'" data-task-uid="'+(row.task_uid||'')+'" title="View"><i class="mdi mdi-eye"></i></button><button type="button" class="btn btn-light-primary icon-btn-sm btn-update-status" data-task-id="'+(row.ticket_id||row.task_id||'')+'" title="Update Status"><i class="bi bi-pencil-square"></i></button></div>'; } }
        ]
      });

      let allRows = [];
      async function loadAssignedTickets(){ try{ const r=await fetch(TICKET_API_BASE + '/assigned-to-me'); const t=await r.text(); const d=safeParseJson(t)||{}; const rows = Array.isArray(d)? d : (d.tickets||d.data||d.items||d.rows||[]); allRows = Array.isArray(rows)? rows : []; renderAssigned(); } catch(e){ console.error('loadAssignedTickets error', e); showNotification('Error loading tickets','error'); } }
      function renderAssigned(){ table.clear(); table.rows.add(allRows); table.draw(); updateStatusCards(allRows); }
      function updateStatusCards(rows){ const counts={ open:0, 'in progress':0, 'on hold':0, resolved:0, closed:0 }; (rows||[]).forEach(function(r){ const s = (r.task_status || r.status_name || '').toLowerCase(); if(counts.hasOwnProperty(s)) counts[s]++; }); const set=(id,v)=>{ const el=document.getElementById(id); if(el) el.textContent=v; }; set('status_open',counts.open); set('status_in_progress',counts['in progress']); set('status_on_hold',counts['on hold']); set('status_resolved',counts.resolved); set('status_closed',counts.closed); }

      document.addEventListener('click', function(e){ const v=e.target.closest('.btn-view'); if(v){ viewTicket(v.dataset.taskId||'', v.dataset.taskUid||''); return; } const us=e.target.closest('.btn-update-status'); if(us){ openUpdateStatusModal(us.dataset.taskId||''); } });

      async function viewTicket(taskId, taskUid){ const p=new URLSearchParams(); if(taskId) p.append('task_id',taskId); if(taskUid) p.append('task_uid',taskUid); try{ const r=await fetch(TICKET_API_BASE+'/view',{ method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:p.toString() }); const t=await r.text(); const d=safeParseJson(t)||{}; const payload=d.data||d; if(payload.task_id||payload.task_uid||payload.id){ const title=payload.task_subject||payload.title||''; const num=payload.task_ticket_no||payload.ticket_number||''; const statusName=payload.task_status||payload.status_name||payload.status||''; const priorityName=payload.task_priority||payload.priority_name||''; const due=payload.task_due_date||payload.due_date||''; const desc=payload.task_description||payload.description||''; const content='<h4>'+title+'</h4><div class="row mt-3"><div class="col-md-6"><p><strong>Ticket Number:</strong> '+num+'</p><p><strong>Status:</strong> <span class="badge bg-'+getStatusClass(statusName)+'">'+statusName+'</span></p><p><strong>Priority:</strong> <span class="badge bg-'+getPriorityClass(payload.priority_level)+'">'+priorityName+'</span></p></div><div class="col-md-5"><p><strong>Due Date:</strong> '+formatDate(due)+'</p></div></div><div class="mt-3"><strong>Description:</strong><p class="mt-2">'+desc+'</p></div>'; document.getElementById('ticketDetailsContent').innerHTML=content; const statusEl=document.getElementById('view_meta_status'); const priorityEl=document.getElementById('view_meta_priority'); const assignedEl=document.getElementById('view_meta_assigned_to'); const createdByEl=document.getElementById('view_meta_created_by'); const dueDateEl=document.getElementById('view_meta_due_date'); if(statusEl){ statusEl.textContent=statusName||'N/A'; statusEl.className='badge bg-'+getStatusClass(statusName||''); } if(priorityEl){ priorityEl.textContent=priorityName||'N/A'; priorityEl.className='badge bg-'+getPriorityClass(payload.priority_level); } if(assignedEl) assignedEl.textContent=payload.task_assigned_to||payload.assigned_to_name||'Unassigned'; if(createdByEl) createdByEl.textContent=payload.created_by||'Unknown'; if(dueDateEl) dueDateEl.textContent=formatDate(due)||'N/A'; (new bootstrap.Modal(document.getElementById('viewTicketModal'))).show(); } else { showNotification((d && (d.message||d.error||d.status)) || 'Failed to load ticket','error'); } }catch(e){ console.error('viewTicket error', e); showNotification('Error loading ticket','error'); } }

      function openUpdateStatusModal(taskId){ document.getElementById('update_task_id').value = taskId; (new bootstrap.Modal(document.getElementById('updateStatusModal'))).show(); }
      async function loadStatuses(){ try{ const sel=document.getElementById('update_status_id'); if(!sel) return; let rows=[]; try{ const r1=await fetch(TICKET_API_BASE + '/statuses/list',{ method:'POST', headers:{'Content-Type':'application/json'}, body:'{}' }); const t1=await r1.text(); const d1=safeParseJson(t1)||{}; rows=Array.isArray(d1)?d1:(d1.statuses||d1.data||[]); }catch(e){ rows=[]; } if(!rows||!rows.length){ try{ const r2=await fetch(TICKET_API_BASE + '/statuses'); const t2=await r2.text(); const d2=safeParseJson(t2)||{}; rows=Array.isArray(d2)?d2:(d2.statuses||d2.data||[]); }catch(e){ rows=[]; } } sel.innerHTML='<option value="">Select Status</option>'+ (rows||[]).map(function(s){ const id=s.status_id||s.id||s.code||s.value||s.name; const name=s.name||s.label||s.code||String(id); return '<option value="'+id+'">'+name+'</option>'; }).join(''); }catch(_){} }
      async function submitStatusUpdate(){ const id=document.getElementById('update_task_id').value; const statusId=document.getElementById('update_status_id').value; const comment=document.getElementById('update_comment').value; if(!id||!statusId){ showNotification('Status and Ticket required','error'); return; } const p=new URLSearchParams(); p.append('task_id', id); p.append('status_id', statusId); if(comment) p.append('task_remarks', comment); try{ const r=await fetch(TICKET_API_BASE + '/update_tickets',{ method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:p.toString() }); const t=await r.text(); const d=safeParseJson(t)||{}; const ok = (d && (d.success===true || String(d.status||'').toLowerCase()==='success')) || r.ok; if(ok){ showNotification('Status updated','success'); (bootstrap.Modal.getInstance(document.getElementById('updateStatusModal'))||new bootstrap.Modal(document.getElementById('updateStatusModal'))).hide(); document.getElementById('updateStatusForm').reset(); loadAssignedTickets(); } else { showNotification((d.message||d.error||'Failed to update status'),'error'); } }catch(e){ console.error('submitStatusUpdate', e); showNotification('Error updating status','error'); } }

      document.addEventListener('click', function(e){ const s=e.target.closest('#submitUpdateStatus'); if(s){ submitStatusUpdate(); } });
      $('#updateStatusModal').on('shown.bs.modal', loadStatuses);
      loadAssignedTickets();
    });
  </script>

  <div class="modal fade" id="viewTicketModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl"><div class="modal-content modern-modal"><div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));"><div class="d-flex align-items-center gap-3"><div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.08), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);"><i class="bi bi-card-text text-primary fs-4"></i></div><div><h5 class="mb-0 fw-semibold">Ticket Details</h5><small class="text-muted">View the ticket and its activity</small></div></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div><div class="modal-body"><div class="row"><div class="col-md-8"><div class="card"><div class="card-header"><h6 class="card-title mb-0">Ticket Information</h6></div><div class="card-body"><div id="ticketDetailsContent"></div></div></div></div><div class="col-md-4"><div class="card"><div class="card-header"><h6 class="card-title mb-0">Summary</h6></div><div class="card-body"><p class="mb-2"><strong>Status: </strong> <span id="view_meta_status" class="badge bg-secondary">&nbsp;</span></p><p class="mb-2"><strong>Priority: </strong> <span id="view_meta_priority" class="badge bg-secondary">&nbsp;</span></p><p class="mb-2"><strong>Assigned To: </strong> <span id="view_meta_assigned_to" class="text-muted">&nbsp;</span></p><p class="mb-2"><strong>Created By: </strong> <span id="view_meta_created_by" class="text-muted">&nbsp;</span></p><p class="mb-0"><strong>Due Date: </strong> <span id="view_meta_due_date" class="text-muted">&nbsp;</span></p></div></div></div></div></div></div>
  </div>

  <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-md"><div class="modal-content modern-modal"><div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));"><div class="d-flex align-items-center gap-3"><div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.10), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);"><i class="bi bi-pencil text-primary fs-4"></i></div><div><h5 class="mb-0 fw-semibold">Update Status</h5><small class="text-muted">Set a new status with a comment</small></div></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div><div class="modal-body"><form id="updateStatusForm"><input type="hidden" id="update_task_id"><div class="mb-3"><label class="form-label">Status</label><select id="update_status_id" class="form-select"><option value="">Select Status</option></select></div><div class="mb-3"><label class="form-label">Comment</label><textarea id="update_comment" class="form-control" rows="3"></textarea></div></form></div><div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary" id="submitUpdateStatus">Update</button></div></div></div>
  </div>
</main>
