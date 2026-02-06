<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Knowledge Base</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Tickets</a></li>
            <li class="breadcrumb-item active" aria-current="page">Knowledge Base</li>
          </ol>
        </nav>
      </div>
    </div>

    <div class="card mb-3">
      <div class="card-body">
        <div class="input-group">
          <span class="input-group-text"><i class="ri-search-line"></i></span>
          <input type="text" class="form-control" id="kbSearch" placeholder="Search solutions, keywords, or ticket numbers...">
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header"><h6 class="mb-0">Articles from archived tickets</h6></div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="kb-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Ticket #</th>
                <th>Title</th>
                <th>Solution Summary</th>
                <th>Tags</th>
                <th>Archived</th>
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
      const table = $('#kb-datatable').DataTable({
        columns: [
          { data: 'task_ticket_no' },
          { data: 'task_subject' },
          { data: 'solution_summary' },
          { data: 'tags' },
          { data: 'archived_at', render: function(d){ return formatDate(d || ''); } }
        ]
      });
      function formatDate(dateString) { if (!dateString) return 'N/A'; const date = new Date(dateString); return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' }); }
      async function loadKB() {
        const params = new URLSearchParams(); params.append('task_status', 'Archived');
        const resp = await fetch(TICKET_API_BASE + '/load', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params.toString() });
        const text = await resp.text(); const data = safeParseJson(text) || {}; const rows = (data.tickets || data.data || []).map(r => ({
          task_ticket_no: r.task_ticket_no,
          task_subject: r.task_subject,
          solution_summary: r.solution || r.task_remarks || '',
          tags: (r.task_type || '') + (r.task_priority ? ', ' + r.task_priority : ''),
          archived_at: r.modified_by_date || r.created_date
        }));
        table.clear(); table.rows.add(rows); table.draw();
      }
      document.getElementById('kbSearch').addEventListener('input', function(e){ table.search(e.target.value).draw(); });
      loadKB();
    });
  </script>
</main>
