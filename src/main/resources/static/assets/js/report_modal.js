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

  async function fetchReportService(endpoint, params = {}) {
    const CONTEXT_PATH = window.CONTEXT_PATH || '';
    let finalUrl = CONTEXT_PATH + endpoint;
    
    // Build query string
    const query = Object.entries(params)
      .filter(([_, v]) => v != null)
      .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
      .join('&');
    
    if (query) {
      finalUrl += (finalUrl.includes('?') ? '&' : '?') + query;
    }

    try {
      const r = await fetch(finalUrl);
      const tx = await r.text();
      
      const result = { 
        ok: r.ok, 
        status: r.status, 
        text: tx, 
        json: safeParseJson(tx) || {}
      };

      if (!r.ok) {
        console.error(`[Reports API] Error Response: ${tx.substring(0, 200)}`);
      }
      
      return result;
    } catch (error) {
      console.error(`[Reports API] Network/Request Error:`, error);
      throw error;
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
      const endpoint = reportType === 'summary' 
        ? '/v1/ticket_service/get_system_dashboard_data' 
        : '/v1/ticket_service/get_tickets_list_for_dashboard';
      
      const params = {
        start_date: start,
        end_date: end
      };

      const result = await fetchReportService(endpoint, params);
      
      if (!result.ok) {
        throw new Error(`Server returned ${result.status}`);
      }

      const data = result.json;
      
      if (reportType === 'summary') {
          let processed = data.success !== undefined ? data.data : data;
          if (processed.analytics) processed = processed.analytics;
          
          reportData = {
              open_tickets: processed.open_tickets ?? processed.open ?? 0,
              in_progress_tickets: processed.in_progress_tickets ?? processed.in_progress ?? 0,
              resolved_tickets: processed.resolved_tickets ?? processed.resolved ?? 0,
              closed_tickets: processed.closed_tickets ?? processed.closed ?? 0,
              total_tickets: processed.total_tickets ?? processed.total ?? 0,
              by_priority: processed.by_priority || []
          };
      } else {
          const tickets = Array.isArray(data) ? data : (data.tickets || data.data || []);
          
          const stats = {
              open: 0,
              in_progress: 0,
              resolved: 0,
              closed: 0,
              total: tickets.length,
              by_priority: {}
          };
          
          tickets.forEach(t => {
              const status = String(t.task_status || t.status_name || '').toLowerCase();
              if (status.includes('open')) stats.open++;
              else if (status.includes('progress')) stats.in_progress++;
              else if (status.includes('resolved')) stats.resolved++;
              else if (status.includes('closed')) stats.closed++;
              
              const priority = String(t.priority_name || t.task_priority || 'Low').toLowerCase();
              stats.by_priority[priority] = (stats.by_priority[priority] || 0) + 1;
          });
          
          reportData = {
              open_tickets: stats.open,
              in_progress_tickets: stats.in_progress,
              resolved_tickets: stats.resolved,
              closed_tickets: stats.closed,
              total_tickets: stats.total,
              tickets: tickets,
              by_priority: Object.entries(stats.by_priority).map(([name, count]) => ({
                  priority_name: name.charAt(0).toUpperCase() + name.slice(1),
                  count: count
              }))
          };
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
    const previewArea = document.getElementById('reportPreviewArea');
    if (!reportData) {
      if (!document.getElementById('scopeTickets')?.checked) {
        showNoScopeState();
      } else {
        fetchReportData();
      }
      return;
    }

    const type = document.getElementById('reportType').value;
    const titleEl = document.getElementById('previewReportTitle');
    const updateTimeEl = document.getElementById('previewUpdateTime');
    
    titleEl.textContent = type === 'summary' ? 'Executive Summary Report' : 'Detailed Analysis Report';
    updateTimeEl.textContent = new Date().toLocaleTimeString();

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
    const previewArea = document.getElementById('reportPreviewArea');
    const open = reportData.open_tickets ?? 0;
    const inProgress = reportData.in_progress_tickets ?? 0;
    const resolved = reportData.resolved_tickets ?? 0;
    const closed = reportData.closed_tickets ?? 0;
    const total = reportData.total_tickets ?? (open + inProgress + resolved + closed);
    const activeOrgs = document.getElementById('org_count')?.textContent || '0';

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
        <div class="col-md-4">
          <div class="stat-card-sm glass-card p-4 text-center h-100">
            <div class="stat-icon-sm bg-primary bg-opacity-10 text-primary rounded-circle p-3 mx-auto mb-3">
              <i class="bi bi-ticket-perforated fs-4"></i>
            </div>
            <div class="small text-muted text-uppercase mb-1">Total Tickets</div>
            <h2 class="fw-bold mb-2 text-primary">${total}</h2>
          </div>
        </div>
        <div class="col-md-4">
          <div class="stat-card-sm glass-card p-4 text-center h-100">
            <div class="stat-icon-sm bg-success bg-opacity-10 text-success rounded-circle p-3 mx-auto mb-3">
              <i class="bi bi-buildings fs-4"></i>
            </div>
            <div class="small text-muted text-uppercase mb-1">Organizations</div>
            <h2 class="fw-bold mb-2 text-success">${activeOrgs}</h2>
          </div>
        </div>
        <div class="col-md-4">
          <div class="stat-card-sm glass-card p-4 text-center h-100">
            <div class="stat-icon-sm bg-warning bg-opacity-10 text-warning rounded-circle p-3 mx-auto mb-3">
              <i class="bi bi-hourglass-split fs-4"></i>
            </div>
            <div class="small text-muted text-uppercase mb-1">In Progress</div>
            <h2 class="fw-bold mb-2 text-warning">${inProgress}</h2>
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
    const previewArea = document.getElementById('reportPreviewArea');
    const open = reportData.open_tickets ?? 0;
    const inProgress = reportData.in_progress_tickets ?? 0;
    const resolved = reportData.resolved_tickets ?? 0;
    const closed = reportData.closed_tickets ?? 0;
    const total = reportData.total_tickets ?? (open + inProgress + resolved + closed);
    const totalCount = total || 1;

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
        type: 'bar', barWidth: '50%', itemStyle: { borderRadius: [8, 8, 0, 0] },
        label: { show: true, position: 'top' }
      }]
    });
  }

  function showLoadingState() {
    document.getElementById('reportPreviewArea').innerHTML = `
      <div class="text-center py-5">
        <div class="spinner-border text-primary mb-3" role="status"></div>
        <p class="text-muted">Loading report data...</p>
      </div>
    `;
  }

  function showNoScopeState() {
    document.getElementById('reportPreviewArea').innerHTML = `
      <div class="text-center py-5">
        <i class="bi bi-info-circle text-primary fs-1 mb-3"></i>
        <h5>No Data Scope Selected</h5>
        <p class="text-muted">Please select "Tickets & Tasks" to view analytics.</p>
      </div>
    `;
  }

  function showErrorState(message) {
    document.getElementById('reportPreviewArea').innerHTML = `
      <div class="text-center py-5">
        <i class="bi bi-exclamation-triangle text-danger fs-1 mb-3"></i>
        <p class="text-danger fw-semibold">Error loading report data</p>
        <p class="text-muted small">${message || 'Please try again'}</p>
        <button id="retryReportFetch" class="btn btn-sm btn-outline-primary mt-3">Retry</button>
      </div>
    `;
    document.getElementById('retryReportFetch')?.addEventListener('click', () => fetchReportData());
  }

  async function exportToPdf() {
    if (!window.jspdf?.jsPDF || !reportData) {
      if (window.Toastify) Toastify({ text: "Export failed", style: { background: "#ef4444" } }).showToast();
      return;
    }

    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();
    const type = document.getElementById('reportType').value;
    
    doc.setFontSize(24);
    doc.text('ANALYTICS REPORT', 105, 20, { align: 'center' });
    doc.setFontSize(12);
    doc.text(`Generated: ${new Date().toLocaleString()}`, 105, 30, { align: 'center' });

    const open = reportData.open_tickets ?? 0;
    const inProgress = reportData.in_progress_tickets ?? 0;
    const resolved = reportData.resolved_tickets ?? 0;
    const closed = reportData.closed_tickets ?? 0;
    const total = reportData.total_tickets ?? (open + inProgress + resolved + closed);

    if (window.jspdf.plugin?.autotable) {
      doc.autoTable({
        startY: 50,
        head: [['Status', 'Count', 'Distribution']],
        body: [
          ['Open', open, `${Math.round((open / total * 100) || 0)}%`],
          ['In Progress', inProgress, `${Math.round((inProgress / total * 100) || 0)}%`],
          ['Resolved', resolved, `${Math.round((resolved / total * 100) || 0)}%`],
          ['Closed', closed, `${Math.round((closed / total * 100) || 0)}%`]
        ]
      });
    }

    doc.save(`report-${type}-${Date.now()}.pdf`);
  }

  function exportToCsv() {
    if (!reportData) return;
    const type = document.getElementById('reportType').value;
    const open = reportData.open_tickets ?? 0;
    const inProgress = reportData.in_progress_tickets ?? 0;
    const resolved = reportData.resolved_tickets ?? 0;
    const closed = reportData.closed_tickets ?? 0;
    const total = reportData.total_tickets ?? (open + inProgress + resolved + closed);

    let csv = "Status,Count,Percentage\n";
    csv += `Open,${open},${Math.round((open / total * 100) || 0)}%\n`;
    csv += `In Progress,${inProgress},${Math.round((inProgress / total * 100) || 0)}%\n`;
    csv += `Resolved,${resolved},${Math.round((resolved / total * 100) || 0)}%\n`;
    csv += `Closed,${closed},${Math.round((closed / total * 100) || 0)}%\n`;

    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.setAttribute('hidden', '');
    a.setAttribute('href', url);
    a.setAttribute('download', `report-${type}.csv`);
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }
}

// Initialize on DOM load
document.addEventListener('DOMContentLoaded', () => {
    initReportGeneration();
});

// Also expose to window in case dashboard.js needs to call it
window.initReportGeneration = initReportGeneration;
