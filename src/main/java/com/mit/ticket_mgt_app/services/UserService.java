package com.mit.ticket_mgt_app.services;

import org.springframework.stereotype.Service;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class UserService {
    
    public String addUser(String web_service_url, String web_service_api_key, String json_request)
	{
		String output = null;
		try {
			try {
				Client client = Client.create();
				WebResource webResource = client.resource(web_service_url + "v1/user_service/add_user");
				
				ClientResponse response_ws = webResource.type("application/json")
						.header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
				if (response_ws.getStatus() != 200) {
					throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
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

    public String loadUsers(String web_service_url, String web_service_api_key, int page, int limit, String search)
	{
		String output = null;
		try {
			try {
				Client client = Client.create();
				WebResource webResource = client.resource(web_service_url + "v1/user_service/load_users");
				
				ClientResponse response_ws = webResource.type("application/json")
						.header("x-api-key", web_service_api_key).post(ClientResponse.class, "{\"page\": " + page + ", \"limit\": " + limit + ", \"search\": \"" + search + "\"}");
				if (response_ws.getStatus() != 200) {
					throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
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

    public String getUserById(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/user_service/get_user_by_id");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
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
            WebResource webResource = client.resource(web_service_url + "v1/user_service/update_user");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
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
            WebResource webResource = client.resource(web_service_url + "v1/user_service/get_user_profile");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return output;
    }
}
