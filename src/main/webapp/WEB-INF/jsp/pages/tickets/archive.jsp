<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Archived Tickets</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Tickets</a></li>
            <li class="breadcrumb-item active" aria-current="page">Archive</li>
          </ol>
        </nav>
      </div>
    </div>

    <div class="row g-3 mb-3">
      <div class="col-md-3">
        <label class="form-label">From</label>
        <input type="date" class="form-control" id="filter_from">
      </div>
      <div class="col-md-3">
        <label class="form-label">To</label>
        <input type="date" class="form-control" id="filter_to">
      </div>
      <div class="col-md-6 d-flex align-items-end gap-2">
        <button class="btn btn-primary" id="applyFilters"><i class="ri-filter-3-line"></i> Apply Filters</button>
        <button class="btn btn-outline-secondary" id="clearFilters"><i class="ri-close-line"></i> Clear</button>
      </div>
    </div>

    <div class="card">
      <div class="card-body">
        <div class="table-responsive">
          <table id="archive-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Ticket #</th>
                <th>Title</th>
                <th>Priority</th>
                <th>Status</th>
                <th>Assigned To</th>
                <th>Archived Date</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const TICKET_API_BASE = '${pageContext.request.contextPath}/api/tickets';
      function safeParseJson(text) { try { return JSON.parse(text); } catch (_) { return null; } }
      function showNotification(message, type = 'success') { Toastify({ text: message, duration: 3000, close: true, gravity: 'top', position: 'right', backgroundColor: type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : type === 'warning' ? '#ffc107' : '#17a2b8' }).showToast(); }

      const table = $('#archive-datatable').DataTable({
        columns: [
          { data: 'task_ticket_no' },
          { data: 'task_subject' },
          { data: 'task_priority' },
          { data: 'task_status' },
          { data: 'task_assigned_to' },
          { data: 'archived_at', render: function(d){ return formatDate(d || ''); } },
          { data: null, orderable: false, className: 'text-end', render: function(_, __, row){ return `<button class="btn btn-sm btn-outline-primary btn-reopen" data-ticket-id="${row.task_uid || row.task_id}"><i class="ri-refresh-line"></i> Reopen</button>`; } }
        ]
      });

      function formatDate(dateString) { if (!dateString) return 'N/A'; const date = new Date(dateString); return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }); }

      async function loadArchive() {
        const params = new URLSearchParams();
        params.append('task_status', 'Archived');
        const from = document.getElementById('filter_from').value;
        const to = document.getElementById('filter_to').value;
        if (from) params.append('created_from', from);
        if (to) params.append('created_to', to);
        try {
          console.group('loadArchive');
          const resp = await fetch(TICKET_API_BASE + '/load', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params.toString() });
          const text = await resp.text();
          const data = safeParseJson(text) || {};
          console.log('loadArchive response', text);
          const rows = data.tickets || data.data || data.items || data.rows || [];
          table.clear();
          table.rows.add(Array.isArray(rows) ? rows : []);
          table.draw();
          console.groupEnd();
        } catch (e) { console.error('loadArchive error', e); showNotification('Failed to load archive', 'error'); }
      }

      async function reopenTicket(ticketId) {
        try {
          console.group('reopenTicket');
          const resp = await fetch(TICKET_API_BASE + '/' + ticketId + '/reopen', { method: 'POST' });
          const text = await resp.text();
          const result = safeParseJson(text) || {};
          console.log('reopenTicket response', text);
          if ((result && (result.success === true || result.status === 'Success')) || resp.ok) {
            showNotification('Ticket reopened', 'success');
            loadArchive();
          } else {
            showNotification((result.message || result.error || 'Failed to reopen'), 'error');
          }
          console.groupEnd();
        } catch (e) { console.error('reopenTicket error', e); showNotification('Error reopening ticket', 'error'); }
      }

      document.addEventListener('click', function(e){ const btn = e.target.closest('.btn-reopen'); if (btn){ reopenTicket(btn.dataset.ticketId); } });
      document.getElementById('applyFilters').addEventListener('click', loadArchive);
      document.getElementById('clearFilters').addEventListener('click', () => { document.getElementById('filter_from').value=''; document.getElementById('filter_to').value=''; loadArchive(); });
      loadArchive();
    });
  </script>
</main>
