/**
 * Organizations Archive JavaScript
 * Handles loading and managing archived tickets for the organization
 */

document.addEventListener('DOMContentLoaded', function() {
    const ORG_FETCH_API = (window.CONTEXT_PATH || '') + '/api/tickets/get_org_archived_tasks';
    const TICKET_ACTION_API = (window.CONTEXT_PATH || '') + '/api/tickets';
    
    console.log('Archive API URL:', ORG_FETCH_API); // Debug log
    let allTickets = [];
    let table = null;

    // Initialize DataTable
    if ($.fn.DataTable.isDataTable('#org-archive-datatable')) {
        $('#org-archive-datatable').DataTable().destroy();
    }

    table = $('#org-archive-datatable').DataTable({
        data: [],
        columns: [
            { 
                data: null,
                render: function(data) {
                    return `
                        <div class="d-flex align-items-center">
                            <div class="avatar-sm bg-light rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 32px; height: 32px;">
                                <i class="bi bi-ticket-detailed text-secondary"></i>
                            </div>
                            <div>
                                <h6 class="mb-0 text-dark" style="font-size: 0.9rem;">${data.ticket_number || data.task_ticket_no || 'N/A'}</h6>
                                <small class="text-muted">${data.subject || data.task_subject || ''}</small>
                            </div>
                        </div>
                    `;
                }
            },
            { 
                data: null,
                render: function(data) {
                    const status = data.status || data.task_status || 'N/A';
                    let badgeClass = 'bg-soft-secondary text-secondary';
                    if (status.toLowerCase().includes('progress')) badgeClass = 'bg-soft-info text-info';
                    else if (status.toLowerCase().includes('resolved')) badgeClass = 'bg-soft-success text-success';
                    
                    return `<span class="badge ${badgeClass}">${status}</span>`;
                }
            },
            { 
                data: null,
                render: function(data) {
                    const priority = data.priority || data.task_priority || 'N/A';
                    let badgeClass = 'bg-light text-dark';
                    if (priority.toLowerCase() === 'high' || priority.toLowerCase() === 'critical') badgeClass = 'bg-soft-danger text-danger';
                    else if (priority.toLowerCase() === 'medium') badgeClass = 'bg-soft-warning text-warning';
                    
                    return `<span class="badge ${badgeClass}">${priority}</span>`;
                }
            },
            { 
                data: 'archived_at',
                render: function(data) {
                    if (!data) return 'N/A';
                    return new Date(data).toLocaleDateString();
                }
            },
            { 
                data: 'days_archived',
                render: function(data) {
                    return data ? `<span class="text-muted">${data} days</span>` : '-';
                }
            },
            {
                data: null,
                orderable: false,
                className: 'text-end',
                render: function(data) {
                    // Use task_id for actions
                    const ticketId = data.task_id || data.id;
                    return `
                        <div class="dropdown">
                            <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-three-dots-vertical"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item d-flex align-items-center gap-2" href="javascript:void(0)" onclick="restoreTicket('${ticketId}')">
                                        <i class="bi bi-arrow-counterclockwise text-success"></i> Restore Ticket
                                    </a>
                                </li>
                            </ul>
                        </div>
                    `;
                }
            }
        ],
        pageLength: 10,
        language: {
            search: "_INPUT_",
            searchPlaceholder: "Search archive...",
            paginate: {
                previous: '<i class="bi bi-chevron-left"></i>',
                next: '<i class="bi bi-chevron-right"></i>'
            }
        },
        drawCallback: function() {
            $('.dataTables_paginate > .pagination').addClass('pagination-sm justify-content-end mb-0');
        }
    });

    // Load Archived Tickets
    async function loadArchivedTickets() {
        try {
            const orgId = window.CURRENT_USER_ORG_ID || '';
            const payload = { 
                p_org_id: orgId, // Changed to p_org_id as required by the backend
                p_limit: 50,
                p_offset: 0
            };
            
            console.log('Archive Payload:', payload);

            const response = await fetch(ORG_FETCH_API, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(payload)
            });
            const text = await response.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                console.error("Failed to parse JSON:", text);
                return;
            }

            // Check for error response
            if (data && (data.success === false || data.status === 'error')) {
                console.error('API Error:', data);
                if (typeof showNotification === 'function') {
                    showNotification(data.message || 'Failed to load archived tickets', 'error');
                }
                return;
            }

            // Handle new response format { success: true, data: { tasks: [...], pagination: ... } }
            let tasks = [];
            if (data.data && Array.isArray(data.data.tasks)) {
                tasks = data.data.tasks;
            } else if (Array.isArray(data.data)) {
                tasks = data.data;
            } else if (Array.isArray(data)) {
                tasks = data;
            }

            allTickets = tasks;
            
            table.clear().rows.add(allTickets).draw();
            
            const countEl = document.getElementById('archived_total');
            if (countEl) {
                // If backend provides total count, use it, otherwise use loaded length
                if (data.data && data.data.pagination && data.data.pagination.total) {
                    countEl.textContent = data.data.pagination.total;
                } else {
                    countEl.textContent = allTickets.length;
                }
            }
            
        } catch (error) {
            console.error('Error loading archived tickets:', error);
            showNotification('Failed to load archive', 'error');
        }
    }

    // Global actions
    window.restoreTicket = async function(ticketId) {
        if (!confirm('Are you sure you want to restore this ticket? It will be reopened.')) return;

        try {
            const response = await fetch(`${TICKET_ACTION_API}/${ticketId}/reopen`, { 
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            
            if (response.ok) {
                showNotification('Ticket restored successfully', 'success');
                loadArchivedTickets();
            } else {
                showNotification('Failed to restore ticket', 'error');
            }
        } catch (error) {
            console.error('Error restoring ticket:', error);
            showNotification('Error restoring ticket', 'error');
        }
    };

    function showNotification(message, type) {
        if (window.Swal) {
            Swal.fire({
                text: message,
                icon: type,
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000
            });
        } else {
            alert(message);
        }
    }

    // Event Listeners
    const refreshBtn = document.getElementById('refreshArchiveBtn');
    if (refreshBtn) refreshBtn.addEventListener('click', loadArchivedTickets);

    const searchInput = document.getElementById('archive_search');
    if (searchInput) {
        searchInput.addEventListener('keyup', function() {
            table.search(this.value).draw();
        });
    }

    // Initial load
    loadArchivedTickets();
});
