package com.mit.ticket_mgt_app.services;

import java.util.Map;
import java.util.logging.Logger;

import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Service;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class AppointmentService {

    private static final Logger logger = Logger.getLogger(AppointmentService.class.getName());

    public String loadSlots(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/load_slots");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error loading slots: " + e.getMessage());
            throw new RuntimeException("Error loading slots: " + e.getMessage(), e);
        }

        return output;
    }

    public String getSlotsSummary(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_slots_summary");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting slots summary: " + e.getMessage());
            throw new RuntimeException("Error getting slots summary: " + e.getMessage(), e);
        }

        return output;
    }

    public String createSlot(String web_service_url, String web_service_api_key, Map<String, Object> slotData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/create_slot");
            
            JSONObject requestJson = new JSONObject(slotData);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error creating slot: " + e.getMessage());
            throw new RuntimeException("Error creating slot: " + e.getMessage(), e);
        }

        return output;
    }

    public String createBatchSlots(String web_service_url, String web_service_api_key, Map<String, Object> batchData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/create_batch_slots");
            
            JSONObject requestJson = new JSONObject(batchData);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error creating batch slots: " + e.getMessage());
            throw new RuntimeException("Error creating batch slots: " + e.getMessage(), e);
        }

        return output;
    }

    public String toggleSlotAvailability(String web_service_url, String web_service_api_key, Integer slotId, Integer userId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/toggle_slot_availability/" + slotId)
                    .queryParam("userId", userId.toString());
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class);
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error toggling slot availability: " + e.getMessage());
            throw new RuntimeException("Error toggling slot availability: " + e.getMessage(), e);
        }

        return output;
    }

    public String deleteSlot(String web_service_url, String web_service_api_key, Integer slotId, Integer userId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/delete_slot/" + slotId)
                    .queryParam("userId", userId.toString());
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .delete(ClientResponse.class);
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error deleting slot: " + e.getMessage());
            throw new RuntimeException("Error deleting slot: " + e.getMessage(), e);
        }

        return output;
    }

    public String getAppointmentTypes(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_appointment_types");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting appointment types: " + e.getMessage());
            throw new RuntimeException("Error getting appointment types: " + e.getMessage(), e);
        }

        return output;
    }

    public String bookAppointment(String web_service_url, String web_service_api_key, Map<String, Object> bookingData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/book_appointment");
            
            JSONObject requestJson = new JSONObject(bookingData);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error booking appointment: " + e.getMessage());
            throw new RuntimeException("Error booking appointment: " + e.getMessage(), e);
        }

        return output;
    }

    public String cancelAppointment(String web_service_url, String web_service_api_key, Integer appointmentId, Map<String, Object> cancelData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/cancel_appointment/" + appointmentId);
            
            JSONObject requestJson = new JSONObject(cancelData);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error canceling appointment: " + e.getMessage());
            throw new RuntimeException("Error canceling appointment: " + e.getMessage(), e);
        }

        return output;
    }

    public String getUserAppointments(String web_service_url, String web_service_api_key, Integer userId, Integer page, Integer size) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_user_appointments")
                    .queryParam("user_id", userId.toString())
                    .queryParam("page", page.toString())
                    .queryParam("size", size.toString());
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting user appointments: " + e.getMessage());
            throw new RuntimeException("Error getting user appointments: " + e.getMessage(), e);
        }

        return output;
    }

    public String getAvailableSlots(String web_service_url, String web_service_api_key, String date, Integer appointmentTypeId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_available_slots")
                    .queryParam("date", date)
                    .queryParam("appointment_type_id", appointmentTypeId != null ? appointmentTypeId.toString() : "");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting available slots: " + e.getMessage());
            throw new RuntimeException("Error getting available slots: " + e.getMessage(), e);
        }

        return output;
    }

    public String getSlotDetails(String web_service_url, String web_service_api_key, Integer slotId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_slot_details/" + slotId);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting slot details: " + e.getMessage());
            throw new RuntimeException("Error getting slot details: " + e.getMessage(), e);
        }

        return output;
    }

    public String updateSlot(String web_service_url, String web_service_api_key, Integer slotId, Map<String, Object> slotData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/update_slot/" + slotId);
            
            JSONObject requestJson = new JSONObject(slotData);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .put(ClientResponse.class, requestJson.toString());
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error updating slot: " + e.getMessage());
            throw new RuntimeException("Error updating slot: " + e.getMessage(), e);
        }

        return output;
    }

    public String getAppointmentDetails(String web_service_url, String web_service_api_key, Integer appointmentId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_appointment_details/" + appointmentId);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting appointment details: " + e.getMessage());
            throw new RuntimeException("Error getting appointment details: " + e.getMessage(), e);
        }

        return output;
    }

    public String rescheduleAppointment(String web_service_url, String web_service_api_key, Integer appointmentId, Map<String, Object> rescheduleData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/reschedule_appointment/" + appointmentId);
            
            JSONObject requestJson = new JSONObject(rescheduleData);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());
            
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error rescheduling appointment: " + e.getMessage());
            throw new RuntimeException("Error rescheduling appointment: " + e.getMessage(), e);
        }

        return output;
    }

    public String getProviderSlots(String web_service_url, String web_service_api_key, Integer providerId, String startDate, String endDate) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_provider_slots")
                    .queryParam("provider_id", providerId.toString())
                    .queryParam("start_date", startDate)
                    .queryParam("end_date", endDate);
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting provider slots: " + e.getMessage());
            throw new RuntimeException("Error getting provider slots: " + e.getMessage(), e);
        }

        return output;
    }


       public String loadAppointments(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_appointments");
            
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error loading appointments: " + e.getMessage());
            throw new RuntimeException("Error loading appointments: " + e.getMessage(), e);
        }

        return output;
    }


        public String appointmentById(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/appointment_service/get_appointment_by_id");
            
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


}