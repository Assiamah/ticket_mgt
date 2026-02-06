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
@RequestMapping("/api/organizations")
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

    @GetMapping("")
    public ResponseEntity<?> loadOrganizations(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        //     return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID.\"}");
        // }
        try {
            webServiceResponse = organizationService.loadOrganizations( wsURLConfig.getWeb_service_url_ser(), wsURLConfig.getWeb_service_url_ser_api_key(), "{}");
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("{\"status\": \"error\", \"message\": \"Failed to load organizations: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("")
    public ResponseEntity<?> createOrganization(@RequestBody Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        //     return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            webServiceResponse = organizationService.createOrganization( wsURLConfig.getWeb_service_url_ser(), wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("{\"status\": \"error\", \"message\": \"Failed to create organization: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/{orgId}/block")
    public ResponseEntity<?> blockOrganization(@PathVariable String orgId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        //     return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID.\"}");
        // }
        try {
            webServiceResponse = organizationService.blockOrganization( wsURLConfig.getWeb_service_url_ser(), wsURLConfig.getWeb_service_url_ser_api_key(), orgId);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("{\"status\": \"error\", \"message\": \"Failed to block organization: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/{orgId}/unblock")
    public ResponseEntity<?> unblockOrganization(@PathVariable String orgId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        //     return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID.\"}");
        // }
        try {
            webServiceResponse = organizationService.unblockOrganization( wsURLConfig.getWeb_service_url_ser(), wsURLConfig.getWeb_service_url_ser_api_key(), orgId);
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("{\"status\": \"error\", \"message\": \"Failed to unblock organization: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/{orgId}/update")
    public ResponseEntity<?> updateOrganization(@PathVariable String orgId, @RequestBody Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        //     return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            obj.put("org_id", orgId);
            webServiceResponse = organizationService.updateOrganization( wsURLConfig.getWeb_service_url_ser(), wsURLConfig.getWeb_service_url_ser_api_key(), obj.toString());
            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("{\"status\": \"error\", \"message\": \"Failed to update organization: " + e.getMessage() + "\"}");
        }
    }
}