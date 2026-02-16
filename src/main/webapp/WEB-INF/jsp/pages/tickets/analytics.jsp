<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String orgName = (String) request.getAttribute("orgName");
    String orgId = (String) request.getAttribute("orgId");
    
    if (orgName == null || orgId == null) {
        java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session.getAttribute("userInfo");
        if (userInfo != null) {
            if (orgName == null) {
                Object nameObj = userInfo.get("org_name");
                if (nameObj == null) nameObj = userInfo.get("organization_name");
                if (nameObj == null) nameObj = userInfo.get("company_name");
                if (nameObj == null) nameObj = userInfo.get("business_name");
                if (nameObj == null) nameObj = userInfo.get("org_code");
                if (nameObj != null) orgName = String.valueOf(nameObj);
            }
            if (orgId == null) {
                Object oid = userInfo.get("org_id");
                if (oid == null) oid = userInfo.get("organization_id");
                if (oid != null) {
                    orgId = String.valueOf(oid);
                }
            }
        }
    }

    if (orgName == null) orgName = "My Organization";
    if (orgId == null) orgId = "0";
%>
<c:set var="orgName" value="<%= orgName %>" />
<c:set var="orgId" value="<%= orgId %>" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/libs/apexcharts/apexcharts.css">
<main class="app-wrapper">
    <div class="container-fluid">
    <style>
        /* Use dashboard.css styles where possible */
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: linear-gradient(135deg, var(--analytics-light) 0%, #f1f5f9 100%);
            min-height: 100vh;
            color: var(--analytics-dark);
        }
        
        .analytics-container {
            padding: 2rem;
            max-width: 100%;
        }
        
        @media (max-width: 768px) {
            .analytics-container {
                padding: 1rem;
            }
        }
        
        /* Header Section - Inspired by dashboard.jsp */
        .analytics-header {
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            border-radius: 24px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            border: none;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
        }
        
        .header-background {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
            z-index: 1;
        }
        
        .header-content {
            position: relative;
            z-index: 2;
        }
        
        .header-title {
            font-size: 2.25rem;
            font-weight: 800;
            color: white;
            margin-bottom: 0.5rem;
        }
        
        .header-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.125rem;
            margin-bottom: 1.5rem;
        }
        
        .header-badges {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .header-badge {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 50px;
            padding: 0.75rem 1.25rem;
            color: white;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
        }
        
        .header-info-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            color: white;
        }
        
        /* Stats Styling */
        .stat-value-analytics {
            font-size: 2.75rem;
            font-weight: 800;
            line-height: 1;
            margin-bottom: 0.5rem;
            color: var(--analytics-dark);
            font-feature-settings: "tnum";
            font-variant-numeric: tabular-nums;
        }
        
        /* Recent Tickets Table */
        .recent-tickets-analytics {
            border-radius: 20px;
            overflow: hidden;
        }
        
        .recent-tickets-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .view-all-btn-analytics {
            padding: 0.5rem 1rem;
            background: rgba(99, 102, 241, 0.1);
            color: #6366f1;
            border-radius: 10px;
            font-size: 0.875rem;
            font-weight: 500;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
        }
        
        .view-all-btn-analytics:hover {
            background: rgba(99, 102, 241, 0.15);
            text-decoration: none;
            color: #6366f1;
        }
        
        /* Loading States */
        .loading-shimmer-analytics {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 1.5s infinite;
            border-radius: 8px;
        }
        
        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .analytics-header {
                padding: 1.5rem;
            }
            
            .header-title {
                font-size: 1.75rem;
            }
        }
        
        @media (max-width: 576px) {
            .stat-value-analytics {
                font-size: 2.25rem;
            }
            
            .header-badges {
                flex-direction: column;
            }
        }
        
        /* Scrollbar Styling */
        .analytics-container::-webkit-scrollbar {
            width: 8px;
        }
        
        .analytics-container::-webkit-scrollbar-track {
            background: transparent;
        }
        
        .analytics-container::-webkit-scrollbar-thumb {
            background: rgba(99, 102, 241, 0.3);
            border-radius: 4px;
        }
        
        .analytics-container::-webkit-scrollbar-thumb:hover {
            background: rgba(99, 102, 241, 0.5);
        }
        
        /* Animation for counters */
        @keyframes countUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .stat-value-analytics {
            animation: countUp 0.6s ease-out;
        }
    </style>
</head>
<body>
    <div class="analytics-container">
        <!-- Header Section -->
        <header class="analytics-header">
            <div class="header-background"></div>
            <div class="header-content">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h1 class="header-title">${orgName} Analytics</h1>
                        <p class="header-subtitle">Comprehensive insights and performance metrics for your organization</p>
                        <div class="header-badges">
                            <div class="header-badge">
                                <i class="bi bi-building"></i>
                                Organization Dashboard
                            </div>
                            <div class="header-badge">
                                <i class="bi bi-calendar-range"></i>
                                <span id="dateRangeBadge">Last 30 days</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 mt-4 mt-lg-0">
                        <div class="header-info-card">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-person-circle fs-4"></i>
                                    <div>
                                        <div class="small opacity-75">Contact Person</div>
                                        <div class="fw-bold"><c:out value="${sessionScope.userName}" /></div>
                                    </div>
                                </div>
                            </div>
                            <div class="border-top pt-2 mt-2 border-opacity-25">
                                <small class="opacity-75">Last updated: <span id="lastUpdatedTime">Just now</span></small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Date Range Filter -->
        <div class="content-card p-4 rounded-4 mb-4">
            <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">
                <div class="h6 mb-0">
                    <i class="bi bi-calendar-range text-primary me-2"></i>
                    Analytics Date Range
                </div>
                <div class="d-flex gap-2 align-items-end">
                    <div>
                        <label for="dateRangeStart" class="form-label small text-muted mb-1">Start Date</label>
                        <input type="date" id="dateRangeStart" class="form-control form-control-sm">
                    </div>
                    <div>
                        <label for="dateRangeEnd" class="form-label small text-muted mb-1">End Date</label>
                        <input type="date" id="dateRangeEnd" class="form-control form-control-sm">
                    </div>
                    <div class="d-flex gap-1">
                        <button id="applyFilters" class="btn btn-primary btn-sm" title="Apply filters">
                            <i class="bi bi-filter me-1"></i> Apply
                        </button>
                        <button id="clearDateRange" class="btn btn-outline-secondary btn-sm" title="Clear date range">
                            <i class="bi bi-x-lg"></i>
                        </button>
                        <button id="refreshDashboard" class="btn btn-outline-secondary btn-sm" title="Refresh dashboard">
                            <i class="bi bi-arrow-clockwise"></i>
                        </button>
                        <button id="exportData" class="btn btn-outline-secondary btn-sm" title="Export data">
                            <i class="bi bi-download"></i>
                        </button>
                    </div>
                </div>
            </div>
            <div class="preset-buttons-analytics mt-3">
                <button class="preset-btn-analytics btn btn-outline-primary btn-sm rounded-pill px-3 active" data-days="7">Last 7 days</button>
                <button class="preset-btn-analytics btn btn-outline-primary btn-sm rounded-pill px-3" data-days="30">Last 30 days</button>
                <button class="preset-btn-analytics btn btn-outline-primary btn-sm rounded-pill px-3" data-days="90">Last 90 days</button>
                <button class="preset-btn-analytics btn btn-outline-primary btn-sm rounded-pill px-3" data-days="365">Last year</button>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="row g-3 mb-4">
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-ticket-detailed"></i>
                        </div>
                        <div class="stat-trend-badge">
                            <i class="bi bi-ticket-perforated"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="stat_total">0</div>
                        <div class="stat-label">Total Tickets</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-primary" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-record-circle"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 12%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="stat_open">0</div>
                        <div class="stat-label">Open Tickets</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-success" style="width: 65%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-lightning-charge"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 8%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="stat_in_progress">0</div>
                        <div class="stat-label">In Progress</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-warning" style="width: 45%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 15%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="stat_resolved">0</div>
                        <div class="stat-label">Resolved</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-info" style="width: 30%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                        <div class="stat-trend-badge down">
                            <i class="bi bi-arrow-down"></i> 5%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="stat_overdue">0</div>
                        <div class="stat-label">Overdue</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-danger" style="width: 20%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon bg-secondary bg-opacity-10 text-secondary">
                            <i class="bi bi-x-circle"></i>
                        </div>
                        <div class="stat-trend-badge">
                            <i class="bi bi-dash"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="stat_closed">0</div>
                        <div class="stat-label">Closed</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-secondary" style="width: 50%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Grid -->
        <div class="row g-3 mb-4">
            <!-- Ticket Trends -->
            <div class="col-xl-8">
                <div class="chart-card content-card">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-graph-up me-2"></i>
                            Ticket Trends Over Time
                        </h4>
                        <div class="btn-group btn-group-sm" role="group">
                            <button type="button" class="btn btn-outline-secondary active" data-range="week">Week</button>
                            <button type="button" class="btn btn-outline-secondary" data-range="month">Month</button>
                            <button type="button" class="btn btn-outline-secondary" data-range="quarter">Quarter</button>
                            <button type="button" class="btn btn-outline-secondary" data-range="year">Year</button>
                        </div>
                    </div>
                    <div class="chart-card-body">
                        <div id="ticketTrendChart" style="height: 320px;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <div class="d-flex justify-content-between">
                            <small class="text-muted">Showing ticket volume trends over time</small>
                            <small class="text-muted">Updated: <span id="trendChartUpdate">just now</span></small>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Status Distribution -->
            <div class="col-xl-4 col-lg-6">
                <div class="chart-card content-card">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-pie-chart me-2"></i>
                            Status Distribution
                        </h4>
                        <div class="time-filter">
                            <select class="form-select form-select-sm">
                                <option selected>Current</option>
                                <option>Last Week</option>
                                <option>Last Month</option>
                            </select>
                        </div>
                    </div>
                    <div class="chart-card-body">
                        <div id="statusPieChart" style="height: 100%;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <small class="text-muted">Distribution of tickets by current status</small>
                    </div>
                </div>
            </div>
            
            <!-- Priority Breakdown -->
            <div class="col-xl-6 col-lg-6">
                <div class="chart-card content-card">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-bar-chart me-2"></i>
                            Priority Breakdown
                        </h4>
                    </div>
                    <div class="chart-card-body">
                        <div id="priorityChart" style="height: 320px;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <small class="text-muted">Priority level distribution across tickets</small>
                    </div>
                </div>
            </div>
            
            <!-- Category Distribution -->
            <div class="col-xl-6 col-lg-12">
                <div class="chart-card content-card">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-grid-3x3-gap me-2"></i>
                            Category Distribution
                        </h4>
                    </div>
                    <div class="chart-card-body">
                        <div id="categoryChart" style="height: 320px;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <small class="text-muted">Top categories by ticket volume</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Tickets -->
        <div class="recent-tickets-analytics content-card">
            <div class="recent-tickets-header">
                <h3 class="chart-title-analytics">
                    <i class="bi bi-clock-history"></i>
                    Recent Ticket Activity
                </h3>
                <a href="${pageContext.request.contextPath}/tickets" class="view-all-btn-analytics">
                    <i class="bi bi-ticket-perforated"></i>
                    View All Tickets
                </a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Ticket ID</th>
                            <th>Subject</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Created Date</th>
                            <th>Last Updated</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="recentTicketsTable">
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-2 text-muted">Loading recent tickets...</p>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/assets/libs/apexcharts/apexcharts.min.js"></script>
    <script>window.CONTEXT_PATH='${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/assets/js/ticket_analytics.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Update last updated time
            function updateLastUpdated() {
                const now = new Date();
                const timeString = now.toLocaleTimeString('en-US', { 
                    hour: '2-digit', 
                    minute: '2-digit'
                });
                const dateString = now.toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric'
                });
                const lastUpdatedEl = document.getElementById('lastUpdatedTime');
                const trendUpdateEl = document.getElementById('trendChartUpdate');
                if (lastUpdatedEl) lastUpdatedEl.textContent = `${dateString} at ${timeString}`;
                if (trendUpdateEl) trendUpdateEl.textContent = `${dateString} ${timeString}`;
            }
            
            updateLastUpdated();
            setInterval(updateLastUpdated, 60000);
            
            // Add loading animation to counters
            document.querySelectorAll('.stat-value-analytics, .priority-count-analytics').forEach(el => {
                el.innerHTML = '<span class="loading-shimmer-analytics" style="display: inline-block; width: 80px; height: 40px; vertical-align: middle;"></span>';
            });
        });
    </script>
    </div>
</main>