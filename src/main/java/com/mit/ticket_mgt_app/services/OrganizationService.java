package com.mit.ticket_mgt_app.services;

import org.springframework.stereotype.Service;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class OrganizationService {
    public String loadOrganizations(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/organization_service/get_all_organizations");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return output;
    }

    public String createOrganization(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/organization_service/add_organization");
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

    public String blockOrganization(String web_service_url, String web_service_api_key, String orgId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/organization_service/update_organization");
            String body = "{\"org_id\": \"" + orgId + "\", \"status\": \"blocked\"}";
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).put(ClientResponse.class, body);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return output;
    }

    public String unblockOrganization(String web_service_url, String web_service_api_key, String orgId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/organization_service/update_organization");
            String body = "{\"org_id\": \"" + orgId + "\", \"status\": \"active\"}";
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).put(ClientResponse.class, body);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return output;
    }

    public String updateOrganization(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/organization_service/update_organization");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).put(ClientResponse.class, jsonRequest);
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