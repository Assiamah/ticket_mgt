<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Categories</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Tickets</a></li>
            <li class="breadcrumb-item active" aria-current="page">Categories</li>
          </ol>
        </nav>
      </div>
    </div>
    <div class="card mt-4">
      <div class="card-header d-flex align-items-center justify-content-between">
        <p class="text-muted mb-0">Manage ticket statuses</p>
        <button class="btn btn-primary" id="btnAddStatus"><i class="ri-list-check-2 me-2"></i>Add Status</button>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="statuses-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Name</th>
                <th>Usage</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header d-flex align-items-center justify-content-between">
        <p class="text-muted mb-0">Manage ticket categories</p>
        <button class="btn btn-primary" id="btnAddCategory"><i class="ri-list-check-2 me-2"></i>Add Category</button>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="categories-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Name</th>
                <th>Usage</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
      </div>
    </div>
    </div>
    <div class="card mt-4">
      <div class="card-header d-flex align-items-center justify-content-between">
        <p class="text-muted mb-0">Manage ticket priorities</p>
        <button class="btn btn-primary" id="btnAddPriority"><i class="ri-list-check-2 me-2"></i>Add Priority</button>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="priorities-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Name</th>
                <th>Usage</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-md modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Add Category</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form id="addCategoryForm">
              <div class="mb-3">
                <label class="form-label">Name</label>
                <input class="form-control" id="category_name" required />
              </div>
              
              <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" id="category_description" rows="3"></textarea>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary" id="submitAddCategory">Create</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    const TICKET_API = '${pageContext.request.contextPath}/api/tickets';
    function safeParseJson(text){ try{ return JSON.parse(text);}catch(_){ return null; } }
    function showToast(msg, type='success'){ Toastify({ text: msg, duration: 3000, close: true, gravity: 'top', position: 'right', backgroundColor: type==='success' ? '#28a745' : type==='error' ? '#dc3545' : '#17a2b8' }).showToast(); }
    function setSubmitting(flag){ const btn=document.getElementById('submitAddCategory'); if(!btn) return; btn.disabled=flag; btn.innerHTML = flag ? '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Creating...' : 'Create'; }
    function initCategoriesTable(){ const table = $('#categories-datatable').DataTable({ destroy:true, data:[], columns:[ { data:'name', defaultContent:'' }, { data:'ticket_count', defaultContent:0 }, { data:null, orderable:false, render:function(row){ const disabled = Number(row.ticket_count||0) > 0 ? 'disabled' : ''; return '<button class="btn btn-sm btn-danger btn-delete-category" data-id="'+(row.category_id||row.id||'')+'" '+disabled+'>Delete</button>'; } } ]}); return table; }
    function initPrioritiesTable(){ const table = $('#priorities-datatable').DataTable({ destroy:true, data:[], columns:[ { data:'name', defaultContent:'' }, { data:'ticket_count', defaultContent:0 }, { data:null, orderable:false, render:function(row){ const disabled = Number(row.ticket_count||0) > 0 ? 'disabled' : ''; return '<button class="btn btn-sm btn-danger btn-delete-priority" data-id="'+(row.priority_id||row.id||'')+'" '+disabled+'>Delete</button>'; } } ]}); return table; }
    function initStatusesTable(){ const table = $('#statuses-datatable').DataTable({ destroy:true, data:[], columns:[ { data:'name', defaultContent:'' }, { data:'ticket_count', defaultContent:0 }, { data:null, orderable:false, render:function(row){ const disabled = Number(row.ticket_count||0) > 0 ? 'disabled' : ''; return '<button class="btn btn-sm btn-danger btn-delete-status" data-id="'+(row.status_id||row.id||'')+'" '+disabled+'>Delete</button>'; } } ]}); return table; }
    async function loadCategories(){ try{ console.group('loadCategories'); const resp = await fetch(TICKET_API + '/categories/list', { method:'POST', headers:{'Content-Type':'application/json'}, body: '{}' }); const text=await resp.text(); const d=safeParseJson(text)||{}; console.log('loadCategories response', text); const rows = Array.isArray(d) ? d : (d.categories || d.data || []); const table = $('#categories-datatable').DataTable(); table.clear().rows.add(rows).draw(); console.groupEnd(); } catch(e){ console.error('loadCategories error',e); } }
    async function loadPriorities(){ try{ console.group('loadPriorities'); const resp = await fetch(TICKET_API + '/priorities/list', { method:'POST', headers:{'Content-Type':'application/json'}, body: '{}' }); const text=await resp.text(); const d=safeParseJson(text)||{}; console.log('loadPriorities response', text); const rows = Array.isArray(d) ? d : (d.priorities || d.data || []); const table = $('#priorities-datatable').DataTable(); table.clear().rows.add(rows).draw(); console.groupEnd(); } catch(e){ console.error('loadPriorities error',e); } }
    async function loadStatusesMgt(){ try{ console.group('loadStatusesMgt'); const resp = await fetch(TICKET_API + '/statuses/list', { method:'POST', headers:{'Content-Type':'application/json'}, body: '{}' }); const text=await resp.text(); const d=safeParseJson(text)||{}; console.log('loadStatusesMgt response', text); const rows = Array.isArray(d) ? d : (d.statuses || d.data || []); const table = $('#statuses-datatable').DataTable(); table.clear().rows.add(rows).draw(); console.groupEnd(); } catch(e){ console.error('loadStatusesMgt error',e); } }
    async function submitAddCategory(){ const name=document.getElementById('category_name').value.trim(); if(!name){ showToast('Name is required','error'); return; } const payload = { name: name, description: document.getElementById('category_description').value }; setSubmitting(true); try{ console.group('submitAddCategory'); const resp = await fetch(TICKET_API + '/categories/add', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }); const text=await resp.text(); const result=safeParseJson(text)||{}; console.log('submitAddCategory response', text); if(resp.ok){ showToast(result.message||'Category created'); document.getElementById('addCategoryForm').reset(); (function(){ const el=document.getElementById('addCategoryModal'); const m=bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el); m.hide(); })(); loadCategories(); } else { showToast(result.message||text,'error'); } console.groupEnd(); } catch(e){ console.error('submitAddCategory error',e); showToast('Error creating category','error'); } finally { setSubmitting(false); } }
    async function submitAddPriority(){ const name = prompt('Priority name'); if(!name) return; try{ const resp = await fetch(TICKET_API + '/priorities/add', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ name }) }); const text=await resp.text(); const result=safeParseJson(text)||{}; if(resp.ok){ showToast(result.message||'Priority created'); loadPriorities(); } else { showToast(result.message||text,'error'); } } catch(e){ showToast('Error creating priority','error'); } }
    async function deleteCategory(id){ if(!id) return; if(!confirm('Delete this category?')) return; try{ const resp = await fetch(TICKET_API + '/categories/delete', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ category_id: id }) }); const text=await resp.text(); const result=safeParseJson(text)||{}; if(resp.ok){ showToast(result.message||'Category deleted'); loadCategories(); } else { showToast(result.message||text,'error'); } } catch(e){ showToast('Error deleting category','error'); } }
    async function deletePriority(id){ if(!id) return; if(!confirm('Delete this priority?')) return; try{ const resp = await fetch(TICKET_API + '/priorities/delete', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ priority_id: id }) }); const text=await resp.text(); const result=safeParseJson(text)||{}; if(resp.ok){ showToast(result.message||'Priority deleted'); loadPriorities(); } else { showToast(result.message||text,'error'); } } catch(e){ showToast('Error deleting priority','error'); } }
    async function deleteStatus(id){ if(!id) return; if(!confirm('Delete this status?')) return; try{ const resp = await fetch(TICKET_API + '/statuses/delete', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ status_id: id }) }); const text=await resp.text(); const result=safeParseJson(text)||{}; if(resp.ok){ showToast(result.message||'Status deleted'); loadStatusesMgt(); } else { showToast(result.message||text,'error'); } } catch(e){ showToast('Error deleting status','error'); } }
    async function submitAddStatus(){ const name = prompt('Status name'); if(!name) return; try{ const resp = await fetch(TICKET_API + '/statuses/add', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ name }) }); const text=await resp.text(); const result=safeParseJson(text)||{}; if(resp.ok){ showToast(result.message||'Status created'); loadStatusesMgt(); } else { showToast(result.message||text,'error'); } } catch(e){ showToast('Error creating status','error'); } }
    document.addEventListener('DOMContentLoaded', function(){ const catTable=initCategoriesTable(); const priTable=initPrioritiesTable(); const statTable=initStatusesTable(); loadCategories(); loadPriorities(); loadStatusesMgt(); document.getElementById('btnAddCategory').addEventListener('click', function(){ const m = new bootstrap.Modal(document.getElementById('addCategoryModal')); m.show(); }); document.getElementById('submitAddCategory').addEventListener('click', submitAddCategory); document.getElementById('btnAddPriority').addEventListener('click', submitAddPriority); document.getElementById('btnAddStatus').addEventListener('click', submitAddStatus); $('#categories-datatable').on('click', '.btn-delete-category', function(){ deleteCategory(this.dataset.id); }); $('#priorities-datatable').on('click', '.btn-delete-priority', function(){ deletePriority(this.dataset.id); }); $('#statuses-datatable').on('click', '.btn-delete-status', function(){ deleteStatus(this.dataset.id); }); });
  </script>
</main>
