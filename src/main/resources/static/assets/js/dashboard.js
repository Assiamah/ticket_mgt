// Enhanced Dashboard Module - Optimized Version
 const Dashboard = (() => {
    // Configuration
    const CONFIG = {
        API_BASE: (window.CONTEXT_PATH || '') + '/api/tickets',
        REFRESH_INTERVAL: 30000, // 30 seconds
        BACKOFF_DURATION: 120000, // 2 minutes for errors
        CHART_ANIMATION_DURATION: 1200,
        MAX_ORGANIZATIONS_DISPLAY: 8,
        MAX_CATEGORIES_DISPLAY: 12,
        DEFAULT_DATE_RANGE_DAYS: 30, // Default to 1 month
        LOG_PREFIX: '[Dashboard]',
        LOG_VERBOSE: false // Set to false to reduce logging in production
    };

    // Enhanced logging utility
    const log = {
        info: (event, data) => {
            if (!CONFIG.LOG_VERBOSE) return;
            try {
                console.log(CONFIG.LOG_PREFIX, event, JSON.stringify(data, null, 2) ?? '');
            } catch (e) {
                console.log(CONFIG.LOG_PREFIX, event, 'ERROR_LOGGING_DATA:', e.message);
            }
        },
        warn: (event, data) => {
            try {
                console.warn(CONFIG.LOG_PREFIX, event, JSON.stringify(data, null, 2) ?? '');
            } catch (e) {
                console.warn(CONFIG.LOG_PREFIX, event, 'ERROR_LOGGING_DATA:', e.message);
            }
        },
        error: (event, err) => {
            try {
                console.error(CONFIG.LOG_PREFIX, event, err.stack ? err.stack : err);
            } catch (e) {
                console.error(CONFIG.LOG_PREFIX, event, 'ERROR_LOGGING_ERROR:', e.message);
            }
        },
        debug: (event, data) => {
            if (!CONFIG.LOG_VERBOSE) return;
            try {
                console.debug(CONFIG.LOG_PREFIX, event, JSON.stringify(data, null, 2) ?? '');
            } catch (e) {
                console.debug(CONFIG.LOG_PREFIX, event, 'ERROR_LOGGING_DATA:', e.message);
            }
        }
    };

    // State management
    const state = {
        charts: {
            status: null,
            priority: null,
            trend: null,
            category: null,
            resolution: null,
            orgTickets: null
        },
        data: {
            analytics: null,
            tickets: [],
            organizations: [],
            lastUpdated: null
        },
        filters: {
            dateRange: {
                start: null,
                end: null
            }
        },
        flags: {
            isInitialized: false,
            isFetching: false,
            backoffUntil: 0
        },
        elements: {}
    };

    // Cache DOM elements
    function cacheElements() {
        const ids = [
            'status_pie_chart', 'priority_bar_chart', 'dashboard_ticket_trend_chart',
            'dashboard_category_chart', 'dashboard_resolution_chart', 'dashboard_org_tickets_chart',
            'org_tickets_list', 'totalTickets', 'ticket_total_count', 'status_open_count',
            'status_in_progress_count', 'status_resolved_count', 'status_closed_count',
            'overdue_tickets_count', 'org_count', 'priority_high_count', 'priority_medium_count',
            'priority_low_count', 'my_assigned_total', 'statusChartUpdate',
            // Date filter elements
            'dateRangeStart', 'dateRangeEnd', 'applyDateFilter', 'resetDateFilter'
        ];
        
        ids.forEach(id => {
            const el = document.getElementById(id);
            if (el) state.elements[id] = el;
        });
    }

    // Date filter functions
    const dateFilter = {
        // Initialize date filter with default range (1 month)
        init() {
            const today = new Date();
            const startDate = new Date(today);
            startDate.setDate(today.getDate() - CONFIG.DEFAULT_DATE_RANGE_DAYS);
            
            // Format dates as YYYY-MM-DD for input[type=date]
            const formatDate = (date) => {
                return date.toISOString().split('T')[0];
            };
            
            const formattedStart = formatDate(startDate);
            const formattedEnd = formatDate(today);
            
            // Set initial values
            if (state.elements.dateRangeStart) {
                state.elements.dateRangeStart.value = formattedStart;
            }
            if (state.elements.dateRangeEnd) {
                state.elements.dateRangeEnd.value = formattedEnd;
            }
            
            // Update state
            state.filters.dateRange.start = formattedStart;
            state.filters.dateRange.end = formattedEnd;
            
            // Attach event listeners
            this.attachEventListeners();
        },
        
        // Attach event listeners to date filter elements
        attachEventListeners() {
            if (state.elements.applyDateFilter) {
                state.elements.applyDateFilter.addEventListener('click', () => {
                    this.applyFilter();
                });
            }
            
            if (state.elements.resetDateFilter) {
                state.elements.resetDateFilter.addEventListener('click', () => {
                    this.resetFilter();
                });
            }
            
            // Apply filter when pressing Enter in date inputs
            // or when input values change (auto-apply)
            const dateInputs = [state.elements.dateRangeStart, state.elements.dateRangeEnd];
            dateInputs.forEach(input => {
                if (input) {
                    // Apply on Enter key press
                    input.addEventListener('keypress', (e) => {
                        if (e.key === 'Enter') {
                            this.applyFilter();
                        }
                    });
                    
                    // Apply automatically when input value changes
                    input.addEventListener('input', () => {
                        this.applyFilter();
                    });
                }
            });
        },
        
        // Apply the selected date filter
        applyFilter() {
            const start = state.elements.dateRangeStart?.value;
            const end = state.elements.dateRangeEnd?.value;
            
            if (start && end) {
                // Validate dates
                if (new Date(start) > new Date(end)) {
                    log.warn('dateFilter:invalid-range', {
                        start,
                        end,
                        message: 'Start date cannot be after end date'
                    });
                    return;
                }
                
                // Update state
                state.filters.dateRange.start = start;
                state.filters.dateRange.end = end;
                
                // Refresh dashboard data with new date range
                loader.refresh();
            }
        },
        
        // Reset date filter to default range
        resetFilter() {
            const today = new Date();
            const startDate = new Date(today);
            startDate.setDate(today.getDate() - CONFIG.DEFAULT_DATE_RANGE_DAYS);
            
            const formatDate = (date) => {
                return date.toISOString().split('T')[0];
            };
            
            const formattedStart = formatDate(startDate);
            const formattedEnd = formatDate(today);
            
            // Reset input values
            if (state.elements.dateRangeStart) {
                state.elements.dateRangeStart.value = formattedStart;
            }
            if (state.elements.dateRangeEnd) {
                state.elements.dateRangeEnd.value = formattedEnd;
            }
            
            // Update state
            state.filters.dateRange.start = formattedStart;
            state.filters.dateRange.end = formattedEnd;
            
            // Refresh dashboard data with default date range
            loader.refresh();
        },
        
        // Get date range as query string parameters
        getQueryParams() {
            const { start, end } = state.filters.dateRange;
            return start && end ? `&start_date=${encodeURIComponent(start)}&end_date=${encodeURIComponent(end)}` : '';
        }
    };

    // Utility functions
    const utils = {
        safeParseJson: (text) => {
            try {
                return JSON.parse(text);
            } catch (e) {
                log.warn('utils:json:parse:error', {
                    error: e.message,
                    textPreview: text?.substring(0, 100)
                });
                return null;
            }
        },

        resolveCurrentUserId: () => {
            const contexts = [window.App, window.APP, window.AppContext];
            for (const ctx of contexts) {
                if (ctx?.user) {
                    const user = ctx.user;
                    if (typeof user === 'string') return user;
                    return user.id || user.user_id || user.unique_id || '';
                }
            }
            return document.body?.getAttribute('data-user-id') || '';
        },

        formatNumber: (num) => {
            return num?.toLocaleString() || '0';
        },

        debounce: (func, wait) => {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }
    };

    // API service
    const api = {
        async fetch(endpoint, options = {}) {
            const requestId = Date.now().toString(36) + Math.random().toString(36).substring(2);
            
            if (Date.now() < state.flags.backoffUntil) {
                log.warn('api:fetch:skipped:backoff', {
                    endpoint,
                    backoffUntil: new Date(state.flags.backoffUntil).toISOString()
                });
                return { ok: false, status: 429 };
            }

            // Add date range query parameters only to GET requests
            const method = (options.method || 'GET').toUpperCase();
            let url = `${CONFIG.API_BASE}${endpoint}`;
            
            if (method === 'GET') {
                const dateParams = dateFilter.getQueryParams();
                url += endpoint.includes('?') ? dateParams : (dateParams ? `?${dateParams.substring(1)}` : '');
            }
            
            const config = {
                credentials: 'include',
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    ...options.headers
                },
                ...options
            };

            // Log request details
            log.info('api:fetch:start', {
                requestId,
                endpoint,
                url,
                method: config.method || 'GET',
                headers: config.headers,
                dateRange: state.filters.dateRange,
                timestamp: new Date().toISOString()
            });

            try {
                const startTime = performance.now();
                const response = await fetch(url, config);
                const elapsed = performance.now() - startTime;

                const contentType = response.headers.get('content-type') || '';
                const text = await response.text();
                const json = utils.safeParseJson(text);

                // Log response details
                log.info('api:fetch:complete', {
                    requestId,
                    endpoint,
                    status: response.status,
                    durationMs: Math.round(elapsed),
                    contentType,
                    timestamp: new Date().toISOString()
                });

                // Log response data if available and not too large
                if (json && typeof json === 'object') {
                    // Create a safe copy of the data for logging (limit depth)
                    const logData = JSON.parse(JSON.stringify(json, (key, value) => {
                        if (typeof value === 'object' && value !== null && Object.keys(value).length > 50) {
                            return `[Object with ${Object.keys(value).length} keys]`;
                        }
                        return value;
                    }));
                    
                    log.debug('api:fetch:response:data', {
                        requestId,
                        endpoint,
                        data: logData
                    });
                }

                if (!response.ok) {
                    if (response.status >= 500) {
                        state.flags.backoffUntil = Date.now() + CONFIG.BACKOFF_DURATION;
                    }
                    // Try to read error body if possible
                    let errorMessage = `API error: ${response.status}`;
                    try {
                        if (json && (json.message || json.error)) {
                            errorMessage = json.message || json.error;
                        }
                    } catch (ignore) {}

                    const error = new Error(errorMessage);
                    log.error('api:fetch:error', {
                        requestId,
                        endpoint,
                        status: response.status,
                        error: errorMessage,
                        body: json
                    });
                    throw error;
                }

                // Check if response is HTML (likely redirect to login)
                if (contentType.includes('text/html') || /^\s*<!DOCTYPE html/i.test(text)) {
                    this.handleSessionExpired();
                    log.warn('api:fetch:session-expired', {
                        requestId,
                        endpoint,
                        contentType
                    });
                    return { ok: false, html: true };
                }

                return {
                    ok: true,
                    status: response.status,
                    data: json?.data || json?.result || json,
                    raw: json,
                    text
                };
            } catch (error) {
                log.error('api:fetch:exception', {
                    requestId,
                    endpoint,
                    error: error.message,
                    stack: error.stack
                });
                return { ok: false, error: error.message };
            }
        },

        handleSessionExpired() {
            if (window.Toastify) {
                Toastify({
                    text: 'Session expired — please sign in',
                    duration: 6000,
                    close: true,
                    gravity: 'top',
                    position: 'right',
                    stopOnFocus: true,
                    style: {
                        background: 'linear-gradient(to right, #ff5f6d, #ffc371)',
                        fontSize: '13px'
                    }
                }).showToast();
            }
        },

        // Batch fetch multiple endpoints
        async fetchAll(endpoints) {
            const batchRequestId = Date.now().toString(36) + Math.random().toString(36).substring(2);
            
            log.info('api:fetchAll:start', {
                batchRequestId,
                endpoints,
                totalEndpoints: endpoints.length,
                timestamp: new Date().toISOString()
            });
            
            try {
                const results = await Promise.all(
                    endpoints.map(endpoint => this.fetch(endpoint))
                );
                
                log.info('api:fetchAll:complete', {
                    batchRequestId,
                    endpoints,
                    totalEndpoints: endpoints.length,
                    successfulRequests: results.filter(r => r.ok).length,
                    failedRequests: results.filter(r => !r.ok).length,
                    timestamp: new Date().toISOString()
                });
                
                return results;
            } catch (error) {
                log.error('api:fetchAll:exception', {
                    batchRequestId,
                    endpoints,
                    error: error.message,
                    stack: error.stack
                });
                throw error;
            }
        }
    };

    // Data processors
    const processors = {
        processAnalyticsData(rawData) {
            // Handle new data structure from web service - check if it has a success wrapper
            const responseData = rawData?.success !== undefined ? rawData.data : rawData;
            
            // Handle wrapper structure: stats -> analytics
            const data = responseData?.stats?.analytics || responseData?.analytics || responseData?.stats || responseData?.data || responseData || {};
            
            // Extract priority breakdown if available in new format
            let byPriority = [];
            if (Array.isArray(data.by_priority)) {
                byPriority = data.by_priority;
            } else if (data.priority_breakdown) {
                // Handle priority breakdown in new format
                byPriority = Object.entries(data.priority_breakdown).map(([name, count]) => ({
                    priority_name: name,
                    count: Number(count)
                }));
            }
            
            return {
                open: Number(data.open_tickets ?? data.open ?? data.open_count ?? 0),
                inProgress: Number(data.in_progress_tickets ?? data.in_progress ?? data.in_progress_count ?? 0),
                resolved: Number(data.resolved_tickets ?? data.resolved ?? data.resolved_count ?? 0),
                closed: Number(data.closed_tickets ?? data.closed ?? data.closed_count ?? 0),
                total: Number(data.total_tickets ?? data.total ?? data.total_count ?? 0),
                overdue: Number(data.overdue_tickets ?? data.overdue ?? data.overdue_count ?? 0),
                byPriority: byPriority,
                organizations: Array.isArray(data.organizations) ? data.organizations : data.organizations?.data || []
            };
        },

        processPriorityCounts(analyticsData) {
            const counts = { critical: 0, high: 0, medium: 0, low: 0 };
            
            if (analyticsData?.byPriority) {
                analyticsData.byPriority.forEach(item => {
                    const name = String(item.priority_name || item.name || '').toLowerCase();
                    const count = Number(item.count || item.total || 0);
                    
                    if (name.includes('crit')) counts.critical = count;
                    else if (name.includes('high')) counts.high = count;
                    else if (name.includes('med')) counts.medium = count;
                    else if (name.includes('low')) counts.low = count;
                });
            }
            
            return counts;
        },

        computeTicketAnalytics(tickets) {
            if (!Array.isArray(tickets)) return {
                total: 0,
                open: 0,
                inProgress: 0,
                resolved: 0,
                closed: 0,
                overdue: 0,
                assignedCount: 0,
                trend: [],
                categories: [],
                resolutions: [],
                orgCounts: []
            };
            
            const now = new Date();
            const ninetyDaysAgo = new Date(now);
            ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);
            
            const trend = new Map();
            const categories = new Map();
            const resolutions = new Map();
            const orgCounts = new Map();
            let total = 0;
            let open = 0;
            let inProgress = 0;
            let resolved = 0;
            let closed = 0;
            let overdue = 0;
            let assignedCount = 0;

            tickets.forEach(ticket => {
                total++;
                
                // Declare status once at the beginning of the loop
                const status = String(ticket.task_status || ticket.status_name || '').toLowerCase();
                
                // Calculate ticket status counts
                if (status.includes('open')) open++;
                else if (status.includes('progress')) inProgress++;
                else if (status.includes('resolved')) resolved++;
                else if (status.includes('closed')) closed++;
                
                // Check if overdue
                if (ticket.due_date) {
                    const dueDate = new Date(ticket.due_date);
                    if (dueDate < now && (status.includes('open') || status.includes('progress'))) {
                        overdue++;
                    }
                }
                // Trend analysis by month
                const createdDate = new Date(ticket.created_date || ticket.created_at);
                if (!isNaN(createdDate.getTime())) {
                    const monthKey = `${createdDate.getFullYear()}-${String(createdDate.getMonth() + 1).padStart(2, '0')}`;
                    
                    const trendData = trend.get(monthKey) || { 
                        label: monthKey, 
                        created: 0, 
                        resolved: 0, 
                        inProgress: 0 
                    };
                    
                    trendData.created++;
                    if (status.includes('resolved') || status.includes('closed')) trendData.resolved++;
                    if (status.includes('progress')) trendData.inProgress++;
                    trend.set(monthKey, trendData);
                }

                // Category counts
                const category = String(ticket.category_name || ticket.task_category || ticket.category_id || 'Unknown');
                categories.set(category, (categories.get(category) || 0) + 1);

                // Resolution time (only for resolved/closed tickets)
                if (status.includes('resolved') || status.includes('closed')) {
                    const created = new Date(ticket.created_date || ticket.created_at);
                    const updated = new Date(ticket.updated_date || ticket.updated_at || ticket.closed_at || ticket.resolved_at);
                    
                    if (!isNaN(created.getTime()) && !isNaN(updated.getTime())) {
                        const days = Math.max(0, Math.round((updated - created) / (1000 * 60 * 60 * 24)));
                        const monthKey = `${created.getFullYear()}-${String(created.getMonth() + 1).padStart(2, '0')}`;
                        
                        const resData = resolutions.get(monthKey) || { label: monthKey, totalDays: 0, count: 0 };
                        resData.totalDays += days;
                        resData.count++;
                        resolutions.set(monthKey, resData);
                    }
                }

                // Organization ticket counts (last 90 days)
                const orgCreatedDate = new Date(ticket.created_date || ticket.created_at);
                if (orgCreatedDate >= ninetyDaysAgo) {
                    const orgName = String(
                        ticket.org_name || ticket.organization_name || 
                        (ticket.org?.name) || ticket.organization_id || 'Unknown'
                    ).trim();
                    orgCounts.set(orgName, (orgCounts.get(orgName) || 0) + 1);
                }

                // Assigned tickets count
                const hasAssignee = ticket.assignee_info || 
                                   ticket.assigned_to_username || 
                                   ticket.assigned_to_user || 
                                   ticket.assigned_to_user_id ||
                                   ticket.assigned_to ||
                                   (Array.isArray(ticket.assignees) && ticket.assignees.length > 0);
                if (hasAssignee) assignedCount++;
            });

            return {
                total,
                open,
                inProgress,
                resolved,
                closed,
                overdue,
                trend: Array.from(trend.values()).sort((a, b) => a.label.localeCompare(b.label)),
                categories: Array.from(categories.entries())
                    .map(([name, count]) => ({ name, count }))
                    .sort((a, b) => b.count - a.count)
                    .slice(0, CONFIG.MAX_CATEGORIES_DISPLAY),
                resolutions: Array.from(resolutions.values())
                    .map(item => ({ 
                        label: item.label, 
                        value: item.count ? item.totalDays / item.count : 0 
                    }))
                    .sort((a, b) => a.label.localeCompare(b.label)),
                orgCounts: Array.from(orgCounts.entries())
                    .map(([name, count]) => ({ name, count }))
                    .sort((a, b) => b.count - a.count)
                    .slice(0, CONFIG.MAX_CATEGORIES_DISPLAY),
                assignedCount
            };
        }
    };

    // Chart renderers
    const charts = {
        initChart(instance, elementId) {
            if (instance) instance.dispose();
            const el = state.elements[elementId];
            return el && window.echarts ? echarts.init(el) : null;
        },

        renderStatusChart(data) {
            try {
                log.debug('charts:render:status:start', {
                    data: {
                        open: data.open,
                        inProgress: data.inProgress,
                        resolved: data.resolved,
                        closed: data.closed
                    }
                });
                
                const chart = this.initChart(state.charts.status, 'status_pie_chart');
                if (!chart) {
                    log.warn('charts:render:status:no-element', {
                        elementId: 'status_pie_chart'
                    });
                    return;
                }
                
                state.charts.status = chart;
                const total = data.open + data.inProgress + data.resolved + data.closed;

                const option = {
                    backgroundColor: 'transparent',
                    tooltip: {
                        trigger: 'item',
                        formatter: '{b}: {c} ({d}%)',
                        backgroundColor: 'rgba(255, 255, 255, 0.95)',
                        borderColor: 'rgba(99, 102, 241, 0.1)',
                        textStyle: { color: '#1e293b' },
                        extraCssText: 'box-shadow: 0 8px 32px rgba(0,0,0,0.12); border-radius: 12px; padding: 12px;'
                    },

                    series: [{
                        type: 'pie',
                        radius: ['55%', '80%'],
                        center: ['50%', '50%'],
                        avoidLabelOverlap: true,
                        itemStyle: {
                            borderRadius: 12,
                            borderColor: 'white',
                            borderWidth: 3,
                            shadowColor: 'rgba(0, 0, 0, 0.1)',
                            shadowBlur: 8
                        },
                        label: {
                            show: true,
                            formatter: '{b}\n{d}%',
                            color: '#64748b',
                            fontSize: 12,
                            fontWeight: 500,
                            lineHeight: 18
                        },
                        emphasis: {
                            label: {
                                show: true,
                                fontSize: 14,
                                fontWeight: 'bold',
                                color: '#1e293b'
                            },
                            itemStyle: {
                                shadowBlur: 16,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0,0,0,0.2)'
                            }
                        },
                        data: [
                            { value: data.open, name: 'Open', itemStyle: { color: '#10b981' } },
                            { value: data.inProgress, name: 'In Progress', itemStyle: { color: '#f59e0b' } },
                            { value: data.resolved, name: 'Resolved', itemStyle: { color: '#3b82f6' } },
                            { value: data.closed, name: 'Closed', itemStyle: { color: '#ef4444' } }
                        ],
                        animationType: 'scale',
                        animationEasing: 'elasticOut',
                        animationDelay: (idx) => idx * 150
                    }],
                    graphic: [{
                        type: 'text',
                        left: 'center',
                        top: '45%',
                        style: {
                            text: `Total\n${total}`,
                            fill: '#1e293b',
                            fontSize: 14,
                            fontWeight: 'bold',
                            textAlign: 'center',
                            lineHeight: 24
                        }
                    }]
                };

                chart.setOption(option);
                
                // Update total tickets display
                if (state.elements.totalTickets) {
                    state.elements.totalTickets.textContent = utils.formatNumber(total);
                }

                // Update timestamp
                if (state.elements.statusChartUpdate) {
                    state.elements.statusChartUpdate.textContent = 
                        new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
                }
            } catch (error) {
                log.error('charts:render:status:error', {
                    error: error.message,
                    stack: error.stack
                });
            }
        },

        renderPriorityChart(counts) {
            try {
                log.debug('charts:render:priority:start', {
                    counts
                });
                
                const chart = this.initChart(state.charts.priority, 'priority_bar_chart');
                if (!chart) {
                    log.warn('charts:render:priority:no-element', {
                        elementId: 'priority_bar_chart'
                    });
                    return;
                }
                
                state.charts.priority = chart;

                const option = {
                    backgroundColor: 'transparent',
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: { type: 'shadow' },
                        formatter: '{b}: {c} tickets',
                        backgroundColor: 'rgba(255, 255, 255, 0.95)',
                        borderColor: 'rgba(99, 102, 241, 0.1)',
                        textStyle: { color: '#1e293b' },
                        extraCssText: 'box-shadow: 0 8px 32px rgba(0,0,0,0.12); border-radius: 12px; padding: 12px;'
                    },
                    grid: {
                        left: '3%',
                        right: '4%',
                        bottom: '10%',
                        top: '15%',
                        containLabel: true
                    },
                    xAxis: {
                        type: 'category',
                        data: ['Critical', 'High', 'Medium', 'Low'],
                        axisLine: { 
                            lineStyle: { 
                                color: '#e2e8f0',
                                width: 2
                            } 
                        },
                        axisTick: { show: false },
                        axisLabel: {
                            color: '#64748b',
                            fontSize: 12,
                            fontWeight: 600,
                            margin: 12
                        }
                    },
                    yAxis: {
                        type: 'value',
                        axisLine: { show: false },
                        axisTick: { show: false },
                        splitLine: { 
                            lineStyle: { 
                                color: '#f1f5f9',
                                type: 'dashed',
                                width: 1
                            } 
                        },
                        axisLabel: {
                            color: '#64748b',
                            fontSize: 12,
                            fontWeight: 500
                        }
                    },
                    series: [{
                        type: 'bar',
                        data: [
                            { value: counts.critical || 0, itemStyle: { color: '#dc2626' } },
                            { value: counts.high || 0, itemStyle: { color: '#ef4444' } },
                            { value: counts.medium || 0, itemStyle: { color: '#f59e0b' } },
                            { value: counts.low || 0, itemStyle: { color: '#10b981' } }
                        ],
                        itemStyle: {
                            borderRadius: [8, 8, 0, 0],
                            shadowColor: 'rgba(0,0,0,0.15)',
                            shadowBlur: 8,
                            shadowOffsetY: 4
                        },
                        barWidth: '48%',
                        emphasis: {
                            itemStyle: {
                                shadowColor: 'rgba(0,0,0,0.3)',
                                shadowBlur: 12,
                                shadowOffsetY: 6
                            }
                        },
                        label: {
                            show: true,
                            position: 'top',
                            color: '#1e293b',
                            fontSize: 12,
                            fontWeight: 'bold',
                            formatter: '{c}'
                        },
                        animationDelay: (idx) => idx * 200
                    }],
                    animationEasing: 'elasticOut',
                    animationDuration: 1200
                };

                chart.setOption(option);
            } catch (error) {
                log.error('charts:render:priority:error', {
                    error: error.message,
                    stack: error.stack
                });
            }
        },

        renderTrendChart(trendData) {
            if (!window.ApexCharts) {
                log.warn('charts:render:trend:no-library', {
                    message: 'ApexCharts library not available'
                });
                return;
            }
            if (!state.elements.dashboard_ticket_trend_chart) {
                log.warn('charts:render:trend:no-element', {
                    elementId: 'dashboard_ticket_trend_chart'
                });
                return;
            }

            try {
                log.debug('charts:render:trend:start', {
                    trendDataLength: trendData.length
                });
                if (state.charts.trend) {
                    state.charts.trend.destroy();
                }

                const categories = trendData.map(d => d.label);
                const series = [
                    { name: 'Created', data: trendData.map(d => d.created) },
                    { name: 'Resolved', data: trendData.map(d => d.resolved) },
                    { name: 'In Progress', data: trendData.map(d => d.inProgress) }
                ];

                const options = {
                    series,
                    chart: {
                        type: 'line',
                        height: 320,
                        toolbar: { show: false },
                        animations: { enabled: true, easing: 'easeinout', speed: 800 }
                    },
                    colors: ['#10b981', '#3b82f6', '#f59e0b'],
                    dataLabels: { enabled: false },
                    stroke: { curve: 'smooth', width: 3 },
                    xaxis: { 
                        categories,
                        labels: { style: { colors: '#64748b' } }
                    },
                    yaxis: { 
                        labels: { style: { colors: '#64748b' } },
                        min: 0
                    },
                    grid: { borderColor: '#e2e8f0' },
                    legend: { 
                        position: 'top', 
                        labels: { colors: '#64748b' }
                    },
                    tooltip: { 
                        theme: 'light',
                        shared: true
                    }
                };

                state.charts.trend = new ApexCharts(state.elements.dashboard_ticket_trend_chart, options);
                state.charts.trend.render();
            } catch (error) {
                log.error('charts:render:trend:error', {
                    error: error.message,
                    stack: error.stack
                });
            }
        },

        renderCategoryChart(categories) {
            try {
                log.debug('charts:render:category:start', {
                    categoriesLength: categories.length
                });
                
                const chart = this.initChart(state.charts.category, 'dashboard_category_chart');
                if (!chart) {
                    log.warn('charts:render:category:no-element', {
                        elementId: 'dashboard_category_chart'
                    });
                    return;
                }
                
                state.charts.category = chart;

                const option = {
                    tooltip: {
                        trigger: 'item',
                        formatter: '{b}: {c} ({d}%)'
                    },
                    series: [{
                        type: 'pie',
                        radius: ['45%', '70%'],
                        avoidLabelOverlap: false,
                        itemStyle: {
                            borderRadius: 8,
                            borderColor: '#fff',
                            borderWidth: 2
                        },
                        label: {
                            show: true,
                            formatter: '{b}: {c}'
                        },
                        emphasis: {
                            label: {
                                show: true,
                                fontSize: '14',
                                fontWeight: 'bold'
                            }
                        },
                        data: categories.map(cat => ({
                            value: cat.count,
                            name: cat.name,
                            itemStyle: {
                                color: this.getCategoryColor(cat.name)
                            }
                        }))
                    }]
                };

                chart.setOption(option);
            } catch (error) {
                log.error('charts:render:category:error', {
                    error: error.message,
                    stack: error.stack
                });
            }
        },

        getCategoryColor(categoryName) {
            // Generate consistent color based on category name
            const colors = [
                '#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6',
                '#06b6d4', '#84cc16', '#f97316', '#6366f1', '#ec4899'
            ];
            let hash = 0;
            for (let i = 0; i < categoryName.length; i++) {
                hash = categoryName.charCodeAt(i) + ((hash << 5) - hash);
            }
            return colors[Math.abs(hash) % colors.length];
        },

        // Dispose all charts
        disposeAll() {
            Object.values(state.charts).forEach(chart => {
                if (chart) {
                    if (chart.dispose) chart.dispose();
                    if (chart.destroy) chart.destroy();
                }
            });
            state.charts = {
                status: null,
                priority: null,
                trend: null,
                category: null,
                resolution: null,
                orgTickets: null
            };
        },

        // Resize all charts
        resizeAll: utils.debounce(() => {
            Object.values(state.charts).forEach(chart => {
                if (chart) {
                    if (chart.resize) chart.resize();
                }
            });
        }, 250)
    };

    // UI updaters
    const ui = {
        showLoading() {
            document.querySelectorAll('.stat-card').forEach(card => {
                card.classList.add('loading');
            });
        },

        hideLoading() {
            document.querySelectorAll('.stat-card').forEach(card => {
                card.classList.remove('loading');
            });
        },

        updateCounter(elementId, value, duration = 1000) {
            const element = state.elements[elementId];
            if (!element) return;

            const currentValue = parseInt(element.textContent) || 0;
            if (currentValue === value) return;

            const startTime = Date.now();
            const easeOutQuart = (t) => 1 - Math.pow(1 - t, 4);

            const animate = () => {
                const elapsed = Date.now() - startTime;
                const progress = Math.min(elapsed / duration, 1);
                const eased = easeOutQuart(progress);
                const animatedValue = Math.round(currentValue + (value - currentValue) * eased);
                
                element.textContent = utils.formatNumber(animatedValue);

                if (progress < 1) {
                    requestAnimationFrame(animate);
                } else {
                    element.textContent = utils.formatNumber(value);
                    // Add completion animation
                    element.style.animation = 'pulse 0.5s ease-in-out';
                    setTimeout(() => element.style.animation = '', 500);
                }
            };

            requestAnimationFrame(animate);
        },

        updateOrganizationList(organizations) {
            const container = state.elements.org_tickets_list;
            if (!container || !Array.isArray(organizations)) return;

            const maxTickets = Math.max(...organizations.map(org => org.ticket_count || 0), 1);
            
            container.innerHTML = organizations
                .slice(0, CONFIG.MAX_ORGANIZATIONS_DISPLAY)
                .map(org => {
                    const ticketCount = org.ticket_count || 0;
                    const percentage = (ticketCount / maxTickets) * 100;
                    const orgId = org.id || org.org_id || '';
                    const orgName = org.name || 'Unknown Organization';

                    return `
                        <div class="org-item" onclick="window.location='${window.CONTEXT_PATH || ''}/organizations/${orgId}'">
                            <div class="org-name">
                                <i class="bi bi-building me-2 text-muted"></i>
                                ${orgName}
                            </div>
                            <div class="org-stats">
                                <span class="ticket-count">${utils.formatNumber(ticketCount)}</span>
                                <div class="progress" style="width: 100px; height: 6px;">
                                    <div class="progress-bar" style="width: ${percentage}%"></div>
                                </div>
                            </div>
                        </div>
                    `;
                })
                .join('');
        }
    };

    // Data loader
    const loader = {
        async loadAllData() {
            if (state.flags.isFetching) return;
            
            state.flags.isFetching = true;
            ui.showLoading();

            try {
                // Prepare request payload with current filters
                const payload = {
                    start_date: state.filters.dateRange.start,
                    end_date: state.filters.dateRange.end
                };

                const requestOptions = {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                };

                log.info('data:load:start', {
                    payload,
                    timestamp: new Date().toISOString()
                });

                // Fetch data in parallel using new endpoints via POST
                const [dashboardDataResponse, ticketsListResponse] = await Promise.all([
                    api.fetch('/get_system_dashboard_data', requestOptions),
                    api.fetch('/get_tickets_list_for_dashboard', requestOptions)
                ]);

                // Process dashboard data (contains organizations)
                if (dashboardDataResponse.ok) {
                    let dashboardData = dashboardDataResponse.data;
                    
                    // Handle success wrapper if present
                    if (dashboardData?.success !== undefined) {
                        dashboardData = dashboardData.data;
                    }
                    
                    // Process analytics from get_system_dashboard_data
                    const analytics = processors.processAnalyticsData(dashboardData);
                    state.data.analytics = analytics;

                    // Update main counters from analytics data
                    ui.updateCounter('org_count', analytics.organizations?.length || 0);
                    ui.updateCounter('ticket_total_count', analytics.total);
                    ui.updateCounter('status_open_count', analytics.open);
                    ui.updateCounter('status_in_progress_count', analytics.inProgress);
                    ui.updateCounter('status_resolved_count', analytics.resolved);
                    ui.updateCounter('status_closed_count', analytics.closed);
                    ui.updateCounter('overdue_tickets_count', analytics.overdue);
                    
                    // Update organization list
                    if (analytics.organizations?.length > 0) {
                        ui.updateOrganizationList(analytics.organizations);
                    }

                    // Render status chart
                    charts.renderStatusChart({
                        open: analytics.open,
                        inProgress: analytics.inProgress,
                        resolved: analytics.resolved,
                        closed: analytics.closed
                    });

                    // Process and render priority chart
                    const priorityCounts = processors.processPriorityCounts(analytics);
                    ui.updateCounter('priority_high_count', priorityCounts.high);
                    ui.updateCounter('priority_medium_count', priorityCounts.medium);
                    ui.updateCounter('priority_low_count', priorityCounts.low);
                    charts.renderPriorityChart(priorityCounts);
                }

                // Process tickets for detailed analytics (trend, categories, etc.)
                if (ticketsListResponse.ok) {
                    let ticketsResponseData = ticketsListResponse.data;
                    
                    // Handle any potential success wrapper and extract tickets
                    const tickets = Array.isArray(ticketsResponseData) 
                        ? ticketsResponseData 
                        : ticketsResponseData?.tickets || ticketsResponseData?.data || [];
                    
                    state.data.tickets = tickets;
                    
                    // Calculate ticket analytics including trend and categories
                    const detailedAnalytics = processors.computeTicketAnalytics(tickets);
                    
                    // Update my assigned total from tickets list
                    ui.updateCounter('my_assigned_total', detailedAnalytics.assignedCount);
                    
                    // Render trend and category charts
                    charts.renderTrendChart(detailedAnalytics.trend);
                    charts.renderCategoryChart(detailedAnalytics.categories);
                    
                    // Store the last updated time
                    state.data.lastUpdated = new Date();
                }

            } catch (error) {
                log.error('data:load:error', {
                    error: error.message,
                    stack: error.stack
                });
            } finally {
                state.flags.isFetching = false;
                ui.hideLoading();
            }
        },

        async refresh() {
            await this.loadAllData();
        }
    };

    // Theme handler
    const themeHandler = {
        init() {
            const observer = new MutationObserver((mutations) => {
                mutations.forEach((mutation) => {
                    if (mutation.attributeName === 'data-theme') {
                        this.handleThemeChange();
                    }
                });
            });
            
            observer.observe(document.documentElement, { attributes: true });
        },

        handleThemeChange() {
            // Dispose all charts
            charts.disposeAll();
            
            // Re-render charts with new theme
            if (state.data.analytics) {
                charts.renderStatusChart({
                    open: state.data.analytics.open,
                    inProgress: state.data.analytics.inProgress,
                    resolved: state.data.analytics.resolved,
                    closed: state.data.analytics.closed
                });

                const priorityCounts = processors.processPriorityCounts(state.data.analytics);
                charts.renderPriorityChart(priorityCounts);
            }
        }
    };

    // Public API
    return {
        async init() {
            if (state.flags.isInitialized) {
                log.warn('init:already-initialized', {
                    message: 'Dashboard already initialized'
                });
                return;
            }

            log.info('init:start', {
                timestamp: new Date().toISOString()
            });
            
            try {
                // Cache DOM elements
                cacheElements();
                log.debug('init:cache-elements-complete');

                // Verify if we are on the dashboard page
                // If key dashboard elements (charts) are missing, we assume we are on another page
                // and should not run the dashboard logic to avoid errors and unnecessary API calls.
                if (!state.elements.status_pie_chart && !state.elements.dashboard_ticket_trend_chart) {
                    log.info('init:skipped', { message: 'Dashboard elements not found - likely not on dashboard page' });
                    return;
                }

                // Initialize date filter
                dateFilter.init();
                log.debug('init:date-filter-complete');

                // Initialize theme handler
                themeHandler.init();
                log.debug('init:theme-handler-complete');

                // Load initial data
                await loader.loadAllData();
                log.info('init:data-loaded-successfully');
                
                // Set up auto-refresh
                setInterval(() => {
                    if (document.visibilityState === 'visible') {
                        log.debug('auto-refresh:triggered');
                        loader.refresh();
                    }
                }, CONFIG.REFRESH_INTERVAL);
                log.debug('init:auto-refresh-setup', {
                    intervalMs: CONFIG.REFRESH_INTERVAL
                });
                
                // Handle window resize
                window.addEventListener('resize', charts.resizeAll);
                log.debug('init:resize-handler-setup');
                
                // Handle visibility change
                document.addEventListener('visibilitychange', () => {
                    if (document.visibilityState === 'visible') {
                        log.debug('visibility-change:refresh-triggered');
                        loader.refresh();
                    }
                });
                log.debug('init:visibility-handler-setup');
                
                state.flags.isInitialized = true;
                log.info('init:complete', {
                    timestamp: new Date().toISOString()
                });
            } catch (error) {
                log.error('init:failed', {
                    error: error.message,
                    stack: error.stack
                });
            }
        },

        async refresh() {
            await loader.refresh();
        },

        getState() {
            return { ...state.data };
        },

        destroy() {
            // Clean up
            charts.disposeAll();
            window.removeEventListener('resize', charts.resizeAll);
            state.flags.isInitialized = false;
            log.info('destroy:complete', {
                timestamp: new Date().toISOString()
            });
        }
    };
})();

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    if (window.__DASHBOARD_INITIALIZED__) return;
    
    window.__DASHBOARD_INITIALIZED__ = true;
    
    // Test log to verify logging is working
    const logTest = {
        info: (event, data) => {
            try {
                console.log('[Dashboard]', event, JSON.stringify(data, null, 2) ?? '');
            } catch (e) {
                console.log('[Dashboard]', event, 'ERROR_LOGGING_DATA:', e.message);
            }
        }
    };
    logTest.info('dashboard:test-logging', {
        message: 'Logging system initialized successfully',
        timestamp: new Date().toISOString(),
        config: {
            logPrefix: '[Dashboard]',
            logVerbose: true
        }
    });
    
    // Small delay to ensure everything is loaded
    setTimeout(() => {
        Dashboard.init();
    }, 100);
});

// Make Dashboard available globally
window.Dashboard = Dashboard;