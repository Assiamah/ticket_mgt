<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ticket_categories.css">
<main class="app-wrapper">
    <div class="container-fluid">
        
        <!-- Breadcrumb -->
        <!-- <div class="main-breadcrumb d-flex align-items-center justify-content-between my-4">
            <h2 class="breadcrumb-title mb-0 fs-14">Ticket Management</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb justify-content-end mb-0">
                    <li class="breadcrumb-item"><a href="javascript:void(0)">Settings</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Categories</li>
                </ol>
            </nav>
        </div> -->

        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div class="header-content">
                <h1 class="page-title mb-2">Ticket Configuration</h1>
                <p class="page-subtitle text-muted mb-0">Manage statuses, categories, and priorities for your tickets</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row g-3 mb-4">
            <div class="col-xl-4 col-lg-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #6366f1;">
                        <i class="bi bi-list-task"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="statuses_count">0</div>
                        <div class="stat-label">Status Types</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-lg-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #10b981;">
                        <i class="bi bi-tags"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="categories_count">0</div>
                        <div class="stat-label">Categories</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-lg-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #ef4444;">
                        <i class="bi bi-exclamation-triangle"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="priorities_count">0</div>
                        <div class="stat-label">Priorities</div>
                    </div>
                </div>
            </div>
        </div>
<br>
        <!-- Statuses Section -->
        <div class="card table-card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <div>
                    <h4 class="card-title mb-0">Ticket Statuses</h4>
                    <p class="text-muted mb-0">Manage ticket workflow statuses</p>
                </div>
                <button class="btn btn-primary d-flex align-items-center gap-2" id="btnAddStatus">
                    <i class="bi bi-plus-circle"></i>
                    <span>Add Status</span>
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="statuses-datatable" class="table table-hover">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Color</th>
                                <th>Usage Count</th>
                                <th>Description</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
<br>
        <!-- Categories Section -->
        <div class="card table-card mb-4">
            <div class="card-header d-flex align-items-center justify-content-between">
                <div>
                    <h4 class="card-title mb-0">Ticket Categories</h4>
                    <p class="text-muted mb-0">Organize tickets by category</p>
                </div>
                <button class="btn btn-primary d-flex align-items-center gap-2" id="btnAddCategory">
                    <i class="bi bi-plus-circle"></i>
                    <span>Add Category</span>
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="categories-datatable" class="table table-hover">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Color</th>
                                <th>Usage Count</th>
                                <th>Description</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
<br>
        <!-- Priorities Section -->
        <div class="card table-card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <div>
                    <h4 class="card-title mb-0">Ticket Priorities</h4>
                    <p class="text-muted mb-0">Manage ticket priority levels</p>
                </div>
                <button class="btn btn-primary d-flex align-items-center gap-2" id="btnAddPriority">
                    <i class="bi bi-plus-circle"></i>
                    <span>Add Priority</span>
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="priorities-datatable" class="table table-hover">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Color</th>
                                <th>Level</th>
                                <th>Usage Count</th>
                                <th>Description</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>

    <!-- Add Status Modal -->
    <div class="modal fade modal-blur" id="addStatusModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #6366f1;">
                            <i class="bi bi-list-task"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Add Status</h5>
                            <p class="text-muted mb-0">Create a new ticket status</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="addStatusForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="status_name" class="form-label">Status Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="status_name" required placeholder="e.g., In Progress">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="status_color" class="form-label">Color <span class="text-danger">*</span></label>
                                <select id="status_color" class="form-select modern-select" required>
                                    <option value="">Select Color</option>
                                    <option value="#6366f1" style="color: #6366f1;">Primary (Blue)</option>
                                    <option value="#10b981" style="color: #10b981;">Success (Green)</option>
                                    <option value="#ef4444" style="color: #ef4444;">Danger (Red)</option>
                                    <option value="#f59e0b" style="color: #f59e0b;">Warning (Yellow)</option>
                                    <option value="#8b5cf6" style="color: #8b5cf6;">Purple</option>
                                    <option value="#3b82f6" style="color: #3b82f6;">Info (Light Blue)</option>
                                    <option value="#6b7280" style="color: #6b7280;">Gray</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="status_description" class="form-label">Description</label>
                            <textarea class="form-control modern-textarea" id="status_description" rows="3" placeholder="Describe this status..."></textarea>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="status_is_active" checked>
                                <label class="form-check-label" for="status_is_active">
                                    Active Status
                                </label>
                                <small class="text-muted d-block mt-1">Inactive statuses won't be available for new tickets</small>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAddStatus">
                        <i class="bi bi-plus-circle me-1"></i>
                        Create Status
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Category Modal -->
    <div class="modal fade modal-blur" id="addCategoryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #10b981;">
                            <i class="bi bi-tags"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Add Category</h5>
                            <p class="text-muted mb-0">Create a new ticket category</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="addCategoryForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="category_name" class="form-label">Category Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="category_name" required placeholder="e.g., Technical Support">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="category_color" class="form-label">Color</label>
                                <select id="category_color" class="form-select modern-select">
                                    <option value="">Select Color</option>
                                    <option value="#6366f1" style="color: #6366f1;">Primary (Blue)</option>
                                    <option value="#10b981" style="color: #10b981;">Success (Green)</option>
                                    <option value="#ef4444" style="color: #ef4444;">Danger (Red)</option>
                                    <option value="#f59e0b" style="color: #f59e0b;">Warning (Yellow)</option>
                                    <option value="#8b5cf6" style="color: #8b5cf6;">Purple</option>
                                    <option value="#3b82f6" style="color: #3b82f6;">Info (Light Blue)</option>
                                    <option value="#6b7280" style="color: #6b7280;">Gray</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="category_description" class="form-label">Description</label>
                            <textarea class="form-control modern-textarea" id="category_description" rows="3" placeholder="Describe this category..."></textarea>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="category_is_active" checked>
                                <label class="form-check-label" for="category_is_active">
                                    Active Category
                                </label>
                                <small class="text-muted d-block mt-1">Inactive categories won't be available for new tickets</small>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAddCategory">
                        <i class="bi bi-plus-circle me-1"></i>
                        Create Category
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Priority Modal -->
    <div class="modal fade modal-blur" id="addPriorityModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #ef4444;">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Add Priority</h5>
                            <p class="text-muted mb-0">Create a new priority level</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="addPriorityForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="priority_name" class="form-label">Priority Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control modern-input" id="priority_name" required placeholder="e.g., Critical">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="priority_level" class="form-label">Level <span class="text-danger">*</span></label>
                                <select id="priority_level" class="form-select modern-select" required>
                                    <option value="">Select Level</option>
                                    <option value="1">Level 1 - Critical (Highest)</option>
                                    <option value="2">Level 2 - High</option>
                                    <option value="3">Level 3 - Medium</option>
                                    <option value="4">Level 4 - Low</option>
                                    <option value="5">Level 5 - Lowest</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="priority_color" class="form-label">Color <span class="text-danger">*</span></label>
                                <select id="priority_color" class="form-select modern-select" required>
                                    <option value="">Select Color</option>
                                    <option value="#ef4444" style="color: #ef4444;">Danger (Red)</option>
                                    <option value="#f97316" style="color: #f97316;">Orange</option>
                                    <option value="#f59e0b" style="color: #f59e0b;">Warning (Yellow)</option>
                                    <option value="#3b82f6" style="color: #3b82f6;">Info (Light Blue)</option>
                                    <option value="#10b981" style="color: #10b981;">Success (Green)</option>
                                    <option value="#6b7280" style="color: #6b7280;">Gray</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="priority_response_time" class="form-label">Response Time (Hours)</label>
                                <input type="number" class="form-control modern-input" id="priority_response_time" min="1" max="168" placeholder="e.g., 24">
                                <small class="text-muted">Expected response time in hours</small>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="priority_description" class="form-label">Description</label>
                            <textarea class="form-control modern-textarea" id="priority_description" rows="3" placeholder="Describe this priority level..."></textarea>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="priority_is_active" checked>
                                <label class="form-check-label" for="priority_is_active">
                                    Active Priority
                                </label>
                                <small class="text-muted d-block mt-1">Inactive priorities won't be available for new tickets</small>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAddPriority">
                        <i class="bi bi-plus-circle me-1"></i>
                        Create Priority
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Modal (Reused for all types) -->
    <div class="modal fade modal-blur" id="editItemModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" id="editModalIcon">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <div>
                            <h5 class="modal-title" id="editModalTitle">Edit Item</h5>
                            <p class="text-muted mb-0" id="editModalSubtitle">Modify item details</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="editItemForm">
                        <input type="hidden" id="edit_item_id">
                        <input type="hidden" id="edit_item_type">
                        <div id="editFormContent">
                            <!-- Dynamic form content will be inserted here -->
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitEditItem">
                        <i class="bi bi-check-circle me-1"></i>
                        Save Changes
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
                        <h6 class="mt-3 mb-2" id="deleteItemName"></h6>
                        <p class="text-muted mb-3" id="deleteItemType"></p>
                        <div class="alert alert-warning" id="deleteWarning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            This item is in use by <span id="deleteUsageCount" class="fw-semibold">0</span> tickets
                        </div>
                        <div class="alert alert-danger d-none" id="deleteForbidden">
                            <i class="bi bi-shield-exclamation me-2"></i>
                            Cannot delete items that are in use
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="delete_reason" class="form-label">Reason for Deletion (Optional)</label>
                        <textarea class="form-control modern-textarea" id="delete_reason" rows="2" placeholder="Enter reason..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteItem">
                        <i class="bi bi-trash me-1"></i>
                        Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1100;">
        <div id="liveToast" class="toast align-items-center border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <!-- Message here -->
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

</main>

<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
    console.log('[Categories] CONTEXT_PATH set to:', window.CONTEXT_PATH);
</script>
<script src="${pageContext.request.contextPath}/assets/js/ticket_categories.js"></script>