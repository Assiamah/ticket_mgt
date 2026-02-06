<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<main class="app-wrapper">
    <div class="container-fluid">

        <div class="main-breadcrumb d-flex align-items-center my-3 position-relative">
            <h2 class="breadcrumb-title mb-0 flex-grow-1 fs-14">System Owner Dashboard</h2>
            <div class="flex-shrink-0">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb justify-content-end mb-0">
                        <li class="breadcrumb-item"><a href="javascript:void(0)">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Overview</li>
            </ol>
            </nav>
            </div>
        </div>
        <div class="row g-3 mb-3">
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-primary fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-buildings"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="org_count">0</h3>
                            <span class="fs-5">Organizations</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-primary fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-ticket-perforated"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="ticket_total_count">0</h3>
                            <span class="fs-5">Total Tasks</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-success fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-play-circle"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="status_open_count">0</h3>
                            <span class="fs-5">Open</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-warning fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-lightning-charge"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="status_in_progress_count">0</h3>
                            <span class="fs-5">In Progress</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row g-3 mb-3">
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-info fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="status_resolved_count">0</h3>
                            <span class="fs-5">Resolved</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-danger fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-x-circle"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="status_closed_count">0</h3>
                            <span class="fs-5">Closed</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-danger fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="priority_critical_count">0</h3>
                            <span class="fs-5">Critical</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="card card-h-100">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div class="h-48px w-48px d-flex justify-content-center align-items-center text-danger fs-4 rounded-3 shadow-lg border">
                            <i class="bi bi-arrow-up"></i>
                        </div>
                        <div class="text-end">
                            <h3 id="priority_high_count">0</h3>
                            <span class="fs-5">High</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <div class="card card-h-100">
                    <div class="card-header">
                        <h4>Status Distribution</h4>
                    </div>
                    <div class="card-body">
                        <div id="status_pie_chart" style="height:320px"></div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card card-h-100">
                    <div class="card-header">
                        <h4>Priority Breakdown</h4>
                    </div>
                    <div class="card-body">
                        <div id="priority_bar_chart" style="height:320px"></div>
                    </div>
                </div>
            </div>
      div>
        <!-- <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h4>Latest Order</h4>
                        <div class="d-flex gap-3 align-items-center">
                            <div class="form-icon">
                                <input type="text" class="form-control form-control-icon" id="firstNameLayout4" placeholder="Search Here ..." required>
                                <i class="ri-search-2-line text-muted"></i>
                            </div>
                            <div class="btn-group">
                                <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Weekly
                                </button>
                                <div class="dropdown-menu dropdown-menu-start">
                                    <a class="dropdown-item" href="javascript:void(0)">Weekly</a>
                                    <a class="dropdown-item" href="javascript:void(0)">In Transit</a>
                                    <a class="dropdown-item" href="javascript:void(0)">Delivered</a>
                                    <a class="dropdown-item" href="javascript:void(0)">Pending</a>
                                    <a class="dropdown-item" href="javascript:void(0)">Delayed</a>
                                    <a class="dropdown-item" href="javascript:void(0)">Canceled</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-box table-responsive">
                            <table class="table table-hover text-nowrap">
                                <thead class="table-light border-0">
                                    <tr>
                                        <th>Customer ID</th>
                                        <th>Email</th>
                                        <th>Product</th>
                                        <th>Status</th>
                                        <th>Tracking</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" value="flexCheckDefault" id="flexCheckDefault">
                                                <img src="assets/images/avatar/avatar-1.jpg" class="avatar-sm rounded-2 mx-2" alt="Avatar Image">
                                                #0051134
                                            </div>
                                        </td>
                                        <td>ela@septi.gmail.com</td>
                                        <td>MacBook Air</td>
                                        <td><span class="badge bg-warning-subtle text-warning py-1 rounded-3 border border-warning">On Way</span></td>
                                        <td>PQ1132G</td>
                                        <td>
                                            <div class="dropdown dropdown-menu-end">
                                                <button class="btn p-0" type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Edit</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">View</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Track</a></li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" value="flexCheckDefault1" id="flexCheckDefault1" checked>
                                                <img src="assets/images/avatar/avatar-2.jpg" class="avatar-sm rounded-2 mx-2" alt="Avatar Image">
                                                #0021598
                                            </div>
                                        </td>
                                        <td>te@shroff.gmail.com</td>
                                        <td>Magical Pen</td>
                                        <td><span class="badge bg-primary-subtle text-primary py-1 rounded-3 border border-primary">Waiting</span></td>
                                        <td>CF0568B</td>
                                        <td>
                                            <div class="dropdown dropdown-menu-end">
                                                <button class="btn p-0" type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Edit</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">View</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Track</a></li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" value="flexCheckDefault2" id="flexCheckDefault2">
                                                <img src="assets/images/avatar/avatar-3.jpg" class="avatar-sm rounded-2 mx-2" alt="Avatar Image">
                                                #0045976
                                            </div>
                                        </td>
                                        <td>te@shroff.gmail.com</td>
                                        <td>Secret Diary</td>
                                        <td><span class="badge bg-danger-subtle text-danger py-1 rounded-3 border border-danger">Pending</span></td>
                                        <td>RY4578K</td>
                                        <td>
                                            <div class="dropdown dropdown-menu-end">
                                                <button class="btn p-0" type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Edit</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">View</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Track</a></li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" value="flexCheckDefault3" id="flexCheckDefault3">
                                                <img src="assets/images/avatar/avatar-4.jpg" class="avatar-sm rounded-2 mx-2" alt="Avatar Image">
                                                #0074564
                                            </div>
                                        </td>
                                        <td>te@shroff.gmail.com</td>
                                        <td>IdeaPad Azure</td>
                                        <td><span class="badge bg-success-subtle text-success py-1 rounded-3 border border-success">Delivered</span></td>
                                        <td>ST9856H</td>
                                        <td>
                                            <div class="dropdown dropdown-menu-end">
                                                <button class="btn p-0" type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Edit</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">View</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Track</a></li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" value="flexCheckDefault4" id="flexCheckDefault4">
                                                <img src="assets/images/avatar/avatar-5.jpg" class="avatar-sm rounded-2 mx-2" alt="Avatar Image">
                                                #0098546
                                            </div>
                                        </td>
                                        <td>te@shroff.gmail.com</td>
                                        <td>Laxmi Electric Stove</td>
                                        <td><span class="badge bg-success-subtle text-success py-1 rounded-3 border border-success">Delivered</span></td>
                                        <td>KI1256G</td>
                                        <td>
                                            <div class="dropdown dropdown-menu-end">
                                                <button class="btn p-0" type="button" data-bs-toggle="dropdown">
                                                    <i class="bi bi-three-dots"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Edit</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">View</a></li>
                                                    <li><a class="dropdown-item" href="javascript:void(0)">Track</a></li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-8">
                <div class="card">
                    <div class="card-header">
                        <h4>Average Order Value</h4>
                        <div class="d-flex align-items-center">
                            <ul class="nav nav-pills me-3" id="pills-tab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="average-line-tab" data-bs-toggle="pill" data-bs-target="#average-line" type="button" role="tab" aria-controls="average-line" aria-selected="true">Line</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="average-bar-tab" data-bs-toggle="pill" data-bs-target="#average-bar" type="button" role="tab" aria-controls="average-bar" aria-selected="false">Bar</button>
                                </li>
                            </ul>
                            <div class="dropdown">
                                <a href="javascript:void(0)" data-bs-toggle="dropdown" class="text-muted">
                                    <i class="bi bi-three-dots-vertical"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-start">
                                    <li><a class="dropdown-item" href="javascript:void(0)">This Week</a></li>
                                    <li><a class="dropdown-item" href="javascript:void(0)">This Month</a></li>
                                    <li><a class="dropdown-item" href="javascript:void(0)">This Year</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="pills-tabContent">
                            <div class="tab-pane fade show active" role="tabpanel" aria-labelledby="pills-home-tab" tabindex="0" id="average-line" class="apexcharts-container"></div>
                            <div class="tab-pane fade" id="average-bar" role="tabpanel" aria-labelledby="average-bar-tab" tabindex="0"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4">
                <div class="card card-h-100">
                    <div class="card-header">
                        <h4>Recent Sales</h4>
                        <a href="javascript:void(0)" class="link">View All</a>
                    </div>
                    <div class="card-body">
                        <div id="gridjs_sort-table"></div>
                    </div>
                </div>
            </div>
            <div class="col-xxl-4">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h4>Product Statistics</h4>
                            <p class="mb-0 text-muted">Track your product sales</p>
                        </div>
                        <a href="javascript:void(0)" class="link">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="position-relative">
                            <div id="product-statistics"></div>
                            <div class="product-chart text-center">
                                <h3>9,829</h3>
                                <p class="mb-0">Product Sales</p>
                                <span class="badge bg-success py-1 rounded-pill">+5.34%</span>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <div>
                                <i class="ri-ram-line fs-5 me-3"></i>
                                Electronic
                            </div>
                            <div>
                                <span class="text-muted me-3">2,482</span>
                                <span class="badge bg-primary-subtle text-primary px-2 rounded-3">+5.34%</span>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <div>
                                <i class="bi bi-controller fs-5 me-3"></i>
                                Games
                            </div>
                            <div>
                                <span class="text-muted me-3">1,828</span>
                                <span class="badge bg-warning-subtle text-warning px-2 rounded-3">+5.34%</span>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between">
                            <div>
                                <i class="bi bi-lamp fs-5 me-3"></i>
                                Furniture
                            </div>
                            <div>
                                <span class="text-muted me-3">1,463</span>
                                <span class="badge bg-danger-subtle text-danger px-2 rounded-3">+5.34%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xxl-4 col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <h4>Customer Growth</h4>
                            <p class="mb-0 text-muted">Track Customer per location</p>
                        </div>
                        <a href="javascript:void(0)" class="link">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="bubble-container">
                            <div class="bubble bubble1">2,489</div>
                            <div class="bubble bubble2">1,756</div>
                            <div class="bubble bubble3">285</div>
                            <div class="bubble bubble4">812</div>
                        </div>
                        <div class="d-flex align-items-center gap-4 mb-5">
                            <img src="assets/images/flag/us.svg" height="30" width="30" class="object-fit-cover rounded-circle">
                            <div class="w-100">
                                <div class="d-flex justify-content-between align-items-center fs-13">
                                    <p class="text-muted mb-1">United States</p>
                                </div>
                                <div class="progress progress-sm" style="stroke-dasharray: 282.6, 282.6; stroke-dashoffset: 282.6;">
                                    <div class="progress-bar bg-primary" style="width: 90%"></div>
                                </div>
                            </div>
                            <img src="assets/images/flag/de.svg" height="30" width="30" class="object-fit-cover rounded-circle">
                            <div class="w-100">
                                <div class="d-flex justify-content-between align-items-center fs-13">
                                    <p class="text-muted mb-1">Andorra</p>
                                </div>
                                <div class="progress progress-sm" style="stroke-dasharray: 282.6, 282.6; stroke-dashoffset: 282.6;">
                                    <div class="progress-bar bg-primary" style="width: 70%"></div>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-4 mb-5">
                            <img src="assets/images/flag/ru.svg" height="30" width="30" class="object-fit-cover rounded-circle">
                            <div class="w-100">
                                <div class="d-flex justify-content-between align-items-center fs-13">
                                    <p class="text-muted mb-1">French</p>
                                </div>
                                <div class="progress progress-sm" style="stroke-dasharray: 282.6, 282.6; stroke-dashoffset: 282.6;">
                                    <div class="progress-bar bg-primary" style="width: 70%"></div>
                                </div>
                            </div>
                            <img src="assets/images/flag/cn.svg" height="30" width="30" class="object-fit-cover rounded-circle">
                            <div class="w-100">
                                <div class="d-flex justify-content-between align-items-center fs-13">
                                    <p class="text-muted mb-1">Chinese</p>
                                </div>
                                <div class="progress progress-sm" style="stroke-dasharray: 282.6, 282.6; stroke-dashoffset: 282.6;">
                                    <div class="progress-bar bg-primary" style="width: 25%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xxl-4 col-lg-6">
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header pb-4 mb-2">
                                <h4>Latest Product</h4>
                                <div class="dropdown">
                                    <a href="javascript:void(0)" data-bs-toggle="dropdown" class="text-muted" aria-expanded="false">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="javascript:void(0)">This Week</a></li>
                                        <li><a class="dropdown-item" href="javascript:void(0)">This Month</a></li>
                                        <li><a class="dropdown-item" href="javascript:void(0)">This Year</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-body product-body bg-body m-4 mt-0">
                                <img src="assets/images/dashboard/shoeses.png" class="img-fluid mx-auto d-block product-img1" alt="Product Image">
                                <div class="m-4 mt-0 py-2 px-4 product-gradient">
                                    <div>
                                        <span class="fs-12">Shoe</span>
                                        <p class="fs-5 mb-0">Nike</p>
                                    </div>
                                    <div>
                                        <i class="bi bi-arrow-right-circle-fill fs-3"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-center">
                                    <img src="assets/images/dashboard/enhanced_image.png" class="img-fluid" alt="Enhanced Image">
                                </div>
                                <div class="d-flex gap-3 pt-4">
                                    <a href="#!" class="btn btn-outline-primary w-50">Login / Sign Up</a>
                                    <a href="#!" class="btn btn-primary w-50">Get Started</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>  </div>
        <div class="row">
            <div class="col-xxl-8">
                <div class="row h-100">
                    <div class="col-xl-4 col-sm-6">
                        <div class="card card-h-100">
                            <div class="card-body d-flex align-items-center justify-content-around">
                                <div class="h-48px w-50px position-relative d-flex justify-content-center align-items-center text-primary fs-4 rounded-3 shadow-lg border">
                                    <i class="bi bi-folder2-open"></i>
                                </div>
                                <div>
                                    <h3>$2,647 <i class="bi bi-graph-up-arrow text-success fw-normal fs-5"></i></h3>
                                    <span class="fs-5">Today's Sales</span>
                                    <p class="fs-12 mb-0">Sales Increment Rate</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-sm-6">
                        <div class="card card-h-100">
                            <div class="card-body d-flex align-items-center justify-content-around">
                                <div class="h-48px w-50px position-relative d-flex justify-content-center align-items-center text-primary fs-4 rounded-3 shadow-lg border">
                                    <i class="bi bi-bookmark"></i>
                                </div>
                                <div>
                                    <h3>$24,057 <i class="bi bi-graph-up-arrow text-success fw-normal fs-5"></i></h3>
                                    <span class="fs-5">Total Purchase</span>
                                    <p class="fs-12 mb-0"><span class="text-success">+8%</span> Completion Rate</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-sm-6">
                        <div class="card card-h-100">
                            <div class="card-body d-flex align-items-center justify-content-around">
                                <div class="h-48px w-48px position-relative d-flex justify-content-center align-items-center text-primary fs-4 rounded-3 shadow-lg border">
                                    <i class="bi bi-bookmark"></i>
                                </div>
                                <div>
                                    <h3>47% <i class="bi bi-graph-up-arrow text-success fw-normal fs-5"></i></h3>
                                    <span class="fs-5">Overall Performance</span>
                                    <p class="fs-12 mb-0"><span class="text-success">+12%</span>Completion Rate</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xxl-4">
                <div class="card overflow-hidden bg-primary card-h-100 p-4">
                    <div class="row">
                        <div class="col-8">
                            <div class="vector-image">
                                <img class="img-fluid welcome-img w-200px mb-n20 mt-n5" src="assets/images/dashboard/upgrade-img.png" alt="CRM Vector">
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="text-end">
                                <p class="mb-5 fs-16 fw-semibold text-white">Lorem ipsum dolor <br> sit lorem ipsum <br> dolor sit</p>
                                <a href="javascript:void(0)" class="btn text-white border border-white mt-1">Upgrade</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </

    </div> -->

    <!-- Submit Section -->
</main>

<script src="assets/libs/echarts/echarts.min.js"></script>
<script>
  const API = '${pageContext.request.contextPath}/api';
  let lastAnalytics = null;
  function safeParseJson(t){ try{ return JSON.parse(t);}catch(_){ return null; } }
  async function fetchText(url, options){ const r=await fetch(url, options||{}); const tx=await r.text(); return { ok:r.ok, status:r.status, text:tx, json:safeParseJson(tx)||{} } }
  async function loadOrganizationsCount(){ try{ console.group('loadOrganizationsCount'); const {json,text}=await fetchText(API+'/organizations'); console.log('organizations response', text); const rows = Array.isArray(json)?json:(json.organizations||json.data||[]); document.getElementById('org_count').textContent = (rows||[]).length; console.groupEnd(); } catch(e){ console.error('loadOrganizationsCount error', e); } }
  async function loadTicketStats(){ try{ console.group('loadTicketStats'); const {json,text}=await fetchText(API+'/tickets/stats'); console.log('stats response', text); const stats = json.analytics || json.stats || json.data || json || {}; const open = (stats.open_tickets!=null)?stats.open_tickets:(stats.open!=null)?stats.open:(stats.open_count||0); const inProgress = (stats.in_progress_tickets!=null)?stats.in_progress_tickets:(stats.in_progress!=null)?stats.in_progress:(stats.in_progress_count||0); const resolved = (stats.resolved_tickets!=null)?stats.resolved_tickets:(stats.resolved!=null)?stats.resolved:(stats.resolved_count||0); const closed = (stats.closed_tickets!=null)?stats.closed_tickets:(stats.closed!=null)?stats.closed:(stats.closed_count||0); const total = (stats.total_tickets!=null)?stats.total_tickets:((stats.total||stats.total_count)||(open+inProgress+resolved+closed)); document.getElementById('ticket_total_count').textContent = total; document.getElementById('status_open_count').textContent = open; document.getElementById('status_in_progress_count').textContent = inProgress; document.getElementById('status_resolved_count').textContent = resolved; document.getElementById('status_closed_count').textContent = closed; renderStatusPie({open,inProgress,resolved,closed}); lastAnalytics = stats; console.groupEnd(); } catch(e){ console.error('loadTicketStats error', e); } }
  async function loadPriorityCounts(){ try{ console.group('loadPriorityCounts'); const counts={critical:0,high:0,medium:0,low:0}; if(lastAnalytics && Array.isArray(lastAnalytics.by_priority)){ lastAnalytics.by_priority.forEach(function(it){ const name=String(it.priority_name||it.name||'').toLowerCase(); const c=Number(it.count||it.total||0); if(name.includes('crit')) counts.critical=c; else if(name.includes('high')) counts.high=c; else if(name.includes('med')) counts.medium=c; else if(name.includes('low')) counts.low=c; }); } document.getElementById('priority_critical_count').textContent = counts.critical; document.getElementById('priority_high_count').textContent = counts.high; renderPriorityBar(counts); console.groupEnd(); } catch(e){ console.error('loadPriorityCounts error', e); } }
  function renderStatusPie(data){ try{ const el=document.getElementById('status_pie_chart'); if(!el || !window.echarts) return; const chart=echarts.init(el); const option={ tooltip:{}, legend:{ top:0 }, series:[{ type:'pie', radius:['40%','70%'], avoidLabelOverlap:true, label:{ show:true }, data:[ {value:data.open||0, name:'Open'}, {value:data.inProgress||0, name:'In Progress'}, {value:data.resolved||0, name:'Resolved'}, {value:data.closed||0, name:'Closed'} ] }]}; chart.setOption(option); }catch(e){ console.error('renderStatusPie error',e); } }
  function renderPriorityBar(counts){ try{ const el=document.getElementById('priority_bar_chart'); if(!el || !window.echarts) return; const chart=echarts.init(el); const option={ tooltip:{}, xAxis:{ type:'category', data:['Critical','High','Medium','Low'] }, yAxis:{ type:'value' }, series:[{ type:'bar', data:[ counts.critical||0, counts.high||0, counts.medium||0, counts.low||0 ], itemStyle:{ color:'#2b8a3e' } }]}; chart.setOption(option); }catch(e){ console.error('renderPriorityBar error',e); } }
  document.addEventListener('DOMContentLoaded', async function(){
    await loadOrganizationsCount();
    await loadTicketStats();
    await loadPriorityCounts();
  });
</script>
