<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tickets.css">
<main class="app-wrapper">
    <div class="container-fluid">

        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div class="header-content">
                <h1 class="page-title mb-2">My Tasks</h1>
                <p class="page-subtitle text-muted mb-0">Manage and track your assigned support tickets and tasks</p>
            </div>
            <div class="header-actions">
                <button type="button" class="btn btn-primary btn-lg d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#createTicketModal">
                    <i class="bi bi-plus-circle"></i>
                    <span>Create Task</span>
                </button>
            </div>
        </div>

        <!-- Stats Cards Row -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-lg-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #6366f1;">
                        <i class="bi bi-list-task"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="totalCount">0</div>
                        <div class="stat-label">Total Tasks</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #10b981;">
                        <i class="bi bi-check2-all"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="status_resolved">0</div>
                        <div class="stat-label">Completed</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #f59e0b;">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="status_open">0</div>
                        <div class="stat-label">Pending</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #ef4444;">
                        <i class="bi bi-exclamation-octagon"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="overdue_tickets">0</div>
                        <div class="stat-label">Overdue</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters Card -->
        <div class="card content-card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-xl-4 col-lg-6">
                        <label class="form-label">Search Tasks</label>
                        <div class="search-box">
                            <i class="bi bi-search"></i>
                            <input type="text" id="tasks_search" class="form-control search-input" placeholder="Search tasks by title or description...">
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Priority</label>
                        <select id="filter_priority" class="form-select">
                            <option value="">All Priorities</option>
                            <option value="critical">Critical</option>
                            <option value="high">High</option>
                            <option value="medium">Medium</option>
                            <option value="low">Low</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Status</label>
                        <select id="filter_status" class="form-select">
                            <option value="">All Status</option>
                            <option value="open">Open</option>
                            <option value="in progress">In Progress</option>
                            <option value="resolved">Resolved</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <div class="d-flex gap-2">
                            <button id="applyFiltersBtn" class="btn btn-primary w-100">Apply</button>
                            <button id="clearFiltersBtn" class="btn btn-outline-secondary w-100" title="Clear Filters">
                                <i class="bi bi-x-lg"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Table Card -->
        <div class="card content-card">
            <div class="card-header d-flex align-items-center justify-content-between bg-transparent border-bottom">
                <div>
                    <h4 class="card-title mb-0">Task List</h4>
                    <p class="text-muted mb-0 small">Overview of your assigned tasks</p>
                </div>
                <div class="header-actions">
                    <button type="button" class="btn btn-sm btn-outline-secondary" id="refreshTicketsBtn">
                        <i class="bi bi-arrow-clockwise"></i> Refresh
                    </button>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="tickets-datatable" class="table table-hover align-middle mb-0">
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
            <div class="card-footer bg-transparent border-top d-flex align-items-center justify-content-between">
                <div class="text-muted small">
                    Showing <span id="showingCount">0</span> tasks
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0" id="paginationControls"></ul>
                </nav>
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
    const ORG_API = "${pageContext.request.contextPath}/api/organizations";
    const CURRENT_USER_ID = "${userInfo.id}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/tickets.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize specific logic for My Tasks if needed
        if (typeof loadTickets === 'function') {
            // Reusing loadTickets but filtered for current user if backend supports it
            // or we pass a specific flag
        }
    });
</script>
