package com.mit.ticket_mgt_app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
// // import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
// // import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
// import org.springframework.security.oauth2.core.user.OAuth2User;
// import org.springframework.security.web.SecurityFilterChain;
// import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

// import com.mit.ticket_mgt_app.services.CustomOAuth2UserService;

@Configuration
// @EnableWebSecurity
public class SecurityConfig {
    
    // @Bean
    // public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    //     http
    //         .csrf(csrf -> csrf.disable()) // Disable CSRF for API endpoints
    //         .authorizeHttpRequests(auth -> auth
    //             // Authenticated routes (require login)
    //             .requestMatchers(
    //                 "/dashboard",
    //                 "/accounts",
    //                  "/new_appointment",
    //                   "/all_appointments"
    //             ).authenticated()
                
    //             // All other routes are public by default
    //             .anyRequest().permitAll()
    //         )
    //         .formLogin(form -> form
    //             .loginPage("/login")
    //             .loginProcessingUrl("/v1/auth_service/user_login") 
    //             .defaultSuccessUrl("/dashboard", true)
    //             .failureUrl("/login?error=true")
    //             .permitAll()
    //         )
    //         .oauth2Login(oauth -> oauth
    //             .loginPage("/login")
    //             .defaultSuccessUrl("/dashboard", true)
    //             .userInfoEndpoint(userInfo -> userInfo
    //                 .userService(oAuth2UserService())
    //             )
    //             .failureUrl("/login?error=oauth")
    //         )
    //         .logout(logout -> logout
    //             .logoutSuccessUrl("/login?logout=true")
    //             .invalidateHttpSession(true)
    //             .deleteCookies("JSESSIONID")
    //         )
    //         .sessionManagement(session -> session
    //             .invalidSessionUrl("/login?session=invalid")
    //             .maximumSessions(1)
    //             .expiredUrl("/login?session=expired")
    //         )
    //         .exceptionHandling(exceptions -> exceptions
    //             .accessDeniedPage("/login?error=access_denied")
    //             .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/login?error=unauthorized"))
    //         );
        
    //     return http.build();
    // }

    // @Bean
    // public OAuth2UserService<OAuth2UserRequest, OAuth2User> oAuth2UserService() {
    //     return new CustomOAuth2UserService();
    // }
}