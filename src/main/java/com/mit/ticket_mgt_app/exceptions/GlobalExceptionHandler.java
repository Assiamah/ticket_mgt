package com.mit.ticket_mgt_app.exceptions;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.http.ResponseEntity;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import java.util.HashMap;

@ControllerAdvice
public class GlobalExceptionHandler {

    // Handle 404 (page not found)
    @ExceptionHandler(NoHandlerFoundException.class)
    public Object handleNotFound(NoHandlerFoundException ex, Model model, HttpServletRequest req) {
        if (isApiRequest(req)) {
            Map<String, Object> error = new HashMap<>();
            error.put("status", "error");
            error.put("message", "Endpoint not found: " + req.getRequestURI());
            return ResponseEntity.status(404).body(error);
        }
        model.addAttribute("error", "Page not found");
        return "redirect:/login?error=notfound";
    }

    // Handle generic errors (500 etc.)
    @ExceptionHandler(Exception.class)
    public Object handleGenericError(Exception ex, Model model, HttpServletRequest req) {
        if (isApiRequest(req)) {
            Map<String, Object> error = new HashMap<>();
            error.put("status", "error");
            error.put("message", "Server error: " + ex.getMessage());
            ex.printStackTrace(); // Log the error on server side
            return ResponseEntity.status(500).body(error);
        }
        model.addAttribute("error", "Something went wrong");
        return "redirect:/login?error=server";
    }

    private boolean isApiRequest(HttpServletRequest req) {
        String uri = req.getRequestURI();
        String accept = req.getHeader("Accept");
        String requestedWith = req.getHeader("X-Requested-With");
        
        return uri.startsWith("/v1/") || 
               uri.contains("/api/") ||
               (accept != null && accept.contains("application/json")) ||
               "XMLHttpRequest".equals(requestedWith);
    }
}
