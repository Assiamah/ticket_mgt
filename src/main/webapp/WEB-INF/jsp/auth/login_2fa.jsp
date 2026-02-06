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
                    <img src="${pageContext.request.contextPath}/assets/images/auth/email.png" alt="Email Image" class="h-56px w-56px mx-auto d-block mb-3">
                    <h3 class="fw-medium text-center">OTP Verification : ${otp_pin}</h3>
                    <p class="text-muted text-center mb-8">Please enter the OTP (one time password) to verify your account. A code has been sent to <strong id="phone_number">${phone_number}</strong></p>
                    <div class="h5 text-center mb-8" id="timer">01:00</div>
                    <form method="post" action="${pageContext.request.contextPath}/verify_otp" id="otpForm">
                        <div id="otp-container" class="d-flex align-items-center justify-content-center gap-2 mb-6">
                            <input type="text" class="form-control text-center min-h-50px max-w-64px border rounded otp-input" placeholder="-" maxlength="1" name="vc_1" data-otp-input maxlength="1" inputmode="numeric" pattern="[0-9]" aria-label="OTP digit 1" id="vc_1">
                            <input type="text" class="form-control text-center min-h-50px max-w-64px border rounded otp-input" placeholder="-" maxlength="1" name="vc_2" data-otp-input maxlength="1" inputmode="numeric" pattern="[0-9]" aria-label="OTP digit 2">
                            <input type="text" class="form-control text-center min-h-50px max-w-64px border rounded otp-input" placeholder="-" maxlength="1" name="vc_3" data-otp-input maxlength="1" inputmode="numeric" pattern="[0-9]" aria-label="OTP digit 3">
                            <input type="text" class="form-control text-center min-h-50px max-w-64px border rounded otp-input" placeholder="-" maxlength="1" name="vc_4" data-otp-input maxlength="1" inputmode="numeric" pattern="[0-9]" aria-label="OTP digit 4">
                            <input type="text" class="form-control text-center min-h-50px max-w-64px border rounded otp-input" placeholder="-" maxlength="1" name="vc_5" data-otp-input maxlength="1" inputmode="numeric" pattern="[0-9]" aria-label="OTP digit 5">
                            <input type="text" class="form-control text-center min-h-50px max-w-64px border rounded otp-input" placeholder="-" maxlength="1" name="vc_6" data-otp-input maxlength="1" inputmode="numeric" pattern="[0-9]" aria-label="OTP digit 6">
                        </div>
                        <button type="submit" class="btn btn-primary w-100" id="btn-verify">Verify</button>
                    </form>
                    <p class="text-center mt-6 mb-0 text-muted fs-13">Didn't receive the code? <a href="javascript:void(0)" class="link fw-semibold">Resend</a></p>
                </div>
            </div>
            <p class="position-relative text-center fs-13 mb-0">Copyright &copy;
                <script>document.write(new Date().getFullYear())</script> EREM. All right reserved.
            </p>
        </div>
    </div>
</div>

<script>

$(document).ready(function() {
    // For coordinates (requires user permission)
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(position => {
            document.getElementById('coordinates').value = 
                position.coords.latitude+','+position.coords.longitude;
        });
    }

    $("#vc_1").focus();

    document.getElementById('otpForm').addEventListener('submit', function (e) {

      // var rememberMe = $('#checkbox-signin').is(':checked');
      
      var $this = $('#btn-verify');
      var loadingText = '<span class="text-white"><i class="mdi mdi-spin mdi-loading me-2"></i> Verifying...</span>';

      // Add remember token to form data
      // if (rememberMe) {
      //     var input = $('<input>')
      //         .attr('type', 'hidden')
      //         .attr('name', 'remember')
      //         .val('1');
      //     $('#loginForm').append(input);
      // }

      if ($('#btn-verify').html() !== loadingText) {
          $this.data('original-text', $('#btn-verify').html());
          $this.html(loadingText);
          $('#btn-verify').prop('disabled', true);
      }
    });

    let str = document.getElementById("phone_number").innerHTML;
    let res = str.replace(/\d(?=\d{3})/g, "*");
    document.getElementById("phone_number").innerHTML = res;

    $('.otp-input').on('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    const otpInputs = document.querySelectorAll('.otp-input');

    otpInputs.forEach((input, index) => {
        input.addEventListener('input', (e) => {
          const value = e.target.value;
          if (value.length === 1) {
              if (index < otpInputs.length - 1) {
              otpInputs[index + 1].focus();
              } else {
                  // Automatically submit the form when the last input field is filled
                  //     const enteredOtp = Array.from(otpInputs).map(input => input.value).join('');
                  //    $.ajax({
                  //     type: "GET",
                  //     url: "/two_factor_auth",
                  //     data: {enteredOtp: enteredOtp},
                  //     success: function(data) {}
                  //    });
                  //document.getElementById('otpForm').submit();
                  // $('#verify-indicator').removeClass('d-none');
                  //$('#otp-timer-div').addClass('d-none');
                  setTimeout(() => {
                      document.getElementById("btn-verify").click();
                  }, 1000);
              }
          }
        });

        input.addEventListener('keydown', (e) => {
        if (e.key === 'Backspace' && input.value === '' && index > 0) {
            otpInputs[index - 1].focus();
        }
        });
    });

    const KEY = "otpCountdownTarget"; // stores target timestamp (ms)
    const DURATION = 60; // seconds
    const timerEl = document.getElementById("timer");

    let intervalId = null;

    function formatMMSS(totalSeconds) {
      const m = Math.floor(totalSeconds / 60).toString().padStart(2, "0");
      const s = Math.floor(totalSeconds % 60).toString().padStart(2, "0");
      return m+':'+s;
    }

    function getOrCreateTarget(fromNowSeconds = DURATION) {
      let t = localStorage.getItem(KEY);
      const now = Date.now();
      if (!t || Number(t) <= now) {
        // create new target only if none exists or already expired
        t = String(now + fromNowSeconds * 1000);
        localStorage.setItem(KEY, t);
      }
      return Number(t);
    }

    function startCountdown() {
      const target = getOrCreateTarget();
      updateUI(target);
      if (intervalId) clearInterval(intervalId);
      intervalId = setInterval(() => updateUI(Number(localStorage.getItem(KEY))), 250);
    }

    function updateUI(targetTs) {
      const now = Date.now();
      const remaining = Math.max(0, Math.ceil((targetTs - now) / 1000));
      timerEl.textContent = formatMMSS(remaining);

      if (remaining <= 0 && intervalId) {
        clearInterval(intervalId);
        intervalId = null;
        localStorage.removeItem(KEY); // clear when expired
        // 👉 Here you can redirect, disable OTP input, or show a "Resend OTP" link
        timerEl.textContent = "Expired";
        $('#timer').addClass('text-danger');
      }
    }

    // Auto start/resume on page load
    window.addEventListener("load", startCountdown);

    // Keep multiple tabs/windows in sync
    window.addEventListener("storage", (e) => {
      if (e.key === KEY) {
        const t = localStorage.getItem(KEY);
        if (t) updateUI(Number(t));
      }
    });
});
</script>