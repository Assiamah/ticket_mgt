<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="modal fade modal-blur" id="addUserModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" aria-labelledby="addUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content shadow-lg border-0 rounded-3">
            
            <!-- Header -->
            <div class="modal-header">
                <h5 class="modal-title d-flex align-items-center" id="addUserModalLabel">
                    <i class="fas fa-user-plus me-2"></i> Add New User
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <!-- Body -->
            <div class="modal-body p-4">
                <form id="addUserForm" data-user-id="" data-is-edit="false">

                    <!-- Section: Personal Info -->
                    <h6 class="text-primary fw-bold mb-3"><i class="mdi mdi-account me-1"></i> Personal Information</h6>
                    <div class="row g-3">
                        <div class="col-md-2">
                            <label for="title" class="form-label">Title <span class="text-danger">*</span></label>
                            <select class="form-select" id="title" name="title" required>
                            <option value="">Select</option>
                            <option>Mr.</option>
                            <option>Ms.</option>
                            <option>Mrs.</option>
                            <option>Dr.</option>
                            <option>Prof.</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="first_name" class="form-label">First Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="first_name" name="first_name" required>
                        </div>
                        <div class="col-md-6">
                            <label for="last_name" class="form-label">Last Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="last_name" name="last_name" required>
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label for="middle_name" class="form-label">Middle Name(s)</label>
                            <input type="text" class="form-control" id="middle_name" name="middle_name">
                        </div>
                        <div class="col-md-6">
                            <label for="dob" class="form-label">Date of Birth <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="dob" name="dob">
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label for="gender" class="form-label">Gender <span class="text-danger">*</span></label>
                            <select class="form-select" id="gender" name="gender" required>
                            <option value="">Select</option>
                            <option>Male</option>
                            <option>Female</option>
                            </select>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Section: Account Info -->
                    <h6 class="text-primary fw-bold mb-3"><i class="mdi mdi-key me-1"></i> Account Information</h6>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-12">
                            <label for="org_select" class="form-label">Organization <span class="text-danger">*</span></label>
                            <select class="form-select" id="org_select" name="org_id" required>
                                <option value="">Select Organization</option>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="password" name="password" required autocomplete="new-password">
                        </div>
                        <div class="col-md-6">
                            <label for="confirm_password" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="confirm_password" name="confirm_password" required autocomplete="new-password">
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label for="role" class="form-label">Role <span class="text-danger">*</span></label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="">Select Role</option>
                                <option>Admin</option>
                                <option>User</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="level" class="form-label">Level <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="level" name="level" min="1" max="10" required>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Section: Contact Info -->
                    <h6 class="text-primary fw-bold mb-3"><i class="mdi mdi-contacts me-1"></i> Contact Information</h6>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="phone_number" class="form-label">Phone Number <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <select class="form-select flex-grow-0 w-auto" id="country_code" name="country_code">
                                    <option value="+233">+233</option>
                                </select>
                                <input type="text" class="form-control" placeholder="Enter phone number" id="phone_number" name="phone_number" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="country" class="form-label">Country <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="country" name="country" value="Ghana" required>
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label for="address" class="form-label">Address <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="address" name="address" required>
                        </div>
                        <div class="col-md-6">
                            <label for="zip_code" class="form-label">Zip Code</label>
                            <input type="text" class="form-control" id="zip_code" value="00233" name="zip_code">
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label for="city" class="form-label">City <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="city" name="city" required>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Section: Security -->
                    <h6 class="text-primary fw-bold mb-3"><i class="mdi mdi-shield-half-full me-1"></i> Security Settings</h6>
                    <div class="row mb-2 m-1 bg-light" style="border-radius: 15px; background-color: var(--pe-secondary-bg-subtle);">
                        <div class="col-6 mt-4 mb-4">
                            <div class="label-01">2 Factor Authentication</div>
                            <div class="small text-muted">Two-factor authentication is an enhanced security measure. Once enabled, you'll be required to give one type of identification when you log into</div>
                        </div>
                        <div class="col-6 mt-4 mb-4">
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input two_factor" type="checkbox" id="two_factor" checked>
                                <label class="form-check-label" for="two_factor">Enable Two-Factor Authentication (SMS)</label>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input email_auth" type="checkbox" id="email_auth">
                                <label class="form-check-label" for="email_auth">Enable Email Authentication</label>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-2 m-1 bg-light" style="border-radius: 15px; background-color: var(--pe-secondary-bg-subtle);">
                        <div class="col-6 mt-4 mb-4">
                            <div class="label">Login Notification</div>
                            <div class="small text-muted">Stay informed about account activity. When enabled, you'll receive a notification whenever a login is detected on your account.</div>
                        </div>
                        <div class="col-6 mt-4 mb-4">
                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input login_notifications" type="checkbox" id="login_notifications" checked>
                                <label class="form-check-label" for="login_notifications">Enable Login Notifications</label>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="status" class="form-label">Status</label>
                            <select class="form-select" id="status" name="status">
                            <option value="active" selected>Active</option>
                            <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-6 pt-3 d-flex align-items-center">
                            <div class="form-check mt-4">
                            <input class="form-check-input expire_pass" type="checkbox" id="expire_pass" name="expire_pass">
                            <label class="form-check-label" for="expire_pass">Password Expires (90 days)</label>
                            </div>
                        </div>
                    </div>

                </form>
            </div>

            <!-- Footer -->
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="submitUserForm">Add User</button>
            </div>

        </div>
    </div>
</div>


<!-- Create Single Slot Modal -->
<div class="modal fade modal-blur" id="createSlotModal" tabindex="-1" aria-labelledby="createSlotModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createSlotModalLabel">Create Time Slot</h5>
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
</div>

<!-- Create Multiple Slots Modal -->
<div class="modal fade modal-blur" id="batchSlotsModal" tabindex="-1" aria-labelledby="batchSlotsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="batchSlotsModalLabel">Create Multiple Time Slots</h5>
                <button type="button" class="btn-close " data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="batchSlotsForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="startDate" class="form-label">Start Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="startDate" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="endDate" class="form-label">End Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="endDate" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="dailyStartTime" class="form-label">Daily Start Time <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" id="dailyStartTime" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="dailyEndTime" class="form-label">Daily End Time <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" id="dailyEndTime" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="slotDuration" class="form-label">Slot Duration (minutes) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="slotDuration" min="15" step="15" value="30" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Exclude Days</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="0" id="excludeSunday">
                            <label class="form-check-label" for="excludeSunday">Sunday</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="1" id="excludeMonday">
                            <label class="form-check-label" for="excludeMonday">Monday</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="2" id="excludeTuesday">
                            <label class="form-check-label" for="excludeTuesday">Tuesday</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="3" id="excludeWednesday">
                            <label class="form-check-label" for="excludeWednesday">Wednesday</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="4" id="excludeThursday">
                            <label class="form-check-label" for="excludeThursday">Thursday</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="5" id="excludeFriday">
                            <label class="form-check-label" for="excludeFriday">Friday</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="6" id="excludeSaturday">
                            <label class="form-check-label" for="excludeSaturday">Saturday</label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="batchSlotType" class="form-label">Appointment Type</label>
                        <select class="form-select" id="batchSlotType">
                            <option value="">-- Select Type --</option>
                            <c:forEach var="type" items="${appointmentTypes}">
                                <option value="${type.id}">${type.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="batchMaxCapacity" class="form-label">Maximum Capacity</label>
                        <input type="number" class="form-control" id="batchMaxCapacity" min="1" value="1">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="createBatchSlotsBtn">Create Slots</button>
            </div>
        </div>
    </div>
</div>





<!-- Create Appointment Modal -->
<div class="modal fade modal-blur" id="creatappointmentModal" tabindex="-1" aria-labelledby="creatappointmentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="creatappointmentModalLabel">Slots Calendar </h5>
                <button type="button" class="btn-close " data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">Calendar View</h5>
                        <div class="d-flex gap-2">
                            <button class="btn btn-sm btn-outline-primary" id="todayBtn">Today</button>
                            <div class="btn-group">
                                <button class="btn btn-sm btn-outline-secondary" id="prevBtn"><i class="bi bi-chevron-left"></i></button>
                                <button class="btn btn-sm btn-outline-secondary" id="nextBtn"><i class="bi bi-chevron-right"></i></button>
                            </div>
                            <select class="form-select form-select-sm" id="viewSelector">
                                <option value="dayGridMonth">Month</option>
                                <option value="timeGridWeek" selected>Week</option>
                                <option value="timeGridDay">Day</option>
                                <option value="listWeek">List</option>
                            </select>
                        </div>
                    </div>
                    <div class="card-body">
                        <div id="calendar"></div>
                    </div>
                </div>
            
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal"><i class="mdi mdi-close me-2"></i> Cancel</button>
            </div>
        </div>
    </div>
</div>