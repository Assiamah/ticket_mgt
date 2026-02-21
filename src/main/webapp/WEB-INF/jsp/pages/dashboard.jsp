<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/report_modal.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- PDF Generation Libraries -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>

<main class="app-wrapper">
    <div class="container-fluid">
        <!-- Modern Header with Gradient -->
        <div class="dashboard-header mb-4 p-5 rounded-4 position-relative overflow-hidden border-0" 
             style="background: linear-gradient(135deg, var(--primary-color) 0%, #4f46e5 100%);">
            <div class="header-background-pattern"></div>
            <div class="row align-items-center position-relative z-2">
                <div class="col-md-8">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="header-icon rounded-3 p-3 bg-white bg-opacity-20">
                            <i class="bi bi-speedometer2 text-white fs-2"></i>
                        </div>
                        <div>
                            <h1 class="display-6 fw-bold mb-1 text-white">SpatialEdge Analytics</h1>
                            <p class="text-white text-opacity-85 mb-0 fs-5">Welcome back to your System Owner Dashboard</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3 mt-3">
                        <div class="badge bg-white bg-opacity-20 text-white px-3 py-2 rounded-pill">
                            <i class="bi bi-people-fill me-2"></i>
                            <span id="org_count">0</span> Organizations Active
                        </div>
                        <div class="badge bg-white bg-opacity-20 text-white px-3 py-2 rounded-pill">
                            <i class="bi bi-ticket-perforated me-2"></i>
                            <span id="ticket_total_count">0</span> Total Tickets
                        </div>
                    </div>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <div class="content-card p-3 mb-0">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <i class="bi bi-calendar3 text-primary fs-4"></i>
                            </div>
                            <div class="text-end">
                                <div class="text-muted small">Today is</div>
                                <div id="currentDate" class="fw-bold text-dark"></div>
                            </div>
                        </div>
                        <div class="mt-2 pt-2 border-top border-opacity-10">
                            <small class="text-muted">Last updated: <span id="lastUpdatedTime">Just now</span></small>
                        </div>
                        <div class="mt-3">
                            <button id="openReportModal" class="btn btn-primary w-100 rounded-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#reportModal">
                                <i class="bi bi-file-earmark-bar-graph me-2"></i>Generate Report
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Stats Grid -->
        <div class="row g-3 mb-4">
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--primary-color);">
                            <i class="bi bi-play-circle"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 12%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="status_open_count">0</div>
                        <div class="stat-label">Open Tasks</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-primary" style="width: 65%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--warning-color);">
                            <i class="bi bi-lightning-charge"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 15%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="status_in_progress_count">0</div>
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
                        <div class="stat-icon" style="color: var(--info-color);">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 20%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="status_resolved_count">0</div>
                        <div class="stat-label">Resolved</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-info" style="width: 85%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--danger-color);">
                            <i class="bi bi-x-circle"></i>
                        </div>
                        <div class="stat-trend-badge down">
                            <i class="bi bi-arrow-down"></i> 3%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="status_closed_count">0</div>
                        <div class="stat-label">Closed</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-danger" style="width: 30%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--danger-color);">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                        <div class="stat-trend-badge down">
                            <i class="bi bi-arrow-down"></i> 10%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="overdue_tickets_count">0</div>
                        <div class="stat-label">Overdue</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-danger" style="width: 25%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--primary-color);">
                            <i class="bi bi-person-check"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 2%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="my_assigned_total">0</div>
                        <div class="stat-label">My Tasks</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-primary" style="width: 60%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Date Range Filter -->
        <div class="content-card p-4 mb-4">
            <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">
                <div class="h6 mb-0">
                    <i class="bi bi-calendar-range text-primary me-2"></i>
                    Data Date Range
                </div>
                <div class="d-flex gap-2">
                    <div>
                        <label for="dateRangeStart" class="form-label small text-muted mb-1">Start Date</label>
                        <input type="date" id="dateRangeStart" class="form-control form-control-sm">
                    </div>
                    <div>
                        <label for="dateRangeEnd" class="form-label small text-muted mb-1">End Date</label>
                        <input type="date" id="dateRangeEnd" class="form-control form-control-sm">
                    </div>
                    <div class="align-self-end">
                        <div class="d-flex gap-1">
                            <button id="applyDateFilter" class="btn btn-primary btn-sm">
                                <i class="bi bi-filter me-1"></i> Apply
                            </button>
                            <button id="resetDateFilter" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-arrow-clockwise"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Priority Distribution Cards -->
        <!-- <div class="row g-3 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="priority-card priority-high">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <div class="priority-label">High Priority</div>
                            <div class="priority-number" id="priority_high_count">0</div>
                            <div class="priority-trend up">
                                <i class="bi bi-arrow-up"></i> 7% increase
                            </div>
                        </div>
                        <div class="priority-icon">
                            <i class="bi bi-arrow-up"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="priority-card priority-medium">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <div class="priority-label">Medium Priority</div>
                            <div class="priority-number" id="priority_medium_count">0</div>
                            <div class="priority-trend up">
                                <i class="bi bi-arrow-up"></i> 4% increase
                            </div>
                        </div>
                        <div class="priority-icon">
                            <i class="bi bi-arrow-right"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="priority-card priority-low">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <div class="priority-label">Low Priority</div>
                            <div class="priority-number" id="priority_low_count">0</div>
                            <div class="priority-trend down">
                                <i class="bi bi-arrow-down"></i> 1% decrease
                            </div>
                        </div>
                        <div class="priority-icon">
                            <i class="bi bi-arrow-down"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="priority-card priority-critical">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <div class="priority-label">Critical</div>
                            <div class="priority-number">12</div>
                            <div class="priority-trend up">
                                <i class="bi bi-arrow-up"></i> 3% increase
                            </div>
                        </div>
                        <div class="priority-icon">
                            <i class="bi bi-exclamation-octagon"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div> -->

        <!-- Charts Section -->
        <div class="row g-3 mb-4">
            <div class="col-xl-4 col-lg-6">
                <div class="content-card chart-card mb-0">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-pie-chart me-2"></i>
                            Status Distribution
                        </h4>
                        <div class="time-filter">
                            <select class="form-select form-select-sm">
                                <option>This Week</option>
                                <option selected>This Month</option>
                                <option>This Quarter</option>
                                <option>This Year</option>
                            </select>
                        </div>
                    </div>
                    <div class="chart-card-body">
                        <div id="status_pie_chart" style="width: 100%; height: 100%;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <div class="d-flex justify-content-between">
                            <small class="text-muted">Total: <strong id="totalTickets">0</strong> tickets</small>
                            <small class="text-muted">Updated: <span id="statusChartUpdate">just now</span></small>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-4 col-lg-6">
                <div class="content-card chart-card mb-0">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-bar-chart me-2"></i>
                            Priority Breakdown
                        </h4>
                        <div class="time-filter">
                            <select class="form-select form-select-sm">
                                <option>This Week</option>
                                <option selected>This Month</option>
                                <option>This Quarter</option>
                                <option>This Year</option>
                            </select>
                        </div>
                    </div>
                    <div class="chart-card-body">
                        <div id="priority_bar_chart" style="width: 100%; height: 100%;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <small class="text-muted">Showing priority distribution across all tickets</small>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-4 col-lg-12">
                <div class="content-card chart-card mb-0">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-grid-3x3-gap me-2"></i>
                            Category Distribution
                        </h4>
                    </div>
                    <div class="chart-card-body">
                        <div id="dashboard_category_chart" style="width: 100%; height: 300px;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <small class="text-muted">Top categories by ticket volume</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Full Width Charts -->
        <div class="row g-3 mb-4">
            <div class="col-xl-8">
                <div class="content-card chart-card mb-0">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-graph-up me-2"></i>
                            Ticket Trends Over Time
                        </h4>
                        <div class="btn-group btn-group-sm" role="group">
                            <button type="button" class="btn btn-outline-secondary active">Week</button>
                            <button type="button" class="btn btn-outline-secondary">Month</button>
                            <button type="button" class="btn btn-outline-secondary">Quarter</button>
                            <button type="button" class="btn btn-outline-secondary">Year</button>
                        </div>
                    </div>
                    <div class="chart-card-body">
                        <div id="dashboard_ticket_trend_chart" style="height: 320px;"></div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-4">
                <div class="content-card chart-card mb-0">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-building me-2"></i>
                            Top Organizations
                        </h4>
                        <small class="text-muted">Last 90 days</small>
                    </div>
                    <div class="chart-card-body">
                        <div class="org-list" id="org_tickets_list">
                            <!-- Dynamic content will be loaded here -->
                            <div class="org-item">
                                <div class="org-name">Loading...</div>
                                <div class="org-stats">
                                    <span class="ticket-count">0</span>
                                    <div class="progress" style="width: 100px; height: 6px;">
                                        <div class="progress-bar" style="width: 0%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        
    </div>
</main>

<!-- Report Generation Modal Component -->
<jsp:include page="../components/report_modal.jsp" />

<script src="${pageContext.request.contextPath}/assets/libs/echarts/echarts.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script>window.CONTEXT_PATH='${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/report_modal.js?v=1.1"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Enhanced date display
        const dateOptions = { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };
        const today = new Date();
        const dateEl = document.getElementById('currentDate');
        if (dateEl) {
            dateEl.textContent = today.toLocaleDateString('en-US', dateOptions);
        }
        
        // Update time function
        function updateLastUpdated() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('en-US', { 
                hour: '2-digit', 
                minute: '2-digit',
                second: '2-digit'
            });
            document.getElementById('lastUpdatedTime').textContent = timeString;
        }
        
        // Update every minute
        updateLastUpdated();
        setInterval(updateLastUpdated, 60000);
        
        // Add hover effects
        document.querySelectorAll('.stat-card, .priority-card').forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'translateY(-5px)';
            });
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'translateY(0)';
            });
        });
        
        // Add loading animation
        document.querySelectorAll('.stat-number').forEach(el => {
            el.innerHTML = '<span class="loading-dots"><span>.</span><span>.</span><span>.</span></span>';
        });
    });
</script>
