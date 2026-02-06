<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 <aside class="pe-app-sidebar" id="sidebar">
    <div class="pe-app-sidebar-logo px-6 d-flex align-items-center position-relative">
        <!-- Brand -->
        <a href="index.html" class="d-flex align-items-end logo-main">
            <img height="35" width="34" class="logo-dark" alt="Dark Logo" src="assets/images/logo-md.png">
            <img height="35" width="34" class="logo-light" alt="Light Logo" src="assets/images/logo-md-light.png">
            <h3 class="text-body-emphasis fw-bolder mb-0 ms-1">Urbix</h3>
        </a>
    </div>

    <nav class="pe-app-sidebar-menu nav nav-pills d-flex flex-column" data-simplebar id="sidebar-simplebar" style="height:100%;">
        <div class="flex-grow-1 d-flex flex-column w-100">
            <ul class="pe-main-menu list-unstyled">
                <c:set var="accountsExists" value="false" />
                <c:forEach var="menu" items="${menus}">
                    <c:set var="isActive" value="${currentRoute == menu.route}" />

                    <!-- Check children for active state -->
                    <c:forEach var="child" items="${menu.children}">
                        <c:if test="${currentRoute == child.route}">
                            <c:set var="isActive" value="true" />
                        </c:if>
                    </c:forEach>

                    <!-- Section title (if it's a category) -->
                    <c:if test="${menu.category eq 'title'}">
                        <li class="pe-menu-title">${menu.title}</li>
                    </c:if>

                    <!-- Mark accounts existence -->
                    <c:if test="${menu.route == '/accounts'}">
                        <c:set var="accountsExists" value="true" />
                    </c:if>
                    <c:forEach var="child" items="${menu.children}">
                        <c:if test="${child.route == '/accounts'}">
                            <c:set var="accountsExists" value="true" />
                        </c:if>
                    </c:forEach>

                    <!-- Normal menu item -->
                    <c:if test="${menu.category ne 'title'}">
                        <li class="pe-slide ${not empty menu.children ? 'pe-has-sub' : ''}">
                            <c:choose>
                                <c:when test="${not empty menu.children}">
                                    <a href="#collapse${menu.id}"
                                       class="pe-nav-link ${isActive ? 'active' : ''}"
                                       data-bs-toggle="collapse"
                                       aria-expanded="${isActive}"
                                       aria-controls="collapse${menu.id}">
                                        <i class="${menu.icon} pe-nav-icon"></i>
                                        <span class="pe-nav-content">${menu.title}</span>
                                        <i class="ri-arrow-down-s-line pe-nav-arrow"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}${menu.route}"
                                       class="pe-nav-link ${isActive ? 'active' : ''}">
                                        <i class="${menu.icon} pe-nav-icon"></i>
                                        <span class="pe-nav-content">${menu.title}</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <!-- Submenu -->
                            <c:if test="${not empty menu.children}">
                                <ul class="pe-slide-menu collapse ${isActive ? 'show' : ''}" id="collapse${menu.id}">
                                    <c:forEach var="child" items="${menu.children}">
                                        <li class="pe-slide-item">
                                            <a href="${pageContext.request.contextPath}${child.route}"
                                            class="pe-nav-link ${currentRoute == child.route ? 'active' : ''}">
                                                ${child.title}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </li>
                    </c:if>
                </c:forEach>

                <!-- Fallback Accounts link if not present in menus -->
                <c:if test="${not accountsExists}">
                    <li class="pe-slide">
                        <a href="${pageContext.request.contextPath}/accounts" class="pe-nav-link ${currentRoute == '/accounts' ? 'active' : ''}">
                            <i class="ri-contacts-book-2-line pe-nav-icon"></i>
                            <span class="pe-nav-content">Accounts</span>
                        </a>
                    </li>
                </c:if>

                <!-- Fallback Organizations link if not present in menus -->
                <c:set var="organizationsExists" value="false" />
                <c:forEach var="menu" items="${menus}">
                    <c:if test="${menu.route == '/organizations'}"><c:set var="organizationsExists" value="true" /></c:if>
                    <c:forEach var="child" items="${menu.children}">
                        <c:if test="${child.route == '/organizations'}"><c:set var="organizationsExists" value="true" /></c:if>
                    </c:forEach>
                </c:forEach>
                <c:if test="${not organizationsExists}">
                    <li class="pe-slide">
                        <a href="${pageContext.request.contextPath}/organizations" class="pe-nav-link ${currentRoute == '/organizations' ? 'active' : ''}">
                            <i class="ri-community-line pe-nav-icon"></i>
                            <span class="pe-nav-content">Organizations</span>
                        </a>
                    </li>
                </c:if>

                <!-- Fallback Products link if not present in menus -->
                <c:set var="productsExists" value="false" />
                <c:forEach var="menu" items="${menus}">
                    <c:if test="${menu.route == '/products'}"><c:set var="productsExists" value="true" /></c:if>
                    <c:forEach var="child" items="${menu.children}">
                        <c:if test="${child.route == '/products'}"><c:set var="productsExists" value="true" /></c:if>
                    </c:forEach>
                </c:forEach>
                <c:if test="${not productsExists}">
                    <li class="pe-slide">
                        <a href="${pageContext.request.contextPath}/products" class="pe-nav-link ${currentRoute == '/products' ? 'active' : ''}">
                            <i class="ri-price-tag-3-line pe-nav-icon"></i>
                            <span class="pe-nav-content">Products</span>
                        </a>
                    </li>
                </c:if>

                <c:set var="categoriesExists" value="false" />
                <c:forEach var="menu" items="${menus}">
                    <c:if test="${menu.route == '/tickets/categories'}"><c:set var="categoriesExists" value="true" /></c:if>
                    <c:forEach var="child" items="${menu.children}">
                        <c:if test="${child.route == '/tickets/categories'}"><c:set var="categoriesExists" value="true" /></c:if>
                    </c:forEach>
                </c:forEach>
                <c:if test="${not categoriesExists}">
                    <li class="pe-slide">
                        <a href="${pageContext.request.contextPath}/tickets/categories" class="pe-nav-link ${currentRoute == '/tickets/categories' ? 'active' : ''}">
                            <i class="ri-list-settings-line pe-nav-icon"></i>
                            <span class="pe-nav-content">Categories</span>
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
        
        <!-- Moved to bottom: Sticky bottom widget with last login -->
        <div class="mt-auto">
            <div class="sidebar-widget text-center pb-3 pt-2 border-top">
                <p class="text-muted mb-2 small">Last Login: ${lastLogin}</p>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger rounded-pill w-100" onclick="logoutLink(event, this)">
                    <i class="bi bi-box-arrow-right me-2"></i> Sign Out
                </a>
            </div>
        </div>
    </nav>
</aside>
