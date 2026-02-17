/**
 * User Accounts Management
 * Handles user CRUD, filtering, and interactions
 */

const UserAccounts = {
    // Configuration
    config: {
        apiBase: (window.CONTEXT_PATH || '') + '/api/users',
        endpoints: {
            list: '',
            create: '',
            update: '',
            get: (id) => `/${id}`,
            deactivate: (id) => `/${id}/deactivate`,
            profile: '/profile'
        },
        pagination: {
            page: 1,
            limit: 10,
            total: 0
        }
    },

    // State
    state: {
        users: [],
        filters: {
            search: '',
            status: '',
            role: '',
            organization: ''
        },
        isLoading: false
    },

    // Load Organizations for filter
    async loadOrganizations() {
        console.log('[UserAccounts] Loading organizations...');
        const orgSelect = document.getElementById('filter_organization');
        const modalOrgSelect = document.getElementById('org_select');
        
        if (!orgSelect && !modalOrgSelect) return;

        try {
            // Try fetching from organization API
            const apiPath = (window.CONTEXT_PATH || '') + '/api/organizations';
            const response = await fetch(apiPath);
            if (!response.ok) throw new Error('Failed to load organizations');
            
            const data = await response.json();
            const orgs = Array.isArray(data) ? data : (data.data || data.organizations || []);
            
            console.log('[UserAccounts] Organizations loaded:', orgs);

            const options = orgs.map(org => `<option value="${org.id || org.org_id}">${org.name || org.org_name}</option>`).join('');

            if (orgSelect) {
                orgSelect.innerHTML = '<option value="">All Organizations</option>' + options;
                
                // Add event listener for filter
                orgSelect.addEventListener('change', () => {
                    this.state.filters.organization = orgSelect.value;
                    this.config.pagination.page = 1;
                    this.loadUsers();
                });
            }

            if (modalOrgSelect) {
                modalOrgSelect.innerHTML = '<option value="">Select Organization</option>' + options;
            }

        } catch (error) {
            console.warn('[UserAccounts] Could not load organizations:', error);
        }
    },

    // Initialization
    init() {
        console.log('[UserAccounts] Initializing...');
        this.cacheDOM();
        this.bindEvents();
        this.loadOrganizations(); // Load orgs first
        this.loadUsers();
    },

    // Cache DOM Elements
    cacheDOM() {
        this.dom = {
            table: document.getElementById('users-datatable'),
            tableBody: document.querySelector('#users-datatable tbody'),
            pagination: document.getElementById('paginationControls'),
            
            // Filters
            searchInput: document.getElementById('users_search'),
            statusFilter: document.getElementById('filter_status'),
            roleFilter: document.getElementById('filter_role'),
            orgFilter: document.getElementById('filter_organization'),
            applyBtn: document.getElementById('applyFiltersBtn'),
            clearBtn: document.getElementById('clearFiltersBtn'),
            refreshBtn: document.getElementById('refreshUsersBtn'),
            
            // Stats
            stats: {
                total: document.getElementById('totalCount'),
                active: document.getElementById('activeCount'),
                inactive: document.getElementById('inactiveCount'),
                admin: document.getElementById('adminCount'),
                footerTotal: document.getElementById('totalCountFooter'),
                showingCount: document.getElementById('showingCount'),
                headerTotal: document.getElementById('userCount')
            },
            
            // Modals
            addModal: new bootstrap.Modal(document.getElementById('addUserModal')),
            viewModal: new bootstrap.Modal(document.getElementById('viewUserModal')),
            deleteModal: new bootstrap.Modal(document.getElementById('deleteConfirmModal')),
            assignMenusModal: new bootstrap.Modal(document.getElementById('assignMenusModal')),
            
            // Forms
            addForm: document.getElementById('addUserForm'),
            submitBtn: document.getElementById('submitUserForm'),
            confirmDeleteBtn: document.getElementById('confirmDeleteUser'),
            submitAssignMenusBtn: document.getElementById('submitAssignMenus')
        };
    },

    // Bind Event Listeners
    bindEvents() {
        this.dom.applyBtn?.addEventListener('click', () => this.applyFilters());
        this.dom.clearBtn?.addEventListener('click', () => this.clearFilters());
        this.dom.refreshBtn?.addEventListener('click', () => this.loadUsers());
        
        this.dom.submitBtn?.addEventListener('click', () => this.handleFormSubmit());
        this.dom.confirmDeleteBtn?.addEventListener('click', () => this.executeDelete());
        this.dom.submitAssignMenusBtn?.addEventListener('click', () => this.saveUserMenus());

        // Search input debounce
        let debounceTimer;
        this.dom.searchInput?.addEventListener('input', (e) => {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
                this.state.filters.search = e.target.value;
                this.config.pagination.page = 1;
                this.loadUsers();
            }, 500);
        });
    },

    // Load Users from API
    async loadUsers() {
        if (this.state.isLoading) return;
        this.state.isLoading = true;
        this.showLoading(true);

        const params = new URLSearchParams({
            page: this.config.pagination.page,
            limit: this.config.pagination.limit,
            search: this.state.filters.search
        });

        // Add other filters if selected
        if (this.state.filters.status) params.append('status', this.state.filters.status);
        if (this.state.filters.role) params.append('role', this.state.filters.role);

        // Debug logging
        console.log('[UserAccounts] Loading users with params:', params.toString());
        console.log('[UserAccounts] API URL:', this.config.apiBase);

        try {
            const response = await fetch(`${this.config.apiBase}?${params.toString()}`);
            
            // Handle HTTP errors
            if (!response.ok) {
                 const text = await response.text();
                 console.error('[UserAccounts] HTTP Error:', response.status, text.substring(0, 200));
                 throw new Error(`HTTP error! status: ${response.status}`);
            }

            // Read text first to handle potential non-JSON responses gracefully
            const rawText = await response.text();
            
            // Check if response is HTML (starts with <)
            if (rawText.trim().startsWith('<')) {
                console.error('[UserAccounts] Received HTML instead of JSON:', rawText.substring(0, 200));
                throw new Error("Received HTML response from server. Check API URL or authentication.");
            }

            let data;
            try {
                data = JSON.parse(rawText);
            } catch (e) {
                console.error('[UserAccounts] JSON Parse Error:', e);
                throw new Error("Failed to parse JSON response.");
            }

            console.log('[UserAccounts] Users loaded:', data);
            
            // Handle different response structures
            // 1. { success: true, data: [...] }
            // 2. { status: "success", data: [...] }
            // 3. [...] (direct array)
            // 4. { users: [...], totalCount: ... } (Specific for this API)
            
            let usersData = [];
            let totalCount = 0;

            if (typeof data === 'string') {
                try {
                    const parsed = JSON.parse(data);
                    usersData = parsed.data || parsed.users || parsed;
                    totalCount = parsed.total || parsed.totalCount || usersData.length;
                } catch(e) {
                    console.warn('[UserAccounts] Failed to parse double-encoded JSON');
                }
            } else if (Array.isArray(data)) {
                usersData = data;
                totalCount = data.length;
            } else if (data.users) {
                 // Handle the specific structure returned by the API
                usersData = data.users;
                totalCount = data.totalCount || data.users.length;
            } else if (data.data) {
                usersData = data.data;
                totalCount = data.total || data.data.length;
            }

            this.state.users = Array.isArray(usersData) ? usersData : [];
            this.config.pagination.total = totalCount;
            
            this.renderTable();
            this.updateStats();

        } catch (error) {
            console.error('[UserAccounts] Error loading users:', error);
            this.showNotification('Failed to load users. See console for details.', 'error');
            this.dom.tableBody.innerHTML = `<tr><td colspan="8" class="text-center text-danger py-4">Error loading data: ${error.message}</td></tr>`;
        } finally {
            this.state.isLoading = false;
            this.showLoading(false);
        }
    },

    // Render Table Rows
    renderTable() {
        console.log(`[UserAccounts] Rendering ${this.state.users.length} users into table.`);
        
        // Debug and normalize role check (using window global)
        const currentUserRole = String(window.CURRENT_USER_ROLE || '').toLowerCase();
        console.log('[UserAccounts] Current User Role:', currentUserRole);
        const canAssignMenus = currentUserRole.includes('admin') || currentUserRole.includes('owner');
        console.log('[UserAccounts] Can assign menus?', canAssignMenus);

        const tbody = document.querySelector('#users-datatable tbody');
        
        // If tbody doesn't exist but table does, create it
        if (!tbody) {
            const table = document.getElementById('users-datatable');
            if (table) {
                console.log('[UserAccounts] Creating missing tbody');
                const newTbody = document.createElement('tbody');
                table.appendChild(newTbody);
                this.dom.tableBody = newTbody; // Update reference
            } else {
                console.error('[UserAccounts] Table #users-datatable not found!');
                return;
            }
        } else {
            // Update reference just in case
            this.dom.tableBody = tbody;
        }

        const currentTbody = this.dom.tableBody;
        currentTbody.innerHTML = '';

        if (this.state.users.length === 0) {
            currentTbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted py-4">No users found</td></tr>';
            this.updateStats(); // Ensure stats are zeroed
            return;
        }

        this.state.users.forEach(user => {
            const fullName = user.full_name || `${user.first_name || ''} ${user.last_name || ''}`.trim() || user.username;
            const names = fullName.split(' ');
            const firstName = names[0] || '';
            const lastName = names.length > 1 ? names[names.length - 1] : '';

            const row = document.createElement('tr');
            row.innerHTML = `
                <td>
                    <div class="d-flex align-items-center">
                        <div class="avatar-initial rounded-circle bg-light text-primary me-3 d-flex align-items-center justify-content-center" style="width: 35px; height: 35px; font-weight: bold;">
                            ${this.getInitials(firstName, lastName)}
                        </div>
                        <div>
                            <h6 class="mb-0 fs-14">${fullName}</h6>
                            <small class="text-muted">${user.email}</small>
                        </div>
                    </div>
                </td>
                <td>${user.username}</td>
                <td>${user.phone_number || '-'}</td>
                <td><span class="badge bg-light text-dark border">${user.role}</span></td>
                <td>${user.organization_name || user.org_name || '-'}</td>
                <td>${this.getStatusBadge(user.status)}</td>
                <td>${this.formatDate(user.created_at || user.created_date)}</td>
                <td class="text-end">
                    <div class="dropdown">
                        <button class="btn btn-sm btn-icon btn-ghost-secondary" data-bs-toggle="dropdown">
                            <i class="bi bi-three-dots-vertical"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="UserAccounts.viewUser('${user.id || user.user_id}')"><i class="bi bi-eye me-2"></i>View Details</a></li>
                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="UserAccounts.editUser('${user.id || user.user_id}')"><i class="bi bi-pencil me-2"></i>Edit</a></li>
                            ${canAssignMenus ? 
                            `<li><a class="dropdown-item" href="javascript:void(0)" onclick="UserAccounts.assignMenus('${user.id || user.user_id}', '${user.username}')"><i class="bi bi-list-check me-2"></i>Assign Menus</a></li>` : ''}
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="UserAccounts.deleteUser('${user.id || user.user_id}', '${user.username}')"><i class="bi bi-trash me-2"></i>Delete</a></li>
                        </ul>
                    </div>
                </td>
            `;
            currentTbody.appendChild(row);
        });
        
        // Update counts
        if (this.dom.stats.showingCount) this.dom.stats.showingCount.textContent = this.state.users.length;
        if (this.dom.stats.headerTotal) this.dom.stats.headerTotal.textContent = this.config.pagination.total;
        if (this.dom.stats.footerTotal) this.dom.stats.footerTotal.textContent = this.config.pagination.total;
        
        this.updateStats(); // Force update stats after render
    },

    // Update Dashboard Stats
    updateStats() {
        const users = this.state.users;
        const stats = {
            total: this.config.pagination.total || users.length, // Use API total if available
            active: users.filter(u => String(u.status).toLowerCase() === 'active').length,
            inactive: users.filter(u => String(u.status).toLowerCase() === 'inactive').length,
            admin: users.filter(u => String(u.role).toLowerCase() === 'admin').length
        };

        // Debug stats
        console.log('[UserAccounts] Updating stats:', stats);

        if (this.dom.stats.total) this.dom.stats.total.textContent = stats.total;
        if (this.dom.stats.active) this.dom.stats.active.textContent = stats.active;
        if (this.dom.stats.inactive) this.dom.stats.inactive.textContent = stats.inactive;
        if (this.dom.stats.admin) this.dom.stats.admin.textContent = stats.admin;
    },

    // Handle Form Submit (Add/Edit)
    async handleFormSubmit() {
        if (!this.dom.addForm.checkValidity()) {
            this.dom.addForm.reportValidity();
            return;
        }

        const formData = new FormData(this.dom.addForm);
        const data = Object.fromEntries(formData.entries());
        
        // Ensure checkboxes are handled
        data.expire_pass = document.getElementById('expire_pass').checked;
        data.login_notification = document.getElementById('login_notification').checked;
        data.login_approval = document.getElementById('login_approval').checked;
        
        // Two factor radio
        if(document.getElementById('two_factor_sms').checked) data.two_factor_auth = true; // Simplified for example
        
        // Request Type
        const isEdit = data.requestType === 'updateUser';
        console.log(`[UserAccounts] Submitting form (${data.requestType}):`, data);

        try {
            const response = await fetch(this.config.apiBase, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const result = await response.json();
            console.log('[UserAccounts] Submit result:', result);

            if (result.success || result.status !== 'error') {
                this.showNotification(isEdit ? 'User updated successfully' : 'User created successfully', 'success');
                this.dom.addModal.hide();
                this.loadUsers(); // Refresh list
            } else {
                this.showNotification(result.message || 'Operation failed', 'error');
            }

        } catch (error) {
            console.error('[UserAccounts] Submit error:', error);
            this.showNotification('An error occurred while saving', 'error');
        }
    },

    // View User Details
    async viewUser(id) {
        console.log('[UserAccounts] Viewing user:', id);
        try {
            const response = await fetch(`${this.config.apiBase}${this.config.endpoints.get(id)}`);
            const result = await response.json();
            
            // Handle wrapper structure if present (e.g., { status: "success", data: {...} })
            const user = result.data || result;
            
            console.log('[UserAccounts] User details:', user);

            // Populate Modal
            const fullName = user.full_name || `${user.first_name || ''} ${user.last_name || ''}`.trim();
            document.getElementById('viewUserName').textContent = fullName;
            document.getElementById('viewUserRole').textContent = user.role;
            
            // Meta data
            document.getElementById('view_meta_status').textContent = user.status;
            document.getElementById('view_meta_status').className = `summary-value badge ${user.status === 'active' ? 'bg-success' : 'bg-danger'}`;
            document.getElementById('view_meta_role').textContent = user.role;
            document.getElementById('view_meta_level').textContent = user.level || '1';
            document.getElementById('view_meta_organization').textContent = user.organization_name || user.org_name || '-';
            document.getElementById('view_meta_email').textContent = user.email;
            document.getElementById('view_meta_phone').textContent = user.phone_number || '-';
            document.getElementById('view_meta_created').textContent = this.formatDate(user.created_at || user.created_date);

            // Set ID for edit button
            document.getElementById('editFromViewBtn').onclick = () => {
                this.dom.viewModal.hide();
                this.editUser(id);
            };

            this.dom.viewModal.show();

        } catch (error) {
            console.error('[UserAccounts] Error viewing user:', error);
            this.showNotification('Failed to fetch user details', 'error');
        }
    },

    // Edit User (Populate Form)
    async editUser(id) {
        console.log('[UserAccounts] Editing user:', id);
        try {
            const response = await fetch(`${this.config.apiBase}${this.config.endpoints.get(id)}`);
            const result = await response.json();
            const user = result.data || result;

            // Reset Form
            this.dom.addForm.reset();
            document.getElementById('addUserModalLabel').textContent = 'Edit User';
            document.getElementById('requestType').value = 'updateUser';
            document.getElementById('user_id').value = user.user_id || user.id;
            
            // Populate Fields
            const fullName = user.full_name || '';
            const names = fullName.split(' ');
            const firstName = user.first_name || names[0] || '';
            const lastName = user.last_name || (names.length > 1 ? names.slice(1).join(' ') : '') || '';

            document.getElementById('first_name').value = firstName;
            document.getElementById('last_name').value = lastName;
            document.getElementById('username').value = user.username || '';
            document.getElementById('email').value = user.email || '';
            document.getElementById('phone_number').value = user.phone_number || '';
            document.getElementById('role').value = user.role || '';
            document.getElementById('status').value = user.status || 'active';
            
            // Disable password requirement for edit
            document.getElementById('password').required = false;
            document.getElementById('confirm_password').required = false;

            this.dom.addModal.show();

        } catch (error) {
            console.error('[UserAccounts] Error loading user for edit:', error);
            this.showNotification('Failed to load user details', 'error');
        }
    },

    // Assign Menus
    async assignMenus(userId, username) {
        console.log('[UserAccounts] Assigning menus for:', userId);
        
        document.getElementById('assign_user_id').value = userId;
        document.getElementById('assign_user_name').textContent = `Assigning to: ${username}`;
        document.getElementById('menusList').innerHTML = '<div class="text-center py-4"><div class="spinner-border spinner-border-sm text-primary" role="status"></div><span class="ms-2">Loading menus...</span></div>';
        
        this.dom.assignMenusModal.show();

        try {
            // 1. Fetch all available menus
            const allMenusResponse = await fetch(`${window.CONTEXT_PATH}/api/users/menus`);
            const allMenusResult = await allMenusResponse.json();
            
            // Handle different response structures
            let allMenus = [];
            if (Array.isArray(allMenusResult)) {
                allMenus = allMenusResult;
            } else if (allMenusResult.data && Array.isArray(allMenusResult.data)) {
                allMenus = allMenusResult.data;
            } else if (allMenusResult.menus && Array.isArray(allMenusResult.menus)) {
                allMenus = allMenusResult.menus;
            } else {
                // Fallback: try to parse if it's a string
                 try {
                    const parsed = typeof allMenusResult === 'string' ? JSON.parse(allMenusResult) : allMenusResult;
                    if(Array.isArray(parsed)) allMenus = parsed;
                    else if(parsed.data) allMenus = parsed.data;
                } catch(e) { console.warn('Failed to parse menu list', e); }
            }

            // 2. Fetch user's assigned menus
            const userMenusResponse = await fetch(`${window.CONTEXT_PATH}/api/users/${userId}/menus`);
            const userMenusResult = await userMenusResponse.json();
            
            let assignedMenuIds = [];
             // Handle different response structures for user menus
            if (Array.isArray(userMenusResult)) {
                assignedMenuIds = userMenusResult.map(m => m.id || m.menu_id);
            } else if (userMenusResult.data) {
                assignedMenuIds = (Array.isArray(userMenusResult.data) ? userMenusResult.data : []).map(m => m.id || m.menu_id);
            } else if (userMenusResult.menu_ids) {
                assignedMenuIds = userMenusResult.menu_ids;
            } else {
                 // Try parsing
                 try {
                     const parsed = typeof userMenusResult === 'string' ? JSON.parse(userMenusResult) : userMenusResult;
                     if(Array.isArray(parsed)) assignedMenuIds = parsed.map(m => m.id || m.menu_id);
                     else if(parsed.data) assignedMenuIds = (Array.isArray(parsed.data) ? parsed.data : []).map(m => m.id || m.menu_id);
                 } catch(e) {}
            }

            this.renderMenuSelection(allMenus, assignedMenuIds);

        } catch (error) {
            console.error('[UserAccounts] Error loading menus:', error);
            document.getElementById('menusList').innerHTML = `<div class="alert alert-danger">Failed to load menus: ${error.message}</div>`;
        }
    },

    renderMenuSelection(allMenus, assignedIds) {
        const container = document.getElementById('menusList');
        container.innerHTML = '';
        
        if (!allMenus || allMenus.length === 0) {
            container.innerHTML = '<div class="text-center text-muted">No menus available</div>';
            return;
        }

        // Build simple tree or list
        // Assuming flat list with parent_id or parent_menu_id
        
        // Group by parent
        const roots = [];
        const children = {};
        
        allMenus.forEach(menu => {
            const pid = menu.parent_id || menu.parent_menu_id;
            if (!pid || pid === '0' || pid === 0) {
                roots.push(menu);
            } else {
                if (!children[pid]) children[pid] = [];
                children[pid].push(menu);
            }
        });
        
        // Sort by position or name if available
        roots.sort((a, b) => (a.position || 0) - (b.position || 0) || (a.name || '').localeCompare(b.name || ''));

        const createCheckbox = (menu, isChild = false) => {
            const id = menu.id || menu.menu_id;
            const isChecked = assignedIds.includes(id) || assignedIds.includes(String(id)) || assignedIds.includes(Number(id));
            
            return `
                <div class="form-check ${isChild ? 'ms-4' : 'mb-2 fw-bold'}">
                    <input class="form-check-input menu-checkbox" type="checkbox" 
                           value="${id}" id="menu_${id}" 
                           ${isChecked ? 'checked' : ''}
                           data-parent="${menu.parent_id || menu.parent_menu_id || ''}">
                    <label class="form-check-label" for="menu_${id}">
                        ${menu.name || menu.title || 'Unknown Menu'} 
                        ${menu.icon ? `<i class="${menu.icon} ms-1 text-muted"></i>` : ''}
                    </label>
                </div>
            `;
        };

        let html = '';
        roots.forEach(root => {
            const rootId = root.id || root.menu_id;
            html += createCheckbox(root);
            
            if (children[rootId]) {
                children[rootId].forEach(child => {
                    html += createCheckbox(child, true);
                });
            }
            html += '<hr class="my-2 opacity-25">';
        });
        
        container.innerHTML = html;
        
        // Add event listeners for parent/child selection logic
        container.querySelectorAll('.menu-checkbox').forEach(cb => {
            cb.addEventListener('change', (e) => {
                const id = e.target.value;
                const isChecked = e.target.checked;
                
                // If parent is checked/unchecked, check/uncheck all children
                if (!e.target.dataset.parent) {
                    // It's a parent
                    const childCheckboxes = container.querySelectorAll(`input[data-parent="${id}"]`);
                    childCheckboxes.forEach(child => child.checked = isChecked);
                } else {
                    // It's a child. If checked, ensure parent is checked
                    if (isChecked) {
                        const parentId = e.target.dataset.parent;
                        const parentCb = container.querySelector(`#menu_${parentId}`);
                        if (parentCb) parentCb.checked = true;
                    }
                }
            });
        });
    },

    async saveUserMenus() {
        const userId = document.getElementById('assign_user_id').value;
        if (!userId) return;

        const checkboxes = document.querySelectorAll('.menu-checkbox:checked');
        const menuIds = Array.from(checkboxes).map(cb => cb.value);

        const btn = this.dom.submitAssignMenusBtn;
        const originalText = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';

        try {
            const response = await fetch(`${window.CONTEXT_PATH}/api/users/${userId}/menus`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ menu_ids: menuIds })
            });
            
            const result = await response.json();
            
            if (result.status === 'success' || result.success) {
                this.showNotification('Menu permissions updated successfully', 'success');
                this.dom.assignMenusModal.hide();
            } else {
                this.showNotification(result.message || 'Failed to save permissions', 'error');
            }
        } catch (error) {
            console.error('[UserAccounts] Error saving menus:', error);
            this.showNotification('Error saving menu permissions', 'error');
        } finally {
            btn.disabled = false;
            btn.innerHTML = originalText;
        }
    },

    // Delete User
    deleteUser(id, username) {
        this.dom.deleteModal.show();
        document.getElementById('deleteUserName').textContent = username;
        this.dom.confirmDeleteBtn.onclick = () => this.executeDelete(id);
    },

    async executeDelete(id) {
        if(!id) return;
        console.log('[UserAccounts] Deleting user:', id);
        
        try {
            const response = await fetch(`${this.config.apiBase}${this.config.endpoints.deactivate(id)}`, {
                method: 'POST'
            });
            const result = await response.json();

            if (result.success || result.status !== 'error') {
                this.showNotification('User deactivated successfully', 'success');
                this.dom.deleteModal.hide();
                this.loadUsers();
            } else {
                this.showNotification(result.message || 'Delete failed', 'error');
            }
        } catch (error) {
            console.error('[UserAccounts] Delete error:', error);
            this.showNotification('Failed to delete user', 'error');
        }
    },

    // Helpers
    showNotification(message, type = 'info') {
        // Assuming a global notification function exists, or alert fallback
        if (typeof showNotification === 'function') {
            showNotification(message, type);
        } else {
            alert(message);
        }
    },

    showLoading(show) {
        if (show) {
            this.dom.tableBody.style.opacity = '0.5';
        } else {
            this.dom.tableBody.style.opacity = '1';
        }
    },

    getInitials(first, last) {
        return ((first?.[0] || '') + (last?.[0] || '')).toUpperCase();
    },

    getStatusBadge(status) {
        const badges = {
            'active': 'bg-success',
            'inactive': 'bg-secondary',
            'suspended': 'bg-danger'
        };
        return `<span class="badge ${badges[status] || 'bg-light text-dark'}">${status}</span>`;
    },

    formatDate(dateStr) {
        if (!dateStr) return '-';
        return new Date(dateStr).toLocaleDateString();
    },

    applyFilters() {
        this.state.filters.status = this.dom.statusFilter.value;
        this.state.filters.role = this.dom.roleFilter.value;
        this.config.pagination.page = 1;
        this.loadUsers();
    },

    clearFilters() {
        this.dom.statusFilter.value = '';
        this.dom.roleFilter.value = '';
        this.dom.searchInput.value = '';
        this.state.filters = { search: '', status: '', role: '', organization: '' };
        this.loadUsers();
    },
    
    renderPagination() {
        // Implementation of pagination controls rendering
        // Can be added if pagination API supports total pages
    }
};

// Expose functions to window scope immediately
window.showUserModal = function() {
    const form = document.getElementById('addUserForm');
    if (form) form.reset();
    
    const requestType = document.getElementById('requestType');
    if (requestType) requestType.value = 'addUser';
    
    const label = document.getElementById('addUserModalLabel');
    if (label) label.textContent = 'Add New User';
    
    const pass = document.getElementById('password');
    if (pass) pass.required = true;
    
    const confirmPass = document.getElementById('confirm_password');
    if (confirmPass) confirmPass.required = true;
    
    const modalEl = document.getElementById('addUserModal');
    if (modalEl) {
        const modal = new bootstrap.Modal(modalEl);
        modal.show();
    } else {
        console.error('Add User Modal element not found');
    }
};

window.UserAccounts = UserAccounts;

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    UserAccounts.init();
});
