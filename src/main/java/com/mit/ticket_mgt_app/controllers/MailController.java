package com.mit.ticket_mgt_app.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mit.ticket_mgt_app.services.EmailService;

@RestController
public class MailController {
    
    private final EmailService emailService;

    public MailController(EmailService emailService) {
        this.emailService = emailService;
    }

    @GetMapping("/send-mail")
    public String sendMail() {
        emailService.sendSimpleMessage("prosper.edem13@gmail.com", "Test Subject", "Hello, this is a test email!");
        return "Mail Sent!";
    }
}
