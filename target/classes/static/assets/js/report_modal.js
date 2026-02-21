/**
 * Report Generation Module
 * This file handles all logic for the Analytics Report Generator modal.
 */

function initReportGeneration() {
  console.log('[Reports] Initializing report generation module...');
  const modalEl = document.getElementById('reportModal');
  if (!modalEl) {
    console.warn('[Reports] Report modal element not found!');
    return;
  }
  
  if (!document.getElementById('reportPreviewContent')) {
    console.error('[Reports] Critical: #reportPreviewContent container not found inside modal!');
  }

  // Get globals or defaults
  const CONTEXT_PATH = window.CONTEXT_PATH || '';
  const API = CONTEXT_PATH + '/api';
  
  const openBtn = document.getElementById('openReportModal');
  let reportModal = null;
  
  if (window.bootstrap && window.bootstrap.Modal) {
    reportModal = bootstrap.Modal.getOrCreateInstance(modalEl);
  }
  
  let previewChart = null;
  let reportData = null;

  // Listen for modal show event
  modalEl.addEventListener('show.bs.modal', () => {
    console.group('%c[Reports] Modal Lifecycle: OPEN', 'color: #6366f1; font-weight: bold;');
    console.log('Timestamp:', new Date().toISOString());
    
    // Sync dates from dashboard filter on open
    const dStart = document.getElementById('dateRangeStart')?.value;
    const dEnd = document.getElementById('dateRangeEnd')?.value;
    console.log('Syncing dates from dashboard:', { dStart, dEnd });
    
    const rStartEl = document.getElementById('reportStartDate');
    const rEndEl = document.getElementById('reportEndDate');
    
    if (dStart && rStartEl) rStartEl.value = dStart;
    if (dEnd && rEndEl) rEndEl.value = dEnd;
    
    console.groupEnd();
    
    // Crucial: ensure we actually have dates before fetching
    if (rStartEl?.value && rEndEl?.value) {
        fetchReportData();
    } else {
        console.warn('[Reports] Modal opened but no dates available to fetch data');
        // Set default dates if missing (last 30 days)
        if (rStartEl && rEndEl) {
            const end = new Date();
            const start = new Date();
            start.setDate(end.getDate() - 30);
            rStartEl.value = start.toISOString().split('T')[0];
            rEndEl.value = end.toISOString().split('T')[0];
            fetchReportData();
        }
    }
  });

  // Listen for modal hide event
  modalEl.addEventListener('hide.bs.modal', () => {
    console.group('%c[Reports] Modal Lifecycle: CLOSE', 'color: #ef4444; font-weight: bold;');
    console.log('Timestamp:', new Date().toISOString());
    console.groupEnd();
    
    // Cleanup if needed
    if (previewChart) {
      previewChart.dispose();
      previewChart = null;
    }
  });

  // Event Listeners for trigger button
  if (openBtn) {
    openBtn.addEventListener('click', () => {
      console.log('[Reports] Open button clicked');
      if (reportModal) reportModal.show();
    });
  }

  // Report Type Change - Update description and preview
  const reportTypeSelect = document.getElementById('reportType');
  if (reportTypeSelect) {
    reportTypeSelect.addEventListener('change', (e) => {
      const type = e.target.value;
      const descEl = document.getElementById('reportTypeDescription');
      
      if (type === 'summary') {
        descEl.textContent = 'Overview with key metrics and charts';
      } else {
        descEl.textContent = 'Comprehensive breakdown with detailed tables';
      }
      
      updateReportPreview();
    });
  }

  // Date filter buttons
  const applyBtn = document.getElementById('applyReportDateFilter');
  if (applyBtn) {
    applyBtn.addEventListener('click', function(e) {
      if (e) {
        e.preventDefault();
        e.stopPropagation();
      }
      
      console.group('%c[Reports] Button Clicked: APPLY', 'color: #10b981; font-weight: bold;');
      const startEl = document.getElementById('reportStartDate');
      const endEl = document.getElementById('reportEndDate');
      const start = startEl?.value;
      const end = endEl?.value;
      
      if (!start || !end) {
        if (window.Toastify) {
            Toastify({
                text: "Please select both start and end dates",
                duration: 3000,
                style: { background: "#f59e0b" }
            }).showToast();
        } else {
            alert('Please select both start and end dates');
        }
        console.groupEnd();
        return;
      }

      if (new Date(start) > new Date(end)) {
        if (window.Toastify) {
            Toastify({
                text: "Start date cannot be after end date",
                duration: 3000,
                style: { background: "#ef4444" }
            }).showToast();
        } else {
            alert('Start date cannot be after end date');
        }
        console.groupEnd();
        return;
      }
      
      console.groupEnd();
      fetchReportData();
    });
  }

  const resetBtn = document.getElementById('resetReportDateFilter');
  if (resetBtn) {
    resetBtn.addEventListener('click', function(e) {
      if (e) {
        e.preventDefault();
        e.stopPropagation();
      }
      console.group('[Reports] Button Clicked: RESET');
      
      // Sync from main dashboard filter
      const dStart = document.getElementById('dateRangeStart')?.value;
      const dEnd = document.getElementById('dateRangeEnd')?.value;
      
      if (dStart && dEnd) {
        document.getElementById('reportStartDate').value = dStart;
        document.getElementById('reportEndDate').value = dEnd;
      } else {
        // Fallback to 30 days ago if dashboard dates not available
        const today = new Date();
        const start = new Date(today);
        start.setDate(today.getDate() - 30);
        document.getElementById('reportStartDate').value = start.toISOString().split('T')[0];
        document.getElementById('reportEndDate').value = today.toISOString().split('T')[0];
      }
      
      console.groupEnd();
      fetchReportData();
    });
  }

  // Update preview on filter changes
  const filterInputs = [
    'filterPrioHigh', 'filterPrioMed', 'filterPrioLow',
    'includeCharts', 'includeSummary', 'scopeOrgs', 'scopeUsers', 'scopeTickets'
  ];

  filterInputs.forEach(id => {
    const el = document.getElementById(id);
    if (el) {
      el.addEventListener('change', (e) => {
        if (id === 'scopeTickets') {
          fetchReportData();
        } else {
          updateReportPreview();
        }
      });
    }
  });

  // Export buttons
  document.getElementById('exportPdfBtn')?.addEventListener('click', exportToPdf);
  document.getElementById('exportCsvBtn')?.addEventListener('click', exportToCsv);
  document.getElementById('generateFinalReport')?.addEventListener('click', exportToPdf);
  document.getElementById('resetReportFilters')?.addEventListener('click', resetReportFilters);

  // ============================================
  // SERVICE LAYER
  // ============================================
  function safeParseJson(t) {
    try { return JSON.parse(t); } catch (_) { return null; }
  }

  async function fetchReportService(endpoint, options = {}) {
    const CONTEXT_PATH = window.CONTEXT_PATH || '';
    let finalUrl = CONTEXT_PATH + endpoint;
    
    const method = (options.method || 'GET').toUpperCase();
    
    if (method === 'GET' && options.params) {
        const query = Object.entries(options.params)
          .filter(([_, v]) => v != null)
          .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
          .join('&');
        if (query) finalUrl += (finalUrl.includes('?') ? '&' : '?') + query;
    }

    const fetchOptions = {
        method: method,
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...(options.headers || {})
        },
        ...options
    };
    
    delete fetchOptions.params;

    if (method !== 'GET' && options.body && typeof options.body === 'object') {
        fetchOptions.body = JSON.stringify(options.body);
    }

    try {
      console.log(`[Reports API] Fetching: ${method} ${finalUrl}`);
      const r = await fetch(finalUrl, fetchOptions);
      const tx = await r.text();
      
      const result = { 
        ok: r.ok, 
        status: r.status, 
        text: tx, 
        json: safeParseJson(tx) || {}
      };

      if (!r.ok) {
        console.error(`[Reports API] Error Response (${r.status}): ${tx.substring(0, 200)}`);
      }
      
      return result;
    } catch (error) {
      console.error(`[Reports API] Network/Request Error:`, error);
      // Return a failed result structure instead of throwing, so Promise.allSettled can handle it
      return { ok: false, status: 0, error: error.message }; 
    }
  }

  // ============================================
  // FETCH REPORT DATA
  // ============================================
  async function fetchReportData() {
    const startEl = document.getElementById('reportStartDate');
    const endEl = document.getElementById('reportEndDate');
    const typeEl = document.getElementById('reportType');
    const scopeTicketsEl = document.getElementById('scopeTickets');
    
    const start = startEl?.value;
    const end = endEl?.value;
    const reportType = typeEl?.value;
    const includeTickets = scopeTicketsEl ? scopeTicketsEl.checked : true;
    
    if (!start || !end) return;

    if (!includeTickets) {
      showNoScopeState();
      return;
    }

    showLoadingState();
    
    try {
      // Correct endpoints matching dashboard.js
      const ticketEndpoint = reportType === 'summary' 
        ? '/api/tickets/get_system_dashboard_data' 
        : '/api/tickets/get_tickets_list_for_dashboard';
      
      const ticketPayload = {
        start_date: start,
        end_date: end
      };

      // Fetch all data in parallel with Promise.allSettled
      const results = await Promise.allSettled([
        fetchReportService(ticketEndpoint, { method: 'POST', body: ticketPayload }),
        fetchReportService('/v1/organization_service/get_all_organizations'),
        fetchReportService('/api/users')
      ]);

      const ticketResult = results[0].status === 'fulfilled' ? results[0].value : { ok: false };
      const orgResult = results[1].status === 'fulfilled' ? results[1].value : { ok: false };
      const userResult = results[2].status === 'fulfilled' ? results[2].value : { ok: false };
      
      if (!ticketResult.ok) {
        console.error('Ticket fetch failed:', ticketResult);
      }

      // Initialize reportData structure
      reportData = {
          open_tickets: 0, in_progress_tickets: 0, resolved_tickets: 0, closed_tickets: 0, total_tickets: 0,
          org_count: 0, active_org_count: 0, user_count: 0,
          organizations: [], users: [], tickets: [], by_priority: []
      };

      // Process Ticket Data
      if (ticketResult.ok) {
          const data = ticketResult.json;
          if (reportType === 'summary') {
              let processed = data.success !== undefined ? data.data : data;
              // Handle nested 'data' or 'analytics' if present
              if (processed.analytics) processed = processed.analytics;
              
              reportData.open_tickets = processed.open_tickets ?? processed.open ?? 0;
              reportData.in_progress_tickets = processed.in_progress_tickets ?? processed.in_progress ?? 0;
              reportData.resolved_tickets = processed.resolved_tickets ?? processed.resolved ?? 0;
              reportData.closed_tickets = processed.closed_tickets ?? processed.closed ?? 0;
              reportData.total_tickets = processed.total_tickets ?? processed.total ?? 0;
              reportData.by_priority = processed.by_priority || [];
          } else {
              const tickets = Array.isArray(data) ? data : (data.tickets || data.data || []);
              reportData.tickets = tickets;
              reportData.total_tickets = tickets.length;
              
              const stats = { open: 0, in_progress: 0, resolved: 0, closed: 0, by_priority: {} };
              
              tickets.forEach(t => {
                  const status = String(t.task_status || t.status_name || '').toLowerCase();
                  if (status.includes('open')) stats.open++;
                  else if (status.includes('progress')) stats.in_progress++;
                  else if (status.includes('resolved')) stats.resolved++;
                  else if (status.includes('closed')) stats.closed++;
                  
                  const priority = String(t.priority_name || t.task_priority || 'Low').toLowerCase();
                  stats.by_priority[priority] = (stats.by_priority[priority] || 0) + 1;
              });
              
              reportData.open_tickets = stats.open;
              reportData.in_progress_tickets = stats.in_progress;
              reportData.resolved_tickets = stats.resolved;
              reportData.closed_tickets = stats.closed;
              reportData.by_priority = Object.entries(stats.by_priority).map(([name, count]) => ({
                  priority_name: name.charAt(0).toUpperCase() + name.slice(1),
                  count: count
              }));
          }
      }

      // Process Organization Data
      if (orgResult.ok) {
          const orgData = orgResult.json || [];
          const organizations = Array.isArray(orgData) ? orgData : (orgData.data || []);
          reportData.organizations = organizations;
          reportData.org_count = organizations.length;
          reportData.active_org_count = organizations.filter(o => o.is_active).length;
      }

      // Process User Data
      if (userResult.ok) {
          const userData = userResult.json || [];
          let users = [];
          if (Array.isArray(userData)) users = userData;
          else if (userData.users && Array.isArray(userData.users)) users = userData.users;
          else if (userData.content && Array.isArray(userData.content)) users = userData.content;
          else if (userData.data && Array.isArray(userData.data)) users = userData.data;
          
          reportData.users = users;
          reportData.user_count = users.length;
      }
      
      updateReportPreview();
    } catch (e) {
      console.error('[Reports] Error:', e);
      showErrorState(e.message);
    }
  }

  // ============================================
  // RESET ALL FILTERS
  // ============================================
  function resetReportFilters() {
    document.getElementById('reportType').value = 'summary';
    document.getElementById('reportTypeDescription').textContent = 'Overview with key metrics and charts';
    
    const dStart = document.getElementById('dateRangeStart')?.value;
    const dEnd = document.getElementById('dateRangeEnd')?.value;
    
    if (dStart) document.getElementById('reportStartDate').value = dStart;
    if (dEnd) document.getElementById('reportEndDate').value = dEnd;
    
    document.getElementById('filterPrioHigh').checked = true;
    document.getElementById('filterPrioMed').checked = true;
    document.getElementById('filterPrioLow').checked = true;
    document.getElementById('includeCharts').checked = true;
    document.getElementById('includeSummary').checked = true;
    document.getElementById('scopeOrgs').checked = true;
    document.getElementById('scopeUsers').checked = false;
    document.getElementById('scopeTickets').checked = true;
    
    fetchReportData();
  }

  // ============================================
  // UPDATE PREVIEW
  // ============================================
  async function updateReportPreview() {
    if (!reportData) {
      const ticketsScope = document.getElementById('scopeTickets');
      if (ticketsScope && !ticketsScope.checked) {
        showNoScopeState();
      } else {
        fetchReportData();
      }
      return;
    }

    const type = document.getElementById('reportType').value;
    const titleEl = document.getElementById('previewReportTitle');
    const updateTimeEl = document.getElementById('previewUpdateTime');
    
    // Check if title elements exist before setting textContent
    if (titleEl) titleEl.textContent = type === 'summary' ? 'Executive Summary Report' : 'Detailed Analysis Report';
    if (updateTimeEl) updateTimeEl.textContent = new Date().toLocaleTimeString();

    try {
        if (type === 'summary') {
          renderSummaryView();
        } else {
          renderDetailedView();
        }
    } catch (err) {
        showErrorState('Failed to render report preview: ' + err.message);
    }
  }

  function renderSummaryView() {
    const previewArea = getPreviewContainer();
    if (!previewArea) return;
    
    const open = reportData.open_tickets ?? 0;
    const inProgress = reportData.in_progress_tickets ?? 0;
    const resolved = reportData.resolved_tickets ?? 0;
    const closed = reportData.closed_tickets ?? 0;
    const total = reportData.total_tickets ?? (open + inProgress + resolved + closed);
    
    const totalOrgs = reportData.org_count || 0;
    const activeOrgs = reportData.active_org_count || 0;
    const totalUsers = reportData.user_count || 0;

    previewArea.innerHTML = `
      <div class="text-center mb-5 pb-4 border-bottom">
        <div class="report-header-badge mb-3">
          <span class="badge bg-primary bg-opacity-10 text-primary px-4 py-2 rounded-pill">
            <i class="bi bi-shield-check me-2"></i>CONFIDENTIAL
          </span>
        </div>
        <h2 class="fw-bold text-gradient-primary mb-2">EXECUTIVE SUMMARY</h2>
        <p class="text-muted mb-0">System Analytics Report</p>
        <p class="text-muted small">Generated on <span class="fw-semibold">${new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}</span></p>
      </div>

      <div class="row g-4 mb-5">
        <div class="col-md-3">
          <div class="stat-card-sm glass-card p-4 text-center h-100">
            <div class="stat-icon-sm bg-primary bg-opacity-10 text-primary rounded-circle p-3 mx-auto mb-3">
              <i class="bi bi-ticket-perforated fs-4"></i>
            </div>
            <div class="small text-muted text-uppercase mb-1">Total Tickets</div>
            <h2 class="fw-bold mb-2 text-primary">${total}</h2>
            <div class="small text-muted">${inProgress} in progress</div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card-sm glass-card p-4 text-center h-100">
            <div class="stat-icon-sm bg-success bg-opacity-10 text-success rounded-circle p-3 mx-auto mb-3">
              <i class="bi bi-buildings fs-4"></i>
            </div>
            <div class="small text-muted text-uppercase mb-1">Organizations</div>
            <h2 class="fw-bold mb-2 text-success">${activeOrgs}</h2>
            <div class="small text-muted">of ${totalOrgs} total</div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card-sm glass-card p-4 text-center h-100">
            <div class="stat-icon-sm bg-info bg-opacity-10 text-info rounded-circle p-3 mx-auto mb-3">
              <i class="bi bi-people fs-4"></i>
            </div>
            <div class="small text-muted text-uppercase mb-1">Users</div>
            <h2 class="fw-bold mb-2 text-info">${totalUsers}</h2>
            <div class="small text-muted">Active Participants</div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="stat-card-sm glass-card p-4 text-center h-100">
            <div class="stat-icon-sm bg-warning bg-opacity-10 text-warning rounded-circle p-3 mx-auto mb-3">
              <i class="bi bi-check-circle fs-4"></i>
            </div>
            <div class="small text-muted text-uppercase mb-1">Resolution</div>
            <h2 class="fw-bold mb-2 text-warning">${resolved + closed}</h2>
            <div class="small text-muted">Tickets Closed</div>
          </div>
        </div>
      </div>

      <div class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h5 class="fw-bold mb-0"><i class="bi bi-pie-chart-fill me-2 text-primary"></i>Status Distribution</h5>
        </div>
        <div class="chart-preview-container glass-card rounded-3 p-4">
          <div id="previewStatusChart" style="height: 300px; width: 100%;"></div>
        </div>
      </div>
    `;

    setTimeout(() => renderPreviewChart(reportData), 100);
  }

  function renderDetailedView() {
    const previewArea = getPreviewContainer();
    if (!previewArea) return;
    
    const open = reportData.open_tickets ?? 0;
    const inProgress = reportData.in_progress_tickets ?? 0;
    const resolved = reportData.resolved_tickets ?? 0;
    const closed = reportData.closed_tickets ?? 0;
    const total = reportData.total_tickets ?? (open + inProgress + resolved + closed);
    const totalCount = total || 1;
    
    const orgs = reportData.organizations || [];
    const users = reportData.users || [];
    const tickets = reportData.tickets || [];

    const stats = [
      { name: 'Open', count: open, color: 'primary', icon: 'bi-inbox' },
      { name: 'In Progress', count: inProgress, color: 'warning', icon: 'bi-hourglass-split' },
      { name: 'Resolved', count: resolved, color: 'success', icon: 'bi-check-circle' },
      { name: 'Closed', count: closed, color: 'secondary', icon: 'bi-archive' }
    ];

    previewArea.innerHTML = `
      <div class="text-center mb-5 pb-4 border-bottom">
        <h2 class="fw-bold text-gradient-primary mb-2">DETAILED ANALYSIS</h2>
        <p class="text-muted mb-0">Comprehensive System Performance Breakdown</p>
        <p class="text-muted small">Generated on <span class="fw-semibold">${new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}</span></p>
      </div>

      <!-- Metrics Section -->
      <div class="mb-5">
        <h5 class="fw-bold mb-3"><i class="bi bi-table me-2 text-primary"></i>Metrics Breakdown</h5>
        <div class="glass-card rounded-3 overflow-hidden">
          <table class="table table-hover align-middle mb-0">
            <thead class="bg-light">
              <tr>
                <th class="ps-4 py-3 border-0">Status</th>
                <th class="text-center py-3 border-0">Volume</th>
                <th class="text-center py-3 border-0">Percentage</th>
                <th class="pe-4 py-3 border-0">Distribution</th>
              </tr>
            </thead>
            <tbody>
              ${stats.map(s => {
                const percentage = Math.round((s.count / totalCount * 100) || 0);
                return `
                  <tr>
                    <td class="ps-4 py-3">
                      <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle bg-${s.color} bg-opacity-10 p-2"><i class="bi ${s.icon} text-${s.color}"></i></div>
                        <span class="fw-semibold">${s.name}</span>
                      </div>
                    </td>
                    <td class="text-center py-3"><span class="fw-bold">${s.count}</span></td>
                    <td class="text-center py-3"><span class="fw-bold">${percentage}%</span></td>
                    <td class="pe-4 py-3">
                      <div class="progress" style="height: 8px;"><div class="progress-bar bg-${s.color}" style="width: ${percentage}%"></div></div>
                    </td>
                  </tr>
                `;
              }).join('')}
            </tbody>
          </table>
        </div>
      </div>

      <!-- Organizations Scope -->
      <div class="mb-5">
        <h5 class="fw-bold mb-3"><i class="bi bi-buildings me-2 text-success"></i>Organizations Scope (${orgs.length})</h5>
        <div class="glass-card rounded-3 p-3" style="max-height: 300px; overflow-y: auto;">
            ${orgs.length > 0 ? `
            <table class="table table-sm table-hover">
                <thead><tr><th>Name</th><th>Code</th><th>Status</th></tr></thead>
                <tbody>
                    ${orgs.map(o => `
                        <tr>
                            <td>${o.org_name || 'N/A'}</td>
                            <td>${o.org_code || '-'}</td>
                            <td><span class="badge ${o.is_active ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger'}">${o.is_active ? 'Active' : 'Inactive'}</span></td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            ` : '<p class="text-muted text-center my-3">No organizations found</p>'}
        </div>
      </div>

      <!-- Users Participation -->
      <div class="mb-5">
        <h5 class="fw-bold mb-3"><i class="bi bi-people me-2 text-info"></i>Users Participation (${users.length})</h5>
        <div class="glass-card rounded-3 p-3" style="max-height: 300px; overflow-y: auto;">
             ${users.length > 0 ? `
            <table class="table table-sm table-hover">
                <thead><tr><th>User</th><th>Role</th><th>Status</th></tr></thead>
                <tbody>
                    ${users.map(u => `
                        <tr>
                            <td>${u.username || u.full_name || 'User'}</td>
                            <td><span class="badge bg-light text-dark border">${(u.role || 'User').toUpperCase()}</span></td>
                            <td><span class="badge ${u.status === 'ACTIVE' ? 'bg-soft-success text-success' : 'bg-soft-secondary text-secondary'}">${u.status || 'Unknown'}</span></td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            ` : '<p class="text-muted text-center my-3">No users found</p>'}
        </div>
      </div>

      <!-- Ticket Details -->
      ${tickets.length > 0 ? `
      <div class="mb-5">
        <h5 class="fw-bold mb-3"><i class="bi bi-ticket-detailed me-2 text-warning"></i>Ticket Details (${tickets.length})</h5>
        <div class="glass-card rounded-3 p-3" style="max-height: 400px; overflow-y: auto;">
            <table class="table table-sm table-hover">
                <thead><tr><th>ID</th><th>Subject</th><th>Status</th><th>Priority</th></tr></thead>
                <tbody>
                    ${tickets.map(t => `
                        <tr>
                            <td>#${t.ticket_id || t.id}</td>
                            <td>${t.task_name || t.subject || 'No Subject'}</td>
                            <td><span class="badge bg-soft-primary text-primary">${t.task_status || t.status_name}</span></td>
                            <td><span class="badge bg-soft-secondary text-secondary">${t.task_priority || t.priority_name}</span></td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
      </div>
      ` : ''}

      <div class="mb-4">
        <h5 class="fw-bold mb-3"><i class="bi bi-graph-up-arrow me-2 text-primary"></i>Visual Analysis</h5>
        <div class="chart-preview-container glass-card rounded-3 p-4">
          <div id="previewStatusChart" style="height: 280px; width: 100%;"></div>
        </div>
      </div>
    `;

    setTimeout(() => renderPreviewChart(reportData), 100);
  }

  function renderPreviewChart(data) {
    const chartEl = document.getElementById('previewStatusChart');
    if (!chartEl || !window.echarts || !data) return;

    if (previewChart) previewChart.dispose();
    previewChart = echarts.init(chartEl);
    
    const chartData = [
      { name: 'Open', value: data.open_tickets ?? 0, color: '#6366f1' },
      { name: 'In Progress', value: data.in_progress_tickets ?? 0, color: '#f59e0b' },
      { name: 'Resolved', value: data.resolved_tickets ?? 0, color: '#10b981' },
      { name: 'Closed', value: data.closed_tickets ?? 0, color: '#64748b' }
    ];

    previewChart.setOption({
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
      xAxis: { type: 'category', data: chartData.map(d => d.name) },
      yAxis: { type: 'value' },
      series: [{
        data: chartData.map(d => ({ value: d.value, itemStyle: { color: d.color } })),
        type: 'bar',
        barWidth: '50%',
        itemStyle: { borderRadius: [4, 4, 0, 0] }
      }]
    });
  }

  // Helper to safely get preview container
  function getPreviewContainer() {
    const el = document.getElementById('reportPreviewContent');
    if (!el) {
        console.error('[Reports] Critical: #reportPreviewContent element missing from DOM.');
    }
    return el;
  }

  function showLoadingState() {
    const previewArea = getPreviewContainer();
    if (!previewArea) return;
    
    previewArea.innerHTML = `
      <div class="text-center py-5 my-5">
        <div class="spinner-border text-primary mb-3" role="status" style="width: 3rem; height: 3rem;"></div>
        <h5 class="text-muted fw-normal">Generating Report Preview...</h5>
        <p class="text-muted small">Fetching latest data from system...</p>
      </div>
    `;
  }

  function showErrorState(msg) {
    const previewArea = getPreviewContainer();
    if (!previewArea) return;
    
    previewArea.innerHTML = `
      <div class="text-center py-5 my-5">
        <div class="text-danger mb-3"><i class="bi bi-exclamation-triangle fs-1"></i></div>
        <h5 class="text-danger">Failed to Generate Report</h5>
        <p class="text-muted">${msg}</p>
        <button class="btn btn-sm btn-outline-primary mt-3" onclick="fetchReportData()">
            <i class="bi bi-arrow-clockwise me-2"></i>Retry
        </button>
      </div>
    `;
  }
  
  function showNoScopeState() {
    const previewArea = getPreviewContainer();
    if (!previewArea) return;
    
    previewArea.innerHTML = `
      <div class="text-center py-5 my-5">
        <div class="text-muted mb-3"><i class="bi bi-info-circle fs-1"></i></div>
        <h5 class="text-muted">No Data Selected</h5>
        <p class="text-muted small">Please select "Include Ticket Data" or other scopes to view the report.</p>
      </div>
    `;
  }

  // Placeholder functions for export
  function exportToPdf() {
    if (!reportData) return;
    
    // Simple PDF generation logic or call to library
    if (window.jspdf) {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        
        doc.setFontSize(20);
        doc.text("System Analytics Report", 20, 20);
        
        doc.setFontSize(12);
        doc.text(`Generated: ${new Date().toLocaleString()}`, 20, 30);
        
        doc.text(`Total Tickets: ${reportData.total_tickets}`, 20, 50);
        doc.text(`Open: ${reportData.open_tickets}`, 20, 60);
        doc.text(`In Progress: ${reportData.in_progress_tickets}`, 20, 70);
        doc.text(`Resolved: ${reportData.resolved_tickets}`, 20, 80);
        doc.text(`Closed: ${reportData.closed_tickets}`, 20, 90);
        
        doc.save("report.pdf");
    } else {
        alert("PDF export library not loaded.");
    }
  }

  function exportToCsv() {
    if (!reportData) return;
    // Simple CSV export implementation
    const rows = [
        ["Metric", "Count"],
        ["Total Tickets", reportData.total_tickets],
        ["Open", reportData.open_tickets],
        ["In Progress", reportData.in_progress_tickets],
        ["Resolved", reportData.resolved_tickets],
        ["Closed", reportData.closed_tickets]
    ];
    
    let csvContent = "data:text/csv;charset=utf-8," 
        + rows.map(e => e.join(",")).join("\n");
        
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "report_data.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}

// Expose init function globally
window.initReportGeneration = initReportGeneration;

// Auto-initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initReportGeneration);
} else {
    // DOM already ready, initialize immediately
    initReportGeneration();
}
