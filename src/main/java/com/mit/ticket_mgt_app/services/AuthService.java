package com.mit.ticket_mgt_app.services;

import org.springframework.stereotype.Service;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class AuthService {

	public String userLogin(String web_service_url, String web_service_api_key, String json_request) {

		String output = null;
		try {
			try {
				Client client = Client.create();
				String base = web_service_url == null ? "" : web_service_url;
				if (!base.endsWith("/"))
					base += "/";
				WebResource webResource = client.resource(base + "v1/auth_service/user_login");
				System.out.println(base + "v1/auth_service/user_login");
				ClientResponse response_ws = webResource.type("application/json")
						.header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
				output = response_ws.getEntity(String.class);
				if (response_ws.getStatus() != 200) {
					System.out.println("Failed : HTTP error code : " + response_ws.getStatus());
					// If the response is not 200, and we have an output, we should probably return
					// a JSON error
					// so that the caller can handle it gracefully.
					if (output == null || output.trim().isEmpty() || !output.trim().startsWith("{")) {
						return "{\"success\": false, \"message\": \"HTTP Error " + response_ws.getStatus()
								+ (output != null ? ": " + output : "") + "\"}";
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return output;
	}

	public String verifyOtp(String web_service_url, String web_service_api_key, String json_request) {
		String output = null;
		try {
			try {
				Client client = Client.create();
				String base = web_service_url == null ? "" : web_service_url;
				if (!base.endsWith("/"))
					base += "/";
				WebResource webResource = client.resource(base + "v1/auth_service/verify_otp");

				ClientResponse response_ws = webResource.type("application/json")
						.header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);
				output = response_ws.getEntity(String.class);
				if (response_ws.getStatus() != 200) {
					System.out.println("Failed : HTTP error code : " + response_ws.getStatus());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return output;
	}

}
