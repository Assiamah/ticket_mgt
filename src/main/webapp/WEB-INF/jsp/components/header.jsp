<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    /* Global Theme Variables - Matched with Sidebar */
    :root {
        --sidebar-expanded: 280px;
        --sidebar-collapsed: 80px;
        --header-height: 70px;
        --sidebar-width: var(--sidebar-expanded);
        --sidebar-collapsed-width: var(--sidebar-collapsed);
        --primary-color: #6366f1;
        --primary-hover: #4f46e5;
        --primary-subtle: #eef2ff;
        --danger-color: #ef4444;
        --success-color: #10b981;
        --warning-color: #f59e0b;
        --bg-light: #ffffff;
        --bg-dark: #1e293b;
        --text-light: #64748b;
        --text-dark: #94a3b8;
        --text-active-light: #1e293b;
        --text-active-dark: #f1f5f9;
        --border-light: #e2e8f0;
        --border-dark: #334155;
        --hover-bg-light: #f8fafc;
        --hover-bg-dark: #334155;
        --active-bg-light: #eef2ff;
        --active-bg-dark: #475569;
        --radius-md: 12px;
        --radius-sm: 8px;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.1);
    }

    /* Header Container - Synchronized with Sidebar */
    header.app-header#appHeader {
        position: fixed !important;
        top: 0 !important;
        left: var(--sidebar-expanded) !important;
        right: 0 !important;
        height: var(--header-height) !important;
        background: var(--bg-light) !important;
        border-bottom: 1px solid var(--border-light) !important;
        z-index: 1000 !important;
        transition: var(--transition) !important;
        backdrop-filter: blur(10px) !important;
        -webkit-backdrop-filter: blur(10px) !important;
        box-shadow: var(--shadow-sm) !important;
    }

    [data-theme="dark"] header.app-header#appHeader {
        background: var(--bg-dark) !important;
        border-bottom: 1px solid var(--border-dark) !important;
    }

    /* Header Adjustment for Collapsed Sidebar */
    body.sidebar-collapsed header.app-header#appHeader {
        left: var(--sidebar-collapsed) !important;
    }

    @media (max-width: 768px) {
        header.app-header#appHeader {
            left: 0 !important;
        }
    }
    .app-wrapper {
        padding-top: calc(1.5rem + var(--header-height)) !important;
        margin-left: var(--sidebar-width) !important;
    }
    body.sidebar-collapsed .app-wrapper {
        margin-left: var(--sidebar-collapsed-width) !important;
    }
    @media (max-width: 768px) {
        .app-wrapper { margin-left: 0 !important; }
    }

    /* Header Inner Container */
    header.app-header#appHeader .header-container {
        width: 100% !important;
        height: 100% !important;
        padding: 0 24px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: space-between !important;
    }

    /* Header Left Section */
    header.app-header#appHeader .header-left {
        display: flex !important;
        align-items: center !important;
        gap: 16px !important;
        flex: 1 !important;
    }

    /* Header Right Section */
    header.app-header#appHeader .header-right {
        display: flex !important;
        align-items: center !important;
        gap: 12px !important;
    }

    /* Sidebar Toggle Button */
    header.app-header#appHeader .sidebar-toggle-btn {
        width: 40px !important;
        height: 40px !important;
        border-radius: var(--radius-sm) !important;
        border: 1px solid var(--border-light) !important;
        background: transparent !important;
        color: var(--text-light) !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        cursor: pointer !important;
        transition: var(--transition) !important;
        font-size: 1.25rem !important;
    }

    [data-theme="dark"] header.app-header#appHeader .sidebar-toggle-btn {
        border-color: var(--border-dark) !important;
        color: var(--text-dark) !important;
    }

    header.app-header#appHeader .sidebar-toggle-btn:hover {
        background: var(--hover-bg-light) !important;
        border-color: var(--primary-color) !important;
        color: var(--primary-color) !important;
        transform: translateY(-1px) !important;
        box-shadow: 0 2px 8px rgba(99, 102, 241, 0.2) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .sidebar-toggle-btn:hover {
        background: var(--hover-bg-dark) !important;
    }

    /* Search Bar */
    header.app-header#appHeader .header-search {
        position: relative !important;
        flex: 0 1 400px !important;
    }

    header.app-header#appHeader .search-input {
        width: 100% !important;
        height: 40px !important;
        padding: 0 16px 0 44px !important;
        border-radius: var(--radius-md) !important;
        border: 1px solid var(--border-light) !important;
        background: var(--hover-bg-light) !important;
        color: var(--text-active-light) !important;
        font-size: 14px !important;
        font-weight: 500 !important;
        transition: var(--transition) !important;
        cursor: pointer !important;
    }

    [data-theme="dark"] header.app-header#appHeader .search-input {
        background: var(--hover-bg-dark) !important;
        border-color: var(--border-dark) !important;
        color: var(--text-active-dark) !important;
    }

    header.app-header#appHeader .search-input:hover {
        border-color: var(--primary-color) !important;
        background: var(--bg-light) !important;
        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .search-input:hover {
        background: var(--bg-dark) !important;
    }

    header.app-header#appHeader .search-icon {
        position: absolute !important;
        left: 16px !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        color: var(--text-light) !important;
        font-size: 1.1rem !important;
        pointer-events: none !important;
    }

    /* Search Shortcut Badge */
    header.app-header#appHeader .search-shortcut {
        position: absolute !important;
        right: 12px !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        background: var(--primary-color) !important;
        color: white !important;
        font-size: 11px !important;
        font-weight: 600 !important;
        padding: 2px 8px !important;
        border-radius: 6px !important;
        border: 2px solid var(--bg-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .search-shortcut {
        border-color: var(--bg-dark) !important;
    }

    /* Header Actions */
    header.app-header#appHeader .header-actions {
        display: flex !important;
        align-items: center !important;
        gap: 8px !important;
    }

    /* Action Buttons */
    header.app-header#appHeader .action-btn {
        width: 40px !important;
        height: 40px !important;
        border-radius: var(--radius-sm) !important;
        border: 1px solid var(--border-light) !important;
        background: transparent !important;
        color: var(--text-light) !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        cursor: pointer !important;
        transition: var(--transition) !important;
        position: relative !important;
        font-size: 1.25rem !important;
    }

    [data-theme="dark"] header.app-header#appHeader .action-btn {
        border-color: var(--border-dark) !important;
        color: var(--text-dark) !important;
    }

    header.app-header#appHeader .action-btn:hover {
        background: var(--hover-bg-light) !important;
        border-color: var(--primary-color) !important;
        color: var(--primary-color) !important;
        transform: translateY(-1px) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .action-btn:hover {
        background: var(--hover-bg-dark) !important;
    }

    /* Notification Badge */
    header.app-header#appHeader .notification-badge {
        position: absolute !important;
        top: -4px !important;
        right: -4px !important;
        width: 18px !important;
        height: 18px !important;
        background: linear-gradient(135deg, var(--danger-color), #dc2626) !important;
        color: white !important;
        font-size: 10px !important;
        font-weight: 600 !important;
        border-radius: 50% !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        border: 2px solid var(--bg-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .notification-badge {
        border-color: var(--bg-dark) !important;
        background: linear-gradient(135deg, #dc2626, #b91c1c) !important;
    }

    /* Cart Badge */
    header.app-header#appHeader .cart-badge {
        position: absolute !important;
        top: -4px !important;
        right: -4px !important;
        width: 18px !important;
        height: 18px !important;
        background: linear-gradient(135deg, var(--warning-color), #d97706) !important;
        color: white !important;
        font-size: 10px !important;
        font-weight: 600 !important;
        border-radius: 50% !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        border: 2px solid var(--bg-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .cart-badge {
        border-color: var(--bg-dark) !important;
        background: linear-gradient(135deg, #d97706, #b45309) !important;
    }

    /* Theme Toggle */
    header.app-header#appHeader .theme-toggle {
        display: flex !important;
        background: var(--hover-bg-light) !important;
        border-radius: var(--radius-md) !important;
        padding: 4px !important;
        border: 1px solid var(--border-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .theme-toggle {
        background: var(--hover-bg-dark) !important;
        border-color: var(--border-dark) !important;
    }

    header.app-header#appHeader .theme-btn {
        width: 36px !important;
        height: 36px !important;
        border-radius: var(--radius-sm) !important;
        border: none !important;
        background: transparent !important;
        color: var(--text-light) !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        cursor: pointer !important;
        transition: var(--transition) !important;
        font-size: 1.1rem !important;
    }

    header.app-header#appHeader .theme-btn.active {
        background: var(--primary-color) !important;
        color: white !important;
        box-shadow: 0 2px 8px rgba(99, 102, 241, 0.3) !important;
    }

    /* Profile Dropdown */
    header.app-header#appHeader .profile-dropdown {
        margin-left: 8px !important;
    }

    header.app-header#appHeader .profile-btn {
        display: flex !important;
        align-items: center !important;
        gap: 12px !important;
        padding: 8px 12px !important;
        border-radius: var(--radius-md) !important;
        border: 1px solid var(--border-light) !important;
        background: transparent !important;
        cursor: pointer !important;
        transition: var(--transition) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .profile-btn {
        border-color: var(--border-dark) !important;
    }

    header.app-header#appHeader .profile-btn:hover {
        background: var(--hover-bg-light) !important;
        border-color: var(--primary-color) !important;
        transform: translateY(-1px) !important;
        box-shadow: var(--shadow-sm) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .profile-btn:hover {
        background: var(--hover-bg-dark) !important;
    }

    header.app-header#appHeader .profile-avatar {
        width: 36px !important;
        height: 36px !important;
        border-radius: 50% !important;
        background: linear-gradient(135deg, var(--primary-color), var(--primary-hover)) !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        color: white !important;
        font-weight: 600 !important;
        font-size: 14px !important;
        border: 2px solid var(--bg-light) !important;
        transition: var(--transition) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .profile-avatar {
        border-color: var(--bg-dark) !important;
    }

    header.app-header#appHeader .profile-btn:hover .profile-avatar {
        transform: scale(1.05) !important;
        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2) !important;
    }

    header.app-header#appHeader .profile-info {
        text-align: left !important;
    }

    header.app-header#appHeader .profile-name {
        font-size: 14px !important;
        font-weight: 600 !important;
        color: var(--text-active-light) !important;
        margin: 0 !important;
        white-space: nowrap !important;
    }

    [data-theme="dark"] header.app-header#appHeader .profile-name {
        color: var(--text-active-dark) !important;
    }

    header.app-header#appHeader .profile-email {
        font-size: 12px !important;
        color: var(--text-light) !important;
        margin: 2px 0 0 0 !important;
        white-space: nowrap !important;
    }

    [data-theme="dark"] header.app-header#appHeader .profile-email {
        color: var(--text-dark) !important;
    }

    header.app-header#appHeader .profile-arrow {
        color: var(--text-light) !important;
        font-size: 1.2rem !important;
        transition: transform 0.3s !important;
    }

    header.app-header#appHeader .profile-btn[aria-expanded="true"] .profile-arrow {
        transform: rotate(180deg) !important;
    }

    /* Dropdown Menu */
    header.app-header#appHeader .dropdown-menu {
        background: var(--bg-light) !important;
        border: 1px solid var(--border-light) !important;
        border-radius: var(--radius-md) !important;
        box-shadow: var(--shadow-lg) !important;
        padding: 0 !important;
        min-width: 280px !important;
        overflow: hidden !important;
        margin-top: 8px !important;
    }

    [data-theme="dark"] header.app-header#appHeader .dropdown-menu {
        background: var(--bg-dark) !important;
        border-color: var(--border-dark) !important;
    }

    header.app-header#appHeader .dropdown-header {
        padding: 16px !important;
        border-bottom: 1px solid var(--border-light) !important;
        background: var(--hover-bg-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .dropdown-header {
        border-color: var(--border-dark) !important;
        background: var(--hover-bg-dark) !important;
    }

    header.app-header#appHeader .dropdown-body {
        padding: 8px 0 !important;
    }

    header.app-header#appHeader .dropdown-item {
        padding: 12px 16px !important;
        color: var(--text-light) !important;
        text-decoration: none !important;
        display: flex !important;
        align-items: center !important;
        gap: 12px !important;
        transition: var(--transition) !important;
        border: none !important;
        background: transparent !important;
        width: 100% !important;
        text-align: left !important;
        font-size: 14px !important;
        font-weight: 500 !important;
    }

    [data-theme="dark"] header.app-header#appHeader .dropdown-item {
        color: var(--text-dark) !important;
    }

    header.app-header#appHeader .dropdown-item:hover {
        background: var(--hover-bg-light) !important;
        color: var(--text-active-light) !important;
        padding-left: 20px !important;
    }

    [data-theme="dark"] header.app-header#appHeader .dropdown-item:hover {
        background: var(--hover-bg-dark) !important;
        color: var(--text-active-dark) !important;
    }

    header.app-header#appHeader .dropdown-item i {
        width: 20px !important;
        text-align: center !important;
        font-size: 1.1rem !important;
    }

    header.app-header#appHeader .dropdown-item.text-danger {
        color: var(--danger-color) !important;
    }

    header.app-header#appHeader .dropdown-item.text-danger:hover {
        background: rgba(239, 68, 68, 0.1) !important;
    }

    /* Notification Dropdown Specific */
    header.app-header#appHeader .notification-dropdown {
        min-width: 360px !important;
        max-height: 500px !important;
        overflow-y: auto !important;
    }

    header.app-header#appHeader .notification-item {
        padding: 12px 16px !important;
        border-bottom: 1px solid var(--border-light) !important;
        transition: var(--transition) !important;
        display: flex !important;
        gap: 12px !important;
    }

    [data-theme="dark"] header.app-header#appHeader .notification-item {
        border-color: var(--border-dark) !important;
    }

    header.app-header#appHeader .notification-item:hover {
        background: var(--hover-bg-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .notification-item:hover {
        background: var(--hover-bg-dark) !important;
    }

    header.app-header#appHeader .notification-item:last-child {
        border-bottom: none !important;
    }

    header.app-header#appHeader .notification-icon {
        width: 40px !important;
        height: 40px !important;
        border-radius: 10px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        font-size: 1.2rem !important;
        flex-shrink: 0 !important;
    }

    header.app-header#appHeader .notification-content {
        flex: 1 !important;
    }

    header.app-header#appHeader .notification-title {
        font-size: 14px !important;
        font-weight: 600 !important;
        color: var(--text-active-light) !important;
        margin: 0 0 4px 0 !important;
    }

    [data-theme="dark"] header.app-header#appHeader .notification-title {
        color: var(--text-active-dark) !important;
    }

    header.app-header#appHeader .notification-time {
        font-size: 12px !important;
        color: var(--text-light) !important;
        margin: 0 !important;
    }

    [data-theme="dark"] header.app-header#appHeader .notification-time {
        color: var(--text-dark) !important;
    }

    /* Cart Dropdown Specific */
    header.app-header#appHeader .cart-dropdown {
        min-width: 320px !important;
    }

    header.app-header#appHeader .cart-item {
        padding: 12px 16px !important;
        border-bottom: 1px solid var(--border-light) !important;
        display: flex !important;
        align-items: center !important;
        gap: 12px !important;
    }

    [data-theme="dark"] header.app-header#appHeader .cart-item {
        border-color: var(--border-dark) !important;
    }

    header.app-header#appHeader .cart-item-image {
        width: 60px !important;
        height: 60px !important;
        border-radius: 8px !important;
        object-fit: cover !important;
        border: 1px solid var(--border-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .cart-item-image {
        border-color: var(--border-dark) !important;
    }

    header.app-header#appHeader .cart-item-details {
        flex: 1 !important;
    }

    header.app-header#appHeader .cart-item-name {
        font-size: 14px !important;
        font-weight: 600 !important;
        color: var(--text-active-light) !important;
        margin: 0 0 4px 0 !important;
    }

    [data-theme="dark"] header.app-header#appHeader .cart-item-name {
        color: var(--text-active-dark) !important;
    }

    header.app-header#appHeader .cart-item-quantity {
        font-size: 12px !important;
        color: var(--text-light) !important;
        margin: 0 !important;
    }

    [data-theme="dark"] header.app-header#appHeader .cart-item-quantity {
        color: var(--text-dark) !important;
    }

    header.app-header#appHeader .cart-item-price {
        font-size: 14px !important;
        font-weight: 600 !important;
        color: var(--text-active-light) !important;
    }

    [data-theme="dark"] header.app-header#appHeader .cart-item-price {
        color: var(--text-active-dark) !important;
    }

    /* Mobile Responsive */
    @media (max-width: 768px) {
        header.app-header#appHeader {
            left: 0 !important;
        }

        body.sidebar-collapsed header.app-header#appHeader {
            left: 0 !important;
        }

        header.app-header#appHeader .header-container {
            padding: 0 16px !important;
        }

        header.app-header#appHeader .header-search {
            flex: 0 1 200px !important;
        }

        header.app-header#appHeader .profile-info {
            display: none !important;
        }

        header.app-header#appHeader .profile-btn {
            padding: 8px !important;
        }

        header.app-header#appHeader .notification-dropdown,
        header.app-header#appHeader .cart-dropdown {
            position: fixed !important;
            top: var(--header-height) !important;
            left: 50% !important;
            transform: translateX(-50%) !important;
            width: 90vw !important;
            max-width: 400px !important;
        }
    }

    @media (max-width: 576px) {
        header.app-header#appHeader .header-search {
            display: none !important;
        }

        header.app-header#appHeader .header-actions {
            gap: 4px !important;
        }

        header.app-header#appHeader .d-none-mobile {
            display: none !important;
        }
    }
</style>

<header class="app-header" id="appHeader">
    <div class="header-container">
        <div class="header-left">
            <button class="sidebar-toggle-btn" id="toggleSidebar" aria-label="Toggle Sidebar">
                <i class="ri-menu-line"></i>
            </button>
            
            <!-- <div class="header-search d-none d-md-block">
                <input type="text" class="search-input" placeholder="Search for anything..." readonly data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="ri-search-line search-icon"></i>
                <span class="search-shortcut">Ctrl K</span>
            </div> -->
        </div>

        <div class="header-right">
            <div class="header-actions">
                <button class="action-btn d-md-none" data-bs-toggle="modal" data-bs-target="#searchModal" aria-label="Search">
                    <i class="ri-search-line"></i>
                </button>
                
                <div class="dropdown">
                    <button class="action-btn notification-btn" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Notifications">
                        <i class="ri-notification-3-line"></i>
                        <span class="notification-badge">3</span>
                    </button>
                    <div class="dropdown-menu dropdown-menu-end notification-dropdown">
                        <div class="dropdown-header">
                            <h6 class="mb-0 d-flex align-items-center">
                                Notifications
                                <span class="badge bg-primary-subtle text-primary ms-auto">3 Unread</span>
                            </h6>
                        </div>
                        <div class="dropdown-body">
                            <div class="notification-item">
                                <div class="notification-icon bg-primary-subtle text-primary">
                                    <i class="ri-shopping-cart-line"></i>
                                </div>
                                <div class="notification-content">
                                    <p class="notification-title">New Order Received</p>
                                    <p class="notification-time">2 minutes ago</p>
                                </div>
                            </div>
                            <div class="notification-item">
                                <div class="notification-icon bg-success-subtle text-success">
                                    <i class="ri-user-follow-line"></i>
                                </div>
                                <div class="notification-content">
                                    <p class="notification-title">New User Registered</p>
                                    <p class="notification-time">1 hour ago</p>
                                </div>
                            </div>
                            <div class="notification-item">
                                <div class="notification-icon bg-warning-subtle text-warning">
                                    <i class="ri-alert-line"></i>
                                </div>
                                <div class="notification-content">
                                    <p class="notification-title">Server Maintenance</p>
                                    <p class="notification-time">Tomorrow, 2:00 AM</p>
                                </div>
                            </div>
                        </div>
                        <div class="dropdown-header">
                            <a href="javascript:void(0)" class="text-primary text-decoration-none small">View all notifications</a>
                        </div>
                    </div>
                </div>
                
                <!-- <div class="dropdown">
                    <button class="action-btn cart-btn" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Cart">
                        <i class="ri-shopping-cart-2-line"></i>
                        <span class="cart-badge">2</span>
                    </button>
                    <div class="dropdown-menu dropdown-menu-end cart-dropdown">
                        <div class="dropdown-header">
                            <h6 class="mb-0">Cart Items</h6>
                            <span class="badge bg-primary-subtle text-primary">2</span>
                        </div>
                        <div class="dropdown-body">
                            <div class="cart-item">
                                <img src="${pageContext.request.contextPath}/assets/images/product/img-02.png" alt="Product" class="cart-item-image">
                                <div class="cart-item-details">
                                    <p class="cart-item-name">Wireless Headphones</p>
                                    <p class="cart-item-quantity">2 × $159.99</p>
                                </div>
                                <div class="cart-item-price">$319.98</div>
                            </div>
                            <div class="cart-item">
                                <img src="${pageContext.request.contextPath}/assets/images/product/img-03.png" alt="Product" class="cart-item-image">
                                <div class="cart-item-details">
                                    <p class="cart-item-name">Smart Watch</p>
                                    <p class="cart-item-quantity">1 × $299.99</p>
                                </div>
                                <div class="cart-item-price">$299.99</div>
                            </div>
                        </div>
                        <div class="dropdown-header">
                            <div class="d-flex justify-content-between align-items-center w-100">
                                <span>Total:</span>
                                <strong>$619.97</strong>
                            </div>
                        </div>
                        <div class="dropdown-header">
                            <div class="d-grid gap-2">
                                <a href="apps-ecommerce-cart.html" class="btn btn-outline-primary">View Cart</a>
                                <a href="apps-ecommerce-checkout.html" class="btn btn-primary">Checkout</a>
                            </div>
                        </div>
                    </div>
                </div> -->
                
                <!-- <button class="action-btn d-none d-md-block" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-label="Settings">
                    <i class="ri-settings-3-line"></i>
                </button> -->
                
                <div class="theme-toggle" id="toggleMode">
                    <button class="theme-btn active" id="lightModeBtn" type="button" aria-label="Switch to Light Mode">
                        <i class="ri-sun-line"></i>
                    </button>
                    <button class="theme-btn" id="darkModeBtn" type="button" aria-label="Switch to Dark Mode">
                        <i class="ri-moon-line"></i>
                    </button>
                </div>
            </div>
            
            <div class="dropdown profile-dropdown">
                <button class="profile-btn" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${not empty userInfo.first_name and not empty userInfo.last_name}">
                                ${fn:substring(userInfo.first_name, 0, 1)}${fn:substring(userInfo.last_name, 0, 1)}
                            </c:when>
                            <c:otherwise>
                                <i class="ri-user-line"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-info d-none d-xl-block">
                        <p class="profile-name">${userInfo.first_name} ${userInfo.last_name}</p>
                        <p class="profile-email">${userInfo.email}</p>
                    </div>
                    <i class="ri-arrow-down-s-line profile-arrow"></i>
                </button>
                <div class="dropdown-menu dropdown-menu-end">
                    <div class="dropdown-header">
                        <div class="d-flex align-items-center gap-3">
                            <div class="profile-avatar">
                                <c:choose>
                                    <c:when test="${not empty userInfo.first_name and not empty userInfo.last_name}">
                                        ${fn:substring(userInfo.first_name, 0, 1)}${fn:substring(userInfo.last_name, 0, 1)}
                                    </c:when>
                                    <c:otherwise>
                                        <i class="ri-user-line"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <p class="profile-name mb-1">${userInfo.first_name} ${userInfo.last_name}</p>
                                <p class="profile-email mb-0">${userInfo.email}</p>
                            </div>
                        </div>
                    </div>
                    <div class="dropdown-body">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                            <i class="ri-user-line"></i>
                            <span>My Profile</span>
                        </a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile/settings">
                            <i class="ri-settings-3-line"></i>
                            <span>Settings</span>
                        </a>
                        <a class="dropdown-item" href="javascript:void(0)">
                            <i class="ri-customer-service-2-line"></i>
                            <span>Support Center</span>
                        </a>
                        <a class="dropdown-item" href="javascript:void(0)">
                            <i class="ri-file-text-line"></i>
                            <span>Documentation</span>
                        </a>
                        <div class="dropdown-divider my-2"></div>
                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout" onclick="logoutLink(event, this)">
                            <i class="ri-logout-box-r-line"></i>
                            <span>Sign Out</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- Search Modal -->
<div class="modal fade" id="searchModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body p-0">
                <div class="input-group input-group-lg">
                    <input type="text" class="form-control border-0 py-3 px-4" placeholder="Search for anything..." autofocus>
                    <button class="btn btn-primary px-4" type="button">
                        <i class="ri-search-line"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Global User Context
    window.userInfo = {
        unique_id: "${userInfo.unique_id}",
        user_uuid: "${userInfo.user_uuid != null ? userInfo.user_uuid : userInfo.unique_id}",
        organization_uuid: "${userInfo.organization_uuid}",
        org_id: "${userInfo.org_id}",
        email: "${userInfo.email}",
        first_name: "${userInfo.first_name}",
        last_name: "${userInfo.last_name}",
        role: "${userInfo.role}"
    };

    window.ORG_CONTEXT = {
        organization_uuid: "${userInfo.organization_uuid}",
        organization_id: "${userInfo.org_id}"
    };
    
    // Log context for debugging
    console.log('[App] Context loaded', { user: window.userInfo.unique_id, org: window.ORG_CONTEXT.organization_uuid, org_id: window.ORG_CONTEXT.organization_id });
</script>

<script>
// Header JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Toggle Sidebar
    const toggleSidebarBtn = document.getElementById('toggleSidebar');
    if (toggleSidebarBtn) {
        toggleSidebarBtn.addEventListener('click', toggleSidebar);
    }

    // Initialize Dark Mode
    initDarkMode();

    // Initialize dropdown tooltips
    initDropdownTooltips();
});

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const isMobile = window.innerWidth <= 768;
    
    if (isMobile) {
        sidebar.classList.toggle('show');
        document.body.classList.toggle('sidebar-open');
        document.body.style.overflow = sidebar.classList.contains('show') ? 'hidden' : '';
    } else {
        sidebar.classList.toggle('collapsed');
        document.body.classList.toggle('sidebar-collapsed');
        localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
    }
    
    updateToggleIcon();
}

function updateToggleIcon() {
    const sidebar = document.getElementById('sidebar');
    const headerIcon = document.querySelector('.sidebar-toggle-btn i');
    
    if (sidebar.classList.contains('collapsed')) {
        headerIcon.className = 'ri-menu-line';
    } else {
        headerIcon.className = 'ri-menu-line';
    }
}

function initDarkMode() {
    const lightModeBtn = document.getElementById('lightModeBtn');
    const darkModeBtn = document.getElementById('darkModeBtn');
    const isDarkMode = localStorage.getItem('darkMode') === 'true';
    
    if (isDarkMode) {
        document.body.setAttribute('data-theme', 'dark');
        lightModeBtn.classList.remove('active');
        darkModeBtn.classList.add('active');
    } else {
        document.body.removeAttribute('data-theme');
        lightModeBtn.classList.add('active');
        darkModeBtn.classList.remove('active');
    }
    
    lightModeBtn.addEventListener('click', function() {
        document.body.removeAttribute('data-theme');
        lightModeBtn.classList.add('active');
        darkModeBtn.classList.remove('active');
        localStorage.setItem('darkMode', 'false');
    });
    
    darkModeBtn.addEventListener('click', function() {
        document.body.setAttribute('data-theme', 'dark');
        lightModeBtn.classList.remove('active');
        darkModeBtn.classList.add('active');
        localStorage.setItem('darkMode', 'true');
    });
}

function initDropdownTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

function logoutLink(event, element) {
    event.preventDefault();

    Swal.fire({
        title: "Ready to leave?",
        text: "Are you sure you want to sign out?",
        icon: "question",
        showCancelButton: true,
        confirmButtonColor: "#6366f1",
        cancelButtonColor: "#6b7280",
        confirmButtonText: "Yes, sign out",
        cancelButtonText: "Cancel",
        background: getComputedStyle(document.documentElement).getPropertyValue('--bg-light').trim(),
        color: getComputedStyle(document.documentElement).getPropertyValue('--text-active-light').trim(),
        customClass: {
            popup: 'border-radius-md shadow-lg',
            confirmButton: 'btn btn-primary px-4',
            cancelButton: 'btn btn-secondary px-4'
        },
        buttonsStyling: false
    }).then((result) => {
        if (result.isConfirmed) {
            // Add loading state
            const originalHtml = element.innerHTML;
            element.innerHTML = '<i class="ri-loader-4-line spin me-2"></i> Signing out...';
            element.disabled = true;
            
            // Perform logout
            setTimeout(() => {
                window.location.href = element.getAttribute('href');
            }, 800);
        }
    });
}

// Handle window resize
window.addEventListener('resize', function() {
    const sidebar = document.getElementById('sidebar');
    const isMobile = window.innerWidth <= 768;
    
    if (isMobile) {
        sidebar.classList.remove('collapsed');
        document.body.classList.remove('sidebar-collapsed');
        sidebar.classList.remove('show');
        document.body.classList.remove('sidebar-open');
        document.body.style.overflow = '';
    } else {
        sidebar.classList.remove('show');
        document.body.classList.remove('sidebar-open');
        document.body.style.overflow = '';
        
        // Restore collapsed state
        const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
        if (isCollapsed) {
            sidebar.classList.add('collapsed');
            document.body.classList.add('sidebar-collapsed');
        }
    }
    updateToggleIcon();
});
</script>
