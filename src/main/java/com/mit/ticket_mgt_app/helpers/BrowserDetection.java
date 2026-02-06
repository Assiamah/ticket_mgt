package com.mit.ticket_mgt_app.helpers;

import org.springframework.stereotype.Service;

@Service
public class BrowserDetection {
    
     public String getDetectBrowser(String userAgent) {
        if (userAgent.contains("chrome")) return "Chrome";
        if (userAgent.contains("firefox")) return "Firefox";
        if (userAgent.contains("safari") && !userAgent.contains("chrome")) return "Safari";
        if (userAgent.contains("msie") || userAgent.contains("trident")) return "Internet Explorer";
        if (userAgent.contains("edge")) return "Edge";
        return "Unknown";
    }
}
