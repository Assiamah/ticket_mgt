/**
 * Ticket Archive JavaScript
 * Handles loading and managing archived tickets
 */

document.addEventListener('DOMContentLoaded', function() {
    const ARCHIVE_API = window.CONTEXT_PATH + '/v1/organization_service/fetch_archived_tickets';
    let allTickets = [];
    let table = null;

    // Initialize DataTable
    if ($.fn.DataTable.isDataTable('#archive-datatable')) {
        $('#archive-datatable').DataTable().destroy();
    }

    table = $('#archive-datatable').DataTable({
        data: [],
        columns: [
            { 
                data: 'ticket_number',
                render: function(data, type, row) {
                    return `<span class="fw-semibold text-primary">#${data || 'N/A'}</span>`;
                }
            },
            { 
                data: 'task_subject',
                render: function(data, type, row) {
                    return `
                        <div class="d-flex flex-column">
                            <span class="fw-medium">${data || 'No Title'}</span>
                            <small class="text-muted text-truncate" style="max-width: 200px;">${row.task_description || ''}</small>
                        </div>
                    `;
                }
            },
            { 
                data: 'priority_level',
                render: function(data, type, row) {
                    // Handle both numeric ID and string
                    const priorityMap = {
                        1: { label: 'Critical', class: 'danger' },
                        2: { label: 'High', class: 'warning' },
                        3: { label: 'Medium', class: 'info' },
                        4: { label: 'Low', class: 'success' },
                        'Critical': { label: 'Critical', class: 'danger' },
                        'High': { label: 'High', class: 'warning' },
                        'Medium': { label: 'Medium', class: 'info' },
                        'Low': { label: 'Low', class: 'success' }
                    };
                    const val = data || row.priority || 'Unknown';
                    const p = priorityMap[val] || { label: val, class: 'secondary' };
                    return `<span class="badge bg-soft-${p.class} text-${p.class}">${p.label}</span>`;
                }
            },
            { 
                data: 'status_id',
                render: function(data, type, row) {
                    // Handle both numeric ID and string status
                    const statusMap = {
                        1: { label: 'Open', class: 'primary' },
                        2: { label: 'In Progress', class: 'info' },
                        3: { label: 'Resolved', class: 'success' },
                        4: { label: 'Closed', class: 'secondary' }
                    };
                    const val = data || row.status || 'Archived';
                    // If val is a string like 'Resolved', just use it
                    if (typeof val === 'string' && isNaN(parseInt(val))) {
                         const sClass = val.toLowerCase() === 'resolved' ? 'success' : 'secondary';
                         return `<span class="badge bg-${sClass}">${val}</span>`;
                    }
                    const s = statusMap[val] || { label: 'Archived', class: 'secondary' };
                    return `<span class="badge bg-${s.class}">${s.label}</span>`;
                }
            },
            { 
                data: 'archived_by',
                render: function(data) {
                    return `<div class="d-flex align-items-center">
                        <div class="avatar-xs me-2">
                            <span class="avatar-title rounded-circle bg-light text-primary">
                                ${data ? data.charAt(0).toUpperCase() : 'U'}
                            </span>
                        </div>
                        <span>${data || 'System'}</span>
                    </div>`;
                }
            },
            { 
                data: 'archived_date',
                render: function(data) {
                    if (!data) return 'N/A';
                    return new Date(data).toLocaleDateString() + ' ' + new Date(data).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
                }
            },
            { 
                data: 'archive_reason',
                render: function(data) {
                    return `<span class="text-muted small">${data || 'Standard Archival'}</span>`;
                }
            },
            {
                data: null,
                orderable: false,
                className: 'text-end',
                render: function(data) {
                    return `
                        <div class="dropdown">
                            <button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-three-dots-vertical"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item d-flex align-items-center gap-2" href="javascript:void(0)" onclick="viewTicketDetails('${data.ticket_number}')">
                                        <i class="bi bi-eye"></i> View Details
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center gap-2" href="javascript:void(0)" onclick="restoreTicket('${data.ticket_id}')">
                                        <i class="bi bi-arrow-counterclockwise"></i> Restore
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
            },
            emptyTable: "No archived tickets found"
        },
        drawCallback: function() {
            $('.dataTables_paginate > .pagination').addClass('pagination-sm justify-content-end mb-0');
        }
    });

    // Load Archived Tickets
    async function loadArchivedTickets() {
        try {
            const response = await fetch(ARCHIVE_API, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
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

            // Handle different response structures
            const tickets = Array.isArray(data) ? data : (data.tickets || data.data || []);
            
            allTickets = tickets;
            table.clear().rows.add(allTickets).draw();
            
            // Update stats
            updateStats(tickets);
            
        } catch (error) {
            console.error('Error loading archived tickets:', error);
            if (typeof showNotification === 'function') {
                showNotification('Failed to load archived tickets', 'error');
            }
        }
    }

    function updateStats(tickets) {
        const countEl = document.getElementById('archiveCount');
        if (countEl) countEl.textContent = tickets.length;
        
        const totalEl = document.getElementById('total_archived');
        if (totalEl) totalEl.textContent = tickets.length;
        
        // Calculate other stats
        const resolved = tickets.filter(t => t.status_id == 3).length; // Assuming 3 is Resolved
        const critical = tickets.filter(t => t.priority_level == 1).length; // Assuming 1 is Critical
        
        const resolvedEl = document.getElementById('archived_resolved');
        if (resolvedEl) resolvedEl.textContent = resolved;
        
        const criticalEl = document.getElementById('archived_critical');
        if (criticalEl) criticalEl.textContent = critical;
    }

    // Initial load
    loadArchivedTickets();

    // Refresh button
    const refreshBtn = document.getElementById('refreshTicketsBtn');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', loadArchivedTickets);
    }
    
    // Also bind to the other refresh button in table header
    const refreshTableBtn = document.getElementById('refreshArchiveBtn');
    if (refreshTableBtn) {
        refreshTableBtn.addEventListener('click', loadArchivedTickets);
    }

    // Global functions for actions
    window.viewTicketDetails = function(ticketNumber) {
        // Implement view details logic
        // Check if we can reuse viewTicket from tickets.js or need new logic
        console.log('View details for', ticketNumber);
        // For now just show alert or basic modal if available
        const ticket = allTickets.find(t => t.ticket_number === ticketNumber);
        if (ticket) {
            // Populate modal if exists
            const titleEl = document.getElementById('view_archive_title');
            if (titleEl) {
                titleEl.textContent = ticket.task_subject;
                document.getElementById('view_archive_ticket_number').textContent = '#' + ticket.ticket_number;
                // ... populate other fields ...
                const modal = new bootstrap.Modal(document.getElementById('viewArchiveModal'));
                modal.show();
            }
        }
    };

    window.restoreTicket = function(ticketId) {
        if (!confirm('Are you sure you want to restore this ticket?')) return;
        // Implement restore logic
        console.log('Restore ticket', ticketId);
    };
});
