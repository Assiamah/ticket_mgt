package com.mit.ticket_mgt_app.helpers;

public class BlankDetection {

    public boolean isBlank(String str) {
        return str == null || str.trim().isEmpty();
    }
}
