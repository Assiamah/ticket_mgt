package com.mit.ticket_mgt_app.controllers;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mit.ticket_mgt_app.config.WebServiceURLConfig;
import com.mit.ticket_mgt_app.services.AppointmentService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PageController {

    @Autowired
    private WebServiceURLConfig wsURLConfig;

    // private final WebServiceURLConfig wsURLConfig;
    @Autowired
    private AppointmentService appointmentService;

    public PageController(WebServiceURLConfig wsURLConfig, AppointmentService appointmentService) {
        this.wsURLConfig = wsURLConfig;
        this.appointmentService = appointmentService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }

        // Allow dashboard for all authenticated users, even if menu entry is missing

        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/dashboard.jsp");
        model.addAttribute("page_name", "Dashboard");
        model.addAttribute("currentRoute", "/dashboard");
        return "layouts/app";
    }

    @GetMapping("/accounts")
    public String accounts(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }

        // if (!hasAccessUtil.hasAccess(session, "/accounts")) {
        // return "redirect:/login?access=forbidden";
        // }

        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/user-management/accounts.jsp");
        model.addAttribute("page_name", "Accounts");
        model.addAttribute("currentRoute", "/accounts");
        return "layouts/app";
    }

    @GetMapping("/manage_slots")
    public String manageSlots(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }

        // if (!hasAccessUtil.hasAccess(session, "/manage_slots")) {
        // return "redirect:/login?access=forbidden";
        // }

        String appointmentTypesJson = appointmentService.getAppointmentTypes(
                wsURLConfig.getWeb_service_url_ser(),
                wsURLConfig.getWeb_service_url_ser_api_key());

        try {
            ObjectMapper mapper = new ObjectMapper();

            // Deserialize JSON array into a List of Maps (quick way)
            List<Map<String, Object>> appointmentTypes = mapper.readValue(
                    appointmentTypesJson,
                    new TypeReference<List<Map<String, Object>>>() {
                    });

            model.addAttribute("appointmentTypes", appointmentTypes);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("appointmentTypes", Collections.emptyList());
        }

        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/appointments/manage_slots.jsp");
        model.addAttribute("page_name", "Manage Slots");
        model.addAttribute("currentRoute", "/manage_slots");
        return "layouts/app";
    }

    @GetMapping("/manage_appointments")
    public String allappointments(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }

        // if (!hasAccessUtil.hasAccess(session, "/manage_appointments")) {
        // return "redirect:/login?access=forbidden";
        // }

        String appointmentTypesJson = appointmentService.getAppointmentTypes(
                wsURLConfig.getWeb_service_url_ser(),
                wsURLConfig.getWeb_service_url_ser_api_key());

        try {
            ObjectMapper mapper = new ObjectMapper();

            // Deserialize JSON array into a List of Maps (quick way)
            List<Map<String, Object>> appointmentTypes = mapper.readValue(
                    appointmentTypesJson,
                    new TypeReference<List<Map<String, Object>>>() {
                    });

            model.addAttribute("appointmentTypes", appointmentTypes);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("appointmentTypes", Collections.emptyList());
        }

        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/appointments/manage_appointments.jsp");
        model.addAttribute("page_name", "Manage Appointments");
        model.addAttribute("currentRoute", "/manage_appointments");
        return "layouts/app";
    }

    @GetMapping("/spatial_map_explorer")
    public String spatialMapExplorer(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }

        // if (!hasAccessUtil.hasAccess(session, "/spatial_map_explorer")) {
        // return "redirect:/login?access=forbidden";
        // }

        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/maps/spatial_map_explorer.jsp");
        model.addAttribute("page_name", "Spatial Map Explorer");
        model.addAttribute("currentRoute", "/spatial_map_explorer");
        return "layouts/app";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/user-management/profile.jsp");
        model.addAttribute("page_name", "Profile");
        model.addAttribute("currentRoute", "/profile");
        return "layouts/app";
    }

    @GetMapping("/tickets")
    public String tickets(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }

        // if (!hasAccessUtil.hasAccess(session, "/tickets")) {
        // return "redirect:/login?access=forbidden";
        // }

        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/tickets/tickets.jsp");
        model.addAttribute("page_name", "tickets");
        model.addAttribute("currentRoute", "/tickets");
        return "layouts/app";
    }

    @GetMapping("/tickets/analytics")
    public String ticketsAnalytics(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // if (!hasAccessUtil.hasAccess(session, "/tickets/analytics")) {
        // return "redirect:/login?access=forbidden";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/tickets/analytics.jsp");
        model.addAttribute("page_name", "Ticket Analytics");
        model.addAttribute("currentRoute", "/tickets/analytics");
        return "layouts/app";
    }

    @GetMapping("/tickets/create")
    public String ticketsCreate(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // if (!hasAccessUtil.hasAccess(session, "/tickets/create")) {
        // return "redirect:/login?access=forbidden";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/tickets/create.jsp");
        model.addAttribute("page_name", "Create Ticket");
        model.addAttribute("currentRoute", "/tickets/create");
        return "layouts/app";
    }

    @GetMapping("/tickets/archive")
    public String ticketsArchive(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // if (!hasAccessUtil.hasAccess(session, "/tickets/archive")) {
        // return "redirect:/login?access=forbidden";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/tickets/archive.jsp");
        model.addAttribute("page_name", "Archived Tickets");
        model.addAttribute("currentRoute", "/tickets/archive");
        return "layouts/app";
    }

    @GetMapping("/tickets/categories")
    public String ticketsCategories(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // if (!hasAccessUtil.hasAccess(session, "/tickets/categories")) {
        // return "redirect:/login?access=forbidden";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/tickets/categories.jsp");
        model.addAttribute("page_name", "Ticket Categories");
        model.addAttribute("currentRoute", "/tickets/categories");
        return "layouts/app";
    }

    @GetMapping("/tickets/my_tasks")
    public String myTasks(Model model, HttpSession session) {
        model.addAttribute("content", "../pages/tickets/my_tasks.jsp");
        model.addAttribute("page_name", "My Tasks");
        model.addAttribute("currentRoute", "/tickets/my_tasks");
        return "layouts/app";
    }

    @GetMapping("/tickets/assigned_jobs")
    public String assignedJobs(Model model, HttpSession session) {
        model.addAttribute("content", "../pages/tickets/assigned_jobs.jsp");
        model.addAttribute("page_name", "Assigned Jobs");
        model.addAttribute("currentRoute", "/tickets/assigned_jobs");
        return "layouts/app";
    }

    @GetMapping("/tickets/org_archive")
    public String ticketsOrgArchive(Model model, HttpSession session) {
        model.addAttribute("content", "../pages/tickets/org_archive.jsp");
        model.addAttribute("page_name", "Organization Archive");
        model.addAttribute("currentRoute", "/tickets/org_archive");
        return "layouts/app";
    }

    @GetMapping("/knowledge-base")
    public String knowledgeBase(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // if (!hasAccessUtil.hasAccess(session, "/knowledge-base")) {
        // return "redirect:/login?access=forbidden";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/knowledge-base/index.jsp");
        model.addAttribute("page_name", "Knowledge Base");
        model.addAttribute("currentRoute", "/knowledge-base");
        return "layouts/app";
    }

    @GetMapping("/analytics/staff_performance")
    public String staffPerformance(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // if (!hasAccessUtil.hasAccess(session, "/analytics/staff_performance")) {
        // return "redirect:/login?access=forbidden";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/analytics/staff_performance.jsp");
        model.addAttribute("page_name", "Staff Performance");
        model.addAttribute("currentRoute", "/analytics/staff_performance");
        return "layouts/app";
    }

    @GetMapping("/organizations")
    public String organizations(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/organizations/manage.jsp");
        model.addAttribute("page_name", "Organizations");
        model.addAttribute("currentRoute", "/organizations");
        return "layouts/app";
    }

    @GetMapping("/organizations/add")
    public String organizationsAdd(Model model, HttpSession session) {
        model.addAttribute("content", "../pages/organizations/manage.jsp");
        model.addAttribute("page_name", "Add Organization");
        model.addAttribute("currentRoute", "/organizations/add");
        return "layouts/app";
    }

    @GetMapping("/products")
    public String products(Model model, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }
        // model.addAttribute("user",
        // SecurityContextHolder.getContext().getAuthentication().getName());
        model.addAttribute("content", "../pages/products/manage.jsp");
        model.addAttribute("page_name", "Products");
        model.addAttribute("currentRoute", "/products");
        return "layouts/app";
    }
}
