<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/accounts.css">
<main class="app-wrapper">
    <div class="container-fluid">
        
        <!-- Breadcrumb -->
        <!-- <div class="main-breadcrumb d-flex align-items-center justify-content-between my-4">
            <h2 class="breadcrumb-title mb-0 fs-14">User Management</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb justify-content-end mb-0">
                    <li class="breadcrumb-item"><a href="javascript:void(0)">System</a></li>
                    <li class="breadcrumb-item active" aria-current="page">User Accounts</li>
                </ol>
            </nav>
        </div> -->

        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div class="header-content">
                <h1 class="page-title mb-2">User Accounts</h1>
                <p class="page-subtitle text-muted mb-0">Manage system users, permissions, and access controls</p>
            </div>
            <div class="header-actions">
                <button class="btn btn-primary d-flex align-items-center gap-2" onclick="showUserModal()">
                    <i class="bi bi-person-plus"></i>
                    <span>Add User</span>
                </button>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row g-3 mb-4">
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #6366f1;">
                        <i class="bi bi-people"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="totalCount">0</div>
                        <div class="stat-label">Total Users</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #10b981;">
                        <i class="bi bi-person-check"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="activeCount">0</div>
                        <div class="stat-label">Active Users</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #ef4444;">
                        <i class="bi bi-person-x"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="inactiveCount">0</div>
                        <div class="stat-label">Deactivated</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-lg-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #8b5cf6;">
                        <i class="bi bi-shield-lock"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="adminCount">0</div>
                        <div class="stat-label">Administrators</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters Card -->
        <div class="card filter-card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-xl-4 col-lg-6">
                        <label class="form-label">Search Users</label>
                        <div class="search-box">
                            <i class="bi bi-search"></i>
                            <input type="text" id="users_search" class="form-control search-input" placeholder="Search by name, username, email, or phone...">
                        </div>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Status</label>
                        <select id="filter_status" class="form-select">
                            <option value="">All Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                            <option value="suspended">Suspended</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Role</label>
                        <select id="filter_role" class="form-select">
                            <option value="">All Roles</option>
                            <option value="admin">Administrator</option>
                            <option value="manager">Manager</option>
                            <option value="user">User</option>
                        </select>
                    </div>
                    <div class="col-xl-2 col-lg-3">
                        <label class="form-label">Organization</label>
                        <select id="filter_organization" class="form-select">
                            <option value="">All Organizations</option>
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
                    <h4 class="card-title mb-0">All Users</h4>
                    <p class="text-muted mb-0">Showing <span id="userCount">0</span> users</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-outline-secondary" id="refreshUsersBtn">
                        <i class="bi bi-arrow-clockwise"></i>
                        Refresh
                    </button>
                    <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="bi bi-download"></i> Export
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportUsers('csv')">CSV</a></li>
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportUsers('excel')">Excel</a></li>
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportUsers('pdf')">PDF</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="users-datatable" class="table table-hover">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Username</th>
                                <th>Contact</th>
                                <th>Role</th>
                                <th>Organization</th>
                                <th>Status</th>
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
                    Showing <span id="showingCount">0</span> of <span id="totalCountFooter">0</span> users
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
                <h5 class="card-title mb-0">User Preview</h5>
            </div>
            <div class="card-body">
                <div class="row" id="userPreview">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="user-avatar-preview">
                                    <img id="preview_avatar" src="${pageContext.request.contextPath}/assets/images/users/user-1.png" alt="Avatar">
                                </div>
                                <div>
                                    <h5 class="preview-title mb-1" id="preview_name">Select a user to preview</h5>
                                    <div class="badge-container">
                                        <span class="badge" id="preview_role">-</span>
                                        <span class="badge" id="preview_status">-</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Username</small></p>
                                <p class="fw-semibold" id="preview_username">-</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Organization</small></p>
                                <p class="fw-semibold" id="preview_organization">-</p>
                            </div>
                            <div class="col-md-12">
                                <p class="mb-1"><small class="text-muted">Email</small></p>
                                <p class="fw-semibold" id="preview_email">-</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <p class="mb-1"><small class="text-muted">Contact Information</small></p>
                            <p class="preview-description" id="preview_contact">-</p>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Account Created</small></p>
                                <p class="fw-semibold" id="preview_created">-</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><small class="text-muted">Last Login</small></p>
                                <p class="fw-semibold" id="preview_last_login">-</p>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <div id="preview_security" class="security-features">
                                    <small class="text-muted">No security features enabled</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> -->

    </div>

    <!-- Add User Modal -->
    <div class="modal fade modal-blur" id="addUserModal" tabindex="-1" aria-hidden="true" style="z-index: 2000;">
        <div class="modal-dialog modal-xl" style="margin-top: 100px;">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #6366f1;">
                            <i class="bi bi-person-plus"></i>
                        </div>
                        <div>
                            <h5 class="modal-title" id="addUserModalLabel">Add New User</h5>
                            <p class="text-muted mb-0">Create a new user account with permissions</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <form id="addUserForm" novalidate>
                        <input type="hidden" id="user_id" name="user_id">
                        <input type="hidden" id="requestType" name="requestType" value="addUser">
                        
                        <ul class="nav nav-tabs" id="userFormTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="personal-tab" data-bs-toggle="tab" data-bs-target="#personal" type="button">Personal Info</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="account-tab" data-bs-toggle="tab" data-bs-target="#account" type="button">Account</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="security-tab" data-bs-toggle="tab" data-bs-target="#security" type="button">Security</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="permissions-tab" data-bs-toggle="tab" data-bs-target="#permissions" type="button">Permissions</button>
                            </li>
                        </ul>
                        
                        <div class="tab-content pt-4" id="userFormTabContent">
                            <!-- Personal Information Tab -->
                            <div class="tab-pane fade show active" id="personal" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <label for="title" class="form-label">Title</label>
                                        <select id="title" name="title" class="form-select modern-select">
                                            <option value="">Select</option>
                                            <option value="Mr.">Mr.</option>
                                            <option value="Mrs.">Mrs.</option>
                                            <option value="Ms.">Ms.</option>
                                            <option value="Dr.">Dr.</option>
                                            <option value="Prof.">Prof.</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="first_name" class="form-label">First Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control modern-input" id="first_name" name="first_name" required>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="middle_name" class="form-label">Middle Name</label>
                                        <input type="text" class="form-control modern-input" id="middle_name" name="middle_name">
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="last_name" class="form-label">Last Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control modern-input" id="last_name" name="last_name" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="dob" class="form-label">Date of Birth</label>
                                        <input type="date" class="form-control modern-input" id="dob" name="dob">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="gender" class="form-label">Gender</label>
                                        <select id="gender" name="gender" class="form-select modern-select">
                                            <option value="">Select</option>
                                            <option value="Male">Male</option>
                                            <option value="Female">Female</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="country" class="form-label">Country</label>
                                        <input type="text" class="form-control modern-input" id="country" name="country" placeholder="e.g., Ghana">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="nationality" class="form-label">Nationality</label>
                                        <input type="text" class="form-control modern-input" id="nationality" name="nationality" placeholder="e.g., Ghanaian">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Account Information Tab -->
                            <div class="tab-pane fade" id="account" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control modern-input" id="username" name="username" required placeholder="e.g., johndoe" autocomplete="username">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control modern-input" id="email" name="email" required placeholder="user@example.com" autocomplete="email">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <label for="password" class="form-label mb-0">Password <span class="text-danger">*</span></label>
                                            <button type="button" class="btn btn-sm btn-link p-0 text-decoration-none" onclick="document.getElementById('password').value='Welcome@123';document.getElementById('confirm_password').value='Welcome@123'">Set Default (Welcome@123)</button>
                                        </div>
                                        <input type="password" class="form-control modern-input" id="password" name="password" required placeholder="Minimum 8 characters" autocomplete="new-password">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="confirm_password" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control modern-input" id="confirm_password" name="confirm_password" required autocomplete="new-password">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="org_select" class="form-label">Organization</label>
                                        <select id="org_select" name="org_id" class="form-select modern-select">
                                            <option value="">Select Organization</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="role" class="form-label">Role <span class="text-danger">*</span></label>
                                        <select id="role" name="role" class="form-select modern-select" required>
                                            <option value="">Select Role</option>
                                            <option value="admin">Administrator</option>
                                            <option value="manager">Manager</option>
                                            <option value="user">User</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="level" class="form-label">Access Level</label>
                                        <select id="level" name="level" class="form-select modern-select">
                                            <option value="1">Level 1 (Basic)</option>
                                            <option value="2">Level 2 (Standard)</option>
                                            <option value="3">Level 3 (Advanced)</option>
                                            <option value="4">Level 4 (Administrative)</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="phone_number" class="form-label">Phone Number</label>
                                        <div class="input-group">
                                            <select id="country_code" name="country_code" class="form-select modern-select" style="max-width: 100px;">
                                                <option value="+233">+233</option>
                                                <option value="+1">+1</option>
                                                <option value="+44">+44</option>
                                                <option value="+61">+61</option>
                                            </select>
                                            <input type="tel" class="form-control modern-input" id="phone_number" name="phone_number" placeholder="Phone number">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Security Settings Tab -->
                            <div class="tab-pane fade" id="security" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="status" class="form-label">Account Status</label>
                                        <select id="status" name="status" class="form-select modern-select">
                                            <option value="active">Active</option>
                                            <option value="inactive">Inactive</option>
                                            <option value="suspended">Suspended</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Password Policy</label>
                                        <div class="form-check form-switch mt-2">
                                            <input class="form-check-input" type="checkbox" id="expire_pass" name="expire_pass">
                                            <label class="form-check-label" for="expire_pass">
                                                Force Password Change (Expire Password)
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="card-title mb-0">Two-Factor Authentication</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="two_factor" id="two_factor_sms">
                                                    <label class="form-check-label" for="two_factor_sms">
                                                        SMS Authentication
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="two_factor" id="two_factor_email">
                                                    <label class="form-check-label" for="two_factor_email">
                                                        Email Authentication
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-12 mb-3">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="two_factor" id="two_factor_none" checked>
                                                    <label class="form-check-label" for="two_factor_none">
                                                        No Two-Factor Authentication
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card mt-3">
                                    <div class="card-header">
                                        <h6 class="card-title mb-0">Security Notifications</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" id="login_notification" name="login_notification">
                                            <label class="form-check-label" for="login_notification">
                                                Login Notifications
                                            </label>
                                        </div>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="login_approval" name="login_approval">
                                            <label class="form-check-label" for="login_approval">
                                                Require Approval for New Logins
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Permissions Tab -->
                            <div class="tab-pane fade" id="permissions" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label">Address Information</label>
                                        <input type="text" class="form-control modern-input mb-2" id="address" name="address" placeholder="Street address">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <input type="text" class="form-control modern-input mb-2" id="city" name="city" placeholder="City">
                                            </div>
                                            <div class="col-md-4">
                                                <input type="text" class="form-control modern-input mb-2" id="zip_code" name="zip_code" placeholder="Zip Code">
                                            </div>
                                            <div class="col-md-4">
                                                <input type="text" class="form-control modern-input" id="state" name="state" placeholder="State/Region">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle me-2"></i>
                                    <small>Menu permissions can be assigned after creating the user account.</small>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-secondary" id="prevUserStep" style="display:none;">Previous</button>
                    <button type="button" class="btn btn-primary" id="nextUserStep">Next</button>
                    <button type="button" class="btn btn-primary" id="submitUserForm" style="display:none;">
                        <i class="bi bi-plus-circle me-1"></i>
                        Create User
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- View User Modal -->
    <div class="modal fade modal-blur" id="viewUserModal" tabindex="-1" aria-hidden="true" style="z-index: 2000;">
        <div class="modal-dialog modal-xl" style="margin-top: 100px;">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #10b981;">
                            <i class="bi bi-person-badge"></i>
                        </div>
                        <div>
                            <h5 class="modal-title" id="viewUserName">User Details</h5>
                            <p class="text-muted mb-0" id="viewUserRole"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Personal & Account Information</h6>
                                </div>
                                <div class="card-body">
                                    <div id="userDetailsContent">
                                        <!-- User details will be populated here -->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Account Summary</h6>
                                </div>
                                <div class="card-body">
                                    <div class="summary-item">
                                        <span class="summary-label">Status:</span>
                                        <span class="summary-value badge" id="view_meta_status"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Role:</span>
                                        <span class="summary-value" id="view_meta_role"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Access Level:</span>
                                        <span class="summary-value" id="view_meta_level"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Organization:</span>
                                        <span class="summary-value" id="view_meta_organization"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Email:</span>
                                        <span class="summary-value" id="view_meta_email"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Phone:</span>
                                        <span class="summary-value" id="view_meta_phone"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">2FA:</span>
                                        <span class="summary-value" id="view_meta_2fa"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Created Date:</span>
                                        <span class="summary-value" id="view_meta_created"></span>
                                    </div>
                                    <div class="summary-item">
                                        <span class="summary-label">Last Login:</span>
                                        <span class="summary-value" id="view_meta_last_login"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Assigned Menus Section -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h6 class="card-title mb-0">Assigned Permissions & Menus</h6>
                                </div>
                                <div class="card-body">
                                    <div id="view_menus_list" class="menus-grid">
                                        <div class="text-center py-4">
                                            <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
                                            <span class="ms-2 text-muted">Loading assigned menus...</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="editFromViewBtn">
                        <i class="bi bi-pencil me-2"></i>
                        Edit User
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Assign Menus Modal -->
    <div class="modal fade modal-blur" id="assignMenusModal" tabindex="-1" aria-hidden="true" style="z-index: 2000;">
        <div class="modal-dialog modal-lg" style="margin-top: 100px;">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #8b5cf6;">
                            <i class="bi bi-list-check"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Assign Menu Permissions</h5>
                            <p class="text-muted mb-0" id="assign_user_name"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-0">
                    <input type="hidden" id="assign_user_id">
                    <div class="mb-3">
                        <label class="form-label">Select Menus</label>
                        <div class="form-control modern-select p-3" style="height: 300px; overflow-y: auto;" id="menusList">
                            <!-- Menus will be loaded here -->
                        </div>
                        <small class="text-muted">Selected menus will be accessible to this user</small>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i>
                        <small>Parent menus will automatically include access to their child menus</small>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitAssignMenus">
                        <i class="bi bi-check-circle me-1"></i>
                        Save Permissions
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Security Actions Modal -->
    <div class="modal fade modal-blur" id="securityActionModal" tabindex="-1" aria-hidden="true" style="z-index: 2000;">
        <div class="modal-dialog modal-md" style="margin-top: 100px;">
            <div class="modal-content modern-modal">
                <div class="modal-header border-0 pb-0">
                    <div class="d-flex align-items-center gap-3">
                        <div class="modal-icon" style="color: #f59e0b;">
                            <i class="bi bi-shield-lock"></i>
                        </div>
                        <div>
                            <h5 class="modal-title">Security Actions</h5>
                            <p class="text-muted mb-0" id="security_user_name"></p>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-3">
                    <form id="securityActionForm">
                        <input type="hidden" id="security_user_id" name="user_id">
                        
                        <!-- Force Password Change Toggle -->
                        <div class="mb-4 p-3 bg-light rounded-3 border">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="force_password_change" name="expire_pass">
                                <label class="form-check-label fw-bold" for="force_password_change">Force Password Change</label>
                            </div>
                            <small class="text-muted d-block mt-1">If enabled, the user will be forced to change their password upon next login.</small>
                        </div>

                        <h6 class="fw-bold mb-3">Set New Password</h6>

                        <!-- Default Password Section -->
                        <div class="mb-3">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <label class="form-label mb-0">Quick Password</label>
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="useDefaultPassword()">
                                    <i class="bi bi-magic me-1"></i> Apply
                                </button>
                            </div>
                            <div class="input-group input-group-sm">
                                <input type="text" class="form-control bg-white" id="default_password_display" value="Welcome@123" placeholder="Enter a temporary password">
                                <button class="btn btn-outline-secondary" type="button" onclick="copyDefaultPassword()">
                                    <i class="bi bi-clipboard"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="new_password" class="form-label">New Password</label>
                            <input type="password" class="form-control modern-input" id="new_password" name="new_password" placeholder="Leave empty to keep current password" autocomplete="new-password">
                        </div>
                        <div class="mb-3">
                            <label for="confirm_new_password" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control modern-input" id="confirm_new_password" name="confirm_new_password" placeholder="Confirm new password" autocomplete="new-password">
                        </div>
                    </form>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="submitSecurityAction">
                        <i class="bi bi-check-circle me-1"></i>
                        Save Changes
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade modal-blur" id="deleteConfirmModal" tabindex="-1" aria-hidden="true" style="z-index: 2000;">
        <div class="modal-dialog modal-sm" style="margin-top: 100px;">
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
                        <h6 class="mt-3 mb-2" id="deleteUserName"></h6>
                        <p class="text-muted mb-3">User Account</p>
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <span id="deleteWarningText">Are you sure you want to delete this user account?</span>
                        </div>
                        <div class="alert alert-danger d-none" id="deleteForbidden">
                            <i class="bi bi-shield-exclamation me-2"></i>
                            Cannot delete active administrators or users with active sessions
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="delete_reason" class="form-label">Reason for Deletion (Optional)</label>
                        <textarea class="form-control modern-textarea" id="delete_reason" rows="2" placeholder="Enter reason..."></textarea>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteUser">
                        <i class="bi bi-trash me-1"></i>
                        Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

</main>

<script>
     window.CONTEXT_PATH='${pageContext.request.contextPath}';
     window.CURRENT_USER_ROLE = "${userInfo.role}";
     
     // Debug role visible on screen
     document.addEventListener('DOMContentLoaded', function() {
        const role = window.CURRENT_USER_ROLE;
        if (!role || role.trim() === '') {
            console.error('User role is missing!');
        }
        
        // Check if debug banner already exists
        if (!document.getElementById('debug-role-banner')) {
            const banner = document.createElement('div');
            banner.id = 'debug-role-banner';
            banner.style.cssText = 'position: fixed; top: 0; left: 0; right: 0; background: #ffc107; color: #000; text-align: center; padding: 5px; z-index: 9999; font-weight: bold; font-size: 12px;';
            banner.innerHTML = 'DEBUG: Current User Role = [' + role + ']';
            
            // Only show if we suspect an issue (or always for now to verify)
            // document.body.appendChild(banner); 
            
            // Log to console is better for now, but user can't see console.
            // I will add a small text in the page header instead of a banner.
            const header = document.querySelector('.page-title');
            if(header) {
                 const debugSpan = document.createElement('span');
                 debugSpan.className = 'badge bg-warning text-dark ms-2';
                 debugSpan.style.fontSize = '0.6em';
                 debugSpan.textContent = 'Role: ' + (role || 'None');
                 header.appendChild(debugSpan);
            }
        }
     });
 </script>
 <script src="${pageContext.request.contextPath}/assets/js/accounts.js?v=${pageContext.session.lastAccessedTime}_updated"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Wizard Logic for Create User Modal
        const stepIds = ['personal-tab', 'account-tab', 'security-tab', 'permissions-tab'];
        let currentStepIndex = 0;

        const prevBtn = document.getElementById('prevUserStep');
        const nextBtn = document.getElementById('nextUserStep');
        const submitBtn = document.getElementById('submitUserForm');
        
        // Ensure buttons exist before attaching logic
        if (!prevBtn || !nextBtn || !submitBtn) return;

        function updateWizardState() {
            // Update Buttons
            prevBtn.style.display = currentStepIndex > 0 ? 'inline-block' : 'none';
            nextBtn.style.display = currentStepIndex < stepIds.length - 1 ? 'inline-block' : 'none';
            submitBtn.style.display = currentStepIndex === stepIds.length - 1 ? 'inline-block' : 'none';
            
            // Note: We don't programmatically show the tab here because this function
            // is called AFTER the tab is shown (via event listener) or when we want to switch tabs.
        }

        function switchTab(index) {
            if (index >= 0 && index < stepIds.length) {
                const tabEl = document.getElementById(stepIds[index]);
                if (tabEl) {
                    const tab = new bootstrap.Tab(tabEl);
                    tab.show();
                    // The 'shown.bs.tab' listener will update the state
                }
            }
        }

        prevBtn.addEventListener('click', function() {
            switchTab(currentStepIndex - 1);
        });

        nextBtn.addEventListener('click', function() {
            // Validate current step before moving (Optional)
            // if (!validateStep(currentStepIndex)) return;
            switchTab(currentStepIndex + 1);
        });

        // Sync state when tabs are clicked manually or switched programmatically
        stepIds.forEach((id, index) => {
            const el = document.getElementById(id);
            if (el) {
                el.addEventListener('shown.bs.tab', function() {
                    currentStepIndex = index;
                    updateWizardState();
                });
            }
        });

        // Reset wizard when modal opens
        const modal = document.getElementById('addUserModal');
        if (modal) {
            modal.addEventListener('show.bs.modal', function() {
                // Reset to first tab
                switchTab(0);
            });
        }
        
        // Initial state update
        updateWizardState();
    });
</script>
