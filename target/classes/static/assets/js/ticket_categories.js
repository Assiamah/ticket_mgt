/**
 * Ticket Categories Management
 * Handles CRUD operations for Statuses, Categories, and Priorities
 */

const TicketCategories = {
    // Configuration
    config: {
        // Fallback if window.CONTEXT_PATH is not set yet
        apiBase: (typeof window.CONTEXT_PATH !== 'undefined' ? window.CONTEXT_PATH : '') + '/api/tickets',
        endpoints: {
            statuses: {
                list: '/statuses/list',
                add: '/statuses/add',
                update: '/statuses/update',
                delete: '/statuses/delete'
            },
            categories: {
                list: '/categories/list',
                add: '/categories/add',
                update: '/categories/update', 
                delete: '/categories/delete'
            },
            priorities: {
                list: '/priorities/list',
                add: '/priorities/add',
                update: '/priorities/update', 
                delete: '/priorities/delete'
            }
        }
    },

    // State
    state: {
        statuses: [],
        categories: [],
        priorities: [],
        currentItem: null,
        deleteItem: null
    },

    // DOM Elements Cache
    dom: {},

    // Initialize
    init() {
        console.log('[TicketCategories] Initializing...');
        // Re-evaluate apiBase in init to ensure window.CONTEXT_PATH is ready
        // Handle undefined or null CONTEXT_PATH by defaulting to empty string
        const contextPath = (typeof window.CONTEXT_PATH !== 'undefined' && window.CONTEXT_PATH !== null) ? window.CONTEXT_PATH : '';
        this.config.apiBase = contextPath + '/api/tickets';
        
        console.log('[TicketCategories] API Base URL:', this.config.apiBase);
        
        this.cacheDOM();
        this.bindEvents();
        this.loadAllData();
    },

    // Cache DOM Elements
    cacheDOM() {
        this.dom = {
            // Stats
            stats: {
                statuses: document.getElementById('statuses_count'),
                categories: document.getElementById('categories_count'),
                priorities: document.getElementById('priorities_count')
            },

            // Tables
            tables: {
                statuses: document.querySelector('#statuses-datatable tbody'),
                categories: document.querySelector('#categories-datatable tbody'),
                priorities: document.querySelector('#priorities-datatable tbody')
            },

            // Modals
            modals: {
                addStatus: new bootstrap.Modal(document.getElementById('addStatusModal')),
                addCategory: new bootstrap.Modal(document.getElementById('addCategoryModal')),
                addPriority: new bootstrap.Modal(document.getElementById('addPriorityModal')),
                editItem: new bootstrap.Modal(document.getElementById('editItemModal')),
                deleteConfirm: new bootstrap.Modal(document.getElementById('deleteConfirmModal'))
            },

            // Forms
            forms: {
                addStatus: document.getElementById('addStatusForm'),
                addCategory: document.getElementById('addCategoryForm'),
                addPriority: document.getElementById('addPriorityForm'),
                editItem: document.getElementById('editItemForm')
            },

            // Buttons
            buttons: {
                addStatus: document.getElementById('btnAddStatus'),
                addCategory: document.getElementById('btnAddCategory'),
                addPriority: document.getElementById('btnAddPriority'),
                submitAddStatus: document.getElementById('submitAddStatus'),
                submitAddCategory: document.getElementById('submitAddCategory'),
                submitAddPriority: document.getElementById('submitAddPriority'),
                submitEditItem: document.getElementById('submitEditItem'),
                confirmDelete: document.getElementById('confirmDeleteItem')
            }
        };
    },

    // Bind Events
    bindEvents() {
        // Add Buttons
        this.dom.buttons.addStatus.addEventListener('click', () => this.dom.modals.addStatus.show());
        this.dom.buttons.addCategory.addEventListener('click', () => this.dom.modals.addCategory.show());
        this.dom.buttons.addPriority.addEventListener('click', () => this.dom.modals.addPriority.show());

        // Submit Add Forms
        this.dom.buttons.submitAddStatus.addEventListener('click', () => this.handleAddStatus());
        this.dom.buttons.submitAddCategory.addEventListener('click', () => this.handleAddCategory());
        this.dom.buttons.submitAddPriority.addEventListener('click', () => this.handleAddPriority());

        // Submit Edit/Delete
        this.dom.buttons.submitEditItem.addEventListener('click', () => this.handleEditSubmit());
        this.dom.buttons.confirmDelete.addEventListener('click', () => this.handleDeleteSubmit());
    },

    // Load All Data
    async loadAllData() {
        await Promise.all([
            this.loadStatuses(),
            this.loadCategories(),
            this.loadPriorities()
        ]);
        this.updateStats();
    },

    // ------------------------------------------------------------------------
    // Status Operations
    // ------------------------------------------------------------------------

    async loadStatuses() {
        try {
            const response = await this.fetchAPI(this.config.endpoints.statuses.list, {});
            // Check response structure. Based on TicketRest, it returns webServiceResponse directly.
            // Assuming it returns { status: "success", data: [...] } or just [...]
            this.state.statuses = this.parseResponse(response);
            this.renderStatuses();
        } catch (error) {
            console.error('Failed to load statuses:', error);
            this.showToast('Error', 'Failed to load statuses', 'error');
        }
    },

    renderStatuses() {
        const tbody = this.dom.tables.statuses;
        tbody.innerHTML = '';

        if (!this.state.statuses.length) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-3">No statuses found</td></tr>';
            return;
        }

        this.state.statuses.forEach(status => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>
                    <div class="d-flex align-items-center">
                        <span class="status-dot me-2" style="background-color: ${status.color || '#6b7280'}"></span>
                        <span class="fw-medium">${status.name}</span>
                    </div>
                </td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <div class="color-preview" style="background-color: ${status.color || '#6b7280'}; width: 16px; height: 16px; border-radius: 4px;"></div>
                        <span class="text-muted small">${status.color || '-'}</span>
                    </div>
                </td>
                <td><span class="badge bg-light text-dark">${status.usage_count || 0}</span></td>
                <td><span class="text-muted text-truncate d-block" style="max-width: 200px;">${status.description || '-'}</span></td>
                <td class="text-end">
                    <button class="btn btn-sm btn-icon btn-ghost-secondary" onclick="TicketCategories.openEditModal('status', '${status.id}')">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button class="btn btn-sm btn-icon btn-ghost-danger" onclick="TicketCategories.openDeleteModal('status', '${status.id}')">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            `;
            tbody.appendChild(row);
        });
    },

    async handleAddStatus() {
        const name = document.getElementById('status_name').value;
        const color = document.getElementById('status_color').value;
        const description = document.getElementById('status_description').value;
        const isActive = document.getElementById('status_is_active').checked;

        if (!name || !color) {
            this.showToast('Validation Error', 'Name and Color are required', 'warning');
            return;
        }

        try {
            const payload = { name, color, description, is_active: isActive };
            const response = await this.fetchAPI(this.config.endpoints.statuses.add, payload);
            
            if (this.isSuccess(response)) {
                this.dom.modals.addStatus.hide();
                this.dom.forms.addStatus.reset();
                this.showToast('Success', 'Status added successfully', 'success');
                this.loadStatuses();
            } else {
                throw new Error(response.message || 'Failed to add status');
            }
        } catch (error) {
            console.error('Add status failed:', error);
            this.showToast('Error', error.message, 'error');
        }
    },

    // ------------------------------------------------------------------------
    // Category Operations
    // ------------------------------------------------------------------------

    async loadCategories() {
        try {
            const response = await this.fetchAPI(this.config.endpoints.categories.list, {});
            this.state.categories = this.parseResponse(response);
            this.renderCategories();
        } catch (error) {
            console.error('Failed to load categories:', error);
            this.showToast('Error', 'Failed to load categories', 'error');
        }
    },

    renderCategories() {
        const tbody = this.dom.tables.categories;
        tbody.innerHTML = '';

        if (!this.state.categories.length) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-3">No categories found</td></tr>';
            return;
        }

        this.state.categories.forEach(category => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>
                    <div class="d-flex align-items-center">
                        <span class="status-dot me-2" style="background-color: ${category.color || '#10b981'}"></span>
                        <span class="fw-medium">${category.name}</span>
                    </div>
                </td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <div class="color-preview" style="background-color: ${category.color || '#10b981'}; width: 16px; height: 16px; border-radius: 4px;"></div>
                        <span class="text-muted small">${category.color || '-'}</span>
                    </div>
                </td>
                <td><span class="badge bg-light text-dark">${category.usage_count || 0}</span></td>
                <td><span class="text-muted text-truncate d-block" style="max-width: 200px;">${category.description || '-'}</span></td>
                <td class="text-end">
                    <button class="btn btn-sm btn-icon btn-ghost-secondary" onclick="TicketCategories.openEditModal('category', '${category.id}')">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button class="btn btn-sm btn-icon btn-ghost-danger" onclick="TicketCategories.openDeleteModal('category', '${category.id}')">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            `;
            tbody.appendChild(row);
        });
    },

    async handleAddCategory() {
        const name = document.getElementById('category_name').value;
        const color = document.getElementById('category_color').value;
        const description = document.getElementById('category_description').value;
        const isActive = document.getElementById('category_is_active').checked;

        if (!name) {
            this.showToast('Validation Error', 'Name is required', 'warning');
            return;
        }

        try {
            const payload = { name, color, description, is_active: isActive };
            const response = await this.fetchAPI(this.config.endpoints.categories.add, payload);
            
            if (this.isSuccess(response)) {
                this.dom.modals.addCategory.hide();
                this.dom.forms.addCategory.reset();
                this.showToast('Success', 'Category added successfully', 'success');
                this.loadCategories();
            } else {
                throw new Error(response.message || 'Failed to add category');
            }
        } catch (error) {
            console.error('Add category failed:', error);
            this.showToast('Error', error.message, 'error');
        }
    },

    // ------------------------------------------------------------------------
    // Priority Operations
    // ------------------------------------------------------------------------

    async loadPriorities() {
        try {
            const response = await this.fetchAPI(this.config.endpoints.priorities.list, {});
            this.state.priorities = this.parseResponse(response);
            this.renderPriorities();
        } catch (error) {
            console.error('Failed to load priorities:', error);
            this.showToast('Error', 'Failed to load priorities', 'error');
        }
    },

    renderPriorities() {
        const tbody = this.dom.tables.priorities;
        tbody.innerHTML = '';

        if (!this.state.priorities.length) {
            tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted py-3">No priorities found</td></tr>';
            return;
        }

        // Sort by level (ascending)
        const sortedPriorities = [...this.state.priorities].sort((a, b) => (a.level || 99) - (b.level || 99));

        sortedPriorities.forEach(priority => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>
                    <div class="d-flex align-items-center">
                        <span class="status-dot me-2" style="background-color: ${priority.color || '#ef4444'}"></span>
                        <span class="fw-medium">${priority.name}</span>
                    </div>
                </td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <div class="color-preview" style="background-color: ${priority.color || '#ef4444'}; width: 16px; height: 16px; border-radius: 4px;"></div>
                        <span class="text-muted small">${priority.color || '-'}</span>
                    </div>
                </td>
                <td><span class="badge bg-light text-dark border">Level ${priority.level || '-'}</span></td>
                <td><span class="badge bg-light text-dark">${priority.usage_count || 0}</span></td>
                <td><span class="text-muted text-truncate d-block" style="max-width: 200px;">${priority.description || '-'}</span></td>
                <td class="text-end">
                    <button class="btn btn-sm btn-icon btn-ghost-secondary" onclick="TicketCategories.openEditModal('priority', '${priority.id}')">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button class="btn btn-sm btn-icon btn-ghost-danger" onclick="TicketCategories.openDeleteModal('priority', '${priority.id}')">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            `;
            tbody.appendChild(row);
        });
    },

    async handleAddPriority() {
        const name = document.getElementById('priority_name').value;
        const level = document.getElementById('priority_level').value;
        const color = document.getElementById('priority_color').value;
        const responseTime = document.getElementById('priority_response_time').value;
        const description = document.getElementById('priority_description').value;
        const isActive = document.getElementById('priority_is_active').checked;

        if (!name || !level || !color) {
            this.showToast('Validation Error', 'Name, Level, and Color are required', 'warning');
            return;
        }

        try {
            const payload = { 
                name, 
                level: parseInt(level), 
                color, 
                response_time: parseInt(responseTime) || 0,
                description, 
                is_active: isActive 
            };
            const response = await this.fetchAPI(this.config.endpoints.priorities.add, payload);
            
            if (this.isSuccess(response)) {
                this.dom.modals.addPriority.hide();
                this.dom.forms.addPriority.reset();
                this.showToast('Success', 'Priority added successfully', 'success');
                this.loadPriorities();
            } else {
                throw new Error(response.message || 'Failed to add priority');
            }
        } catch (error) {
            console.error('Add priority failed:', error);
            this.showToast('Error', error.message, 'error');
        }
    },

    // ------------------------------------------------------------------------
    // Shared / Utility Functions
    // ------------------------------------------------------------------------

    // Open Edit Modal
    openEditModal(type, id) {
        let item;
        let title = '';
        let iconClass = '';
        let iconColor = '';
        
        // Find item and set modal details
        if (type === 'status') {
            item = this.state.statuses.find(i => i.id === id);
            title = 'Edit Status';
            iconClass = 'bi-list-task';
            iconColor = '#6366f1';
        } else if (type === 'category') {
            item = this.state.categories.find(i => i.id === id);
            title = 'Edit Category';
            iconClass = 'bi-tags';
            iconColor = '#10b981';
        } else if (type === 'priority') {
            item = this.state.priorities.find(i => i.id === id);
            title = 'Edit Priority';
            iconClass = 'bi-exclamation-triangle';
            iconColor = '#ef4444';
        }

        if (!item) return;

        // Set state
        this.state.currentItem = item;
        document.getElementById('edit_item_id').value = id;
        document.getElementById('edit_item_type').value = type;

        // Update Modal Header
        document.getElementById('editModalTitle').textContent = title;
        const iconContainer = document.getElementById('editModalIcon');
        iconContainer.innerHTML = `<i class="bi ${iconClass}"></i>`;
        iconContainer.style.color = iconColor;

        // Build Form
        const formContainer = document.getElementById('editFormContent');
        formContainer.innerHTML = this.buildEditForm(type, item);

        // Show Modal
        this.dom.modals.editItem.show();
    },

    // Build Edit Form HTML
    buildEditForm(type, item) {
        if (type === 'status') {
            return `
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Status Name</label>
                        <input type="text" class="form-control modern-input" id="edit_name" value="${item.name || ''}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Color</label>
                        <select id="edit_color" class="form-select modern-select" required>
                            <option value="#6366f1" ${item.color === '#6366f1' ? 'selected' : ''}>Primary (Blue)</option>
                            <option value="#10b981" ${item.color === '#10b981' ? 'selected' : ''}>Success (Green)</option>
                            <option value="#ef4444" ${item.color === '#ef4444' ? 'selected' : ''}>Danger (Red)</option>
                            <option value="#f59e0b" ${item.color === '#f59e0b' ? 'selected' : ''}>Warning (Yellow)</option>
                            <option value="#8b5cf6" ${item.color === '#8b5cf6' ? 'selected' : ''}>Purple</option>
                            <option value="#3b82f6" ${item.color === '#3b82f6' ? 'selected' : ''}>Info (Light Blue)</option>
                            <option value="#6b7280" ${item.color === '#6b7280' ? 'selected' : ''}>Gray</option>
                        </select>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control modern-textarea" id="edit_description" rows="3">${item.description || ''}</textarea>
                </div>
            `;
        } else if (type === 'category') {
            return `
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Category Name</label>
                        <input type="text" class="form-control modern-input" id="edit_name" value="${item.name || ''}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Color</label>
                        <select id="edit_color" class="form-select modern-select">
                            <option value="#6366f1" ${item.color === '#6366f1' ? 'selected' : ''}>Primary (Blue)</option>
                            <option value="#10b981" ${item.color === '#10b981' ? 'selected' : ''}>Success (Green)</option>
                            <option value="#ef4444" ${item.color === '#ef4444' ? 'selected' : ''}>Danger (Red)</option>
                            <option value="#f59e0b" ${item.color === '#f59e0b' ? 'selected' : ''}>Warning (Yellow)</option>
                            <option value="#8b5cf6" ${item.color === '#8b5cf6' ? 'selected' : ''}>Purple</option>
                            <option value="#3b82f6" ${item.color === '#3b82f6' ? 'selected' : ''}>Info (Light Blue)</option>
                            <option value="#6b7280" ${item.color === '#6b7280' ? 'selected' : ''}>Gray</option>
                        </select>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control modern-textarea" id="edit_description" rows="3">${item.description || ''}</textarea>
                </div>
            `;
        } else if (type === 'priority') {
            return `
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Priority Name</label>
                        <input type="text" class="form-control modern-input" id="edit_name" value="${item.name || ''}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Level</label>
                        <select id="edit_level" class="form-select modern-select" required>
                            <option value="1" ${item.level == 1 ? 'selected' : ''}>Level 1 - Critical</option>
                            <option value="2" ${item.level == 2 ? 'selected' : ''}>Level 2 - High</option>
                            <option value="3" ${item.level == 3 ? 'selected' : ''}>Level 3 - Medium</option>
                            <option value="4" ${item.level == 4 ? 'selected' : ''}>Level 4 - Low</option>
                            <option value="5" ${item.level == 5 ? 'selected' : ''}>Level 5 - Lowest</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Color</label>
                        <select id="edit_color" class="form-select modern-select" required>
                            <option value="#ef4444" ${item.color === '#ef4444' ? 'selected' : ''}>Danger (Red)</option>
                            <option value="#f97316" ${item.color === '#f97316' ? 'selected' : ''}>Orange</option>
                            <option value="#f59e0b" ${item.color === '#f59e0b' ? 'selected' : ''}>Warning (Yellow)</option>
                            <option value="#3b82f6" ${item.color === '#3b82f6' ? 'selected' : ''}>Info (Light Blue)</option>
                            <option value="#10b981" ${item.color === '#10b981' ? 'selected' : ''}>Success (Green)</option>
                            <option value="#6b7280" ${item.color === '#6b7280' ? 'selected' : ''}>Gray</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Response Time (Hours)</label>
                        <input type="number" class="form-control modern-input" id="edit_response_time" value="${item.response_time || ''}">
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control modern-textarea" id="edit_description" rows="3">${item.description || ''}</textarea>
                </div>
            `;
        }
    },

    // Handle Edit Submit
    async handleEditSubmit() {
        const id = document.getElementById('edit_item_id').value;
        const type = document.getElementById('edit_item_type').value;
        
        const name = document.getElementById('edit_name').value;
        const color = document.getElementById('edit_color').value;
        const description = document.getElementById('edit_description').value;

        const payload = { 
            [type + '_id']: id, // e.g., status_id, category_id
            name, 
            color, 
            description 
        };

        // Add specific fields
        if (type === 'priority') {
            payload.level = parseInt(document.getElementById('edit_level').value);
            payload.response_time = parseInt(document.getElementById('edit_response_time').value) || 0;
        }

        let endpoint;
        if (type === 'status') endpoint = this.config.endpoints.statuses.update;
        else if (type === 'category') endpoint = this.config.endpoints.categories.update; // Ensure this endpoint exists
        else if (type === 'priority') endpoint = this.config.endpoints.priorities.update; // Ensure this endpoint exists

        // If endpoints are missing for category/priority update, warn user
        if (!endpoint) {
             this.showToast('Error', 'Update not implemented for this type yet', 'warning');
             return;
        }

        try {
            const response = await this.fetchAPI(endpoint, payload);
            if (this.isSuccess(response)) {
                this.dom.modals.editItem.hide();
                this.showToast('Success', 'Item updated successfully', 'success');
                this.loadAllData();
            } else {
                throw new Error(response.message || 'Update failed');
            }
        } catch (error) {
            console.error('Update failed:', error);
            this.showToast('Error', error.message, 'error');
        }
    },

    // Open Delete Modal
    openDeleteModal(type, id) {
        let item;
        let endpoint;
        let idField;

        if (type === 'status') {
            item = this.state.statuses.find(i => i.id === id);
            endpoint = this.config.endpoints.statuses.delete;
            idField = 'status_id';
        } else if (type === 'category') {
            item = this.state.categories.find(i => i.id === id);
            endpoint = this.config.endpoints.categories.delete;
            idField = 'category_id';
        } else if (type === 'priority') {
            item = this.state.priorities.find(i => i.id === id);
            endpoint = this.config.endpoints.priorities.delete;
            idField = 'priority_id';
        }

        if (!item) return;

        // Populate Modal
        document.getElementById('deleteItemName').textContent = item.name;
        document.getElementById('deleteItemType').textContent = type.charAt(0).toUpperCase() + type.slice(1);
        document.getElementById('deleteUsageCount').textContent = item.usage_count || 0;

        // State for deletion
        this.state.deleteItem = { type, id, endpoint, idField };

        this.dom.modals.deleteConfirm.show();
    },

    // Handle Delete Submit
    async handleDeleteSubmit() {
        const { type, id, endpoint, idField } = this.state.deleteItem;
        
        try {
            const payload = { [idField]: id };
            const response = await this.fetchAPI(endpoint, payload);
            
            if (this.isSuccess(response)) {
                this.dom.modals.deleteConfirm.hide();
                this.showToast('Success', 'Item deleted successfully', 'success');
                this.loadAllData();
            } else {
                throw new Error(response.message || 'Delete failed');
            }
        } catch (error) {
            console.error('Delete failed:', error);
            this.showToast('Error', error.message, 'error');
        }
    },

    // Update Stats Cards
    updateStats() {
        this.dom.stats.statuses.textContent = this.state.statuses.length;
        this.dom.stats.categories.textContent = this.state.categories.length;
        this.dom.stats.priorities.textContent = this.state.priorities.length;
    },

    // API Helper
    async fetchAPI(url, data) {
        try {
            // Log the request URL for debugging
            // Ensure we don't have double slashes
            const baseUrl = this.config.apiBase.endsWith('/') ? this.config.apiBase.slice(0, -1) : this.config.apiBase;
            const endpoint = url.startsWith('/') ? url : '/' + url;
            const fullUrl = baseUrl + endpoint;
            
            console.log(`[TicketCategories] Fetching: ${fullUrl}`);

            const response = await fetch(fullUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                // Try to read error message from response
                let errorMsg = `HTTP error! status: ${response.status}`;
                try {
                    const errorData = await response.json();
                    if (errorData.message) errorMsg = errorData.message;
                } catch(e) {
                    // Could not parse error JSON, maybe HTML
                    const text = await response.text();
                    console.error('API Error Response:', text);
                }
                throw new Error(errorMsg);
            }

            // Handle potential double-encoding or non-JSON responses gracefully
            const text = await response.text();
            try {
                return JSON.parse(text);
            } catch (e) {
                console.warn('Response is not valid JSON:', text);
                // If response is HTML (starts with <), throw meaningful error
                if (text.trim().startsWith('<')) {
                     throw new Error('Server returned HTML instead of JSON. Check API path.');
                }
                return text;
            }
        } catch (error) {
            throw error;
        }
    },

    // Helper to parse response and normalize data
    parseResponse(response) {
        let data = response;
        if (typeof response === 'string') {
            try {
                data = JSON.parse(response);
            } catch (e) {
                console.warn('Failed to parse response string:', response);
            }
        }

        if (Array.isArray(data)) return data;
        if (data && Array.isArray(data.data)) return data.data;
        if (data && data.status === 'success' && Array.isArray(data.data)) return data.data;
        
        return [];
    },

    // Helper to check if operation was successful
    isSuccess(response) {
        if (response && response.status === 'success') return true;
        if (response && response.status === 'Success') return true;
        // Sometimes just returning the object implies success if no error field
        if (response && !response.error && !response.status) return true; 
        return false;
    },

    // Toast Notification
    showToast(title, message, type = 'info') {
        // Use global Toastify if available (as seen in app.jsp)
        if (typeof Toastify === 'function') {
            let bgColor;
            if (type === 'success') bgColor = "#10b981"; // Green
            else if (type === 'error') bgColor = "#ef4444"; // Red
            else if (type === 'warning') bgColor = "#f59e0b"; // Yellow
            else bgColor = "#6366f1"; // Blue/Primary

            Toastify({
                text: `${title}: ${message}`,
                duration: 3000,
                close: true,
                gravity: "top", // `top` or `bottom`
                position: "right", // `left`, `center` or `right`
                backgroundColor: bgColor,
                stopOnFocus: true, // Prevents dismissing of toast on hover
            }).showToast();
            return;
        }

        // Fallback to Bootstrap Toast if Toastify not found
        const toastEl = document.getElementById('liveToast');
        if (!toastEl) {
            console.log(`[${type.toUpperCase()}] ${title}: ${message}`);
            return;
        }

        const toastBody = toastEl.querySelector('.toast-body');
        toastBody.innerHTML = `<strong>${title}</strong><br>${message}`;

        // Set color based on type
        toastEl.className = 'toast align-items-center border-0 text-white';
        if (type === 'success') toastEl.classList.add('bg-success');
        else if (type === 'error') toastEl.classList.add('bg-danger');
        else if (type === 'warning') toastEl.classList.add('bg-warning');
        else toastEl.classList.add('bg-primary');

        const toast = new bootstrap.Toast(toastEl);
        toast.show();
    }
};

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    TicketCategories.init();
});
