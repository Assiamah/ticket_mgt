/**
 * Organizations Management JavaScript
 * Handles listing, adding, updating, and viewing organizations
 */

document.addEventListener('DOMContentLoaded', function() {
    const ORG_API = window.CONTEXT_PATH + '/v1/organization_service';
    const PRODUCT_API = window.CONTEXT_PATH + '/api/products';
    let allOrgs = [];
    let allProducts = [];
    let table = null;

    // Initialize DataTable
    if ($.fn.DataTable.isDataTable('#orgs-datatable')) {
        $('#orgs-datatable').DataTable().destroy();
    }

    table = $('#orgs-datatable').DataTable({
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
            { data: 'org_code' },
            { data: 'email', defaultContent: 'N/A' },
            { 
                data: null, 
                render: function(data) {
                    return [data.city, data.country].filter(Boolean).join(', ') || 'N/A';
                }
            },
            { 
                data: 'status',
                render: function(data) {
                    const status = data || 'inactive';
                    const badgeClass = status === 'active' ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger';
                    return `<span class="badge ${badgeClass}">${status.toUpperCase()}</span>`;
                }
            },
            { 
                data: 'subscription_type',
                render: function(data) {
                    return data ? `<span class="badge bg-light text-dark border">${data.toUpperCase()}</span>` : 'N/A';
                }
            },
            { 
                data: 'created_date',
                render: function(data) {
                    return data ? new Date(data).toLocaleDateString() : 'N/A';
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
                                    <a class="dropdown-item d-flex align-items-center gap-2" href="javascript:void(0)" onclick="viewOrg('${data.org_id}')">
                                        <i class="bi bi-eye"></i> View Details
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center gap-2" href="javascript:void(0)" onclick="editOrg('${data.org_id}')">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center gap-2 text-danger" href="javascript:void(0)" onclick="blockOrg('${data.org_id}')">
                                        <i class="bi bi-slash-circle"></i> Block
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
            searchPlaceholder: "Search organizations...",
            paginate: {
                previous: '<i class="bi bi-chevron-left"></i>',
                next: '<i class="bi bi-chevron-right"></i>'
            }
        },
        drawCallback: function() {
            $('.dataTables_paginate > .pagination').addClass('pagination-sm justify-content-end mb-0');
        }
    });

    // Load Data
    async function loadData() {
        await Promise.all([loadProducts(), loadOrgs()]);
    }

    async function loadProducts() {
        try {
            const response = await fetch(PRODUCT_API);
            if (!response.ok) {
                console.error("Product API Error:", response.status);
                return;
            }
            const text = await response.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                console.error("Failed to parse products JSON:", text);
                return;
            }
            
            allProducts = Array.isArray(data) ? data : (data.products || data.data || []);
            
            // Populate select options
            const options = allProducts.map(p => `<option value="${p.id}">${p.product_name} (${p.product_code})</option>`).join('');
            $('#org_products').html(options);
            $('#edit_org_products').html(options);
            
        } catch (error) {
            console.error('Error loading products:', error);
            showNotification('Failed to load products', 'error');
        }
    }

    async function loadOrgs() {
        try {
            const response = await fetch(ORG_API + '/get_all_organizations');
            
            if (!response.ok) {
                const errText = await response.text();
                console.error("API Error:", errText);
                let errMsg = 'Failed to load organizations';
                try {
                    const errJson = JSON.parse(errText);
                    if (errJson.message) errMsg = errJson.message;
                } catch(e) {}
                showNotification(errMsg, 'error');
                return;
            }

            const text = await response.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                console.error("Failed to parse orgs JSON:", text);
                return;
            }

            if (data.status === 'error') {
                 showNotification(data.message || 'Error loading organizations', 'error');
                 return;
            }

            const orgs = Array.isArray(data) ? data : (data.organizations || data.data || []);
            
            // Filter out blocked ones if needed, or show all. Usually 'manage' shows active ones.
            // The archive page shows blocked ones. Let's show non-blocked here.
            allOrgs = orgs.filter(o => o.status !== 'blocked');
            
            table.clear().rows.add(allOrgs).draw();
            
            // Update stats
            const countEl = document.getElementById('showingCount');
            const totalEl = document.getElementById('totalCount');
            if (countEl) countEl.textContent = allOrgs.length;
            if (totalEl) totalEl.textContent = orgs.length; // Total includes blocked? Or just loaded count
            
        } catch (error) {
            console.error('Error loading organizations:', error);
            showNotification('Failed to load organizations', 'error');
        }
    }

    // Add Organization
    const btnAddOrg = document.getElementById('btnAddOrg');
    if (btnAddOrg) {
        btnAddOrg.addEventListener('click', () => {
            document.getElementById('addOrgForm').reset();
            $('#org_products').val(null).trigger('change'); // Reset multi-select
            new bootstrap.Modal(document.getElementById('addOrgModal')).show();
        });
    }

    document.getElementById('submitAddOrg').addEventListener('click', async function() {
        const form = document.getElementById('addOrgForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const productIds = $('#org_products').val();
        if (!productIds || productIds.length === 0) {
            showNotification('Please select at least one product', 'warning');
            return;
        }

        const payload = {
            org_name: document.getElementById('org_name').value,
            org_code: document.getElementById('org_code').value,
            email: document.getElementById('org_email').value,
            phone: document.getElementById('org_phone').value,
            address: document.getElementById('org_address').value,
            city: document.getElementById('org_city').value,
            country: document.getElementById('org_country').value,
            subscription_type: document.getElementById('subscription_type').value,
            is_system_owner: document.getElementById('is_system_owner').checked,
            subscription_start_date: document.getElementById('subscription_start_date').value,
            subscription_end_date: document.getElementById('subscription_end_date').value,
            product_ids: productIds, // Validation requirement
            status: document.getElementById('is_active').checked ? 'active' : 'inactive'
        };

        try {
            const response = await fetch(ORG_API + '/add_organization', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (response.ok) {
                showNotification('Organization created successfully', 'success');
                bootstrap.Modal.getInstance(document.getElementById('addOrgModal')).hide();
                loadOrgs();
            } else {
                const err = await response.json();
                showNotification(err.message || 'Failed to create organization', 'error');
            }
        } catch (error) {
            console.error('Error creating organization:', error);
            showNotification('Error creating organization', 'error');
        }
    });

    // Edit Organization
    window.editOrg = async function(orgId) {
        try {
            // Fetch latest details
            const response = await fetch(ORG_API + '/get_organization_by_id', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ org_id: orgId })
            });
            if (!response.ok) throw new Error('Failed to fetch organization details');
            
            const text = await response.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch(e) {
                 // Try finding in local list if fetch fails or returns weird format
                 data = allOrgs.find(o => o.org_id === orgId);
            }
            
            const org = Array.isArray(data) ? data[0] : (data.organization || data); // Adjust based on API response structure
            if (!org) throw new Error('Organization not found');

            // Populate form
            document.getElementById('edit_org_id').value = org.org_id || orgId;
            document.getElementById('edit_org_name').value = org.org_name || '';
            document.getElementById('edit_org_code').value = org.org_code || '';
            document.getElementById('edit_org_email').value = org.email || '';
            document.getElementById('edit_org_phone').value = org.phone || '';
            document.getElementById('edit_org_address').value = org.address || '';
            document.getElementById('edit_org_city').value = org.city || '';
            document.getElementById('edit_org_country').value = org.country || '';
            document.getElementById('edit_subscription_type').value = org.subscription_type || '';
            document.getElementById('edit_is_system_owner').checked = org.is_system_owner === true || org.is_system_owner === 'true';
            document.getElementById('edit_subscription_start_date').value = org.subscription_start_date || '';
            document.getElementById('edit_subscription_end_date').value = org.subscription_end_date || '';
            document.getElementById('edit_is_active').checked = org.status === 'active';

            // Set products
            // Assuming org.product_ids or org.products is available. 
            // If the API returns product objects, map to IDs.
            let productIds = [];
            if (org.product_ids) productIds = org.product_ids;
            else if (org.products) productIds = org.products.map(p => p.id || p.product_id);
            
            $('#edit_org_products').val(productIds).trigger('change');

            new bootstrap.Modal(document.getElementById('editOrgModal')).show();

        } catch (error) {
            console.error('Error fetching organization details:', error);
            showNotification('Failed to load organization details', 'error');
        }
    };

    document.getElementById('submitEditOrg').addEventListener('click', async function() {
        const orgId = document.getElementById('edit_org_id').value;
        const form = document.getElementById('editOrgForm');
        
        const productIds = $('#edit_org_products').val();
        if (!productIds || productIds.length === 0) {
            showNotification('Please select at least one product', 'warning');
            return;
        }

        const payload = {
            org_id: orgId, // Ensure org_id is in payload
            org_name: document.getElementById('edit_org_name').value,
            org_code: document.getElementById('edit_org_code').value,
            email: document.getElementById('edit_org_email').value,
            phone: document.getElementById('edit_org_phone').value,
            address: document.getElementById('edit_org_address').value,
            city: document.getElementById('edit_org_city').value,
            country: document.getElementById('edit_org_country').value,
            subscription_type: document.getElementById('edit_subscription_type').value,
            is_system_owner: document.getElementById('edit_is_system_owner').checked,
            subscription_start_date: document.getElementById('edit_subscription_start_date').value,
            subscription_end_date: document.getElementById('edit_subscription_end_date').value,
            product_ids: productIds,
            status: document.getElementById('edit_is_active').checked ? 'active' : 'inactive'
        };

        try {
            const response = await fetch(ORG_API + '/update_organization', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (response.ok) {
                showNotification('Organization updated successfully', 'success');
                bootstrap.Modal.getInstance(document.getElementById('editOrgModal')).hide();
                loadOrgs();
            } else {
                const err = await response.json();
                showNotification(err.message || 'Failed to update organization', 'error');
            }
        } catch (error) {
            console.error('Error updating organization:', error);
            showNotification('Error updating organization', 'error');
        }
    });

    // Block Organization
    window.blockOrg = async function(orgId) {
        if (!confirm('Are you sure you want to block this organization?')) return;

        try {
            const response = await fetch(ORG_API + '/block_organization', { 
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ org_id: orgId })
            });
            if (response.ok) {
                showNotification('Organization blocked successfully', 'success');
                loadOrgs();
            } else {
                showNotification('Failed to block organization', 'error');
            }
        } catch (error) {
            console.error('Error blocking organization:', error);
            showNotification('Error blocking organization', 'error');
        }
    };

    // View Organization
    window.viewOrg = async function(orgId) {
         try {
            // Use local data first if available, else fetch
            let org = allOrgs.find(o => o.org_id === orgId);
            if (!org) {
                 const response = await fetch(ORG_API + '/get_organization_by_id', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ org_id: orgId })
                 });
                 if (response.ok) {
                     const text = await response.text();
                     const data = JSON.parse(text);
                     org = Array.isArray(data) ? data[0] : (data.organization || data);
                 }
            }
            
            if (!org) return;

            document.getElementById('view_org_name').textContent = org.org_name;
            document.getElementById('view_org_code').textContent = org.org_code;
            
            // Populate meta details
            document.getElementById('view_meta_status').textContent = org.status;
            document.getElementById('view_meta_status').className = `summary-value badge ${org.status === 'active' ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger'}`;
            
            document.getElementById('view_meta_subscription').textContent = org.subscription_type || 'N/A';
            document.getElementById('view_meta_system_owner').textContent = org.is_system_owner ? 'Yes' : 'No';
            document.getElementById('view_meta_email').textContent = org.email || 'N/A';
            document.getElementById('view_meta_phone').textContent = org.phone || 'N/A';
            document.getElementById('view_meta_country').textContent = org.country || 'N/A';
            document.getElementById('view_meta_created').textContent = org.created_date ? new Date(org.created_date).toLocaleDateString() : 'N/A';
            
            // Render details content
            const detailsHtml = `
                <div class="row mb-3">
                    <div class="col-6"><small class="text-muted">Address</small><div class="fw-medium">${org.address || 'N/A'}</div></div>
                    <div class="col-6"><small class="text-muted">City</small><div class="fw-medium">${org.city || 'N/A'}</div></div>
                </div>
            `;
            document.getElementById('orgDetailsContent').innerHTML = detailsHtml;

            // Render products
            const productsList = document.getElementById('view_products_list');
            if (org.product_ids && org.product_ids.length > 0) {
                 // Map IDs to names if possible, otherwise just IDs
                 const productNames = org.product_ids.map(id => {
                     const p = allProducts.find(ap => ap.id == id); // loose equality for string/int match
                     return p ? p.product_name : `Product ${id}`;
                 });
                 productsList.innerHTML = productNames.map(name => `<span class="badge bg-light text-dark me-1 mb-1 border">${name}</span>`).join('');
                 document.getElementById('view_meta_product_count').textContent = org.product_ids.length;
            } else {
                 productsList.innerHTML = '<span class="text-muted small">No products assigned</span>';
                 document.getElementById('view_meta_product_count').textContent = '0';
            }
            
            // Bind actions
            document.getElementById('editFromViewBtn').onclick = () => {
                bootstrap.Modal.getInstance(document.getElementById('viewOrgModal')).hide();
                editOrg(orgId);
            };
            
            new bootstrap.Modal(document.getElementById('viewOrgModal')).show();

        } catch (error) {
            console.error('Error viewing organization:', error);
            showNotification('Failed to load organization details', 'error');
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

    // Initial load
    loadData();
});
