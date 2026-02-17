package com.mit.ticket_mgt_app.services;

import org.springframework.stereotype.Service;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class ProductService {
    public String getAllProducts(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/product_service/get_all_products");
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

    public String addProduct(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/product_service/add_product");
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

    public String deleteProduct(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/product_service/delete_product");
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

    public String getProductById(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/product_service/get_product_by_id");
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

    public String updateProduct(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/product_service/update_product");
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
