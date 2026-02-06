<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">My Profile</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">User Management</a></li>
            <li class="breadcrumb-item active" aria-current="page">Profile</li>
          </ol>
        </nav>
      </div>
    </div>

    <div class="row g-3">
      <div class="col-lg-4">
        <div class="card">
          <div class="card-body text-center">
            <img src="${pageContext.request.contextPath}/assets/images/users/user-1.png" alt="Avatar" class="rounded-circle profile-img mb-3" id="pf_avatar">
            <h5 class="fw-bold mb-1" id="pf_full_name">${userInfo.full_name}</h5>
            <p class="text-muted mb-2" id="pf_role">${userInfo.role}</p>
            <div class="d-flex justify-content-center gap-2">
              <span class="badge bg-success-subtle" id="pf_status">${userInfo.status}</span>
              <span class="badge bg-warning-subtle" id="pf_level">Level ${userInfo.level}</span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-8">
        <div class="card">
          <div class="card-header">
            <p class="mb-0">Account Information</p>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-6">
                <p class="mb-2"><strong>Username:</strong> <span class="text-muted float-end" id="pf_username">${userInfo.username}</span></p>
                <p class="mb-2"><strong>Email:</strong> <span class="text-muted float-end" id="pf_email">${userInfo.email}</span></p>
                <p class="mb-2"><strong>Phone:</strong> <span class="text-muted float-end" id="pf_phone">${userInfo.country_code} ${userInfo.phone_number}</span></p>
                <p class="mb-2"><strong>Gender:</strong> <span class="text-muted float-end" id="pf_gender">${userInfo.gender}</span></p>
              </div>
              <div class="col-md-6">
                <p class="mb-2"><strong>Status:</strong> <span class="badge bg-success-subtle float-end" id="pf_status_2">${userInfo.status}</span></p>
                <p class="mb-2"><strong>Title:</strong> <span class="text-muted float-end" id="pf_title">${userInfo.title}</span></p>
                <p class="mb-2"><strong>Organization:</strong> <span class="text-muted float-end" id="pf_org_id">${userInfo.org_name}</span></p>
                <p class="mb-2"><strong>Unique ID:</strong> <span class="text-muted float-end" id="pf_unique_id">${userInfo.unique_id}</span></p>
              </div>
            </div>
          </div>
        </div>
        <div class="card mt-3">
          <div class="card-header">
            <p class="mb-0">Address</p>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-6">
                <p class="mb-2"><strong>Address:</strong> <span class="text-muted float-end" id="pf_address">${userInfo.address}</span></p>
                <p class="mb-2"><strong>City:</strong> <span class="text-muted float-end" id="pf_city">${userInfo.city}</span></p>
                <p class="mb-2"><strong>Zip Code:</strong> <span class="text-muted float-end" id="pf_zip">${userInfo.zip_code}</span></p>
              </div>
              <div class="col-md-6">
                <p class="mb-2"><strong>Country:</strong> <span class="text-muted float-end" id="pf_country">${userInfo.country}</span></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>
        <div class="card mt-3">
          <div class="card-header">
            <p class="mb-0">Organization</p>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-6">
                <p class="mb-2"><strong>Name:</strong> <span class="text-muted float-end" id="pf_org_name"></span></p>
                <p class="mb-2"><strong>Code:</strong> <span class="text-muted float-end" id="pf_org_code"></span></p>
                <p class="mb-2"><strong>Status:</strong> <span class="badge bg-success-subtle float-end" id="pf_org_status"></span></p>
              </div>
              <div class="col-md-6">
                <p class="mb-2"><strong>Subscription:</strong> <span class="text-muted float-end" id="pf_org_sub_type"></span></p>
                <p class="mb-2"><strong>Start:</strong> <span class="text-muted float-end" id="pf_org_sub_start"></span></p>
                <p class="mb-2"><strong>End:</strong> <span class="text-muted float-end" id="pf_org_sub_end"></span></p>
              </div>
            </div>
          </div>
        </div>
<script>
  (function(){
    const PROFILE_API = '${pageContext.request.contextPath}/api/users/profile';
    function set(id, val){ const el=document.getElementById(id); if(el) el.textContent = val==null? '': String(val); }
    function setBadge(id, val){ const el=document.getElementById(id); if(!el) return; const v=String(val||''); el.textContent = v; const isActive = v.toLowerCase()==='active'; el.className = isActive ? 'badge bg-success-subtle float-end' : 'badge bg-danger-subtle float-end'; }
    function fmtDate(d){ if(!d) return ''; try{ const dt=new Date(d); if(!isNaN(dt.getTime())) return dt.toLocaleDateString(); }catch(_){ } return String(d||''); }
    const qp = new URLSearchParams(window.location.search); const qId = qp.get('user_id');
    const sessionId = '${userInfo.id}';
    const payload = (function(){ const p={}; if(qId){ const n=parseInt(qId,10); if(!isNaN(n)) p.user_id=n; } else if(sessionId){ const n=parseInt(sessionId,10); if(!isNaN(n)) p.user_id=n; } return p; })();
    withLoader(fetch(PROFILE_API, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload) }))
      .then(r=>r.text())
      .then(t=>{ let data; try{ data=JSON.parse(t); }catch(_){ data=null; }
        let profile = null;
        if (data && typeof data==='object') {
          profile = data.profile || data.data || data.user || data.result || data;
          if (data.success===false && data.message) return;
        }
        if(!profile) return;
        set('pf_full_name', profile.full_name||profile.name);
        set('pf_role', profile.role);
        setBadge('pf_status', profile.status);
        setBadge('pf_status_2', profile.status);
        set('pf_level', 'Level ' + (profile.level||''));
        set('pf_username', profile.username);
        set('pf_email', profile.email);
        set('pf_phone', (profile.country_code?profile.country_code+' ':'') + (profile.phone_number||''));
        set('pf_gender', profile.gender);
        set('pf_title', profile.title);
        const org = profile.organization || {};
        const orgName = org.org_name || org.name || profile.org_name || '';
        const orgCode = org.org_code || org.code || profile.org_code || '';
        set('pf_org_id', orgName);
        set('pf_unique_id', profile.unique_id);
        set('pf_address', profile.address);
        set('pf_city', profile.city);
        set('pf_zip', profile.zip_code);
        set('pf_country', profile.country);
        set('pf_nationality', profile.nationality);
        set('pf_org_name', orgName);
        set('pf_org_code', orgCode);
        setBadge('pf_org_status', org.status||'');
        set('pf_org_sub_type', org.subscription_type||'');
        set('pf_org_sub_start', fmtDate(org.subscription_start_date));
        set('pf_org_sub_end', fmtDate(org.subscription_end_date));
      })
      .catch(()=>{});
  })();
</script>
