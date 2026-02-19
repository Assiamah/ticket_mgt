/**
 * Accounts Management Script
 * Handles user CRUD, filtering, and security actions
 */

// Global state
let currentPage = 1;
let currentSearch = '';
let currentFilters = {
    status: '',
    role: '',
    organization: ''
};

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    loadUsers();
    setupEventListeners();
});

function setupEventListeners() {
    // Search
    const searchInput = document.getElementById('users_search');
    if (searchInput) {
        searchInput.addEventListener('input', debounce(function(e) {
            currentSearch = e.target.value;
            currentPage = 1;
            loadUsers();
        }, 500));
    }

    // Filters
    ['filter_status', 'filter_role', 'filter_organization'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', function() {
                // Update filters logic if needed
            });
        }
    });

    document.getElementById('applyFiltersBtn')?.addEventListener('click', function() {
        currentFilters.status = document.getElementById('filter_status').value;
        currentFilters.role = document.getElementById('filter_role').value;
        currentFilters.organization = document.getElementById('filter_organization').value;
        currentPage = 1;
        loadUsers();
    });

    document.getElementById('clearFiltersBtn')?.addEventListener('click', function() {
        document.getElementById('filter_status').value = '';
        document.getElementById('filter_role').value = '';
        document.getElementById('filter_organization').value = '';
        document.getElementById('users_search').value = '';
        currentSearch = '';
        currentFilters = { status: '', role: '', organization: '' };
        loadUsers();
    });

    document.getElementById('refreshUsersBtn')?.addEventListener('click', () => loadUsers());

    // Modal Submits
    document.getElementById('submitUserForm')?.addEventListener('click', handleUserSubmit);
    document.getElementById('submitSecurityAction')?.addEventListener('click', handleSecuritySubmit);
    document.getElementById('confirmDeleteUser')?.addEventListener('click', handleDeleteSubmit);
    document.getElementById('submitAssignMenus')?.addEventListener('click', handleAssignMenusSubmit);
}

// --- Data Loading ---

async function loadUsers(page = currentPage) {
    const tbody = document.querySelector('#users-datatable tbody');
    if (!tbody) return;

    tbody.innerHTML = '<tr><td colspan="8" class="text-center"><div class="spinner-border text-primary" role="status"></div></td></tr>';

    try {
        const params = new URLSearchParams({
            page: page,
            limit: 10,
            search: currentSearch,
            ...currentFilters
        });

        const response = await fetch(`${window.CONTEXT_PATH}/api/users?${params.toString()}`);
        if (!response.ok) throw new Error('Failed to load users');
        
        const rawData = await response.json();
        const data = safeParse(rawData); // Handle potential double encoding
        
        renderTable(data.users || data.content || []); // Adapt to actual API response structure
        renderPagination(data);
        updateStats(data);
        
    } catch (error) {
        console.error('Error:', error);
        tbody.innerHTML = `<tr><td colspan="8" class="text-center text-danger">Error loading users: ${error.message}</td></tr>`;
        if (typeof Toastify === 'function') {
            Toastify({ text: "Error loading users", backgroundColor: "#dc3545" }).showToast();
        }
    }
}

function renderTable(users) {
    const tbody = document.querySelector('#users-datatable tbody');
    tbody.innerHTML = '';

    if (!users || users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center">No users found</td></tr>';
        return;
    }

    users.forEach(user => {
        const tr = document.createElement('tr');
        
        // Determine correct User ID field
        const userId = user.id || user.user_id || user.userId || user.unique_id;
        if (!userId) console.warn('User ID missing for user:', user);

        // Status Badge
        const statusBadge = getStatusBadge(user.status);
        
        // Role Badge
        const roleBadge = getRoleBadge(user.role);

        // Determine display name and initials
        const fullName = (user.title ? user.title + ' ' : '') + (user.full_name || `${user.first_name || ''} ${user.last_name || ''}`.trim() || user.username || 'User');
        
        // Initials logic
        let initials = '';
        if (user.first_name && user.last_name) {
            initials = getInitials(user.first_name, user.last_name);
        } else {
             // Try to get initials from full name, ignoring title if possible
             const nameParts = fullName.replace(/^(Mr\.|Mrs\.|Ms\.|Dr\.|Prof\.)\s+/i, '').trim().split(' ');
             if (nameParts.length > 0) {
                 initials = nameParts[0][0] || '';
                 if (nameParts.length > 1) {
                     initials += nameParts[nameParts.length - 1][0] || '';
                 }
             }
             initials = initials.toUpperCase();
        }

        tr.innerHTML = `
            <td>
                <div class="d-flex align-items-center">
                    <div class="avatar avatar-sm me-2 bg-light text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold">
                        ${initials}
                    </div>
                    <div>
                        <div class="fw-bold">${fullName}</div>
                        <div class="small text-muted">${user.email || ''}</div>
                    </div>
                </div>
            </td>
            <td>${user.username || '-'}</td>
            <td>${user.phone_number || '-'}</td>
            <td>${roleBadge}</td>
            <td>${user.organization_name || '-'}</td>
            <td>${statusBadge}</td>
            <td>${formatDate(user.created_at)}</td>
            <td class="text-end">
                <div class="dropdown">
                    <button class="btn btn-sm btn-icon btn-ghost-secondary rounded-circle" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-three-dots-vertical"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="javascript:void(0)" onclick="viewUser('${userId}')"><i class="bi bi-eye me-2"></i>View Details</a></li>
                        <li><a class="dropdown-item" href="javascript:void(0)" onclick="editUser('${userId}')"><i class="bi bi-pencil me-2"></i>Edit User</a></li>
                        <li><a class="dropdown-item" href="javascript:void(0)" onclick="assignMenus('${userId}')"><i class="bi bi-list-check me-2"></i>Assign Menus</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="javascript:void(0)" onclick="showSecurityModal('${userId}')"><i class="bi bi-shield-lock me-2"></i>Security Actions</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="confirmDeleteUser('${userId}', '${user.username}')"><i class="bi bi-trash me-2"></i>Delete User</a></li>
                    </ul>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });
    
    // Update counts
    document.getElementById('userCount').textContent = users.length;
}

// --- Security Modal Functions ---

window.showSecurityModal = async function(userId) {
    try {
        const response = await fetch(`${window.CONTEXT_PATH}/api/users/${userId}`);
        const rawData = await response.json();
        let user = safeParse(rawData); // Handle potential double encoding
        
        // Handle potential response wrappers
        if (user.user) user = user.user;
        if (user.data) user = user.data;
        
        if (!user || (!user.id && !user.user_id)) throw new Error('User not found or invalid response format');

        // Populate modal
        const currentUserId = user.id || user.user_id;
        document.getElementById('security_user_id').value = currentUserId;
        const fullName = user.full_name || `${user.first_name || ''} ${user.last_name || ''}`.trim() || user.username;
        document.getElementById('security_user_name').textContent = `${fullName} (ID: ${currentUserId}) (${user.username})`;
        
        // Reset fields
        document.getElementById('new_password').value = '';
        document.getElementById('confirm_new_password').value = '';
        document.getElementById('force_password_change').checked = user.expire_pass === true || user.expire_pass === 'true'; // Handle boolean/string
        
        // Show modal
        const modal = new bootstrap.Modal(document.getElementById('securityActionModal'));
        modal.show();
        
    } catch (error) {
        console.error('Error fetching user for security:', error);
        showToast('Error fetching user details', 'error');
    }
};

window.useDefaultPassword = function() {
    const defaultPass = document.getElementById('default_password_display').value;
    document.getElementById('new_password').value = defaultPass;
    document.getElementById('confirm_new_password').value = defaultPass;
};

window.copyDefaultPassword = function() {
    const copyText = document.getElementById("default_password_display");
    copyText.select();
    copyText.setSelectionRange(0, 99999); 
    navigator.clipboard.writeText(copyText.value).then(function() {
        showToast("Copied to clipboard", "success");
    }, function(err) {
        console.error('Async: Could not copy text: ', err);
    });
};

async function handleSecuritySubmit(event) {
    if (event) event.preventDefault();
    
    const userId = document.getElementById('security_user_id').value;
    const forceChange = document.getElementById('force_password_change').checked;
    const newPassword = document.getElementById('new_password').value;
    const confirmPassword = document.getElementById('confirm_new_password').value;
    
    const btn = document.getElementById('submitSecurityAction');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';

    try {
        const contextPath = window.CONTEXT_PATH || '';
        
        // 1. Update Force Password Change
        // Add timestamp to prevent caching issues and explicitly set POST
        const forceResponse = await fetch(`${contextPath}/api/users/actions/set_force_password_change?t=${new Date().getTime()}`, {
            method: 'POST',
            cache: 'no-store',
            headers: { 
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ user_id: userId, expire_pass: forceChange })
        });
        
        if (!forceResponse.ok) {
             // Try to parse error JSON, fallback to status text
             const errorData = await forceResponse.json().catch(() => ({}));
             throw new Error(errorData.message || `Server error: ${forceResponse.status} ${forceResponse.statusText}`);
        }

        // 2. Update Password if provided
        if (newPassword) {
            if (newPassword !== confirmPassword) {
                throw new Error('Passwords do not match');
            }
            
            const passResponse = await fetch(`${contextPath}/api/users/actions/set_default_password?t=${new Date().getTime()}`, {
                method: 'POST',
                cache: 'no-store',
                headers: { 
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({ user_id: userId, password: newPassword })
            });
            
            if (!passResponse.ok) {
                 const errorData = await passResponse.json().catch(() => ({}));
                 throw new Error(errorData.message || `Server error: ${passResponse.status} ${passResponse.statusText}`);
            }
        }

        showToast('Security settings updated successfully', 'success');
        bootstrap.Modal.getInstance(document.getElementById('securityActionModal')).hide();
        loadUsers(); // Refresh list

    } catch (error) {
        console.error('Security update error:', error);
        showToast(error.message, 'error');
    } finally {
        btn.disabled = false;
        btn.innerHTML = originalText;
    }
}

// --- Helper Functions ---

function safeParse(data) {
    if (typeof data === 'string') {
        try {
            const parsed = JSON.parse(data);
            // If it's still a string (double encoded), parse again
            if (typeof parsed === 'string') return JSON.parse(parsed);
            return parsed;
        } catch (e) {
            return data;
        }
    }
    return data;
}

function showToast(message, type = 'info') {
    if (typeof Toastify === 'function') {
        const colors = {
            success: "linear-gradient(to right, #00b09b, #96c93d)",
            error: "linear-gradient(to right, #ff5f6d, #ffc371)",
            info: "linear-gradient(to right, #00b09b, #96c93d)",
            warning: "linear-gradient(to right, #f7b733, #fc4a1a)"
        };
        Toastify({
            text: message,
            duration: 3000,
            close: true,
            gravity: "top",
            position: "center",
            style: { background: colors[type] || colors.info }
        }).showToast();
    } else {
        alert(message);
    }
}

function getInitials(first, last) {
    return ((first || '')[0] + (last || '')[0]).toUpperCase();
}

function formatDate(dateString) {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString();
}

function getStatusBadge(status) {
    const map = {
        'active': 'bg-success-subtle text-success',
        'inactive': 'bg-secondary-subtle text-secondary',
        'suspended': 'bg-danger-subtle text-danger'
    };
    const cls = map[status?.toLowerCase()] || 'bg-light text-dark';
    return `<span class="badge ${cls}">${status || 'Unknown'}</span>`;
}

function getRoleBadge(role) {
    const map = {
        'admin': 'bg-purple-subtle text-purple',
        'manager': 'bg-blue-subtle text-blue',
        'user': 'bg-gray-subtle text-gray'
    };
    // Adjust colors if needed, assuming standard Bootstrap or custom classes
    return `<span class="badge bg-secondary">${role || '-'}</span>`;
}

function debounce(func, wait) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

// --- Placeholders for other actions (simplified) ---

window.viewUser = async function(userId) {
    try {
        const response = await fetch(`${window.CONTEXT_PATH}/api/users/${userId}`);
        const rawData = await response.json();
        let user = safeParse(rawData);
        
        // Handle wrappers
        if (user.user) user = user.user;
        if (user.data) user = user.data;
        
        if (!user) throw new Error('User not found');

        // Populate View Modal
        document.getElementById('viewUserName').textContent = user.full_name || `${user.first_name || ''} ${user.last_name || ''}`.trim() || user.username;
        document.getElementById('viewUserRole').textContent = user.role || 'User';
        
        // Helper to safe display
        const val = (v) => v || '-';
        
        let html = `
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="text-muted small">Username</label>
                    <div class="fw-bold">${val(user.username)}</div>
                </div>
                <div class="col-md-6">
                    <label class="text-muted small">Full Name</label>
                    <div class="fw-bold">${val((user.title ? user.title + ' ' : '') + (user.full_name || (user.first_name + ' ' + user.last_name)))}</div>
                </div>
                <div class="col-md-6">
                    <label class="text-muted small">Email</label>
                    <div class="fw-bold">${val(user.email)}</div>
                </div>
                <div class="col-md-6">
                    <label class="text-muted small">Phone</label>
                    <div class="fw-bold">${val(user.phone_number)}</div>
                </div>
                <div class="col-md-6">
                    <label class="text-muted small">Gender</label>
                    <div class="fw-bold">${val(user.gender)}</div>
                </div>
                <div class="col-md-6">
                    <label class="text-muted small">DOB</label>
                    <div class="fw-bold">${val(user.dob)}</div>
                </div>
                 <div class="col-md-6">
                    <label class="text-muted small">Country</label>
                    <div class="fw-bold">${val(user.country)}</div>
                </div>
                 <div class="col-md-6">
                    <label class="text-muted small">Nationality</label>
                    <div class="fw-bold">${val(user.nationality)}</div>
                </div>
            </div>
            <div class="mt-3">
                <label class="text-muted small">Address</label>
                <div class="fw-bold">
                    ${[user.address, user.city, user.state, user.zip_code].filter(Boolean).join(', ') || '-'}
                </div>
            </div>
        `;
        
        document.getElementById('userDetailsContent').innerHTML = html;
        
        // Populate Summary
        document.getElementById('view_meta_status').textContent = user.status || '-';
        document.getElementById('view_meta_status').className = `summary-value badge ${getStatusBadgeClass(user.status)}`;
        document.getElementById('view_meta_role').textContent = user.role || '-';
        document.getElementById('view_meta_level').textContent = user.level || '-';
        document.getElementById('view_meta_organization').textContent = user.organization_name || user.org_id || '-';
        document.getElementById('view_meta_email').textContent = user.email || '-';
        document.getElementById('view_meta_phone').textContent = user.phone_number || '-';
        document.getElementById('view_meta_2fa').textContent = user.two_factor || 'None';
        document.getElementById('view_meta_created').textContent = formatDate(user.created_at);
        document.getElementById('view_meta_last_login').textContent = formatDate(user.last_login);
        
        // Load Menus (async)
        loadUserMenusForView(userId);
        
        // Setup Edit Button
        document.getElementById('editFromViewBtn').onclick = () => {
            bootstrap.Modal.getInstance(document.getElementById('viewUserModal')).hide();
            editUser(userId);
        };

        new bootstrap.Modal(document.getElementById('viewUserModal')).show();
        
    } catch (error) {
        console.error('Error viewing user:', error);
        showToast('Error loading user details', 'error');
    }
};

function getStatusBadgeClass(status) {
    const map = {
        'active': 'bg-success-subtle text-success',
        'inactive': 'bg-secondary-subtle text-secondary',
        'suspended': 'bg-danger-subtle text-danger'
    };
    return map[status?.toLowerCase()] || 'bg-light text-dark';
}

async function loadUserMenusForView(userId) {
    const container = document.getElementById('view_menus_list');
    container.innerHTML = '<div class="text-center py-2"><div class="spinner-border spinner-border-sm text-primary"></div></div>';
    
    try {
        const response = await fetch(`${window.CONTEXT_PATH}/api/users/${userId}/menus`);
        if (!response.ok) throw new Error('Failed to load menus');
        const rawData = await response.json();
        
        const parsed = safeParse(rawData);
        let menus = [];
        if (Array.isArray(parsed)) menus = parsed;
        else if (parsed && parsed.data && Array.isArray(parsed.data)) menus = parsed.data;
        else if (parsed && parsed.menus && Array.isArray(parsed.menus)) menus = parsed.menus;
        else if (parsed && parsed.content && Array.isArray(parsed.content)) menus = parsed.content;
        
        if (!menus || menus.length === 0) {
            container.innerHTML = '<div class="text-muted text-center py-2">No specific menu permissions assigned</div>';
            return;
        }
        
        // Render menus (simplified)
        container.innerHTML = menus.map(m => `<span class="badge bg-primary-subtle text-primary me-1 mb-1">${m.title || m.menu_name || m.name || m.menuName || 'Unknown'}</span>`).join('');
        
    } catch (e) {
        console.error('Error loading view menus:', e);
        container.innerHTML = '<div class="text-danger small">Failed to load permissions</div>';
    }
}

window.assignMenus = async function(userId) {
    const menusList = document.getElementById('menusList');
    try {
        // 1. Fetch User Info for Title
        // Optimistically we could use the row data if passed, but fetching ensures freshness
        const userResp = await fetch(`${window.CONTEXT_PATH}/api/users/${userId}`);
        const rawData = await userResp.json();
        let user = safeParse(rawData);
        if (user.user) user = user.user;
        if (user.data) user = user.data;
        
        document.getElementById('assign_user_name').textContent = `For ${user.full_name || user.username}`;
        document.getElementById('assign_user_id').value = userId;
        
        // 2. Load All Menus & User's Menus
        menusList.innerHTML = '<div class="text-center py-4"><div class="spinner-border text-primary"></div></div>';
        
        new bootstrap.Modal(document.getElementById('assignMenusModal')).show();
        
        const [allMenusResp, userMenusResp] = await Promise.all([
            fetch(`${window.CONTEXT_PATH}/api/users/menus`),
            fetch(`${window.CONTEXT_PATH}/api/users/${userId}/menus`)
        ]);
        
        const allMenusRaw = await allMenusResp.json();
        const userMenusRaw = await userMenusResp.json();
        
        // Helper to extract array from various response structures
        const getArray = (data) => {
            const parsed = safeParse(data);
            if (Array.isArray(parsed)) return parsed;
            if (parsed && parsed.data && Array.isArray(parsed.data)) return parsed.data;
            if (parsed && parsed.menus && Array.isArray(parsed.menus)) return parsed.menus;
            if (parsed && parsed.content && Array.isArray(parsed.content)) return parsed.content;
            return [];
        };
        
        const allMenus = getArray(allMenusRaw);
        const userMenus = getArray(userMenusRaw);
        
        // Create Set of IDs for O(1) lookup
        // Handle various ID field names (id, menu_id, menuId)
        const userMenuIds = new Set(userMenus.map(m => String(m.menu_id || m.id || m.menuId)));
        
        // Render Checkboxes
        if (!allMenus || allMenus.length === 0) {
            menusList.innerHTML = '<div class="text-center text-muted">No menus available</div>';
            return;
        }
        
        let html = '';
        allMenus.forEach(menu => {
            const menuId = String(menu.menu_id || menu.id || menu.menuId);
            const menuName = menu.title || menu.menu_name || menu.name || menu.menuName || 'Unknown Menu';
            const isChecked = userMenuIds.has(menuId) ? 'checked' : '';
            
            html += `
                <div class="form-check mb-2">
                    <input class="form-check-input" type="checkbox" value="${menuId}" id="menu_${menuId}" ${isChecked}>
                    <label class="form-check-label" for="menu_${menuId}">
                        ${menuName} <small class="text-muted">(${menu.url || menu.route || '-'})</small>
                    </label>
                </div>
            `;
        });
        menusList.innerHTML = html;
        
    } catch (error) {
        console.error('Error preparing menu assignment:', error);
        if (menusList) {
            menusList.innerHTML = `<div class="text-center text-danger p-3">Error loading menu data: ${error.message}</div>`;
        }
        showToast('Error loading menu data', 'error');
    }
};

window.showUserModal = function() {
    const form = document.getElementById('addUserForm');
    form.reset();
    document.getElementById('user_id').value = '';
    document.getElementById('requestType').value = 'addUser';
    document.getElementById('addUserModalLabel').textContent = 'Add New User';
    
    // Reset Password Requirements
    document.getElementById('password').setAttribute('required', '');
    document.getElementById('confirm_password').setAttribute('required', '');
    document.getElementById('password').placeholder = "Minimum 8 characters";
    
    // Update Button
    const btn = document.getElementById('submitUserForm');
    btn.innerHTML = '<i class="bi bi-plus-circle me-1"></i> Create User';
    
    new bootstrap.Modal(document.getElementById('addUserModal')).show();
};

window.editUser = async function(userId) {
    try {
        const response = await fetch(`${window.CONTEXT_PATH}/api/users/${userId}`);
        const rawData = await response.json();
        let user = safeParse(rawData);
        
        if (user.user) user = user.user;
        if (user.data) user = user.data;
        
        if (!user) throw new Error('User not found');

        // Populate Form
        const form = document.getElementById('addUserForm');
        form.reset();
        
        document.getElementById('user_id').value = user.id || user.user_id;
        document.getElementById('requestType').value = 'updateUser';
        document.getElementById('addUserModalLabel').textContent = 'Edit User';
        
        // Update Button
        const btn = document.getElementById('submitUserForm');
        btn.innerHTML = '<i class="bi bi-check-circle me-1"></i> Update User';
        
        // Remove Password Requirements
        document.getElementById('password').removeAttribute('required');
        document.getElementById('confirm_password').removeAttribute('required');
        document.getElementById('password').placeholder = "Leave blank to keep current";

        // Personal
        document.getElementById('title').value = user.title || '';
        document.getElementById('first_name').value = user.first_name || '';
        document.getElementById('middle_name').value = user.middle_name || '';
        document.getElementById('last_name').value = user.last_name || '';
        document.getElementById('dob').value = user.dob ? user.dob.split('T')[0] : '';
        document.getElementById('gender').value = user.gender || '';
        document.getElementById('country').value = user.country || '';
        document.getElementById('nationality').value = user.nationality || '';
        
        // Account
        document.getElementById('username').value = user.username || '';
        document.getElementById('email').value = user.email || '';
        // document.getElementById('phone_number').value = user.phone_number || ''; // Phone is in permissions tab in HTML? No, it's in Account tab in my read?
        // Let's check HTML structure again. 
        // Ah, phone_number is in Account tab in the HTML I read (lines 392-401).
        // Wait, lines 392-401 are in "Account Information Tab" section?
        // Line 340: <div class="tab-pane fade" id="account" role="tabpanel">
        // ...
        // Line 392: <label for="phone_number" class="form-label">Phone Number</label>
        // Yes.
        
        document.getElementById('phone_number').value = user.phone_number || '';
        document.getElementById('organization').value = user.organization_name || user.org_id || ''; 
        document.getElementById('role').value = user.role || '';
        
        // Security
        document.getElementById('status').value = user.status || 'active';
        document.getElementById('expire_pass').checked = user.expire_pass === true || user.expire_pass === 'true';
        
        // Permissions / Address
        document.getElementById('address').value = user.address || '';
        document.getElementById('city').value = user.city || '';
        document.getElementById('state').value = user.state || '';
        document.getElementById('zip_code').value = user.zip_code || '';

        new bootstrap.Modal(document.getElementById('addUserModal')).show();
        
    } catch (error) {
        console.error('Error loading user for edit:', error);
        showToast('Error loading user details', 'error');
    }
};

window.confirmDeleteUser = function(userId, username) {
    document.getElementById('deleteUserName').textContent = username;
    // Store userId for delete action
    const confirmBtn = document.getElementById('confirmDeleteUser');
    confirmBtn.onclick = () => handleDeleteSubmit(userId);
    new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
};

async function handleDeleteSubmit(userId) {
    // Call delete endpoint
    console.log('Deleting user', userId);
    // ...
}

function renderPagination(data) {
    // Implement pagination rendering based on data.totalPages, etc.
}

function updateStats(data) {
    const users = data.users || data.content || [];
    
    // Initialize counts
    let total = 0;
    let active = 0;
    let inactive = 0;
    let admins = 0;

    // Check if API provides aggregate stats
    if (data.stats) {
        total = data.stats.total || 0;
        active = data.stats.active || 0;
        inactive = data.stats.inactive || 0;
        admins = data.stats.admins || 0;
    } else {
        // Fallback: Calculate from loaded data (current page)
        // Note: This will only reflect the current page's data if server-side pagination is used
        // and no global stats are provided.
        total = data.totalElements || data.total_users || users.length;
        
        users.forEach(user => {
            const status = (user.status || '').toLowerCase();
            const role = (user.role || '').toLowerCase();
            
            if (status === 'active') active++;
            else if (status === 'inactive' || status === 'deactivated' || status === 'suspended') inactive++;
            
            if (role === 'admin' || role === 'administrator' || role === 'super_admin') admins++;
        });
    }

    // Update DOM elements with animation
    animateValue('totalCount', parseInt(document.getElementById('totalCount').textContent) || 0, total);
    animateValue('activeCount', parseInt(document.getElementById('activeCount').textContent) || 0, active);
    animateValue('inactiveCount', parseInt(document.getElementById('inactiveCount').textContent) || 0, inactive);
    animateValue('adminCount', parseInt(document.getElementById('adminCount').textContent) || 0, admins);
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

function handleUserSubmit() {
    const form = document.getElementById('addUserForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());
    
    // Convert boolean/numeric fields if necessary
    
    const btn = document.getElementById('submitUserForm');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';

    fetch(`${window.CONTEXT_PATH}/api/users`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(result => {
        const res = safeParse(result);
        if (res.status === 'error' || (res.code && res.code !== 200)) {
            throw new Error(res.message || 'Failed to save user');
        }
        
        showToast('User saved successfully', 'success');
        bootstrap.Modal.getInstance(document.getElementById('addUserModal')).hide();
        loadUsers();
    })
    .catch(error => {
        console.error('Save error:', error);
        showToast(error.message, 'error');
    })
    .finally(() => {
        btn.disabled = false;
        btn.innerHTML = originalText;
    });
}

function handleAssignMenusSubmit() {
    const userId = document.getElementById('assign_user_id').value;
    const checkboxes = document.querySelectorAll('#menusList input[type="checkbox"]:checked');
    const menuIds = Array.from(checkboxes).map(cb => cb.value);
    
    const btn = document.getElementById('submitAssignMenus');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...';
    
    fetch(`${window.CONTEXT_PATH}/api/users/${userId}/menus`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ menu_ids: menuIds })
    })
    .then(response => response.json())
    .then(result => {
         const res = safeParse(result);
        if (res.status === 'error') throw new Error(res.message);
        
        showToast('Menu assignments updated', 'success');
        bootstrap.Modal.getInstance(document.getElementById('assignMenusModal')).hide();
    })
    .catch(error => {
        console.error('Menu assign error:', error);
        showToast(error.message, 'error');
    })
    .finally(() => {
        btn.disabled = false;
        btn.innerHTML = originalText;
    });
}
