package com.mit.ticket_mgt_app.controllers.rest;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Logger;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.codehaus.jettison.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mit.ticket_mgt_app.config.WebServiceURLConfig;
import com.mit.ticket_mgt_app.services.TicketService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.dao.DataAccessException;

@RestController
@RequestMapping("/api/tickets/")
public class TicketRest {
    private final WebServiceURLConfig wsURLConfig;
    private final TicketService ticketService;

    private static final Logger logger = Logger.getLogger(TicketRest.class.getName());

    public TicketRest(WebServiceURLConfig wsURLConfig, TicketService ticketService) {
        this.wsURLConfig = wsURLConfig;
        this.ticketService = ticketService;
    }

    @PostMapping("/get_org_archived_tasks")
    public ResponseEntity<?> getOrgArchivedTasks(@RequestBody Map<String, Object> payload, HttpSession session) {
        try {
            // Add user info to payload if available
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
                if (userInfo != null) {
                    if (userInfo.get("org_id") != null)
                        payload.put("org_id", userInfo.get("org_id"));
                    if (userInfo.get("id") != null)
                        payload.put("user_id", userInfo.get("id"));
                }
            } catch (Exception ignore) {
            }

            JSONObject obj = new JSONObject(payload);
            String res = ticketService.getOrgArchivedTasks(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to get archived tasks: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/fetch_archived_tickets")
    public ResponseEntity<?> fetchArchivedTickets(@RequestBody Map<String, Object> payload, HttpSession session) {
        try {
            // Add user info to payload if available
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
                if (userInfo != null) {
                    if (userInfo.get("org_id") != null)
                        payload.put("org_id", userInfo.get("org_id"));
                    if (userInfo.get("id") != null)
                        payload.put("user_id", userInfo.get("id"));
                }
            } catch (Exception ignore) {
            }

            JSONObject obj = new JSONObject(payload);
            String res = ticketService.fetchArchivedTickets(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch archived tickets: " + e.getMessage()
                            + "\"}");
        }
    }

    // @Autowired
    // private isAuthenticatedUtil isAuthenticatedUtil;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    String webServiceResponse = "";
    String requestType = "";

    @GetMapping("/all")
    public ResponseEntity<?> getAllTickets(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = ticketService.getAllTickets(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching tickets: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch tickets: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/list")
    public ResponseEntity<?> listTickets(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            Integer userId = null;
            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");
                if (userInfo != null && userInfo.get("id") != null) {
                    userId = Integer.parseInt(userInfo.get("id").toString());
                }
            } catch (Exception ignore) {
            }

            webServiceResponse = ticketService.getAllTickets(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userId);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            logger.severe("Error fetching tickets: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch tickets: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/list")
    public ResponseEntity<?> listTicketsPost(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            Integer userId = null;
            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");
                if (userInfo != null && userInfo.get("id") != null) {
                    userId = Integer.parseInt(userInfo.get("id").toString());
                }
            } catch (Exception ignore) {
            }

            webServiceResponse = ticketService.getAllTickets(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userId);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            logger.severe("Error fetching tickets: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch tickets: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/get_system_dashboard_data")
    public ResponseEntity<?> getSystemDashboardData(
            @RequestBody java.util.Map<String, Object> payload,
            HttpSession session) {
        try {
            logger.info("getSystemDashboardData payload: " + payload);
            String startDate = (String) payload.get("start_date");
            String endDate = (String) payload.get("end_date");

            String response = ticketService.getSystemDashboardData(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    startDate,
                    endDate);

            if (response == null || response.trim().isEmpty()) {
                return ResponseEntity.ok("[]");
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.severe("Error fetching system dashboard data: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch system dashboard data: "
                            + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/get_user_org_dashboard_data")
    public ResponseEntity<?> getUserOrgDashboardData(
            @RequestBody java.util.Map<String, Object> payload,
            HttpSession session) {
        try {
            logger.info("getUserOrgDashboardData payload: " + payload);
            String startDate = (String) payload.get("start_date");
            String endDate = (String) payload.get("end_date");

            // Get user info from session
            @SuppressWarnings("unchecked")
            java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session.getAttribute("userInfo");
            String userId = null;
            String orgId = null;

            if (userInfo != null) {
                logger.info("Session userInfo keys: " + userInfo.keySet());
                if (userInfo.get("unique_id") != null) {
                    userId = userInfo.get("unique_id").toString();
                }

                // Try multiple keys for organization ID
                if (userInfo.get("org_id") != null) {
                    orgId = userInfo.get("org_id").toString();
                } else if (userInfo.get("organization_id") != null) {
                    orgId = userInfo.get("organization_id").toString();
                } else if (userInfo.get("organizationId") != null) {
                    orgId = userInfo.get("organizationId").toString();
                } else if (userInfo.get("company_id") != null) {
                    orgId = userInfo.get("company_id").toString();
                } else if (userInfo.get("business_id") != null) {
                    orgId = userInfo.get("business_id").toString();
                }
            } else {
                logger.warning("Session userInfo is NULL");
            }

            // Allow override from payload if needed
            if (payload.containsKey("org_id") && payload.get("org_id") != null) {
                String payloadOrgId = payload.get("org_id").toString();
                if (!payloadOrgId.trim().isEmpty()) {
                    orgId = payloadOrgId;
                }
            } else if (payload.containsKey("organization_id") && payload.get("organization_id") != null) {
                String payloadOrgId = payload.get("organization_id").toString();
                if (!payloadOrgId.trim().isEmpty()) {
                    orgId = payloadOrgId;
                }
            }

            logger.info("Resolved orgId for dashboard: " + orgId + ", userId: " + userId);

            String response = ticketService.getUserOrgDashboardData(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userId,
                    orgId,
                    startDate,
                    endDate);

            if (response == null || response.trim().isEmpty()) {
                return ResponseEntity.ok()
                        .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                        .body("{}");
            }

            return ResponseEntity.ok()
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(response);
        } catch (Exception e) {
            logger.severe("Error fetching user org dashboard data: " + e.getMessage());
            return ResponseEntity.status(500)
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch dashboard data: " + e.getMessage()
                            + "\"}");
        }
    }

    @PostMapping("/get_tickets_list_for_dashboard")
    public ResponseEntity<?> getTicketsListForDashboard(
            @RequestBody java.util.Map<String, Object> payload,
            HttpSession session) {
        try {
            String startDate = (String) payload.get("start_date");
            String endDate = (String) payload.get("end_date");
            Integer limit = payload.containsKey("limit") ? Integer.parseInt(payload.get("limit").toString()) : null;

            String response = ticketService.getTicketsListForDashboard(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    startDate,
                    endDate,
                    limit);

            if (response == null || response.trim().isEmpty()) {
                logger.warning("Tickets list for dashboard service returned empty response");
                return ResponseEntity.ok()
                        .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                        .body("{}");
            }

            return ResponseEntity.ok()
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(response);
        } catch (Exception e) {
            logger.severe("Error fetching tickets list for dashboard: " + e.getMessage());
            return ResponseEntity.status(500)
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch tickets list: " + e.getMessage()
                            + "\"}");
        }
    }

    @GetMapping("/{ticketId}")
    public ResponseEntity<?> getTicketById(@PathVariable String ticketId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            JSONObject requestJson = new JSONObject();
            requestJson.put("ticket_id", ticketId);

            webServiceResponse = ticketService.getTicketById(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    requestJson.toString());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching ticket: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch ticket: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/users_for_assignment")
    public ResponseEntity<?> usersForAssignment(HttpSession session, HttpServletRequest request) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            webServiceResponse = ticketService.getUsersForAssignment(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    "{}");
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            logger.severe("Error fetching users for assignment: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch users for assignment: "
                            + e.getMessage() + "\"}");
        }
    }

    private boolean isValidUuid(String s) {
        if (s == null || s.isEmpty())
            return false;
        try {
            java.util.UUID.fromString(s);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @PostMapping("/create")
    public String createticket(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            // Session is expired
            request.setAttribute("login", "sessionout");
            return "login";
        }

        // {"title":"DHCCHCHD","description":"DEHHEHDHYD","priority_id":"high","department_id":"it","category_id":"ht"}
        try {
            JSONObject obj = new JSONObject();
            // String academic_year = request.getParameter("academic_year");
            String task_subject = request.getParameter("task_subject");
            String task_type = request.getParameter("task_type");
            String task_description = request.getParameter("task_description");
            String task_priority = request.getParameter("task_priority");
            String task_remarks = request.getParameter("task_remarks");
            String product_id = request.getParameter("product_id");
            String category_id = request.getParameter("category_id");
            String priority_id = request.getParameter("priority_id");
            String status_id = request.getParameter("status_id");
            String due_date = request.getParameter("due_date");
            String org_id = request.getParameter("org_id");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String priority = request.getParameter("priority");

            // obj.put("academic_year", academic_year);
            obj.put("task_subject", task_subject);
            obj.put("task_type", task_type);
            obj.put("task_description", task_description);
            obj.put("task_priority", task_priority);
            obj.put("task_remarks", task_remarks);
            if (product_id != null && !product_id.trim().isEmpty())
                obj.put("product_id", product_id);
            if (category_id != null && !category_id.trim().isEmpty())
                obj.put("category_id", category_id);
            if (priority_id != null && !priority_id.trim().isEmpty())
                obj.put("priority_id", priority_id);
            if (status_id != null && !status_id.trim().isEmpty())
                obj.put("status_id", status_id);
            if (due_date != null && !due_date.trim().isEmpty())
                obj.put("due_date", due_date);
            if (org_id != null && !org_id.trim().isEmpty())
                obj.put("org_id", org_id);
            if (title != null && !title.trim().isEmpty())
                obj.put("title", title);
            if (description != null && !description.trim().isEmpty())
                obj.put("description", description);
            if (priority != null && !priority.trim().isEmpty())
                obj.put("priority", priority);
            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");

                if (userInfo != null) {
                    // Try to find user ID (can be "id", "user_id", or "userId")
                    Object userIdObj = userInfo.get("id");
                    if (userIdObj == null)
                        userIdObj = userInfo.get("user_id");
                    if (userIdObj == null)
                        userIdObj = userInfo.get("userId");

                    if (userIdObj != null) {
                        try {
                            int userId = Integer.parseInt(userIdObj.toString());
                            obj.put("created_by", userId);
                            obj.put("user_id", userId);
                        } catch (NumberFormatException e) {
                            System.err.println("Error parsing user ID from session: " + userIdObj);
                        }
                    } else {
                        System.err.println("User ID not found in session userInfo: " + userInfo.keySet());
                    }

                    // Map org_id to target_org_id if present (for system owners creating tickets
                    // for others)
                    if (obj.has("org_id") && !obj.has("target_org_id")) {
                        obj.put("target_org_id", obj.get("org_id"));
                    }
                }
            } catch (Exception ignore) {
            }

            System.out.println("JSON Request: " + obj.toString());

            // Call web service
            webServiceResponse = ticketService.createTicket(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());

            return webServiceResponse;

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            // try {
            // errorResponse.put("status", "error");
            // errorResponse.put("message", "Error adding fees item: " + e.getMessage());

            // response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // response.setContentType("application/json");
            // response.getWriter().write(errorResponse.toString());
            // } catch (JSONException e1) {
            // // TODO Auto-generated catch block
            // e1.printStackTrace();
            // }

        }

        return null;

    }

    // @PostMapping(value = "/create", consumes = "application/json")
    // public ResponseEntity<?> createTicketJson(@RequestBody java.util.Map<String,
    // Object> payload, HttpSession session) {
    // if (!isAuthenticatedUtil.isAuthenticated(session)) {
    // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
    // \"SESSION_INVALID.\"}");
    // }
    // try {
    // org.codehaus.jettison.json.JSONObject obj = new
    // org.codehaus.jettison.json.JSONObject(payload);
    // try {
    // @SuppressWarnings("unchecked")
    // java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>)
    // session
    // .getAttribute("userInfo");
    // if (userInfo != null && userInfo.get("id") != null) {
    // obj.put("created_by", Integer.parseInt(userInfo.get("id").toString()));
    // }
    // } catch (Exception ignore) {
    // }

    // webServiceResponse = ticketService.createTicket(
    // wsURLConfig.getWeb_service_url_ser(),
    // wsURLConfig.getWeb_service_url_ser_api_key(),
    // obj.toString());

    // return ResponseEntity.ok(webServiceResponse);
    // } catch (Exception e) {
    // e.printStackTrace();
    // return ResponseEntity.status(500)
    // .body("{\"status\": \"error\", \"message\": \"Failed to create ticket: " +
    // e.getMessage() + "\"}");
    // }
    // }

    @PostMapping(value = "/create", consumes = "application/json")
    public ResponseEntity<?> createTicketJson(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");

                if (userInfo != null) {
                    // Try to find user ID (can be "id", "user_id", or "userId")
                    Object userIdObj = userInfo.get("id");
                    if (userIdObj == null)
                        userIdObj = userInfo.get("user_id");
                    if (userIdObj == null)
                        userIdObj = userInfo.get("userId");

                    if (userIdObj != null) {
                        try {
                            int userId = Integer.parseInt(userIdObj.toString());
                            obj.put("created_by", userId);
                            obj.put("user_id", userId);
                        } catch (NumberFormatException e) {
                            System.err.println("Error parsing user ID from session: " + userIdObj);
                        }
                    } else {
                        System.err.println("User ID not found in session userInfo: " + userInfo.keySet());
                    }

                    // Map org_id to target_org_id if present (for system owners creating tickets
                    // for others)
                    if (obj.has("org_id") && !obj.has("target_org_id")) {
                        obj.put("target_org_id", obj.get("org_id"));
                    }
                }
            } catch (Exception ignore) {
            }

            webServiceResponse = ticketService.createTicket(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());

            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to create ticket: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/create_context")
    public ResponseEntity<?> getCreateTicketContext(@RequestParam(required = false) String org_id,
            HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            @SuppressWarnings("unchecked")
            java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session.getAttribute("userInfo");
            Integer userId = null;
            if (userInfo != null && userInfo.get("id") != null) {
                userId = Integer.parseInt(userInfo.get("id").toString());
            }
            webServiceResponse = ticketService.getCreateTicketContext(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userId,
                    org_id);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            logger.severe("Error fetching create context: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch create context: " + e.getMessage()
                            + "\"}");
        }
    }

    @PostMapping("/update")
    public String updateticket(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            // Session is expired
            request.setAttribute("login", "sessionout");
            return "login";
        }

        // {"title":"DHCCHCHD","description":"DEHHEHDHYD","priority_id":"high","department_id":"it","category_id":"ht"}
        try {
            JSONObject obj = new JSONObject();
            // String academic_year = request.getParameter("academic_year");
            String task_id = request.getParameter("task_id");
            String task_status = request.getParameter("task_status");
            String task_subject = request.getParameter("task_subject");
            String task_type = request.getParameter("task_type");
            String task_description = request.getParameter("task_description");
            String task_priority = request.getParameter("task_priority");
            String task_remarks = request.getParameter("task_remarks");

            // obj.put("academic_year", academic_year);
            obj.put("task_id", task_id);
            obj.put("task_status", task_status);
            obj.put("task_subject", task_subject);
            obj.put("task_type", task_type);
            obj.put("task_description", task_description);
            obj.put("task_remarks", task_remarks);
            obj.put("task_priority", task_priority);

            System.out.println("JSON Request: " + obj.toString());

            // Call web service
            webServiceResponse = ticketService.updateTicket(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());

            return webServiceResponse;

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            // try {
            // errorResponse.put("status", "error");
            // errorResponse.put("message", "Error adding fees item: " + e.getMessage());

            // response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // response.setContentType("application/json");
            // response.getWriter().write(errorResponse.toString());
            // } catch (JSONException e1) {
            // // TODO Auto-generated catch block
            // e1.printStackTrace();
            // }

        }

        return null;

    }

    @PostMapping("/view")
    public String viewticket(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            // Session is expired
            request.setAttribute("login", "sessionout");
            return "login";
        }

        // {"title":"DHCCHCHD","description":"DEHHEHDHYD","priority_id":"high","department_id":"it","category_id":"ht"}
        try {
            String task_id = request.getParameter("task_id");
            String task_uid = request.getParameter("task_uid");
            String id = request.getParameter("id");

            // Build modern payload expected by get_ticket_by_id: prefer task_id/task_uid
            JSONObject obj = new JSONObject();
            if (task_id != null && !task_id.isEmpty())
                obj.put("task_id", task_id);
            else if (task_uid != null && !task_uid.isEmpty())
                obj.put("task_uid", task_uid);
            else if (id != null && !id.isEmpty())
                obj.put("task_id", id);

            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");
                if (userInfo != null && userInfo.get("id") != null) {
                    obj.put("user_id", Integer.parseInt(userInfo.get("id").toString()));
                }
            } catch (Exception ignore) {
            }

            // If neither id is present, return explicit error to client
            if (!obj.has("task_id") && !obj.has("task_uid")) {
                return "{\"success\": false, \"message\": \"Either task_id or task_uid is required\"}";
            }

            webServiceResponse = ticketService.getTicketById(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());
            return webServiceResponse;

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            // try {
            // errorResponse.put("status", "error");
            // errorResponse.put("message", "Error adding fees item: " + e.getMessage());

            // response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // response.setContentType("application/json");
            // response.getWriter().write(errorResponse.toString());
            // } catch (JSONException e1) {
            // // TODO Auto-generated catch block
            // e1.printStackTrace();
            // }

        }

        return null;

    }
    // @PostMapping("/assign_ticket")
    // public String assignTicket(HttpSession session, HttpServletRequest request,
    // HttpServletResponse response) {
    // if (request.getRequestedSessionId() != null &&
    // !request.isRequestedSessionIdValid()) {
    // // Session is expired
    // request.setAttribute("login", "sessionout");
    // return "login";
    // }

    // //
    // {"title":"DHCCHCHD","description":"DEHHEHDHYD","priority_id":"high","department_id":"it","category_id":"ht"}
    // try {
    // JSONObject obj = new JSONObject();
    // //String academic_year = request.getParameter("academic_year");
    // String task_id = request.getParameter("task_id");
    // String user_to_assign_id = request.getParameter("user_to_assign_id");

    // //obj.put("academic_year", academic_year);
    // obj.put("task_id", task_id);
    // obj.put("user_to_assign_id", user_to_assign_id);

    // System.out.println("JSON Request: " + obj.toString());

    // // Call web service
    // webServiceResponse = ticketService.archiveTicket(
    // wsURLConfig.getWeb_service_url_ser(),
    // wsURLConfig.getWeb_service_url_ser_api_key(),
    // obj.toString()
    // );

    // return webServiceResponse;

    // } catch (Exception e) {
    // e.printStackTrace();
    // JSONObject errorResponse = new JSONObject();
    // // try {
    // // errorResponse.put("status", "error");
    // // errorResponse.put("message", "Error adding fees item: " + e.getMessage());

    // // response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    // // response.setContentType("application/json");
    // // response.getWriter().write(errorResponse.toString());
    // // } catch (JSONException e1) {
    // // // TODO Auto-generated catch block
    // // e1.printStackTrace();
    // // }

    // }

    // return null;

    // }

    @PostMapping("/load")
    public String loadTicket(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            // Session is expired
            request.setAttribute("login", "sessionout");
            return "login";
        }

        // {"title":"DHCCHCHD","description":"DEHHEHDHYD","priority_id":"high","department_id":"it","category_id":"ht"}
        try {
            JSONObject obj = new JSONObject();
            // String academic_year = request.getParameter("academic_year");
            String task_status = request.getParameter("task_status");
            String created_from = request.getParameter("created_from");
            String created_to = request.getParameter("created_to");

            // obj.put("academic_year", academic_year);
            obj.put("task_status", task_status);
            if (created_from != null && !created_from.isEmpty())
                obj.put("created_from", created_from);
            if (created_to != null && !created_to.isEmpty())
                obj.put("created_to", created_to);

            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");
                if (userInfo != null) {
                    Object orgId = userInfo.get("organization_id");
                    if (orgId != null)
                        obj.put("organization_id", String.valueOf(orgId));
                    Object userId = userInfo.get("id");
                    if (userId != null)
                        obj.put("user_id", Integer.parseInt(String.valueOf(userId)));
                }
            } catch (Exception ignore) {
            }

            System.out.println("JSON Request: " + obj.toString());

            // Call web service
            webServiceResponse = ticketService.select_get_active_all_task(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());

            return webServiceResponse;

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            // try {
            // errorResponse.put("status", "error");
            // errorResponse.put("message", "Error adding fees item: " + e.getMessage());

            // response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // response.setContentType("application/json");
            // response.getWriter().write(errorResponse.toString());
            // } catch (JSONException e1) {
            // // TODO Auto-generated catch block
            // e1.printStackTrace();
            // }

        }

        return null;

    }

    // @PutMapping("/{ticketId}/update")
    // public ResponseEntity<?> updateTicket(@PathVariable String ticketId,
    // @RequestBody Map<String, Object> ticketData,
    // HttpSession session) {
    // if (!isAuthenticatedUtil.isAuthenticated(session)) {
    // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
    // \"SESSION_INVALID.\"}");
    // }

    // try {
    // @SuppressWarnings("unchecked")
    // Map<String, Object> userInfo = (Map<String, Object>)
    // session.getAttribute("userInfo");
    // Integer userId = Integer.parseInt(userInfo.get("id").toString());

    // ticketData.put("updated_by", userId);
    // ticketData.put("ticket_id", ticketId);

    // webServiceResponse =
    // ticketService.updateTicket( wsURLConfig.getWeb_service_url_ser(),
    // wsURLConfig.getWeb_service_url_ser_api_key(),
    // ticketData);

    // return ResponseEntity.ok(webServiceResponse);

    // } catch (Exception e) {
    // logger.severe("Error updating ticket: " + e.getMessage());
    // e.printStackTrace();
    // return ResponseEntity.status(500).body("{\"status\": \"error\", \"message\":
    // \"Failed to update ticket: " + e.getMessage() + "\"}");
    // }
    // }

    @GetMapping("/{ticketId}/comments")
    public ResponseEntity<?> getTicketComments(@PathVariable String ticketId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = ticketService.getTicketComments(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    ticketId);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching ticket comments: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch comments: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/{ticketId}/comments")
    public ResponseEntity<?> addTicketComment(@PathVariable String ticketId,
            @RequestBody Map<String, Object> commentData,
            HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            Integer userId = Integer.parseInt(userInfo.get("id").toString());

            commentData.put("ticket_id", ticketId);
            commentData.put("user_id", userId);

            webServiceResponse = ticketService.addTicketComment(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    commentData);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error adding comment: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to add comment: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/{ticketId}/history")
    public ResponseEntity<?> getTicketHistory(@PathVariable String ticketId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = ticketService.getTicketHistory(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    ticketId);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching ticket history: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch history: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/priorities")
    public ResponseEntity<?> getPriorities(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = ticketService.getPriorities(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching priorities: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to fetch priorities: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/statuses")
    public ResponseEntity<?> getStatuses(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = ticketService.getStatuses(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching statuses: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch statuses: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/statuses/list")
    public ResponseEntity<?> listStatuses(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            // Get user info if available, but don't fail if not
            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");
                // Log for debug but continue
                // if (userInfo == null) logger.warning("Session userInfo is null in
                // listStatuses");
            } catch (Exception ignore) {
            }

            webServiceResponse = ticketService.getStatuses(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch statuses: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/statuses/add")
    public ResponseEntity<?> addStatus(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.addStatus(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to add status: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/statuses/update")
    public ResponseEntity<?> updateStatus(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.updateStatus(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to update status: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/statuses/delete")
    public ResponseEntity<?> deleteStatus(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.deleteStatus(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to delete status: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/statuses/get_by_id")
    public ResponseEntity<?> getStatusById(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.getStatusById(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch status: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/departments")
    public ResponseEntity<?> getDepartments(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = ticketService.getDepartments(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching departments: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to fetch departments: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/categories")
    public ResponseEntity<?> getCategories(@RequestParam(required = false) String departmentId,
            HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = ticketService.getCategories(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    departmentId);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching categories: " + e.getMessage());
            e.printStackTrace();
            try {
                webServiceResponse = ticketService.getCategoriesMgt(wsURLConfig.getWeb_service_url_ser(),
                        wsURLConfig.getWeb_service_url_ser_api_key());
                return ResponseEntity.ok(webServiceResponse);
            } catch (Exception e2) {
                logger.severe("Fallback getCategoriesMgt failed: " + e2.getMessage());
                return ResponseEntity.status(500).body(
                        "{\"status\": \"error\", \"message\": \"Failed to fetch categories: " + e.getMessage() + "\"}");
            }
        }
    }

    @PostMapping("/categories/list")
    public ResponseEntity<?> listCategories(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            // Get user info if available, but don't fail if not
            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");
            } catch (Exception ignore) {
            }

            webServiceResponse = ticketService.getCategoriesMgt(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch categories: " + e.getMessage()
                            + "\"}");
        }
    }

    @PostMapping("/categories/add")
    public ResponseEntity<?> addCategory(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.addCategory(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to add category: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/categories/delete")
    public ResponseEntity<?> deleteCategory(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.deleteCategory(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to delete category: " + e.getMessage()
                            + "\"}");
        }
    }

    @PostMapping("/priorities/list")
    public ResponseEntity<?> listPriorities(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            // Get user info if available, but don't fail if not
            try {
                @SuppressWarnings("unchecked")
                java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session
                        .getAttribute("userInfo");
            } catch (Exception ignore) {
            }

            webServiceResponse = ticketService.getPrioritiesMgt(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch priorities: " + e.getMessage()
                            + "\"}");
        }
    }

    @PostMapping("/priorities/add")
    public ResponseEntity<?> addPriority(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.addPriority(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to add priority: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/priorities/delete")
    public ResponseEntity<?> deletePriority(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = ticketService.deletePriority(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to delete priority: " + e.getMessage()
                            + "\"}");
        }
    }

    @GetMapping("/my-tickets")
    public ResponseEntity<?> getMyTickets(HttpSession session,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            Integer userId = Integer.parseInt(userInfo.get("id").toString());

            webServiceResponse = ticketService.getUserTickets(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userId,
                    page,
                    size);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching user tickets: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch tickets: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/assigned-to-me")
    public ResponseEntity<?> getTicketsAssignedToMe(HttpSession session,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            Integer userId = Integer.parseInt(userInfo.get("id").toString());

            webServiceResponse = ticketService.getTicketsAssignedToUser(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userId,
                    page,
                    size);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching assigned tickets: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch assigned tickets: " + e.getMessage()
                            + "\"}");
        }
    }

    @PostMapping("/{ticketId}/close")
    public ResponseEntity<?> closeTicket(@PathVariable String ticketId,
            @RequestBody Map<String, Object> closeData,
            HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            Integer userId = Integer.parseInt(userInfo.get("id").toString());

            closeData.put("ticket_id", ticketId);
            closeData.put("closed_by", userId);

            webServiceResponse = ticketService.closeTicket(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    closeData);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error closing ticket: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to close ticket: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/{ticketId}/reopen")
    public ResponseEntity<?> reopenTicket(@PathVariable String ticketId,
            HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            Integer userId = Integer.parseInt(userInfo.get("id").toString());

            webServiceResponse = ticketService.reopenTicket(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    ticketId,
                    userId);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error reopening ticket: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to reopen ticket: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/stats")
    public ResponseEntity<?> getTicketStats(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            Integer userId = null;
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
                if (userInfo != null && userInfo.get("id") != null) {
                    userId = Integer.parseInt(userInfo.get("id").toString());
                }
            } catch (Exception ignore) {
            }

            webServiceResponse = ticketService.getTicketStats(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), userId);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching ticket stats: " + e.getMessage());
            e.printStackTrace();
            try {
                String listStr = ticketService.getAllTickets(wsURLConfig.getWeb_service_url_ser(),
                        wsURLConfig.getWeb_service_url_ser_api_key());
                int open = 0, inProgress = 0, resolved = 0, closed = 0;
                JSONArray arr = null;
                try {
                    JSONObject obj = new JSONObject(listStr);
                    if (obj.has("data")) {
                        arr = obj.optJSONArray("data");
                    } else if (obj.has("tickets")) {
                        arr = obj.optJSONArray("tickets");
                    }
                } catch (Exception ignore) {
                }
                if (arr == null) {
                    try {
                        arr = new JSONArray(listStr);
                    } catch (Exception ignore) {
                    }
                }
                if (arr != null) {
                    for (int i = 0; i < arr.length(); i++) {
                        JSONObject t = arr.optJSONObject(i);
                        if (t == null)
                            continue;
                        String st = String.valueOf(t.opt("task_status")).toLowerCase();
                        if (st.contains("open"))
                            open++;
                        else if (st.contains("progress"))
                            inProgress++;
                        else if (st.contains("resolve"))
                            resolved++;
                        else if (st.contains("close"))
                            closed++;
                    }
                }
                int total = open + inProgress + resolved + closed;
                JSONObject stats = new JSONObject();
                stats.put("open", open);
                stats.put("in_progress", inProgress);
                stats.put("resolved", resolved);
                stats.put("closed", closed);
                stats.put("total", total);
                return ResponseEntity.ok(stats.toString());
            } catch (Exception e2) {
                logger.severe("Stats fallback failed: " + e2.getMessage());
                return ResponseEntity.status(500)
                        .body("{\"status\": \"error\", \"message\": \"Failed to fetch stats: " + e.getMessage()
                                + "\"}");
            }
        }
    }

    @PostMapping("/update_tickets")
    public String editticket(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            // Session is expired
            request.setAttribute("login", "sessionout");
            return "login";
        }

        // {"title":"DHCCHCHD","description":"DEHHEHDHYD","priority_id":"high","department_id":"it","category_id":"ht"}
        try {
            JSONObject obj = new JSONObject();
            // String academic_year = request.getParameter("academic_year");
            String task_subject = request.getParameter("task_subject");
            String task_id = request.getParameter("task_id");
            String task_type = request.getParameter("task_type");
            String task_description = request.getParameter("task_description");
            String task_priority = request.getParameter("task_priority");
            String task_remarks = request.getParameter("task_remarks");
            String status_id = request.getParameter("status_id");

            // obj.put("academic_year", academic_year);
            obj.put("task_subject", task_subject);
            obj.put("task_id", task_id);
            obj.put("task_type", task_type);
            obj.put("task_description", task_description);
            obj.put("task_priority", task_priority);
            obj.put("task_remarks", task_remarks);
            if (status_id != null && !status_id.isEmpty())
                obj.put("status_id", status_id);

            System.out.println("JSON Request: " + obj.toString());

            // Call web service
            webServiceResponse = ticketService.editTicket(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());

            return webServiceResponse;

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            // try {
            // errorResponse.put("status", "error");
            // errorResponse.put("message", "Error adding fees item: " + e.getMessage());

            // response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // response.setContentType("application/json");
            // response.getWriter().write(errorResponse.toString());
            // } catch (JSONException e1) {
            // // TODO Auto-generated catch block
            // e1.printStackTrace();
            // }

        }

        return null;

    }

    @PostMapping("/assign_ticket")
    public String assignticket(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            // Session is expired
            request.setAttribute("login", "sessionout");
            return "login";
        }

        // {"title":"DHCCHCHD","description":"DEHHEHDHYD","priority_id":"high","department_id":"it","category_id":"ht"}
        try {
            JSONObject obj = new JSONObject();
            // String academic_year = request.getParameter("academic_year");
            String task_id = request.getParameter("task_id");
            String user_to_assign_id = request.getParameter("user_to_assign_id");

            // obj.put("academic_year", academic_year);
            obj.put("task_id", task_id);
            obj.put("user_to_assign_id", user_to_assign_id);

            // Map to user_uuid as expected by the backend
            obj.put("user_uuid", user_to_assign_id);
            obj.put("p_user_uuid", user_to_assign_id); // Fallback if p_ convention is used

            System.out.println("JSON tt Request: " + obj.toString());

            // Call web service
            webServiceResponse = ticketService.assignTicket(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());

            if (webServiceResponse == null || webServiceResponse.trim().isEmpty()) {
                org.codehaus.jettison.json.JSONObject ok = new org.codehaus.jettison.json.JSONObject();
                ok.put("status", "Success");
                ok.put("msg", "Ticket assigned successfully");
                return ok.toString();
            }
            return webServiceResponse;

        } catch (Exception e) {
            try {
                org.codehaus.jettison.json.JSONObject err = new org.codehaus.jettison.json.JSONObject();
                err.put("status", "error");
                err.put("message", "Error assigning ticket: " + e.getMessage());
                return err.toString();
            } catch (org.codehaus.jettison.json.JSONException ignore) {
                return "{\"status\":\"error\",\"message\":\"Error assigning ticket\"}";
            }
        }

    }

    @PostMapping("/archive_ticket")
    public ResponseEntity<String> archiveticket(HttpSession session, HttpServletRequest request,
            HttpServletResponse response) {
        if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            // Session is expired - return JSON with 401 so AJAX callers don't receive HTML
            // login page
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"error\":\"sessionout\"}");
        }

        try {
            JSONObject obj = new JSONObject();
            // Prefer form parameters (existing code) but accept JSON body as well for
            // modern clients
            String task_id = request.getParameter("task_id");
            if (task_id == null || task_id.trim().isEmpty()) {
                // attempt to read JSON body
                StringBuilder sb = new StringBuilder();
                try (java.io.BufferedReader reader = request.getReader()) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        sb.append(line);
                    }
                } catch (Exception readEx) {
                    logger.fine("No request body to read for archive_ticket: " + readEx.getMessage());
                }
                String body = sb.toString().trim();
                if (!body.isEmpty()) {
                    try {
                        JSONObject bodyJson = new JSONObject(body);
                        if (bodyJson.has("task_id")) {
                            task_id = bodyJson.optString("task_id", null);
                        }
                    } catch (Exception parseEx) {
                        logger.fine("Failed to parse JSON body for archive_ticket: " + parseEx.getMessage());
                    }
                }
            }
            obj.put("task_id", task_id);

            System.out.println("JSON tt Request: " + obj.toString());

            if (task_id == null || task_id.trim().isEmpty()) {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("status", "Error");
                errorResponse.put("msg", "Missing task_id in request");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse.toString());
            }

            // Call web service
            webServiceResponse = ticketService.archiveTicket(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());

            // If the downstream service returned an empty/blank response, return a clear
            // JSON error
            if (webServiceResponse == null || webServiceResponse.trim().isEmpty()) {
                JSONObject emptyResp = new JSONObject();
                emptyResp.put("status", "Error");
                emptyResp.put("msg", "Archive service returned empty response");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(emptyResp.toString());
            }

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorResponse = new JSONObject();
            // Return a JSON error response with 500
            try {
                errorResponse.put("error", e.getMessage());
            } catch (JSONException je) {
                // ignore
            }
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse.toString());
        }
    }

    @PostMapping("/get_task_uuid")
    public ResponseEntity<Map<String, String>> getTaskUuid(@RequestBody Map<String, Object> requestBody) {
        Map<String, String> response = new HashMap<>();
        try {
            Object idObj = requestBody.get("id");
            if (idObj == null) {
                response.put("error", "Missing id");
                return ResponseEntity.badRequest().body(response);
            }

            Long numericId = Long.valueOf(idObj.toString());

            // Try schema-qualified table first, then fall back to an unqualified table
            // name.
            String[] candidateSql = new String[] {
                    "SELECT task_id FROM tickets_mgt.tasks WHERE id = ?",
                    "SELECT task_id FROM tasks WHERE id = ?"
            };

            String taskIdStr = null;
            for (String sql : candidateSql) {
                try {
                    // query as String to be compatible with different JDBC drivers/DBs
                    taskIdStr = jdbcTemplate.queryForObject(sql, new Object[] { numericId }, String.class);
                    if (taskIdStr != null && !taskIdStr.isEmpty()) {
                        break;
                    }
                } catch (DataAccessException dae) {
                    // Table or query might not exist in the local/dev DB (H2). Try the next
                    // candidate.
                    logger.fine("getTaskUuid: query failed for sql [" + sql + "]: " + dae.getMessage());
                }
            }

            if (taskIdStr != null && !taskIdStr.isEmpty()) {
                response.put("task_id", taskIdStr);
                return ResponseEntity.ok(response);
            } else {
                response.put("error", "Task not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

        } catch (NumberFormatException nfe) {
            response.put("error", "Invalid id");
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            logger.severe("Error in getTaskUuid: " + e.getMessage());
            response.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    // end of TicketRest
}
