package com.mit.ticket_mgt_app.services;

import org.springframework.stereotype.Service;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

import java.util.*;

import com.mit.ticket_mgt_app.model.Menu;

@Service
public class MenuService {
    public List<Menu> buildMenuTree(List<Menu> flatMenus) {
        Map<Integer, Menu> menuMap = new HashMap<>();
        List<Menu> rootMenus = new ArrayList<>();

        // Map all menus by id
        for (Menu menu : flatMenus) {
            menuMap.put(menu.getId(), menu);
        }

        // Assign children to parents
        for (Menu menu : flatMenus) {
            if (menu.getParentId() == null) {
                rootMenus.add(menu);
            } else {
                Menu parent = menuMap.get(menu.getParentId());
                if (parent != null) {
                    parent.getChildren().add(menu);
                }
            }
        }

        // Sort by position
        rootMenus.sort(Comparator.comparingInt(Menu::getPosition));
        for (Menu menu : menuMap.values()) {
            menu.getChildren().sort(Comparator.comparingInt(Menu::getPosition));
        }

        return rootMenus;
    }

    public String getMenus(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/menu_service/get_all_menus");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting menus: " + e.getMessage(), e);
        }

        return output;
    }

    public String getUserMenus(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/menu_service/get_user_menus");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error getting user menus: " + e.getMessage(), e);
        }

        return output;
    }

    public String saveUserMenus(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/menu_service/save_user_menus");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error saving user menus: " + e.getMessage(), e);
        }

        return output;
    }
}
