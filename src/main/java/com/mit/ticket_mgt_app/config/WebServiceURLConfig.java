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

  
}
