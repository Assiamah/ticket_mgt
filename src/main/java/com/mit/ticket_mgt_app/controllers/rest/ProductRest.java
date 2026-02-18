package com.mit.ticket_mgt_app.controllers.rest;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

import com.mit.ticket_mgt_app.config.WebServiceURLConfig;
import com.mit.ticket_mgt_app.services.ProductService;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/api/products")
public class ProductRest {

    // @Autowired
    // private isAuthenticatedUtil isAuthenticatedUtil;

    private final WebServiceURLConfig wsURLConfig;
    private final ProductService productService;

    public ProductRest(WebServiceURLConfig wsURLConfig, ProductService productService) {
        this.wsURLConfig = wsURLConfig;
        this.productService = productService;
    }

    @GetMapping("")
    public ResponseEntity<?> getAllProducts(@RequestParam(required = false) String org_id, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            org.codehaus.jettison.json.JSONObject payload = new org.codehaus.jettison.json.JSONObject();
            if (org_id != null && !org_id.isEmpty()) {
                payload.put("org_id", org_id);
            }

            String res = productService.getAllProducts(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(), payload.toString());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to load products: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("")
    public ResponseEntity<?> addProduct(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            @SuppressWarnings("unchecked")
            java.util.Map<String, Object> userInfo = (java.util.Map<String, Object>) session.getAttribute("userInfo");
            if (userInfo != null) {
                Object uid = userInfo.get("id");
                if (uid != null)
                    payload.put("created_by", Integer.parseInt(uid.toString()));
                Object orgId = userInfo.get("org_id");
                if (orgId != null)
                    payload.put("org_id", orgId.toString());
            }
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            String res = productService.addProduct(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to create product: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/delete_product")
    public ResponseEntity<?> deleteProduct(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            String res = productService.deleteProduct(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to delete product: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/get_product_by_id")
    public ResponseEntity<?> getProductById(@RequestBody java.util.Map<String, Object> payload, HttpSession session) {
        try {
            org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject(payload);
            String res = productService.getProductById(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    obj.toString());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to get product: " + e.getMessage() + "\"}");
        }
    }
}
