<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
    <div class="container-fluid">

        <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
            <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">User Accounts</h2>
            <div class="flex-shrink-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-end mb-0">
                        <li class="breadcrumb-item"><a href="javascript:void(0)">User Management</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Accounts</li>
                    </ol>
                </nav>
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <div class="row g-3 mb-2">
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body d-flex align-items-center justify-content-between">
                                <div>
                                    <div class="text-muted">All Accounts</div>
                                    <div class="fs-4 fw-semibold" id="totalCount">0</div>
                                </div>
                                <i class="ri-team-line fs-3 text-primary"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body d-flex align-items-center justify-content-between">
                                <div>
                                    <div class="text-muted">Active</div>
                                    <div class="fs-4 fw-semibold text-success" id="activeCount">0</div>
                                </div>
                                <i class="ri-user-smile-line fs-3 text-success"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body d-flex align-items-center justify-content-between">
                                <div>
                                    <div class="text-muted">Deactivated</div>
                                    <div class="fs-4 fw-semibold text-danger" id="inactiveCount">0</div>
                                </div>
                                <i class="ri-user-unfollow-line fs-3 text-danger"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <!-- <h5 class="card-title mb-0"></h5> -->
                        <p class="text-muted mb-4 col-8">Manage your users with this interactive DataTable. View, edit, and assign menu permissions.</p>
                        <button class="btn btn-primary float-end" onclick="showUserModal()"><i class="mdi mdi-account-plus me-2"></i>Add User</button>
                        <div class="mt-3">
                            <ul class="nav nav-pills">
                                <li class="nav-item"><a id="filterAll" class="nav-link active" href="#">All</a></li>
                                <li class="nav-item"><a id="filterActive" class="nav-link" href="#">Active</a></li>
                                <li class="nav-item"><a id="filterInactive" class="nav-link" href="#">Deactivated</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="card-body">
                     <div class="table-responsive">
                        <table id="users-datatable" class="table table-striped dt-responsive w-100">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Role</th>
                                    <th>Created At</th>
                                    <th>Status</th>
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

    </div>

    <!-- Submit Section -->
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    loadOrganizationsForSelect();

    const submitButton = document.getElementById('submitUserForm');
    const addUserForm = document.getElementById('addUserForm');

    window.showUserModal = function(){

        // Change modal title
        document.getElementById('addUserModalLabel').innerHTML = 
            'Add User';

        document.getElementById('addUserForm').dataset.userId = '';
        document.getElementById('addUserForm').dataset.isEdit = 'false';

        // Change submit button text
        // document.getElementById('submitUserForm').textContent = 'Add User';
        document.getElementById('submitUserForm').innerHTML = '<i class="mdi mdi-content-save me-2"></i> Add User';

        // Open the modal
        const modalEl = document.getElementById('addUserModal');
        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
        loadOrganizationsForSelect();
        modal.show();
        // Reset the form
        addUserForm.reset();
    }
    
    // Add event listener to the submit button
    submitButton.addEventListener('click', function(e) {
        e.preventDefault();

        const text = submitButton.textContent;

        Swal.fire({
            title: 'Are you sure?',
            icon: 'warning',
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonText: text == 'Update User' ? 'Yes, Update it' : 'Yes, Save it'
        }).then(function(result) {
            if (result.isConfirmed) {
                handleFormSubmission();
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                Swal.fire("Cancelled", "No action performed.", "error");
            }
        });
    });
    
    // Function to handle form submission
    function handleFormSubmission() {
        // Validate the form
        if (!validateForm()) {
            return;
        }
        
        // Prepare the form data
        const formData = prepareFormData();
        
        // Show loading state
        showLoader("Processing...");
        
        // Submit the data (using fetch API)
        submitFormData(formData)
            .then(response => {
                // console.log(response)
                if(response.message == "SESSION_INVALID") {
                    window.location.href = "login?session=invalid"
                    return;
                }

                if(response.message == 'Missing required fields.') {
                    showNotification(response.message, 'error');
                    return;
                }

                if(response.message == 'Invalid request type.') {
                    showNotification(response.message, 'error');
                    return;
                }

                if(response.success == false) {
                    showNotification(response.message, 'error');
                    return;
                }
                // Handle success
                showNotification(response.message, 'success');
                // Close the modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('addUserModal'));
                modal.hide();
                // Reset the form
                addUserForm.reset();
                // refresh the table
                loadUsersForDataTable();
            })
            .catch(error => {
                // Handle error
                showNotification('Error adding user: ' + error.message, 'error');
            })
            .finally(() => {
                // Reset loading state
                hideLoader()
            });
    }
    
    // Function to validate the form
    function validateForm() {
        let isValid = true;
        const requiredFields = addUserForm.querySelectorAll('[required]');
        
        // Check all required fields
        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                isValid = false;
                highlightError(field, 'This field is required');
            } else {
                removeErrorHighlight(field);
            }
        });
        
        // Validate email format
        const emailField = document.getElementById('email');
        if (emailField.value && !isValidEmail(emailField.value)) {
            isValid = false;
            highlightError(emailField, 'Please enter a valid email address');
        }
        
        // Validate password match
        const passwordField = document.getElementById('password');
        const confirmPasswordField = document.getElementById('confirm_password');
        if (passwordField.value !== confirmPasswordField.value) {
            isValid = false;
            highlightError(confirmPasswordField, 'Passwords do not match');
        }
        
        // Validate phone number
        const phoneField = document.getElementById('phone_number');
        if (phoneField.value && !isValidPhoneNumber(phoneField.value)) {
            isValid = false;
            highlightError(phoneField, 'Please enter a valid phone number');
        }
        
        return isValid;
    }
    
    // Function to prepare form data
    function prepareFormData() {
        // Get security settings
        const twoFactorSms = document.querySelector('.two_factor').checked;
        const twoFactorEmail = document.querySelector('.email_auth').checked;
        const loginNotifications = document.querySelector('.login_notifications').checked;
        
        const el = document.getElementById("addUserForm");
        const isEdit = JSON.parse(el.dataset.isEdit);
        const userId = el.dataset.userId;

        // console.log(typeof isEdit, userId);

        // Prepare the data object
        const formData = {
            // Personal information
            title: document.getElementById('title').value,
            first_name: document.getElementById('first_name').value,
            last_name: document.getElementById('last_name').value,
            middle_name: document.getElementById('middle_name').value,
            dob: document.getElementById('dob').value,
            gender: document.getElementById('gender').value,
            
            // Account information
            username: document.getElementById('username').value,
            email: document.getElementById('email').value,
            password: document.getElementById('password').value,
            role: document.getElementById('role').value,
            level: document.getElementById('level').value,
            
            // Contact information
            country_code: document.getElementById('country_code').value,
            phone_number: document.getElementById('phone_number').value,
            country: document.getElementById('country').value,
            address: document.getElementById('address').value,
            zip_code: document.getElementById('zip_code').value,
            city: document.getElementById('city').value,
            
            // Security settings
            two_factor_auth: twoFactorSms || twoFactorEmail,
            two_factor_method: twoFactorSms ? 'SMS' : (twoFactorEmail ? 'Email' : 'None'),
            login_notification: loginNotifications,
            status: document.getElementById('status').value,
            expire_pass: document.getElementById('expire_pass').checked,
            
            // Additional fields that might be needed
            user_id: isEdit ? userId : '',
            org_id: document.getElementById('org_select').value,
            requestType: isEdit ? 'updateUser' : 'addUser'
        };
        
        return formData;
    }

    function loadOrganizationsForSelect(){
        const select = document.getElementById('org_select');
        if(!select) return;
        fetch('/api/organizations')
          .then(r=>r.text())
          .then(t=>{ let data; try{ data=JSON.parse(t);}catch(_){data=null;} return data; })
          .then(data=>{
              const rows = Array.isArray(data) ? data : (data.organizations || data.data || []);
              const normalized = rows.map(function(row){
                  const id = row.org_id || row.id;
                  const name = row.name || row.org_name || '';
                  const code = row.code || row.org_code || '';
                  return { id, label: code ? (name + ' (' + code + ')') : name };
              }).filter(o=>o.id);
              const cur = select.value;
              select.innerHTML = '<option value="">Select Organization</option>' + normalized.map(o=>('<option value="'+o.id+'">'+o.label+'</option>')).join('');
              if(cur) select.value = cur;
          })
          .catch(()=>{});
    }
    
    // Function to submit form data (using fetch API)
    function submitFormData(formData) {
        return new Promise((resolve, reject) => {
            // Replace with your actual API endpoint
            fetch('/api/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    // Add CSRF token if needed
                    // 'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                },
                body: JSON.stringify(formData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Server returned an error: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                resolve(data);
            })
            .catch(error => {
                reject(error);
            });
        });
    }
    
    // Helper function to validate email format
    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    
    // Helper function to validate phone number
    function isValidPhoneNumber(phone) {
        const phoneRegex = /^[0-9+\-\s()]{10,20}$/;
        return phoneRegex.test(phone);
    }
    
    // Helper function to highlight field with error
    function highlightError(field, message) {
        // Add error class
        field.classList.add('is-invalid');
        
        // Create or update error message
        let errorElement = field.parentNode.querySelector('.invalid-feedback');
        if (!errorElement) {
            errorElement = document.createElement('div');
            errorElement.className = 'invalid-feedback';
            field.parentNode.appendChild(errorElement);
        }
        errorElement.textContent = message;
    }
    
    // Helper function to remove error highlight
    function removeErrorHighlight(field) {
        field.classList.remove('is-invalid');
        const errorElement = field.parentNode.querySelector('.invalid-feedback');
        if (errorElement) {
            errorElement.remove();
        }
    }
    
    // Helper function to generate a unique ID
    function generateUniqueId() {
        // Implement your unique ID generation logic
        return 'user_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }
    
    // Add CSS for error styling
    const style = document.createElement('style');
    style.textContent = `
        .is-invalid {
            border-color: #dc3545 !important;
        }
        .invalid-feedback {
            display: block;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875em;
            color: #dc3545;
        }
    `;
    document.head.appendChild(style);
});

// Helper function to show notification
window.showNotification = function(message, type = 'success') {
    // You can implement a toast notification system here
    Toastify({
        text: message,
        duration: 10000,
        close: true,
        gravity: "top",
        position: "right",
        stopOnFocus: true,
        avatar: type === 'success' ? '../assets/images/notification/ok-48.png' : '../assets/images/notification/high_priority-48.png', // small icon image
        style: {
            background: type === 'success' ? 'linear-gradient(to right, #00b09b, #96c93d)' : 'linear-gradient(to right, #ff5f6d, #ffc371)',
            fontSize: "13px",
        },
    }).showToast();
}

// ---------- CONFIG ----------
const usersApiEndpoint = '/api/users'; // expected: { users: [...] } OR [ ... ] 
// Optional: page-level loader element id (if you want show/hide)
function setLoadingState(isLoading) {
    const tableBody = document.querySelector('#users-datatable tbody');
    if (isLoading) {
        // simple overlay row while loading
        tableBody.innerHTML = `<tr><td colspan="8" class="text-center py-4">Loading users...</td></tr>`;
    }
}

// Format date helper
function formatDateShort(dateString) {
    if (!dateString) return { formattedDate: 'N/A', formattedTime: '' };
    const date = new Date(dateString);
    return {
        formattedDate: date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' }),
        formattedTime: date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })
    };
}

// ---------- DATATABLE INITIALIZATION ----------
let usersTable = null;
let usersData = [];

function initUsersDataTable() {
    // If table exists, destroy it first
    if ($.fn.DataTable.isDataTable('#users-datatable')) {
        $('#users-datatable').DataTable().destroy();
        $('#users-datatable tbody').empty();
    }

    usersTable = new DataTable('#users-datatable', {
        data: [], // will populate after fetch
        columns: [
            { // Name + avatar
                data: null,
                orderable: true,
                render: function (data, type, row) {
                    const name = row.full_name || [row.first_name, row.last_name].filter(Boolean).join(' ').trim() || row.username || 'Unknown';
                    const avatar = row.profile_picture || '../assets/images/users/user-1.png';
                    return `
                        <div class="d-flex align-items-center">
                            <div class="image me-2">
                                <img src="`+avatar+`" alt="`+name+`" class="user-avatar" onerror="this.src='images/avatar/default-user.png'">
                            </div>
                            <div class="f12-medium">`+name+`</div>
                        </div>
                    `;
                }
            },
            { data: 'username', orderable: true },
            { data: 'email', orderable: true },
            { // phone (country_code + phone_number)
                data: null,
                render: function (data, type, row) {
                    const cc = row.country_code || '';
                    const pn = row.phone_number || 'N/A';
                    return cc+` `+pn;
                }
            },
            { data: 'role', render: data => (data || 'user'), className: 'text-center' },
            { // created_at (date + time)
                data: 'created_at',
                render: function (data) {
                    const d = formatDateShort(data);
                    return d.formattedDate+` `+d.formattedTime;
                }
            },
            { // status badge
                data: 'status',
                render: function (data) {
                    const status = (data || 'unknown').toLowerCase();
                    let cls = 'bg-success-subtle text-success';
                    if (status === 'inactive') { cls = 'bg-danger-subtle text-danger'; }
                    else if (status === 'suspended') { cls = 'bg-warning-subtle text-warning';}
                    return `<div class="badge rounded-pill `+cls+`"><span class="font-poppins text-capitalize">`+status+`</span></div>`;
                },
                orderable: false,
                className: 'text-center'
            },
            { // actions
                data: null,
                orderable: false,
                className: 'text-end',
                render: function (data, type, row) {
                    return `
                        <div class="d-flex gap-2 justify-content-end">
                            <button type="button" class="btn btn-light-info icon-btn-sm btn-view" data-user-id="`+row.id+`" data-bs-toggle="tooltip" data-bs-custom-class="tooltip-white" data-bs-placement="top" data-bs-title="View User">
                                <i class="mdi mdi-eye"></i>
                            </button>
                            <button type="button" class="btn btn-light-success icon-btn-sm btn-edit" data-user-id="`+row.id+`" data-bs-toggle="tooltip" data-bs-custom-class="tooltip-white" data-bs-placement="top" data-bs-title="Edit User">
                                <i class="mdi mdi-grease-pencil"></i>
                            </button>
                            <button type="button" class="btn btn-light-danger icon-btn-sm btn-assign-menu" data-user-id="`+row.id+`" data-bs-toggle="tooltip" data-bs-custom-class="tooltip-white" data-bs-placement="top" data-bs-title="Assign Menu">
                                <i class="mdi mdi-format-list-checks"></i>
                            </button>
                            <button type="button" class="btn btn-light-warning icon-btn-sm btn-deactivate" data-user-id="`+row.id+`" data-bs-toggle="tooltip" data-bs-custom-class="tooltip-white" data-bs-placement="top" data-bs-title="Deactivate User">
                                <i class="mdi mdi-account-off"></i>
                            </button>
                        </div>
                    `;
                }
            }
        ],
        dom:
            "<'d-flex align-items-center mb-2'<'btn-left'B><'ms-auto'f>>" + // buttons on left, search on right
            "<'row'<'col-sm-12'tr>>" +
            "<'row mt-2'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'p>>",
        buttons: [
            {
                extend: 'copyHtml5',
                text: '<i class="mdi mdi-content-copy me-1"></i> Copy',
                className: 'btn btn-sm btn-outline-danger me-1',
                titleAttr: 'Copy to clipboard'
            },
            {
                extend: 'csvHtml5',
                text: '<i class="mdi mdi-file-excel me-1"></i> CSV',
                className: 'btn btn-sm btn-outline-success me-1',
                titleAttr: 'Export CSV'
            },
            // {
            //     extend: 'excelHtml5',
            //     text: '<i class="bi bi-file-earmark-excel me-1"></i> Excel',
            //     className: 'btn btn-sm btn-outline-success me-1',
            //     titleAttr: 'Export Excel'
            // },
            // {
            //     extend: 'pdfHtml5',
            //     text: '<i class="bi bi-file-earmark-pdf me-1"></i> PDF',
            //     className: 'btn btn-sm btn-outline-danger me-1',
            //     titleAttr: 'Export PDF',
            //     orientation: 'landscape',
            //     pageSize: 'A4',
            //     exportOptions: { columns: ':visible' }
            // },
            {
                extend: 'print',
                text: '<i class="bi bi-printer me-1"></i> Print',
                className: 'btn btn-sm btn-outline-info me-1',
                titleAttr: 'Print table'
            }
        ]
    });
    $('#users-datatable').on('draw.dt', function(){ updateCountCards(); });
    if (usersTable && typeof usersTable.on === 'function') { usersTable.on('draw', function(){ updateCountCards(); }); }
    const tbody = document.querySelector('#users-datatable tbody');
    if (tbody && !tbody.__observer) {
        const obs = new MutationObserver(() => updateCountCards());
        obs.observe(tbody, { childList: true });
        tbody.__observer = obs;
    }
}

// ---------- FETCH DATA AND POPULATE TABLE ----------
async function loadUsersForDataTable() {
    try {
        //setLoadingState(true);
        const resp = await fetch(usersApiEndpoint, { method: 'GET', headers: { 'Content-Type': 'application/json' } });
        if (!resp.ok) throw new Error('Server returned ' + resp.status);
        const json = await resp.json();
        // Accept either { users: [...] } OR [...]
        const users = Array.isArray(json) ? json : (json.users || json.data || []);
        // Normalize rows if necessary (ensure id present)
        const normalized = users.map(u => {
            return Object.assign({}, u, {
                id: u.id || u.user_id || null
            });
        });
        usersData = normalized;

        // initialize datatable if not exists
        if (!usersTable) initUsersDataTable();

        // load data into datatable (clear -> add -> draw)
        usersTable.clear();
        usersTable.rows.add(normalized);
        usersTable.draw();
        updateCountCards();
        setTimeout(updateCountCards, 0);

    } catch (err) {
        console.error('Error loading users for DataTable:', err);
        // Optionally show user-facing toast
    } finally {
        setLoadingState(false);
    }
}

// ---------- INIT ON DOM READY ----------
$(document).ready(function() {
    // create datatable wrapper
    initUsersDataTable();

    // load data and populate datatable
    loadUsersForDataTable().then(() => {
        addActionListeners();
        addFilterListeners();
    });
});

// Function to set loading state
function setLoadingState(isLoading) {
    const tableBody = document.querySelector('.list-transaction-content tbody');
    
    if (isLoading) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="8" class="text-center py-4">
                    <!--<div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2 text-muted">Loading users...</p>-->
                </td>
            </tr>
        `;
    }
}

// Function to show notification
// function showNotification(message, type = 'info') {
//     // You can implement a toast notification system here
//     console.log(`${type}: ${message}`);
    
//     // Example using Bootstrap toast (if available)
//     if (typeof bootstrap !== 'undefined') {
//         // Create and show a toast notification
//     }
// }

// Add some CSS for the user avatar
const style = document.createElement('style');
style.textContent = `
    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
    }
`;
document.head.appendChild(style);

// Function to add event listeners to action buttons
function addActionListeners() {
    // View button
    document.querySelectorAll('.btn-view').forEach(btn => {
        btn.addEventListener('click', function() {
            const userId = this.getAttribute('data-user-id');
            viewUser(userId);
        });
    });
    
    // Edit button
    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', function() {
            const userId = this.getAttribute('data-user-id');
            editUser(userId);
        });
    });
    
    // Assign menu button
    document.querySelectorAll('.btn-assign-menu').forEach(btn => {
        btn.addEventListener('click', function() {
            const userId = this.getAttribute('data-user-id');
            showAssignMenuModal(userId);
        });
    });

    // Deactivate button
    document.querySelectorAll('.btn-deactivate').forEach(btn => {
        btn.addEventListener('click', function() {
            const userId = this.getAttribute('data-user-id');
            confirmDeactivateUser(userId);
        });
    });
}

// Function to view user details
function viewUser(userId) {
    // console.log('View user:', userId);
    // Fetch user details and show in a view modal
    fetch('/api/users/'+userId)
        .then(response => response.json())
        .then(user => {
            // Create or show view modal with user details
            showUserViewModal(user);
        })
        .catch(error => {
            console.error('Error fetching user details:', error);
            showNotification('Failed to load user details', 'error');
        });
}

function editUser(userId) {
    // console.log('Edit user:', userId);

    $('#viewUserModal').modal('hide');
    
    // Show loading state
    setLoadingState(true, 'Loading user details...');
    
    // Fetch user details and populate the edit form
    fetch('/api/users/' + userId)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Server returned ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            // Extract user object from response
            const user = data.user || data;
            
            // Populate the existing addUserModal for editing
            populateEditForm(user);
            
            // Show the modal
            const modal = new bootstrap.Modal(document.getElementById('addUserModal'));
            modal.show();
            
            // Change modal title
            document.getElementById('addUserModalLabel').innerHTML = 
                'Edit User';
            
            // Change submit button text
            document.getElementById('submitUserForm').innerHTML = 'Update User';

            
            // Store user ID for update
            document.getElementById('addUserForm').dataset.userId = userId;
            document.getElementById('addUserForm').dataset.isEdit = 'true';
            
            // Disable username field for editing
            const usernameField = document.getElementById('username');
            if (usernameField) {
                usernameField.disabled = true;
            }
            
        })
        .catch(error => {
            console.error('Error fetching user details:', error);
            showNotification('Failed to load user details for editing: ' + error.message, 'error');
        })
        .finally(() => {
            setLoadingState(false);
        });
}

    // Function to populate edit form with proper null checking
    function populateEditForm(user) {
    // console.log('Populating form with user:', user);
    
    // Safe function to set value only if element exists
    function setValueIfExists(elementId, value) {
        const element = document.getElementById(elementId);
        if (element) {
            element.value = value || '';
        } else {
            console.warn('Element not found:', elementId);
        }
    }
    
    // Safe function to set checked state
    function setCheckedIfExists(elementId, isChecked) {
        const element = document.getElementById(elementId);
        if (element) {
            element.checked = !!isChecked;
        } else {
            console.warn('Element not found:', elementId);
        }
    }
    
    // Personal Information
    setValueIfExists('title', user.title);
    setValueIfExists('first_name', user.first_name);
    setValueIfExists('last_name', user.last_name);
    setValueIfExists('middle_name', user.middle_name);
    setValueIfExists('dob', user.dob ? formatDateForInput(user.dob) : '');
    setValueIfExists('gender', user.gender);
    
    // Account Information
    setValueIfExists('username', user.username);
    setValueIfExists('email', user.email);
    setValueIfExists('org_select', user.org_id);
    setValueIfExists('role', user.role);
    setValueIfExists('level', user.level);
    
    // Contact Information
    setValueIfExists('country_code', user.country_code || '+233');
    setValueIfExists('phone_number', user.phone_number);
    setValueIfExists('country', user.country || 'Ghana');
    setValueIfExists('address', user.address);
    setValueIfExists('zip_code', user.zip_code || '00233');
    setValueIfExists('city', user.city);
    
    // Security Settings
    setValueIfExists('status', user.status || 'active');
    setCheckedIfExists('expire_pass', user.expire_pass);
    
    // Set security settings - Two Factor Authentication
    const twoFactorSms = document.querySelector('.account-security-item:nth-child(1) .content-item:nth-child(1) .tf-check');
    const twoFactorEmail = document.querySelector('.account-security-item:nth-child(1) .content-item:nth-child(2) .tf-check');
    const loginNotification = document.querySelector('.account-security-item:nth-child(2) .content-item .tf-check');
    
    // Handle two-factor authentication settings
    if (user.two_factor_auth) {
        if (user.two_factor_method === 'SMS' && twoFactorSms) {
            twoFactorSms.checked = true;
            if (twoFactorEmail) twoFactorEmail.checked = false;
        } else if (user.two_factor_method === 'Email' && twoFactorEmail) {
            twoFactorEmail.checked = true;
            if (twoFactorSms) twoFactorSms.checked = false;
        } else if (twoFactorSms && twoFactorEmail) {
            // Default to SMS if method is not specified but 2FA is enabled
            twoFactorSms.checked = true;
            twoFactorEmail.checked = false;
        }
    } else {
        if (twoFactorSms) twoFactorSms.checked = false;
        if (twoFactorEmail) twoFactorEmail.checked = false;
    }
    
    // Handle login notification
    if (loginNotification) {
        loginNotification.checked = user.login_notification || false;
    }
    
    // Remove required attribute from password fields for edit mode
    const passwordField = document.getElementById('password');
    const confirmPasswordField = document.getElementById('confirm_password');
    
    if (passwordField) {
        passwordField.removeAttribute('required');
        passwordField.placeholder = 'Leave blank to keep current password';
    }
    
    if (confirmPasswordField) {
        confirmPasswordField.removeAttribute('required');
        confirmPasswordField.placeholder = 'Leave blank to keep current password';
    }
}

// Helper function to format date for input field (YYYY-MM-DD)
function formatDateForInput(dateString) {
    if (!dateString) return '';
    
    try {
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return '';
        
        return date.toISOString().split('T')[0];
    } catch (e) {
        console.error('Error formatting date:', e);
        return '';
    }
}

// Function to set loading state
function setLoadingState(isLoading, message = 'Loading...') {
    // Create or get loading overlay
    let overlay = document.getElementById('loadingOverlay');
    
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = 'loadingOverlay';
        overlay.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            flex-direction: column;
        `;
        
        overlay.innerHTML = `
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <div class="loading-text mt-2 text-muted f12-medium">${message}</div>
        `;
        
        document.body.appendChild(overlay);
    }
    
    if (isLoading) {
        overlay.style.display = 'flex';
        const loadingText = overlay.querySelector('.loading-text');
        if (loadingText) {
            loadingText.textContent = message;
        }
    } else {
        overlay.style.display = 'none';
    }
}

// Function to show assign menu modal
function showAssignMenuModal(userId) {
    // console.log('Assign menu to user:', userId);
    
    // Show loading state
    // setLoadingState(true, 'Loading menu data...');
    
    // Fetch available menus and user's assigned menus
    Promise.all([
        fetch('/api/users/menus').then(res => res.json()),
        fetch('/api/users/' + userId + '/menus').then(res => res.json())
    ])
    .then(([allMenusResponse, assignedMenusResponse]) => {
        // Extract menus from responses
        const allMenus = allMenusResponse.menus || allMenusResponse;
        const assignedMenus = assignedMenusResponse.menus || assignedMenusResponse;
        
        // Create and show the menu assignment modal
        createMenuAssignmentModal(userId, allMenus, assignedMenus);
    })
    .catch(error => {
        console.error('Error fetching menu data:', error);
        showNotification('Failed to load menu data: ' + error.message, 'error');
    })
    .finally(() => {
        setLoadingState(false);
    });
}

// Function to create menu assignment modal
function createMenuAssignmentModal(userId, allMenus, assignedMenus) {
    // Create modal HTML
    const modalHTML = `
        <div class="modal fade modal-blur" id="assignMenuModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="assignMenuModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-md modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header ps-3">
                        <h5 class="modal-title" id="assignMenuModalLabel">
                            <i class="fas fa-list me-2"></i>Assign Menus to User
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <input type="text" class="form-control bg-Gainsboro" id="menuSearch" placeholder="Search menus...">
                        </div>
                        <div class="menu-list-container" style="max-height: 400px; overflow-y: auto;">
                            <div id="menuTree" class="menu-tree"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="saveMenuAssignments">Save Assignments</button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if it exists
    const existingModal = document.getElementById('assignMenuModal');
    if (existingModal) {
        existingModal.remove();
    }
    
    // Add modal to document
    document.body.insertAdjacentHTML('beforeend', modalHTML);
    
    // Build menu tree
    buildMenuTree(allMenus, assignedMenus);
    
    // Add event listeners
    document.getElementById('saveMenuAssignments').onclick = () => saveMenuAssignments(userId);
    document.getElementById('menuSearch').addEventListener('input', filterMenus);
    
    // Show the modal
    const modal = new bootstrap.Modal(document.getElementById('assignMenuModal'));
    modal.show();
    
    // Clean up when modal is closed
    modal._element.addEventListener('hidden.bs.modal', function() {
        if (document.body.contains(modal._element)) {
            document.body.removeChild(modal._element);
        }
    });
}

// Function to build menu tree
function buildMenuTree(allMenus, assignedMenus) {
    const menuTree = document.getElementById('menuTree');
    menuTree.innerHTML = '';

    // Ensure arrays
    const allMenusArray = Array.isArray(allMenus) ? allMenus : (allMenus.menus || []);
    const assignedMenusArray = Array.isArray(assignedMenus) ? assignedMenus : (assignedMenus.menus || []);

    // Extract assigned menu IDs
    const assignedMenuIds = assignedMenusArray.map(menu => menu.id);

    // Create a map for quick lookup of menus by ID
    const menuById = {};
    allMenusArray.forEach(menu => {
        menuById[menu.id] = menu;
    });

    // Group menus by parent and build hierarchy
    const menuMap = {};
    allMenusArray.forEach(menu => {
        const parentId = menu.parent_id || 'root';
        if (!menuMap[parentId]) {
            menuMap[parentId] = [];
        }
        menuMap[parentId].push(menu);
    });

    // Build tree starting with root level menus
    buildMenuLevel(menuMap, 'root', menuTree, assignedMenuIds, menuById, 0);

    // Add selection listeners after tree is built
    addMenuSelectionListeners(menuMap, menuById);
}

// Recursive function to build menu levels
function buildMenuLevel(menuMap, parentId, container, assignedMenuIds, menuById, level) {
    const menus = menuMap[parentId] || [];
    
    menus.sort((a, b) => (a.position || 0) - (b.position || 0));
    
    menus.forEach(menu => {
        const isAssigned = assignedMenuIds.includes(menu.id);
        const hasChildren = menuMap[menu.id] && menuMap[menu.id].length > 0;
        
        const menuItem = document.createElement('div');
        menuItem.className = 'menu-item-a';
        menuItem.dataset.menuId = menu.id;
        menuItem.dataset.parentId = menu.parent_id || 'root';
        menuItem.style.marginLeft = level * 20 + 'px';
        
        // Determine if parent should be partially checked (some children selected)
        let partialCheck = false;
        if (hasChildren) {
            const childMenuIds = menuMap[menu.id].map(child => child.id);
            const assignedChildren = childMenuIds.filter(id => assignedMenuIds.includes(id));
            partialCheck = assignedChildren.length > 0 && assignedChildren.length < childMenuIds.length;
        }
        
        // menuItem.innerHTML = `
        //     <div class="tf-cart-checkbox mt-2">
        //         <div class="tf-checkbox-wrapp">
        //             <input class="checkbox-item menu-checkbox" type="checkbox" 
        //                 data-menu-id="`+menu.id+`"
        //                 data-parent-id="`+menu.parent_id || 'root'+`"
        //                 `+isAssigned ? 'checked' : ''+`
        //                 `+partialCheck ? 'data-partial="true"' : ''+`
        //                 `+hasChildren ? 'data-has-children="true"' : ''+`>
        //             <div>
        //                 <i class="icon-check"></i>
        //             </div>
        //         </div>
        //         <div class="f12-medium text-break d-flex align-items-center">
        //             `+menu.icon ? `<i class="`+menu.icon+` me-2"></i>` : ''+`
        //             `+menu.title+`
        //         </div>
        //     </div>
        // `;

        menuItem.innerHTML = `
            <div class="form-check d-flex align-items-center mb-2">
                <input class="form-check-input menu-checkbox me-2" type="checkbox"
                    data-menu-id="`+menu.id+`"
                    data-parent-id="`+menu.parent_id+`"
                    `+(isAssigned ? 'checked' : '')+`
                    `+(partialCheck ? 'data-partial="true"' : '')+`
                    `+(hasChildren ? 'data-has-children="true"' : '')+`>
        
                <label class="form-check-label d-flex align-items-center text-break w-100">
                `+(menu.icon ? `<span class="me-2"><i class="`+menu.icon+` pe-nav-icon"></i></span>` : '')+`
                <span>`+menu.title+`</span>
                </label>
            </div>
            `;
        
        container.appendChild(menuItem);
        
        // Recursively build child menus
        if (hasChildren) {
            buildMenuLevel(menuMap, menu.id, container, assignedMenuIds, menuById, level + 1);
        }
    });
}

// Function to add menu selection listeners
function addMenuSelectionListeners(menuMap, menuById) {
    // Handle parent checkbox changes (check/uncheck all children)
    document.querySelectorAll('.menu-checkbox[data-has-children="true"]').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const menuId = parseInt(this.dataset.menuId);
            const isChecked = this.checked;
            
            // Check/uncheck all children recursively
            checkAllChildren(menuId, isChecked, menuMap);
            
            // Update parent states
            updateParentCheckboxStates(this);
        });
    });
    
    // Handle child checkbox changes (update parent state)
    document.querySelectorAll('.menu-checkbox:not([data-has-children="true"])').forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            updateParentCheckboxStates(this);
        });
    });
    
    // Initialize parent checkbox states
    document.querySelectorAll('.menu-checkbox[data-has-children="true"]').forEach(checkbox => {
        updateParentCheckboxStates(checkbox);
    });
}

// Function to check/uncheck all children recursively
function checkAllChildren(parentId, isChecked, menuMap) {
    const children = menuMap[parentId] || [];
    
    children.forEach(child => {
        const childCheckbox = document.querySelector(`.menu-checkbox[data-menu-id="${child.id}"]`);
        if (childCheckbox) {
            childCheckbox.checked = isChecked;
            
            // Recursively check children of this child
            if (childCheckbox.dataset.hasChildren === 'true') {
                checkAllChildren(child.id, isChecked, menuMap);
            }
        }
    });
}

// Function to update parent checkbox states based on children
function updateParentCheckboxStates(checkboxElement) {
    const menuId = parseInt(checkboxElement.dataset.menuId);
    const parentId = checkboxElement.dataset.parentId;
    
    if (parentId === 'root') return;
    
    const parentCheckbox = document.querySelector(`.menu-checkbox[data-menu-id="`+parentId+`"]`);
    if (!parentCheckbox) return;
    
    const children = document.querySelectorAll(`.menu-item-a[data-parent-id="`+parentId+`"] .menu-checkbox`);
    const checkedChildren = Array.from(children).filter(cb => cb.checked);
    const partialChildren = Array.from(children).filter(cb => cb.dataset.partial === 'true');
    
    // Remove partial state
    parentCheckbox.removeAttribute('data-partial');
    
    if (checkedChildren.length === 0) {
        // No children checked
        parentCheckbox.checked = false;
    } else if (checkedChildren.length === children.length && partialChildren.length === 0) {
        // All children checked
        parentCheckbox.checked = true;
    } else {
        // Some children checked - set partial state
        parentCheckbox.checked = true;
        parentCheckbox.dataset.partial = 'true';
    }
    
    // Recursively update grandparents
    updateParentCheckboxStates(parentCheckbox);
}

// Function to filter menus
function filterMenus() {
    const searchTerm = document.getElementById('menuSearch').value.toLowerCase();
    const menuItems = document.querySelectorAll('.menu-item-a');
    
    if (!searchTerm) {
        // Show all items if no search term
        menuItems.forEach(item => {
            item.style.display = 'block';
            // Show all parents
            let parent = item.closest('.menu-item-a');
            while (parent) {
                parent.style.display = 'block';
                parent = parent.parentElement.closest('.menu-item-a');
            }
        });
        return;
    }
    
    menuItems.forEach(item => {
        const text = item.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            item.style.display = 'block';
            
            // Show all parents of matching items
            let parent = item.parentElement;
            while (parent && parent.classList.contains('menu-item-a')) {
                parent.style.display = 'block';
                parent = parent.parentElement.closest('.menu-item-a');
            }
        } else {
            // Check if any children match
            const children = item.querySelectorAll('.menu-item-a');
            const hasMatchingChild = Array.from(children).some(child => 
                child.textContent.toLowerCase().includes(searchTerm)
            );
            
            item.style.display = hasMatchingChild ? 'block' : 'none';
        }
    });
}

// Function to save menu assignments
function saveMenuAssignments(userId) {
    const selectedMenus = [];

    // Get all checked checkboxes (excluding partially checked parents)
    document.querySelectorAll('.menu-checkbox:checked:not([data-partial="true"])').forEach(checkbox => {
        selectedMenus.push(parseInt(checkbox.dataset.menuId));
    });

    // Ask for confirmation before saving
    Swal.fire({
        title: 'Are you sure?',
        text: 'Do you want to save these menu assignments?',
        icon: 'warning',
        showCancelButton: true,
        // confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, Save',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            // Show loading state
            showLoader("Processing...");

            // Send assignment data to server
            fetch('/api/users/' + userId + '/menus', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    menu_ids: selectedMenus
                })
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`Server returned ` + response.status);
                }
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                     showNotification('Menu assignments saved successfully!', 'success');
            
                    // Close the modal
                    const modal = bootstrap.Modal.getInstance(document.getElementById('assignMenuModal'));
                    modal.hide();
                } else {
                    throw new Error(data.message || 'Failed to save assignments');
                }
            })
            .catch(error => {
                console.error('Error saving menu assignments:', error);
                Swal.fire('Error', 'Failed to save menu assignments: ' + error.message, 'error');
            })
            .finally(() => {
                hideLoader();
            });
        } else if (result.dismiss === Swal.DismissReason.cancel) {
            Swal.fire("Cancelled", "No action performed.", "error");
        }
    });
}

// Function to show user view modal
function showUserViewModal(user) {
    // Precompute safe fields
    const profilePicture = user.profile_picture || '../assets/images/users/user-1.png';
    const fullName = user.full_name || (user.first_name || '') + ' ' + (user.last_name || '');
    const role = user.role || 'No role assigned';
    const username = user.username || 'N/A';
    const email = user.email || 'N/A';
    const phone = (user.country_code || '') + ' ' + (user.phone_number || 'N/A');
    const title = user.title || 'N/A';
    const gender = user.gender || 'N/A';
    const dob = user.dob ? new Date(user.dob).toLocaleDateString() : 'N/A';
    const status = user.status || 'unknown';
    const statusClass = status === 'active' ? 'success' : status === 'inactive' ? 'secondary' : 'warning';
    const level = user.level || 'N/A';
    const joined = user.created_at ? new Date(user.created_at).toLocaleDateString() : 'N/A';
    const updated = user.updated_at ? new Date(user.updated_at).toLocaleDateString() : 'N/A';
    const nationality = user.nationality || 'N/A';
    const address = user.address || 'N/A';
    const city = user.city || 'N/A';
    const country = user.country || 'N/A';
    const zip_code = user.zip_code || 'N/A';
    const two_factor_auth = user.two_factor_auth ? 'Enabled' : 'Disabled';
    const login_notification = user.login_notification ? 'Enabled' : 'Disabled';
    const login_approval = user.login_approval ? 'Enabled' : 'Disabled';
    const expire_pass = user.expire_pass ? 'Yes (90 days)' : 'No';
    const two_factor_method = user.two_factor_method || 'N/A';

    // Build modal HTML with precomputed values
    const modalHTML = `
            <div class="modal fade modal-blur" id="viewUserModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="viewUserModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content shadow-lg rounded-4">
                    <div class="modal-header py-3">
                    <h5 class="modal-title fw-semibold" id="viewUserModalLabel">
                        <i class="fas fa-user-circle me-2"></i> User Details
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                    <div class="row g-4">
                        <div class="col-md-4 text-center">
                        <div class="p-3 bg-light rounded-4 shadow-none">
                            <img src="`+profilePicture+`" alt="`+fullName+`" class="rounded-circle profile-img border border-3 shadow-none mb-3" onerror="this.src='images/users/user-1.png'">
                            <h5 class="fw-bold mb-1">`+fullName+`</h5>
                            <p class="text-muted mb-0">`+role+`</p>
                        </div>
                        </div>
                        <div class="col-md-8">
                        <div class="mb-4">
                            <h6 class="fw-bold text-primary mb-2"><i class="bi bi-person-badge me-1"></i> Account Information</h6>
                            <div class="card shadow-none rounded-3">
                            <div class="card-body p-3">
                                <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-2"><strong>Username:</strong> <span class="text-muted float-end">`+username+`</span></p>
                                    <p class="mb-2"><strong>Email:</strong> <span class="text-muted float-end">`+email+`</span></p>
                                    <p class="mb-2"><strong>Phone:</strong> <span class="text-muted float-end">`+phone+`</span></p>
                                    <p class="mb-2"><strong>Title:</strong> <span class="text-muted float-end">`+title+`</span></p>
                                    <p class="mb-2"><strong>Gender:</strong> <span class="text-muted float-end">`+gender+`</span></p>
                                    <p class="mb-0"><strong>Date of Birth:</strong> <span class="text-muted float-end">`+dob+`</span></p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-2"><strong>Status:</strong> <span class="badge bg-`+statusClass+` float-end">`+status+`</span></p>
                                    <p class="mb-2"><strong>Level:</strong> <span class="text-muted float-end">`+level+`</span></p>
                                    <p class="mb-2"><strong>Joined:</strong> <span class="text-muted float-end">`+joined+`</span></p>
                                    <p class="mb-2"><strong>Last Updated:</strong> <span class="text-muted float-end">`+updated+`</span></p>
                                    <p class="mb-0"><strong>Nationality:</strong> <span class="text-muted float-end">`+nationality+`</span></p>
                                </div>
                                </div>
                            </div>
                            </div>
                        </div>
                        <div class="mb-4">
                            <h6 class="fw-bold text-primary mb-2"><i class="bi bi-geo-alt me-1"></i> Address Information</h6>
                            <div class="card shadow-none rounded-3">
                            <div class="card-body p-3">
                                <p class="mb-2"><strong>Address:</strong> <span class="text-muted float-end">`+address+`</span></p>
                                <p class="mb-2"><strong>City:</strong> <span class="text-muted float-end">`+city+`</span></p>
                                <p class="mb-2"><strong>Country:</strong> <span class="text-muted float-end">`+country+`</span></p>
                                <p class="mb-0"><strong>Zip Code:</strong> <span class="text-muted float-end">`+zip_code+`</span></p>
                            </div>
                            </div>
                        </div>
                        <div>
                            <h6 class="fw-bold text-primary mb-2"><i class="bi bi-shield-lock me-1"></i> Security Settings</h6>
                            <div class="card shadow-none rounded-3">
                            <div class="card-body p-3">
                                <p class="mb-2"><strong>Two-Factor Auth:</strong> <span class="text-muted float-end">`+two_factor_auth+`</span></p>
                                <p class="mb-2"><strong>Login Notifications:</strong> <span class="text-muted float-end">`+login_notification+`</span></p>
                                <p class="mb-2"><strong>Login Approval:</strong> <span class="text-muted float-end">`+login_approval+`</span></p>
                                <p class="mb-0"><strong>Password Expires:</strong> <span class="text-muted float-end">`+expire_pass+`</span></p>
                            </div>
                            </div>
                        </div>
                        </div>
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="editUser(`+user.id+`)">Edit User</button>
                    </div>
                </div>
                </div>
            </div>
            `;
    
   // Remove old modal if it exists
    const existingModal = document.getElementById('viewUserModal');
    if (existingModal) {
        existingModal.remove();
    }

    // Create a temporary container to parse the HTML
    const tempContainer = document.createElement('div');
    tempContainer.innerHTML = modalHTML;
    const modalElement = tempContainer.firstElementChild;
    
    // Add the modal to the DOM
    document.body.appendChild(modalElement);
    
    // Initialize and show the modal after a slight delay to ensure DOM is ready
    setTimeout(() => {
        try {
            const modal = new bootstrap.Modal(document.getElementById('viewUserModal'));
            modal.show();
            
            // Add event listener to remove modal from DOM when hidden
            modalElement.addEventListener('hidden.bs.modal', function () {
                if (document.body.contains(modalElement)) {
                    document.body.removeChild(modalElement);
                }
            });
        } catch (error) {
            console.error('Error showing modal:', error);
        }
    }, 50);
}

// Add CSS for menu tree and partial check states
const menuStyles = `
    <style>
        .menu-tree {
            padding: 10px;
        }
        .menu-item-a {
            margin-bottom: 5px;
            padding: 5px;
            border-radius: 4px;
        }
        .menu-item-a:hover {
            background-color: #f8f9fa;
        }
        .menu-checkbox {
            margin-right: 8px;
        }
        .menu-checkbox[data-partial="true"] {
            opacity: 0.7;
        }
        .tf-checkbox-wrapp {
            position: relative;
        }
        .form-check-label {
            cursor: pointer;
        }
    </style>
`;

// Add styles to document if not already added
if (!document.getElementById('menu-styles')) {
    const styleElement = document.createElement('style');
    styleElement.id = 'menu-styles';
    styleElement.textContent = menuStyles;
    document.head.appendChild(styleElement);
}
</script>
async function confirmDeactivateUser(userId) {
    const result = await Swal.fire({
        title: 'Deactivate this user?',
        text: 'They will no longer be able to log in.',
        icon: 'warning',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, deactivate'
    });
    if (!result.isConfirmed) return;

    try {
        const resp = await fetch('/api/users/' + userId + '/deactivate', { method: 'POST' });
        const text = await resp.text();
        let data; try { data = JSON.parse(text); } catch(_) { data = { status:'error', message:text }; }
        if (resp.ok) {
            showNotification((data.message || 'User deactivated'), 'success');
            loadUsersForDataTable();
        } else {
            showNotification((data.message || data.error || 'Failed to deactivate'), 'error');
        }
    } catch (e) {
        console.error(e);
        showNotification('Error deactivating user: ' + e.message, 'error');
    }
}
function updateCountCards() {
    let visible = [];
    try {
        if (window.jQuery && $.fn.dataTable && $.fn.dataTable.isDataTable('#users-datatable')) {
            visible = $('#users-datatable').DataTable().rows({ search: 'applied' }).data().toArray();
        } else if (usersTable && typeof usersTable.rows === 'function') {
            const d = usersTable.rows({ search: 'applied' }).data();
            visible = Array.isArray(d) ? d : (typeof d.toArray === 'function' ? d.toArray() : []);
        }
    } catch(_){ }
    if (!Array.isArray(visible) || visible.length===0) {
        const domRows = Array.from(document.querySelectorAll('#users-datatable tbody tr'));
        visible = domRows.map(function(tr){ const tds = tr.querySelectorAll('td'); const statusTd = tds[6]; const s = statusTd ? statusTd.textContent.trim().toLowerCase() : ''; return { status: s }; });
        if (visible.length===0) visible = usersData;
    }
    const normStatus = (s, row) => {
        let val = s ? String(s).toLowerCase() : 'unknown';
        if (val === 'unknown' && row && typeof row.is_active !== 'undefined') {
            val = (row.is_active === true || String(row.is_active).toLowerCase()==='true') ? 'active' : 'inactive';
        }
        if (val === 'deactivated' || val === 'blocked' || val === 'inactive') return 'inactive';
        if (val === 'active') return 'active';
        return 'unknown';
    };
    const total = visible.length;
    const active = visible.filter(u => normStatus(u.status, u) === 'active').length;
    const inactive = visible.filter(u => normStatus(u.status, u) === 'inactive').length;
    const totalEl = document.getElementById('totalCount');
    const activeEl = document.getElementById('activeCount');
    const inactiveEl = document.getElementById('inactiveCount');
    if (totalEl) totalEl.textContent = total;
    if (activeEl) activeEl.textContent = active;
    if (inactiveEl) inactiveEl.textContent = inactive;
}

function addFilterListeners() {
    const all = document.getElementById('filterAll');
    const act = document.getElementById('filterActive');
    const ina = document.getElementById('filterInactive');
    function setActive(el) {
        [all, act, ina].forEach(a => a && a.classList.remove('active'));
        el && el.classList.add('active');
    }
    if (all) all.addEventListener('click', function(e){ e.preventDefault(); usersTable.column(6).search('').draw(); setActive(all); });
    if (act) act.addEventListener('click', function(e){ e.preventDefault(); usersTable.column(6).search('^active$', true, false).draw(); setActive(act); });
    if (ina) ina.addEventListener('click', function(e){ e.preventDefault(); usersTable.column(6).search('^inactive$', true, false).draw(); setActive(ina); });
}
