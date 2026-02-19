/**
 * Ticket Archive JavaScript
 * Handles loading and managing archived tickets
 */

document.addEventListener('DOMContentLoaded', function() {
    const ARCHIVE_API_URL = (typeof ARCHIVE_API !== 'undefined') ? ARCHIVE_API : (window.CONTEXT_PATH || '') + '/v1/organization_service/fetch_archived_tickets';
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
                render: function(data, type, row) {
                    const dateVal = data || row.archived_at || row.created_at || row.created_date;
                    if (!dateVal) return 'N/A';
                    return new Date(dateVal).toLocaleDateString() + ' ' + new Date(dateVal).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
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

    // Load Organizations
    async function loadOrganizations() {
        console.log('Loading organizations...');
        try {
            const apiUrl = window.ORG_API || (window.CONTEXT_PATH || '') + '/v1/organization_service/get_all_organizations';
            console.log('Fetching organizations from:', apiUrl);
            
            const response = await fetch(apiUrl);
            if (response.ok) {
                const text = await response.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error('Failed to parse organization response:', e);
                    return;
                }
                
                // Handle various response structures
                // If data is null/undefined, default to empty array
                if (!data) data = [];
                
                const organizations = Array.isArray(data) ? data : (data.organizations || data.data || []);
                console.log('Organizations loaded:', organizations.length);
                
                const orgSelect = document.getElementById('filter_organization');
                if (orgSelect) {
                    let html = '<option value="">All Organizations</option>';
                    
                    if (Array.isArray(organizations)) {
                        organizations.forEach(o => {
                            const id = o.org_id || o.id;
                            const name = o.org_name || o.name;
                            if (id && name) {
                                html += `<option value="${id}">${name}</option>`;
                            }
                        });
                    }
                    
                    orgSelect.innerHTML = html;
                    
                    // Set default from user info if available
                    if (window.userInfo && (window.userInfo.organization_uuid || window.userInfo.org_id)) {
                        const userOrgId = window.userInfo.organization_uuid || window.userInfo.org_id;
                        orgSelect.value = userOrgId;
                        
                        if (orgSelect.value !== userOrgId) {
                            console.warn('User organization ID not found in dropdown options:', userOrgId);
                        }
                    }
                } else {
                    console.error('Organization filter dropdown element not found!');
                }
            } else {
                console.error('Failed to load organizations, status:', response.status);
            }
        } catch (error) {
            console.error('Error loading organizations:', error);
        }
    }

    // Load Products
    async function loadProducts() {
        try {
            const orgSelect = document.getElementById('filter_organization');
            // STRICTLY use dropdown value. 
            // The dropdown is the source of the organization UUID on the page.
            const orgId = orgSelect ? orgSelect.value : null;
            
            if (!orgId) {
                 const productSelect = document.getElementById('filter_product');
                 if (productSelect) productSelect.innerHTML = '<option value="">All Products</option>';
                 return;
            }

            const response = await fetch(`${window.CONTEXT_PATH}/api/products?org_id=${orgId}`);
            if (response.ok) {
                const text = await response.text();
                let data = JSON.parse(text);
                const products = Array.isArray(data) ? data : (data.products || data.data || []);
                
                const productSelect = document.getElementById('filter_product');
                if (productSelect) {
                    let html = '<option value="">All Products</option>';
                    products.forEach(p => {
                        html += `<option value="${p.product_id || p.id}">${p.product_name} (${p.product_code})</option>`;
                    });
                    productSelect.innerHTML = html;
                }
            }
        } catch (error) {
            console.error('Error loading products:', error);
        }
    }

    // Load Archived Tickets
    async function loadArchivedTickets() {
        try {
            // Get user info from global context
            const userId = window.userInfo ? (window.userInfo.unique_id || window.userInfo.user_uuid || window.userInfo.id) : null;
            
            // Get filter values
            const searchInput = document.getElementById('search_archive');
            const fromDateInput = document.getElementById('filter_from');
            const toDateInput = document.getElementById('filter_to');
            const productInput = document.getElementById('filter_product');
            const orgInput = document.getElementById('filter_organization');
            
            const searchText = searchInput ? searchInput.value : '';
            const productId = productInput ? productInput.value : '';
            
            // STRICTLY use dropdown value.
            // The dropdown is the source of the organization UUID on the page.
            const orgId = orgInput ? orgInput.value : '';
            
            const currentYear = new Date().getFullYear();
            let fromDate = fromDateInput && fromDateInput.value ? fromDateInput.value : `${currentYear}-01-01`;
            let toDate = toDateInput && toDateInput.value ? toDateInput.value : `${currentYear}-12-31`;
            
            // Append time if missing
            if (fromDate.length === 10) fromDate += ' 00:00:00';
            if (toDate.length === 10) toDate += ' 23:59:59';

            const payload = {
                user_id: userId,
                organization_id: orgId,
                product_id: productId,
                from_date: fromDate,
                to_date: toDate,
                search_text: searchText,
                page: 1,
                limit: 50
            };

            console.log('Archive API URL:', ARCHIVE_API);
            console.log('Archive Payload:', payload);

            const response = await fetch(ARCHIVE_API, {
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
        // Calculate stats
        let total = tickets.length;
        let resolved = 0;
        let critical = 0;
        let high = 0;
        let totalDays = 0;
        let thisMonth = 0;

        const now = new Date();
        const currentMonth = now.getMonth();
        const currentYear = now.getFullYear();

        tickets.forEach(t => {
            // Resolved
            // Check status_id or status string
            if (t.status_id == 3 || (t.status && t.status.toLowerCase() === 'resolved')) {
                resolved++;
            }

            // Critical Priority
            // Check priority_level or priority string
            if (t.priority_level == 1 || (t.priority && t.priority.toLowerCase() === 'critical')) {
                critical++;
            }

            // High Priority
            if (t.priority_level == 2 || (t.priority && t.priority.toLowerCase() === 'high')) {
                high++;
            }

            // Days Archived (Avg Age)
            if (t.days_archived) {
                totalDays += t.days_archived;
            }

            // This Month
            const archiveDateStr = t.archived_at || t.archived_date || t.created_date;
            if (archiveDateStr) {
                const d = new Date(archiveDateStr);
                if (d.getMonth() === currentMonth && d.getFullYear() === currentYear) {
                    thisMonth++;
                }
            }
        });

        // Update DOM elements with animation
        animateValue('total_archived', parseInt(document.getElementById('total_archived')?.textContent || 0), total);
        animateValue('archived_resolved', parseInt(document.getElementById('archived_resolved')?.textContent || 0), resolved);
        animateValue('archived_critical', parseInt(document.getElementById('archived_critical')?.textContent || 0), critical);
        animateValue('archived_high', parseInt(document.getElementById('archived_high')?.textContent || 0), high);
        
        // Avg Age
        const avgAge = total > 0 ? Math.round(totalDays / total) : 0;
        const avgEl = document.getElementById('avg_archive_age');
        if (avgEl) {
            avgEl.textContent = avgAge + ' days';
        }

        animateValue('archived_this_month', parseInt(document.getElementById('archived_this_month')?.textContent || 0), thisMonth);
        
        // Update header count
        const countEl = document.getElementById('archiveCount');
        if (countEl) countEl.textContent = total;
    }

    function animateValue(id, start, end) {
        if (start === end) return;
        const range = end - start;
        const duration = 1000;
        let startTime = null;
        
        const obj = document.getElementById(id);
        if (!obj) return;

        function step(timestamp) {
            if (!startTime) startTime = timestamp;
            const progress = Math.min((timestamp - startTime) / duration, 1);
            obj.textContent = Math.floor(progress * range + start);
            if (progress < 1) {
                window.requestAnimationFrame(step);
            } else {
                obj.textContent = end;
            }
        }
        window.requestAnimationFrame(step);
    }

    // Event Listeners for Filters
    const applyFiltersBtn = document.getElementById('applyFilters');
    if (applyFiltersBtn) {
        applyFiltersBtn.addEventListener('click', loadArchivedTickets);
    }

    const clearFiltersBtn = document.getElementById('clearFilters');
    if (clearFiltersBtn) {
        clearFiltersBtn.addEventListener('click', function() {
            if(document.getElementById('search_archive')) document.getElementById('search_archive').value = '';
            if(document.getElementById('filter_from')) document.getElementById('filter_from').value = '';
            if(document.getElementById('filter_to')) document.getElementById('filter_to').value = '';
            if(document.getElementById('filter_priority')) document.getElementById('filter_priority').value = '';
            if(document.getElementById('filter_product')) document.getElementById('filter_product').value = '';
            if(document.getElementById('filter_organization')) document.getElementById('filter_organization').value = '';
            loadProducts(); // Reload products for default org
            loadArchivedTickets();
        });
    }

    // Organization filter listener
    const orgSelect = document.getElementById('filter_organization');
    if (orgSelect) {
        orgSelect.addEventListener('change', function() {
            loadProducts(); // Reload products for selected org
            loadArchivedTickets(); // Auto reload tickets
        });
    }

    // Initial load
    // Chain the loading sequence to ensure dropdown is the source
    loadOrganizations().then(() => {
        loadProducts();
        loadArchivedTickets();
    });

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
