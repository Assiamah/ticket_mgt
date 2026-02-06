package com.mit.ticket_mgt_app.services;

import org.springframework.stereotype.Service;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class CategoryService {
    public String addCategory(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "api/tickets_mgt_services/add_category");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, jsonRequest);
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
