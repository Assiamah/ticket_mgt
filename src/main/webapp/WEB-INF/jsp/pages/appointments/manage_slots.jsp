<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<main class="app-wrapper">
    <div class="container-fluid">
        <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
            <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">Manage Time Slots</h2>
            <div class="flex-shrink-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-end mb-0">
                        <li class="breadcrumb-item"><a href="javascript:void(0)">Appointments</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Manage Slots</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <!-- Action buttons -->
        <div class="row mb-3">
            <div class="col-12">
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createSlotModal">
                        <i class="bi bi-plus-circle"></i> Create Single Slot
                    </button>
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#batchSlotsModal">
                        <i class="bi bi-collection-play"></i> Create Multiple Slots
                    </button>
                    <button type="button" class="btn btn-info" id="viewSlotsBtn">
                        <i class="bi bi-eye"></i> View Slots
                    </button>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-xl-9">
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
            
            <div class="col-xl-3">
                <!-- Slot Summary Card -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Slot Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span>Total Slots:</span>
                            <span class="badge bg-primary" id="totalSlots">0</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span>Available Slots:</span>
                            <span class="badge bg-success" id="availableSlots">0</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span>Booked Slots:</span>
                            <span class="badge bg-info" id="bookedSlots">0</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span>Full Slots:</span>
                            <span class="badge bg-warning" id="fullSlots">0</span>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions Card -->
                <!-- <div class="card mt-3">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary btn-sm" id="copyWeekBtn">
                                <i class="bi bi-calendar-week"></i> Copy This Week's Slots
                            </button>
                            <button class="btn btn-outline-danger btn-sm" id="clearDayBtn">
                                <i class="bi bi-x-circle"></i> Clear Selected Day
                            </button>
                            <button class="btn btn-outline-warning btn-sm" id="toggleAvailabilityBtn">
                                <i class="bi bi-toggle-off"></i> Toggle Availability
                            </button>
                        </div>
                    </div>
                </div> -->
                
                <!-- Recent Activity Card -->
                <div class="card mt-3">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Recent Activity</h5>
                    </div>
                    <div class="card-body" style="max-height: 200px; overflow-y: auto;">
                        <ul class="list-group list-group-flush" id="recentActivity">
                            <li class="list-group-item px-0 py-2">No recent activity</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div><!--End container-fluid-->
</main><!--End app-wrapper-->

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize calendar
    const calendarEl = document.getElementById('calendar');
    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'timeGridWeek',
        height: 800,            // adjusts to content
        contentHeight: 600,        // fixed maximum content height
        expandRows: true, 
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
        },
        events: '/api/appointments/slots',
        editable: true,
        selectable: true,
        selectMirror: true,
        dayMaxEvents: true,
        validRange: {
            start: new Date() // prevents selection before today
        },
        select: function(info) {
            $('#createSlotModal').modal('show');
            $('#slotDate').val(info.startStr.substring(0, 10));
            $('#startTime').val(info.startStr.substring(11, 16));
            $('#endTime').val(info.endStr.substring(11, 16));
        },
        eventClick: function(info) {
            showSlotOptions(info.event);
        }
    });
    calendar.render();

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
    document.getElementById('viewSlotsBtn').addEventListener('click', function() {
        calendar.refetchEvents();
        updateSlotSummary();
    });

    // Helper functions
    function updateSlotSummary() {
        fetch('/api/appointments/slots/summary')
        .then(response => response.json())
        .then(data => {
            // console.log(data)
            document.getElementById('totalSlots').textContent = data.total_slots;
            document.getElementById('availableSlots').textContent = data.available_slots;
            document.getElementById('bookedSlots').textContent = data.booked_slots;
            document.getElementById('fullSlots').textContent = data.full_slots;
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

    function showSlotOptions(event) {
        // Implement a modal or context menu for slot operations
        // (edit, delete, toggle availability, etc.)
        const appointmentProps = event._def.extendedProps;
        const appAvailability = appointmentProps.is_available ? "Available" : "Not Available";
        const modalHtml = `
            <div class="modal fade modal-blur" id="slotOptionsModal" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Slot Options</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p>Slot: `+event.start.toLocaleString()+` - `+event.end.toLocaleString()+`</p>
                            <p>Status: `+appAvailability+`</p>
                            <p>Bookings: `+appointmentProps.current_bookings+`/`+appointmentProps.max_capacity+`</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-warning" id="toggleSlotBtn">Toggle Availability</button>
                            <button type="button" class="btn btn-danger" id="deleteSlotBtn">Delete Slot</button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Add modal to DOM and show it
        $('body').append(modalHtml);
        const modal = new bootstrap.Modal(document.getElementById('slotOptionsModal'));
        modal.show();
        
        // Set up event handlers
        document.getElementById('toggleSlotBtn').addEventListener('click', function() {
            toggleSlotAvailability(event.id);
            modal.hide();
        });
        
        document.getElementById('deleteSlotBtn').addEventListener('click', function() {
            deleteSlot(event.id);
            modal.hide();
        });
        
        // Remove modal from DOM when hidden
        $('#slotOptionsModal').on('hidden.bs.modal', function() {
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
