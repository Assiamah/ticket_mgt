package com.mit.ticket_mgt_app.helpers;

import java.net.NetworkInterface;
import java.util.Enumeration;

import org.springframework.stereotype.Service;

@Service
public class LocalMacAddress {

    public String getLocalMacAddress() {
        try {
            // Get all network interfaces
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            
            while (interfaces.hasMoreElements()) {
                NetworkInterface network = interfaces.nextElement();
                
                // Skip loopback and inactive interfaces
                if (network.isLoopback() || !network.isUp()) {
                    continue;
                }
                
                // Get MAC address if available
                byte[] mac = network.getHardwareAddress();
                if (mac != null) {
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < mac.length; i++) {
                        sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? ":" : ""));
                    }
                    return sb.toString();
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "00-00-00-00-00-00";
    }
}