<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
    <div class="container-fluid">

        <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
            <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Manage Tickets</h2>
            <div class="flex-shrink-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-end mb-0">
                        <li class="breadcrumb-item"><a href="javascript:void(0)">Tickets</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Manage Tickets</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-12">
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createTicketModal">
                        <i class="ri-draft-line"></i> Create Ticket
                    </button>
                    <div class="ms-auto">
                        <button type="button" class="btn btn-outline-primary" id="refreshTicketsBtn">
                            <i class="ri-refresh-line"></i> Refresh
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Status & Priority Cards -->
        <div class="row g-3 mb-3">
            <div class="col-md-2">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">Open</div>
                            <div class="fs-5 fw-semibold" id="status_open">0</div>
                        </div>
                        <i class="ri-record-circle-line text-primary"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">In Progress</div>
                            <div class="fs-5 fw-semibold" id="status_in_progress">0</div>
                        </div>
                        <i class="ri-run-line text-info"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">On Hold</div>
                            <div class="fs-5 fw-semibold" id="status_on_hold">0</div>
                        </div>
                        <i class="ri-pause-circle-line text-warning"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">Resolved</div>
                            <div class="fs-5 fw-semibold" id="status_resolved">0</div>
                        </div>
                        <i class="ri-checkbox-circle-line text-success"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">Closed</div>
                            <div class="fs-5 fw-semibold" id="status_closed">0</div>
                        </div>
                        <i class="ri-close-circle-line text-secondary"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">High</div>
                            <div class="fs-5 fw-semibold text-danger" id="priority_high">0</div>
                        </div>
                        <i class="ri-alarm-warning-line text-danger"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">Medium</div>
                            <div class="fs-5 fw-semibold text-warning" id="priority_medium">0</div>
                        </div>
                        <i class="ri-time-line text-warning"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">Low</div>
                            <div class="fs-5 fw-semibold text-success" id="priority_low">0</div>
                        </div>
                        <i class="ri-leaf-line text-success"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted">Critical</div>
                            <div class="fs-5 fw-semibold text-danger" id="priority_critical">0</div>
                        </div>
                        <i class="ri-flashlight-line text-danger"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <input id="tickets_search" type="text" class="form-control" placeholder="Search tickets">
            </div>
            <div class="col-md-2">
                <select id="filter_status" class="form-select">
                    <option value="">All Statuses</option>
                    <option value="open">Open</option>
                    <option value="in progress">In Progress</option>
                    <option value="on hold">On Hold</option>
                    <option value="resolved">Resolved</option>
                    <option value="closed">Closed</option>
                </select>
            </div>
            <div class="col-md-2">
                <select id="filter_priority" class="form-select">
                    <option value="">All Priorities</option>
                    <option value="high">High</option>
                    <option value="medium">Medium</option>
                    <option value="low">Low</option>
                    <option value="critical">Critical</option>
                </select>
            </div>
            <div class="col-md-2">
                <div class="form-check pt-2">
                    <input class="form-check-input" type="checkbox" id="filter_unassigned">
                    <label class="form-check-label" for="filter_unassigned">Unassigned only</label>
                </div>
            </div>
            <div class="col-md-2">
                <input id="filter_start" type="date" class="form-control" placeholder="Start date">
            </div>
            <div class="col-md-2">
                <input id="filter_end" type="date" class="form-control" placeholder="End date">
            </div>
            <div class="col-md-1 d-none d-md-block">
                <button id="clearFiltersBtn" class="btn btn-outline-secondary w-100">Clear</button>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <p class="text-muted mb-4 col-8">
                            Manage support tickets with this interactive DataTable. View, assign, update, or close tickets easily.
                        </p>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="tickets-datatable" class="table table-striped dt-responsive w-100">
                                <thead>
                                    <tr>
                                        <th>Ticket #</th>
                                        <th>Title</th>
                                        <th>Type</th>
                                        <th>Priority</th>
                                        <th>Description</th>
                                        <th>Created By</th>
                                        <th>Remarks </th>
                                        <th>Status</th>
                                        <th>Company Name</th>
                                        <th>Assigned To</th>
                                        <th>Created Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Data will be populated by JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-3">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h6 class="card-title mb-0">Quick Preview</h6>
                    </div>
                    <div class="card-body">
                        <div id="ticketPreview">
                            <div class="mb-2"><strong id="preview_ticket_number"></strong></div>
                            <div class="mb-2" id="preview_title"></div>
                            <div class="mb-2"><span class="badge" id="preview_status"></span> <span class="badge" id="preview_priority"></span></div>
                            <div class="mb-2"><span id="preview_assigned_to"></span></div>
                            <div class="mb-2"><span id="preview_created_by"></span></div>
                            <div class="mb-2"><span id="preview_due_date"></span></div>
                            <div class="mb-2" id="preview_description"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        </div>

    <!-- Create Ticket Modal -->
    <div class="modal fade modal-blur" id="createTicketModal" tabindex="-1" aria-labelledby="createTicketModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content modern-modal">
                    <div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.10), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);">
                                <i class="bi bi-plus-circle-fill text-primary fs-4"></i>
                            </div>
                            <div>
                                <h5 id="createTicketModalLabel" class="mb-0 fw-semibold">Create New Ticket</h5>
                                <small class="text-muted">Fill in the details to create a ticket</small>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                <div class="modal-body">
                    <form id="createTicketForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="organization_id" class="form-label">Organization</label>
                                <select id="organization_id" class="form-select"></select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="task_subject" class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="task_subject" required>
                            </div>
                            <div class="col-md-6 mb-3">
                               <label for="priority_id" class="form-label">Priority <span class="text-danger">*</span></label>
                                    <select id="priority_id" class="form-select" required>
                                        <option value="">Select Priority</option>
                                    </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="status_id" class="form-label">Status</label>
                                <select id="status_id" class="form-select">
                                    <option value="">Select Status</option>
                                </select>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="task_type" class="form-label">Type<span class="text-danger">*</span></label>
                                <select class="form-select" id="task_type" required>
                                    <option value="">Select Type</option>
                                    <option value="customer-service">Customer Service</option>
                                    <option value="it">IT</option>
                                    <option value="pur">purchasing</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="product_id" class="form-label">Product <span class="text-danger">*</span></label>
                                <select id="product_id" class="form-select" required>
                                    <option value="">Select Product</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="category_id" class="form-label">Category <span class="text-danger">*</span></label>
                                <select id="category_id" class="form-select" required>
                                    <option value="">Select Category</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="due_date" class="form-label">Due Date</label>
                                <input type="date" class="form-control" id="due_date">
                            </div>
                        </div>
                        <div class="row">
                            
                        </div>
                        <div class="mb-3">
                            <label for="task_description" class="form-label">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="task_description" rows="4" required></textarea>
                        </div>
                        </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="createTicketBtn">Create Ticket</button>
                </div>
            </div>
        </div>
    </div>
    <!-- View Ticket Modal -->
    <div class="modal fade" id="viewTicketModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
                <div class="modal-content modern-modal">
                    <div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.08), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);">
                                <i class="bi bi-card-text text-primary fs-4"></i>
                            </div>
                            <div>
                                <h5 class="mb-0 fw-semibold">Ticket Details</h5>
                                <small class="text-muted">View the ticket and its activity</small>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-8">
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
                   
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Summary</h6>
                                </div>
                                <div class="card-body">
                                    <p class="mb-2"><strong>Status: </strong> <span id="view_meta_status" class="badge bg-secondary">&nbsp;</span></p>
                                    <p class="mb-2"><strong>Priority: </strong> <span id="view_meta_priority" class="badge bg-secondary">&nbsp;</span></p>
                                    <p class="mb-2"><strong>Assigned To: </strong> <span id="view_meta_assigned_to" class="text-muted">&nbsp;</span></p>
                                    <p class="mb-2"><strong>Created By: </strong> <span id="view_meta_created_by" class="text-muted">&nbsp;</span></p>
                                    <p class="mb-0"><strong>Due Date: </strong> <span id="view_meta_due_date" class="text-muted">&nbsp;</span></p>
                                </div>
                            </div>
                            <!-- Optional: history card can be re-enabled below if needed -->
                            <!--
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Ticket History</h6>
                                </div>
                                <div class="card-body">
                                    <div id="ticketHistory">
                                  
                                    </div>
                                </div>
                            </div>
                            -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Ticket Modal -->
    <div class="modal fade modal-blur" id="editTicketModal" tabindex="-1" aria-labelledby="editTicketModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content modern-modal">
            <div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.08), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);">
                        <i class="bi bi-pencil-square text-primary fs-4"></i>
                    </div>
                    <div>
                        <h5 class="mb-0 fw-semibold" id="editTicketModalLabel">Update Ticket</h5>
                        <small class="text-muted">Modify ticket details</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editTicketForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="task_subject" class="form-label">Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="edit_task_subject" required>
                        </div>
                        <div class="col-md-6 mb-3">
                           <label for="task_priority" class="form-label">Priority <span class="text-danger">*</span></label>
                                <select id="edit_task_priority" class="form-select" required>
                                    <option value="">Select Priority</option>
                                    <option value="high">High</option>
                                    <option value="medium">Medium</option>
                                    <option value="low">Low</option>
                                </select>


                                <!-- Will be populated dynamically -->

                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="task_type" class="form-label">Type<span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="edit_task_type" required>

                                <!-- Will be populated dynamically -->
                            </select>
                        </div>


                     <input type="hidden" class="form-control" id="edit_task_id"  required>

                    

                        <div class="col-md-6 mb-3">
                            <label for="task_remarks" class="form-label">Remarks <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="edit_task_remarks" rows="4" required></textarea>

                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="task_description" class="form-label">Description <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="edit_task_description" rows="4" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="updateTicket">Update Ticket</button>
            </div>
        </div>
    </div>
    </div>

    <!-- assign Ticket Modal -->
    <div class="modal fade modal-blur" id="assignTicketModal" tabindex="-1" aria-labelledby="assignTicketModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content modern-modal">
            <div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.06), rgba(var(--bs-primary-rgb),0.02));">
                <div class="d-flex align-items-center gap-3">
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:46px;height:46px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.08), rgba(var(--bs-primary-rgb),0.03));box-shadow:0 6px 18px rgba(0,0,0,0.04);">
                        <i class="bi bi-person-plus-fill text-primary fs-4"></i>
                    </div>
                    <div>
                        <h5 class="mb-0 fw-semibold" id="assignTicketModalLabel">Assign Ticket</h5>
                        <small class="text-muted">Choose an agent to assign this ticket to</small>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="assignTicketForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="task_subject" class="form-label">Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="assign_task_subject" required>
                        </div>
                        <div class="col-md-6 mb-3">
                           <label for="task_priority" class="form-label">Priority <span class="text-danger">*</span></label>
                                <select id="assign_task_priority" class="form-select" required>
                                    <option value="">Select Priority</option>
                                    <option value="high">High</option>
                                    <option value="medium">Medium</option>
                                    <option value="low">Low</option>
                                </select>


                                <!-- Will be populated dynamically -->

                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="task_type" class="form-label">Type<span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="assign_task_type" required>

                                <!-- Will be populated dynamically -->
                            </select>
                        </div>


                     <input type="hidden" class="form-control" id="assign_task_id"  required>

                    

                        <div class="col-md-6 mb-3">
                            <label for="task_remarks" class="form-label">Remarks <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="assign_task_remarks" rows="4" required></textarea>

                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="task_description" class="form-label">Description <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="assign_task_description" rows="4" required></textarea>
                    </div>

                   <label for="assign_task_to" class="form-label">Assign To <span class="text-danger">*</span></label>
                        <select id="assign_task_to" class="form-select" required>
                            <option value="">Select User</option>
                            <option value="john_doe">John Doe</option>
                            <option value="jane_doe">Jane Doe</option>
                            <option value="kwame">Kwame</option>
                            <option value="michael_asare">Michael Asare</option>
                        </select>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="assignTicketBtn">Assign Ticket</button>
            </div>
        </div>
    </div>
    </div>

    <!-- Archive Ticket Modal (modernized) -->
    <div class="modal fade" id="archiveTicketModal" tabindex="-1" aria-labelledby="archiveTicketModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content archive-modal shadow-sm border-0">
                <div class="modal-header align-items-center py-3 border-0" style="background: linear-gradient(90deg, rgba(var(--bs-primary-rgb),0.08), rgba(var(--bs-primary-rgb),0.02));">
                    <div class="d-flex align-items-center gap-3">
                        <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:54px;height:54px;background:linear-gradient(135deg, rgba(var(--bs-primary-rgb),0.12), rgba(var(--bs-primary-rgb),0.04));box-shadow:0 6px 18px rgba(0,0,0,0.06);">
                            <i class="bi bi-archive-fill text-primary fs-3"></i>
                        </div>
                        <div>
                            <h5 id="archiveTicketModalLabel" class="mb-0 fw-semibold">Archive ticket</h5>
                            <small class="text-muted">Move this ticket to the archive</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <form id="archiveTicketForm" class="modal-body px-4 py-3">
                    <input type="hidden" id="archive_task_id">

                    <div class="mb-3 text-center">
                        <p class="mb-1 fw-medium" id="archive_task_subject" style="font-size:1rem;color:#333;"></p>
                        <small id="archive_task_ticket_no" class="text-muted">&nbsp;</small>
                    </div>

                    <!-- Simplified modal: no extra options -->
                    <div class="d-flex gap-2 justify-content-center">
                        <button type="button" class="btn btn-outline-secondary btn-sm px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary btn-sm px-4" id="confirmArchiveBtn">Archive</button>
                    </div>
                </form>
                <style>
                    /* Small styles scoped to the app modals to match the aesthetic */
                    .archive-modal .modal-content,
                    .modern-modal .modal-content { border-radius:12px; }

                    .archive-modal .form-control,
                    .modern-modal .form-control { border-radius:8px; }

                    /* Ensure the primary button is always visible even if CSS vars are not present */
                    .archive-modal .btn-primary,
                    .modern-modal .btn-primary {
                        /* fallback background color, plus a subtle gradient on top */
                        background-color: var(--bs-primary, #0d6efd);
                        background-image: linear-gradient(180deg, rgba(13,110,253,0.95), #0b5ed7);
                        border: none;
                        color: #fff;
                        box-shadow: 0 6px 18px rgba(11,94,215,0.12);
                    }
                    .archive-modal .btn-primary:hover,
                    .modern-modal .btn-primary:hover{ filter:brightness(.98); }

                    /* Header tweaks for modern modals */
                    .modern-modal .modal-header { padding: 1rem 1.25rem; border-bottom: none; }
                    .modern-modal .modal-content { overflow: hidden; }

                    /* Footer button rounding */
                    .modern-modal .modal-footer .btn { border-radius:8px; }
                </style>
            </div>
        </div>
    </div>


 


</main>

<script>
document.addEventListener('DOMContentLoaded', function() {


          window.showNotification = function(message, type = 'success') {
        Toastify({
            text: message,
            duration: 3000,
            close: true,
            gravity: "top",
            position: "right",
            backgroundColor: type === 'success' ? '#28a745' : 
                           type === 'error' ? '#dc3545' :
                           type === 'warning' ? '#ffc107' : '#17a2b8',
        }).showToast();
    }




    // Constants
    const TICKET_API_BASE = '${pageContext.request.contextPath}/api/tickets';
    const ORG_API = '${pageContext.request.contextPath}/api/organizations';
    const ticketTable = initTicketsDataTable();
    let allTicketsRows = [];
    
    // Initialize the page
    loadInitialData();
    setupEventListeners();

function initTicketsDataTable() {
    return $('#tickets-datatable').DataTable({
            columns: [
                { data: null, orderable: true, render: function(_, __, row){ return row.task_ticket_no || row.ticket_number || row.ticket_no || ''; } },
                { data: null, orderable: true, render: function(_, __, row){ return row.task_subject || row.title || ''; } },
                { 
                    data: 'task_type',
                    render: function(data, type, row) {
                        const priorityClass = getPriorityClass(row.priority_level);
                        return `<span class="badge bg-`+priorityClass+`">`+data+`</span>`;
                    }
                },
                // { 
                //     data: 'status_name',
                //     render: function(data, type, row) {
                //         const statusClass = getStatusClass(data);
                //         return `<span class="badge bg-`+statusClass+`">`+data+`</span>`;
                //     }
                // },
                { data: null, orderable: true, render: function(_, __, row){ return row.task_priority || row.priority_name || ''; } },
                { data: null, orderable: true, render: function(_, __, row){ return row.task_description || row.description || ''; } },
                { data: 'created_by', orderable: true },
                { data: 'task_remarks', orderable: true },
                { data: null, orderable: true, render: function(_, __, row){ return row.task_status || row.status_name || ''; } },
                {
                    data: null,
                    orderable: true,
                    defaultContent: '',
                    render: function(data, type, row) {
                        return row.created_by_org_name || row.comp_name || row.org_name || row.organization_name || row.company_name || row.company || '';
                    }
                },
                { data: null, orderable: true, render: function(_, __, row){ return row.task_assigned_to || row.assigned_to_name || ''; } },
                // { 
                //     data: 'task_read_status',
                //     render: function(data) {
                //         return formatDate(data);
                //     }
                // },
                { 
                    data: null,
                    render: function(_, __, row) {
                        const data = row.created_date || row.created_at;
                        const dueDate = new Date(data);
                        const now = new Date();
                        const isOverdue = dueDate < now;
                        const cls = isOverdue ? 'text-danger' : '';
                        return `<span class="${cls}">`+formatDate(data)+`</span>`;
                    }
                },
                {
                    data: null,
                    orderable: false,
                    className: 'text-end',
                    render: function(data, type, row) {
                        return `
                            <div class="d-flex gap-2 justify-content-end">
                                <button type="button" class="btn btn-light-info icon-btn-sm btn-view" data-task-id="`+(row.ticket_id||'')+`" data-task-uid="`+(row.task_uid||'')+`" title="View Ticket">
                                    <i class="mdi mdi-eye"></i>
                                </button>
                                <button type="button" class="btn btn-light-success icon-btn-sm btn-edit" data-task-id="`+(row.ticket_id||'')+`" data-task-uid="`+(row.task_uid||'')+`" title="Edit Ticket">
                                    <i class="mdi mdi-grease-pencil"></i>
                                </button>
                                 <button type="button" class="btn btn-light-success icon-btn-sm btn-assign" data-task-id="`+(row.ticket_id||'')+`" data-task-uid="`+(row.task_uid||'')+`" title="Assign Ticket">
                                    <i class="bi bi-person-check"></i>
                                </button>

                                <button type="button" class="btn btn-light-danger icon-btn-sm btn-archive" data-task-id="`+(row.ticket_id||'')+`" data-task-uid="`+(row.task_uid||'')+`" title="Archive Ticket">
                                    <i class="bi bi-archive"></i>
                                </button>
                            </div>
                        `;
                    }
                }
            ],
            dom: "<'d-flex align-items-center mb-2'<'btn-left'B><'ms-auto'f>>" +
                 "<'row'<'col-sm-12'tr>>" +
                 "<'row mt-2'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'p>>",
            buttons: [
                {
                    extend: 'copyHtml5',
                    text: '<i class="mdi mdi-content-copy me-1"></i> Copy',
                    className: 'btn btn-sm btn-outline-danger me-1'
                },
                {
                    extend: 'csvHtml5',
                    text: '<i class="mdi mdi-file-excel me-1"></i> CSV',
                    className: 'btn btn-sm btn-outline-success me-1'
                },
                {
                    extend: 'print',
                    text: '<i class="bi bi-printer me-1"></i> Print',
                    className: 'btn btn-sm btn-outline-info me-1'
                }
            ]
        });
    }

    function loadInitialData() {
        loadTickets();
        loadCreateContext();
        loadPriorities();
        loadStatuses();
        loadCategories();
    }

    function setupEventListeners() {
    // Refresh button
    document.getElementById('refreshTicketsBtn').addEventListener('click', loadTickets);
    
    // Create ticket button
    document.getElementById('createTicketBtn').addEventListener('click', createTicket);

    const orgSelEl = document.getElementById('organization_id');
    if (orgSelEl) orgSelEl.addEventListener('change', function(){ loadCreateContext(this.value); });
    

    // Update ticket buttons (guarded in case some modals do not include them)
    const updateTicketEl = document.getElementById('updateTicket');
    if (updateTicketEl) updateTicketEl.addEventListener('click', updateTicket);
    const updateTicketBtnEl = document.getElementById('updateTicketBtn');
    if (updateTicketBtnEl) updateTicketBtnEl.addEventListener('click', updateTicket);

    // Archive ticket button
    document.getElementById('confirmArchiveBtn').addEventListener('click', confirmArchiveTicket);

    // Assign ticket button
    document.getElementById('assignTicketBtn').addEventListener('click', submitAssignTicket);

    // document.getElementById('assignTicketBtn').addEventListener('click', submitAssignTicket);
    
    // View ticket modal events (delegated)
    document.addEventListener('click', function(e) {
        const v = e.target.closest('.btn-view');
        if (v) {
            const taskId = v.dataset.taskId || '';
            const taskUid = v.dataset.taskUid || '';
            viewTicket(taskId, taskUid);
            return;
        }
        const ed = e.target.closest('.btn-edit');
        if (ed) {
            const taskId = ed.dataset.taskId || '';
            const taskUid = ed.dataset.taskUid || '';
            editTicket(taskId, taskUid);
            return;
        }
        const asn = e.target.closest('.btn-assign');
        if (asn) {
            const taskId = asn.dataset.taskId || '';
            const taskUid = asn.dataset.taskUid || '';
            assignTicket(taskId, taskUid);
            return;
        }
        const ar = e.target.closest('.btn-archive');
        if (ar) {
            const taskId = ar.dataset.taskId || '';
            const taskUid = ar.dataset.taskUid || '';
            archiveTicket(taskId, taskUid);
        }
    });
}

    var fs = document.getElementById('tickets_search'); if (fs) fs.addEventListener('input', renderTickets);
    var st = document.getElementById('filter_status'); if (st) st.addEventListener('change', renderTickets);
    var pr = document.getElementById('filter_priority'); if (pr) pr.addEventListener('change', renderTickets);
    var ua = document.getElementById('filter_unassigned'); if (ua) ua.addEventListener('change', renderTickets);
    var sd = document.getElementById('filter_start'); if (sd) sd.addEventListener('change', renderTickets);
    var ed = document.getElementById('filter_end'); if (ed) ed.addEventListener('change', renderTickets);
    var cf = document.getElementById('clearFiltersBtn'); if (cf) cf.addEventListener('click', clearFilters);
    $('#tickets-datatable tbody').on('click', 'tr', function(){ var row = ticketTable.row(this).data(); if (row) setTicketPreview(row); });

    // Safely parse JSON regardless of content-type, return null on failure
    function safeParseJson(text) {
        try { return JSON.parse(text); } catch (_) { return null; }
    }

    $('#createTicketModal').on('shown.bs.modal', async function(){
        try {
            await loadPriorities();
            await loadCategories();
            const orgVal = document.getElementById('organization_id') ? document.getElementById('organization_id').value : '';
            await loadCreateContext(orgVal || undefined);
        } catch (_) {}
    });

    async function loadPriorities(){
        try{
            const sel = document.getElementById('priority_id');
            if (!sel) return;
            let rows = [];
            try{
                const r1 = await fetch(TICKET_API_BASE + '/priorities/list', { method:'POST', headers:{'Content-Type':'application/json'}, body:'{}' });
                const t1 = await r1.text();
                const d1 = safeParseJson(t1) || {};
                rows = Array.isArray(d1) ? d1 : (d1.priorities || d1.data || []);
            }catch(_){ rows = []; }
            if (!rows || !rows.length) {
                try{
                    const r2 = await fetch(TICKET_API_BASE + '/priorities');
                    const t2 = await r2.text();
                    const d2 = safeParseJson(t2) || {};
                    rows = Array.isArray(d2) ? d2 : (d2.priorities || d2.data || []);
                }catch(_){ rows = []; }
            }
            sel.innerHTML = '<option value="">Select Priority</option>' + (rows||[]).map(function(p){
                const id = p.priority_id || p.id || p.code || p.value || p.name;
                const name = p.name || p.label || p.code || String(id);
                return '<option value="'+id+'">'+name+'</option>';
            }).join('');
        }catch(_){}
    }

    async function loadCategories(){
        try{
            const sel = document.getElementById('category_id');
            if (!sel) return;
            let rows = [];
            try{
                const r1 = await fetch(TICKET_API_BASE + '/categories/list', { method:'POST', headers:{'Content-Type':'application/json'}, body:'{}' });
                const t1 = await r1.text();
                const d1 = safeParseJson(t1) || {};
                rows = Array.isArray(d1) ? d1 : (d1.categories || d1.data || []);
            }catch(_){ rows = []; }
            if (!rows || !rows.length) {
                try{
                    const r2 = await fetch(TICKET_API_BASE + '/categories');
                    const t2 = await r2.text();
                    const d2 = safeParseJson(t2) || {};
                    rows = Array.isArray(d2) ? d2 : (d2.categories || d2.data || []);
                }catch(_){ rows = []; }
            }
            sel.innerHTML = '<option value="">Select Category</option>' + (rows||[]).map(function(p){
                const id = p.category_id || p.id || p.code || p.value || p.name;
                const name = p.name || p.label || p.code || String(id);
                return '<option value="'+id+'">'+name+'</option>';
            }).join('');
        }catch(_){}
    }

    async function loadStatuses(){
        try{
            const sel = document.getElementById('status_id');
            if (!sel) return;
            let rows = [];
            try{
                const r1 = await fetch(TICKET_API_BASE + '/statuses/list', { method:'POST', headers:{'Content-Type':'application/json'}, body:'{}' });
                const t1 = await r1.text();
                const d1 = safeParseJson(t1) || {};
                rows = Array.isArray(d1) ? d1 : (d1.statuses || d1.data || []);
            }catch(_){ rows = []; }
            if (!rows || !rows.length) {
                try{
                    const r2 = await fetch(TICKET_API_BASE + '/statuses');
                    const t2 = await r2.text();
                    const d2 = safeParseJson(t2) || {};
                    rows = Array.isArray(d2) ? d2 : (d2.statuses || d2.data || []);
                }catch(_){ rows = []; }
            }
            sel.innerHTML = '<option value="">Select Status</option>' + (rows||[]).map(function(s){
                const id = s.status_id || s.id || s.code || s.value || s.name;
                const name = s.name || s.label || s.code || String(id);
                return '<option value="'+id+'">'+name+'</option>';
            }).join('');
        }catch(_){}
    }

    async function loadOrganizations(){
        try{
            const r = await fetch(ORG_API);
            const t = await r.text();
            const d = safeParseJson(t) || {};
            const rows = Array.isArray(d) ? d : (d.organizations || d.data || []);
            const sel = document.getElementById('organization_id');
            if (sel) {
                sel.innerHTML = '<option value="">Select Organization</option>' + rows.map(function(o){
                    const id = o.org_id || o.id;
                    const name = o.org_name || o.name || '';
                    return id ? '<option value="'+id+'">'+name+'</option>' : '';
                }).join('');
            }
        }catch(_){}
    }

    async function loadCreateContext(orgId){
        try{
            const url = orgId ? TICKET_API_BASE + '/create_context?org_id=' + encodeURIComponent(orgId) : TICKET_API_BASE + '/create_context';
            const r = await fetch(url);
            const t = await r.text();
            const d = safeParseJson(t) || {};
            const ctx = d.org_context || d.context || {};
            const products = Array.isArray(d.products) ? d.products : (d.products && d.products.data) ? d.products.data : (d.data && d.data.products) ? d.data.products : [];
            const orgSel = document.getElementById('organization_id');
            const prodSel = document.getElementById('product_id');
            if (prodSel) {
                if (products.length === 1) {
                    const p = products[0];
                    const id = p.product_id || p.id;
                    const name = p.product_name || p.name || '';
                    prodSel.innerHTML = id ? '<option value="'+id+'">'+name+'</option>' : '<option value="">Select Product</option>';
                    prodSel.disabled = true;
                } else {
                    prodSel.disabled = false;
                    prodSel.innerHTML = '<option value="">Select Product</option>' + products.map(function(p){
                        const id = p.product_id || p.id;
                        const name = p.product_name || p.name || '';
                        return id ? '<option value="'+id+'">'+name+'</option>' : '';
                    }).join('');
                }
            }
            if (ctx && (ctx.is_system_owner === true || String(ctx.is_system_owner).toLowerCase() === 'true')) {
                if (orgSel) {
                    orgSel.parentElement.style.display = 'block';
                    if (!orgSel.options.length) { await loadOrganizations(); }
                    if (orgId) orgSel.value = orgId;
                    orgSel.disabled = false;
                }
            } else {
                if (orgSel) {
                    orgSel.parentElement.style.display = 'none';
                    orgSel.innerHTML = '';
                }
            }
        }catch(_){}
    }

    // Determine success from various backend shapes
    function isSuccessPayload(obj) {
        if (!obj || typeof obj !== 'object') return false;
        if (obj.success === true) return true;
        if (typeof obj.status === 'string' && obj.status.toLowerCase() === 'success') return true;
        if (obj.code === 200) return true;
        return false;
    }

    async function loadTickets() {
        try {
            console.group('loadTickets');
            const response = await fetch(TICKET_API_BASE + '/list');
            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
            }
            const text = await response.text();
            console.log('loadTickets response', text);
            const data = safeParseJson(text) || {};
            const rows = Array.isArray(data)
                ? data
                : (data.tickets || data.data || data.items || data.rows || []);
            allTicketsRows = Array.isArray(rows) ? rows : [];
            renderTickets();
            console.groupEnd();
            return;
            ticketTable.clear();
            ticketTable.rows.add(Array.isArray(rows) ? rows : []);
            ticketTable.draw();
            updateStatusPriorityCards(Array.isArray(rows) ? rows : []);
            console.groupEnd();
        } catch (error) {
            console.error('Error loading tickets:', error);
            showNotification('Error loading tickets', 'error');
        }
    }

    function updateStatusPriorityCards(rows) {
        const statusCounts = { open:0, 'in progress':0, 'on hold':0, resolved:0, closed:0 };
        const priorityCounts = { high:0, medium:0, low:0, critical:0 };
        rows.forEach(r => {
            const s = String((r.task_status || r.status_name || '')).toLowerCase();
            if (s in statusCounts) statusCounts[s]++;
            const pStr = String((r.task_priority || r.priority_name || '')).toLowerCase();
            if (pStr && (pStr in priorityCounts)) priorityCounts[pStr]++;
            else {
                const lvl = parseInt(r.priority_level);
                if (!isNaN(lvl)) {
                    if (lvl === 1) priorityCounts.critical++;
                    else if (lvl === 2) priorityCounts.high++;
                    else if (lvl === 3) priorityCounts.medium++;
                    else if (lvl === 4) priorityCounts.low++;
                }
            }
        });
        const set = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val; };
        set('status_open', statusCounts.open);
        set('status_in_progress', statusCounts['in progress']);
        set('status_on_hold', statusCounts['on hold']);
        set('status_resolved', statusCounts.resolved);
        set('status_closed', statusCounts.closed);
        set('priority_high', priorityCounts.high);
        set('priority_medium', priorityCounts.medium);
        set('priority_low', priorityCounts.low);
        set('priority_critical', priorityCounts.critical);
    }

    function normalize(v) { return String(v || '').toLowerCase(); }
    function applyFilters(rows) {
        const q = normalize(document.getElementById('tickets_search') && document.getElementById('tickets_search').value);
        const status = normalize(document.getElementById('filter_status') && document.getElementById('filter_status').value);
        const priority = normalize(document.getElementById('filter_priority') && document.getElementById('filter_priority').value);
        const unassigned = !!(document.getElementById('filter_unassigned') && document.getElementById('filter_unassigned').checked);
        const start = document.getElementById('filter_start') && document.getElementById('filter_start').value;
        const end = document.getElementById('filter_end') && document.getElementById('filter_end').value;
        const startDate = start ? new Date(start) : null;
        const endDate = end ? new Date(end) : null;
        return (rows || []).filter(function(r){
            const title = normalize(r.task_subject || r.title);
            const ticketNo = normalize(r.task_ticket_no || r.ticket_number || r.ticket_no);
            const desc = normalize(r.task_description || r.description);
            const assigned = normalize(r.task_assigned_to || r.assigned_to_name);
            const s = normalize(r.task_status || r.status_name);
            const p = normalize(r.task_priority || r.priority_name);
            if (q && !(title.includes(q) || ticketNo.includes(q) || desc.includes(q) || assigned.includes(q))) return false;
            if (status && s !== status) return false;
            if (priority && p !== priority) return false;
            if (unassigned && assigned) return false;
            const ct = r.created_date || r.created_at;
            if (startDate || endDate) {
                const d = ct ? new Date(ct) : null;
                if (!d) return false;
                if (startDate && d < startDate) return false;
                if (endDate) { var endD = new Date(end); endD.setHours(23,59,59,999); if (d > endD) return false; }
            }
            return true;
        });
    }
    function renderTickets(){
        const filtered = applyFilters(allTicketsRows);
        ticketTable.clear();
        ticketTable.rows.add(filtered);
        ticketTable.draw();
        updateStatusPriorityCards(filtered);
        if (filtered && filtered[0]) setTicketPreview(filtered[0]);
    }
    function clearFilters(){
        const ids = ['tickets_search','filter_status','filter_priority','filter_unassigned','filter_start','filter_end'];
        ids.forEach(function(id){ var el = document.getElementById(id); if (!el) return; if (el.type === 'checkbox') el.checked = false; else el.value = ''; });
        renderTickets();
    }
    function setTicketPreview(row){
        var numEl = document.getElementById('preview_ticket_number');
        var titleEl = document.getElementById('preview_title');
        var statusEl = document.getElementById('preview_status');
        var prEl = document.getElementById('preview_priority');
        var asnEl = document.getElementById('preview_assigned_to');
        var crEl = document.getElementById('preview_created_by');
        var dueEl = document.getElementById('preview_due_date');
        var descEl = document.getElementById('preview_description');
        if (numEl) numEl.textContent = row.task_ticket_no || row.ticket_number || row.ticket_no || '';
        if (titleEl) titleEl.textContent = row.task_subject || row.title || '';
        var s = row.task_status || row.status_name || '';
        var p = row.task_priority || row.priority_name || '';
        if (statusEl) { statusEl.className = 'badge bg-' + getStatusClass(s); statusEl.textContent = s; }
        if (prEl) { prEl.className = 'badge bg-' + getPriorityClass(row.priority_level); prEl.textContent = p; }
        if (asnEl) asnEl.textContent = row.task_assigned_to || row.assigned_to_name || '';
        if (crEl) crEl.textContent = row.created_by || '';
        if (dueEl) dueEl.textContent = formatDate(row.due_date || row.created_at || row.created_date || '');
        if (descEl) descEl.textContent = row.task_description || row.description || '';
    }



    // JQUERY

    $(document).ready(function() {
  $('#assignTicketBtn').on('click', function() {
    // Get values from the form
    const formData = {
      title: $('#assign_task_subject').val().trim(),
      priority: $('#assign_task_priority').val(),
      type: $('#assign_task_type').val().trim(),
      task_id: $('#assign_task_id').val(),
      remarks: $('#assign_task_remarks').val().trim(),
      description: $('#assign_task_description').val().trim(),
      assigned_to: $('#assign_task_to').val()
    };

    // Validate required fields
    if (!formData.title || !formData.priority || !formData.type || 
        !formData.remarks || !formData.description || !formData.assigned_to) {
      alert(' Please fill in all required fields.');
      return;
    }

    // Log or send the form data
    console.log('Form Data:', formData);

    // Example AJAX call (uncomment and adjust when backend is ready)
    /*
    $.ajax({
      url: '/assign_ticket',
      method: 'POST',
      data: formData,
      success: function(response) {
        alert('✅ Ticket assigned successfully!');
        $('#assignTicketModal').modal('hide');
      },
      error: function(err) {
        alert('❌ Error assigning ticket.');
        console.error(err);
      }
    });
    */
  });
});


    // async function loadDropdownData() {
    //     try {
    //         // Load priorities
    //         const prioritiesResponse = await fetch(TICKET_API_BASE+'/priorities');
    //         const priorities = await prioritiesResponse.json();
    //         populateDropdown('ticketPriority', priorities);
    //         populateDropdown('updatePriority', priorities);
            
    //         // Load departments
    //         const deptsResponse = await fetch(TICKET_API_BASE+'/departments');
    //         const departments = await deptsResponse.json();
    //         populateDropdown('ticketDepartment', departments);
            
    //         // Load statuses
    //         const statusesResponse = await fetch(TICKET_API_BASE+'/statuses');
    //         const statuses = await statusesResponse.json();
    //         populateDropdown('updateStatus', statuses);
            
    //         // Load agents
    //         const agentsResponse = await fetch('/api/users/agents');
    //         const agents = await agentsResponse.json();
    //         populateDropdown('assignTo', agents);
            
    //     } catch (error) {
    //         console.error('Error loading dropdown data:', error);
    //     }
    // }

    // function populateDropdown(elementId, data) {
    //     const select = document.getElementById(elementId);
    //     if (!select) return;
        
    //     select.innerHTML = '';
    //     data.forEach(item => {
    //         const option = document.createElement('option');
    //         option.value = item.id || item.value;
    //         option.textContent = item.name || item.text;
    //         select.appendChild(option);
    //     });
    // }

    async function createTicket() {
        const subject = document.getElementById('task_subject').value;
        const desc = document.getElementById('task_description').value;
        const pr = document.getElementById('priority_id').value;
        const prSel = document.getElementById('priority_id');
        const prName = prSel && prSel.options[prSel.selectedIndex] ? prSel.options[prSel.selectedIndex].text : '';
        const statusId = document.getElementById('status_id').value;
        const payload = {
            title: subject,
            description: desc,
            task_type: document.getElementById('task_type').value,
            product_id: document.getElementById('product_id').value,
            category_id: document.getElementById('category_id').value
        };
        if (pr) payload.priority_id = pr;
        if (prName) payload.priority = prName;
        if (statusId) payload.status_id = statusId;
        const due = document.getElementById('due_date').value; if(due) payload.due_date = due;

        try {
            console.group('createTicket');
            const response = await fetch(TICKET_API_BASE+'/create', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
            }

            const text = await response.text();
            console.log('createTicket response', text);
            const result = safeParseJson(text) || {};
            if (isSuccessPayload(result)) {
                showNotification('Ticket created successfully', 'success');
                $('#createTicketModal').modal('hide');
                document.getElementById('createTicketForm').reset();
                loadTickets();
            } else {
                const msg = (result && (result.message || result.error || result.status)) || 'Failed to create ticket';
                showNotification(msg, 'error');
            }
            console.groupEnd();
        } catch (error) {
            console.error('Error creating ticket:', error);
            showNotification('Error creating ticket', 'error');
        }
    }


       window.showNotification = function(message, type = 'success') {
        Toastify({
            text: message,
            duration: 3000,
            close: true,
            gravity: "top",
            position: "right",
            backgroundColor: type === 'success' ? '#28a745' : 
                           type === 'error' ? '#dc3545' :
                           type === 'warning' ? '#ffc107' : '#17a2b8',
        }).showToast();
    }

     // update function
       async function updateTicket() {

        console.log("Update ticket function called");
        // Build urlencoded form data to match backend request.getParameter expectations
        const params = new URLSearchParams();
        params.append('task_id', document.getElementById('edit_task_id').value);
        params.append('task_subject', document.getElementById('edit_task_subject').value);
        params.append('task_type', document.getElementById('edit_task_type').value);
        params.append('task_description', document.getElementById('edit_task_description').value);
        params.append('task_priority', document.getElementById('edit_task_priority').value);
        params.append('task_remarks', document.getElementById('edit_task_remarks').value);

        console.log(params.toString());
        
        try {
            console.group('updateTicket');
            const response = await fetch(TICKET_API_BASE+'/update_tickets', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            });

            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
            }

            const text = await response.text();
            console.log('updateTicket response', text);
            const result = safeParseJson(text) || {};
            console.log(result);
            //  console.log("Update ticket function response received");
            if (isSuccessPayload(result)) {
                showNotification('Ticket updated successfully', 'success');
                $('#editTicketModal').modal('hide');
                document.getElementById('editTicketForm').reset();
                loadTickets();
            } else {
                const msg = (result && (result.message || result.error || result.status)) || 'Failed to update ticket';
                showNotification(msg, 'error');
            }
            console.groupEnd();
        } catch (error) {
            console.error('Error updating ticket:', error);
            showNotification('Error updating ticket', 'error');
        }
    }

  

    async function editTicket(taskId, taskUid) {
        // Build urlencoded form data to match backend request.getParameter expectations
        const params = new URLSearchParams();
        if (taskId) params.append('task_id', taskId);
        if (taskUid) params.append('task_uid', taskUid);
        
        try {
            console.group('editTicket');
            const response = await fetch(TICKET_API_BASE+'/view', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            });

            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
            }

            const text = await response.text();
            // editTicket response
            const result = safeParseJson(text) || {};
            const payload = result.data || result;

            // fetched ticket payload

            document.getElementById("edit_task_subject").value = payload.task_subject || payload.title || "";
            document.getElementById("edit_task_priority").value = (payload.task_priority || payload.priority_name || "").toLowerCase();
            document.getElementById("edit_task_type").value = payload.task_type || "";
            document.getElementById("edit_task_remarks").value = payload.task_remarks || "";
            document.getElementById("edit_task_description").value = payload.task_description || payload.description || "";
            document.getElementById("edit_task_id").value = payload.task_id || payload.task_uid || payload.ticket_id || "";

            if (payload.task_id || payload.task_uid || payload.id || payload.ticket_id) {
                populateEditModal(payload);
                (new bootstrap.Modal(document.getElementById('editTicketModal'))).show();

                edit_task_subject
                // document.getElementById('editTicketForm').reset();
                task_subject
                // loadTickets();
            } else {
                const msg = (result && (result.message || result.error || result.status)) || 'Failed to load ticket';
                showNotification(msg, 'error');
            }
        } catch (error) {
            console.error('Error editing ticket:', error);
            showNotification('Error editing ticket', 'error');
        }
    }


     // Assign function - Load ticket data and show modal
    async function assignTicket(taskId, taskUid) {
        
        // Build urlencoded form data to fetch ticket details
        const params = new URLSearchParams();
        if (taskId) params.append('task_id', taskId);
        if (taskUid) params.append('task_uid', taskUid);
        
        try {
            const response = await fetch(TICKET_API_BASE+'/view', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            });

            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
            }

            const text = await response.text();
            const result = safeParseJson(text) || {};
            const payload = result.data || result;
            // fetched ticket for assignment
            
            if (payload.task_id || payload.task_uid || payload.id || payload.ticket_id) {
                // Populate the assign modal with ticket data
                document.getElementById("assign_task_subject").value = payload.task_subject || payload.title || "";
                document.getElementById("assign_task_priority").value = (payload.task_priority || payload.priority_name || "").toLowerCase();
                document.getElementById("assign_task_type").value = payload.task_type || "";
                document.getElementById("assign_task_remarks").value = payload.task_remarks || "";
                document.getElementById("assign_task_description").value = payload.task_description || payload.description || "";
                document.getElementById("assign_task_id").value = payload.task_id || payload.task_uid || payload.ticket_id || payload.id || "";
                
                await loadAssignableUsers('');
                (new bootstrap.Modal(document.getElementById('assignTicketModal'))).show();
            } else {
                const msg = (result && (result.message || result.error || result.status)) || 'Failed to load ticket';
                showNotification(msg, 'error');
            }
        } catch (error) {
            console.error('Error loading ticket for assignment:', error);
            showNotification('Error loading ticket', 'error');
        }
    }

  

    




    async function submitAssignTicket() {
    const taskId = document.getElementById('assign_task_id').value;
    const assignedTo = document.getElementById('assign_task_to').value;

    if (!taskId) {
        showNotification('No ticket selected to assign', 'warning');
        return;
    }
    if (!assignedTo) {
        showNotification('Please select a user to assign the ticket to', 'warning');
        return;
    }

    const payload = {
        task_id: taskId,
        user_to_assign_id: assignedTo,                 
    };

    console.log("Sending payload:", payload);

    try {
        const params = new URLSearchParams();
        params.append('task_id', payload.task_id);
        params.append('user_to_assign_id', payload.user_to_assign_id);
        const response = await fetch(TICKET_API_BASE + '/assign_ticket', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        });
        const text = await response.text();
        console.log("Raw response text:", text);
        const trimmed = (text || '').trim();
        if (!trimmed) {
            showNotification('Ticket assigned successfully', 'success');
            $('#assignTicketModal').modal('hide');
            document.getElementById('assignTicketForm').reset();
            loadTickets();
            return;
        }
        const result = safeParseJson(trimmed) || {};
        const statusStr = (result.status || '').toString().toLowerCase();
        const ok = (result.success === true) || (statusStr === 'success');
        if (ok) {
            showNotification(result.msg || result.message || 'Ticket assigned successfully', 'success');
            $('#assignTicketModal').modal('hide');
            document.getElementById('assignTicketForm').reset();
            loadTickets();
        } else {
            showNotification(result.msg || result.message || 'Failed to assign ticket', 'error');
        }
    } catch (error) {
        console.error('Error assigning ticket:', error);
        showNotification('Error assigning ticket: ' + error.message, 'error');
    }
}


function populateEditModal(result) {
    // Fallback if result is empty
    if (!result || Object.keys(result).length === 0) return;

    // Populate fields
    document.getElementById("edit_task_subject").value = result.task_subject || result.title || "";
    document.getElementById("edit_task_priority").value = (result.task_priority || result.priority_name || "").toLowerCase();
    document.getElementById("edit_task_type").value = result.task_type || "";
    document.getElementById("edit_task_remarks").value = result.task_remarks || "";
    document.getElementById("edit_task_description").value = result.task_description || result.description || "";

    // If you want to keep task_id hidden for update
    const hiddenId = document.getElementById("edit_task_id");
    if (hiddenId) hiddenId.value = result.task_id || result.task_uid || result.ticket_id || '';
}



async function archiveTicket(ticketId) {
    // First, show the confirmation modal with the ticket ID
    document.getElementById("archive_task_id").value = ticketId;
    // Set a friendly preview; if you have the ticket subject available in the table row, replace this
    const subjectEl = document.getElementById('archive_task_subject');
    const ticketNoEl = document.getElementById('archive_task_ticket_no');
    if (subjectEl) subjectEl.textContent = `Ticket ID: ${ticketId}`;
    if (ticketNoEl) ticketNoEl.textContent = '';
    // clear optional fields (none remain)
    $('#archiveTicketModal').modal('show');
}



async function confirmArchiveTicket() {
    const taskId = document.getElementById('archive_task_id').value;
    

    if (!taskId) {
        showNotification('No ticket selected to archive', 'warning');
        return;
    }
    try{
        const uuidResponse = await fetch('/api/tickets/get_task_uuid',{
            method: "POST",
            headers: {'Content-Type' : 'application/json'},
            body: JSON.stringify({id: taskId})
        });

        // Read as text first and safely parse JSON - backend may return HTML (error page / redirect)
        const uuidText = await uuidResponse.text();
        const uuidData = safeParseJson(uuidText) || {};

        if (!uuidResponse.ok) {
            // If session expired, bail out
            if (uuidResponse.status === 401) {
                showNotification('Session expired. Please log in again.', 'error');
                return;
            }

            // If the mapping endpoint returned 404 (not found) we can try a graceful fallback:
            // maybe the provided id is already the task UUID — try to detect that and proceed.
            console.warn('get_task_uuid failed', uuidResponse.status, uuidText);
            const looksLikeUuid = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(taskId);
            // If mapping not found in DB (dev/h2), attempt an optimistic fallback: try archiving with
            // the provided id directly. This helps dev instances that don't have the mapping table.
            if (uuidResponse.status === 404) {
                console.info('get_task_uuid returned 404; attempting optimistic archive with provided id (looksLikeUuid=' + looksLikeUuid + ')');
                const payload = { task_id: taskId };
                await doArchiveRequest(payload);
                return;
            }

            showNotification((uuidData && (uuidData.error || uuidData.message)) || 'Failed to get task UUID', 'error');
            return;
        }

        // If endpoint succeeded but didn't include a task_id, allow fallback to provided id when it
        // already looks like a UUID (some rows already store UUIDs client-side).
        if (!uuidData.task_id) {
            const looksLikeUuid = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(taskId);
            if (looksLikeUuid) {
                const payload = { task_id: taskId };
                await doArchiveRequest(payload);
                return;
            }

            showNotification(uuidData.error || "Failed to get task UUID", 'error');
            return;
        }

    const payload = { task_id: uuidData.task_id };
        await doArchiveRequest(payload);
    } catch (error) {
        console.error('Error archiving ticket:', error);
        showNotification('Error archiving ticket: ' + error.message, 'error');
    }

    
}

// Helper that performs the archive POST and handles response & notifications
async function doArchiveRequest(payload) {
    try {
        console.log("Payload for archiving:", payload);
        // The backend `archiveticket` handler reads request parameters (request.getParameter("task_id")),
        // so send form-encoded data rather than JSON so `getParameter` will find it.
        const params = new URLSearchParams();
        params.append('task_id', payload.task_id);

        const response = await fetch(TICKET_API_BASE + '/archive_ticket', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        });

        const text = await response.text();
        console.log("Raw response text:", text);

        const result = safeParseJson(text) || {};

        if (result.status === 'Success') {
            showNotification(result.msg || 'Ticket archived successfully', 'success');
            $('#archiveTicketModal').modal('hide');
            const form = document.getElementById('archiveTicketForm');
            if (form) form.reset();
            loadTickets();
        } else {
            showNotification(result.msg || 'Failed to archive ticket', 'error');
        }
    } catch (error) {
        console.error('Error archiving ticket:', error);
        showNotification('Error archiving ticket: ' + (error && error.message ? error.message : error), 'error');
    }
}
    

function displayTicketDetails(ticket) {
        const content = `
            <h4>`+(ticket.task_subject||ticket.title||'')+`</h4>
            <div class="row mt-3">
                <div class="col-md-6">
                    <p><strong>Ticket Number:</strong> `+(ticket.task_ticket_no||ticket.ticket_number||'')+`</p>
                    <p><strong>Status:</strong> <span class="badge bg-`+getStatusClass((ticket.task_status||ticket.status_name||''))+`">`+(ticket.task_status||ticket.status_name||'')+`</span></p>
                    <p><strong>Priority:</strong> <span class="badge bg-`+getPriorityClass(ticket.priority_level)+`">`+(ticket.task_priority||ticket.priority_name||'')+`</span></p>
                </div>
                <div class="col-md-5">
                    <p><strong>Due Date:</strong> `+formatDate(ticket.task_due_date||ticket.due_date)+`</p>
                </div>
            </div>
            <div class="mt-3">
                <strong>Description:</strong>
                <p class="mt-2">`+(ticket.task_description||ticket.description||'')+`</p>
            </div>
        `;
        
        document.getElementById('ticketDetailsContent').innerHTML = content;
        
        // Populate summary info (read-only)
        const statusEl = document.getElementById('view_meta_status');
        const priorityEl = document.getElementById('view_meta_priority');
        const assignedEl = document.getElementById('view_meta_assigned_to');
        const createdByEl = document.getElementById('view_meta_created_by');
        const dueDateEl = document.getElementById('view_meta_due_date');

        if (statusEl) {
            const st = ticket.task_status || ticket.status_name || '';
            statusEl.textContent = st || 'N/A';
            statusEl.className = 'badge bg-' + getStatusClass(st || '');
        }
        if (priorityEl) {
            priorityEl.textContent = (ticket.task_priority || ticket.priority_name || 'N/A');
            priorityEl.className = 'badge bg-' + getPriorityClass(ticket.priority_level);
        }
        if (assignedEl) assignedEl.textContent = ticket.task_assigned_to || ticket.assigned_to_name || 'Unassigned';
        if (createdByEl) createdByEl.textContent = ticket.created_by || 'Unknown';
        if (dueDateEl) dueDateEl.textContent = formatDate(ticket.task_due_date || ticket.due_date) || 'N/A';

        // Store current ticket ID for other actions
        document.getElementById('viewTicketModal').dataset.ticketId = ticket.ticket_id || '';
    }


    async function viewTicket(taskId, taskUid) {
    const params = new URLSearchParams();
    if (taskId) params.append('task_id', taskId);
    if (taskUid) params.append('task_uid', taskUid);

    try {
        const response = await fetch(TICKET_API_BASE + '/view', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        });

        if (!response.ok) {
            if (response.status === 401) {
                showNotification('Session expired. Please log in again.', 'error');
                return;
            }
        }

    const text = await response.text();
    const result = safeParseJson(text) || {};
    const payload = result.data || result;

    console.log("Fetched ticket:", payload);

    if (payload.task_id || payload.task_uid || payload.id) {
        displayTicketDetails(payload);
        (new bootstrap.Modal(document.getElementById('viewTicketModal'))).show();
        } else {
            const msg = (result && (result.message || result.error || result.status)) || 'Failed to load ticket';
            showNotification(msg, 'error');
        }
    } catch (error) {
        console.error('Error loading ticket:', error);
        showNotification('Error loading ticket', 'error');
    }
}



function displayTicketDetails(task) {
    document.getElementById('view_task_id').textContent = task.task_id || task.ticket_id || '';
    document.getElementById('view_task_subject').textContent = task.task_subject || task.title || '';
    document.getElementById('view_task_type').textContent = task.task_type || '';
    document.getElementById('view_task_description').textContent = task.task_description || task.description || '';
    document.getElementById('view_task_remarks').textContent = task.task_remarks || '';

    // Priority badge styling
    const priorityEl = document.getElementById('view_task_priority');
    priorityEl.textContent = task.task_priority || task.priority_name || '';
    priorityEl.className = 'badge ' + 
        (task.task_priority === 'High' ? 'bg-danger' : 
         task.task_priority === 'Medium' ? 'bg-warning' : 'bg-success');

    document.getElementById('view_task_due_date').textContent = task.task_due_date || task.due_date || '';

    // Audit info
    document.getElementById('view_created_by').textContent = task.created_by || '';
    document.getElementById('view_created_by_id').textContent = task.created_by_id || '';
    document.getElementById('view_created_by_date').textContent = task.created_by_date || '';

    document.getElementById('view_modified_by').textContent = task.modified_by || '';
    document.getElementById('view_modified_by_id').textContent = task.modified_by_id || '';
    document.getElementById('view_modified_by_date').textContent = task.modified_by_date || '';
}



    function displayTicketDetails(ticket) {
        const title = ticket.task_subject || ticket.title || '';
        const number = ticket.task_ticket_no || ticket.ticket_number || '';
        const statusName = ticket.task_status || ticket.status_name || ticket.status || '';
        const priorityName = ticket.task_priority || ticket.priority_name || '';
        const due = ticket.task_due_date || ticket.due_date || '';
        const desc = ticket.task_description || ticket.description || '';

        const content = `
            <h4>`+title+`</h4>
            <div class="row mt-3">
                <div class="col-md-6">
                    <p><strong>Ticket Number:</strong> `+number+`</p>
                    <p><strong>Status:</strong> <span class="badge bg-`+getStatusClass(statusName)+`">`+statusName+`</span></p>
                    <p><strong>Priority:</strong> <span class="badge bg-`+getPriorityClass(ticket.priority_level)+`">`+priorityName+`</span></p>
                </div>
                <div class="col-md-5">
                    <p><strong>Due Date:</strong> `+formatDate(due)+`</p>
                </div>
            </div>
            <div class="mt-3">
                <strong>Description:</strong>
                <p class="mt-2">`+desc+`</p>
            </div>
        `;
        
        document.getElementById('ticketDetailsContent').innerHTML = content;

        // Populate summary info (read-only)
        const statusEl = document.getElementById('view_meta_status');
        const priorityEl = document.getElementById('view_meta_priority');
        const assignedEl = document.getElementById('view_meta_assigned_to');
        const createdByEl = document.getElementById('view_meta_created_by');
        const dueDateEl = document.getElementById('view_meta_due_date');

        if (statusEl) {
            statusEl.textContent = statusName || 'N/A';
            statusEl.className = 'badge bg-' + getStatusClass(statusName || '');
        }
        if (priorityEl) {
            priorityEl.textContent = priorityName || 'N/A';
            priorityEl.className = 'badge bg-' + getPriorityClass(ticket.priority_level);
        }
        if (assignedEl) assignedEl.textContent = ticket.task_assigned_to || ticket.assigned_to_name || 'Unassigned';
        if (createdByEl) createdByEl.textContent = ticket.created_by || 'Unknown';
        if (dueDateEl) dueDateEl.textContent = formatDate(due) || 'N/A';

        // Store current ticket ID for other actions
        document.getElementById('viewTicketModal').dataset.ticketId = ticket.task_id || ticket.ticket_id || ticket.task_uid || ticket.id || '';
    }

    async function loadTicketComments(ticketId) {
        try {
            const response = await fetch(TICKET_API_BASE+'/'+ticketId+'/comments');
            const text = await response.text();
            const result = safeParseJson(text) || {};
            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
                console.error('Failed to load comments', response.status, text);
                showNotification((result && (result.error || result.message)) || 'Failed to load comments', 'error');
                return;
            }
            
            let commentsHtml = '';
            if (result.success && result.comments.length > 0) {
                result.comments.forEach(comment => {
                    commentsHtml += `
                        <div class="comment mb-3 p-3 border rounded">
                            <div class="d-flex justify-content-between">
                                <strong>`+comment.username+`</strong>
                                <small class="text-muted">`+formatDate(comment.created_at)+`</small>
                            </div>
                            <p class="mb-0 mt-2">`+comment.comment_text+`</p>
                            `+(comment.is_internal ? '<span class="badge bg-warning">Internal</span>' : '')+`
                        </div>
                    `;
                });
            } else {
                commentsHtml = '<p class="text-muted">No comments yet.</p>';
            }
            
            document.getElementById('ticketComments').innerHTML = commentsHtml;
        } catch (error) {
            console.error('Error loading comments:', error);
        }
    }

    async function loadTicketHistory(ticketId) {
        try {
            const response = await fetch(TICKET_API_BASE+'/'+ticketId+'/history');
            const text = await response.text();
            const result = safeParseJson(text) || {};
            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
                console.error('Failed to load history', response.status, text);
                showNotification((result && (result.error || result.message)) || 'Failed to load history', 'error');
                return;
            }
            
            let historyHtml = '';
            if (result.success && result.history.length > 0) {
                result.history.forEach(history => {
                    historyHtml += `
                        <div class="history-item mb-2">
                            <small class="text-muted">`+formatDate(history.change_date)+`</small>
                            <p class="mb-0">`+history.changed_by+`: `+history.field_name+` changed from "`+(history.old_value || 'None')+`" to "`+(history.new_value || 'None')+`"</p>
                        </div>
                    `;
                });
            } else {
                historyHtml = '<p class="text-muted">No history available.</p>';
            }
            
            document.getElementById('ticketHistory').innerHTML = historyHtml;
        } catch (error) {
            console.error('Error loading history:', error);
        }
    }


    async function addComment() {
        const ticketId = document.getElementById('viewTicketModal').dataset.ticketId;
        const commentText = document.getElementById('newComment').value;
        const isInternal = document.getElementById('internalComment').checked;
        
        if (!commentText.trim()) {
            showNotification('Please enter a comment', 'warning');
            return;
        }
        
        try {
            const response = await fetch(TICKET_API_BASE+'/'+ticketId+'/comments', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    comment_text: commentText,
                    is_internal: isInternal
                })
            });
            const text = await response.text();
            const result = safeParseJson(text) || {};
            if (!response.ok) {
                if (response.status === 401) {
                    showNotification('Session expired. Please log in again.', 'error');
                    return;
                }
                console.error('Failed to add comment', response.status, text);
                showNotification((result && (result.error || result.message)) || 'Failed to add comment', 'error');
                return;
            }
            
            if (result.success) {
                showNotification('Comment added successfully', 'success');
                document.getElementById('newComment').value = '';
                document.getElementById('internalComment').checked = false;
                loadTicketComments(ticketId);
            } else {
                showNotification(result.message || 'Failed to add comment', 'error');
            }
        } catch (error) {
            console.error('Error adding comment:', error);
            showNotification('Error adding comment', 'error');
        }
    }

    // function editTicket(ticketId) {
    //     // Implementation for edit ticket functionality
    //     showNotification('Edit functionality coming soon', 'info');
    // }

    // Helper functions
    function getPriorityClass(level) {
        switch(parseInt(level)) {
            case 1: return 'danger';    // Critical
            case 2: return 'warning';   // High
            case 3: return 'info';      // Medium
            case 4: return 'primary';   // Low
            case 5: return 'secondary'; // Very Low
            default: return 'secondary';
        }
    }

    function getStatusClass(status) {
        const s = (status || '').toString().toLowerCase().trim();
        switch(s) {
            case 'open': return 'primary';
            case 'in progress': return 'info';
            case 'on hold': return 'warning';
            case 'resolved': return 'success';
            case 'closed': return 'secondary';
            default: return 'secondary';
        }
    }

    function formatDate(dateString) {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    window.showNotification = function(message, type = 'success') {
        Toastify({
            text: message,
            duration: 3000, 
            close: true,
            gravity: "top",
            position: "right",
            backgroundColor: type === 'success' ? '#28a745' : 
                           type === 'error' ? '#dc3545' :
                           type === 'warning' ? '#ffc107' : '#17a2b8',
        }).showToast();
    }

    async function loadAssignableUsers(searchText) {
        try {
            const url = TICKET_API_BASE + '/users_for_assignment' +
                (searchText ? ('?search_text=' + encodeURIComponent(searchText)) : '');
            const response = await fetch(url);
            const text = await response.text();
            console.group('loadAssignableUsers');
            console.log('users_for_assignment url', url);
            console.log('users_for_assignment raw', text);
            const result = safeParseJson(text) || {};
            console.log('users_for_assignment parsed', result);
            const usersAll = Array.isArray(result.users) ? result.users : (result.data && Array.isArray(result.data.users) ? result.data.users : []);
            const q = (searchText || '').toLowerCase();
            const users = q ? usersAll.filter(u => {
                const nm = (u.display_name || u.fullname || u.name || ((u.first_name && u.last_name) ? (u.first_name + ' ' + u.last_name) : '') || u.username || u.email || '').toLowerCase();
                return nm.includes(q);
            }) : usersAll;
            console.log('users_for_assignment users', users);
            const sel = document.getElementById('assign_task_to');
            if (!sel) return;
            sel.innerHTML = '';
            if (result.success === false) {
                const opt = document.createElement('option');
                opt.value = '';
                opt.textContent = 'No users available';
                sel.appendChild(opt);
                if (result.message) {
                    showNotification(result.message, 'warning');
                }
                console.groupEnd();
                return;
            }
            users.forEach(u => {
                const id = u.user_id || u.id || u.uid || u.employee_id || '';
                const name = u.display_name || u.fullname || u.name || ((u.first_name && u.last_name) ? (u.first_name + ' ' + u.last_name) : '') || u.username || u.email || id;
                if (!id) return;
                const opt = document.createElement('option');
                opt.value = id;
                opt.textContent = name;
                sel.appendChild(opt);
            });
            if (sel.options.length === 0) {
                const opt = document.createElement('option');
                opt.value = '';
                opt.textContent = 'No users available';
                sel.appendChild(opt);
            }
            console.groupEnd();
        } catch (error) {
            console.error('Error loading assignable users:', error);
            showNotification('Failed to load users for assignment', 'error');
        }
    }

});
</script>
