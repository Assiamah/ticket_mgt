package com.mit.ticket_mgt_app.helpers;

import java.text.NumberFormat;
import java.util.Locale;

public class AmountInWords {

    public String convert(int amount) {
        return String.valueOf(amount);
    }

    public String convert(double amount) {
        return String.valueOf(amount);
    }

    public String convert(String amount) {
        return amount;
    }

    public String convert(int amount, Locale locale) {
        NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);
        return numberFormat.format(amount);
    }

    public String convert(double amount, Locale locale) {
        NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);
        return numberFormat.format(amount);
    }

    public String convert(String amount, Locale locale) {
        NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);
        return numberFormat.format(Double.parseDouble(amount));
    }
}
