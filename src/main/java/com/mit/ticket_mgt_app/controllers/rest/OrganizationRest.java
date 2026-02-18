package com.mit.ticket_mgt_app.controllers.rest;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mit.ticket_mgt_app.services.OrganizationService;
import com.mit.ticket_mgt_app.config.WebServiceURLConfig;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/v1/organization_service")
public class OrganizationRest {

    @Autowired
    private OrganizationService organizationService;

    private final WebServiceURLConfig wsURLConfig;

    // @Autowired
    // private isAuthenticatedUtil isAuthenticatedUtil;

    private String webServiceResponse = null;

    public OrganizationRest(WebServiceURLConfig wsURLConfig) {
        this.wsURLConfig = wsURLConfig;
    }

    @GetMapping("/get_all_organizations")
    public ResponseEntity<?> loadOrganizations(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            webServiceResponse = organizationService.loadOrganizations(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), "{}");
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to load organizations: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/add_organization")
    public ResponseEntity<?> createOrganization(@RequestBody Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = organizationService.createOrganization(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to create organization: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/block_organization")
    public ResponseEntity<?> blockOrganization(@RequestBody Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            String orgId = (String) payload.get("org_id");
            webServiceResponse = organizationService.blockOrganization(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), orgId);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to block organization: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/unblock_organization")
    public ResponseEntity<?> unblockOrganization(@RequestBody Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            String orgId = (String) payload.get("org_id");
            webServiceResponse = organizationService.unblockOrganization(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), orgId);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to unblock organization: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/fetch_archived_tickets")
    public ResponseEntity<?> fetchArchivedTickets(@RequestBody Map<String, Object> payload, HttpSession session) {
        try {
            // Add user info to payload if available
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
                System.out.println("DEBUG: OrganizationRest session userInfo: " + userInfo);
                if (userInfo != null) {
                    // Extract User ID
                    if (!payload.containsKey("user_id")) {
                        Object uniqueId = userInfo.get("unique_id");
                        Object userId = userInfo.get("user_id");
                        Object id = userInfo.get("id");

                        // Prefer UUID (unique_id)
                        if (uniqueId != null && isValidUUID(uniqueId.toString())) {
                            payload.put("user_id", uniqueId.toString());
                        } else if (userId != null && isValidUUID(userId.toString())) {
                            payload.put("user_id", userId.toString());
                        } else if (id != null && isValidUUID(id.toString())) {
                            payload.put("user_id", id.toString());
                        } else {
                            // If no valid UUID found, do NOT send numeric ID to avoid DB type mismatch
                            // If needed, we can log this scenario
                            System.out.println(
                                    "DEBUG: No valid UUID found for user_id. Skipping injection to avoid type mismatch. Available IDs: unique_id="
                                            + uniqueId + ", id=" + id);
                        }
                    }

                    // Extract Organization ID
                    if (!payload.containsKey("org_id")) {
                        Object orgId = userInfo.get("org_id");
                        if (orgId == null)
                            orgId = userInfo.get("organization_id");
                        if (orgId == null)
                            orgId = userInfo.get("organizationId");
                        if (orgId == null)
                            orgId = userInfo.get("company_id");
                        if (orgId == null)
                            orgId = userInfo.get("business_id");

                        if (orgId == null) {
                            // Check for nested organization object
                            Object orgObj = userInfo.get("organization");
                            if (orgObj instanceof Map) {
                                Map<?, ?> orgMap = (Map<?, ?>) orgObj;
                                if (orgMap.get("id") != null)
                                    orgId = orgMap.get("id");
                                else if (orgMap.get("org_id") != null)
                                    orgId = orgMap.get("org_id");
                            }
                        }

                        if (orgId != null) {
                            payload.put("org_id", orgId);
                        } else {
                            System.out.println("DEBUG: Organization ID not found in session for getOrgArchivedTasks.");
                            // Attempt to use user_id as org_id if user is System Owner?
                            // This is a guess, but if the user is a system owner, maybe their ID maps to
                            // the main org?
                            // Let's NOT guess too much, but print the debug.
                        }
                    }
                }
            } catch (Exception ignore) {
            }

            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = organizationService.fetchArchivedTickets(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to fetch archived tickets: " + e.getMessage()
                            + "\"}");
        }
    }

    @PostMapping("/get_org_archived_tasks")
    public ResponseEntity<?> getOrgArchivedTasks(@RequestBody Map<String, Object> payload, HttpSession session) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            if (userInfo != null) {
                // Extract User ID
                if (!payload.containsKey("user_id")) {
                    Object uniqueId = userInfo.get("unique_id");
                    Object userId = userInfo.get("user_id");
                    Object id = userInfo.get("id");

                    if (uniqueId != null && isValidUUID(uniqueId.toString())) {
                        payload.put("user_id", uniqueId.toString());
                    } else if (userId != null && isValidUUID(userId.toString())) {
                        payload.put("user_id", userId.toString());
                    } else if (id != null && isValidUUID(id.toString())) {
                        payload.put("user_id", id.toString());
                    }
                }

                // Extract Organization ID
                // Map session org_id to p_org_id and organization_id if not present
                Object orgId = null;
                if (!payload.containsKey("p_org_id") || !payload.containsKey("organization_id")) {
                    orgId = userInfo.get("org_id");
                    if (orgId == null)
                        orgId = userInfo.get("organization_id");
                    if (orgId == null)
                        orgId = userInfo.get("organizationId");
                    if (orgId == null)
                        orgId = userInfo.get("company_id");
                    if (orgId == null)
                        orgId = userInfo.get("business_id");

                    if (orgId == null) {
                        Object orgObj = userInfo.get("organization");
                        if (orgObj instanceof Map) {
                            Map<?, ?> orgMap = (Map<?, ?>) orgObj;
                            if (orgMap.get("id") != null)
                                orgId = orgMap.get("id");
                            else if (orgMap.get("org_id") != null)
                                orgId = orgMap.get("org_id");
                        }
                    }

                    if (orgId != null) {
                        if (!payload.containsKey("p_org_id"))
                            payload.put("p_org_id", orgId);
                        if (!payload.containsKey("organization_id"))
                            payload.put("organization_id", orgId);
                    }
                }
            }

            // Ensure payload has defaults if missing
            if (!payload.containsKey("p_limit"))
                payload.put("p_limit", 50);
            if (!payload.containsKey("p_offset"))
                payload.put("p_offset", 0);

            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = organizationService.getOrgArchivedTasks(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to get organization archived tasks: "
                            + e.getMessage() + "\"}");
        }
    }

    @org.springframework.web.bind.annotation.PutMapping("/update_organization")
    public ResponseEntity<?> updateOrganization(@RequestBody Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = organizationService.updateOrganization(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to update organization: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/get_organization_by_id")
    public ResponseEntity<?> getOrganizationById(@RequestBody Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            String orgId = (String) payload.get("org_id");
            webServiceResponse = organizationService.getOrganizationById(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), orgId);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to get organization: " + e.getMessage() + "\"}");
        }
    }

    private boolean isValidUUID(String uuid) {
        if (uuid == null)
            return false;
        try {
            java.util.UUID.fromString(uuid);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}