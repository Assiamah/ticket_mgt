package com.mit.ticket_mgt_app.config;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
@ConfigurationProperties(prefix = "app.config")
public class WebServiceURLConfig {
    String web_service_url_ser;
    String web_service_url_ser_api_key;
    String app_folder_path;

    public String getWeb_service_url_ser() {
        return web_service_url_ser;
    }

    public void setWeb_service_url_ser(String web_service_url_ser) {
        this.web_service_url_ser = web_service_url_ser;
    }

    public String getWeb_service_url_ser_api_key() {
        return web_service_url_ser_api_key;
    }

    public void setWeb_service_url_ser_api_key(String web_service_url_ser_api_key) {
        this.web_service_url_ser_api_key = web_service_url_ser_api_key;
    }

    public String getApp_folder_path() {
        return app_folder_path;
    }

    public void setApp_folder_path(String app_folder_path) {
        this.app_folder_path = app_folder_path;
    }
}
