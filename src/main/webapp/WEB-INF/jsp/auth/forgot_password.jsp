<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!-- START -->
<div class="position-fixed top-0 bottom-0 end-0 start-0 z-0 bg-pattern"></div>
<div class="auth-pattern-shapes d-none d-lg-block"></div>
<div class="auth-pattern-outline d-none d-lg-block"></div>
<div class="auth-pattern-shape extra d-none d-lg-block"></div>
<div class="auth-pattern-extra d-none d-lg-block"></div>

<div class="container">
    <div class="row justify-content-center align-items-center min-vh-100 pt-20 pb-10">
        <div class="col-12 col-md-8 col-lg-6 col-xl-5">
            <div class="card mx-xxl-8 shadow-none">
                <div class="card-body p-8">
                    <h3 class="fw-medium text-center">Reset Password</h3>
                    <p class="mb-8 text-muted text-center">Enter your email to receive instructions</p>
                    <form method="post" action="${pageContext.request.contextPath}/auth/reset-password-request" id="resetForm">
                        <div class="mb-4">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" name="email" id="email" placeholder="Enter your email" required>
                        </div>
                        
                        <div>
                            <button type="submit" class="btn btn-primary w-100 mb-4" id="btn-reset">Send Reset Link</button>
                        </div>
                    </form>
                    <p class="text-center mt-6 mb-0 text-muted fs-13">Remember your password? <a href="${pageContext.request.contextPath}/login" class="link fw-semibold">Sign In</a></p>
                </div>
            </div>
            <p class="position-relative text-center fs-13 mb-0">Copyright &copy;
                <script>document.write(new Date().getFullYear())</script> EREM. All right reserved.
            </p>
        </div>
    </div>
</div>

<!-- Combined error message display -->
<c:if test="${not empty param.error or not empty param.success}">
    <c:set var="alertType" value="danger"/>
    <c:set var="alertIcon" value="exclamation-triangle-fill"/>
    <c:set var="alertMessage" value=""/>
    
    <c:choose>
        <c:when test="${param.success eq 'true'}">
            <c:set var="alertType" value="success"/>
            <c:set var="alertMessage" value="Reset link sent to your email"/>
        </c:when>
        <c:when test="${param.error eq 'true'}">
            <c:set var="alertMessage" value="Failed to send reset link"/>
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
    document.getElementById('resetForm').addEventListener('submit', function (e) {
        var $this = $('#btn-reset');
        var loadingText = '<span class="text-white"><i class="mdi mdi-spin mdi-loading me-2"></i> Sending...</span>';

        if ($('#btn-reset').html() !== loadingText) {
            $this.data('original-text', $('#btn-reset').html());
            $this.html(loadingText);
            $('#btn-reset').prop('disabled', true);
        }
    });
</script>