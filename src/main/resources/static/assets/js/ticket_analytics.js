// Ticket Analytics Module
const TicketAnalytics = (() => {
    // Configuration
    const CONFIG = {
        API_BASE: (window.CONTEXT_PATH || '') + '/api/tickets',
        REFRESH_INTERVAL: 60000, // 1 minute
        LOG_PREFIX: '[Analytics]',
        LOG_VERBOSE: false
    };

    // State
    const state = {
        charts: {
            trend: null,
            status: null,
            priority: null,
            category: null
        },
        filters: {
            startDate: null,
            endDate: null
        },
        isLoading: false
    };

    // UI Elements
    const elements = {
        stats: {
            total: 'stat_total',
            open: 'stat_open',
            inProgress: 'stat_in_progress',
            resolved: 'stat_resolved',
            closed: 'stat_closed',
            overdue: 'stat_overdue'
        },
        charts: {
            trend: 'ticketTrendChart',
            status: 'statusPieChart',
            priority: 'priorityChart',
            category: 'categoryChart'
        },
        table: 'recentTicketsTable',
        filters: {
            start: 'dateRangeStart',
            end: 'dateRangeEnd',
            apply: 'applyFilters',
            clear: 'clearDateRange',
            refresh: 'refreshDashboard'
        }
    };

    // Helper functions
    const utils = {
        formatNumber: (num) => num?.toLocaleString() || '0',
        
        formatDate: (dateStr) => {
            if (!dateStr) return 'N/A';
            const date = new Date(dateStr);
            return date.toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
        },

        getPriorityColor: (priority) => {
            const p = (priority || '').toLowerCase();
            if (p.includes('crit')) return '#dc2626'; // Red
            if (p.includes('high')) return '#ef4444'; // Red
            if (p.includes('med')) return '#f59e0b'; // Amber
            if (p.includes('low')) return '#10b981'; // Green
            return '#64748b'; // Slate
        },

        getStatusColor: (status) => {
            const s = (status || '').toLowerCase();
            if (s.includes('open')) return '#10b981'; // Green
            if (s.includes('prog')) return '#f59e0b'; // Amber
            if (s.includes('res')) return '#3b82f6'; // Blue
            if (s.includes('clos')) return '#64748b'; // Slate
            return '#64748b';
        }
    };

    // Data Fetching
    const api = {
        async fetchData() {
            if (state.isLoading) return;
            state.isLoading = true;
            render.setLoading(true);

            const payload = {};
            if (state.filters.startDate) payload.start_date = state.filters.startDate;
            if (state.filters.endDate) payload.end_date = state.filters.endDate;
            
            // Robustly get Organization ID
            let orgId = null;
            
            // 1. Try Window Context
            if (window.ORG_CONTEXT) {
                orgId = window.ORG_CONTEXT.organization_id || window.ORG_CONTEXT.organization_uuid;
            }
            
            // 2. Try User Info
            if (!orgId && window.userInfo) {
                orgId = window.userInfo.org_id || window.userInfo.organization_id || window.userInfo.organization_uuid;
            }
            
            // 3. Try hidden input fields (common in JSP)
            if (!orgId) {
                 const orgIdInput = document.getElementById('orgId') || document.getElementById('organizationId');
                 if (orgIdInput) orgId = orgIdInput.value;
            }

            if (orgId) {
                payload.org_id = orgId;
                // Also send as organization_id to be sure
                payload.organization_id = orgId;
            } else {
                console.warn(CONFIG.LOG_PREFIX, 'Organization ID not found in context or DOM');
            }
            
            console.log(CONFIG.LOG_PREFIX, 'Fetching data with payload:', payload);

            try {
                const response = await fetch(`${CONFIG.API_BASE}/get_user_org_dashboard_data`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) throw new Error(`API error: ${response.status}`);
                
                const result = await response.json();
                
                if (result.success && result.data) {
                    render.updateDashboard(result.data);
                } else {
                    console.error(CONFIG.LOG_PREFIX, 'Failed to load data:', result);
                }
            } catch (error) {
                console.error(CONFIG.LOG_PREFIX, 'Error fetching data:', error);
            } finally {
                state.isLoading = false;
                render.setLoading(false);
            }
        }
    };

    // Rendering
    const render = {
        setLoading(isLoading) {
            const tableBody = document.getElementById(elements.table);
            
            if (isLoading) {
                // Add loading class to stats for opacity effect
                document.querySelectorAll('.stat-number').forEach(el => el.style.opacity = '0.5');
                
                // Show loading in table if it exists
                if (tableBody) {
                    tableBody.innerHTML = `
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-2 text-muted">Updating analytics...</p>
                            </td>
                        </tr>`;
                }
            } else {
                document.querySelectorAll('.stat-number').forEach(el => el.style.opacity = '1');
            }
        },

        updateDashboard(data) {
            this.updateHeader(data.organization);
            this.updateStats(data);
            this.updateCharts(data);
            this.updateTable(data.recent_tickets || []);
        },

        updateHeader(organization) {
            if (organization && organization.org_name) {
                const titleEl = document.querySelector('.header-title');
                if (titleEl) {
                    titleEl.textContent = `${organization.org_name} Analytics`;
                }
            }
        },

        updateStats(data) {
            // Update stat cards
            const updateEl = (id, val) => {
                const el = document.getElementById(id);
                if (el) el.textContent = utils.formatNumber(val);
            };

            // Use summary_stats if available (matches new API response structure)
            const stats = data.summary_stats || data.status_counts || {};
            
            updateEl(elements.stats.total, data.total_tickets || stats.total || 0);
            updateEl(elements.stats.open, stats.open || 0);
            updateEl(elements.stats.inProgress, stats.in_progress || 0);
            updateEl(elements.stats.resolved, stats.resolved || 0);
            updateEl(elements.stats.closed, stats.closed || 0);
            updateEl(elements.stats.overdue, stats.overdue || data.metrics?.overdue_tickets || 0);
        },

        updateCharts(data) {
            // Trend Chart
            let trendData = data.trends;

            // Fallback: Generate trends from recent_tickets if trends is missing
            if ((!trendData || trendData.length === 0) && data.recent_tickets && data.recent_tickets.length > 0) {
                 const trendsMap = {};
                 data.recent_tickets.forEach(ticket => {
                     const dateStr = ticket.created_date || ticket.created_at;
                     if (dateStr) {
                         // Extract YYYY-MM-DD
                         let date;
                         try {
                             date = new Date(dateStr).toISOString().split('T')[0];
                         } catch (e) {
                             console.warn('Invalid date:', dateStr);
                             return;
                         }
                         trendsMap[date] = (trendsMap[date] || 0) + 1;
                     }
                 });
                 
                 trendData = Object.keys(trendsMap).sort().map(date => ({
                     period: date,
                     count: trendsMap[date]
                 }));
                 
                 // If we have data but it's sparse, maybe fill in gaps? 
                 // For now, let's just show what we have to ensure the chart renders.
            }

            if (trendData && trendData.length > 0) {
                const options = {
                    series: [{
                        name: 'Tickets',
                        data: trendData.map(t => t.count)
                    }],
                    chart: {
                        type: 'area',
                        height: 320,
                        toolbar: { show: false }
                    },
                    dataLabels: { enabled: false },
                    stroke: { curve: 'smooth' },
                    xaxis: {
                        categories: trendData.map(t => t.period),
                        type: 'datetime' // Better for dates
                    },
                    colors: ['#6366f1']
                };

                if (state.charts.trend) {
                    state.charts.trend.updateOptions(options);
                } else {
                    const el = document.getElementById(elements.charts.trend);
                    if (el) {
                        state.charts.trend = new ApexCharts(el, options);
                        state.charts.trend.render();
                    }
                }
            } else {
                 // Handle empty state for chart
                 const el = document.getElementById(elements.charts.trend);
                 if (el) {
                     el.innerHTML = '<div class="d-flex align-items-center justify-content-center h-100 text-muted">No trend data available</div>';
                 }
            }

            // Status Pie Chart
            const stats = data.summary_stats || data.status_counts || {};
            const statusData = [
                stats.open || 0,
                stats.in_progress || 0,
                stats.resolved || 0,
                stats.closed || 0
            ];
            
            const statusOptions = {
                series: statusData,
                labels: ['Open', 'In Progress', 'Resolved', 'Closed'],
                chart: {
                    type: 'donut',
                    height: 320
                },
                colors: ['#10b981', '#f59e0b', '#3b82f6', '#64748b'],
                legend: { position: 'bottom' }
            };

            if (state.charts.status) {
                state.charts.status.updateOptions(statusOptions);
            } else {
                const el = document.getElementById(elements.charts.status);
                if (el) {
                    state.charts.status = new ApexCharts(el, statusOptions);
                    state.charts.status.render();
                }
            }

            // Priority Bar Chart
            if (data.priority_counts) {
                // priority_counts is an object: { critical: 0, high: 0, ... }
                // Convert to arrays for ApexCharts
                const categories = Object.keys(data.priority_counts).map(k => k.charAt(0).toUpperCase() + k.slice(1).toLowerCase());
                const counts = Object.values(data.priority_counts);

                const priorityColorsMap = {
                    'Critical': '#dc2626',
                    'High': '#ef4444',
                    'Medium': '#f59e0b',
                    'Low': '#10b981',
                    'Normal': '#3b82f6'
                };
                const priorityColors = categories.map(c => priorityColorsMap[c] || '#6366f1');

                const priorityOptions = {
                    series: [{
                        name: 'Tickets',
                        data: counts
                    }],
                    chart: {
                        type: 'bar',
                        height: 320,
                        toolbar: { show: false }
                    },
                    plotOptions: {
                        bar: { borderRadius: 4, horizontal: false, distributed: true }
                    },
                    dataLabels: { enabled: false },
                    xaxis: {
                        categories: categories,
                    },
                    colors: priorityColors,
                    legend: { show: false }
                };

                if (state.charts.priority) {
                    state.charts.priority.updateOptions(priorityOptions);
                } else {
                    const el = document.getElementById(elements.charts.priority);
                    if (el) {
                        state.charts.priority = new ApexCharts(el, priorityOptions);
                        state.charts.priority.render();
                    }
                }
            }
            
            // Category Chart (if available)
             if (data.category_distribution) {
                const categoryOptions = {
                    series: data.category_distribution.map(c => c.count),
                    labels: data.category_distribution.map(c => c.name),
                    chart: {
                        type: 'donut',
                        height: 320,
                        toolbar: { show: false }
                    },
                    colors: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#06b6d4'],
                    plotOptions: { 
                        pie: { 
                            donut: { 
                                size: '65%' 
                            } 
                        } 
                    },
                    dataLabels: { enabled: true },
                    legend: { position: 'bottom' },
                    stroke: { show: false }
                };

                if (state.charts.category) {
                    state.charts.category.updateOptions(categoryOptions);
                } else {
                    const el = document.getElementById(elements.charts.category);
                    if (el) {
                        state.charts.category = new ApexCharts(el, categoryOptions);
                        state.charts.category.render();
                    }
                }
            }
        },

        updateTable(tickets) {
            const tbody = document.getElementById(elements.table);
            if (!tbody) return;

            if (tickets.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">
                            No recent tickets found
                        </td>
                    </tr>`;
                return;
            }

            tbody.innerHTML = tickets.map(ticket => `
                <tr>
                    <td><span class="fw-medium">#${ticket.ticket_number || (ticket.id ? ticket.id.substring(0, 8) : 'N/A')}</span></td>
                    <td>
                        <div class="text-truncate" style="max-width: 200px;" title="${ticket.subject || ticket.title}">
                            ${ticket.subject || ticket.title || 'No Subject'}
                        </div>
                    </td>
                    <td>
                        <span class="badge bg-opacity-10 text-body" style="background-color: ${utils.getPriorityColor(ticket.priority)}20; color: ${utils.getPriorityColor(ticket.priority)} !important">
                            ${ticket.priority || 'Normal'}
                        </span>
                    </td>
                    <td>
                        <span class="badge bg-opacity-10 text-body" style="background-color: ${utils.getStatusColor(ticket.status)}20; color: ${utils.getStatusColor(ticket.status)} !important">
                            ${ticket.status || 'Open'}
                        </span>
                    </td>
                    <td>${utils.formatDate(ticket.created_date || ticket.created_at)}</td>
                    <td>${utils.formatDate(ticket.updated_date || ticket.updated_at)}</td>
                    <td class="text-end">
                        <a href="${window.CONTEXT_PATH || ''}/tickets?view=${ticket.id}" class="btn btn-sm btn-light">
                            <i class="bi bi-eye"></i>
                        </a>
                    </td>
                </tr>
            `).join('');
        }
    };

    // Initialization
    function init() {
        // Initialize date pickers with defaults (last 30 days)
        const end = new Date();
        const start = new Date();
        start.setDate(start.getDate() - 30);

        const startEl = document.getElementById(elements.filters.start);
        const endEl = document.getElementById(elements.filters.end);

        if (startEl) startEl.valueAsDate = start;
        if (endEl) endEl.valueAsDate = end;

        state.filters.startDate = start.toISOString().split('T')[0];
        state.filters.endDate = end.toISOString().split('T')[0];

        // Add Change Listeners for Dynamic Fetching
        const handleDateChange = () => {
            if (startEl && endEl) {
                // Basic validation
                if (startEl.value && endEl.value) {
                    state.filters.startDate = startEl.value;
                    state.filters.endDate = endEl.value;
                    api.fetchData();
                }
            }
        };

        if (startEl) startEl.addEventListener('change', handleDateChange);
        if (endEl) endEl.addEventListener('change', handleDateChange);

        // Event Listeners
        document.getElementById(elements.filters.apply)?.addEventListener('click', () => {
            if (startEl) state.filters.startDate = startEl.value;
            if (endEl) state.filters.endDate = endEl.value;
            api.fetchData();
        });

        document.getElementById(elements.filters.clear)?.addEventListener('click', () => {
            const end = new Date();
            const start = new Date();
            start.setDate(start.getDate() - 30);
            
            if (startEl) startEl.valueAsDate = start;
            if (endEl) endEl.valueAsDate = end;
            
            state.filters.startDate = start.toISOString().split('T')[0];
            state.filters.endDate = end.toISOString().split('T')[0];
            
            // Reset active preset
            document.querySelectorAll('.preset-btn-analytics').forEach(b => b.classList.remove('active'));
            document.querySelector('.preset-btn-analytics[data-days="30"]')?.classList.add('active');
            
            api.fetchData();
        });

        document.getElementById(elements.filters.refresh)?.addEventListener('click', () => {
            api.fetchData();
        });
        
        // Preset buttons
        document.querySelectorAll('.preset-btn-analytics').forEach(btn => {
            btn.addEventListener('click', (e) => {
                // Remove active class from all
                document.querySelectorAll('.preset-btn-analytics').forEach(b => b.classList.remove('active'));
                // Add to clicked
                e.target.classList.add('active');
                
                const days = parseInt(e.target.dataset.days);
                const newStart = new Date();
                newStart.setDate(newStart.getDate() - days);
                
                if (startEl) startEl.valueAsDate = newStart;
                if (endEl) endEl.valueAsDate = new Date();
                
                state.filters.startDate = newStart.toISOString().split('T')[0];
                state.filters.endDate = new Date().toISOString().split('T')[0];
                
                api.fetchData();
            });
        });

        // Initial fetch
        api.fetchData();
    }

    return {
        init
    };
})();

document.addEventListener('DOMContentLoaded', () => {
    TicketAnalytics.init();
});