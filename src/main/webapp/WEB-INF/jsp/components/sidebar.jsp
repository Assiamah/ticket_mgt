<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* Modern Sidebar Styles - High Priority Override */
    aside.pe-app-sidebar#sidebar {
        --sidebar-width: 280px;
        --sidebar-collapsed-width: 80px;
        --primary-color: #6366f1;
        --primary-hover: #4f46e5;
        --sidebar-bg: #ffffff;
        --sidebar-text: #64748b;
        --sidebar-text-active: #1e293b;
        --sidebar-hover-bg: #f8fafc;
        --sidebar-active-bg: #eef2ff;
        --border-color: #e2e8f0;
        --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        --border-radius: 0 20px 20px 0;
        --logout-gradient: linear-gradient(135deg, #ef4444, #dc2626);
        --logout-gradient-hover: linear-gradient(135deg, #dc2626, #b91c1c);
    }

    [data-theme="dark"] aside.pe-app-sidebar#sidebar {
        --sidebar-bg: #1e293b;
        --sidebar-text: #94a3b8;
        --sidebar-text-active: #f1f5f9;
        --sidebar-hover-bg: #334155;
        --sidebar-active-bg: #475569;
        --border-color: #334155;
        --logout-gradient: linear-gradient(135deg, #dc2626, #b91c1c);
        --logout-gradient-hover: linear-gradient(135deg, #b91c1c, #991b1b);
    }

    aside.pe-app-sidebar#sidebar {
        position: fixed !important;
        left: 0 !important;
        top: 0 !important;
        height: 100vh !important;
        width: var(--sidebar-width) !important;
        background: var(--sidebar-bg) !important;
        border-right: 1px solid var(--border-color) !important;
        display: flex !important;
        flex-direction: column !important;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
        z-index: 1000 !important;
        box-shadow: var(--shadow) !important;
        border-radius: var(--border-radius) !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed {
        width: var(--sidebar-collapsed-width) !important;
        border-radius: 0 12px 12px 0 !important;
    }

    aside.pe-app-sidebar#sidebar .pe-app-sidebar-logo {
        height: 70px !important;
        padding: 0 1.5rem !important;
        display: flex !important;
        align-items: center !important;
        border-bottom: 1px solid var(--border-color) !important;
        position: relative !important;
        background: var(--sidebar-bg) !important;
    }

    aside.pe-app-sidebar#sidebar .logo-main {
        text-decoration: none !important;
        display: flex !important;
        align-items: center !important;
        gap: 0.75rem !important;
        transition: opacity 0.3s !important;
    }

    aside.pe-app-sidebar#sidebar .logo-main:hover {
        opacity: 0.8 !important;
    }

    aside.pe-app-sidebar#sidebar .logo-main h3 {
        font-size: 1.5rem !important;
        font-weight: 700 !important;
        color: var(--sidebar-text-active) !important;
        margin: 0 !important;
        white-space: nowrap !important;
        transition: opacity 0.3s !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .logo-main h3 {
        opacity: 0 !important;
        width: 0 !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar .sidebar-toggle {
        position: absolute !important;
        right: 12px !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        width: 32px !important;
        height: 32px !important;
        background: var(--primary-color) !important;
        border: 2px solid var(--sidebar-bg) !important;
        border-radius: 50% !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        cursor: pointer !important;
        transition: all 0.3s !important;
        color: white !important;
        font-size: 14px !important;
        box-shadow: 0 2px 8px rgba(99, 102, 241, 0.3) !important;
        z-index: 1001 !important;
    }

    aside.pe-app-sidebar#sidebar .sidebar-toggle:hover {
        background: var(--primary-hover) !important;
        transform: translateY(-50%) scale(1.1) !important;
        box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4) !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .sidebar-toggle {
        right: 50% !important;
        transform: translate(50%, -50%) !important;
    }

    aside.pe-app-sidebar#sidebar .pe-app-sidebar-menu {
        flex: 1 !important;
        overflow-y: auto !important;
        overflow-x: hidden !important;
        padding: 1rem 0 !important;
        display: flex !important;
        flex-direction: column !important;
    }

    aside.pe-app-sidebar#sidebar .pe-app-sidebar-menu::-webkit-scrollbar {
        width: 6px !important;
    }

    aside.pe-app-sidebar#sidebar .pe-app-sidebar-menu::-webkit-scrollbar-thumb {
        background: var(--border-color) !important;
        border-radius: 3px !important;
    }

    aside.pe-app-sidebar#sidebar .pe-main-menu {
        padding: 0 !important;
        margin: 0 !important;
        flex: 1 !important;
    }

    aside.pe-app-sidebar#sidebar .pe-menu-title {
        padding: 1rem 1.5rem 0.5rem !important;
        font-size: 0.75rem !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.05em !important;
        color: var(--sidebar-text) !important;
        opacity: 0.7 !important;
        transition: opacity 0.3s !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .pe-menu-title {
        opacity: 0 !important;
        height: 0 !important;
        padding: 0 !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar .pe-slide {
        margin: 0.25rem 0.75rem !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-link {
        display: flex !important;
        align-items: center !important;
        gap: 0.75rem !important;
        padding: 0.75rem 1rem !important;
        color: var(--sidebar-text) !important;
        text-decoration: none !important;
        border-radius: 0.5rem !important;
        transition: all 0.2s ease !important;
        position: relative !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-link::before {
        content: '' !important;
        position: absolute !important;
        left: 0 !important;
        top: 0 !important;
        height: 100% !important;
        width: 3px !important;
        background: var(--primary-color) !important;
        transform: scaleY(0) !important;
        transition: transform 0.2s ease !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-link:hover {
        background: var(--sidebar-hover-bg) !important;
        color: var(--sidebar-text-active) !important;
        transform: translateX(2px) !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-link.active {
        background: var(--sidebar-active-bg) !important;
        color: var(--primary-color) !important;
        font-weight: 600 !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-link.active::before {
        transform: scaleY(1) !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-icon {
        font-size: 1.25rem !important;
        min-width: 24px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        transition: transform 0.2s !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-icon svg {
        width: 20px !important;
        height: 20px !important;
        stroke: currentColor !important;
        stroke-width: 2px !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-link:hover .pe-nav-icon {
        transform: scale(1.1) !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-content {
        flex: 1 !important;
        white-space: nowrap !important;
        transition: opacity 0.3s !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .pe-nav-content {
        opacity: 0 !important;
        width: 0 !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-arrow {
        font-size: 1rem !important;
        transition: transform 0.3s !important;
    }

    aside.pe-app-sidebar#sidebar .pe-nav-link[aria-expanded="true"] .pe-nav-arrow {
        transform: rotate(-180deg) !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .pe-nav-arrow {
        opacity: 0 !important;
    }

    aside.pe-app-sidebar#sidebar .pe-slide-menu {
        list-style: none !important;
        padding: 0 !important;
        margin: 0.5rem 0 0 0 !important;
        max-height: 0 !important;
        overflow: hidden !important;
        transition: max-height 0.3s ease !important;
    }

    aside.pe-app-sidebar#sidebar .pe-slide-menu.show {
        max-height: 500px !important;
    }

    aside.pe-app-sidebar#sidebar .pe-slide-item {
        margin: 0.25rem 0 !important;
    }

    aside.pe-app-sidebar#sidebar .pe-slide-item .pe-nav-link {
        padding: 0.5rem 1rem 0.5rem 3.25rem !important;
        font-size: 0.9rem !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .pe-slide-menu {
        display: none !important;
    }

    /* Enhanced Logout Section */
    aside.pe-app-sidebar#sidebar .sidebar-logout-section {
        margin-top: auto !important;
        padding: 1rem 1.5rem !important;
        border-top: 1px solid var(--border-color) !important;
        background: var(--sidebar-bg) !important;
        transition: all 0.3s ease !important;
    }

    aside.pe-app-sidebar#sidebar .user-info {
        margin-bottom: 1rem !important;
        transition: opacity 0.3s ease !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .user-info {
        opacity: 0 !important;
        height: 0 !important;
        margin: 0 !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar .user-avatar {
        width: 36px !important;
        height: 36px !important;
        border-radius: 50% !important;
        background: linear-gradient(135deg, var(--primary-color), var(--primary-hover)) !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        color: white !important;
        font-weight: 600 !important;
        margin-right: 0.75rem !important;
        font-size: 0.875rem !important;
    }

    aside.pe-app-sidebar#sidebar .user-details {
        flex: 1 !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar .user-name {
        font-size: 0.875rem !important;
        font-weight: 600 !important;
        color: var(--sidebar-text-active) !important;
        margin: 0 !important;
        white-space: nowrap !important;
        overflow: hidden !important;
        text-overflow: ellipsis !important;
    }

    aside.pe-app-sidebar#sidebar .user-role {
        font-size: 0.75rem !important;
        color: var(--sidebar-text) !important;
        margin: 0.25rem 0 0 0 !important;
        white-space: nowrap !important;
        overflow: hidden !important;
        text-overflow: ellipsis !important;
    }

    aside.pe-app-sidebar#sidebar .last-login {
        font-size: 0.75rem !important;
        color: var(--sidebar-text) !important;
        margin: 0.25rem 0 0 0 !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn-container {
        width: 100% !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn {
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        gap: 0.75rem !important;
        padding: 0.875rem 1.5rem !important;
        background: var(--logout-gradient) !important;
        color: white !important;
        border: none !important;
        border-radius: 12px !important;
        font-weight: 600 !important;
        font-size: 0.875rem !important;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
        cursor: pointer !important;
        width: 100% !important;
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25) !important;
        position: relative !important;
        overflow: hidden !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn::before {
        content: '' !important;
        position: absolute !important;
        top: 0 !important;
        left: -100% !important;
        width: 100% !important;
        height: 100% !important;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent) !important;
        transition: left 0.7s ease !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn:hover {
        background: var(--logout-gradient-hover) !important;
        transform: translateY(-2px) !important;
        box-shadow: 0 6px 20px rgba(239, 68, 68, 0.35) !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn:hover::before {
        left: 100% !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn:active {
        transform: translateY(0) !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn i {
        font-size: 1.125rem !important;
        transition: transform 0.3s !important;
    }

    aside.pe-app-sidebar#sidebar .logout-btn:hover i {
        transform: translateX(2px) !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .logout-btn {
        width: 48px !important;
        height: 48px !important;
        padding: 0 !important;
        border-radius: 50% !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .logout-btn span {
        display: none !important;
    }

    /* Badge for notifications */
    aside.pe-app-sidebar#sidebar .nav-badge {
        position: absolute !important;
        right: 1rem !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        background: var(--primary-color) !important;
        color: white !important;
        font-size: 0.7rem !important;
        padding: 0.2rem 0.5rem !important;
        border-radius: 1rem !important;
        font-weight: 600 !important;
    }

    /* Mobile responsive improvements */
    @media (max-width: 768px) {
        aside.pe-app-sidebar#sidebar {
            transform: translateX(-100%) !important;
            border-radius: 0 20px 20px 0 !important;
            width: var(--sidebar-width) !important;
        }

        aside.pe-app-sidebar#sidebar.show {
            transform: translateX(0) !important;
        }

        aside.pe-app-sidebar#sidebar.show .sidebar-toggle {
            right: 12px !important;
            transform: translateY(-50%) !important;
        }

        .sidebar-overlay {
            position: fixed !important;
            inset: 0 !important;
            background: rgba(0, 0, 0, 0.5) !important;
            backdrop-filter: blur(4px) !important;
            z-index: 999 !important;
            opacity: 0 !important;
            pointer-events: none !important;
            transition: opacity 0.3s ease-in-out !important;
        }

        .sidebar-overlay.show {
            opacity: 1 !important;
            pointer-events: all !important;
        }

        aside.pe-app-sidebar#sidebar.collapsed {
            width: var(--sidebar-width) !important;
            border-radius: 0 20px 20px 0 !important;
        }

        aside.pe-app-sidebar#sidebar.collapsed .sidebar-toggle {
            right: 12px !important;
            transform: translateY(-50%) !important;
        }
    }

    @media (max-width: 480px) {
        aside.pe-app-sidebar#sidebar {
            --sidebar-width: 260px !important;
            border-radius: 0 16px 16px 0 !important;
        }

        aside.pe-app-sidebar#sidebar .sidebar-logout-section {
            padding: 0.875rem 1.25rem !important;
        }

        aside.pe-app-sidebar#sidebar .logout-btn {
            padding: 0.75rem 1.25rem !important;
        }
    }

    /* Tooltip for collapsed state */
    aside.pe-app-sidebar#sidebar.collapsed .pe-nav-link {
        position: relative !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .pe-nav-link:hover::after {
        content: attr(data-title) !important;
        position: absolute !important;
        left: 100% !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        margin-left: 1rem !important;
        padding: 0.5rem 1rem !important;
        background: var(--sidebar-text-active) !important;
        color: white !important;
        border-radius: 0.5rem !important;
        white-space: nowrap !important;
        z-index: 1000 !important;
        font-size: 0.875rem !important;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important;
        pointer-events: none !important;
    }

    aside.pe-app-sidebar#sidebar.collapsed .logout-btn:hover::after {
        content: "Sign Out" !important;
        position: absolute !important;
        left: 100% !important;
        top: 50% !important;
        transform: translateY(-50%) !important;
        margin-left: 1rem !important;
        padding: 0.5rem 1rem !important;
        background: var(--sidebar-text-active) !important;
        color: white !important;
        border-radius: 0.5rem !important;
        white-space: nowrap !important;
        z-index: 1000 !important;
        font-size: 0.875rem !important;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important;
        pointer-events: none !important;
    }

    /* Smooth scrollbar for all browsers */
    aside.pe-app-sidebar#sidebar .pe-app-sidebar-menu {
        scrollbar-width: thin !important;
        scrollbar-color: var(--border-color) transparent !important;
    }
</style>

<aside class="pe-app-sidebar" id="sidebar">
    <div class="pe-app-sidebar-logo px-6 d-flex align-items-center position-relative">
        <a href="index.html" class="d-flex align-items-end logo-main">
            <img height="35" width="34" class="logo-dark" alt="Dark Logo" src="${pageContext.request.contextPath}/assets/images/logo-md.png">
            <img height="35" width="34" class="logo-light" alt="Light Logo" src="${pageContext.request.contextPath}/assets/images/logo-md-light.png">
            <h3 class="text-body-emphasis fw-bolder mb-0 ms-1">Urbix</h3>
        </a>
        <div class="sidebar-toggle" onclick="toggleSidebar()">
            <i class="ri-arrow-left-s-line"></i>
        </div>
    </div>

    <nav class="pe-app-sidebar-menu nav nav-pills d-flex flex-column" data-simplebar id="sidebar-simplebar" style="height:100%;">
        <div class="flex-grow-1 d-flex flex-column w-100">
            <%-- Debug Menu Data --%>
            <c:if test="${empty menus}">
                <div style="color: red; padding: 10px;">Warning: Session 'menus' is empty!</div>
            </c:if>
            <ul class="pe-main-menu list-unstyled">
                <c:forEach var="menu" items="${menus}">
                    <c:set var="isActive" value="${currentRoute == menu.route}" />

                    <c:if test="${not empty menu.children}">
                        <c:forEach var="child" items="${menu.children}">
                            <c:if test="${currentRoute == child.route}">
                                <c:set var="isActive" value="true" />
                            </c:if>
                        </c:forEach>
                    </c:if>

                    <c:if test="${menu.category ne 'title'}">
                        <li class="pe-slide ${not empty menu.children ? 'pe-has-sub' : ''}">
                            <c:choose>
                                <c:when test="${not empty menu.children}">
                                    <a href="#collapse${menu.id}"
                                       class="pe-nav-link ${isActive ? 'active' : ''}"
                                       data-bs-toggle="collapse"
                                       aria-expanded="${isActive}"
                                       aria-controls="collapse${menu.id}"
                                       data-title="${menu.title}">
                                        <span class="pe-nav-icon">
                                            <c:choose>
                                                <c:when test="${menu.title eq 'Dashboard'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Tickets'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 9V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.96 1.7L10 6a2 2 0 0 0 2 2h0a2 2 0 0 0 2-2l.14-1.3a2 2 0 0 1 1.96-1.7H20a2 2 0 0 1 2 2v4"/><path d="M2 15v4a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-4"/><rect width="20" height="6" x="2" y="9" rx="2"/><path d="M7 12h.01"/><path d="M17 12h.01"/></svg>
                                                </c:when>
                                                <c:when test="${menu.category eq 'User Management' || menu.title eq 'Accounts' || menu.title eq 'Profile'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Organizations'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="16" height="20" x="4" y="2" rx="2" ry="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01"/><path d="M16 6h.01"/><path d="M8 10h.01"/><path d="M16 10h.01"/><path d="M8 14h.01"/><path d="M16 14h.01"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Products'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Analytics'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                                                </c:when>
                                                <c:otherwise>
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="pe-nav-content">${menu.title}</span>
                                        <i class="ri-arrow-down-s-line pe-nav-arrow"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}${menu.route}"
                                       class="pe-nav-link ${isActive ? 'active' : ''}"
                                       data-title="${menu.title}">
                                        <span class="pe-nav-icon">
                                            <c:choose>
                                                <c:when test="${menu.title eq 'Dashboard'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Accounts'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Profile'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Organizations'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="16" height="20" x="4" y="2" rx="2" ry="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01"/><path d="M16 6h.01"/><path d="M8 10h.01"/><path d="M16 10h.01"/><path d="M8 14h.01"/><path d="M16 14h.01"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Products'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
                                                </c:when>
                                                <c:when test="${menu.title eq 'Analytics'}">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                                                </c:when>
                                                <c:otherwise>
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="pe-nav-content">${menu.title}</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${not empty menu.children}">
                                <ul class="pe-slide-menu collapse ${isActive ? 'show' : ''}" id="collapse${menu.id}">
                                    <c:forEach var="child" items="${menu.children}">
                                        <li class="pe-slide-item">
                                            <a href="${pageContext.request.contextPath}${child.route}"
                                            class="pe-nav-link ${currentRoute == child.route ? 'active' : ''}"
                                            data-title="${child.title}">
                                                ${child.title}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </li>
                    </c:if>
                </c:forEach>
                
                <%-- Explicitly add Organizations/Add Organization if missing from session menus --%>
                <c:set var="hasOrgMenu" value="false" />
                <c:forEach var="menu" items="${menus}">
                    <c:if test="${menu.title eq 'Organizations'}">
                        <c:set var="hasOrgMenu" value="true" />
                    </c:if>
                </c:forEach>
                
                <c:if test="${!hasOrgMenu}">
                    <li class="pe-slide pe-has-sub">
                        <a href="#collapseOrgManual"
                           class="pe-nav-link ${currentRoute.startsWith('/organizations') ? 'active' : ''}"
                           data-bs-toggle="collapse"
                           aria-expanded="${currentRoute.startsWith('/organizations') ? 'true' : 'false'}"
                           aria-controls="collapseOrgManual"
                           data-title="Organizations">
                            <span class="pe-nav-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="16" height="20" x="4" y="2" rx="2" ry="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01"/><path d="M16 6h.01"/><path d="M8 10h.01"/><path d="M16 10h.01"/><path d="M8 14h.01"/><path d="M16 14h.01"/></svg>
                            </span>
                            <span class="pe-nav-content">Organizations</span>
                            <i class="ri-arrow-down-s-line pe-nav-arrow"></i>
                        </a>
                        <ul class="pe-slide-menu collapse ${currentRoute.startsWith('/organizations') ? 'show' : ''}" id="collapseOrgManual">
                            <li class="pe-slide-item">
                                <a href="${pageContext.request.contextPath}/organizations/archive"
                                   class="pe-nav-link ${currentRoute eq '/organizations/archive' ? 'active' : ''}"
                                   data-title="Organization Archive">
                                    Organization Archive
                                </a>
                            </li>
                            <li class="pe-slide-item">
                                <a href="${pageContext.request.contextPath}/organizations/add"
                                   class="pe-nav-link ${currentRoute eq '/organizations/add' ? 'active' : ''}"
                                   data-title="Add Organization">
                                    Add Organization
                                </a>
                            </li>
                        </ul>
                    </li>
                </c:if>
            </ul>
        </div>
        
        <!-- Enhanced Logout Section -->
        <div class="sidebar-logout-section">
            <div class="user-info d-flex align-items-center">
                <div class="user-avatar">
                    <c:choose>
                        <c:when test="${not empty userInitials}">
                            ${userInitials}
                        </c:when>
                        <c:otherwise>
                            <i class="ri-user-line"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="user-details">
                    <p class="user-name">
                        <c:choose>
                            <c:when test="${not empty userName}">
                                ${userName}
                            </c:when>
                            <c:otherwise>
                                ${not empty userInfo.role ? userInfo.role : 'User'}
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p class="user-role">
                        <c:choose>
                            <c:when test="${not empty userInfo.role}">
                                ${userInfo.role}
                            </c:when>
                            <c:otherwise>
                                Member
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p class="last-login">Last Login: ${lastLogin}</p>
                </div>
            </div>
            <div class="logout-btn-container">
                <button onclick="logoutLink(event, this)" 
                       class="logout-btn"
                       data-title="Sign Out">
                    <i class="ri-logout-box-r-line"></i>
                    <span>Sign Out</span>
                </button>
            </div>
        </div>
    </nav>
</aside>

<!-- Mobile overlay -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<script>
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    const isMobile = window.innerWidth <= 768;
    
    if (isMobile) {
        sidebar.classList.toggle('show');
        overlay.classList.toggle('show');
        // Prevent body scroll when sidebar is open on mobile
        document.body.style.overflow = sidebar.classList.contains('show') ? 'hidden' : '';
    } else {
        sidebar.classList.toggle('collapsed');
        document.body.classList.toggle('sidebar-collapsed');
        localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
    }
    updateToggleIcon();
}

// Restore sidebar state on page load
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
    
    if (isCollapsed && window.innerWidth > 768) {
        sidebar.classList.add('collapsed');
        document.body.classList.add('sidebar-collapsed');
    }
    
    // Update toggle icon based on state
    updateToggleIcon();
    
    // Add click event to close sidebar on mobile when clicking outside
    document.addEventListener('click', function(event) {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        const isMobile = window.innerWidth <= 768;
        
        if (isMobile && sidebar.classList.contains('show') && 
            !sidebar.contains(event.target) && 
            event.target !== overlay) {
            toggleSidebar();
        }
    });
});

function updateToggleIcon() {
    const sidebar = document.getElementById('sidebar');
    const toggleIcon = document.querySelector('.sidebar-toggle i');
    
    if (sidebar.classList.contains('collapsed')) {
        toggleIcon.className = 'ri-arrow-right-s-line';
    } else {
        toggleIcon.className = 'ri-arrow-left-s-line';
    }
}

function logoutLink(event, element) {
    event.preventDefault();
    // Add confirmation before logout
    if (confirm('Are you sure you want to sign out?')) {
        window.location.href = '${pageContext.request.contextPath}/logout';
    }
}

// Handle window resize
window.addEventListener('resize', function() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    
    if (window.innerWidth > 768) {
        // On desktop, make sure overlay is hidden
        overlay.classList.remove('show');
        sidebar.classList.remove('show');
        document.body.style.overflow = '';
        
        // Restore collapsed state if it was collapsed
        const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
        if (isCollapsed) {
            sidebar.classList.add('collapsed');
            document.body.classList.add('sidebar-collapsed');
        } else {
            sidebar.classList.remove('collapsed');
            document.body.classList.remove('sidebar-collapsed');
        }
    } else {
        // On mobile, make sure sidebar is hidden by default
        sidebar.classList.remove('collapsed');
        document.body.classList.remove('sidebar-collapsed');
        sidebar.classList.remove('show');
        overlay.classList.remove('show');
        document.body.style.overflow = '';
    }
    updateToggleIcon();
});

// Initialize on load
window.dispatchEvent(new Event('resize'));
</script>
