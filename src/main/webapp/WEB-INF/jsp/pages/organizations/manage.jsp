<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Organizations</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Management</a></li>
            <li class="breadcrumb-item active" aria-current="page">Organizations</li>
          </ol>
        </nav>
      </div>
    </div>

    <div class="row g-3 mb-2">
      <div class="col-md-4">
        <div class="card">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted">Total</div>
              <div class="fs-4 fw-semibold" id="org_total">0</div>
            </div>
            <i class="ri-community-line fs-3 text-primary"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted">Active</div>
              <div class="fs-4 fw-semibold text-success" id="org_active">0</div>
            </div>
            <i class="ri-shield-check-line fs-3 text-success"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted">Blocked</div>
              <div class="fs-4 fw-semibold text-danger" id="org_blocked">0</div>
            </div>
            <i class="ri-forbid-line fs-3 text-danger"></i>
          </div>
        </div>
      </div>
    </div>

    <div class="card">
      <div class="card-header d-flex align-items-center justify-content-between">
        <p class="text-muted mb-0">Manage organizations: view, add, and block/unblock institutions.</p>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addOrgModal"><i class="ri-building-2-line me-2"></i>Add Organization</button>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="orgs-datatable" class="table table-striped dt-responsive w-100">
            <thead>
              <tr>
                <th>Name</th>
                <th>Code</th>
                <th>Country</th>
                <th>Status</th>
                <th>Created</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="addOrgModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Add Organization</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
  <form id="addOrgForm">
    <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Name</label>
                <input class="form-control" id="org_name" required />
              </div>
              <div class="col-md-6">
                <label class="form-label">Code</label>
                <input class="form-control" id="org_code" required />
              </div>
              <div class="col-md-6">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" id="org_email" />
              </div>
              <div class="col-md-6">
                <label class="form-label">Phone</label>
                <input class="form-control" id="org_phone" />
              </div>
              <div class="col-md-6">
                <label class="form-label">Address</label>
                <input class="form-control" id="org_address" />
              </div>
              <div class="col-md-6">
                <label class="form-label">City</label>
                <input class="form-control" id="org_city" />
              </div>
              <div class="col-md-6">
                <label class="form-label">Country</label>
                <input class="form-control" id="org_country" />
              </div>
              <div class="col-md-6">
                <label class="form-label">Subscription Type</label>
                <select class="form-select" id="subscription_type">
                  <option value="">Select</option>
                  <option value="standard">Standard</option>
                  <option value="premium">Premium</option>
                  <option value="enterprise">Enterprise</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">Subscription Start Date</label>
                <input type="datetime-local" class="form-control" id="subscription_start_date" required />
              </div>
              <div class="col-md-6">
                <label class="form-label">Subscription End Date</label>
                <input type="datetime-local" class="form-control" id="subscription_end_date" />
              </div>
      <div class="col-md-6 d-flex align-items-center pt-4">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="is_system_owner" />
          <label class="form-check-label" for="is_system_owner">System Owner</label>
        </div>
      </div>
              <div class="col-md-12">
                <label class="form-label">Products</label>
                <select class="form-select" id="org_products"></select>
                <div class="form-text">Select a product</div>
              </div>
    </div>
  </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="button" class="btn btn-primary" id="submitAddOrg">Create</button>
        </div>
      </div>
    </div>
  </div>

  <div class="modal fade" id="viewOrgModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Organization Details</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">Name</label><div class="form-control" id="v_org_name" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Code</label><div class="form-control" id="v_org_code" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Email</label><div class="form-control" id="v_org_email" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Phone</label><div class="form-control" id="v_org_phone" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Address</label><div class="form-control" id="v_org_address" readonly></div></div>
            <div class="col-md-6"><label class="form-label">City</label><div class="form-control" id="v_org_city" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Country</label><div class="form-control" id="v_org_country" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Status</label><div class="form-control" id="v_status" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Subscription Type</label><div class="form-control" id="v_subscription_type" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Subscription Start</label><div class="form-control" id="v_subscription_start_date" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Subscription End</label><div class="form-control" id="v_subscription_end_date" readonly></div></div>
            <div class="col-md-6"><label class="form-label">System Owner</label><div class="form-control" id="v_is_system_owner" readonly></div></div>
            <div class="col-md-6"><label class="form-label">Created</label><div class="form-control" id="v_created_date" readonly></div></div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <script>
    const ORG_API = '${pageContext.request.contextPath}/api/organizations';
    const PRODUCTS_API = '${pageContext.request.contextPath}/api/products';
    function safeParseJson(text) { try { return JSON.parse(text); } catch (_) { return null; } }
    function showToast(msg, type='success'){ Toastify({ text: msg, duration: 3000, close: true, gravity: 'top', position: 'right', backgroundColor: type==='success' ? '#28a745' : type==='error' ? '#dc3545' : '#17a2b8' }).showToast(); }
    function parseDate(d){ if(!d) return null; if(typeof d==='number') { const nd=new Date(d); return isNaN(nd.getTime())?null:nd; } if(typeof d==='string'){ const s=d.trim(); if(/^\d{4}-\d{2}-\d{2}T/.test(s)) { const nd=new Date(s); return isNaN(nd.getTime())?null:nd; } if(/^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}(:\d{2})?$/.test(s)) { const nd=new Date(s.replace(' ','T')); return isNaN(nd.getTime())?null:nd; } if(/^\d{4}-\d{2}-\d{2}$/.test(s)) { const nd=new Date(s+'T00:00:00'); return isNaN(nd.getTime())?null:nd; } }
      try{ const nd=new Date(d); return isNaN(nd.getTime())?null:nd; }catch(_){ return null; } }
    function formatDateTime(d){ const dt=parseDate(d); return dt ? dt.toLocaleString('en-US', { year:'numeric', month:'short', day:'numeric', hour:'2-digit', minute:'2-digit' }) : '—'; }
    function toDateTimeLocalValue(date){ const pad = (n) => String(n).padStart(2,'0'); const y=date.getFullYear(); const m=pad(date.getMonth()+1); const d=pad(date.getDate()); const hh=pad(date.getHours()); const mm=pad(date.getMinutes()); return `${y}-${m}-${d}T${hh}:${mm}`; }
    function formatForApiTimestamp(dateOrString){ const dt = typeof dateOrString==='string' ? parseDate(dateOrString) : dateOrString; if(!dt) return ''; const pad = (n) => String(n).padStart(2,'0'); const y=dt.getFullYear(); const m=pad(dt.getMonth()+1); const d=pad(dt.getDate()); const hh=pad(dt.getHours()); const mm=pad(dt.getMinutes()); const ss=pad(dt.getSeconds()); return `${y}-${m}-${d} ${hh}:${mm}:${ss}`; }
    function formatForApiDate(dateOrString){
      if(typeof dateOrString==='string'){
        const s=dateOrString.trim();
        if(!s) return '';
        if(s.includes('T')) return s.split('T')[0];
        if(/^\d{4}-\d{2}-\d{2}/.test(s)) return s.slice(0,10);
      }
      const dt = typeof dateOrString==='string' ? parseDate(dateOrString) : dateOrString;
      if(!dt) return '';
      const pad = (n) => String(n).padStart(2,'0');
      const y=dt.getFullYear(); const m=pad(dt.getMonth()+1); const d=pad(dt.getDate());
      return `${y}-${m}-${d}`;
    }

    let orgTable;
    let orgRows = [];
    let currentEditOrgId = null;
    function setSubmitting(flag){ const btn=document.getElementById('submitAddOrg'); if(!btn) return; btn.disabled=flag; btn.innerHTML = flag ? '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>' + (currentEditOrgId ? 'Updating...' : 'Creating...') : (currentEditOrgId ? 'Update' : 'Create'); }
    function validateOrgForm(){
      const name = document.getElementById('org_name').value.trim();
      const code = document.getElementById('org_code').value.trim();
      const startVal = document.getElementById('subscription_start_date').value;
      const prodSel = document.getElementById('org_products');
      if(!name || !code){ showToast('Name and Code are required','error'); return false; }
      const startDateOnly = formatForApiDate(startVal);
      if(!startDateOnly){ showToast('Subscription start date is invalid','error'); return false; }
      if(prodSel && !prodSel.value){ showToast('product_ids is required: select a product','error'); return false; }
      return true;
    }

    document.addEventListener('DOMContentLoaded', function(){
      orgTable = $('#orgs-datatable').DataTable({
        columns: [
          { data: 'name', defaultContent: '' },
          { data: 'code', defaultContent: '' },
          { data: 'country', defaultContent: '' },
          { data: 'status', defaultContent: '', render: function(d){ const s=String(d||'').toLowerCase(); return s==='active' ? '<span class="badge bg-success-subtle">Active</span>' : '<span class="badge bg-danger-subtle">Blocked</span>'; } },
          { data: 'created_date', defaultContent: '', render: function(d){ return formatDateTime(d); } },
          { data: null, orderable:false, className:'text-end', render:function(_,__,row){ const blocked = String(row.status||'').toLowerCase()!=='active'; return `
              <button class="btn btn-light-info icon-btn-sm btn-view" data-id="${row.org_id||row.id}"><i class="mdi mdi-eye"></i></button>
              <button class="btn btn-light-success icon-btn-sm btn-edit" data-id="${row.org_id||row.id}"><i class="mdi mdi-pencil"></i></button>
              <button class="btn ${blocked?'btn-light-success':'btn-light-danger'} icon-btn-sm btn-toggle" data-id="${row.org_id||row.id}" data-blocked="${blocked}"><i class="${blocked?'mdi mdi-lock-open-variant':'mdi mdi-lock'}"></i></button>
            `; } }
        ]
      });

      loadOrgs();
      const startInputEl = document.getElementById('subscription_start_date'); if(startInputEl){ startInputEl.value = toDateTimeLocalValue(new Date()); }
      const submitBtn = document.getElementById('submitAddOrg'); if(submitBtn){ submitBtn.addEventListener('click', submitAddOrUpdate); }
      const addTriggerBtn = document.querySelector('[data-bs-target="#addOrgModal"]'); if(addTriggerBtn){ addTriggerBtn.addEventListener('click', function(){ currentEditOrgId = null; const btn=document.getElementById('submitAddOrg'); if(btn){ btn.disabled=false; btn.textContent='Create'; } }); }
      const addForm = document.getElementById('addOrgForm'); if(addForm){ addForm.addEventListener('submit', function(e){ e.preventDefault(); submitAddOrUpdate(); }); }
      loadProductsForSelect();
      // Table action buttons (delegated)
      $('#orgs-datatable tbody').on('click', '.btn-edit', function(e){
        e.preventDefault(); e.stopPropagation();
        const id = $(this).data('id');
        const row = orgRows.find(function(r){ return String(r.id)===String(id) || String(r.org_id||'')===String(id); });
        if(row){ openEditOrgModal(row); }
      });
      $('#orgs-datatable tbody').on('click', '.btn-view', function(e){
        e.preventDefault(); e.stopPropagation();
        const id = $(this).data('id');
        const row = orgRows.find(function(r){ return String(r.id)===String(id) || String(r.org_id||'')===String(id); });
        if(row){ openViewOrgModal(row); }
      });
      $('#orgs-datatable tbody').on('click', '.btn-toggle', function(e){
        e.preventDefault(); e.stopPropagation();
        const id = $(this).data('id');
        const blocked = $(this).data('blocked')===true || String($(this).data('blocked')).toLowerCase()==='true';
        toggleOrg(id, blocked);
      });
      // Fallback global handlers
      document.addEventListener('click', function(e){ const btn=e.target.closest('.btn-toggle'); if(btn){ toggleOrg(btn.dataset.id, btn.dataset.blocked==='true'); }});
      $('#orgs-datatable tbody').on('click','tr', function(e){
        if ($(e.target).closest('.btn-edit, .btn-view, .btn-toggle').length) return;
        const data = orgTable.row(this).data();
        if (data) { openViewOrgModal(data); }
      });
      document.addEventListener('click', function(e){ const btn=e.target.closest('.btn-view'); if(btn){ const id=btn.getAttribute('data-id'); const row = orgRows.find(r => String(r.org_id||r.id)===String(id)); if(row){ openViewOrgModal(row); } }});
    });

    async function loadOrgs(){
      try{
        const resp = await fetch(ORG_API);
        const text = await resp.text();
        const data = safeParseJson(text) || {};
        const rows = Array.isArray(data) ? data : (data.organizations || data.data || []);
        orgRows = rows.map(function(row){
          return {
            id: row.org_id || row.id,
            name: row.name || row.org_name || '',
            code: row.code || row.org_code || '',
            country: row.country || row.org_country || '',
            status: (function(){
              const s = row.status || row.org_status;
              if (s) return s;
              const b1 = row.is_blocked; const b2 = row.blocked; const b3 = row.isBlocked;
              const boolish = (v) => v === true || String(v).toLowerCase()==='true' || v===1 || String(v)==='1';
              if (boolish(b1) || boolish(b2) || boolish(b3)) return 'blocked';
              return 'active';
            })(),
            created_date: (
              row.created_date || row.created_at || row.org_created_date ||
              row.createdDate || row.createdAt || row.created ||
              row.created_on || row.createdOn
            ),
            email: row.email || row.org_email,
            phone: row.phone || row.org_phone,
            address: row.address || row.org_address,
            city: row.city || row.org_city,
            subscription_type: row.subscription_type,
            subscription_start_date: row.subscription_start_date,
            subscription_end_date: row.subscription_end_date,
            is_system_owner: row.is_system_owner
          };
        });
        orgTable.clear(); orgTable.rows.add(orgRows); orgTable.draw();
        updateCounts();
      }catch(e){ console.error(e); showToast('Failed to load organizations','error'); }
    }

    function updateCounts(){
      const total = orgRows.length;
      const active = orgRows.filter(o => String(o.status||'').toLowerCase()==='active').length;
      const blocked = total - active;
      document.getElementById('org_total').textContent = total;
      document.getElementById('org_active').textContent = active;
      document.getElementById('org_blocked').textContent = blocked;
    }

    async function submitAddOrg(){
      if(!validateOrgForm()) return;
      const startVal = document.getElementById('subscription_start_date').value;
      const endVal = document.getElementById('subscription_end_date').value;
      const prodSel = document.getElementById('org_products');
      const payload = {
        org_name: document.getElementById('org_name').value,
        org_code: document.getElementById('org_code').value,
        org_email: document.getElementById('org_email').value,
        org_phone: document.getElementById('org_phone').value,
        org_address: document.getElementById('org_address').value,
        org_city: document.getElementById('org_city').value,
        org_country: document.getElementById('org_country').value,
        is_system_owner: document.getElementById('is_system_owner').checked,
        subscription_type: document.getElementById('subscription_type').value,
        subscription_start_date: formatForApiDate(startVal) || formatForApiDate(new Date()),
        subscription_end_date: endVal ? formatForApiDate(endVal) : null,
        product_ids: (function(){ const v = prodSel ? prodSel.value : ''; return v ? [v] : []; })()
      };
      if(!payload.subscription_end_date) payload.subscription_end_date = null;
      if(!payload.product_ids || payload.product_ids.length===0){ showToast('product_ids is required','error'); return; }
      try{
        const resp = await fetch(ORG_API, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)});
        const text = await resp.text(); const result = safeParseJson(text)||{};
        if(resp.ok){ showToast(result.message||'Organization created'); currentEditOrgId = null; document.getElementById('addOrgForm').reset(); (function(){ const el=document.getElementById('addOrgModal'); const m=bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el); m.hide(); })(); loadOrgs(); }
        else { showToast(result.message||text,'error'); }
      }catch(e){ console.error(e); showToast('Error creating organization','error'); }
    }

    async function toggleOrg(orgId, currentlyBlocked){
      try{
        const resp = await fetch(ORG_API + '/' + orgId + (currentlyBlocked? '/unblock' : '/block'), { method:'POST' });
        const text = await resp.text(); const result = safeParseJson(text)||{};
        if(resp.ok){ showToast(result.message|| (currentlyBlocked?'Unblocked':'Blocked') ); loadOrgs(); }
        else { showToast(result.message||text,'error'); }
      }catch(e){ console.error(e); showToast('Action failed','error'); }
    }

    function openViewOrgModal(row){
      const get = (k) => row[k]!==undefined && row[k]!==null ? String(row[k]) : '';
      const set = (id, val) => { const el=document.getElementById(id); if(el) el.textContent = val; };
      set('v_org_name', get('org_name') || get('name'));
      set('v_org_code', get('org_code') || get('code'));
      set('v_org_email', get('org_email') || get('email'));
      set('v_org_phone', get('org_phone') || get('phone'));
      set('v_org_address', get('org_address') || get('address'));
      set('v_org_city', get('org_city') || get('city'));
      set('v_org_country', get('org_country') || get('country'));
      set('v_status', get('status'));
      set('v_subscription_type', get('subscription_type'));
      set('v_subscription_start_date', get('subscription_start_date'));
      set('v_subscription_end_date', get('subscription_end_date'));
      set('v_is_system_owner', get('is_system_owner'));
      set('v_created_date', formatDateTime(get('created_date')));
      const modal = new bootstrap.Modal(document.getElementById('viewOrgModal'));
      modal.show();
    }

  function openEditOrgModal(row){
      try {
        const titleEl = document.querySelector('#addOrgModal .modal-title');
        if (titleEl) titleEl.textContent = 'Edit Organization';
        const btn=document.getElementById('submitAddOrg');
        if(btn){ btn.disabled=false; btn.textContent='Update'; }
        const formEl = document.getElementById('addOrgForm');
        if (formEl){
          const controls = formEl.querySelectorAll('input, select, textarea');
          controls.forEach(function(el){ el.readOnly = false; el.disabled = false; });
        }
      } catch(_){}
      const setVal = (id, val) => { const el=document.getElementById(id); if(el) el.value = val||''; };
      setVal('org_name', row.org_name || row.name);
      setVal('org_code', row.org_code || row.code);
      setVal('org_email', row.org_email || row.email);
      setVal('org_phone', row.org_phone || row.phone);
      setVal('org_address', row.org_address || row.address);
      setVal('org_city', row.org_city || row.city);
      setVal('org_country', row.org_country || row.country);
      setVal('subscription_type', row.subscription_type);
      const startInputEl = document.getElementById('subscription_start_date'); if(startInputEl){ const dt = parseDate(row.subscription_start_date); startInputEl.value = dt ? toDateTimeLocalValue(dt) : toDateTimeLocalValue(new Date()); }
      const endInputEl = document.getElementById('subscription_end_date'); if(endInputEl){ const dt = parseDate(row.subscription_end_date); endInputEl.value = dt ? toDateTimeLocalValue(dt) : ''; }
      const sysOwner = document.getElementById('is_system_owner'); if(sysOwner) sysOwner.checked = !!(row.is_system_owner === true || String(row.is_system_owner).toLowerCase()==='true');
      currentEditOrgId = row.org_id || row.id;
      const btn=document.getElementById('submitAddOrg'); if(btn){ btn.disabled=false; btn.textContent='Update'; }
      const prodSel = document.getElementById('org_products');
      if(prodSel){
        const ids = (function(){
          const prods = row.products || row.product_list || [];
          if(Array.isArray(prods)){
            const fromObj = prods.map(function(p){ return p.product_id || p.id; }).filter(Boolean);
            return row.product_ids || fromObj;
          }
          return row.product_ids || [];
        })();
        const firstId = Array.isArray(ids) && ids.length ? String(ids[0]) : '';
        if(firstId){ prodSel.value = firstId; }
      }
      const addModal = new bootstrap.Modal(document.getElementById('addOrgModal'));
      addModal.show();
  }

  function loadProductsForSelect(){
    const sel = document.getElementById('org_products'); if(!sel) return;
    fetch(PRODUCTS_API).then(r=>r.text()).then(t=>{ const data=safeParseJson(t)||{}; const rows=Array.isArray(data)?data:(data.products||data.data||[]); const options = rows.map(function(row){ const id=row.product_id||row.id; const name=row.product_name||row.name||''; return id? {id, name} : null; }).filter(Boolean); const current = sel.value; sel.innerHTML = '<option value="">Select</option>' + options.map(o=>'<option value="'+o.id+'">'+o.name+'</option>').join(''); if(current){ sel.value = current; } }).catch(function(){});
  }

  $('#addOrgModal').on('shown.bs.modal', function(){
    try { loadProductsForSelect(); } catch(_){}
  });

    async function submitAddOrUpdate(){
      const btn=document.getElementById('submitAddOrg'); if(btn && btn.disabled) return;
      setSubmitting(true);
      try{
        if (currentEditOrgId) { await submitUpdateOrg(currentEditOrgId); }
        else { await submitAddOrg(); }
      } finally {
        setSubmitting(false);
      }
    }



    async function submitUpdateOrg(orgId){
      if(!validateOrgForm()) return;
      const startVal = document.getElementById('subscription_start_date').value;
      const endVal = document.getElementById('subscription_end_date').value;
      const prodSelU = document.getElementById('org_products');
      const payload = {
        org_id: orgId,
        org_name: document.getElementById('org_name').value,
        org_code: document.getElementById('org_code').value,
        org_email: document.getElementById('org_email').value,
        org_phone: document.getElementById('org_phone').value,
        org_address: document.getElementById('org_address').value,
        org_city: document.getElementById('org_city').value,
        org_country: document.getElementById('org_country').value,
        is_system_owner: document.getElementById('is_system_owner').checked,
        subscription_type: document.getElementById('subscription_type').value,
        subscription_start_date: formatForApiDate(startVal) || formatForApiDate(new Date()),
        subscription_end_date: endVal ? formatForApiDate(endVal) : null,
        product_ids: (function(){ const v = prodSelU ? prodSelU.value : ''; return v ? [v] : []; })()
      };
      if(!payload.subscription_end_date) payload.subscription_end_date = null;
      if(!payload.product_ids || payload.product_ids.length===0){ showToast('product_ids is required','error'); return; }
      try{
        const resp = await fetch(ORG_API + '/' + orgId + '/update', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)});
        const text = await resp.text(); const result = safeParseJson(text)||{};
        if(resp.ok){ showToast(result.message||'Organization updated'); currentEditOrgId = null; document.getElementById('addOrgForm').reset(); (function(){ const el=document.getElementById('addOrgModal'); const m=bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el); m.hide(); })(); loadOrgs(); }
        else { showToast(result.message||text,'error'); }
      }catch(e){ console.error(e); showToast('Error updating organization','error'); }
    }
  </script>
</main>
    <!--  -->
