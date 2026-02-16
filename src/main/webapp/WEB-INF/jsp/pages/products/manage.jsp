<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css">
<main class="app-wrapper">
    <div class="container-fluid">
        
        <!-- Breadcrumb -->
        <!-- <div class="main-breadcrumb d-flex align-items-center justify-content-between my-4">
            <h2 class="breadcrumb-title mb-0 fs-14">Product Management</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb justify-content-end mb-0">
                    <li class="breadcrumb-item"><a href="javascript:void(0)">System</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Products</li>
                </ol>
            </nav>
        </div> -->

        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div class="header-content">
                <h1 class="page-title mb-2">Product Catalog</h1>
                <p class="page-subtitle text-muted mb-0">Manage platform products and their configurations</p>
            </div>
            <div class="header-actions">
                <button class="btn btn-primary d-flex align-items-center gap-2" id="btnAddProduct">
                    <i class="bi bi-plus-circle"></i>
                    <span>Add Product</span>
                </button>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #6366f1;">
                        <i class="bi bi-box-seam"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="total_products">0</div>
                        <div class="stat-label">Total Products</div>
                        <!-- <div class="stat-trend up">
                            <i class="bi bi-arrow-up-short"></i>
                            <span>Active</span>
                        </div> -->
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #10b981;">
                        <i class="bi bi-check-circle"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="active_products">0</div>
                        <div class="stat-label">Active Products</div>
                        <!-- <div class="stat-trend up">
                            <i class="bi bi-check-circle-fill"></i>
                            <span>Live</span>
                        </div> -->
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #f59e0b;">
                        <i class="bi bi-building"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="organizations_count">0</div>
                        <div class="stat-label">Organizations</div>
                        <!-- <div class="stat-trend">
                            <i class="bi bi-link-45deg"></i>
                            <span>Assigned</span>
                        </div> -->
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #8b5cf6;">
                        <i class="bi bi-diagram-3"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="total_assignments">0</div>
                        <div class="stat-label">Assignments</div>
                        <!-- <div class="stat-trend">
                            <i class="bi bi-info-circle"></i>
                            <span>Total</span>
                        </div> -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters Card -->
        <div class="card filter-card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-xl-4 col-lg-6">
                        <label class="form-label">Search Products</label>
                        <div class="search-box">
                            <i class="bi bi-search"></i>
                            <input type="text" id="products_search" class="form-control search-input" placeholder="Search by name, code, or description...">
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Status</label>
                        <select id="filter_status" class="form-select">
                            <option value="">All Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Organization</label>
                        <select id="filter_organization" class="form-select">
                            <option value="">All Organizations</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Sort By</label>
                        <select id="filter_sort" class="form-select">
                            <option value="name">Name (A-Z)</option>
                            <option value="name_desc">Name (Z-A)</option>
                            <option value="code">Code</option>
                            <option value="org_count">Organizations</option>
                            <option value="created">Recently Added</option>
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
                    <h4 class="card-title mb-0">All Products</h4>
                    <p class="text-muted mb-0">Showing <span id="productCount">0</span> products</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-outline-secondary" id="refreshProductsBtn">
                        <i class="bi bi-arrow-clockwise"></i>
                        Refresh
                    </button>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="bi bi-download"></i> Export
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportProducts('csv')">CSV</a></li>
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportProducts('excel')">Excel</a></li>
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportProducts('pdf')">PDF</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="products-datatable" class="table table-hover">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Code</th>
                                <th>Version</th>
                                <th>Status</th>
                                <th>Organizations</th>
                                <th>Description</th>
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
                    Showing <span id="showingCount">0</span> of <span id="totalCount">0</span> products
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
                <h5 class="card-title mb-0">Product Preview</h5>
            </div>
            <div class="card-body">
                <div class="row" id="productPreview">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <h5 class="preview-title" id="preview_name">Select a product to preview</h5>
                            <div class="badge-container mt-2">
                                <span class="badge" id="preview_status">-</span>
                                <span class="badge" id="preview_version">-</span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Product Code</small></p>
                                <p class="fw-semibold" id="preview_code">-</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Organizations</small></p>
                                <p class="fw-semibold" id="preview_org_count">0</p>
                            </div>
                            <div class="col-md-12">
                                <p class="mb-1"><small class="text-muted">Documentation</small></p>
                                <a href="#" target="_blank" id="preview_doc_url" class="text-primary">No documentation</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <p class="mb-1"><small class="text-muted">Description</small></p>
                            <p class="preview-description" id="preview_description">No description available</p>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Created Date</small></p>
                                <p class="fw-semibold" id="preview_created">-</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Last Updated</small></p>
                                <p class="fw-semibold" id="preview_updated">-</p>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <div id="preview_organizations" class="organizations-list">
                                    <small class="text-muted">No organizations assigned</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> -->

    </div>

    <!-- Add Product Modal -->
    <div class="modal fade modal-blur" id="addProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #6366f1;">
                            <i class="bi bi-box-seam"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Add New Product</h5>
                            <p class="text-muted mb-0">Create a new platform product</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="addProductForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="product_name" class="form-label">Product Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="product_name" required placeholder="e.g., Customer Portal">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="product_code" class="form-label">Product Code <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="product_code" required placeholder="e.g., CP-001">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="product_version" class="form-label">Version</label>
                                <input type="text" class="form-control modern-input" id="product_version" placeholder="e.g., 1.0.0">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="product_category" class="form-label">Category</label>
                                <select id="product_category" class="form-select modern-select">
                                    <option value="">Select Category</option>
                                    <option value="software">Software</option>
                                    <option value="service">Service</option>
                                    <option value="hardware">Hardware</option>
                                    <option value="integration">Integration</option>
                                    <option value="custom">Custom Solution</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="product_description" class="form-label">Description</label>
                            <textarea class="form-control modern-textarea" id="product_description" rows="3" placeholder="Describe the product features and purpose..."></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="documentation_url" class="form-label">Documentation URL</label>
                                <input type="url" class="form-control modern-input" id="documentation_url" placeholder="https://docs.example.com">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="support_email" class="form-label">Support Email</label>
                                <input type="email" class="form-control modern-input" id="support_email" placeholder="support@example.com">
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="prod_is_active" checked>
                                <label class="form-check-label" for="prod_is_active">
                                    Active Product
                                </label>
                                <small class="text-muted d-block mt-1">Inactive products won't be available for new tickets</small>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAddProduct">
                        <i class="bi bi-plus-circle me-1"></i>
                        Create Product
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Product Modal -->
    <div class="modal fade modal-blur" id="editProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #f59e0b;">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Edit Product</h5>
                            <p class="text-muted mb-0">Update product details</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="editProductForm">
                        <input type="hidden" id="edit_product_id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_product_name" class="form-label">Product Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="edit_product_name" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_product_code" class="form-label">Product Code <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="edit_product_code" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_product_version" class="form-label">Version</label>
                                <input type="text" class="form-control modern-input" id="edit_product_version">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_product_category" class="form-label">Category</label>
                                <select id="edit_product_category" class="form-select modern-select">
                                    <option value="">Select Category</option>
                                    <option value="software">Software</option>
                                    <option value="service">Service</option>
                                    <option value="hardware">Hardware</option>
                                    <option value="integration">Integration</option>
                                    <option value="custom">Custom Solution</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="edit_product_description" class="form-label">Description</label>
                            <textarea class="form-control modern-textarea" id="edit_product_description" rows="3"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="edit_documentation_url" class="form-label">Documentation URL</label>
                                <input type="url" class="form-control modern-input" id="edit_documentation_url">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="edit_support_email" class="form-label">Support Email</label>
                                <input type="email" class="form-control modern-input" id="edit_support_email">
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="edit_prod_is_active">
                                <label class="form-check-label" for="edit_prod_is_active">
                                    Active Product
                                </label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitEditProduct">
                        <i class="bi bi-check-circle me-1"></i>
                        Update Product
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Product Modal -->
    <div class="modal fade modal-blur" id="viewProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #10b981;">
                            <i class="bi bi-card-text"></i>
                        </div>
                        <div>
                            <h5 class="modal-title" id="view_product_name">Product Details</h5>
                            <p class="text-muted mb-0" id="view_product_code"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Product Information</h6>
                                </div>
                                <div class="card-body">
                                    <div id="productDetailsContent">
                                        <!-- Product details will be populated here -->
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
                                            Edit Product
                                        </button>
                                        <button type="button" class="btn btn-outline-success" id="assignOrganizationsBtn">
                                            <i class="bi bi-building me-2"></i>
                                            Assign Organizations
                                        </button>
                                        <button type="button" class="btn btn-outline-warning" id="toggleStatusBtn">
                                            <i class="bi bi-power me-2"></i>
                                            Toggle Status
                                        </button>
                                        <button type="button" class="btn btn-outline-danger" id="deleteProductBtn">
                                            <i class="bi bi-trash me-2"></i>
                                            Delete Product
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Product Summary</h6>
                                </div>
                                <div class="card-body">
                                    <div class="summary-item">
                                        <span class="summary-label">Status:</span>
                                        <span class="summary-value badge" id="view_meta_status"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Version:</span>
                                        <span class="summary-value" id="view_meta_version"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Category:</span>
                                        <span class="summary-value" id="view_meta_category"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Organizations:</span>
                                        <span class="summary-value" id="view_meta_org_count">0</span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Documentation:</span>
                                        <span class="summary-value" id="view_meta_doc_url">
                                            <a href="#" target="_blank">Link</a>
                                        </span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Support Email:</span>
                                        <span class="summary-value" id="view_meta_support_email"></span>
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

    <!-- Assign Organizations Modal -->
    <div class="modal fade modal-blur" id="assignOrganizationsModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #8b5cf6;">
                            <i class="bi bi-building-add"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Assign Organizations</h5>
                            <p class="text-muted mb-0" id="assign_product_name"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <input type="hidden" id="assign_product_id">
                    <div class="mb-3">
                        <label class="form-label">Select Organizations</label>
                        <div class="form-control modern-select p-3" style="height: 200px; overflow-y: auto;" id="organizationsList">
                            <!-- Organizations will be loaded here -->
                        </div>
                        <small class="text-muted">Hold Ctrl/Cmd to select multiple organizations</small>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i>
                        <small>Selected organizations will have access to this product for ticket creation</small>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAssignOrganizations">
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
                        <h6 class="mt-3 mb-2" id="deleteProductName"></h6>
                        <p class="text-muted mb-3">Product</p>
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <span id="deleteWarningText">Are you sure you want to delete this product?</span>
                        </div>
                        <div class="alert alert-danger d-none" id="deleteForbidden">
                            <i class="bi bi-shield-exclamation me-2"></i>
                            Cannot delete products that are assigned to organizations or have active tickets
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="delete_reason" class="form-label">Reason for Deletion (Optional)</label>
                        <textarea class="form-control modern-textarea" id="delete_reason" rows="2" placeholder="Enter reason..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteProduct">
                        <i class="bi bi-trash me-1"></i>
                        Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

</main>

<script src="${pageContext.request.contextPath}/assets/js/products.js"></script>