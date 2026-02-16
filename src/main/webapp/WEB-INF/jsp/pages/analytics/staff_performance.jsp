<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff_performance.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

<main class="app-wrapper performance-dashboard">
    <div class="container-fluid">
        <!-- Enhanced Header with Stats -->
        <div class="dashboard-header mb-4">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <div class="d-flex align-items-center gap-3">
                        <div class="header-icon rounded-3 bg-primary bg-opacity-10 p-3">
                            <i class="bi bi-graph-up-arrow text-primary fs-3"></i>
                        </div>
                        <div>
                            <h1 class="page-title mb-1 fw-bold">Staff Performance</h1>
                            <p class="page-subtitle text-muted mb-0 d-flex align-items-center gap-2">
                                <i class="bi bi-bar-chart-line text-primary"></i>
                                Monitor workload distribution and job performance metrics
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="header-actions d-flex align-items-center gap-3 justify-content-end">
                        <div class="position-relative search-wrapper">
                            <i class="bi bi-search position-absolute top-50 translate-middle-y ms-3"></i>
                            <input type="text" id="staff_search" class="form-control ps-5 search-input" 
                                   placeholder="Search staff by name or role...">
                        </div>
                        <button class="btn btn-outline-primary d-flex align-items-center gap-2" 
                                data-bs-toggle="modal" data-bs-target="#exportModal">
                            <i class="bi bi-download"></i>
                            <span class="d-none d-md-inline">Export</span>
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Quick Stats Cards -->
            <div class="row g-3 mt-4">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card stat-card-primary">
                        <div class="stat-icon">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div class="stat-content">
                            <h3 class="stat-value" id="totalStaffCount">0</h3>
                            <p class="stat-label">Active Staff</p>
                        </div>
                        <div class="stat-trend text-success">
                            <i class="bi bi-arrow-up-short"></i>
                            <span>12%</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card stat-card-success">
                        <div class="stat-icon">
                            <i class="bi bi-check-circle-fill"></i>
                        </div>
                        <div class="stat-content">
                            <h3 class="stat-value" id="totalCompletedJobs">0</h3>
                            <p class="stat-label">Completed Jobs</p>
                        </div>
                        <div class="stat-trend text-success">
                            <i class="bi bi-arrow-up-short"></i>
                            <span>8%</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card stat-card-warning">
                        <div class="stat-icon">
                            <i class="bi bi-clock-fill"></i>
                        </div>
                        <div class="stat-content">
                            <h3 class="stat-value" id="totalPendingJobs">0</h3>
                            <p class="stat-label">Pending Jobs</p>
                        </div>
                        <div class="stat-trend text-danger">
                            <i class="bi bi-arrow-down-short"></i>
                            <span>3%</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card stat-card-danger">
                        <div class="stat-icon">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                        </div>
                        <div class="stat-content">
                            <h3 class="stat-value" id="totalOverdueJobs">0</h3>
                            <p class="stat-label">Overdue Jobs</p>
                        </div>
                        <div class="stat-trend text-warning">
                            <i class="bi bi-arrow-up-short"></i>
                            <span>5%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar card border-0 shadow-sm mb-4">
            <div class="card-body p-3">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-muted small"><i class="bi bi-funnel"></i> Filters:</span>
                            <select class="form-select form-select-sm border-0 bg-light w-auto" id="roleFilter">
                                <option value="">All Roles</option>
                                <option value="admin">Administrator</option>
                                <option value="support">Support Agent</option>
                                <option value="technician">Technician</option>
                                <option value="manager">Manager</option>
                            </select>
                            <select class="form-select form-select-sm border-0 bg-light w-auto" id="departmentFilter">
                                <option value="">All Departments</option>
                                <option value="it">IT</option>
                                <option value="hr">HR</option>
                                <option value="finance">Finance</option>
                                <option value="operations">Operations</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-4 text-center">
                        <div class="btn-group btn-group-sm" role="group">
                            <input type="radio" class="btn-check" name="workloadFilter" id="filterAll" checked>
                            <label class="btn btn-outline-secondary" for="filterAll">All</label>
                            <input type="radio" class="btn-check" name="workloadFilter" id="filterHigh">
                            <label class="btn btn-outline-danger" for="filterHigh">High Workload</label>
                            <input type="radio" class="btn-check" name="workloadFilter" id="filterMedium">
                            <label class="btn btn-outline-warning" for="filterMedium">Medium</label>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <button class="btn btn-sm btn-light me-2" onclick="refreshData()">
                            <i class="bi bi-arrow-clockwise"></i> Refresh
                        </button>
                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#insightsModal">
                            <i class="bi bi-graph-up"></i> View Insights
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Staff Table -->
        <div class="card border-0 shadow-sm table-card">
            <div class="card-header bg-white border-0 py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0 fw-semibold">
                        <i class="bi bi-table me-2"></i>Staff Performance Overview
                    </h5>
                    <div class="d-flex align-items-center gap-2">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="autoRefreshToggle">
                            <label class="form-check-label small" for="autoRefreshToggle">Auto-refresh</label>
                        </div>
                        <select class="form-select form-select-sm w-auto" id="rowsPerPage">
                            <option value="10">10 rows</option>
                            <option value="25">25 rows</option>
                            <option value="50">50 rows</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="staffTable">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4 py-3 border-top-0">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="selectAllStaff">
                                    </div>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark">
                                    <a href="#" class="text-decoration-none text-dark sortable" data-sort="name">
                                        Staff Member <i class="bi bi-arrow-down-up ms-1"></i>
                                    </a>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark">
                                    <a href="#" class="text-decoration-none text-dark sortable" data-sort="role">
                                        Role & Department <i class="bi bi-arrow-down-up ms-1"></i>
                                    </a>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark text-center">
                                    <a href="#" class="text-decoration-none text-dark sortable" data-sort="total">
                                        Total Jobs <i class="bi bi-arrow-down-up ms-1"></i>
                                    </a>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark text-center">
                                    <a href="#" class="text-decoration-none text-dark sortable" data-sort="completed">
                                        Completed <i class="bi bi-arrow-down-up ms-1"></i>
                                    </a>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark text-center">
                                    <a href="#" class="text-decoration-none text-dark sortable" data-sort="pending">
                                        Pending <i class="bi bi-arrow-down-up ms-1"></i>
                                    </a>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark text-center">
                                    <a href="#" class="text-decoration-none text-dark sortable" data-sort="overdue">
                                        Overdue <i class="bi bi-arrow-down-up ms-1"></i>
                                    </a>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark text-center">
                                    <a href="#" class="text-decoration-none text-dark sortable" data-sort="workload">
                                        Workload <i class="bi bi-arrow-down-up ms-1"></i>
                                    </a>
                                </th>
                                <th class="py-3 border-top-0 fw-semibold text-dark text-center">Performance</th>
                                <th class="py-3 border-top-0 fw-semibold text-dark text-center pe-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="staffTableBody">
                            <!-- Loading skeleton -->
                            <tr class="loading-row">
                                <td colspan="10" class="text-center py-5">
                                    <div class="d-flex flex-column align-items-center">
                                        <div class="spinner-border text-primary mb-3" role="status" style="width: 3rem; height: 3rem;">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                        <h5 class="mb-2">Loading staff performance data</h5>
                                        <p class="text-muted mb-0">Fetching real-time metrics and analytics...</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer bg-white border-top py-3">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center gap-3">
                            <span class="text-muted small" id="selectedCountText">0 staff selected</span>
                            <div class="btn-group" id="bulkActionsGroup" style="display: none;">
                                <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                    Bulk Actions
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#" onclick="bulkExport()">
                                        <i class="bi bi-download me-2"></i>Export Selected
                                    </a></li>
                                    <li><a class="dropdown-item" href="#" onclick="bulkAssignJobs()">
                                        <i class="bi bi-send me-2"></i>Assign Jobs
                                    </a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="#" onclick="bulkNotify()">
                                        <i class="bi bi-bell me-2"></i>Send Reminder
                                    </a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="text-muted small" id="paginationInfo">
                                Showing <span id="showingStart" class="fw-semibold">0</span>-<span id="showingEnd" class="fw-semibold">0</span> 
                                of <span id="totalStaff" class="fw-semibold">0</span> staff members
                            </div>
                            <nav aria-label="Staff pagination">
                                <ul class="pagination pagination-sm mb-0" id="staffPagination">
                                    <!-- Pagination will be populated here -->
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Enhanced Right Drawer -->
<div class="offcanvas offcanvas-end drawer-job-management" tabindex="-1" id="jobDrawer" 
     aria-labelledby="jobDrawerLabel" style="width: 650px;">
    <div class="offcanvas-header border-bottom bg-gradient-primary text-white">
        <div class="d-flex align-items-center gap-3">
            <div class="avatar-lg rounded-circle bg-white text-primary d-flex align-items-center 
                        justify-content-center fw-bold shadow-sm" id="drawerAvatar">
                <!-- Initials -->
            </div>
            <div class="flex-grow-1">
                <h5 class="offcanvas-title mb-1" id="drawerStaffName">Staff Name</h5>
                <p class="mb-0 small opacity-75" id="drawerStaffRole">Role • Department</p>
            </div>
        </div>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0 d-flex flex-column">
        <!-- Stats Summary -->
        <div class="p-4 border-bottom bg-light">
            <div class="row g-3">
                <div class="col-3">
                    <div class="stat-summary stat-summary-total">
                        <div class="stat-number" id="drawerTotal">0</div>
                        <div class="stat-label">Total Jobs</div>
                        <div class="stat-progress">
                            <div class="progress" style="height: 4px;">
                                <div class="progress-bar" role="progressbar" style="width: 100%"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-3">
                    <div class="stat-summary stat-summary-completed">
                        <div class="stat-number" id="drawerCompleted">0</div>
                        <div class="stat-label">Completed</div>
                        <div class="stat-progress">
                            <div class="progress" style="height: 4px;">
                                <div class="progress-bar bg-success" role="progressbar" style="width: 75%"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-3">
                    <div class="stat-summary stat-summary-pending">
                        <div class="stat-number" id="drawerPending">0</div>
                        <div class="stat-label">Pending</div>
                        <div class="stat-progress">
                            <div class="progress" style="height: 4px;">
                                <div class="progress-bar bg-warning" role="progressbar" style="width: 50%"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-3">
                    <div class="stat-summary stat-summary-overdue">
                        <div class="stat-number" id="drawerOverdue">0</div>
                        <div class="stat-label">Overdue</div>
                        <div class="stat-progress">
                            <div class="progress" style="height: 4px;">
                                <div class="progress-bar bg-danger" role="progressbar" style="width: 25%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Performance Metrics -->
            <div class="mt-4">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="mb-0 fw-semibold">Performance Score</h6>
                    <span class="badge bg-primary rounded-pill" id="performanceScore">0/100</span>
                </div>
                <div class="progress" style="height: 10px;">
                    <div class="progress-bar bg-gradient-primary" role="progressbar" style="width: 85%" 
                         id="performanceBar"></div>
                </div>
            </div>
        </div>

        <!-- Filters & Actions Toolbar -->
        <div class="p-3 border-bottom bg-white sticky-top" style="z-index: 1020;">
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex gap-2 align-items-center">
                    <div class="input-group input-group-sm" style="width: 250px;">
                        <span class="input-group-text bg-transparent border-end-0">
                            <i class="bi bi-funnel"></i>
                        </span>
                        <select class="form-select form-select-sm border-start-0 ps-0" id="jobStatusFilter">
                            <option value="">All Statuses</option>
                            <option value="open">Open</option>
                            <option value="in_progress">In Progress</option>
                            <option value="resolved">Resolved</option>
                            <option value="closed">Closed</option>
                        </select>
                    </div>
                    <div class="input-group input-group-sm" style="width: 200px;">
                        <span class="input-group-text bg-transparent border-end-0">
                            <i class="bi bi-flag"></i>
                        </span>
                        <select class="form-select form-select-sm border-start-0 ps-0" id="jobPriorityFilter">
                            <option value="">All Priorities</option>
                            <option value="high">High</option>
                            <option value="medium">Medium</option>
                            <option value="low">Low</option>
                        </select>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-sm btn-outline-secondary d-flex align-items-center gap-1" 
                            onclick="clearJobFilters()">
                        <i class="bi bi-x-circle"></i> Clear
                    </button>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-primary dropdown-toggle d-flex align-items-center gap-1" 
                                type="button" data-bs-toggle="dropdown" aria-expanded="false" 
                                id="bulkActionsBtn" disabled>
                            <i class="bi bi-check-square"></i>
                            <span id="selectedCountBadge">0 Selected</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#" id="bulkReassignBtn">
                                <i class="bi bi-person-badge me-2"></i>Reassign Selected
                            </a></li>
                            <li><a class="dropdown-item" href="#" id="bulkStatusBtn">
                                <i class="bi bi-arrow-repeat me-2"></i>Update Status
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#" id="bulkPriorityBtn">
                                <i class="bi bi-flag me-2"></i>Change Priority
                            </a></li>
                            <li><a class="dropdown-item text-danger" href="#" id="bulkArchiveBtn">
                                <i class="bi bi-archive me-2"></i>Archive Selected
                            </a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Jobs List with Enhanced Design -->
        <div class="flex-grow-1 overflow-auto p-3" id="jobsListContainer">
            <div class="text-center py-5">
                <div class="empty-state">
                    <div class="empty-state-icon mb-3">
                        <i class="bi bi-clipboard-data fs-1"></i>
                    </div>
                    <h5 class="fw-semibold mb-2">No jobs selected</h5>
                    <p class="text-muted mb-4">Select a staff member from the table to view their assigned jobs</p>
                    <div class="d-flex justify-content-center gap-2">
                        <button class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-question-circle me-1"></i> Learn more
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Quick Stats Footer -->
        <div class="border-top p-3 bg-light">
            <div class="row g-2 text-center">
                <div class="col">
                    <div class="small text-muted">Avg. Completion Time</div>
                    <div class="fw-semibold" id="avgCompletionTime">--</div>
                </div>
                <div class="col border-start">
                    <div class="small text-muted">SLA Compliance</div>
                    <div class="fw-semibold" id="slaCompliance">--</div>
                </div>
                <div class="col border-start">
                    <div class="small text-muted">Customer Rating</div>
                    <div class="fw-semibold" id="customerRating">--</div>
                </div>
                <div class="col border-start">
                    <div class="small text-muted">Last Updated</div>
                    <div class="fw-semibold" id="lastUpdated">Just now</div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Export Modal -->
<div class="modal fade" id="exportModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title d-flex align-items-center gap-2">
                    <i class="bi bi-download text-primary"></i>
                    Export Performance Data
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-4">
                    <label class="form-label fw-semibold">Export Format</label>
                    <div class="d-flex gap-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="exportFormat" id="formatCSV" checked>
                            <label class="form-check-label d-flex align-items-center gap-2" for="formatCSV">
                                <i class="bi bi-filetype-csv fs-5 text-success"></i>
                                <div>
                                    <div class="fw-semibold">CSV</div>
                                    <small class="text-muted">Excel compatible</small>
                                </div>
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="exportFormat" id="formatPDF">
                            <label class="form-check-label d-flex align-items-center gap-2" for="formatPDF">
                                <i class="bi bi-filetype-pdf fs-5 text-danger"></i>
                                <div>
                                    <div class="fw-semibold">PDF</div>
                                    <small class="text-muted">Print ready</small>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-semibold">Date Range</label>
                    <div class="row g-2">
                        <div class="col">
                            <input type="date" class="form-control" id="exportStartDate">
                        </div>
                        <div class="col-auto d-flex align-items-center">
                            <span class="text-muted">to</span>
                        </div>
                        <div class="col">
                            <input type="date" class="form-control" id="exportEndDate">
                        </div>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-semibold">Include Metrics</label>
                    <div class="row g-2">
                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="includeStats" checked>
                                <label class="form-check-label" for="includeStats">Performance Statistics</label>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="includeCharts" checked>
                                <label class="form-check-label" for="includeCharts">Charts & Graphs</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary d-flex align-items-center gap-2">
                    <i class="bi bi-download"></i>
                    Export Data
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Insights Modal -->
<div class="modal fade" id="insightsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title d-flex align-items-center gap-2">
                    <i class="bi bi-graph-up-arrow text-primary"></i>
                    Performance Insights
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body">
                                <h6 class="card-title fw-semibold mb-3">
                                    <i class="bi bi-pie-chart me-2"></i>Workload Distribution
                                </h6>
                                <div class="chart-placeholder bg-light rounded-3 p-4 text-center">
                                    <i class="bi bi-pie-chart-fill fs-1 text-primary opacity-25"></i>
                                    <p class="mt-2 text-muted">Workload chart visualization</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body">
                                <h6 class="card-title fw-semibold mb-3">
                                    <i class="bi bi-bar-chart me-2"></i>Performance Trends
                                </h6>
                                <div class="chart-placeholder bg-light rounded-3 p-4 text-center">
                                    <i class="bi bi-bar-chart-line-fill fs-1 text-success opacity-25"></i>
                                    <p class="mt-2 text-muted">Performance trend visualization</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h6 class="card-title fw-semibold mb-3">Key Insights</h6>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <div class="insight-item insight-positive">
                                            <div class="insight-icon">
                                                <i class="bi bi-lightning-charge-fill"></i>
                                            </div>
                                            <div class="insight-content">
                                                <div class="insight-title">Top Performer</div>
                                                <div class="insight-value" id="topPerformerName">--</div>
                                                <div class="insight-detail">98% completion rate</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="insight-item insight-warning">
                                            <div class="insight-icon">
                                                <i class="bi bi-exclamation-triangle-fill"></i>
                                            </div>
                                            <div class="insight-content">
                                                <div class="insight-title">Highest Workload</div>
                                                <div class="insight-value" id="highWorkloadName">--</div>
                                                <div class="insight-detail">42 active jobs</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="insight-item insight-danger">
                                            <div class="insight-icon">
                                                <i class="bi bi-clock-history"></i>
                                            </div>
                                            <div class="insight-content">
                                                <div class="insight-title">Most Overdue</div>
                                                <div class="insight-value" id="mostOverdueName">--</div>
                                                <div class="insight-detail">8 overdue tasks</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Enhanced Reassign Modal -->
<div class="modal fade" id="reassignModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title d-flex align-items-center gap-2">
                    <i class="bi bi-person-badge text-primary"></i>
                    Reassign Job<span id="reassignCountText"></span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info d-flex align-items-center gap-2">
                    <i class="bi bi-info-circle"></i>
                    <small>This action will transfer selected jobs to another staff member.</small>
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-semibold">New Owner</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent">
                            <i class="bi bi-search"></i>
                        </span>
                        <select class="form-select" id="newOwnerSelect">
                            <option value="">Select Staff...</option>
                            <!-- Options populated via JS -->
                        </select>
                    </div>
                    <div class="mt-2">
                        <div class="staff-preview card border p-3" id="selectedStaffPreview" style="display: none;">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-sm rounded-circle bg-primary text-white d-flex 
                                            align-items-center justify-content-center fw-bold" 
                                     id="previewAvatar">JD</div>
                                <div>
                                    <div class="fw-semibold" id="previewName">John Doe</div>
                                    <div class="small text-muted" id="previewDetails">Support Agent • 5 active jobs</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-semibold">
                        Note <span class="text-muted fw-normal">(Optional)</span>
                    </label>
                    <textarea class="form-control" rows="3" id="reassignNote" 
                              placeholder="Add a note explaining the reason for reassignment..."></textarea>
                    <div class="form-text">This note will be visible in the job history.</div>
                </div>
                
                <div class="mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="notifyUser" checked>
                        <label class="form-check-label" for="notifyUser">
                            Notify the new owner about this assignment
                        </label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary d-flex align-items-center gap-2" 
                        id="confirmReassignBtn">
                    <i class="bi bi-send"></i>
                    Confirm Reassignment
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Enhanced Status Update Modal -->
<div class="modal fade" id="statusUpdateModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title d-flex align-items-center gap-2">
                    <i class="bi bi-arrow-repeat text-primary"></i>
                    Update Job Status
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-4">
                    <label class="form-label fw-semibold">New Status</label>
                    <div class="row g-2" id="statusOptions">
                        <div class="col-6">
                            <div class="status-option status-open" data-status="open">
                                <div class="status-icon">
                                    <i class="bi bi-circle"></i>
                                </div>
                                <div class="status-info">
                                    <div class="status-name">Open</div>
                                    <div class="status-desc">Job is awaiting assignment</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="status-option status-in-progress" data-status="in_progress">
                                <div class="status-icon">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </div>
                                <div class="status-info">
                                    <div class="status-name">In Progress</div>
                                    <div class="status-desc">Currently being worked on</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="status-option status-on-hold" data-status="on_hold">
                                <div class="status-icon">
                                    <i class="bi bi-pause-circle"></i>
                                </div>
                                <div class="status-info">
                                    <div class="status-name">On Hold</div>
                                    <div class="status-desc">Waiting for external input</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="status-option status-resolved" data-status="resolved">
                                <div class="status-icon">
                                    <i class="bi bi-check-circle"></i>
                                </div>
                                <div class="status-info">
                                    <div class="status-name">Resolved</div>
                                    <div class="status-desc">Completed successfully</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-semibold">Comment</label>
                    <textarea class="form-control" rows="3" id="statusComment" 
                              placeholder="Add details about the status change..."></textarea>
                    <div class="form-text">This comment will be added to the job history.</div>
                </div>
                
                <div class="mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="notifyCustomer" checked>
                        <label class="form-check-label" for="notifyCustomer">
                            Notify the customer about this status update
                        </label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary d-flex align-items-center gap-2" 
                        id="confirmStatusUpdateBtn">
                    <i class="bi bi-check-lg"></i>
                    Update Status
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/staff_performance.js"></script>
