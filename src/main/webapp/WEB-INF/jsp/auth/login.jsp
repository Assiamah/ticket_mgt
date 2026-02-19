<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!-- START -->
<div class="position-fixed top-0 bottom-0 end-0 start-0 z-0 bg-pattern"></div>
<div class="auth-pattern-shapes d-none d-lg-block"></div>
<div class="auth-pattern-outline d-none d-lg-block"></div>
<div class="auth-pattern-shape extra d-none d-lg-block"></div>
<div class="auth-pattern-extra d-none d-lg-block"></div>
<!-- <header class="px-3 px-md-8 py-5 position-absolute top-0 d-flex justify-content-between align-items-center w-100 z-1">
    <a href="index.html" class="d-flex align-items-end logo-main">
        <img height="35" class="logo-dark" alt="Dark Logo" src="assets/images/logo-md.png">
        <h3 class="text-body-emphasis fw-bolder mb-0 ms-1">Urbix</h3>
    </a>
    <ul class="list-inline mb-0">
        <li class="list-inline-item pe-4 border-end"><a href="index.html" class="link-body-emphasis">Home</a></li>
        <li class="list-inline-item pe-4 border-end"><a href="#!" class="link-body-emphasis">Support</a></li>
        <li class="list-inline-item"><a href="#!" class="link-body-emphasis">Documentation</a></li>
    </ul>
</header> -->
<div class="container">
    <div class="row justify-content-center align-items-center min-vh-100 pt-20 pb-10">
        <div class="col-12 col-md-8 col-lg-6 col-xl-5">
            <div class="card mx-xxl-8 shadow-none">
                <div class="card-body p-8">
                    <c:choose>
                        <c:when test="${forceChangePassword}">
                            <h3 class="fw-medium text-center">Change Password</h3>
                            <p class="mb-8 text-muted text-center">You are required to change your password.</p>
                            <form id="resetPasswordForm" onsubmit="handleResetPassword(event)">
                                <input type="hidden" id="reset_user_id" value="${userId}">
                                <div class="mb-4">
                                    <label for="reset_default_pass" class="form-label">Current Password (Default) <span class="text-danger">*</span></label>
                                    <div class="position-relative">
                                        <input type="password" class="form-control" id="reset_default_pass" placeholder="Enter default password" required>
                                        <button type="button" class="btn btn-link position-absolute end-0 top-0 text-decoration-none text-muted toggle-password" data-target="reset_default_pass"><i class="ri-eye-off-line align-middle"></i></button>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="reset_new_pass" class="form-label">New Password <span class="text-danger">*</span></label>
                                    <div class="position-relative">
                                        <input type="password" class="form-control" id="reset_new_pass" placeholder="Enter new password" required>
                                        <button type="button" class="btn btn-link position-absolute end-0 top-0 text-decoration-none text-muted toggle-password" data-target="reset_new_pass"><i class="ri-eye-off-line align-middle"></i></button>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="reset_confirm_pass" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                                    <div class="position-relative">
                                        <input type="password" class="form-control" id="reset_confirm_pass" placeholder="Confirm new password" required>
                                        <button type="button" class="btn btn-link position-absolute end-0 top-0 text-decoration-none text-muted toggle-password" data-target="reset_confirm_pass"><i class="ri-eye-off-line align-middle"></i></button>
                                    </div>
                                </div>
                                <div>
                                    <button type="submit" class="btn btn-primary w-100 mb-4" id="btn-reset-pass">Change Password</button>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <h3 class="fw-medium text-center">Welcome back!</h3>
                            <p class="mb-8 text-muted text-center">Create Your Account in Minutes</p>
                            <form method="post" action="${pageContext.request.contextPath}/user_authentication" id="loginForm">
                                <input type="hidden" name="coordinates" id="coordinates">
                                <div class="mb-4">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" name="email" id="email" placeholder="Enter your email" required>
                                </div>
                                <div class="mb-4">
                                    <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                                    <div class="position-relative">
                                        <input type="password" class="form-control" name="password" id="password" placeholder="Enter your password" required>
                                        <button type="button" class="btn btn-link position-absolute end-0 top-0 text-decoration-none text-muted toggle-password" id="toggle-password" data-target="password"><i class="ri-eye-off-line align-middle"></i></button>
                                    </div>
                                </div>
                                <div class="my-6">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="form-check">
                                            <input type="checkbox" class="form-check-input" id="rememberMe">
                                            <label class="form-check-label" for="rememberMe">Remember me</label>
                                        </div>
                                        <div class="form-text">
                                            <a href="${pageContext.request.contextPath}/forgot-password" class="link">Forgot password?</a>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <button type="submit" class="btn btn-primary w-100 mb-4" id="btn-login">Sign In</button>
                                    <!-- <button type="button" class="btn btn-outline-light w-100 d-flex align-items-center gap-2 justify-content-center text-muted">
                                        <img src="assets/images/google.png" alt="Google Logo" class="h-20px w-20px">Sign in with Google
                                    </button> -->
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                    <!-- <p class="text-center mt-6 mb-0 text-muted fs-13">Don't have an account? <a href="auth-signup.html" class="link fw-semibold">Sign up here</a></p> -->
                </div>
            </div>
            <p class="position-relative text-center fs-13 mb-0">Copyright &copy;
                <script>document.write(new Date().getFullYear())</script> EREM. All right reserved.
            </p>
        </div>
    </div>
</div>

<!-- Combined error message display -->
<c:if test="${not empty param.error or not empty param.session or not empty param.logout}">
    <c:set var="alertType" value="danger"/>
    <c:set var="alertIcon" value="exclamation-triangle-fill"/>
    <c:set var="alertMessage" value=""/>
    
    <c:choose>
        <c:when test="${param.error eq 'true'}">
            <c:set var="alertMessage" value="Invalid credentials"/>
        </c:when>
        <c:when test="${param.error eq 'oauth'}">
            <c:set var="alertMessage" value="OAuth login failed"/>
        </c:when>
        <c:when test="${param.error eq 'access_denied'}">
            <c:set var="alertMessage" value="Access denied"/>
        </c:when>
        <c:when test="${param.error eq 'unauthorized'}">
            <c:set var="alertMessage" value="Please login"/>
        </c:when>
        <c:when test="${param.error eq 'notfound'}">
            <c:set var="alertMessage" value="Page not found"/>
        </c:when>
        <c:when test="${param.session eq 'invalid'}">
            <c:set var="alertMessage" value="Invalid session"/>
        </c:when>
        <c:when test="${param.session eq 'expired'}">
            <c:set var="alertMessage" value="Session expired"/>
        </c:when>
        <c:when test="${param.logout eq 'true'}">
            <c:set var="alertType" value="success"/>
            <c:set var="alertIcon" value="check-circle-fill"/>
            <c:set var="alertMessage" value="Logged out successfully"/>
        </c:when>
        <c:otherwise>
            <c:set var="alertMessage" value="Unknown error occurred"/>
        </c:otherwise>
    </c:choose>
    
    <script>
        Toastify({
            text: "${alertMessage}",
            duration: 10000,
            close: true,
            gravity: "top",
            position: "right",
            stopOnFocus: true,
            avatar: "${alertType eq 'success' ? '../assets/images/notification/ok-48.png' : '../assets/images/notification/high_priority-48.png'}", // small icon image
            style: {
                background: "${alertType eq 'success' ? 'linear-gradient(to right, #00b09b, #96c93d)' : 'linear-gradient(to right, #ff5f6d, #ffc371)'}",
                fontSize: "13px",
            },
        }).showToast();
    </script>
</c:if>

<script>
    document.getElementById('loginForm')?.addEventListener('submit', function (e) {

        // var rememberMe = $('#checkbox-signin').is(':checked');
        
        var $this = $('#btn-login');
        var loadingText = '<span class="text-white"><i class="mdi mdi-spin mdi-loading me-2"></i> Authenticating...</span>';

        // Add remember token to form data
        // if (rememberMe) {
        //     var input = $('<input>')
        //         .attr('type', 'hidden')
        //         .attr('name', 'remember')
        //         .val('1');
        //     $('#loginForm').append(input);
        // }

        if ($('#btn-login').html() !== loadingText) {
            $this.data('original-text', $('#btn-login').html());
            $this.html(loadingText);
            $('#btn-login').prop('disabled', true);
        }
    });

    // Handle Password Reset
    function handleResetPassword(event) {
        event.preventDefault();
        
        const userId = document.getElementById('reset_user_id').value;
        const defaultPass = document.getElementById('reset_default_pass').value;
        const newPass = document.getElementById('reset_new_pass').value;
        const confirmPass = document.getElementById('reset_confirm_pass').value;
        
        if (newPass !== confirmPass) {
            Toastify({
                text: "New passwords do not match",
                duration: 3000,
                close: true,
                gravity: "top",
                position: "right",
                style: { background: "linear-gradient(to right, #ff5f6d, #ffc371)" }
            }).showToast();
            return;
        }
        
        const btn = document.getElementById('btn-reset-pass');
        const originalText = btn.innerHTML;
        btn.innerHTML = '<span class="text-white"><i class="mdi mdi-spin mdi-loading me-2"></i> Resetting...</span>';
        btn.disabled = true;
        
        const payload = {
            user_id: userId,
            default_password: defaultPass,
            new_password: newPass,
            confirm_password: confirmPass
        };
        
        fetch('${pageContext.request.contextPath}/reset_password_with_default', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success' || data.success === true) {
                Toastify({
                    text: "Password changed successfully. Redirecting to login...",
                    duration: 3000,
                    close: true,
                    gravity: "top",
                    position: "right",
                    style: { background: "linear-gradient(to right, #00b09b, #96c93d)" }
                }).showToast();
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/login';
                }, 1500);
            } else {
                throw new Error(data.message || 'Failed to reset password');
            }
        })
        .catch(error => {
            Toastify({
                text: error.message,
                duration: 5000,
                close: true,
                gravity: "top",
                position: "right",
                style: { background: "linear-gradient(to right, #ff5f6d, #ffc371)" }
            }).showToast();
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    }

    // Toggle Password Visibility
    document.querySelectorAll('.toggle-password').forEach(button => {
        button.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const input = document.getElementById(targetId);
            const icon = this.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('ri-eye-off-line');
                icon.classList.add('ri-eye-line');
            } else {
                input.type = 'password';
                icon.classList.remove('ri-eye-line');
                icon.classList.add('ri-eye-off-line');
            }
        });
    });
</script>