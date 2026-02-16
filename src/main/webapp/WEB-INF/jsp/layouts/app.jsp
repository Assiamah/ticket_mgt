<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="utf-8" />
    <title>EREM :: ${page_name} </title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta content="Admin & Dashboards Template" name="description" />
    <meta content="Pixeleyez" name="author" />
    
    <!-- layout setup -->
    <!-- <script type="module" src="${pageContext.request.contextPath}/assets/js/layout-setup.js"></script> -->
    
    <!-- App favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/libs/gridjs/theme/mermaid.min.css">
    <!-- Simplebar Css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/libs/simplebar/simplebar.min.css">
    <!-- Swiper Css -->
    <link href="${pageContext.request.contextPath}/assets/libs/swiper/swiper-bundle.min.css" rel="stylesheet">
    <!-- Nouislider Css -->
    <link href="${pageContext.request.contextPath}/assets/libs/nouislider/nouislider.min.css" rel="stylesheet">
    <!-- Bootstrap Css -->
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" id="bootstrap-style" rel="stylesheet" type="text/css">
    <!--icons css-->
    <link href="${pageContext.request.contextPath}/assets/css/icons.min.css" rel="stylesheet" type="text/css">
    <!-- App Css-->
    <link href="${pageContext.request.contextPath}/assets/css/app.min.css" id="app-style" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/assets/css/custom.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/assets/css/main.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/assets/libs/sweetalert2/sweetalert2.min.css" rel="stylesheet" type="text/css">

    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
    <link href="https://cdn.jsdelivr.net/npm/@mdi/font@7.4.47/css/materialdesignicons.min.css" rel="stylesheet">

    <link href="${pageContext.request.contextPath}/assets/libs/datatables.net-bs5/css/dataTables.bootstrap5.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/libs/datatables.net-responsive-bs5/css/responsive.bootstrap5.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/libs/datatables.net-buttons-bs5/css/buttons.bootstrap5.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/libs/datatables.net-select-bs5/css/select.bootstrap5.min.css" rel="stylesheet" type="text/css" />

    <!-- Javascript -->
    <script>
        window.CONTEXT_PATH = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
</head>

<body>

    <!-- Begin page -->
    <div id="layout-wrapper">

        <!-- Begin Header -->
        <jsp:include page="../components/header.jsp"></jsp:include>
        <!-- End Header -->

        <!-- Begin Sidebar -->
        <jsp:include page="../components/sidebar.jsp"></jsp:include>
        <!-- End Sidebar -->

        <!-- Begin Main Content -->
        <jsp:include page="${content}" />
        <!-- End Main Content -->

        <!-- Begin Offcanvas -->
         <jsp:include page="../components/offcanvas.jsp"></jsp:include>
        <!-- End Offcanvas -->

        <!-- Begin Scroll Top -->
         <jsp:include page="../components/scrolltop.jsp"></jsp:include>
        <!-- End Scroll Top -->
         
        <!-- Begin Footer -->
        <jsp:include page="../components/footer.jsp"></jsp:include>
        <!-- End Footer -->


    </div>
    <!-- END page -->

    <jsp:include page="../components/modal.jsp"></jsp:include>

    <!-- JAVASCRIPT -->
    <script src="${pageContext.request.contextPath}/assets/libs/swiper/swiper-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/simplebar/simplebar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scroll-top.init.js"></script>    
    <script src="${pageContext.request.contextPath}/assets/libs/gridjs/gridjs.umd.js" type="text/javascript"></script>

    <!-- <script src="${pageContext.request.contextPath}/assets/libs/apexcharts/apexcharts.min.js"></script> -->
    <!-- File js -->
    <!-- <script src="${pageContext.request.contextPath}/assets/js/dashboard/e-commerce.init.js"></script> -->
    <!-- App js -->
    <!-- <script type="module" src="${pageContext.request.contextPath}/assets/js/app.js"></script> -->
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/sweetalert2/sweetalert2.all.min.js"></script>

    <!-- Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <!-- axios js -->
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <!--datatable js-->
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net/js/jquery.dataTables.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-responsive/js/dataTables.responsive.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-responsive-bs5/js/responsive.bootstrap5.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-buttons-bs5/js/buttons.bootstrap5.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-buttons/js/buttons.html5.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-buttons/js/buttons.flash.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-buttons/js/buttons.print.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/libs/datatables.net-select/js/dataTables.select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/table/datatable.init.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>

    <script>
        // Show the loading modal when the DOM starts loading
        // Show Loader
        window.showLoader = function(message = "Loading...") {
            Swal.fire({
                text: message,
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        }

        // Hide Loader (with default timeout)
        window.hideLoader = function(timeout = 500) {
            setTimeout(() => {
            Swal.close();
            }, timeout);
        }

        // Loader when page starts loading
        document.addEventListener("DOMContentLoaded", () => {
            showLoader();
        });

        // Close when everything is fully loaded
        window.addEventListener("load", () => {
            hideLoader(); // closes after 500ms
        });

        // Wrap fetch with loader
        window.withLoader = function(promise) {
            showLoader();
            return promise.finally(() => hideLoader());
        }

        // Example usage
        // withLoader(fetch("/api/data")).then(r => r.json()).then(console.log);

        // Auto hook into jQuery AJAX (if using jQuery)
        if (window.jQuery) {
            $(document).ajaxStart(() => showLoader());
            $(document).ajaxStop(() => hideLoader());
        }
    </script>

</body>

</html>
