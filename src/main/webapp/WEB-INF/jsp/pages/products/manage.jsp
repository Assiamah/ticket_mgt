<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Products</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Management</a></li>
            <li class="breadcrumb-item active" aria-current="page">Products</li>
          </ol>
        </nav>
      </div>
    </div>

    <div class="card">
      <div class="card-header d-flex align-items-center justify-content-between">
        <p class="text-muted mb-0">Manage products: view and add platform products.</p>
        <button class="btn btn-primary" id="btnAddProduct"><i class="ri-price-tag-3-line me-2"></i>Add Product</button>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="products-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Name</th>
                <th>Code</th>
                <th>Status</th>
                <th>Organizations</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Add Product</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form id="addProductForm">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Name</label>
                <input class="form-control" id="product_name" required />
              </div>
              <div class="col-md-6">
                <label class="form-label">Code</label>
                <input class="form-control" id="product_code" required />
              </div>
              <div class="col-md-12">
                <label class="form-label">Description</label>
                <textarea class="form-control" id="product_description" rows="3"></textarea>
              </div>
              <div class="col-md-6">
                <label class="form-label">Version</label>
                <input class="form-control" id="product_version" />
              </div>
              <div class="col-md-6">
                <label class="form-label">Documentation URL</label>
                <input class="form-control" id="documentation_url" />
              </div>
              <div class="col-md-12 d-flex align-items-center pt-2">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" id="prod_is_active" checked />
                  <label class="form-check-label" for="prod_is_active">Active</label>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-primary" id="submitAddProduct">Create</button>
        </div>
      </div>
    </div>
  </div>

  <script>
    const PRODUCTS_API = '${pageContext.request.contextPath}/api/products';
    function safeParseJson(text){ try{ return JSON.parse(text); }catch(_){ return null; } }
    function showToast(msg, type='success'){ Toastify({ text: msg, duration: 3000, close: true, gravity: 'top', position: 'right', backgroundColor: type==='success' ? '#28a745' : type==='error' ? '#dc3545' : '#17a2b8' }).showToast(); }
    function setSubmitting(flag){ const btn=document.getElementById('submitAddProduct'); if(!btn) return; btn.disabled=flag; btn.innerHTML = flag ? '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Creating...' : 'Create'; }
    function validateProductForm(){ const name=document.getElementById('product_name').value.trim(); const code=document.getElementById('product_code').value.trim(); if(!name || !code){ showToast('Name and Code are required','error'); return false; } return true; }
    function loadProducts(){
      const table = $('#products-datatable').DataTable({ destroy:true, data:[], columns:[
        { data:'name', defaultContent:'' },
        { data:'code', defaultContent:'' },
        { data:'status', defaultContent:'', render:function(d){ const s=String(d||'').toLowerCase(); return s==='active'? '<span class="badge bg-success-subtle">Active</span>' : '<span class="badge bg-danger-subtle">Inactive</span>'; }},
        { data:'org_count', defaultContent:'0' }
      ]});
      fetch(PRODUCTS_API).then(r=>r.text()).then(t=>{
        const data = safeParseJson(t) || {};
        const rows = Array.isArray(data) ? data : (data.products || data.data || []);
        const normalized = rows.map(function(row){ return {
          id: row.product_id || row.id,
          name: row.product_name || row.name || '',
          code: row.product_code || row.code || '',
          status: row.status || (row.is_active===true?'active':'inactive'),
          org_count: (Array.isArray(row.organizations)? row.organizations.length : (row.org_count||0))
        }; });
        table.clear(); table.rows.add(normalized); table.draw();
      }).catch(function(){ /* ignore */ });
    }
    function submitAddProduct(){ if(!validateProductForm()) return; const payload = { product_name: document.getElementById('product_name').value, product_code: document.getElementById('product_code').value, product_description: document.getElementById('product_description').value, product_version: document.getElementById('product_version').value, documentation_url: document.getElementById('documentation_url').value, is_active: document.getElementById('prod_is_active').checked }; setSubmitting(true); withLoader(fetch(PRODUCTS_API, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)}).then(async r=>{ const text=await r.text(); const result=safeParseJson(text)||{}; if(r.ok){ showToast(result.message||'Product created'); document.getElementById('addProductForm').reset(); (function(){ const el=document.getElementById('addProductModal'); const m=bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el); m.hide(); })(); loadProducts(); } else { showToast(result.message||text,'error'); } })).finally(()=> setSubmitting(false)); }
    document.addEventListener('DOMContentLoaded', function(){ loadProducts(); const btn=document.getElementById('btnAddProduct'); if(btn){ btn.addEventListener('click', function(){ const m = new bootstrap.Modal(document.getElementById('addProductModal')); m.show(); }); } const submitBtn=document.getElementById('submitAddProduct'); if(submitBtn){ submitBtn.addEventListener('click', submitAddProduct); } const form=document.getElementById('addProductForm'); if(form){ form.addEventListener('submit', function(e){ e.preventDefault(); submitAddProduct(); }); } });
  </script>
</main>
