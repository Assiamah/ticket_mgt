/**
 * Organizations Archive JavaScript
 * Handles loading and managing archived (blocked) organizations
 */

document.addEventListener('DOMContentLoaded', function() {
    const ORG_FETCH_API = window.CONTEXT_PATH + '/v1/organization_service/get_org_archived_tasks';
    const ORG_ACTION_API = window.CONTEXT_PATH + '/v1/organization_service';
    let allOrgs = [];
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
                                <i class="bi bi-building text-secondary"></i>
                            </div>
                            <div>
                                <h6 class="mb-0 text-dark" style="font-size: 0.9rem;">${data.org_name || 'N/A'}</h6>
                                <small class="text-muted">${data.org_code || ''}</small>
                            </div>
                        </div>
                    `;
                }
            },
            { 
                data: 'created_date',
                render: function(data) {
                    if (!data) return 'N/A';
                    return new Date(data).toLocaleDateString();
                }
            },
            { 
                data: null,
                render: function() {
                    return '<span class="text-muted small">Subscription Expired/Deactivated</span>';
                }
            },
            { 
                data: null,
                render: function() {
                    return `
                        <span class="badge bg-soft-danger text-danger">
                            <i class="bi bi-x-circle me-1"></i> Blocked
                        </span>
                    `;
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
                                    <a class="dropdown-item d-flex align-items-center gap-2" href="javascript:void(0)" onclick="unblockOrg('${data.org_id}')">
                                        <i class="bi bi-check-circle text-success"></i> Restore
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center gap-2 text-danger" href="javascript:void(0)" onclick="deleteOrgPermanently('${data.org_id}')">
                                        <i class="bi bi-trash"></i> Delete Permanently
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

    // Load Organizations
    async function loadArchivedOrgs() {
        try {
            const response = await fetch(ORG_FETCH_API, {
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
                    showNotification(data.message || 'Failed to load archived organizations', 'error');
                }
                return;
            }

            const orgs = Array.isArray(data) ? data : (data.organizations || data.data || []);
            
            // Filter for blocked organizations
            // allOrgs = orgs.filter(o => o.status === 'blocked' || o.is_active === false || o.is_active === '0');
            allOrgs = orgs;
            
            table.clear().rows.add(allOrgs).draw();
            
            // Update stats
            const countEl = document.getElementById('archived_total');
            if (countEl) countEl.textContent = allOrgs.length;
            
        } catch (error) {
            console.error('Error loading archived organizations:', error);
            showNotification('Failed to load archive', 'error');
        }
    }

    // Global actions
    window.unblockOrg = async function(orgId) {
        if (!confirm('Are you sure you want to restore this organization?')) return;

        try {
            const response = await fetch(`${ORG_ACTION_API}/unblock_organization`, { 
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ org_id: orgId })
            });
            if (response.ok) {
                showNotification('Organization restored successfully', 'success');
                loadArchivedOrgs();
            } else {
                showNotification('Failed to restore organization', 'error');
            }
        } catch (error) {
            console.error('Error restoring organization:', error);
            showNotification('Error restoring organization', 'error');
        }
    };

    window.deleteOrgPermanently = function(orgId) {
        // Implement permanent deletion logic if backend supports it
        showNotification('Permanent deletion not supported in this view', 'info');
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
    if (refreshBtn) refreshBtn.addEventListener('click', loadArchivedOrgs);

    const searchInput = document.getElementById('archive_search');
    if (searchInput) {
        searchInput.addEventListener('keyup', function() {
            table.search(this.value).draw();
        });
    }

    // Initial load
    loadArchivedOrgs();
});
