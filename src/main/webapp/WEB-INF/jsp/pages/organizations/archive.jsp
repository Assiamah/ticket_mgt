<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/organizations.css">
<main class="app-wrapper">
    <div class="container-fluid">

        <!-- Header -->
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div class="header-content">
                <h1 class="page-title mb-2">Organization Archive</h1>
                <p class="page-subtitle text-muted mb-0">View and manage deactivated or historical organization records</p>
            </div>
            <div class="header-actions">
                <button type="button" class="btn btn-outline-secondary d-flex align-items-center gap-2" id="refreshArchiveBtn">
                    <i class="bi bi-arrow-clockwise"></i>
                    <span>Refresh</span>
                </button>
            </div>
        </div>

        <!-- Stats Cards Row -->
        <div class="row g-3 mb-4">
            <div class="col-xl-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #64748b;">
                        <i class="bi bi-archive"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="archived_total">0</div>
                        <div class="stat-label">Total Archived</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-md-6">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #ef4444;">
                        <i class="bi bi-trash"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="deleted_total">0</div>
                        <div class="stat-label">Pending Deletion</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-md-12">
                <div class="stat-card d-flex align-items-start">
                    <div class="stat-icon" style="color: #10b981;">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </div>
                    <div class="stat-content ms-3">
                        <div class="stat-number" id="restored_recent">0</div>
                        <div class="stat-label">Recently Restored</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Card -->
        <div class="card content-card">
            <div class="card-header d-flex align-items-center justify-content-between bg-transparent border-bottom">
                <h4 class="card-title mb-0">Archived Records</h4>
                <div class="search-box">
                    <i class="bi bi-search"></i>
                    <input type="text" id="archive_search" class="form-control form-control-sm" placeholder="Search archive...">
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table id="org-archive-datatable" class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th>Organization</th>
                                <th>Archive Date</th>
                                <th>Reason</th>
                                <th>Previous Status</th>
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
    </div>
</main>

<script>
    window.CONTEXT_PATH = "${pageContext.request.contextPath}";
    // Inject Organization ID from session userInfo
    // Try multiple possible keys as backend does
    window.CURRENT_USER_ORG_ID = "${userInfo.org_id}";
    if (!window.CURRENT_USER_ORG_ID || window.CURRENT_USER_ORG_ID === '') window.CURRENT_USER_ORG_ID = "${userInfo.organization_id}";
    if (!window.CURRENT_USER_ORG_ID || window.CURRENT_USER_ORG_ID === '') window.CURRENT_USER_ORG_ID = "${userInfo.organizationId}";
    if (!window.CURRENT_USER_ORG_ID || window.CURRENT_USER_ORG_ID === '') window.CURRENT_USER_ORG_ID = "${userInfo.company_id}";
    if (!window.CURRENT_USER_ORG_ID || window.CURRENT_USER_ORG_ID === '') window.CURRENT_USER_ORG_ID = "${userInfo.business_id}";
    // Nested organization object check
    if (!window.CURRENT_USER_ORG_ID || window.CURRENT_USER_ORG_ID === '') window.CURRENT_USER_ORG_ID = "${userInfo.organization.id}";
    if (!window.CURRENT_USER_ORG_ID || window.CURRENT_USER_ORG_ID === '') window.CURRENT_USER_ORG_ID = "${userInfo.organization.org_id}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/organizations_archive.js?v=<%=System.currentTimeMillis()%>"></script>
