<!-- Analytics Report Generator Modal -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-fullscreen-xl-down modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg overflow-hidden" style="border-radius: 24px;">
            <!-- Modal Header with Gradient -->
            <div class="modal-header border-0 px-4 py-4 position-relative overflow-hidden" 
                 style="background: linear-gradient(135deg, var(--primary-color) 0%, #4f46e5 100%);">
                <div class="header-background-pattern"></div>
                <div class="position-relative z-2 d-flex align-items-center w-100">
                    <div class="d-flex align-items-center gap-3 flex-grow-1">
                        <div class="header-icon rounded-3 p-3 bg-white bg-opacity-20">
                            <i class="bi bi-bar-chart-line-fill text-white fs-3"></i>
                        </div>
                        <div>
                            <h5 class="modal-title fw-bold mb-1 text-white" id="reportModalLabel">Analytics Report Generator</h5>
                            <p class="mb-0 text-white text-opacity-85 small">Create comprehensive reports with interactive visual insights</p>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
            </div>

            <div class="modal-body p-0">
                <div class="d-flex flex-column flex-lg-row h-100" style="min-height: 70vh;">
                    <!-- Left Sidebar: Configuration -->
                    <div class="report-config-panel bg-light p-4 border-end" style="width: 100%; max-width: 380px;">
                        
                        <!-- Report Identity -->
                        <div class="report-section mb-4">
                            <label class="form-label fw-bold text-muted small text-uppercase mb-3">Report Configuration</label>
                            
                            <div class="mb-3">
                                <label for="reportType" class="form-label smaller fw-bold">Report Template</label>
                                <select class="form-select form-select-sm border-0 shadow-sm" id="reportType">
                                    <option value="summary" selected>Executive Summary Overview</option>
                                    <option value="detailed">Comprehensive Detailed Breakdown</option>
                                </select>
                                <div id="reportTypeDescription" class="form-text smaller text-muted mt-2">
                                    Overview with key metrics and trend charts.
                                </div>
                            </div>
                        </div>

                        <!-- Analysis Period -->
                        <div class="report-section mb-4">
                            <label class="form-label fw-bold text-muted small text-uppercase mb-3">Analysis Period</label>
                            <div class="content-card p-3 border-0">
                                <div class="mb-3">
                                    <label class="form-label smaller fw-bold">Start Date</label>
                                    <input type="date" id="reportStartDate" class="form-control form-control-sm border-0 shadow-sm">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label smaller fw-bold">End Date</label>
                                    <input type="date" id="reportEndDate" class="form-control form-control-sm border-0 shadow-sm">
                                </div>
                                <div class="d-flex gap-2 mt-3">
                                    <button id="applyReportDateFilter" class="btn btn-primary btn-sm w-100">Apply Period</button>
                                    <button id="resetReportDateFilter" class="btn btn-outline-secondary btn-sm px-3"><i class="bi bi-arrow-counterclockwise"></i></button>
                                </div>
                            </div>
                        </div>

                        <!-- Data Inclusion -->
                        <div class="report-section mb-4">
                            <label class="form-label fw-bold text-muted small text-uppercase mb-3">Data Visualization</label>
                            
                            <div class="priority-filter-group d-flex flex-wrap gap-2 mb-3">
                                <div class="priority-filter-item flex-grow-1">
                                    <input type="checkbox" class="btn-check" id="filterPrioHigh" checked autocomplete="off">
                                    <label class="btn btn-outline-danger btn-sm w-100" for="filterPrioHigh">High</label>
                                </div>
                                <div class="priority-filter-item flex-grow-1">
                                    <input type="checkbox" class="btn-check" id="filterPrioMed" checked autocomplete="off">
                                    <label class="btn btn-outline-warning btn-sm w-100" for="filterPrioMed">Med</label>
                                </div>
                                <div class="priority-filter-item flex-grow-1">
                                    <input type="checkbox" class="btn-check" id="filterPrioLow" checked autocomplete="off">
                                    <label class="btn btn-outline-info btn-sm w-100" for="filterPrioLow">Low</label>
                                </div>
                            </div>

                            <div class="content-card p-3 border-0">
                                <div class="form-check form-switch form-switch-custom mb-3">
                                    <input class="form-check-input" type="checkbox" id="includeCharts" checked>
                                    <label class="form-check-label smaller fw-bold ms-2" for="includeCharts">Include Trend Charts</label>
                                </div>
                                <div class="form-check form-switch form-switch-custom mb-3">
                                    <input class="form-check-input" type="checkbox" id="includeSummary" checked>
                                    <label class="form-check-label smaller fw-bold ms-2" for="includeSummary">Executive Summary</label>
                                </div>
                                <hr class="my-3 opacity-10">
                                <div class="form-check form-switch form-switch-custom mb-2">
                                    <input class="form-check-input" type="checkbox" id="scopeOrgs" checked>
                                    <label class="form-check-label smaller fw-bold ms-2" for="scopeOrgs">Organizations Scope</label>
                                </div>
                                <div class="form-check form-switch form-switch-custom mb-2">
                                    <input class="form-check-input" type="checkbox" id="scopeUsers" checked>
                                    <label class="form-check-label smaller fw-bold ms-2" for="scopeUsers">Users Participation</label>
                                </div>
                                <div class="form-check form-switch form-switch-custom">
                                    <input class="form-check-input" type="checkbox" id="scopeTickets" checked>
                                    <label class="form-check-label smaller fw-bold ms-2" for="scopeTickets">Ticket Details</label>
                                </div>
                            </div>
                        </div>

                        <button id="resetReportFilters" class="btn btn-link btn-sm text-muted text-decoration-none w-100">
                            <i class="bi bi-trash3 me-2"></i>Reset All Configuration
                        </button>
                    </div>

                    <!-- Right Panel: Live Preview -->
                    <div class="report-preview-panel flex-grow-1 bg-light p-4 p-lg-5 overflow-auto">
                        <div class="report-preview-canvas shadow-lg mx-auto position-relative">
                            <div id="reportPreviewContent">
                                <!-- Initial state or data will be injected here -->
                                <div class="text-center py-5">
                                    <div class="spinner-border text-primary mb-3" role="status"></div>
                                    <p class="text-muted">Preparing report preview...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Footer: Export Actions -->
            <div class="modal-footer border-0 px-4 py-3 bg-white shadow-lg export-actions-bar">
                <div class="d-flex align-items-center gap-3 w-100">
                    <div class="flex-grow-1 d-none d-md-block">
                        <span class="text-muted small">Ready to export in high resolution</span>
                    </div>
                    <div class="d-flex gap-2 w-100 w-md-auto">
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Close</button>
                        <button type="button" id="exportCsvBtn" class="btn btn-outline-primary px-4">
                            <i class="bi bi-file-earmark-spreadsheet me-2"></i>CSV
                        </button>
                        <button type="button" id="exportPdfBtn" class="btn btn-primary px-4 shadow-sm">
                            <i class="bi bi-file-earmark-pdf-fill me-2"></i>Export PDF
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
