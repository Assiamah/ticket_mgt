<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tickets.css">
<main class="app-wrapper">
  <div class="container-fluid">
    
    <!-- Page Header -->
    <div class="page-header d-flex align-items-center justify-content-between mb-4">
      <div class="header-content">
        <h1 class="page-title mb-2">Archived Tickets</h1>
        <p class="page-subtitle text-muted mb-0">View and manage tickets that have been archived</p>
      </div>
      <div class="header-actions">
        <button class="btn btn-outline-primary" id="refreshTicketsBtn">
          <i class="bi bi-arrow-clockwise me-1"></i>
          Refresh
        </button>
        <div class="dropdown">
          <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
            <i class="bi bi-download me-1"></i>
            Export
          </button>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportArchive('csv')">CSV</a></li>
            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportArchive('excel')">Excel</a></li>
            <li><a class="dropdown-item" href="javascript:void(0)" onclick="exportArchive('pdf')">PDF</a></li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Stats Row -->
    <div class="row g-3 mb-4">
      <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
        <div class="stat-card d-flex align-items-start">
          <div class="stat-icon text-muted">
            <i class="bi bi-archive"></i>
          </div>
          <div class="stat-content ms-3">
            <div class="stat-number" id="total_archived">0</div>
            <div class="stat-label">Total Archived</div>
          </div>
        </div>
      </div>
      <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
        <div class="stat-card d-flex align-items-start">
          <div class="stat-icon" style="color: #10b981;">
            <i class="bi bi-check-circle"></i>
          </div>
          <div class="stat-content ms-3">
            <div class="stat-number" id="archived_resolved">0</div>
            <div class="stat-label">Resolved</div>
          </div>
        </div>
      </div>
      <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
        <div class="stat-card d-flex align-items-start">
          <div class="stat-icon text-danger">
            <i class="bi bi-exclamation-octagon"></i>
          </div>
          <div class="stat-content ms-3">
            <div class="stat-number" id="archived_critical">0</div>
            <div class="stat-label">Critical</div>
          </div>
        </div>
      </div>
      <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
        <div class="stat-card d-flex align-items-start">
          <div class="stat-icon" style="color: #f97316;">
            <i class="bi bi-exclamation-triangle"></i>
          </div>
          <div class="stat-content ms-3">
            <div class="stat-number" id="archived_high">0</div>
            <div class="stat-label">High Priority</div>
          </div>
        </div>
      </div>
      <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
        <div class="stat-card d-flex align-items-start">
          <div class="stat-icon" style="color: #8b5cf6;">
            <i class="bi bi-clock-history"></i>
          </div>
          <div class="stat-content ms-3">
            <div class="stat-number" id="avg_archive_age">0</div>
            <div class="stat-label">Avg Archive Age</div>
          </div>
        </div>
      </div>
      <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
        <div class="stat-card d-flex align-items-start">
          <div class="stat-icon" style="color: #3b82f6;">
            <i class="bi bi-calendar"></i>
          </div>
          <div class="stat-content ms-3">
            <div class="stat-number" id="archived_this_month">0</div>
            <div class="stat-label">This Month</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Filters Card -->
    <div class="card filter-card mb-4">
      <div class="card-body">
        <div class="row g-3 align-items-end">
          <div class="col-xl-3 col-lg-4">
            <label class="form-label">Search Archived Tickets</label>
            <div class="search-box">
              <i class="bi bi-search"></i>
              <input type="text" id="search_archive" class="form-control search-input" placeholder="Search tickets, titles, descriptions...">
            </div>
          </div>
          <div class="col-xl-2 col-lg-3">
            <label class="form-label">Product</label>
            <select id="filter_product" class="form-select">
              <option value="">All Products</option>
            </select>
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
            <label class="form-label">From Date</label>
            <div class="search-box">
              <i class="bi bi-calendar"></i>
              <input type="date" class="form-control search-input" id="filter_from" placeholder="Start date">
            </div>
          </div>
          <div class="col-xl-2 col-lg-3">
            <label class="form-label">To Date</label>
            <div class="search-box">
              <i class="bi bi-calendar"></i>
              <input type="date" class="form-control search-input" id="filter_to" placeholder="End date">
            </div>
          </div>
          <div class="col-xl-1 col-lg-2">
            <div class="d-flex gap-2">
              <button id="applyFilters" class="btn btn-primary w-100">Apply</button>
              <button id="clearFilters" class="btn btn-outline-secondary w-100" title="Clear Filters">
                <i class="bi bi-x-lg"></i>
              </button>
            </div>
          </div>
        </div>
        <div class="row mt-3">
          <div class="col-12">
            <div class="form-check form-switch">
              <input class="form-check-input" type="checkbox" id="filter_recent_only">
              <label class="form-check-label" for="filter_recent_only">Show Recent Only (Last 30 days)</label>
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
          <h4 class="card-title mb-0">Archived Tickets</h4>
          <p class="text-muted mb-0">Showing <span id="archiveCount">0</span> archived tickets</p>
        </div>
        <div class="d-flex align-items-center gap-2">
          <div class="dropdown">
            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
              <i class="bi bi-funnel"></i>
              Archive Reason
            </button>
            <ul class="dropdown-menu" id="archiveReasonFilter">
              <li><a class="dropdown-item" href="javascript:void(0)" data-reason="">All Reasons</a></li>
              <li><a class="dropdown-item" href="javascript:void(0)" data-reason="resolved">Resolved</a></li>
              <li><a class="dropdown-item" href="javascript:void(0)" data-reason="duplicate">Duplicate</a></li>
              <li><a class="dropdown-item" href="javascript:void(0)" data-reason="no_response">No Response</a></li>
              <li><a class="dropdown-item" href="javascript:void(0)" data-reason="other">Other</a></li>
            </ul>
          </div>
          <button type="button" class="btn btn-sm btn-outline-secondary" id="refreshArchiveBtn">
            <i class="bi bi-arrow-clockwise"></i>
            Refresh
          </button>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table id="archive-datatable" class="table table-hover">
            <thead>
              <tr>
                <th>Ticket #</th>
                <th>Title</th>
                <th>Priority</th>
                <th>Status</th>
                <th>Archived By</th>
                <th>Archived Date</th>
                <th>Archive Reason</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody id="archiveTableBody">
              <!-- Data will be populated by JavaScript -->
            </tbody>
          </table>
        </div>
      </div>
      <div class="card-footer d-flex align-items-center justify-content-between">
        <div class="text-muted">
          Showing <span id="showingCount">0</span> of <span id="totalCount">0</span> archived tickets
        </div>
        <nav>
          <ul class="pagination pagination-sm mb-0" id="paginationControls">
            <!-- Pagination will be generated dynamically -->
          </ul>
        </nav>
      </div>
    </div>

    <!-- Restore Confirmation Modal -->
    <div class="modal fade modal-blur" id="restoreTicketModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-sm">
        <div class="modal-content modern-modal">
          <div class="modal-header border-0 pb-0">
            <div class="d-flex align-items-center gap-3">
              <div class="modal-icon" style="color: #10b981;">
                <i class="bi bi-arrow-counterclockwise"></i>
              </div>
              <div>
                <h5 class="modal-title">Restore Ticket</h5>
                <p class="text-muted mb-0">Move this ticket back to active tickets</p>
              </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body pt-0">
            <input type="hidden" id="restore_ticket_id">
            <div class="text-center mb-4">
              <div class="restore-icon">
                <i class="bi bi-arrow-counterclockwise" style="font-size: 2.5rem; color: #10b981;"></i>
              </div>
              <h6 class="mt-3 mb-2">Restore this ticket?</h6>
              <p class="text-muted mb-0">Ticket: <span id="restore_ticket_number" class="fw-semibold"></span></p>
              <p class="text-muted">The ticket will be moved back to active tickets.</p>
            </div>
            <div class="mb-3">
              <label for="restore_reason" class="form-label">Reason for Restoring (Optional)</label>
              <textarea class="form-control modern-textarea" id="restore_reason" rows="2" placeholder="Add reason for restoring..."></textarea>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-success" id="confirmRestoreBtn">
              <i class="bi bi-arrow-counterclockwise me-1"></i>
              Restore Ticket
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Permanently Modal -->
    <div class="modal fade modal-blur" id="deleteTicketModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-sm">
        <div class="modal-content modern-modal">
          <div class="modal-header border-0 pb-0">
            <div class="d-flex align-items-center gap-3">
              <div class="modal-icon text-danger">
                <i class="bi bi-trash"></i>
              </div>
              <div>
                <h5 class="modal-title">Delete Permanently</h5>
                <p class="text-muted mb-0">This action cannot be undone</p>
              </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body pt-0">
            <input type="hidden" id="delete_ticket_id">
            <div class="text-center mb-4">
              <div class="delete-icon">
                <i class="bi bi-trash" style="font-size: 2.5rem; color: #ef4444;"></i>
              </div>
              <h6 class="mt-3 mb-2">Delete permanently?</h6>
              <p class="text-muted mb-0">Ticket: <span id="delete_ticket_number" class="fw-semibold"></span></p>
              <p class="text-muted">This will permanently delete the ticket and all associated data.</p>
            </div>
            <div class="alert alert-warning">
              <i class="bi bi-exclamation-triangle me-2"></i>
              <small>This action cannot be undone. Please confirm you want to proceed.</small>
            </div>
            <div class="mb-3">
              <label for="delete_confirmation" class="form-label">Type "DELETE" to confirm</label>
              <input type="text" class="form-control modern-input" id="delete_confirmation" placeholder="Type DELETE here">
            </div>
          </div>
          <div class="modal-footer border-0">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-danger" id="confirmDeleteBtn" disabled>
              <i class="bi bi-trash me-1"></i>
              Delete Permanently
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- View Archive Details Modal -->
    <div class="modal fade modal-blur" id="viewArchiveModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content modern-modal">
          <div class="modal-header border-0 pb-0">
            <div class="d-flex align-items-center gap-3">
              <div class="modal-icon text-muted">
                <i class="bi bi-archive"></i>
              </div>
              <div>
                <h5 class="modal-title">Archive Details</h5>
                <p class="text-muted mb-0" id="view_archive_ticket_number"></p>
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
                    <h5 id="view_archive_title" class="mb-3"></h5>
                    <div class="row">
                      <div class="col-md-6">
                        <p class="mb-1"><small class="text-muted">Priority</small></p>
                        <p><span class="badge" id="view_archive_priority"></span></p>
                      </div>
                      <div class="col-md-6">
                        <p class="mb-1"><small class="text-muted">Status at Archive</small></p>
                        <p><span class="badge" id="view_archive_status"></span></p>
                      </div>
                      <div class="col-md-6">
                        <p class="mb-1"><small class="text-muted">Assigned To</small></p>
                        <p class="fw-semibold" id="view_archive_assigned_to"></p>
                      </div>
                      <div class="col-md-6">
                        <p class="mb-1"><small class="text-muted">Archived By</small></p>
                        <p class="fw-semibold" id="view_archive_by"></p>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card mt-3">
                  <div class="card-header">
                    <h6 class="card-title mb-0">Archive Information</h6>
                  </div>
                  <div class="card-body">
                    <div class="row">
                      <div class="col-md-6">
                        <p class="mb-1"><small class="text-muted">Archive Date</small></p>
                        <p class="fw-semibold" id="view_archive_date"></p>
                      </div>
                      <div class="col-md-6">
                        <p class="mb-1"><small class="text-muted">Archive Reason</small></p>
                        <p class="fw-semibold" id="view_archive_reason"></p>
                      </div>
                      <div class="col-12">
                        <p class="mb-1"><small class="text-muted">Archive Notes</small></p>
                        <p class="fw-semibold" id="view_archive_notes"></p>
                      </div>
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
                      <button type="button" class="btn btn-outline-success" id="restoreFromViewBtn">
                        <i class="bi bi-arrow-counterclockwise me-2"></i>
                        Restore Ticket
                      </button>
                      <button type="button" class="btn btn-outline-danger" id="deleteFromViewBtn">
                        <i class="bi bi-trash me-2"></i>
                        Delete Permanently
                      </button>
                      <button type="button" class="btn btn-outline-primary" id="exportFromViewBtn">
                        <i class="bi bi-download me-2"></i>
                        Export Details
                      </button>
                    </div>
                  </div>
                </div>
                <div class="card mt-3">
                  <div class="card-header">
                    <h6 class="card-title mb-0">Timeline</h6>
                  </div>
                  <div class="card-body">
                    <div class="timeline">
                      <div class="timeline-item">
                        <div class="timeline-marker"></div>
                        <div class="timeline-content">
                          <small class="text-muted">Archived</small>
                          <p class="mb-0 fw-semibold" id="view_archive_timeline"></p>
                        </div>
                      </div>
                      <div class="timeline-item">
                        <div class="timeline-marker"></div>
                        <div class="timeline-content">
                          <small class="text-muted">Created</small>
                          <p class="mb-0 fw-semibold" id="view_created_timeline"></p>
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

  <!-- Scripts -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/tickets.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/ticket_archive.js"></script>
</main>