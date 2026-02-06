package com.mit.ticket_mgt_app.controllers.rest;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mit.ticket_mgt_app.config.WebServiceURLConfig;
import com.mit.ticket_mgt_app.services.CategoryService;

import org.springframework.beans.factory.annotation.Autowired;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/categories")
public class CategoryRest {

    // @Autowired
    // private isAuthenticatedUtil isAuthenticatedUtil;

    private final WebServiceURLConfig wsURLConfig;
    private final CategoryService categoryService;

    public CategoryRest(WebServiceURLConfig wsURLConfig, CategoryService categoryService) {
        this.wsURLConfig = wsURLConfig;
        this.categoryService = categoryService;
    }

    @PostMapping("/add")
    public ResponseEntity<?> addCategory(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        //     return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID.\"}");
        // }
        try {
            @SuppressWarnings("unchecked")
            java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session.getAttribute("userInfo");
            if (userInfo != null && userInfo.get("id") != null) {
                payload.put("created_by", Integer.parseInt(userInfo.get("id").toString()));
            }
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            String res = categoryService.addCategory( wsURLConfig.getWeb_service_url_ser(), wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to add category: " + e.getMessage() + "\"}");
        }
    }
}
