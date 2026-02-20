<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/libs/apexcharts/apexcharts.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tickets.css">

<main class="app-wrapper">
    <div class="analytics-container">
        <style>
            /* Analytics Page Styles */
            .analytics-container {
                padding: 2rem;
                max-width: 100%;
            }
            
            @media (max-width: 768px) {
                .analytics-container {
                    padding: 1rem;
                }
            }
            
            /* Header Section */
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
                background: white;
                box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
            }
            
            .content-card {
                background: white;
                border-radius: 20px;
                box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
                border: 1px solid var(--border-color);
                height: 100%;
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
            
            .chart-title-analytics {
                font-size: 1.25rem;
                font-weight: 700;
                color: var(--analytics-dark);
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin: 0;
            }
        </style>

        <!-- Header Section -->
        <header class="analytics-header">
            <div class="header-background"></div>
            <div class="header-content">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h1 class="header-title">Hello <c:out value="${not empty userName ? userName : (not empty userInfo.name ? userInfo.name : (not empty userInfo.username ? userInfo.username : 'User'))}" /></h1>
                        <p class="header-subtitle">Track and manage jobs assigned to your team or department</p>
                        <div class="header-badges">
                            <div class="header-badge">
                                <i class="bi bi-briefcase"></i>
                                Jobs Dashboard
                            </div>
                            <div class="header-badge">
                                <i class="bi bi-person-badge"></i>
                                Assigned to Me
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 mt-4 mt-lg-0">
                        <div class="header-info-card">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <i class="bi bi-person-circle fs-4"></i>
                                    <div>
                                        <div class="small opacity-75">Logged In As</div>
                                        <div class="fw-bold"><c:out value="${not empty userInfo.full_name ? userInfo.full_name : (not empty userName ? userName : (not empty userInfo.name ? userInfo.name : (not empty userInfo.username ? userInfo.username : 'User')))}" /></div>
                                    </div>
                                </div>
                            </div>
                            <div class="d-grid gap-2 mt-3">
                                <button type="button" class="btn btn-light btn-sm d-flex align-items-center justify-content-center gap-2" data-bs-toggle="modal" data-bs-target="#createTicketModal">
                                    <i class="bi bi-plus-circle text-primary"></i>
                                    <span class="text-primary fw-bold">Create Ticket</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Stats Grid -->
        <div class="row g-3 mb-4">
            <div class="col-xl-2 col-lg-4 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--primary-color);">
                            <i class="bi bi-briefcase"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 12%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="totalCount">0</div>
                        <div class="stat-label">Total Jobs</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-primary" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--primary-color);">
                            <i class="bi bi-play-circle"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 8%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="status_open">0</div>
                        <div class="stat-label">Open</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-primary" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
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
                        <div class="stat-number" id="status_in_progress">0</div>
                        <div class="stat-label">In Progress</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-warning" style="width: 75%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--secondary-color);">
                            <i class="bi bi-pause-circle"></i>
                        </div>
                        <div class="stat-trend-badge down">
                            <i class="bi bi-arrow-down"></i> 3%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="status_on_hold">0</div>
                        <div class="stat-label">On Hold</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-secondary" style="width: 40%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-xl-2 col-lg-4 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--info-color);">
                            <i class="bi bi-check-circle"></i>
                        </div>
                        <div class="stat-trend-badge up">
                            <i class="bi bi-arrow-up"></i> 20%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="status_resolved">0</div>
                        <div class="stat-label">Resolved</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-info" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-2 col-lg-4 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon-wrapper">
                        <div class="stat-icon" style="color: var(--danger-color);">
                            <i class="bi bi-exclamation-circle"></i>
                        </div>
                        <div class="stat-trend-badge down">
                            <i class="bi bi-arrow-down"></i> 5%
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number" id="overdue_tickets">0</div>
                        <div class="stat-label">Overdue</div>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-danger" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Grid -->
        <div class="row g-3 mb-4">
            <!-- Status Distribution -->
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
                        <div id="statusPieChart" style="height: 320px;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <div class="d-flex justify-content-between">
                            <small class="text-muted">Total: <strong id="ticketCount">0</strong> tickets</small>
                            <small class="text-muted">Updated: just now</small>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Priority Breakdown -->
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
                        <div id="priorityChart" style="height: 320px;"></div>
                    </div>
                    <div class="chart-card-footer">
                        <small class="text-muted">Showing priority distribution across all tickets</small>
                    </div>
                </div>
            </div>
            
            <!-- Category Distribution -->
            <div class="col-xl-4 col-lg-12">
                <div class="content-card chart-card mb-0">
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

        <!-- Full Width Charts -->
        <div class="row g-3 mb-4">
            <!-- Job Trends -->
            <div class="col-xl-12">
                <div class="content-card chart-card mb-0">
                    <div class="chart-card-header">
                        <h4 class="chart-card-title">
                            <i class="bi bi-graph-up me-2"></i>
                            Job Trends Over Time
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
                            <small class="text-muted">Showing job volume trends over time</small>
                            <small class="text-muted">Updated: <span id="trendChartUpdate">just now</span></small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Card -->
        <div class="recent-tickets-analytics content-card">
            <div class="recent-tickets-header">
                <div class="d-flex align-items-center gap-3">
                    <h3 class="chart-title-analytics mb-0">
                        <i class="bi bi-list-task me-2"></i>
                        Assigned Jobs List
                    </h3>
                    <div class="search-box ms-3">
                        <i class="bi bi-search"></i>
                        <input type="text" id="tickets_search" class="form-control form-control-sm" placeholder="Search jobs...">
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-2" id="refreshTicketsBtn" onclick="loadTickets()">
                        <i class="bi bi-arrow-clockwise"></i>
                        <span>Refresh</span>
                    </button>
                </div>
            </div>
            <div class="table-responsive">
                <table id="tickets-datatable" class="table table-hover mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th style="width: 40px;">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="selectAll">
                                </div>
                            </th>
                            <th>Ticket ID</th>
                            <th>Subject</th>
                            <th>Type</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Assigned To</th>
                            <th>Created</th>
                            <th>Due Date</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Data populated by JS -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Create Ticket Modal -->
    <div class="modal fade" id="createTicketModal" tabindex="-1" aria-labelledby="createTicketModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon">
                            <i class="bi bi-plus-circle-fill"></i>
                        </div>
                        <div>
                            <h5 class="modal-title" id="createTicketModalLabel">Create New Ticket</h5>
                            <p class="text-muted mb-0">Fill in the details to create a new support ticket</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="createTicketForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="organization_id" class="form-label">Organization <span class="text-danger">*</span></label>
                                <select id="organization_id" class="form-select modern-select" required>
                                    <option value="">Select Organization</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="task_subject" class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="task_subject" required placeholder="Enter ticket title">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="priority_id" class="form-label">Priority <span class="text-danger">*</span></label>
                                <select id="priority_id" class="form-select modern-select" required>
                                    <option value="">Select Priority</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="status_id" class="form-label">Status</label>
                                <select id="status_id" class="form-select modern-select">
                                    <option value="">Select Status</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="task_type" class="form-label">Type <span class="text-danger">*</span></label>
                                <select class="form-select modern-select" id="task_type" required>
                                    <option value="">Select Type</option>
                                    <option value="customer-service">Customer Service</option>
                                    <option value="it">IT Support</option>
                                    <option value="sales">Sales</option>
                                    <option value="billing">Billing</option>
                                    <option value="technical">Technical</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="product_id" class="form-label">Product</label>
                                <select id="product_id" class="form-select modern-select">
                                    <option value="">Select Product</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="category_id" class="form-label">Category</label>
                                <select id="category_id" class="form-select modern-select">
                                    <option value="">Select Category</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="due_date" class="form-label">Due Date</label>
                                <input type="date" class="form-control modern-input" id="due_date">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="task_description" class="form-label">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control modern-textarea" id="task_description" rows="4" required placeholder="Describe the issue or request..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="createTicketBtn">
                        <i class="bi bi-plus-circle me-1"></i>
                        Create Ticket
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Ticket Modal -->
    <div class="modal fade modal-blur" id="viewTicketModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon">
                            <i class="bi bi-card-text"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Ticket Details</h5>
                            <p class="text-muted mb-0" id="view_ticket_number"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Ticket Information</h6>
                                </div>
                                <div class="card-body">
                                    <div id="ticketDetailsContent">
                                        <!-- Ticket details will be populated here -->
                                    </div>
                                </div>
                            </div>
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Description</h6>
                                </div>
                                <div class="card-body">
                                    <p id="view_description" class="mb-0"></p>
                                </div>
                            </div>
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Remarks</h6>
                                </div>
                                <div class="card-body">
                                    <p id="view_remarks" class="mb-0 text-muted">No remarks available</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Quick Actions</h6>
                                </div>
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <button type="button" class="btn btn-outline-primary btn-edit-view" id="editFromViewBtn">
                                            <i class="bi bi-pencil me-2"></i>
                                            Edit Ticket
                                        </button>
                                        <button type="button" class="btn btn-outline-success btn-assign-view" id="assignFromViewBtn">
                                            <i class="bi bi-person-plus me-2"></i>
                                            Assign Ticket
                                        </button>
                                        <button type="button" class="btn btn-outline-warning" id="changeStatusBtn">
                                            <i class="bi bi-arrow-repeat me-2"></i>
                                            Change Status
                                        </button>
                                        <button type="button" class="btn btn-outline-danger btn-archive-view" id="archiveFromViewBtn">
                                            <i class="bi bi-archive me-2"></i>
                                            Archive Ticket
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Ticket Summary</h6>
                                </div>
                                <div class="card-body">
                                    <div class="summary-item">
                                        <span class="summary-label">Status:</span>
                                        <span class="summary-value badge" id="view_meta_status"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Priority:</span>
                                        <span class="summary-value badge" id="view_meta_priority"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Type:</span>
                                        <span class="summary-value" id="view_meta_type"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Assigned To:</span>
                                        <span class="summary-value" id="view_meta_assigned_to"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Created By:</span>
                                        <span class="summary-value" id="view_meta_created_by"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Organization:</span>
                                        <span class="summary-value" id="view_meta_organization"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Created Date:</span>
                                        <span class="summary-value" id="view_meta_created_date"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Due Date:</span>
                                        <span class="summary-value" id="view_meta_due_date"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Ticket Modal -->
    <div class="modal fade modal-blur" id="editTicketModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Update Ticket</h5>
                            <p class="text-muted mb-0">Modify ticket details</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="editTicketForm">
                        <input type="hidden" id="edit_task_id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_task_subject" class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="edit_task_subject" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_task_priority" class="form-label">Priority <span class="text-danger">*</span></label>
                                <select id="edit_task_priority" class="form-select modern-select" required>
                                    <option value="">Select Priority</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_task_type" class="form-label">Type <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="edit_task_type" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_task_status" class="form-label">Status</label>
                                <select id="edit_task_status" class="form-select modern-select">
                                    <option value="">Select Status</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="edit_task_description" class="form-label">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control modern-textarea" id="edit_task_description" rows="4" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="edit_task_remarks" class="form-label">Remarks</label>
                            <textarea class="form-control modern-textarea" id="edit_task_remarks" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="updateTicketBtn">
                        <i class="bi bi-check-circle me-1"></i>
                        Update Ticket
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Assign Ticket Modal -->
    <div class="modal fade modal-blur" id="assignTicketModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon">
                            <i class="bi bi-person-plus"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Assign Ticket</h5>
                            <p class="text-muted mb-0">Choose an agent to assign this ticket to</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="assignTicketForm">
                        <input type="hidden" id="assign_task_id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ticket Title</label>
                                <input type="text" class="form-control modern-input" id="assign_task_subject" readonly>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Current Priority</label>
                                <input type="text" class="form-control modern-input" id="assign_task_priority" readonly>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="assign_task_to" class="form-label">Assign To <span class="text-danger">*</span></label>
                            <select id="assign_task_to" class="form-select modern-select" required>
                                <option value="">Select Agent</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="assign_notes" class="form-label">Assignment Notes (Optional)</label>
                            <textarea class="form-control modern-textarea" id="assign_notes" rows="3" placeholder="Add any notes about this assignment..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="assignTicketBtn">
                        <i class="bi bi-person-check me-1"></i>
                        Assign Ticket
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Archive Ticket Modal -->
    <div class="modal fade modal-blur" id="archiveTicketModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon text-danger">
                            <i class="bi bi-archive"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Archive Ticket</h5>
                            <p class="text-muted mb-0">Move this ticket to archive</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <input type="hidden" id="archive_task_id">
                    <div class="text-center mb-4">
                        <div class="archive-icon">
                            <i class="bi bi-archive"></i>
                        </div>
                        <h6 class="mt-3 mb-2">Are you sure?</h6>
                        <p class="text-muted mb-0">Ticket: <span id="archive_ticket_number" class="fw-semibold"></span></p>
                        <p class="text-muted">This action cannot be undone.</p>
                    </div>
                    <div class="mb-3">
                        <label for="archive_reason" class="form-label">Reason for Archiving (Optional)</label>
                        <select id="archive_reason" class="form-select modern-select">
                            <option value="">Select Reason</option>
                            <option value="resolved">Resolved</option>
                            <option value="duplicate">Duplicate</option>
                            <option value="no_response">No Response</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmArchiveBtn">
                        <i class="bi bi-archive me-1"></i>
                        Archive
                    </button>
                </div>
            </div>
        </div>
    </div>

</main>
<script>
    const TICKET_API_BASE = "${pageContext.request.contextPath}/api/tickets";
    const ORG_API = "${pageContext.request.contextPath}/v1/organization_service/get_all_organizations";
    const CURRENT_USER_ID = "${userInfo.id}";
</script>
<script src="${pageContext.request.contextPath}/assets/libs/apexcharts/apexcharts.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/tickets.js?v=<%=System.currentTimeMillis()%>"></script>