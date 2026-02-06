<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
    <div class="container-fluid">

        <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
            <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Manage Appointments</h2>
            <div class="flex-shrink-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-end mb-0">
                        <li class="breadcrumb-item"><a href="javascript:void(0)">Appointments</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Manage Appointments</li>
                    </ol>
                </nav>
            </div>
        </div>

            <div class="row mb-3">
                <div class="col-12">
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#creatappointmentModal">
                            <i class="bi bi-calendar-check"></i> Schedule Appointment
                        </button>
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#batchSlotsModal">
                            <i class="bi bi-person-plus"></i> Create Account
                        </button>
                    </div>
                </div>
            </div>



        <div class="row">
            <div class="col-12">
                 <div class="card">
                    <div class="card-header">
                        <!-- <h5 class="card-title mb-0"></h5> -->
                            <p class="text-muted mb-4 col-8">
                                Manage appointments with this interactive DataTable. View, schedule, update, or cancel client bookings easily.
                            </p>                    </div>
                    <div class="card-body">
                     <div class="table-responsive">
                        <table id="appointments-datatable" class="table table-striped dt-responsive w-100">
                            <thead>
                                <tr>
                                <th>Client</th>
                                <th>Appointment Type</th>
                                <th>Time Slot</th>
                                <th>Status</th>
                                <th>Created Date</th>
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
                loadappointmentsForDataTable();
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
            requestType: isEdit ? 'updateUser' : 'addUser'
        };
        
        return formData;
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
const appointmentApiEndpoint = '/api/appointments/all-appointments'; // expected: { users: [...] } OR [ ... ] 
// Optional: page-level loader element id (if you want show/hide)
function setLoadingState(isLoading) {
    const tableBody = document.querySelector('#appointments-datatable tbody');
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
let appointmentTable = null;

function initAppointmentsDataTable() {
    // If table exists, destroy it first
    if ($.fn.DataTable.isDataTable('#appointments-datatable')) {
        $('#appointments-datatable').DataTable().destroy();
        $('#appointments-datatable tbody').empty();
    }

    appointmentTable = new DataTable('#appointments-datatable', {
        data: [], // will populate after fetch
        columns: [
            { data: 'client_id', orderable: true },
            { data: 'appointment_type_name', orderable: true },
            {
            data: 'start_time',
            render: function (data, type, row) {
                if (!data) return '';
                const d = formatDateShort(data);
                return d.formattedDate + ' ' + d.formattedTime;
            }
            },
            { data: 'status', orderable: true },
             {
            data: 'created_at',
            render: function (data, type, row) {
                if (!data) return '';
                const d = formatDateShort(data);
                return d.formattedDate;
            }
            },
            { // actions
                data: null,
                orderable: false,
                className: 'text-end',
                render: function (data, type, row) {
                    return `
                        <div class="d-flex gap-2 justify-content-end">
                            <button type="button" class="btn btn-light-info icon-btn-sm btn-view" data-appointment-id="`+row.id+`" data-bs-toggle="tooltip" data-bs-custom-class="tooltip-white" data-bs-placement="top" data-bs-title="View Appointment">
                                <i class="mdi mdi-eye"></i>
                            </button>
                            <button type="button" class="btn btn-light-success icon-btn-sm btn-edit" data-appointment-id="`+row.id+`" data-bs-toggle="tooltip" data-bs-custom-class="tooltip-white" data-bs-placement="top" data-bs-title="Edit Appointment">
                                <i class="mdi mdi-grease-pencil"></i>
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
}

// ---------- FETCH DATA AND POPULATE TABLE ----------
async function loadappointmentsForDataTable() {
    try {
        //setLoadingState(true);
        const resp = await fetch(appointmentApiEndpoint, { method: 'GET', headers: { 'Content-Type': 'application/json' } });
        if (!resp.ok) throw new Error('Server returned ' + resp.status);
        const json = await resp.json();
        // console.log(json);
        // Accept either { users: [...] } OR [...]
        const users = Array.isArray(json) ? json : (json.users || json.data || []);
        // Normalize rows if necessary (ensure id present)
        const normalized = users.map(u => {
            return Object.assign({}, u, {
                id: u.id || u.user_id || null
            });
        });

        // initialize datatable if not exists
        if (!appointmentTable) initAppointmentsDataTable();

        // load data into datatable (clear -> add -> draw)
        appointmentTable.clear();
        appointmentTable.rows.add(normalized);
        appointmentTable.draw();

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
    initAppointmentsDataTable();

    // load data and populate datatable
    loadappointmentsForDataTable().then(() => {
        addActionListeners();
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
            const appointmentId = this.getAttribute('data-appointment-id');
            viewAppointment(appointmentId);
        });
    });
    
    // Edit button
    document.querySelectorAll('.btn-edit').forEach(btn => {
        btn.addEventListener('click', function() {
             const appointmentId = this.getAttribute('data-appointment-id');
            rescheduleAppointment(appointmentId);
        });
    });
    
    // Assign menu button
    document.querySelectorAll('.btn-assign-menu').forEach(btn => {
        btn.addEventListener('click', function() {
            const userId = this.getAttribute('data-user-id');
            showAssignMenuModal(userId);
        });
    });
}

// Function to view user details
function viewAppointment(appointmentId) {
    console.log('View Appointment:', appointmentId);
    // Fetch user details and show in a view modal
    fetch('/api/appointments/'+appointmentId)
        .then(response => response.json())
        .then(appointment => {

        console.log('Appointment response (parsed):', appointment);
            // Create or show view modal with user details
            showAppointmentViewModal(appointment);
        })
        .catch(error => {
            console.error('Error fetching user details:', error);
            showNotification('Failed to load user details', 'error');
        });
}



// View Appointment Details Modal

function showAppointmentViewModal(appointment) {
    // Precompute safe fields
    const clientName = appointment.client_name || 'Unknown Client';
    const appointmentType = appointment.appointment_type || 'N/A';
    console.log(appointmentType)
    const status = appointment.status || 'pending';
    const statusClass = status === 'confirmed' ? 'success' : status === 'pending' ? 'warning' : 'secondary';
    const startTime = appointment.start_time ? new Date(appointment.start_time).toLocaleString() : 'N/A';
    const endTime = appointment.end_time ? new Date(appointment.end_time).toLocaleString() : 'N/A';
    const createdAt = appointment.created_at ? new Date(appointment.created_at).toLocaleString() : 'N/A';
    const updatedAt = appointment.updated_at ? new Date(appointment.updated_at).toLocaleString() : 'N/A';
    const notes = appointment.notes || 'No notes added';
    const staff = appointment.staff_name || 'Unassigned';

    // Build modal HTML
    const modalHTML = `
        <div class="modal fade modal-blur" id="viewAppointmentModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="viewAppointmentModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content shadow-lg rounded-4 border-0">
                    <div class="modal-header py-3 bg-light border-bottom-0 rounded-top-4">
                        <h5 class="modal-title fw-semibold" id="viewAppointmentModalLabel">
                            <i class="bi bi-calendar-check me-2 text-primary"></i> Appointment Details
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary mb-2"><i class="bi bi-person me-1"></i> Client Information</h6>
                                <div class="card shadow-none rounded-3">
                                    <div class="card-body p-3">
                                        <p class="mb-2"><strong>Client:</strong> <span class="text-muted float-end" id="clientName"></span></p>
                                        <p class="mb-2"><strong>Appointment Type:</strong> <span class="text-muted float-end" id="appointmentType"></span></p>
                                        <p class="mb-2"><strong>Status:</strong> <span class="badge float-end" id="appointmentStatus"></span></p>
                                        <p class="mb-0"><strong>Assigned Staff:</strong> <span class="text-muted float-end" id="staffName"></span></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="fw-bold text-primary mb-2"><i class="bi bi-clock me-1"></i> Timing</h6>
                                <div class="card shadow-none rounded-3">
                                    <div class="card-body p-3">
                                        <p class="mb-2"><strong>Start Time:</strong> <span class="text-muted float-end" id="start_Time"></span></p>
                                        <p class="mb-2"><strong>End Time:</strong> <span class="text-muted float-end" id="end_Time"></span></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12">
                                <h6 class="fw-bold text-primary mb-2"><i class="bi bi-journal-text me-1"></i> Notes</h6>
                                <div class="card shadow-none rounded-3">
                                    <div class="card-body p-3">
                                        <p class="mb-0 text-muted" id="notes"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><i class="mdi mdi-close me-2"></i> Close</button>
                        <button type="button" class="btn btn-primary" id="editBtn">
                            <i class="bi bi-arrow-repeat me-1"></i> Reschedule Appointment
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;

      // Remove old modal if exists
    const existingModal = document.getElementById('viewAppointmentModal');
    if (existingModal) existingModal.remove();

    // Insert modal into DOM
    const tempContainer = document.createElement('div');
    tempContainer.innerHTML = modalHTML;
    const modalElement = tempContainer.firstElementChild;
    document.body.appendChild(modalElement);

    // Fill in appointment details by ID
    document.getElementById('clientName').textContent = appointment.client_name || 'Unknown Client';
    document.getElementById('appointmentType').textContent = appointment.appointment_type || 'N/A';

    // const status = appointment.status || 'pending';
    // const statusClass = status === 'confirmed' ? 'success' : status === 'pending' ? 'warning' : 'secondary';
    const statusElement = document.getElementById('appointmentStatus');
    statusElement.textContent = status;
    statusElement.classList.add('bg-' + statusClass);

    document.getElementById('staffName').textContent = appointment.staff_name || 'Unassigned';
    // document.getElementById('start_Time').textContent = appointment.staff_name || 'Unassigned';

    document.getElementById('start_Time').textContent = appointment.start_time ? new Date(appointment.start_time).toLocaleString() : 'N/A';
    document.getElementById('end_Time').textContent = appointment.end_time ? new Date(appointment.end_time).toLocaleString() : 'N/A';
    document.getElementById('notes').textContent = appointment.notes || 'No notes added';

    // Add click for Edit button
    document.getElementById('editBtn').onclick = () => editAppointment(appointment.id);

    // Initialize and show
    setTimeout(() => {
        const modal = new bootstrap.Modal(document.getElementById('viewAppointmentModal'));
        modal.show();

        modalElement.addEventListener('hidden.bs.modal', function () {
            if (document.body.contains(modalElement)) {
                document.body.removeChild(modalElement);
            }
        });
    }, 50)
}

function rescheduleAppointment(appointmentId) {
    console.log('View Appointment:', appointmentId);
    // Fetch user details and show in a view modal
    fetch('/api/appointments/'+appointmentId)
        .then(response => response.json())
        .then(appointment => {

        console.log('Appointment response (parsed):', appointment);
            // Create or show view modal with user details
            showAppointmentRescheduleModal(appointment);
        })
        .catch(error => {
            console.error('Error fetching user details:', error);
            showNotification('Failed to load user details', 'error');
        });
}

// View Appointment Details Modal

function rescheduleAppointment(appointment) {
    // Precompute safe fields
    const clientName = appointment.client_name || 'Unknown Client';
    const appointmentType = appointment.appointment_type || 'N/A';
    console.log(appointmentType)
    const status = appointment.status || 'pending';
    const statusClass = status === 'confirmed' ? 'success' : status === 'pending' ? 'warning' : 'secondary';
    const startTime = appointment.start_time ? new Date(appointment.start_time).toLocaleString() : 'N/A';
    const endTime = appointment.end_time ? new Date(appointment.end_time).toLocaleString() : 'N/A';
    const createdAt = appointment.created_at ? new Date(appointment.created_at).toLocaleString() : 'N/A';
    const updatedAt = appointment.updated_at ? new Date(appointment.updated_at).toLocaleString() : 'N/A';
    const notes = appointment.notes || 'No notes added';
    const staff = appointment.staff_name || 'Unassigned';

    // Build modal HTML
    const modalHTML = `
        <div class="modal fade modal-blur" id="createSlotModal" tabindex="-1" aria-labelledby="createSlotModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg rounded-4 border-0">
            <div class="modal-header">
                <h5 class="modal-title" id="createSlotModalLabel">Reschedule Appointment</h5>
                <button type="button" class="btn-close " data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="createSlotForm">
                    <div class="mb-3">
                        <label for="slotDate" class="form-label">Date <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" id="slotDate" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="startTime" class="form-label">Start Time <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" id="startTime" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="endTime" class="form-label">End Time <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" id="endTime" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="slotType" class="form-label">Appointment Type</label>
                        <select class="form-select" id="slotType">
                            <option value="">-- Select Type --</option>
                            <c:forEach var="type" items="${appointmentTypes}">
                                <option value="${type.id}">${type.name} (${type.duration_minutes} mins)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="maxCapacity" class="form-label">Maximum Capacity</label>
                        <input type="number" class="form-control" id="maxCapacity" min="1" value="1">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="createSlotBtn">Create Slot</button>
            </div>
        </div>
    </div>
</div
    `;

      // Remove old modal if exists
    const existingModal = document.getElementById('viewAppointmentModal');
    if (existingModal) existingModal.remove();

    // Insert modal into DOM
    const tempContainer = document.createElement('div');
    tempContainer.innerHTML = modalHTML;
    const modalElement = tempContainer.firstElementChild;
    document.body.appendChild(modalElement);

    // Fill in appointment details by ID
    // document.getElementById('clientName').textContent = appointment.client_name || 'Unknown Client';
    // document.getElementById('appointmentType').textContent = appointment.appointment_type || 'N/A';

    // // const status = appointment.status || 'pending';
    // // const statusClass = status === 'confirmed' ? 'success' : status === 'pending' ? 'warning' : 'secondary';
    // const statusElement = document.getElementById('appointmentStatus');
    // statusElement.textContent = status;
    // statusElement.classList.add('bg-' + statusClass);

    // document.getElementById('staffName').textContent = appointment.staff_name || 'Unassigned';
    // // document.getElementById('start_Time').textContent = appointment.staff_name || 'Unassigned';

    // document.getElementById('start_Time').textContent = appointment.start_time ? new Date(appointment.start_time).toLocaleString() : 'N/A';
    // document.getElementById('end_Time').textContent = appointment.end_time ? new Date(appointment.end_time).toLocaleString() : 'N/A';
    // document.getElementById('notes').textContent = appointment.notes || 'No notes added';

    // Add click for Edit button
    // document.getElementById('editBtn').onclick = () => editAppointment(appointment.id);

    // Initialize and show
    setTimeout(() => {
        const modal = new bootstrap.Modal(document.getElementById('createSlotModal'));
        modal.show();

        modalElement.addEventListener('hidden.bs.modal', function () {
            if (document.body.contains(modalElement)) {
                document.body.removeChild(modalElement);
            }
        });
    }, 50)
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


</script>
<script>
document.addEventListener('DOMContentLoaded', function() {

    const calendarEl = document.getElementById('calendar');
    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'timeGridWeek',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
        },
        events: '/api/appointments/slots',
        editable: true,
        // selectable: true,
        selectMirror: true,
        dayMaxEvents: true,
        validRange: {
            start: new Date() // prevents selection before today
        },
        // select: function(info) {
        //     $('#createSlotModal').modal('show');
        //     $('#slotDate').val(info.startStr.substring(0, 10));
        //     $('#startTime').val(info.startStr.substring(11, 16));
        //     $('#endTime').val(info.endStr.substring(11, 16));
        // },
        eventClick: function(info) {
            scheduleAppointment(info.event);
        }
    });
    calendar.render();

    
    // 🔥 Refresh calendar when modal is shown
    $('#creatappointmentModal').on('shown.bs.modal', function () {
        if (calendar) {
            calendar.updateSize();
        }
    })
    // Navigation controls
    document.getElementById('todayBtn').addEventListener('click', function() {
        calendar.today();
    });
    
    document.getElementById('prevBtn').addEventListener('click', function() {
        calendar.prev();
    });
    
    document.getElementById('nextBtn').addEventListener('click', function() {
        calendar.next();
    });
    
    document.getElementById('viewSelector').addEventListener('change', function() {
        calendar.changeView(this.value);
    });



    // Create single slot
    document.getElementById('createSlotBtn').addEventListener('click', function() {
        const formData = {
            date: $('#slotDate').val(),
            appointment_type_id: $('#slotType').val() || null,
            max_capacity: $('#maxCapacity').val() || 1
        };
        const startTime = $('#startTime').val();
        const endTime = $('#endTime').val();

        // Build proper timestamps
        const startTimestamp = new Date(formData.date+'T'+startTime+':00');
        const endTimestamp   = new Date(formData.date+'T'+endTime+':00');

        // If you want to include them back into formData:
        formData.start_time = startTimestamp.toISOString();
        formData.end_time   = endTimestamp.toISOString();

        // Validate
        if (!formData.date || !formData.start_time || !formData.end_time) {
            //alert('Please fill in all required fields');
            showNotification('Please fill in all required fields', 'error');
            return;
        }

        Swal.fire({
            title: 'Are you sure?',
            text: 'Do you want to create slot?',
            icon: 'warning',
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, Create it'
        }).then(function(result) {
            if (result.isConfirmed) {
                handleSingleSlotSubmission(formData, startTime, endTime);
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                Swal.fire("Cancelled", "No action performed.", "error");
            }
        });
    });

    function handleSingleSlotSubmission(formData, startTime, endTime){
        // Send AJAX request
        fetch('/api/appointments/slots', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                $('#createSlotModal').modal('hide');
                calendar.refetchEvents(); // Refresh calendar
                updateSlotSummary();
                addActivity('Created slot: ' + formData.date + ' ' + startTime + '-' + endTime);
                showNotification('Slot created successfully', 'success');
            } else {
                //alert('Error: ' + data.message);
                showNotification('Error: ' + data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            //alert('Error creating slot');
            showNotification('Error: ' + error, 'error');
        });
    }

    // Create multiple slots
    document.getElementById('createBatchSlotsBtn').addEventListener('click', function() {
        const excludedDays = [];
        if ($('#excludeSunday').is(':checked')) excludedDays.push(0);
        if ($('#excludeMonday').is(':checked')) excludedDays.push(1);
        if ($('#excludeTuesday').is(':checked')) excludedDays.push(2);
        if ($('#excludeWednesday').is(':checked')) excludedDays.push(3);
        if ($('#excludeThursday').is(':checked')) excludedDays.push(4);
        if ($('#excludeFriday').is(':checked')) excludedDays.push(5);
        if ($('#excludeSaturday').is(':checked')) excludedDays.push(6);
        
        const formData = {
            start_date: $('#startDate').val(),
            end_date: $('#endDate').val(),
            start_time: $('#dailyStartTime').val(),
            end_time: $('#dailyEndTime').val(),
            duration_minutes: $('#slotDuration').val(),
            exclude_days: excludedDays.length > 0 ? excludedDays : null,
            appointment_type_id: $('#batchSlotType').val() || null,
            max_capacity: $('#batchMaxCapacity').val() || 1
        };
        
        // Validate
        if (!formData.start_date || !formData.end_date || !formData.start_time || !formData.end_time) {
            // alert('Please fill in all required fields');
            showNotification('Please fill in all required fields', 'error');
            return;
        }

        Swal.fire({
            title: 'Are you sure?',
            text: 'Do you want to create slot?',
            icon: 'warning',
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, Create it'
        }).then(function(result) {
            if (result.isConfirmed) {
                handleBatchSlotSubmission(formData);
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                Swal.fire("Cancelled", "No action performed.", "error");
            }
        });
    });

    function handleBatchSlotSubmission(formData){
        // Send AJAX request
        fetch('/api/appointments/slots/batch', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                $('#batchSlotsModal').modal('hide');
                calendar.refetchEvents(); // Refresh calendar
                updateSlotSummary();
                addActivity('Created ' + data.count + ' slots from ' + formData.start_date + ' to ' + formData.end_date);
                showNotification('Slots created successfully', 'success');
            } else {
                //alert('Error: ' + data.message);
                showNotification('Error: ' + data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            //alert('Error creating slots');
            showNotification('Error: ' + error, 'error');
        });
    }

    // View my slots
    // document.getElementById('viewSlotsBtn').addEventListener('click', function() {
    //     calendar.refetchEvents();
    //     updateSlotSummary();
    // });

    // Helper functions
    function updateSlotSummary() {
        fetch('/api/appointments/slots/summary')
        .then(response => response.json())
        .then(data => {
            // console.log(data)
            // document.getElementById('totalSlots').textContent = data.total_slots;
            // document.getElementById('availableSlots').textContent = data.available_slots;
            // document.getElementById('bookedSlots').textContent = data.booked_slots;
            // document.getElementById('fullSlots').textContent = data.full_slots;
        });
    }

    function addActivity(message) {
        const activityList = document.getElementById('recentActivity');
        if (activityList.children[0].textContent === 'No recent activity') {
            activityList.innerHTML = '';
        }
        
        const now = new Date().toLocaleTimeString();
        const li = document.createElement('li');
        li.className = 'list-group-item px-0 py-2';
        li.innerHTML = `<small class="text-muted">`+now+`</small><br>`+message+``;
        
        activityList.prepend(li);
        
        // Keep only the last 5 activities
        if (activityList.children.length > 5) {
            activityList.removeChild(activityList.lastChild);
        }
    }

    function scheduleAppointment(event) {

        // console.log(event._def.publicId);
        const appointmentProps = event._def.extendedProps;

        const slotID = event._def.publicId

        // console.log(appointmentProps.is_available)

        // console.log("Slot Data:", event);

        // console.log(event.start)
        const startDate = event.start;   // JS Date object
        const endDate   = event.end;     // JS Date object

        // formatted strings (ISO 8601 from FullCalendar)
        const startStr = event.startStr; // "2025-09-20T09:00:00+00:00"
        const endStr   = event.endStr;   // "2025-09-20T10:00:00+00:00"

        // if you just want date part
        const dateOnly = (startDate.getMonth() + 1).toString().padStart(2, '0') + '/' +
                    startDate.getDate().toString().padStart(2, '0') + '/' +
                    startDate.getFullYear();

        // pretty format (local time)
        const startTime = startDate.toLocaleTimeString([], { 
            hour: 'numeric', 
            minute: '2-digit', 
            hour12: true 
        });

        const endTime = endDate.toLocaleTimeString([], { 
            hour: 'numeric', 
            minute: '2-digit', 
            hour12: true 
        });

        // console.log("Start:", startTime); // e.g. 1:31 PM
        // console.log("End:", endTime);     // e.g. 5:40 PM


        let modalHtml = "";

        if(appointmentProps.is_available){

                modalHtml = `
                    <div class="modal fade modal-blur" id="appointmentModal" tabindex="-1">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content shadow-lg rounded-4">
                        <form id="appointmentForm">
                            <div class="modal-header">
                            <h5 class="modal-title">Schedule Appointment</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                <label for="client_id" class="form-label">Client</label>
                                <input type="text" id="client_id" value = "2" class="form-control" readonly>
                                </select>
                                </div>

                                <div class="col-md-6">
                                    <label for="slotType" class="form-label">Appointment Type</label>
                                    <select class="form-select" id="appointment_type_name">
                                        <option value="">-- Select Type --</option>
                                        <c:forEach var="type" items="`+appointmentTypes+`">
                                            <option value="`+type.id+`">`+type.name+` (`+type.duration_minutes+` mins)</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                <label for="time_slot_display" class="form-label">Time Slot</label>
                                <input type="text" id="time_slot_id" class="form-control" readonly>
                                </div>

                                <div class="col-md-6">
                                <label for="time_slot_display" class="form-label">Date</label>
                                <input type="text" id="slot_date" class="form-control" disabled>
                                </div>

                                <div class="col-md-6">
                                <label for="time_slot_display" class="form-label">Start Time</label>
                                <input type="text" id="slot_start_time" class="form-control" disabled>
                                </div>



                                <div class="col-md-6">
                                <label for="time_slot_display" class="form-label">End Time</label>
                                <input type="text" id="slot_end_time" class="form-control" disabled>
                                </div>


                                
                                <div class="col-md-6">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Confirmed">Confirmed</option>
                                    <option value="Pending Confirmation">Pending Confirmation</option>
                                    <option value="Cancelled">Cancelled</option>
                                </select>
                                </div>

                                <div class="col-12">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                                </div>
                            </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal"><i class="mdi mdi-close me-2"></i> Cancel</button>
                            <button type="submit" class="btn btn-primary" id="addAppointment"> <i class="mdi mdi-calendar-check me-2"></i> Save Appointment</button>               
                        </div>
                        </form>
                        </div>
                    </div>
                    </div>
                `;

        } else {

            modalHtml = `
            <div class="modal fade modal-blur" id="appointmentModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="appointmentModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content shadow-lg rounded-4">
                <form id="appointmentForm">
                    <div class="modal-header">
                    <h5 class="modal-title">Appointment Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                        <label for="client_id" class="form-label">Client</label>
                        <input type="text" id="client_id" value = "2" class="form-control" disabled>
                        </select>
                        </div>

                        <div class="col-md-6">
                            <label for="slotType" class="form-label">Appointment Type</label>
                            <select class="form-select" id="appointment_type_name" disabled>
                                <option value="">-- Select Type --</option>
                                <c:forEach var="type" items="`+appointmentTypes+`">
                                    <option value="`+type.id+`">`+type.name+` (`+type.duration_minutes+` mins)</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                        <label for="time_slot_display" class="form-label">Date</label>
                        <input type="text" id="slot_date" class="form-control" disabled>
                        </div>

                        <div class="col-md-6">
                        <label for="time_slot_display" class="form-label">Start Time</label>
                        <input type="text" id="slot_start_time" class="form-control" disabled>
                        </div>



                        <div class="col-md-6">
                        <label for="time_slot_display" class="form-label">End Time</label>
                        <input type="text" id="slot_end_time" class="form-control" disabled>
                        </div>



                        <div class="col-md-6">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status" disabled>
                            <option value="pending">Pending</option>
                            <option value="confirmed">Confirmed</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                        </div>

                        <div class="col-12">
                        <label for="notes" class="form-label">Notes</label>
                        <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
                        </div>
                    </div>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal"><i class="mdi mdi-close me-2"></i> Cancel</button>
                </div>
                </form>
                </div>
            </div>
            </div>
        `;
        }



        // Remove any old modal and append new
        $('#appointmentModal').remove();
        $('body').append(modalHtml);

        const modalEl = document.getElementById('appointmentModal');
        const modal = new bootstrap.Modal(modalEl);

        // Fill in values AFTER modal is in DOM
        // Set select by ID instead of name
        $('#appointment_type_name').val(appointmentProps.appointment_type_id);
        $('#slot_date').val(dateOnly);
        $('#slot_start_time').val(startTime);
        $('#slot_end_time').val(endTime);


        // (optional) fallback: if ID not available, try to match by text
        if (!$('#appointment_type_name').val()) {
        $("#appointment_type_name option").filter(function() {
            return $(this).text().trim().startsWith(appointmentProps.appointment_type_name);
        }).prop('selected', true);
        }

        $('#appointment_type_id').val(appointmentProps.appointment_type_id || '');
        $('#time_slot_id').val(slotID);
        // $('#time_slot_display').val(`${event.start.toLocaleString()} - ${event.end.toLocaleString()}`);
        $('#capacity').val(`${appointmentProps.current_bookings}/${appointmentProps.max_capacity}`);

        // Preselect status
        if (appointmentProps.is_available) {
            $('#status').val('pending');
        } else {
            $('#status').val('cancelled');
        }

        modal.show();

        // Attach handler to appointment form
        $(document).on('submit', '#appointmentForm', function (e) {
            e.preventDefault();

            const formData = {
                client_id: $('#client_id').val(),
                slot_id: $('#time_slot_id').val(),
                appointment_type_id: $('#appointment_type_name').val(),
                notes: $('#notes').val(),
                status :$('#status').val()
            };

            // Validate
            if (!formData.client_id || !formData.slot_id || !formData.appointment_type_id) {
                showNotification('Please fill in all required fields', 'error');
                return;
            }

            Swal.fire({
                title: 'Confirm Booking',
                text: 'Do you want to book this appointment?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, book it!',
                cancelButtonText: 'No, cancel',
                cancelButtonColor: '#d33'

            }).then(result => {
                if (result.isConfirmed) {
                    fetch('/api/appointments/book', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(formData)
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            $('#appointmentModal').modal('hide');
                            calendar.refetchEvents(); // Refresh calendar
                            showNotification('Appointment booked successfully', 'success');
                        } else {
                            showNotification('Error: ' + data.message, 'error');
                        }
                    })
                    .catch(err => {
                        console.error('Error:', err);
                        showNotification('Error booking appointment: ' + err, 'error');
                    });
                }else if (result.dismiss === Swal.DismissReason.cancel) {
                        Swal.fire("Cancelled", "No action performed.", "error");
                    }
            });
        });

        
        // Remove modal from DOM when hidden
        $('#appointmentModal').on('hidden.bs.modal', function() {
            $(this).remove();
        });
    }



    function toggleSlotAvailability(slotId) {

        Swal.fire({
            title: 'Are you sure?',
            text: 'Do you want to toggle the availability of this slot?',
            icon: 'warning',
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, Toggle it'
        }).then(function(result) {
            if (result.isConfirmed) {
                fetch('/api/appointments/slots/'+slotId+'/toggle', {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        calendar.refetchEvents();
                        updateSlotSummary();
                        addActivity('Toggled availability for slot ' + slotId);
                        showNotification('Toggled availability for slot ' + slotId, 'success');
                    } else {
                        //alert('Error toggling slot availability');
                        showNotification('Error toggling slot availability', 'error');
                    }
                });
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                Swal.fire("Cancelled", "No action performed.", "error");
            }
        });
    }

    function deleteSlot(slotId) {
        //if (!confirm('Are you sure you want to delete this slot?')) return;

        Swal.fire({
            title: 'Are you sure?',
            text: 'Do you want to delete this slot?',
            icon: 'warning',
            showCancelButton: true,
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, Delete it'
        }).then(function(result) {
            if (result.isConfirmed) {
                fetch('/api/appointments/slots/'+slotId, {
                    method: 'DELETE'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        calendar.refetchEvents();
                        updateSlotSummary();
                        addActivity('Deleted slot ' + slotId);
                        showNotification('Slot deleted successfully', 'success');
                    } else {
                        // alert('Error deleting slot');
                        showNotification('Error deleting slot', 'error');
                    }
                });
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                Swal.fire("Cancelled", "No action performed.", "error");
            }
        });
    }

    // Initialize page
    updateSlotSummary();

    // Set default dates in modals
    const today = new Date().toISOString().substring(0, 10);
    $('#slotDate').val(today);
    $('#startDate').val(today);
    $('#endDate').val(new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().substring(0, 10));    


});


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


</script>
