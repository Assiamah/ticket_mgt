<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
  <div class="container-fluid">
    <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
      <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Ticket Analytics</h2>
      <div class="flex-shrink-0">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb justify-content-end mb-0">
            <li class="breadcrumb-item"><a href="javascript:void(0)">Tickets</a></li>
            <li class="breadcrumb-item active" aria-current="page">Analytics</li>
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

    <div class="row g-3" id="analyticsCards">
      <div class="col-md-3">
        <div class="card">
          <div class="card-body">
            <h6 class="text-muted">Open</h6>
            <h3 class="mb-0" id="stat_open">0</h3>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card">
          <div class="card-body">
            <h6 class="text-muted">In Progress</h6>
            <h3 class="mb-0" id="stat_in_progress">0</h3>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card">
          <div class="card-body">
            <h6 class="text-muted">Resolved</h6>
            <h3 class="mb-0" id="stat_resolved">0</h3>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card">
          <div class="card-body">
            <h6 class="text-muted">Closed</h6>
            <h3 class="mb-0" id="stat_closed">0</h3>
          </div>
        </div>
      </div>
    </div>

    <div class="row mt-3">
      <div class="col-lg-9">
        <div class="card mb-3">
          <div class="card-header d-flex align-items-center justify-content-between">
            <h6 class="mb-0">Ticket Mix Overview</h6>
            <div class="d-flex align-items-center gap-2">
              <label class="form-label mb-0">Range</label>
              <select id="timeRange" class="form-select form-select-sm" style="width:auto">
                <option value="week">Week</option>
                <option value="month" selected>Month</option>
                <option value="year">Year</option>
                <option value="years">Years</option>
              </select>
            </div>
          </div>
          <div class="card-body">
            <canvas id="mixChart" height="240" style="width:100%"></canvas>
          </div>
        </div>
        <div class="card">
          <div class="card-header">
            <h6 class="mb-0">Tickets by Status</h6>
          </div>
          <div class="card-body">
            <canvas id="statusPieChart" height="200" style="width:100%"></canvas>
          </div>
        </div>
      </div>
      <div class="col-lg-3">
        <div class="card mb-3">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted">High</div>
              <div class="fs-5 fw-semibold text-danger" id="priority_high">0</div>
            </div>
            <i class="ri-alarm-warning-line text-danger"></i>
          </div>
        </div>
        <div class="card mb-3">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted">Medium</div>
              <div class="fs-5 fw-semibold text-warning" id="priority_medium">0</div>
            </div>
            <i class="ri-time-line text-warning"></i>
          </div>
        </div>
        <div class="card mb-3">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted">Low</div>
              <div class="fs-5 fw-semibold text-success" id="priority_low">0</div>
            </div>
            <i class="ri-leaf-line text-success"></i>
          </div>
        </div>
        <div class="card">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted">Critical</div>
              <div class="fs-5 fw-semibold text-danger" id="priority_critical">0</div>
            </div>
            <i class="ri-flashlight-line text-danger"></i>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const TICKET_API_BASE = '${pageContext.request.contextPath}/api/tickets';
      let lastRows = [];
      let lastAnalytics = null;

      function safeParseJson(text) { try { return JSON.parse(text); } catch (_) { return null; } }
      function showNotification(message, type = 'success') {
        Toastify({ text: message, duration: 3000, close: true, gravity: 'top', position: 'right', backgroundColor: type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : type === 'warning' ? '#ffc107' : '#17a2b8' }).showToast();
      }

      async function loadStats() {
        try {
          console.group('loadStats');
          const resp = await fetch(TICKET_API_BASE + '/stats');
          const text = await resp.text();
          const data = safeParseJson(text) || {};
          console.log('loadStats response', text);
          const stats = data.analytics || data.stats || data.data || data || {};
          const open = (stats.open_tickets != null) ? stats.open_tickets : (stats.open != null) ? stats.open : (stats.open_count || 0);
          const inProgress = (stats.in_progress_tickets != null) ? stats.in_progress_tickets : (stats.in_progress != null) ? stats.in_progress : (stats.in_progress_count || 0);
          const resolved = (stats.resolved_tickets != null) ? stats.resolved_tickets : (stats.resolved != null) ? stats.resolved : (stats.resolved_count || 0);
          const closed = (stats.closed_tickets != null) ? stats.closed_tickets : (stats.closed != null) ? stats.closed : (stats.closed_count || 0);
          document.getElementById('stat_open').textContent = open;
          document.getElementById('stat_in_progress').textContent = inProgress;
          document.getElementById('stat_resolved').textContent = resolved;
          document.getElementById('stat_closed').textContent = closed;
          drawStatusPieChart({ open, in_progress: inProgress, resolved, closed });
          lastAnalytics = stats;
          console.groupEnd();
        } catch (e) { console.error('loadStats error', e); }
      }

      async function loadPriorityBreakdown() {
        try {
          console.group('loadPriorityBreakdown');
          const prCounts = { high:0, medium:0, low:0, critical:0 };
          if (lastAnalytics && Array.isArray(lastAnalytics.by_priority)) {
            lastAnalytics.by_priority.forEach(function(it){
              const name = String(it.priority_name || it.name || '').toLowerCase();
              const c = Number(it.count || it.total || 0);
              if (name && prCounts[name] !== undefined) prCounts[name] = c;
            });
          }
          document.getElementById('priority_high').textContent = prCounts.high;
          document.getElementById('priority_medium').textContent = prCounts.medium;
          document.getElementById('priority_low').textContent = prCounts.low;
          document.getElementById('priority_critical').textContent = prCounts.critical;

          const params = new URLSearchParams();
          const from = document.getElementById('filter_from').value;
          const to = document.getElementById('filter_to').value;
          if (from) params.append('created_from', from);
          if (to) params.append('created_to', to);
          const resp = await fetch(TICKET_API_BASE + '/load', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params.toString() });
          const text = await resp.text();
          const data = safeParseJson(text) || {};
          console.log('loadPriorityBreakdown response', text);
          const rows = data.tickets || data.data || data.items || data.rows || [];
          lastRows = Array.isArray(rows) ? rows : [];
          if ((!lastRows || lastRows.length === 0) && lastAnalytics) {
            const synth = [];
            const now = new Date().toISOString();
            const addRows = function(n, p, s){ for(let i=0;i<n;i++){ synth.push({ task_priority:p, task_status:s, created_date: now }); } };
            addRows(prCounts.critical, 'critical', 'open');
            addRows(prCounts.high, 'high', 'open');
            addRows(prCounts.medium, 'medium', 'open');
            addRows(prCounts.low, 'low', 'open');
            const stOpen = (lastAnalytics.open_tickets!=null)?lastAnalytics.open_tickets:(lastAnalytics.open!=null)?lastAnalytics.open:(lastAnalytics.open_count||0);
            const stInProg = (lastAnalytics.in_progress_tickets!=null)?lastAnalytics.in_progress_tickets:(lastAnalytics.in_progress!=null)?lastAnalytics.in_progress:(lastAnalytics.in_progress_count||0);
            const stResolved = (lastAnalytics.resolved_tickets!=null)?lastAnalytics.resolved_tickets:(lastAnalytics.resolved!=null)?lastAnalytics.resolved:(lastAnalytics.resolved_count||0);
            const stClosed = (lastAnalytics.closed_tickets!=null)?lastAnalytics.closed_tickets:(lastAnalytics.closed!=null)?lastAnalytics.closed:(lastAnalytics.closed_count||0);
            addRows(stInProg, 'medium', 'in_progress');
            addRows(stResolved, 'low', 'resolved');
            addRows(stClosed, 'low', 'closed');
            lastRows = synth;
          }
          drawMixChart(lastRows, document.getElementById('timeRange').value || 'month');
          console.groupEnd();
        } catch (e) { console.error('loadPriorityBreakdown error', e); showNotification('Failed to load priority breakdown', 'error'); }
      }

      function bucketKey(d, range) {
        const pad = n => String(n).padStart(2,'0');
        const yr = d.getFullYear();
        const mo = d.getMonth() + 1;
        const day = d.getDate();
        if (range === 'years') return String(yr);
        if (range === 'year') return String(yr);
        if (range === 'month') return yr + '-' + pad(mo);
        if (range === 'week') {
          const oneJan = new Date(d.getFullYear(),0,1);
          const week = Math.ceil((((d - oneJan) / 86400000) + oneJan.getDay()+1) / 7);
          return yr + '-W' + pad(week);
        }
        return yr + '-' + pad(mo);
      }

      function drawMixChart(rows, range) {
        const canvas = document.getElementById('mixChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        const w = canvas.width = canvas.offsetWidth; const h = canvas.height;
        ctx.clearRect(0,0,w,h);
        const buckets = {};
        rows.forEach(r => {
          const ds = r.created_date || r.modified_by_date || r.task_due_date;
          const d = ds ? new Date(ds) : null;
          if (!d || isNaN(d.getTime())) return;
          const key = bucketKey(d, range);
          if (!buckets[key]) buckets[key] = { high:0, medium:0, low:0, critical:0, open:0, in_progress:0, resolved:0, closed:0 };
          const p = String(r.task_priority || '').toLowerCase();
          if (p && buckets[key][p] !== undefined) buckets[key][p]++;
          const s = String(r.task_status || '').toLowerCase();
          if (s && buckets[key][s] !== undefined) buckets[key][s]++;
        });
        const labels = Object.keys(buckets).sort();
        const prColors = { high:'#dc3545', medium:'#ffc107', low:'#28a745', critical:'#ff4d4f' };
        const stColors = { open:'#0d6efd', in_progress:'#17a2b8', resolved:'#28a745', closed:'#6c757d' };
        const seriesBars = ['high','medium','low','critical'];
        const seriesLines = ['open','in_progress','resolved','closed'];
        const maxVal = Math.max(1, ...labels.map(k => Math.max(...seriesBars.map(s=>buckets[k][s]), ...seriesLines.map(s=>buckets[k][s]))));
        const margin = { left:50, right:20, top:20, bottom:40 };
        const cw = w - margin.left - margin.right;
        const ch = h - margin.top - margin.bottom;
        ctx.translate(margin.left, margin.top);
        ctx.strokeStyle = '#ddd';
        ctx.beginPath(); ctx.moveTo(0,0); ctx.lineTo(0,ch); ctx.lineTo(cw,ch); ctx.stroke();
        const groupW = cw / labels.length;
        const barW = groupW / (seriesBars.length + 1);
        labels.forEach((lab, i) => {
          seriesBars.forEach((s, j) => {
            const v = buckets[lab][s];
            const bh = Math.round(ch * (v / maxVal));
            const x = i * groupW + j * barW + 6;
            const y = ch - bh;
            ctx.fillStyle = prColors[s];
            ctx.fillRect(x, y, barW - 8, bh);
          });
          ctx.fillStyle = '#666'; ctx.font = '12px system-ui'; ctx.textAlign = 'center';
          ctx.fillText(lab, i * groupW + groupW/2, ch + 18);
        });
        seriesLines.forEach(s => {
          ctx.beginPath();
          ctx.strokeStyle = stColors[s];
          ctx.lineWidth = 2;
          labels.forEach((lab, i) => {
            const v = buckets[lab][s];
            const y = ch - Math.round(ch * (v / maxVal));
            const x = i * groupW + groupW/2;
            if (i === 0) ctx.moveTo(x,y); else ctx.lineTo(x,y);
          });
          ctx.stroke();
        });
        ctx.setTransform(1,0,0,1,0,0);
      }

      function drawStatusPieChart(stats) {
        const canvas = document.getElementById('statusPieChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        const w = canvas.width = canvas.offsetWidth; const h = canvas.height;
        ctx.clearRect(0,0,w,h);
        const cx = w/2, cy = h/2, r = Math.min(w,h)/2 - 10;
        const items = [
          { label:'Open', value: stats.open || 0, color:'#0d6efd' },
          { label:'In Progress', value: stats.in_progress || 0, color:'#17a2b8' },
          { label:'Resolved', value: stats.resolved || 0, color:'#28a745' },
          { label:'Closed', value: stats.closed || 0, color:'#6c757d' }
        ];
        const total = items.reduce((a,b)=>a+b.value,0) || 1;
        let start = -Math.PI/2;
        items.forEach(it => {
          const angle = (it.value/total) * Math.PI*2;
          ctx.beginPath(); ctx.moveTo(cx,cy); ctx.fillStyle = it.color;
          ctx.arc(cx,cy,r,start,start+angle); ctx.closePath(); ctx.fill();
          start += angle;
        });
      }

      document.getElementById('applyFilters').addEventListener('click', () => { loadPriorityBreakdown(); });
      document.getElementById('clearFilters').addEventListener('click', () => { document.getElementById('filter_from').value=''; document.getElementById('filter_to').value=''; loadPriorityBreakdown(); });
      document.getElementById('timeRange').addEventListener('change', () => { drawMixChart(lastRows, document.getElementById('timeRange').value); });

      (async function init(){
        await loadStats();
        await loadPriorityBreakdown();
      })();
    });
  </script>
</main>
