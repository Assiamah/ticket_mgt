package com.mit.ticket_mgt_app.controllers;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
// import org.springframework.security.core.GrantedAuthority;
// import org.springframework.security.core.authority.SimpleGrantedAuthority;
// import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.mit.ticket_mgt_app.config.WebServiceURLConfig;
import com.mit.ticket_mgt_app.helpers.BrowserDetection;
import com.mit.ticket_mgt_app.helpers.ClientIpAddress;
import com.mit.ticket_mgt_app.helpers.LocalMacAddress;
import com.mit.ticket_mgt_app.model.Menu;
import com.mit.ticket_mgt_app.services.AuthService;
import com.mit.ticket_mgt_app.services.MenuService;
import com.mit.ticket_mgt_app.services.UserService;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
// import com.mit.ticket_mgt_app.utils.EncryptionUtil;
// import com.mit.ticket_mgt_app.utils.isAuthenticatedUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

@Controller
public class AuthController {

    // private EncryptionUtil encryptionUtil;
    @Autowired
    private AuthService authService;

    @Autowired
    private ClientIpAddress clientIpAddress;

    @Autowired
    private BrowserDetection browserDetection;

    public AuthController() {
        System.out.println("AuthController initialized");
    }

    @Autowired
    private LocalMacAddress localMacAddress;

    // public AuthController(WebServiceURLConfig wsURLConfig,
    // EncryptionUtil encryptionUtil,
    // AuthService authService,
    // BrowserDetection browserDetection,
    // ClientIpAddress clientIpAddress,
    // LocalMacAddress localMacAddress) {
    // this.wsURLConfig = wsURLConfig;
    // this.encryptionUtil = encryptionUtil;
    // this.authService = authService;
    // this.browserDetection = browserDetection;
    // this.clientIpAddress = clientIpAddress;
    // this.localMacAddress = localMacAddress;
    // }

    // @Autowired
    // private isAuthenticatedUtil isAuthenticatedUtil;

    @Autowired
    private WebServiceURLConfig wsURLConfig;

    @Autowired
    private MenuService menuService;

    @Autowired
    private UserService userService;

    @GetMapping("/")
    public String showIndexPage(Model model) {
        model.addAttribute("content", "../auth/login.jsp");
        return "layouts/guest";
    }

    @GetMapping("/login")
    public String showLoginPage(Model model) {
        model.addAttribute("content", "../auth/login.jsp");
        return "layouts/guest";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordPage(Model model) {
        model.addAttribute("content", "../auth/forgot_password.jsp");
        return "layouts/guest";
    }

    @GetMapping("/login/2fa")
    public String show2faPage(Model model, HttpSession session) {
        if (session.getAttribute("passKey") == null) {
            model.addAttribute("sessionOut", "Authentication failed! Session has expired.");
            return "redirect:/login";
        }

        model.addAttribute("content", "../auth/login_2fa.jsp");
        return "layouts/guest";
    }

    @PostMapping("/reset_password_with_default")
    @ResponseBody
    public String resetPasswordWithDefault(@RequestBody Map<String, Object> requestData) {
        try {
            JSONObject requestJson = new JSONObject(requestData);
            String webServiceResponse = userService.resetPasswordWithDefault(
                wsURLConfig.getWeb_service_url_ser(),
                wsURLConfig.getWeb_service_url_ser_api_key(),
                requestJson.toString()
            );
            return webServiceResponse;
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"success\": false, \"message\": \"Failed to reset password: " + e.getMessage() + "\"}";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, Model model) {
        // Invalidate the current session
        session.invalidate();

        // Clear any model attributes if needed
        model.asMap().clear();

        // Redirect to login page with a success message
        model.addAttribute("content", "../auth/login.jsp");
        model.addAttribute("message", "You have been logged out successfully");
        return "layouts/guest";
    }

    @PostMapping("/user_authentication")
    public String userAuthentication(Model model, HttpSession session, HttpServletRequest request,
            HttpServletResponse response) throws JSONException {

        // User credentials
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Get Client IP Address
        String ipAddress = clientIpAddress.getClientIpAddress(request);
        System.out.println(email);
        System.out.println(password);

        // Get Server-side Geolocation
        String location = "Unknown";
        String locCoordinate = request.getParameter("coordinates");
        try {
            request.getHeader("X-Client-Location");
        } catch (Exception e) {
            location = "Unknown";
        }

        System.out.println(email);
        System.out.println(password);

        // Timezone
        String timezone = TimeZone.getDefault().getID();

        // Device & Browser detection (basic from User-Agent)
        String userAgent = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent").toLowerCase() : "";
        String deviceName = userAgent;
        String platform = userAgent.contains("windows") ? "Windows"
                : userAgent.contains("mac") ? "Mac"
                        : userAgent.contains("linux") ? "Linux"
                                : "Unknown";
        boolean isDesktop = userAgent.contains("windows") || userAgent.contains("mac") || userAgent.contains("linux");
        boolean isTablet = userAgent.contains("tablet");
        boolean isPhone = userAgent.contains("mobile");
        boolean isRobot = userAgent.contains("bot") || userAgent.contains("crawl") || userAgent.contains("spider");
        String browser = browserDetection.getDetectBrowser(userAgent);
        String macAddress = localMacAddress.getLocalMacAddress();

        // Build JSON request
        JSONObject authData = new JSONObject();
        authData.put("email", email);
        authData.put("password", password);
        authData.put("ip_address", ipAddress);
        authData.put("location", location);
        authData.put("timezone", timezone);
        authData.put("loc_coordinate", locCoordinate);
        authData.put("device", deviceName);
        authData.put("platform", platform);
        authData.put("isDesktop", isDesktop);
        authData.put("isTablet", isTablet);
        authData.put("isPhone", isPhone);
        authData.put("browser", browser);
        authData.put("isRobot", isRobot);
        authData.put("mac_address", macAddress);
        authData.put("full_name", email);

        String jsonRequest = authData.toString();
        System.out.println("how are you");
        System.out.println(wsURLConfig.getWeb_service_url_ser());
        System.out.println(wsURLConfig.getWeb_service_url_ser_api_key());
        System.out.println(jsonRequest);

        String webServiceResponse = authService.userLogin(
                wsURLConfig.getWeb_service_url_ser(),
                wsURLConfig.getWeb_service_url_ser_api_key(),
                jsonRequest);

        System.out.println("webServiceResponse");
        System.out.println(webServiceResponse);

        if (webServiceResponse == null || webServiceResponse.trim().isEmpty()) {
            model.addAttribute("error", "Service unavailable. Please try again later.");
            return "redirect:/login?error=true";
        }

        JSONObject resObj;
        try {
            resObj = new JSONObject(webServiceResponse);
        } catch (JSONException e) {
            System.err.println("Failed to parse webServiceResponse: " + webServiceResponse);
            model.addAttribute("error", "Invalid response from authentication service.");
            return "redirect:/login?error=true";
        }

        System.out.println(email);
        System.out.println(password);
        boolean success = resObj.optBoolean("success", false);

        if (success) {
            JSONObject resData = resObj.optJSONObject("data");
            if (resData == null) {
                model.addAttribute("error",
                        resObj.optString("message", "Login failed. Please check your credentials."));
                return "redirect:/login?error=true";
            }

            // Store passKey with expiry metadata
            Map<String, Object> passKeyData = new HashMap<>();
            passKeyData.put("value", resData.getString("unique_id"));
            passKeyData.put("expiryTime", System.currentTimeMillis() + 15 * 60 * 1000);

            session.setAttribute("passKey", passKeyData);

            // Check if password change is required
            boolean forceToChangePassword = resData.optBoolean("force_to_change_password", false);
            if (forceToChangePassword) {
                 model.addAttribute("forceChangePassword", true);
                 model.addAttribute("userId", resData.getString("unique_id"));
                 model.addAttribute("content", "../auth/login.jsp");
                 return "layouts/guest";
            }

            System.out.println(resData.getString("pin"));
            session.setAttribute("phone_number", resData.getString("phone_number"));
            session.setAttribute("otp_pin", resData.getString("pin"));

            // return "redirect:/dashboard";
            return "redirect:/login/2fa";
        } else {
            String errorMessage = resObj.optString("message", "Invalid email or password.");
            model.addAttribute("error", errorMessage);
            return "redirect:/login?error=true";
        }
    }

    @PostMapping("/verify_otp")
    public String verifyOtp(Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response)
            throws JSONException {

        // if (!isAuthenticatedUtil.loginAuthenticated(session)) {
        // model.addAttribute("sessionOut", "Authentication failed! Session has
        // expired.");
        // return "redirect:/login?session=invalid";
        // }

        @SuppressWarnings("unchecked")
        Map<String, Object> passKeyData = (Map<String, Object>) session.getAttribute("passKey");
        String passKey = (String) passKeyData.get("value");
        String decryptedPassKey = passKey;

        // User credentials
        String vc_1 = request.getParameter("vc_1");
        String vc_2 = request.getParameter("vc_2");
        String vc_3 = request.getParameter("vc_3");
        String vc_4 = request.getParameter("vc_4");
        String vc_5 = request.getParameter("vc_5");
        String vc_6 = request.getParameter("vc_6");

        String enteredOtp = vc_1 + vc_2 + vc_3 + vc_4 + vc_5 + vc_6;

        // Build JSON request
        JSONObject authData = new JSONObject();
        authData.put("unique_id", decryptedPassKey);
        authData.put("pin", enteredOtp);

        String jsonRequest = authData.toString();
        String webServiceResponse = authService.verifyOtp(
                wsURLConfig.getWeb_service_url_ser(),
                wsURLConfig.getWeb_service_url_ser_api_key(),
                jsonRequest);

        if (webServiceResponse == null) {
            model.addAttribute("error", "Service unavailable. Please try again later.");
            return "redirect:/login/2fa";
        }

        JSONObject resObj = new JSONObject(webServiceResponse);

        boolean success = resObj.getBoolean("success");
        if (success) {
            JSONObject resData = resObj.getJSONObject("data");
            // System.out.println(resData);
            // Create authentication

            // List<GrantedAuthority> authorities = new ArrayList<>();
            // authorities.add(new SimpleGrantedAuthority("ROLE_USER"));

            // UsernamePasswordAuthenticationToken authentication = new
            // UsernamePasswordAuthenticationToken(
            // resData.getString("email"),
            // null,
            // authorities);

            // // Set authentication in SecurityContext
            // SecurityContextHolder.getContext().setAuthentication(authentication);

            // // Persist authentication in session (important!)
            // session.setAttribute(
            // "SPRING_SECURITY_CONTEXT",
            // SecurityContextHolder.getContext());

            // Store encrypted passkey in session
            session.setAttribute(
                    "passKey",
                    resData.getString("unique_id"));

            // Store full user info in session
            try {
                ObjectMapper mapper = new ObjectMapper();
                Map<String, Object> userInfo = mapper.readValue(resData.toString(),
                        new TypeReference<Map<String, Object>>() {
                        });
                session.setAttribute("userInfo", userInfo);
                System.out.println("DEBUG: AuthController populated userInfo in session: " + userInfo);
            } catch (Exception e) {
                System.err.println("Error parsing userInfo from resData: " + e.getMessage());
            }

            // --- Assigned menus (convert to tree) ---
            JSONObject menus = resData.getJSONObject("menus");
            JSONArray menuArray = menus.getJSONArray("data");

            // Convert JSONArray -> List<Menu>
            List<Menu> flatMenus = new ArrayList<>();
            for (int i = 0; i < menuArray.length(); i++) {
                JSONObject m = menuArray.getJSONObject(i);
                Menu menu = new Menu();
                menu.setId(m.getInt("id"));
                menu.setTitle(m.getString("title"));
                menu.setRoute(m.isNull("route") ? null : m.getString("route"));
                menu.setIcon(m.isNull("icon") ? null : m.getString("icon"));
                menu.setCategory(m.isNull("category") ? null : m.getString("category"));
                menu.setParentId(m.isNull("parent_id") ? null : m.getInt("parent_id"));
                menu.setPosition(m.getInt("position"));
                flatMenus.add(menu);
            }

            // Build hierarchy
            List<Menu> menuTree = menuService.buildMenuTree(flatMenus);

            // Ensure critical menus exist to prevent access checks from failing
            try {
                boolean hasDashboard = false;
                for (Menu m : menuTree) {
                    if ("Dashboard".equalsIgnoreCase(m.getTitle())
                            || "/dashboard".equalsIgnoreCase(String.valueOf(m.getRoute()))) {
                        hasDashboard = true;
                        break;
                    }
                }
                if (!hasDashboard) {
                    Menu dashboard = new Menu();
                    dashboard.setId(8999);
                    dashboard.setTitle("Dashboard");
                    dashboard.setRoute("/dashboard");
                    dashboard.setIcon("ri-dashboard-3-line");
                    dashboard.setCategory(null);
                    dashboard.setParentId(null);
                    dashboard.setPosition(1);
                    menuTree.add(0, dashboard);
                }

                // Ensure Tickets group with essential children
                Menu ticketsParent = null;
                for (Menu m : menuTree) {
                    if ("Tickets".equalsIgnoreCase(m.getTitle())
                            || "/tickets".equalsIgnoreCase(String.valueOf(m.getRoute()))) {
                        ticketsParent = m;
                        break;
                    }
                }
                if (ticketsParent == null) {
                    ticketsParent = new Menu();
                    ticketsParent.setId(9001);
                    ticketsParent.setTitle("Tickets");
                    ticketsParent.setRoute("/tickets");
                    ticketsParent.setIcon("ri-customer-service-2-line");
                    ticketsParent.setCategory(null);
                    ticketsParent.setParentId(null);
                    ticketsParent.setPosition(20);
                    menuTree.add(ticketsParent);
                }
                java.util.List<Menu> ticketChildren = ticketsParent.getChildren();
                // Manage Tickets
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("Manage Tickets".equalsIgnoreCase(c.getTitle())
                                || "/tickets".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Manage Tickets" + "/tickets").hashCode()));
                        child.setTitle("Manage Tickets");
                        child.setRoute("/tickets");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }
                // Org Archive
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("Org Archive".equalsIgnoreCase(c.getTitle())
                                || "/tickets/org_archive".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Org Archive" + "/tickets/org_archive").hashCode()));
                        child.setTitle("Org Archive");
                        child.setRoute("/tickets/org_archive");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }
                // Create Ticket
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("Create Ticket".equalsIgnoreCase(c.getTitle())
                                || "/tickets/create".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Create Ticket" + "/tickets/create").hashCode()));
                        child.setTitle("Create Ticket");
                        child.setRoute("/tickets/create");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }
                // Analytics
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("Analytics".equalsIgnoreCase(c.getTitle())
                                || "/tickets/analytics".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Analytics" + "/tickets/analytics").hashCode()));
                        child.setTitle("Analytics");
                        child.setRoute("/tickets/analytics");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }
                // Archive
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("Archive".equalsIgnoreCase(c.getTitle())
                                || "/tickets/archive".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Archive" + "/tickets/archive").hashCode()));
                        child.setTitle("Archive");
                        child.setRoute("/tickets/archive");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }
                // My Tasks
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("My Tasks".equalsIgnoreCase(c.getTitle())
                                || "/tickets/my_tasks".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("My Tasks" + "/tickets/my_tasks").hashCode()));
                        child.setTitle("My Tasks");
                        child.setRoute("/tickets/my_tasks");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }
                // Assigned Jobs
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("Assigned Jobs".equalsIgnoreCase(c.getTitle())
                                || "/tickets/assigned_jobs".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Assigned Jobs" + "/tickets/assigned_jobs").hashCode()));
                        child.setTitle("Assigned Jobs");
                        child.setRoute("/tickets/assigned_jobs");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }
                {
                    boolean exists = false;
                    for (Menu c : ticketChildren) {
                        if ("Categories".equalsIgnoreCase(c.getTitle())
                                || "/tickets/categories".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Categories" + "/tickets/categories").hashCode()));
                        child.setTitle("Categories");
                        child.setRoute("/tickets/categories");
                        child.setParentId(ticketsParent.getId());
                        child.setPosition(ticketChildren.size() + 1);
                        ticketChildren.add(child);
                    }
                }

                // Ensure Analytics with Staff Performance
                Menu analyticsParent = null;
                for (Menu m : menuTree) {
                    if ("Analytics".equalsIgnoreCase(m.getTitle())) {
                        analyticsParent = m;
                        break;
                    }
                }
                if (analyticsParent == null) {
                    analyticsParent = new Menu();
                    analyticsParent.setId(9002);
                    analyticsParent.setTitle("Analytics");
                    analyticsParent.setRoute(null);
                    analyticsParent.setIcon("ri-bar-chart-2-line");
                    analyticsParent.setCategory(null);
                    analyticsParent.setParentId(null);
                    analyticsParent.setPosition(30);
                    menuTree.add(analyticsParent);
                }
                java.util.List<Menu> analyticsChildren = analyticsParent.getChildren();
                boolean hasStaffPerf = false;
                for (Menu c : analyticsChildren) {
                    if ("Staff Performance".equalsIgnoreCase(c.getTitle())
                            || "/analytics/staff_performance".equalsIgnoreCase(String.valueOf(c.getRoute()))) {
                        hasStaffPerf = true;
                        break;
                    }
                }
                if (!hasStaffPerf) {
                    Menu perf = new Menu();
                    perf.setId(9003);
                    perf.setTitle("Staff Performance");
                    perf.setRoute("/analytics/staff_performance");
                    perf.setParentId(analyticsParent.getId());
                    perf.setPosition(analyticsChildren.size() + 1);
                    analyticsChildren.add(perf);
                }

                // Ensure Accounts shows in sidebar when backend menus are missing it
                boolean hasAccountsMenu = false;
                for (Menu m : menuTree) {
                    String r = String.valueOf(m.getRoute());
                    if ("/accounts".equalsIgnoreCase(r) || "Accounts".equalsIgnoreCase(m.getTitle())) {
                        hasAccountsMenu = true;
                        break;
                    }
                }
                if (!hasAccountsMenu) {
                    Menu acc = new Menu();
                    acc.setId(9011);
                    acc.setTitle("Accounts");
                    acc.setRoute("/accounts");
                    acc.setIcon("ri-contacts-book-2-line");
                    acc.setCategory(null);
                    acc.setParentId(null);
                    acc.setPosition(10);
                    menuTree.add(acc);
                }

                // Ensure Profile link exists
                boolean hasProfileMenu = false;
                for (Menu m : menuTree) {
                    String r = String.valueOf(m.getRoute());
                    if ("/profile".equalsIgnoreCase(r) || "Profile".equalsIgnoreCase(m.getTitle())) {
                        hasProfileMenu = true;
                        break;
                    }
                }
                if (!hasProfileMenu) {
                    Menu prof = new Menu();
                    prof.setId(9013);
                    prof.setTitle("Profile");
                    prof.setRoute("/profile");
                    prof.setIcon("ri-user-3-line");
                    prof.setCategory(null);
                    prof.setParentId(null);
                    prof.setPosition(9);
                    menuTree.add(prof);
                }

                // Ensure Organizations with Org Archive
                Menu orgParent = null;
                for (Menu m : menuTree) {
                    if ("Organizations".equalsIgnoreCase(m.getTitle())
                            || "/organizations".equalsIgnoreCase(String.valueOf(m.getRoute()))) {
                        orgParent = m;
                        break;
                    }
                }
                if (orgParent == null) {
                    orgParent = new Menu();
                    orgParent.setId(9020);
                    orgParent.setTitle("Organizations");
                    orgParent.setRoute("/organizations");
                    orgParent.setIcon("ri-building-line");
                    orgParent.setCategory(null);
                    orgParent.setParentId(null);
                    orgParent.setPosition(40);
                    menuTree.add(orgParent);
                }
                java.util.List<Menu> orgChildren = orgParent.getChildren();
                // Rename Organization Archive to Add Organization
                {
                    Menu existing = null;
                    for (Menu c : orgChildren) {
                        if ("Organization Archive".equalsIgnoreCase(c.getTitle())
                                || "Add Organization".equalsIgnoreCase(c.getTitle())) {
                            existing = c;
                            break;
                        }
                    }

                    if (existing != null) {
                        // Update title and route
                        existing.setTitle("Add Organization");
                        existing.setRoute("/organizations/add");
                    } else {
                        Menu child = new Menu();
                        child.setId(Math.abs(("Add Organization" + "/organizations/add").hashCode()));
                        child.setTitle("Add Organization");
                        child.setRoute("/organizations/add");
                        child.setParentId(orgParent.getId());
                        child.setPosition(orgChildren.size() + 1);
                        orgChildren.add(child);
                    }
                }

            } catch (Exception ignore) {
            }

            // Store menu tree in session
            session.setAttribute("menus", menuTree);

            // Store user info in session
            Map<String, Object> userInfo = null;
            try {
                ObjectMapper mapper = new ObjectMapper();
                String infoStr = resData.getString("info");
                System.out.println("DEBUG: AuthController raw info: " + infoStr);
                userInfo = mapper.readValue(
                        infoStr,
                        new TypeReference<Map<String, Object>>() {
                        });
                session.setAttribute("userInfo", userInfo);
            } catch (Exception e) {
                e.printStackTrace();
                // handle error: maybe redirect or show a message
            }

            // Capture current timestamp
            LocalDateTime lastLogin = LocalDateTime.now();

            // Format like "Wed Sep 10 10:45PM"
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE MMM dd hh:mma", Locale.ENGLISH);
            String formattedLastLogin = lastLogin.format(formatter);

            // Store in session
            session.setAttribute("lastLogin", formattedLastLogin);

            return "redirect:/dashboard";
        } else {
            String error = resObj.getString("error");
            model.addAttribute("error", error);
            return "redirect:/login/2fa";
        }
    }

}
