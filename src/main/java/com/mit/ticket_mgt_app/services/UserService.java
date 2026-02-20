package com.mit.ticket_mgt_app.services;

import java.util.logging.Logger;

import org.springframework.stereotype.Service;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class UserService {

    private static final Logger logger = Logger.getLogger(UserService.class.getName());

    public String addUser(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            try {
                Client client = Client.create();
                // Ensure URL ends with slash
                String base = web_service_url == null ? "" : web_service_url;
                if (!base.endsWith("/"))
                    base += "/";

                WebResource webResource = client.resource(base + "v1/user_service/add_user");

                ClientResponse response_ws = webResource.type("application/json")
                        .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
                if (response_ws.getStatus() != 200) {
                    String errBody = null;
                    try {
                        errBody = response_ws.getEntity(String.class);
                    } catch (Exception ignore) {
                    }
                    throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus()
                            + (errBody != null ? " | " + errBody : ""));
                }
                output = response_ws.getEntity(String.class);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return output;
    }

    public String loadUsers(String web_service_url, String web_service_api_key, int page, int limit, String search,
            String currentUserUniqueId) {
        String output = null;
        try {
            try {
                Client client = Client.create();
                // Ensure URL ends with slash
                String base = web_service_url == null ? "" : web_service_url;
                if (!base.endsWith("/"))
                    base += "/";

                WebResource webResource = client.resource(base + "v1/user_service/load_users");

                org.codehaus.jettison.json.JSONObject obj = new org.codehaus.jettison.json.JSONObject();
                obj.put("page", page);
                obj.put("limit", limit);
                obj.put("search", search == null ? "" : search);
                if (currentUserUniqueId != null) {
                    obj.put("current_user_unique_id", currentUserUniqueId);
                }

                ClientResponse response_ws = webResource.type("application/json")
                        .header("x-api-key", web_service_api_key).post(ClientResponse.class, obj.toString());

                if (response_ws.getStatus() != 200) {
                    String errBody = null;
                    try {
                        errBody = response_ws.getEntity(String.class);
                    } catch (Exception ignore) {
                    }
                    throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                            (errBody != null ? " | Body: " + errBody : ""));
                }
                output = response_ws.getEntity(String.class);
            } catch (Exception e) {
                e.printStackTrace();
                throw new RuntimeException("Error calling load_users: " + e.getMessage(), e);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw e; // Re-throw to controller
        }

        return output;
    }

    public String getUserById(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            // Ensure URL ends with slash
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";

            WebResource webResource = client.resource(base + "v1/user_service/get_user_by_id");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus()
                        + (errBody != null ? " | " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting user by ID: " + e.getMessage(), e);
        }

        return output;
    }

    public String updateUser(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            // Ensure URL ends with slash
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";

            WebResource webResource = client.resource(base + "v1/user_service/update_user");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus()
                        + (errBody != null ? " | " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error updating user: " + e.getMessage(), e);
        }

        return output;
    }

    public String getUserProfile(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            // Ensure URL ends with slash
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";

            WebResource webResource = client.resource(base + "v1/user_service/get_user_profile");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus()
                        + (errBody != null ? " | " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return output;
    }

    public String setForcePasswordChange(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            // Ensure URL ends with slash
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";

            String url = base + "v1/user_service/set_force_password_change";
            logger.info("Calling external service: " + url);
            WebResource webResource = client.resource(url);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                logger.severe("External service failed. Status: " + response_ws.getStatus() + ", Body: " + errBody);
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null ? " | Body: " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error setting force password change: " + e.getMessage(), e);
        }

        return output;
    }

    public String setDefaultPassword(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            // Ensure URL ends with slash
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";

            String url = base + "v1/user_service/set_default_password";
            logger.info("Calling external service: " + url + " with payload: " + json_request);
            WebResource webResource = client.resource(url);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                logger.severe("External service failed. Status: " + response_ws.getStatus() + ", Body: " + errBody);
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null ? " | Body: " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error setting default password: " + e.getMessage(), e);
        }

        return output;
    }

    public String resetPasswordWithDefault(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            // Ensure URL ends with slash
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";

            // Assuming the remote endpoint follows the pattern
            WebResource webResource = client.resource(base + "reset_password_with_default");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                // Try to read body for error message
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus()
                        + (errBody != null ? " | " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error resetting password with default: " + e.getMessage(), e);
        }

        return output;
    }
}
