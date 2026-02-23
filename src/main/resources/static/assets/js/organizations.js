/**
 * Organizations Management JavaScript
 * Handles listing, adding, updating, and viewing organizations
 */

document.addEventListener('DOMContentLoaded', function() {
    const ORG_API = (window.CONTEXT_PATH || '') + '/v1/organization_service';
    const PRODUCT_API = (window.CONTEXT_PATH || '') + '/api/products';
    let allOrgs = [];
    let allProducts = [];
    let table = null;

    function getProductId(p) {
        let id = null;
        if (p.product_id !== undefined && p.product_id !== null) id = p.product_id;
        else if (p.id !== undefined && p.id !== null) id = p.id;
        else if (p.productId !== undefined && p.productId !== null) id = p.productId;
        else if (p.uuid !== undefined && p.uuid !== null) id = p.uuid;
        
        // Explicitly check for string "undefined" which might come from bad serialization
        if (String(id) === 'undefined') {
            console.warn('getProductId: Found undefined ID for product:', p);
            return null;
        }
        return id;
    }

    // Check if we should open Add Modal automatically
    if (window.location.pathname.endsWith('/organizations/add')) {
        setTimeout(() => {
            const btn = document.getElementById('btnAddOrg');
            if (btn) btn.click();
        }, 500); // Small delay to ensure modal is ready
    }

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
            { data: 'org_email', defaultContent: 'N/A' },
            { 
                data: null, 
                render: function(data) {
                    return [data.org_city, data.org_country].filter(Boolean).join(', ') || 'N/A';
                }
            },
            { 
                data: 'is_active',
                render: function(data) {
                    const isActive = data === true || data === 'true' || data === 1;
                    const status = isActive ? 'ACTIVE' : 'INACTIVE';
                    const badgeClass = isActive ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger';
                    return `<span class="badge ${badgeClass}">${status}</span>`;
                }
            },
            { 
                data: 'subscription_type',
                render: function(data) {
                    return data ? `<span class="badge bg-light text-dark border">${data.toUpperCase()}</span>` : 'N/A';
                }
            },
            { 
                data: 'created_at',
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
                                    <a class="dropdown-item d-flex align-items-center gap-2 ${data.is_active === true || data.is_active === 'true' || data.is_active === 1 ? 'text-danger' : 'text-success'}" href="javascript:void(0)" onclick="${data.is_active === true || data.is_active === 'true' || data.is_active === 1 ? 'blockOrg' : 'unblockOrg'}('${data.org_id}')">
                                        <i class="bi ${data.is_active === true || data.is_active === 'true' || data.is_active === 1 ? 'bi-slash-circle' : 'bi-check-circle'}"></i> ${data.is_active === true || data.is_active === 'true' || data.is_active === 1 ? 'Block' : 'Unblock'}
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
            console.log('Loaded products:', allProducts); // Debugging
            
            // Populate select options
            const options = allProducts.map(p => {
                const id = getProductId(p);
                 const name = p.product_name || p.name || 'Unknown Product';
                 const code = p.product_code ? ` (${p.product_code})` : '';
                 return (id !== null && id !== undefined) ? `<option value="${id}">${name}${code}</option>` : '';
             }).join('');
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
            
            // Show all organizations since Archive page now shows Tasks
            allOrgs = orgs;
            
            table.clear().rows.add(allOrgs).draw();
            
            // Update stats
            updateStats(allOrgs);
            
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

        console.log('Submitting Add Organization payload:', payload); // Debugging
        console.log('Selected productIds:', productIds); // Debugging

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
            else if (org.products) productIds = org.products.map(p => getProductId(p)).filter(id => id !== null && id !== undefined);
            
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

    // Unblock Organization
    window.unblockOrg = async function(orgId) {
        if (!confirm('Are you sure you want to activate this organization?')) return;

        try {
            const response = await fetch(ORG_API + '/unblock_organization', { 
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ org_id: orgId })
            });
            if (response.ok) {
                showNotification('Organization activated successfully', 'success');
                loadOrgs();
            } else {
                showNotification('Failed to activate organization', 'error');
            }
        } catch (error) {
            console.error('Error activating organization:', error);
            showNotification('Error activating organization', 'error');
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
            const isActive = org.is_active === true || org.is_active === 'true' || org.is_active === 1;
            document.getElementById('view_meta_status').textContent = isActive ? 'ACTIVE' : 'INACTIVE';
            document.getElementById('view_meta_status').className = `summary-value badge ${isActive ? 'bg-soft-success text-success' : 'bg-soft-danger text-danger'}`;
            
            document.getElementById('view_meta_subscription').textContent = org.subscription_type || 'N/A';
            document.getElementById('view_meta_system_owner').textContent = (org.is_system_owner === true || org.is_system_owner === 'true') ? 'Yes' : 'No';
            document.getElementById('view_meta_email').textContent = org.org_email || 'N/A';
            document.getElementById('view_meta_phone').textContent = org.org_phone || 'N/A';
            document.getElementById('view_meta_country').textContent = org.org_country || 'N/A';
            document.getElementById('view_meta_created').textContent = org.created_at ? new Date(org.created_at).toLocaleDateString() : 'N/A';
            
            // Render details content
            const detailsHtml = `
                <div class="row mb-3">
                    <div class="col-6"><small class="text-muted">Address</small><div class="fw-medium">${org.org_address || 'N/A'}</div></div>
                    <div class="col-6"><small class="text-muted">City</small><div class="fw-medium">${org.org_city || 'N/A'}</div></div>
                </div>
            `;
            document.getElementById('orgDetailsContent').innerHTML = detailsHtml;

            // Render products
            const productsList = document.getElementById('view_products_list');
            if (org.product_ids && org.product_ids.length > 0) {
                 // Map IDs to names if possible, otherwise just IDs
                 const productNames = org.product_ids.map(id => {
                     const p = allProducts.find(ap => getProductId(ap) == id); // loose equality for string/int match
                     return p ? (p.product_name || p.name) : `Product ${id}`;
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

            const assignBtn = document.getElementById('assignProductsBtn');
            if (assignBtn) {
                assignBtn.onclick = () => {
                    bootstrap.Modal.getInstance(document.getElementById('viewOrgModal')).hide();
                    openAssignProductsModal(orgId, org.org_name, org.product_ids);
                };
            }

            const toggleBtn = document.getElementById('toggleStatusBtn');
            if (toggleBtn) {
                const isOrgActive = org.is_active === true || org.is_active === 'true' || org.is_active === 1;
                toggleBtn.innerHTML = isOrgActive ? '<i class="bi bi-slash-circle me-2"></i> Block Organization' : '<i class="bi bi-check-circle me-2"></i> Activate Organization';
                toggleBtn.className = isOrgActive ? 'btn btn-outline-danger' : 'btn btn-outline-success';
                toggleBtn.onclick = () => {
                    bootstrap.Modal.getInstance(document.getElementById('viewOrgModal')).hide();
                    if (isOrgActive) blockOrg(orgId);
                    else unblockOrg(orgId);
                };
            }
            
            new bootstrap.Modal(document.getElementById('viewOrgModal')).show();

        } catch (error) {
            console.error('Error viewing organization:', error);
            showNotification('Failed to load organization details', 'error');
        }
    };

    function openAssignProductsModal(orgId, orgName, currentProductIds) {
        document.getElementById('assign_org_id').value = orgId;
        document.getElementById('assign_org_name').textContent = orgName;
        
        const listContainer = document.getElementById('productsList');
        listContainer.innerHTML = '';
        
        allProducts.forEach(p => {
            const id = getProductId(p);
            if (!id) return;
            
            const name = p.product_name || p.name || 'Unknown';
            const isChecked = currentProductIds && currentProductIds.includes(id) ? 'checked' : '';
            
            const div = document.createElement('div');
            div.className = 'form-check mb-2';
            div.innerHTML = `
                <input class="form-check-input" type="checkbox" value="${id}" id="prod_assign_${id}" ${isChecked}>
                <label class="form-check-label" for="prod_assign_${id}">
                    ${name} <small class="text-muted">${p.product_code || ''}</small>
                </label>
            `;
            listContainer.appendChild(div);
        });
        
        new bootstrap.Modal(document.getElementById('assignProductsModal')).show();
    }

    const submitAssignBtn = document.getElementById('submitAssignProducts');
    if (submitAssignBtn) {
        submitAssignBtn.addEventListener('click', async function() {
            const orgId = document.getElementById('assign_org_id').value;
            const checkboxes = document.querySelectorAll('#productsList input[type="checkbox"]:checked');
            const selectedIds = Array.from(checkboxes).map(cb => cb.value);
            
            // Validate selected IDs to ensure no "undefined" slips through (double check)
            if (selectedIds.some(id => String(id) === 'undefined')) {
                console.warn('submitAssignProducts: Found undefined ID in selection:', selectedIds);
                showNotification('Invalid product selection detected', 'error');
                return;
            }

            try {
                // Fetch latest org details first to preserve other fields
                const response = await fetch(ORG_API + '/get_organization_by_id', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ org_id: orgId })
                });
                
                if (!response.ok) throw new Error('Failed to fetch org details');
                
                const text = await response.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch(e) {
                    // Try finding in local list
                    data = allOrgs.find(o => o.org_id === orgId);
                }
                
                const org = Array.isArray(data) ? data[0] : (data.organization || data);
                if (!org) throw new Error('Organization not found');

                const payload = {
                    org_id: org.org_id || orgId,
                    org_name: org.org_name,
                    org_code: org.org_code,
                    email: org.email || org.org_email,
                    phone: org.phone || org.org_phone,
                    address: org.address || org.org_address,
                    city: org.city || org.org_city,
                    country: org.country || org.org_country,
                    subscription_type: org.subscription_type,
                    is_system_owner: org.is_system_owner === true || org.is_system_owner === 'true',
                    subscription_start_date: org.subscription_start_date,
                    subscription_end_date: org.subscription_end_date,
                    status: org.status || (org.is_active ? 'active' : 'inactive'),
                    product_ids: selectedIds
                };

                console.log('Submitting Assign Products payload:', payload);

                const updateResponse = await fetch(ORG_API + '/update_organization', {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                if (updateResponse.ok) {
                    showNotification('Products assigned successfully', 'success');
                    bootstrap.Modal.getInstance(document.getElementById('assignProductsModal')).hide();
                    loadOrgs();
                } else {
                    const err = await updateResponse.json();
                    showNotification(err.message || 'Failed to update assignments', 'error');
                }
            } catch (error) {
                console.error('Error assigning products:', error);
                showNotification('Error assigning products', 'error');
            }
        });
    }

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

    function updateStats(orgs) {
        let total = orgs.length;
        let active = 0;
        let blocked = 0;
        let productAssignments = 0;

        orgs.forEach(org => {
            // Status check
            // API returns is_active (boolean), but sometimes it might be string or status field
            const isActive = org.is_active === true || org.is_active === 'true' || org.is_active === 1 || org.status === 'active';
            if (isActive) active++;
            else blocked++;

            // Product count
            // Check for product_ids (array of IDs) or products (array of objects)
            if (org.product_ids && Array.isArray(org.product_ids)) {
                productAssignments += org.product_ids.length;
            } else if (org.products && Array.isArray(org.products)) {
                productAssignments += org.products.length;
            }
        });

        // Debugging stats
        console.log('Stats calculated:', { total, active, blocked, productAssignments });

        // Update DOM elements safely
        const setVal = (id, val) => {
            const el = document.getElementById(id);
            if (el) {
                // If animateValue fails or is not desired, direct assignment works too
                // el.textContent = val;
                animateValue(id, parseInt(el.textContent) || 0, val);
            } else {
                console.warn('Stat element not found:', id);
            }
        };

        setVal('org_total', total);
        setVal('org_active', active);
        setVal('org_blocked', blocked);
        setVal('total_products', productAssignments);
    }

    function animateValue(id, start, end) {
        if (start === end) return;
        const range = end - start;
        const duration = 1000;
        let startTime = null;
        
        const obj = document.getElementById(id);
        if (!obj) {
            console.error('animateValue: Element not found:', id);
            return;
        }

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

    // Initial load
    loadData();
});
