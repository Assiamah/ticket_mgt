package com.mit.ticket_mgt_app.controllers.rest;

import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mit.ticket_mgt_app.config.WebServiceURLConfig;
import com.mit.ticket_mgt_app.services.MenuService;
import com.mit.ticket_mgt_app.services.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/users")
public class UserRest {

    private final WebServiceURLConfig wsURLConfig;
    private final UserService userService;
    private final MenuService menuService;

    public UserRest(WebServiceURLConfig wsURLConfig, UserService userService, MenuService menuService) {
        this.wsURLConfig = wsURLConfig;
        this.userService = userService;
        this.menuService = menuService;
    }

    private static final Logger logger = Logger.getLogger(UserRest.class.getName());

    // @Autowired
    // private isAuthenticatedUtil isAuthenticatedUtil;

    String webServiceResponse = "";
    String requestType = "";

    @GetMapping
    public ResponseEntity<?> loadUsers(
            HttpSession session,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) String search) {

        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            // Get current user unique ID from session
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            String currentUserUniqueId = userInfo != null ? (String) userInfo.get("unique_id") : null;

            // Call service to get users with pagination and search
            webServiceResponse = userService.loadUsers(wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    page, limit, search, currentUserUniqueId);

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching users: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch users: " + e.getMessage() + "\"}");
        }
    }

    // Get user by ID
    @GetMapping("/{userId:\\d+}")
    public ResponseEntity<?> getUserById(@PathVariable Long userId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            JSONObject requestJson = new JSONObject();
            requestJson.put("user_id", userId);

            webServiceResponse = userService.getUserById(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    requestJson.toString());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching user: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch user: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/actions/set_force_password_change")
    public ResponseEntity<?> setForcePasswordChange(@RequestBody Map<String, Object> requestData, HttpSession session) {
        logger.info("Received request for setForcePasswordChange");
        // Authentication Guideline: Ensure user is authenticated before processing
        // Basic session check (replace with comprehensive security/auth utility when
        // available)
        if (session.getAttribute("userInfo") == null) {
            return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID\"}");
        }

        try {
            if (!requestData.containsKey("user_id")) {
                return ResponseEntity.badRequest().body("{\"status\": \"error\", \"message\": \"Missing user_id.\"}");
            }

            Object userIdObj = requestData.get("user_id");
            String userId = String.valueOf(userIdObj);

            JSONObject requestJson = new JSONObject();
            requestJson.put("user_id", userId);
            requestJson.put("expire_pass", requestData.getOrDefault("expire_pass", true)); // Default to true if not
                                                                                           // specified, but usually
                                                                                           // it's a toggle

            logger.info("Sending setForcePasswordChange request: " + requestJson.toString());

            webServiceResponse = userService.setForcePasswordChange(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    requestJson.toString());

            return ResponseEntity.ok(webServiceResponse);

        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest()
                    .body("{\"status\": \"error\", \"message\": \"Invalid user_id format: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            logger.severe("Error setting force password change: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to set force password change: "
                            + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/actions/set_default_password")
    public ResponseEntity<?> setDefaultPassword(@RequestBody Map<String, Object> requestData, HttpSession session) {
        logger.info("Received request for setDefaultPassword");
        // Authentication Guideline: Ensure user is authenticated before processing
        // Basic session check (replace with comprehensive security/auth utility when
        // available)
        if (session.getAttribute("userInfo") == null) {
            return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\": \"SESSION_INVALID\"}");
        }

        try {
            if (!requestData.containsKey("user_id")) {
                return ResponseEntity.badRequest().body("{\"status\": \"error\", \"message\": \"Missing user_id.\"}");
            }
            if (!requestData.containsKey("default_password")) {
                return ResponseEntity.badRequest().body("{\"status\": \"error\", \"message\": \"Missing password.\"}");
            }

            Object userIdObj = requestData.get("user_id");
            String userId = String.valueOf(userIdObj);

            // Reverted UUID lookup logic as per request to pass the ID directly
            /*
             * // Fetch user UUID if numeric ID provided
             * if (userId.matches("\\d+")) {
             * try {
             * JSONObject lookupJson = new JSONObject();
             * lookupJson.put("user_id", Long.parseLong(userId));
             * logger.info("Looking up UUID for numeric user_id: " + userId);
             * String userResp = userService.getUserById(
             * wsURLConfig.getWeb_service_url_ser(),
             * wsURLConfig.getWeb_service_url_ser_api_key(),
             * lookupJson.toString());
             * JSONObject userObj = new JSONObject(userResp);
             * // Handle wrapper if present
             * if (userObj.has("user"))
             * userObj = userObj.getJSONObject("user");
             * else if (userObj.has("data"))
             * userObj = userObj.getJSONObject("data");
             * 
             * if (userObj.has("unique_id")) {
             * String uuid = userObj.getString("unique_id");
             * if (uuid != null && !uuid.isEmpty()) {
             * userId = uuid;
             * logger.info("Found UUID: " + userId);
             * }
             * } else {
             * logger.warning("unique_id not found in user response: " +
             * userObj.toString());
             * }
             * } catch (Exception e) {
             * logger.warning("Could not lookup UUID for user_id " + userId + ": " +
             * e.getMessage());
             * // Continue with original ID if lookup fails
             * }
             * }
             */

            JSONObject requestJson = new JSONObject();
            requestJson.put("user_id", userId);
            requestJson.put("default_password", requestData.get("default_password"));

            logger.info("Sending setDefaultPassword request: " + requestJson.toString());

            webServiceResponse = userService.setDefaultPassword(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    requestJson.toString());

            return ResponseEntity.ok(webServiceResponse);

        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest()
                    .body("{\"status\": \"error\", \"message\": \"Invalid user_id format: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            logger.severe("Error setting default password: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to set default password: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping("/profile")
    public ResponseEntity<?> getUserProfile(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");
            Integer userId = Integer.parseInt(userInfo.get("id").toString());

            JSONObject requestJson = new JSONObject();
            requestJson.put("user_id", userId);

            webServiceResponse = userService.getUserProfile(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    requestJson.toString());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching user profile: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to fetch user profile: " + e.getMessage() + "\"}");
        }
    }

    // Get all menus
    @GetMapping("/menus")
    public ResponseEntity<?> getAllMenus(HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            webServiceResponse = menuService.getMenus(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching menus: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("{\"status\": \"error\", \"message\": \"Failed to fetch menus: " + e.getMessage() + "\"}");
        }
    }

    // Get user's assigned menus
    @GetMapping("/{userId}/menus")
    public ResponseEntity<?> getUserMenus(@PathVariable Long userId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            JSONObject requestJson = new JSONObject();
            requestJson.put("user_id", userId);

            webServiceResponse = menuService.getUserMenus(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    requestJson.toString());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error fetching user menus: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to fetch user menus: " + e.getMessage() + "\"}");
        }
    }

    // Save user menu assignments
    @PostMapping("/{userId}/menus")
    public ResponseEntity<?> saveUserMenus(@PathVariable Long userId, @RequestBody Map<String, Object> requestData,
            HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }

        try {
            JSONObject requestJson = new JSONObject();
            requestJson.put("user_id", userId);

            @SuppressWarnings("unchecked")
            Map<String, Object> userInfo = (Map<String, Object>) session.getAttribute("userInfo");

            int handled_by = Integer.parseInt(userInfo.get("id").toString());
            requestJson.put("handled_by", handled_by);

            // Add menu IDs from request
            if (requestData.containsKey("menu_ids")) {
                requestJson.put("menu_ids", new JSONArray((List<?>) requestData.get("menu_ids")));
            }

            webServiceResponse = menuService.saveUserMenus(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    requestJson.toString());

            return ResponseEntity.ok(webServiceResponse);

        } catch (Exception e) {
            logger.severe("Error saving user menus: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to save user menus: " + e.getMessage() + "\"}");
        }
    }

    @PostMapping
    public String addUser(HttpSession session, HttpServletRequest request, HttpServletResponse response,
            @RequestBody Map<String, Object> requestData) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return "{\"status\": \"error\", \"message\": \"SESSION_INVALID.\"}";
        // }

        try {
            requestType = (String) requestData.get("requestType");

            if ("addUser".equals(requestType)) {
                return addUser(session, requestData);
            } else if ("updateUser".equals(requestType)) {
                return updateUser(session, requestData);
            } else {
                return "{\"status\": \"error\", \"message\": \"Invalid request type.\"}";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"status\": \"error\", \"message\": \"An error occurred.\"}";
        }
    }

    private String addUser(HttpSession session, Map<String, Object> userData) {
        try {
            // Validate required fields
            if (!validateUserData(userData)) {
                return "{\"status\": \"error\", \"message\": \"Missing required fields.\"}";
            }

            // Prepare user data for database insertion
            JSONObject userJson = prepareUserJson(userData);
            System.out.println("userJson: " + userJson);

            webServiceResponse = userService.addUser(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userJson.toString());

            return webServiceResponse;
        } catch (Exception e) {
            logger.severe("Error adding user: " + e.getMessage());
            e.printStackTrace();
            return "{\"status\": \"error\", \"message\": \"Failed to create user: " + e.getMessage() + "\"}";
        }
    }

    private String updateUser(HttpSession session, Map<String, Object> userData) {
        try {
            // Validate required fields
            if (!validateUserData(userData)) {
                return "{\"status\": \"error\", \"message\": \"Missing required fields.\"}";
            }

            // Prepare user data for database insertion
            JSONObject userJson = prepareUserJson(userData);
            System.out.println("userJson: " + userJson);

            webServiceResponse = userService.updateUser(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userJson.toString());

            return webServiceResponse;
        } catch (Exception e) {
            logger.severe("Error adding user: " + e.getMessage());
            e.printStackTrace();
            return "{\"status\": \"error\", \"message\": \"Failed to create user: " + e.getMessage() + "\"}";
        }
    }

    @PostMapping("/{userId}/deactivate")
    public ResponseEntity<?> deactivateUser(@PathVariable Long userId, HttpSession session) {
        // if (!isAuthenticatedUtil.isAuthenticated(session)) {
        // return ResponseEntity.status(401).body("{\"status\": \"error\", \"message\":
        // \"SESSION_INVALID.\"}");
        // }
        try {
            JSONObject userJson = new JSONObject();
            userJson.put("user_id", userId);
            userJson.put("status", "inactive");

            webServiceResponse = userService.updateUser(
                    wsURLConfig.getWeb_service_url_ser(),
                    wsURLConfig.getWeb_service_url_ser_api_key(),
                    userJson.toString());

            return ResponseEntity.ok(webServiceResponse);
        } catch (Exception e) {
            logger.severe("Error deactivating user: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).body(
                    "{\"status\": \"error\", \"message\": \"Failed to deactivate user: " + e.getMessage() + "\"}");
        }
    }

    private boolean validateUserData(Map<String, Object> userData) {
        // Check required fields
        if (!userData.containsKey("first_name") || ((String) userData.get("first_name")).isEmpty()) {
            return false;
        }
        if (!userData.containsKey("last_name") || ((String) userData.get("last_name")).isEmpty()) {
            return false;
        }
        if (!userData.containsKey("username") || ((String) userData.get("username")).isEmpty()) {
            return false;
        }
        if (!userData.containsKey("email") || ((String) userData.get("email")).isEmpty()) {
            return false;
        }
        // if (!userData.containsKey("password") || ((String)
        // userData.get("password")).isEmpty()) {
        // return false;
        // }
        if (!userData.containsKey("role") || ((String) userData.get("role")).isEmpty()) {
            return false;
        }

        // Validate email format
        String email = (String) userData.get("email");
        if (!isValidEmail(email)) {
            return false;
        }

        return true;
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email != null && email.matches(emailRegex);
    }

    private JSONObject prepareUserJson(Map<String, Object> userData) throws Exception {
        JSONObject userJson = new JSONObject();

        // Personal information
        userJson.put("user_id", userData.getOrDefault("user_id", ""));
        userJson.put("org_id", userData.getOrDefault("org_id", ""));
        userJson.put("title", userData.getOrDefault("title", ""));
        userJson.put("first_name", userData.get("first_name"));
        userJson.put("last_name", userData.get("last_name"));
        userJson.put("middle_name", userData.getOrDefault("middle_name", ""));

        // Handle date of birth
        if (userData.containsKey("dob") && userData.get("dob") != null) {
            userJson.put("dob", userData.get("dob"));
        }

        userJson.put("gender", userData.getOrDefault("gender", ""));

        // Account information
        userJson.put("username", userData.get("username"));
        userJson.put("email", userData.get("email"));
        userJson.put("password", userData.get("password")); // In production, hash this password!
        userJson.put("role", userData.get("role"));
        userJson.put("level", userData.getOrDefault("level", 1));

        // Contact information
        userJson.put("country_code", userData.getOrDefault("country_code", ""));
        userJson.put("phone_number", userData.getOrDefault("phone_number", ""));
        userJson.put("address", userData.getOrDefault("address", ""));
        userJson.put("zip_code", userData.getOrDefault("zip_code", ""));
        userJson.put("city", userData.getOrDefault("city", ""));
        userJson.put("country", userData.getOrDefault("country", ""));
        userJson.put("nationality", userData.getOrDefault("nationality", ""));

        // Generate full name
        String fullName = buildFullName(
                (String) userData.getOrDefault("title", ""),
                (String) userData.get("first_name"),
                (String) userData.getOrDefault("middle_name", ""),
                (String) userData.get("last_name"));
        userJson.put("full_name", fullName);

        // Security settings
        userJson.put("two_factor_auth", userData.getOrDefault("two_factor_auth", false));
        userJson.put("two_factor_method", userData.getOrDefault("two_factor_method", ""));
        userJson.put("login_notification", userData.getOrDefault("login_notification", false));
        userJson.put("login_approval", userData.getOrDefault("login_approval", false));
        userJson.put("status", userData.getOrDefault("status", "active"));
        userJson.put("expire_pass", userData.getOrDefault("expire_pass", false));

        // System fields
        userJson.put("provider", "LOCAL");

        return userJson;
    }

    private String buildFullName(String title, String firstName, String middleName, String lastName) {
        StringBuilder fullName = new StringBuilder();

        if (title != null && !title.isEmpty()) {
            fullName.append(title).append(" ");
        }
        if (firstName != null && !firstName.isEmpty()) {
            fullName.append(firstName).append(" ");
        }
        if (middleName != null && !middleName.isEmpty()) {
            fullName.append(middleName).append(" ");
        }
        if (lastName != null && !lastName.isEmpty()) {
            fullName.append(lastName);
        }

        return fullName.toString().trim();
    }
}