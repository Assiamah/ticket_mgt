package com.mit.ticket_mgt_app.services;

import java.util.Map;
import java.util.logging.Logger;

import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Service;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

@Service
public class TicketService {

    private static final Logger logger = Logger.getLogger(TicketService.class.getName());

    public String getAllTickets(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "v1/ticket_service/get_all_tickets");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error loading tickets: " + e.getMessage());
            throw new RuntimeException("Error loading tickets: " + e.getMessage(), e);
        }

        return output;
    }

    public String getAllTickets(String web_service_url, String web_service_api_key, Integer userId) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "v1/ticket_service/get_all_tickets");
            if (userId != null) {
                webResource = webResource.queryParam("user_id", userId.toString());
            }

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error loading tickets: " + e.getMessage());
            throw new RuntimeException("Error loading tickets: " + e.getMessage(), e);
        }

        return output;
    }

    public String getTicketById(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";

            WebResource webResource = client.resource(base + "v1/ticket_service/get_ticket_by_id");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).post(ClientResponse.class, json_request);

            int status = response_ws.getStatus();
            String body = null;
            try {
                body = response_ws.getEntity(String.class);
            } catch (Exception ignore) {
            }
            if (status != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + status);
            }

            boolean needsFallback = false;
            if (body != null && !body.trim().isEmpty()) {
                try {
                    org.codehaus.jettison.json.JSONObject j = new org.codehaus.jettison.json.JSONObject(body);
                    boolean hasIdLike = j.has("ticket_id") || j.has("task_id") || j.has("task_uid") || j.has("id")
                            || j.has("title") || j.has("ticket_number");
                    boolean explicitError = (j.has("success") && !j.optBoolean("success", true))
                            || (j.has("status") && "error".equalsIgnoreCase(j.optString("status")))
                            || (j.has("message") && j.optString("message", "").toLowerCase()
                                    .contains("either task_id or task_uid is required"));
                    needsFallback = explicitError || !hasIdLike;
                } catch (Exception ignore) {
                    needsFallback = true; // non-JSON or unexpected shape
                }
                if (!needsFallback) {
                    return body;
                }
            }

            // Fallbacks: try alternate payload keys and transport formats
            String idValue = null;
            String uidValue = null;
            try {
                org.codehaus.jettison.json.JSONObject o = new org.codehaus.jettison.json.JSONObject(json_request);
                if (o.has("task_id"))
                    idValue = o.optString("task_id", null);
                if (o.has("task_uid"))
                    uidValue = o.optString("task_uid", null);
                if ((idValue == null || idValue.isEmpty()) && o.has("ticket_id"))
                    idValue = o.optString("ticket_id", null);
                if ((idValue == null || idValue.isEmpty()) && o.has("id"))
                    idValue = o.optString("id", null);
            } catch (Exception ignore) {
            }
            if (idValue == null || idValue.isEmpty()) {
                // attempt to parse from form-encoded content
                try {
                    String s = json_request == null ? "" : json_request;
                    if (s.contains("task_id=")) {
                        String[] p = s.split("task_id=");
                        if (p.length > 1)
                            idValue = java.net.URLDecoder.decode(p[1],
                                    java.nio.charset.StandardCharsets.UTF_8.toString());
                    } else if (s.contains("ticket_id=")) {
                        String[] p = s.split("ticket_id=");
                        if (p.length > 1)
                            idValue = java.net.URLDecoder.decode(p[1],
                                    java.nio.charset.StandardCharsets.UTF_8.toString());
                    } else if (s.contains("id=")) {
                        String[] p = s.split("id=");
                        if (p.length > 1)
                            idValue = java.net.URLDecoder.decode(p[1],
                                    java.nio.charset.StandardCharsets.UTF_8.toString());
                    }
                    if (s.contains("task_uid=")) {
                        String[] p2 = s.split("task_uid=");
                        if (p2.length > 1)
                            uidValue = java.net.URLDecoder.decode(p2[1],
                                    java.nio.charset.StandardCharsets.UTF_8.toString());
                    }
                } catch (Exception ignore) {
                }
            }

            if ((idValue != null && !idValue.isEmpty()) || (uidValue != null && !uidValue.isEmpty())) {
                String[] candidatesBody = new String[] {
                        (idValue != null
                                ? new org.codehaus.jettison.json.JSONObject().put("task_id", idValue).toString()
                                : null),
                        (uidValue != null
                                ? new org.codehaus.jettison.json.JSONObject().put("task_uid", uidValue).toString()
                                : null),
                        (idValue != null ? new org.codehaus.jettison.json.JSONObject().put("id", idValue).toString()
                                : null),
                        (idValue != null ? "task_id=" + java.net.URLEncoder.encode(idValue,
                                java.nio.charset.StandardCharsets.UTF_8.toString()) : null),
                        (uidValue != null ? "task_uid=" + java.net.URLEncoder.encode(uidValue,
                                java.nio.charset.StandardCharsets.UTF_8.toString()) : null),
                        (idValue != null ? "id=" + java.net.URLEncoder.encode(idValue,
                                java.nio.charset.StandardCharsets.UTF_8.toString()) : null)
                };

                for (int i = 0; i < candidatesBody.length; i++) {
                    try {
                        String sendBody = candidatesBody[i];
                        if (sendBody == null)
                            continue;
                        boolean isJson = sendBody.startsWith("{");
                        ClientResponse r = webResource
                                .type(isJson ? "application/json" : "application/x-www-form-urlencoded")
                                .header("x-api-key", web_service_api_key)
                                .post(ClientResponse.class, sendBody);
                        if (r.getStatus() == 200) {
                            String out = r.getEntity(String.class);
                            if (out != null && !out.trim().isEmpty())
                                return out;
                        }
                    } catch (Exception ignore) {
                    }
                }

                // Try GET path and query param
                try {
                    String pathId = (uidValue != null && !uidValue.isEmpty()) ? uidValue : idValue;
                    WebResource wr2 = client.resource(base + "v1/ticket_service/get_ticket_by_id/" + pathId);
                    ClientResponse r2 = wr2.type("application/json").header("x-api-key", web_service_api_key)
                            .get(ClientResponse.class);
                    if (r2.getStatus() == 200) {
                        String out = r2.getEntity(String.class);
                        if (out != null && !out.trim().isEmpty())
                            return out;
                    }
                } catch (Exception ignore) {
                }
                try {
                    WebResource wr3 = client.resource(base + "v1/ticket_service/get_ticket_by_id");
                    if (idValue != null)
                        wr3 = wr3.queryParam("task_id", idValue);
                    if (uidValue != null)
                        wr3 = wr3.queryParam("task_uid", uidValue);
                    ClientResponse r3 = wr3.type("application/json").header("x-api-key", web_service_api_key)
                            .get(ClientResponse.class);
                    if (r3.getStatus() == 200) {
                        String out = r3.getEntity(String.class);
                        if (out != null && !out.trim().isEmpty())
                            return out;
                    }
                } catch (Exception ignore) {
                }
            }

            // return empty body to caller for consistency
            return body == null ? "" : body;
        } catch (Exception e) {
            logger.severe("Error getting ticket by ID: " + e.getMessage());
            throw new RuntimeException("Error getting ticket by ID: " + e.getMessage(), e);
        }
    }

    public String getUsersForAssignment(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "v1/ticket_service/get_users_for_assignment");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            int status = response_ws.getStatus();
            String body = null;
            try {
                body = response_ws.getEntity(String.class);
            } catch (Exception ignore) {
            }
            if (status != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + status);
            }
            return body == null ? "" : body;
        } catch (Exception e) {
            logger.severe("Error getting users for assignment: " + e.getMessage());
            throw new RuntimeException("Error getting users for assignment: " + e.getMessage(), e);
        }
    }

    public String createTicket(String web_service_url, String web_service_api_key, String ticketData) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/select_insert_task_record");

            // JSONObject requestJson = new JSONObject(ticketData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, ticketData);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error creating ticket: " + e.getMessage());
            throw new RuntimeException("Error creating ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String updateTicket(String web_service_url, String web_service_api_key, String ticketData) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/update_task_by_id");

            // JSONObject requestJson = new JSONObject(ticketData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, ticketData);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error updating ticket: " + e.getMessage());
            throw new RuntimeException("Error updating ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String editTicket(String web_service_url, String web_service_api_key, String ticketData) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/update_task_by_id");

            // JSONObject requestJson = new JSONObject(ticketData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, ticketData);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error editing ticket: " + e.getMessage());
            throw new RuntimeException("Error editing ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String viewTicket(String web_service_url, String web_service_api_key, String ticketData) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/select_update_task_by_id");

            // JSONObject requestJson = new JSONObject(ticketData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, ticketData);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error viewing ticket: " + e.getMessage());
            throw new RuntimeException("Error viewing ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String assignTicket(String web_service_url, String web_service_api_key, String ticketData) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/select_assign_task");

            // JSONObject requestJson = new JSONObject(ticketData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, ticketData);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error assigning ticket: " + e.getMessage());
            throw new RuntimeException("Error assigning ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String archiveTicket(String web_service_url, String web_service_api_key, String ticketData) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/select_archive_task_record");

            // Some downstream archive endpoints expect form-encoded parameters
            // (task_id=...)
            // Detect if the provided ticketData is JSON with a single task_id field and
            // convert it
            String sendBody = ticketData;
            String contentType = "application/json";
            String parsedTaskId = null;
            try {
                if (ticketData != null && ticketData.trim().startsWith("{")) {
                    org.codehaus.jettison.json.JSONObject maybe = new org.codehaus.jettison.json.JSONObject(ticketData);
                    if (maybe.has("task_id")) {
                        parsedTaskId = maybe.optString("task_id", null);
                    }
                    if (parsedTaskId != null && maybe.length() == 1) {
                        // convert to form-encoded
                        sendBody = "task_id=" + java.net.URLEncoder.encode(parsedTaskId,
                                java.nio.charset.StandardCharsets.UTF_8.toString());
                        contentType = "application/x-www-form-urlencoded";
                    }
                }
            } catch (Exception parseEx) {
                // ignore and send raw ticketData as JSON
                logger.fine("archiveTicket: unable to parse ticketData as JSON, sending raw: " + parseEx.getMessage());
            }

            ClientResponse response_ws = webResource.type(contentType)
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, sendBody);

            int status = response_ws.getStatus();
            String initialBody = null;
            try {
                initialBody = response_ws.getEntity(String.class);
            } catch (Exception ignore) {
            }

            // Collect diagnostics for initial call and fallbacks
            StringBuilder diag = new StringBuilder();
            diag.append("initial->status:").append(status).append("|body:")
                    .append(initialBody == null ? "<null>" : initialBody).append("\n");

            if (status != 200) {
                String errBody = initialBody;
                throw new RuntimeException("Failed : HTTP error code : " + status +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : "") + " | diag: "
                        + diag.toString());
            }

            output = initialBody;
            // Log status and body to help debug empty responses from the downstream service
            logger.info("archiveTicket -> status: " + status + ", body: " + (output == null ? "<null>" : output));

            // If downstream returned 200 but body is empty, attempt a few fallback formats
            if ((output == null || output.trim().isEmpty())) {
                logger.info("archiveTicket: empty response, attempting fallback formats");
                String taskId = parsedTaskId;
                // try to extract task id from form-encoded sendBody if not parsed
                if ((taskId == null || taskId.isEmpty()) && sendBody != null && sendBody.contains("task_id=")) {
                    try {
                        String[] parts = sendBody.split("task_id=");
                        if (parts.length > 1)
                            taskId = java.net.URLDecoder.decode(parts[1],
                                    java.nio.charset.StandardCharsets.UTF_8.toString());
                    } catch (Exception ignore) {
                    }
                }

                if (taskId != null && !taskId.isEmpty()) {
                    String[] candidates = new String[] {
                            "task_id=" + java.net.URLEncoder.encode(taskId,
                                    java.nio.charset.StandardCharsets.UTF_8.toString()),
                            "id=" + java.net.URLEncoder.encode(taskId,
                                    java.nio.charset.StandardCharsets.UTF_8.toString()),
                            "ticket_id=" + java.net.URLEncoder.encode(taskId,
                                    java.nio.charset.StandardCharsets.UTF_8.toString()),
                            "{\"task_id\":\"" + taskId + "\"}"
                    };
                    String[] contentTypes = new String[] {
                            "application/x-www-form-urlencoded",
                            "application/x-www-form-urlencoded",
                            "application/x-www-form-urlencoded",
                            "application/json"
                    };

                    for (int i = 0; i < candidates.length; i++) {
                        try {
                            ClientResponse tryResp = webResource.type(contentTypes[i])
                                    .header("x-api-key", web_service_api_key)
                                    .post(ClientResponse.class, candidates[i]);
                            int tryStatus = tryResp.getStatus();
                            String tryBody = null;
                            try {
                                tryBody = tryResp.getEntity(String.class);
                            } catch (Exception ignore) {
                            }
                            String line = "fallback[" + i + "]->status:" + tryStatus + "|body:"
                                    + (tryBody == null ? "<null>" : tryBody) + "\n";
                            logger.info("archiveTicket " + line);
                            diag.append(line);
                            if (tryStatus == 200 && tryBody != null && !tryBody.trim().isEmpty()) {
                                output = tryBody;
                                break;
                            }
                        } catch (Exception fbEx) {
                            String m = "fallback[" + i + "] exception: " + fbEx.getMessage();
                            logger.fine("archiveTicket fallback[" + i + "] failed: " + fbEx.getMessage());
                            diag.append(m).append("\n");
                        }
                    }
                }

                // If still empty, include diagnostics in an exception so controller can respond
                // with details
                if (output == null || output.trim().isEmpty()) {
                    throw new RuntimeException(
                            "Downstream archive returned empty response; details:\n" + diag.toString());
                }
            }
        } catch (Exception e) {
            logger.severe("Error archiving ticket: " + e.getMessage());
            throw new RuntimeException("Error archiving ticket: " + e.getMessage(), e);
        }

        return output;
    }

    // public String updateTicket(String web_service_url, String
    // web_service_api_key, String ticketData) {
    // String output = null;
    // try {
    // Client client = Client.create();
    // String base = web_service_url == null ? "" : web_service_url;
    // if (!base.endsWith("/")) base += "/";
    // WebResource webResource = client.resource(base +
    // "api/tickets_mgt_services/update_task_by_id");

    // // JSONObject requestJson = new JSONObject(ticketData);

    // ClientResponse response_ws = webResource.type("application/json")
    // .header("x-api-key", web_service_api_key)
    // .post(ClientResponse.class, ticketData);

    // if (response_ws.getStatus() != 200) {
    // String errBody = null;
    // try { errBody = response_ws.getEntity(String.class); } catch (Exception
    // ignore) {}
    // throw new RuntimeException("Failed : HTTP error code : " +
    // response_ws.getStatus() +
    // (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
    // }
    // output = response_ws.getEntity(String.class);
    // } catch (Exception e) {
    // logger.severe("Error updating ticket: " + e.getMessage());
    // throw new RuntimeException("Error updating ticket: " + e.getMessage(), e);
    // }

    // return output;
    // }

    // public String updateTicket(String web_service_url, String
    // web_service_api_key, Map<String, Object> ticketData) {
    // String output = null;
    // try {
    // Client client = Client.create();
    // WebResource webResource = client.resource(web_service_url +
    // "v1/tickets_mgt_services/update_task_by_id");

    // JSONObject requestJson = new JSONObject(ticketData);

    // ClientResponse response_ws = webResource.type("application/json")
    // .header("x-api-key", web_service_api_key)
    // .put(ClientResponse.class, requestJson.toString());

    // if (response_ws.getStatus() != 200) {
    // throw new RuntimeException("Failed : HTTP error code : " +
    // response_ws.getStatus());
    // }
    // output = response_ws.getEntity(String.class);
    // } catch (Exception e) {
    // logger.severe("Error updating ticket: " + e.getMessage());
    // throw new RuntimeException("Error updating ticket: " + e.getMessage(), e);
    // }

    // return output;
    // }

    public String getTicketComments(String web_service_url, String web_service_api_key, String ticketId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/ticket_service/get_ticket_comments/" + ticketId);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting ticket comments: " + e.getMessage());
            throw new RuntimeException("Error getting ticket comments: " + e.getMessage(), e);
        }

        return output;
    }

    public String addTicketComment(String web_service_url, String web_service_api_key,
            Map<String, Object> commentData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/add_ticket_comment");

            JSONObject requestJson = new JSONObject(commentData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());

            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error adding ticket comment: " + e.getMessage());
            throw new RuntimeException("Error adding ticket comment: " + e.getMessage(), e);
        }

        return output;
    }

    public String getTicketHistory(String web_service_url, String web_service_api_key, String ticketId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/ticket_service/get_ticket_history/" + ticketId);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting ticket history: " + e.getMessage());
            throw new RuntimeException("Error getting ticket history: " + e.getMessage(), e);
        }

        return output;
    }

    public String getPriorities(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/get_priorities");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting priorities: " + e.getMessage());
            throw new RuntimeException("Error getting priorities: " + e.getMessage(), e);
        }

        return output;
    }

    public String getStatuses(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "v1/ticket_service/get_statuses");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                logger.severe("getStatuses failed: " + response_ws.getStatus() + " | Body: " + errBody);
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null ? " | Body: " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting statuses: " + e.getMessage());
            throw new RuntimeException("Error getting statuses: " + e.getMessage(), e);
        }

        return output;
    }

    public String getStatusesMgt(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            String fullUrl = base + "tickets_mgt_services/get_statuses";
            logger.info("getStatusesMgt calling: " + fullUrl);

            WebResource webResource = client.resource(fullUrl);
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, "{}");

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                logger.severe("getStatusesMgt failed: " + response_ws.getStatus() + " | Body: " + errBody);
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null ? " | Body: " + errBody : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting statuses: " + e.getMessage());
            throw new RuntimeException("Error getting statuses: " + e.getMessage(), e);
        }
        return output;
    }

    public String addStatus(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/add_status");
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error adding status: " + e.getMessage());
            throw new RuntimeException("Error adding status: " + e.getMessage(), e);
        }
        return output;
    }

    public String updateStatus(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/update_status");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error updating status: " + e.getMessage());
            throw new RuntimeException("Error updating status: " + e.getMessage(), e);
        }
        return output;
    }

    public String deleteStatus(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/delete_status");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error deleting status: " + e.getMessage());
            throw new RuntimeException("Error deleting status: " + e.getMessage(), e);
        }
        return output;
    }

    public String getStatusById(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/get_status_by_id");
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting status by id: " + e.getMessage());
            throw new RuntimeException("Error getting status by id: " + e.getMessage(), e);
        }
        return output;
    }

    public String getDepartments(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/get_departments");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting departments: " + e.getMessage());
            throw new RuntimeException("Error getting departments: " + e.getMessage(), e);
        }

        return output;
    }

    public String getCreateTicketContext(String web_service_url, String web_service_api_key, Integer userId,
            String orgId) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "v1/ticket_service/get_create_ticket_context")
                    .queryParam("user_id", userId == null ? "" : userId.toString());
            if (orgId != null && !orgId.isEmpty()) {
                webResource = webResource.queryParam("org_id", orgId);
            }
            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting create ticket context: " + e.getMessage());
            throw new RuntimeException("Error getting create ticket context: " + e.getMessage(), e);
        }

        return output;
    }

    public String getCategories(String web_service_url, String web_service_api_key, String departmentId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/get_categories");

            if (departmentId != null && !departmentId.isEmpty()) {
                webResource = webResource.queryParam("department_id", departmentId);
            }

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting categories: " + e.getMessage());
            throw new RuntimeException("Error getting categories: " + e.getMessage(), e);
        }

        return output;
    }

    public String getCategoriesMgt(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/get_categories");
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, "{}");
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting categories: " + e.getMessage());
            throw new RuntimeException("Error getting categories: " + e.getMessage(), e);
        }
        return output;
    }

    public String addCategory(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/add_category");
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error adding category: " + e.getMessage());
            throw new RuntimeException("Error adding category: " + e.getMessage(), e);
        }
        return output;
    }

    public String deleteCategory(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/delete_category");
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error deleting category: " + e.getMessage());
            throw new RuntimeException("Error deleting category: " + e.getMessage(), e);
        }
        return output;
    }

    public String getPrioritiesMgt(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/get_priorities");
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, "{}");
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting priorities: " + e.getMessage());
            throw new RuntimeException("Error getting priorities: " + e.getMessage(), e);
        }
        return output;
    }

    public String addPriority(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/add_priority");
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error adding priority: " + e.getMessage());
            throw new RuntimeException("Error adding priority: " + e.getMessage(), e);
        }
        return output;
    }

    public String deletePriority(String web_service_url, String web_service_api_key, String json_request) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/delete_priority");
            ClientResponse response_ws = webResource.type("application/json").header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, json_request);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error deleting priority: " + e.getMessage());
            throw new RuntimeException("Error deleting priority: " + e.getMessage(), e);
        }
        return output;
    }

    public String getUserTickets(String web_service_url, String web_service_api_key, Integer userId, Integer page,
            Integer size) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/get_user_tickets")
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
            logger.severe("Error getting user tickets: " + e.getMessage());
            throw new RuntimeException("Error getting user tickets: " + e.getMessage(), e);
        }

        return output;
    }

    public String getTicketsAssignedToUser(String web_service_url, String web_service_api_key, Integer userId,
            Integer page, Integer size) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/ticket_service/get_tickets_assigned_to_user")
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
            logger.severe("Error getting tickets assigned to user: " + e.getMessage());
            throw new RuntimeException("Error getting tickets assigned to user: " + e.getMessage(), e);
        }

        return output;
    }

    public String closeTicket(String web_service_url, String web_service_api_key, Map<String, Object> closeData) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/close_ticket");

            JSONObject requestJson = new JSONObject(closeData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());

            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error closing ticket: " + e.getMessage());
            throw new RuntimeException("Error closing ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String reopenTicket(String web_service_url, String web_service_api_key, String ticketId, Integer userId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "v1/ticket_service/reopen_ticket/" + ticketId)
                    .queryParam("user_id", userId.toString());

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class);

            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error reopening ticket: " + e.getMessage());
            throw new RuntimeException("Error reopening ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String getTicketStats(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/get_ticket_stats");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting ticket stats: " + e.getMessage());
            throw new RuntimeException("Error getting ticket stats: " + e.getMessage(), e);
        }

        return output;
    }

    public String getTicketStats(String web_service_url, String web_service_api_key, Integer userId) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client.resource(web_service_url + "v1/ticket_service/get_ticket_stats");
            if (userId != null) {
                webResource = webResource.queryParam("user_id", userId.toString());
            }

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting ticket stats: " + e.getMessage());
            throw new RuntimeException("Error getting ticket stats: " + e.getMessage(), e);
        }

        return output;
    }

    public String select_insert_task_record(String web_service_url, String web_service_api_key) {
        String output = null;
        try {
            Client client = Client.create();
            WebResource webResource = client
                    .resource(web_service_url + "tickets_mgt_services/select_insert_task_record");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key).get(ClientResponse.class);
            if (response_ws.getStatus() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus());
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting ticket stats: " + e.getMessage());
            throw new RuntimeException("Error getting ticket stats: " + e.getMessage(), e);
        }

        return output;
    }

    public String select_get_active_all_task(String web_service_url, String web_service_api_key, String ticketData) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/select_get_active_all_task");

            // JSONObject requestJson = new JSONObject(ticketData);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, ticketData);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error creating ticket: " + e.getMessage());
            throw new RuntimeException("Error creating ticket: " + e.getMessage(), e);
        }

        return output;
    }

    public String getSystemDashboardData(String web_service_url, String web_service_api_key, String startDate,
            String endDate) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/get_system_dashboard_data");

            JSONObject requestJson = new JSONObject();
            if (startDate != null && !startDate.isEmpty()) {
                requestJson.put("start_date", startDate);
                requestJson.put("from_date", startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                requestJson.put("end_date", endDate);
                requestJson.put("to_date", endDate);
            }

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting system dashboard data: " + e.getMessage());
            throw new RuntimeException("Error getting system dashboard data: " + e.getMessage(), e);
        }
        return output;
    }

    public String getTicketsListForDashboard(String web_service_url, String web_service_api_key, String startDate,
            String endDate, Integer limit) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/get_tickets_list_for_dashboard");

            JSONObject requestJson = new JSONObject();
            if (startDate != null && !startDate.isEmpty()) {
                requestJson.put("start_date", startDate);
                requestJson.put("from_date", startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                requestJson.put("end_date", endDate);
                requestJson.put("to_date", endDate);
            }
            if (limit != null)
                requestJson.put("limit", limit);

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting tickets list for dashboard: " + e.getMessage());
            throw new RuntimeException("Error getting tickets list for dashboard: " + e.getMessage(), e);
        }
        return output;
    }

    // public String update_task_by_id(String web_service_url, String
    // web_service_api_key, Map<String, Object> ticketData) {
    // String output = null;
    // try {
    // Client client = Client.create();
    // WebResource webResource = client.resource(web_service_url +
    // "api/tickets_mgt_services/update_task_by_id");

    // JSONObject requestJson = new JSONObject(ticketData);

    // ClientResponse response_ws = webResource.type("application/json")
    // .header("x-api-key", web_service_api_key)
    // .put(ClientResponse.class, requestJson.toString());

    // if (response_ws.getStatus() != 200) {
    // throw new RuntimeException("Failed : HTTP error code : " +
    // response_ws.getStatus());
    // }
    // output = response_ws.getEntity(String.class);
    // } catch (Exception e) {
    // logger.severe("Error updating ticket: " + e.getMessage());
    // throw new RuntimeException("Error updating ticket: " + e.getMessage(), e);
    // }

    // return output;
    // }

    // public String updateTicket(String web_service_url, String
    // web_service_api_key, Map<String, Object> ticketData) {
    // String output = null;
    // try {
    // Client client = Client.create();
    // WebResource webResource = client.resource(web_service_url +
    // "api/tickets_mgt_services/update_task_by_id");

    // JSONObject requestJson = new JSONObject(ticketData);

    // ClientResponse response_ws = webResource.type("application/json")
    // .header("x-api-key", web_service_api_key)
    // .put(ClientResponse.class, requestJson.toString());

    // if (response_ws.getStatus() != 200) {
    // throw new RuntimeException("Failed : HTTP error code : " +
    // response_ws.getStatus());
    // }
    // output = response_ws.getEntity(String.class);
    // } catch (Exception e) {
    // logger.severe("Error updating ticket: " + e.getMessage());
    // throw new RuntimeException("Error updating ticket: " + e.getMessage(), e);
    // }

    // return output;
    // }

    public String getUserOrgDashboardData(String web_service_url, String web_service_api_key, String userId,
            String orgId, String startDate, String endDate) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/get_user_org_dashboard_data");

            // Also add as query param for robustness
            if (orgId != null && !orgId.isEmpty()) {
                webResource = webResource.queryParam("org_id", orgId);
                webResource = webResource.queryParam("organization_id", orgId);
            }

            JSONObject requestJson = new JSONObject();
            if (userId != null && !userId.isEmpty())
                requestJson.put("user_id", userId);
            if (orgId != null && !orgId.isEmpty()) {
                requestJson.put("org_id", orgId);
                requestJson.put("organization_id", orgId);
                requestJson.put("organizationId", orgId); // Add camelCase
            }
            if (startDate != null && !startDate.isEmpty()) {
                requestJson.put("start_date", startDate);
                requestJson.put("from_date", startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                requestJson.put("end_date", endDate);
                requestJson.put("to_date", endDate);
            }

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, requestJson.toString());

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting user org dashboard data: " + e.getMessage());
            throw new RuntimeException("Error getting user org dashboard data: " + e.getMessage(), e);
        }
        return output;
    }

    public String getOrgArchivedTasks(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/get_org_archived_tasks");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, jsonRequest);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error getting archived tasks: " + e.getMessage());
            throw new RuntimeException("Error getting archived tasks: " + e.getMessage(), e);
        }

        return output;
    }

    public String fetchArchivedTickets(String web_service_url, String web_service_api_key, String jsonRequest) {
        String output = null;
        try {
            Client client = Client.create();
            String base = web_service_url == null ? "" : web_service_url;
            if (!base.endsWith("/"))
                base += "/";
            WebResource webResource = client.resource(base + "tickets_mgt_services/fetch_archived_tickets");

            ClientResponse response_ws = webResource.type("application/json")
                    .header("x-api-key", web_service_api_key)
                    .post(ClientResponse.class, jsonRequest);

            if (response_ws.getStatus() != 200) {
                String errBody = null;
                try {
                    errBody = response_ws.getEntity(String.class);
                } catch (Exception ignore) {
                }
                throw new RuntimeException("Failed : HTTP error code : " + response_ws.getStatus() +
                        (errBody != null && !errBody.isEmpty() ? (" | Body: " + errBody) : ""));
            }
            output = response_ws.getEntity(String.class);
        } catch (Exception e) {
            logger.severe("Error fetching archived tickets: " + e.getMessage());
            throw new RuntimeException("Error fetching archived tickets: " + e.getMessage(), e);
        }

        return output;
    }
}
