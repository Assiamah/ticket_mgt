<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizations.css">
<main class="app-wrapper">
    <div class="container-fluid">
        
        <!-- Breadcrumb -->
        <!-- <div class="main-breadcrumb d-flex align-items-center justify-content-between my-4">
            <h2 class="breadcrumb-title mb-0 fs-14">Organization Management</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb justify-content-end mb-0">
                    <li class="breadcrumb-item"><a href="javascript:void(0)">System</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Organizations</li>
                </ol>
            </nav>
        </div> -->

        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div class="header-content">
                <h1 class="page-title mb-2">Organization Directory</h1>
                <p class="page-subtitle text-muted mb-0">Manage institutional clients and their configurations</p>
            </div>
            <div class="header-actions">
                <button class="btn btn-primary d-flex align-items-center gap-2" id="btnAddOrg">
                    <i class="bi bi-plus-circle"></i>
                    <span>Add Organization</span>
                </button>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #6366f1;">
                        <i class="bi bi-building"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="org_total">0</div>
                        <div class="stat-label">Total Organizations</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #10b981;">
                        <i class="bi bi-check-circle"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="org_active">0</div>
                        <div class="stat-label">Active</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #ef4444;">
                        <i class="bi bi-x-circle"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="org_blocked">0</div>
                        <div class="stat-label">Blocked</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #8b5cf6;">
                        <i class="bi bi-diagram-3"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="total_products">0</div>
                        <div class="stat-label">Product Assignments</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters Card -->
        <div class="card filter-card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-xl-4 col-lg-6">
                        <label class="form-label">Search Organizations</label>
                        <div class="search-box">
                            <i class="bi bi-search"></i>
                            <input type="text" id="orgs_search" class="form-control search-input" placeholder="Search by name, code, email, or country...">
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Status</label>
                        <select id="filter_status" class="form-select">
                            <option value="">All Status</option>
                            <option value="active">Active</option>
                            <option value="blocked">Blocked</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Country</label>
                        <select id="filter_country" class="form-select">
                            <option value="">All Countries</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Subscription</label>
                        <select id="filter_subscription" class="form-select">
                            <option value="">All Types</option>
                            <option value="standard">Standard</option>
                            <option value="premium">Premium</option>
                            <option value="enterprise">Enterprise</option>
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
<br>
        <!-- Main Table Card -->
        <div class="card table-card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <div>
                    <h4 class="card-title mb-0">All Organizations</h4>
                    <p class="text-muted mb-0">Showing <span id="orgCount">0</span> organizations</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-outline-secondary" id="refreshOrgsBtn">
                        <i class="bi bi-arrow-clockwise"></i>
                        Refresh
                    </button>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="bi bi-download"></i> Export
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportOrgs('csv')">CSV</a></li>
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportOrgs('excel')">Excel</a></li>
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportOrgs('pdf')">PDF</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="orgs-datatable" class="table table-hover">
                        <thead>
                            <tr>
                                <th>Organization</th>
                                <th>Code</th>
                                <th>Contact</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Subscription</th>
                                <th>Created</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer d-flex align-items-center justify-content-between">
                <div class="text-muted">
                    Showing <span id="showingCount">0</span> of <span id="totalCount">0</span> organizations
                </div>
                <nav>
                    <ul class="pagination pagination-sm mb-0" id="paginationControls">
                        <!-- Pagination will be generated dynamically -->
                    </ul>
                </nav>
            </div>
        </div>

        <!-- Quick Preview Card -->
        <!-- <div class="card preview-card mt-4">
            <div class="card-header">
                <h5 class="card-title mb-0">Organization Preview</h5>
            </div>
            <div class="card-body">
                <div class="row" id="orgPreview">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <h5 class="preview-title" id="preview_name">Select an organization to preview</h5>
                            <div class="badge-container mt-2">
                                <span class="badge" id="preview_status">-</span>
                                <span class="badge" id="preview_subscription">-</span>
                                <span class="badge" id="preview_system_owner" style="display: none;">System Owner</span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Organization Code</small></p>
                                <p class="fw-semibold" id="preview_code">-</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Products</small></p>
                                <p class="fw-semibold" id="preview_product_count">0</p>
                            </div>
                            <div class="col-md-12">
                                <p class="mb-1"><small class="text-muted">Contact Email</small></p>
                                <p class="fw-semibold" id="preview_email">-</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <p class="mb-1"><small class="text-muted">Location</small></p>
                            <p class="preview-description" id="preview_location">-</p>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Subscription Start</small></p>
                                <p class="fw-semibold" id="preview_subscription_start">-</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Subscription End</small></p>
                                <p class="fw-semibold" id="preview_subscription_end">-</p>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <div id="preview_products" class="products-list">
                                    <small class="text-muted">No products assigned</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> -->

    </div>

    <!-- Add Organization Modal -->
    <div class="modal fade modal-blur" id="addOrgModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #6366f1;">
                            <i class="bi bi-building-add"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Add New Organization</h5>
                            <p class="text-muted mb-0">Register a new institutional client</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="addOrgForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="org_name" class="form-label">Organization Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="org_name" required placeholder="e.g., Acme Corporation">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="org_code" class="form-label">Organization Code <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="org_code" required placeholder="e.g., ACME-001">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="org_email" class="form-label">Contact Email</label>
                                <input type="email" class="form-control modern-input" id="org_email" placeholder="contact@example.com">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="org_phone" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control modern-input" id="org_phone" placeholder="+1 (555) 123-4567">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="org_address" class="form-label">Address</label>
                                <input type="text" class="form-control modern-input" id="org_address" placeholder="123 Main Street">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="org_city" class="form-label">City</label>
                                <input type="text" class="form-control modern-input" id="org_city" placeholder="New York">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="org_country" class="form-label">Country</label>
                                <input type="text" class="form-control modern-input" id="org_country" placeholder="United States">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="subscription_type" class="form-label">Subscription Type</label>
                                <select id="subscription_type" class="form-select modern-select">
                                    <option value="">Select Type</option>
                                    <option value="standard">Standard</option>
                                    <option value="premium">Premium</option>
                                    <option value="enterprise">Enterprise</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">System Owner</label>
                                <div class="form-check form-switch mt-2">
                                    <input class="form-check-input" type="checkbox" id="is_system_owner">
                                    <label class="form-check-label" for="is_system_owner">
                                        Mark as System Owner
                                    </label>
                                    <small class="text-muted d-block mt-1">System owners have special privileges</small>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="subscription_start_date" class="form-label">Subscription Start <span class="text-danger">*</span></label>
                                <input type="datetime-local" class="form-control modern-input" id="subscription_start_date" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="subscription_end_date" class="form-label">Subscription End</label>
                                <input type="datetime-local" class="form-control modern-input" id="subscription_end_date">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="org_products" class="form-label">Assign Products</label>
                            <select id="org_products" class="form-select modern-select" multiple style="height: 120px;">
                                <!-- Products will be loaded here -->
                            </select>
                            <small class="text-muted">Hold Ctrl/Cmd to select multiple products</small>
                        </div>
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="is_active" checked>
                                <label class="form-check-label" for="is_active">
                                    Active Organization
                                </label>
                                <small class="text-muted d-block mt-1">Blocked organizations cannot access the system</small>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAddOrg">
                        <i class="bi bi-plus-circle me-1"></i>
                        Create Organization
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Organization Modal -->
    <div class="modal fade modal-blur" id="editOrgModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #f59e0b;">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Edit Organization</h5>
                            <p class="text-muted mb-0">Update organization details</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="editOrgForm">
                        <input type="hidden" id="edit_org_id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_org_name" class="form-label">Organization Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="edit_org_name" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_org_code" class="form-label">Organization Code <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="edit_org_code" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_org_email" class="form-label">Contact Email</label>
                                <input type="email" class="form-control modern-input" id="edit_org_email">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_org_phone" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control modern-input" id="edit_org_phone">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label for="edit_org_address" class="form-label">Address</label>
                                <input type="text" class="form-control modern-input" id="edit_org_address">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_org_city" class="form-label">City</label>
                                <input type="text" class="form-control modern-input" id="edit_org_city">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_org_country" class="form-label">Country</label>
                                <input type="text" class="form-control modern-input" id="edit_org_country">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_subscription_type" class="form-label">Subscription Type</label>
                                <select id="edit_subscription_type" class="form-select modern-select">
                                    <option value="">Select Type</option>
                                    <option value="standard">Standard</option>
                                    <option value="premium">Premium</option>
                                    <option value="enterprise">Enterprise</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">System Owner</label>
                                <div class="form-check form-switch mt-2">
                                    <input class="form-check-input" type="checkbox" id="edit_is_system_owner">
                                    <label class="form-check-label" for="edit_is_system_owner">
                                        Mark as System Owner
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_subscription_start_date" class="form-label">Subscription Start <span class="text-danger">*</span></label>
                                <input type="datetime-local" class="form-control modern-input" id="edit_subscription_start_date" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_subscription_end_date" class="form-label">Subscription End</label>
                                <input type="datetime-local" class="form-control modern-input" id="edit_subscription_end_date">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="edit_org_products" class="form-label">Assign Products</label>
                            <select id="edit_org_products" class="form-select modern-select" multiple style="height: 120px;">
                                <!-- Products will be loaded here -->
                            </select>
                            <small class="text-muted">Hold Ctrl/Cmd to select multiple products</small>
                        </div>
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="edit_is_active">
                                <label class="form-check-label" for="edit_is_active">
                                    Active Organization
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitEditOrg">
                        <i class="bi bi-check-circle me-1"></i>
                        Update Organization
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Organization Modal -->
    <div class="modal fade modal-blur" id="viewOrgModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #10b981;">
                            <i class="bi bi-building"></i>
                        </div>
                        <div>
                            <h5 class="modal-title" id="view_org_name">Organization Details</h5>
                            <p class="text-muted mb-0" id="view_org_code"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Organization Information</h6>
                                </div>
                                <div class="card-body">
                                    <div id="orgDetailsContent">
                                        <!-- Organization details will be populated here -->
                                    </div>
                                </div>
                            </div>
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Assigned Products</h6>
                                </div>
                                <div class="card-body">
                                    <div id="view_products_list" class="products-grid">
                                        <!-- Products will be listed here -->
                                    </div>
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
                                        <button type="button" class="btn btn-outline-primary" id="editFromViewBtn">
                                            <i class="bi bi-pencil me-2"></i>
                                            Edit Organization
                                        </button>
                                        <button type="button" class="btn btn-outline-success" id="assignProductsBtn">
                                            <i class="bi bi-box-seam me-2"></i>
                                            Assign Products
                                        </button>
                                        <button type="button" class="btn btn-outline-warning" id="toggleStatusBtn">
                                            <i class="bi bi-power me-2"></i>
                                            Toggle Status
                                        </button>
                                        <button type="button" class="btn btn-outline-danger" id="deleteOrgBtn">
                                            <i class="bi bi-trash me-2"></i>
                                            Delete Organization
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Organization Summary</h6>
                                </div>
                                <div class="card-body">
                                    <div class="summary-item">
                                        <span class="summary-label">Status:</span>
                                        <span class="summary-value badge" id="view_meta_status"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Subscription:</span>
                                        <span class="summary-value" id="view_meta_subscription"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">System Owner:</span>
                                        <span class="summary-value" id="view_meta_system_owner"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Assigned Products:</span>
                                        <span class="summary-value" id="view_meta_product_count">0</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Contact Email:</span>
                                        <span class="summary-value" id="view_meta_email"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Phone:</span>
                                        <span class="summary-value" id="view_meta_phone"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Country:</span>
                                        <span class="summary-value" id="view_meta_country"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Subscription Start:</span>
                                        <span class="summary-value" id="view_meta_subscription_start"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Subscription End:</span>
                                        <span class="summary-value" id="view_meta_subscription_end"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Created Date:</span>
                                        <span class="summary-value" id="view_meta_created"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Last Updated:</span>
                                        <span class="summary-value" id="view_meta_updated"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Assign Products Modal -->
    <div class="modal fade modal-blur" id="assignProductsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #8b5cf6;">
                            <i class="bi bi-box-seam"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Assign Products</h5>
                            <p class="text-muted mb-0" id="assign_org_name"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <input type="hidden" id="assign_org_id">
                    <div class="mb-3">
                        <label class="form-label">Select Products</label>
                        <div class="form-control modern-select p-3" style="height: 300px; overflow-y: auto;" id="productsList">
                            <!-- Products will be loaded here -->
                        </div>
                        <small class="text-muted">Hold Ctrl/Cmd to select multiple products</small>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i>
                        <small>Selected products will be accessible to this organization for ticket creation</small>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAssignProducts">
                        <i class="bi bi-check-circle me-1"></i>
                        Save Assignments
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade modal-blur" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon text-danger">
                            <i class="bi bi-trash"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Confirm Delete</h5>
                            <p class="text-muted mb-0">This action cannot be undone</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <div class="text-center mb-4">
                        <div class="delete-icon">
                            <i class="bi bi-trash"></i>
                        </div>
                        <h6 class="mt-3 mb-2" id="deleteOrgName"></h6>
                        <p class="text-muted mb-3">Organization</p>
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <span id="deleteWarningText">Are you sure you want to delete this organization?</span>
                        </div>
                        <div class="alert alert-danger d-none" id="deleteForbidden">
                            <i class="bi bi-shield-exclamation me-2"></i>
                            Cannot delete organizations that have active tickets or users
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="delete_reason" class="form-label">Reason for Deletion (Optional)</label>
                        <textarea class="form-control modern-textarea" id="delete_reason" rows="2" placeholder="Enter reason..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteOrg">
                        <i class="bi bi-trash me-1"></i>
                        Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

</main>

<script src="${pageContext.request.contextPath}/assets/js/organizations.js"></script>