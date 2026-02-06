// package com.mit.ticket_mgt_app.services;

// import java.util.TimeZone;

// import org.codehaus.jettison.json.JSONException;
// import org.codehaus.jettison.json.JSONObject;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
// import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
// import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
// import org.springframework.security.oauth2.core.user.OAuth2User;
// import org.springframework.stereotype.Service;
// import org.springframework.web.context.request.RequestContextHolder;
// import org.springframework.web.context.request.ServletRequestAttributes;

// import com.mit.ticket_mgt_app.config.WebServiceURLConfig;
// import com.mit.ticket_mgt_app.helpers.BrowserDetection;
// import com.mit.ticket_mgt_app.helpers.ClientIpAddress;
// import com.mit.ticket_mgt_app.helpers.LocalMacAddress;
// // import com.mit.ticket_mgt_app.utils.EncryptionUtil;

// import jakarta.servlet.http.HttpServletRequest;

// @Service
// public class CustomOAuth2UserService extends DefaultOAuth2UserService {
    
//     @Autowired
//     private WebServiceURLConfig wsURLConfig;
    
//     // @Autowired
//     // private EncryptionUtil encryptionUtil;

//     AuthService authService = new AuthService();
//     BrowserDetection browserDetection = new BrowserDetection();
//     ClientIpAddress clientIpAddress = new ClientIpAddress();
//     LocalMacAddress localMacAddress = new LocalMacAddress();

//     @Override
//     public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
//         OAuth2User oAuth2User = super.loadUser(userRequest);
        
//         // Get the current request
//         HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
//             .currentRequestAttributes()).getRequest();
        
//         // Extract user information from Google
//         String email = oAuth2User.getAttribute("email");
//         String name = oAuth2User.getAttribute("name");
        
//         // Get Client IP Address
//         String ipAddress = clientIpAddress.getClientIpAddress(request);

//         // Get Server-side Geolocation
//         String location = "Unknown";
//         String locCoordinate = request.getParameter("coordinates");
//         try {
//             request.getHeader("X-Client-Location");
//         } catch (Exception e) {
//             location = "Unknown";
//         }

//         // Timezone
//         String timezone = TimeZone.getDefault().getID();

//         // Device & Browser detection (basic from User-Agent)
//         String userAgent = request.getHeader("User-Agent").toLowerCase();
//         String deviceName = userAgent;
//         String platform = userAgent.contains("windows") ? "Windows"
//                         : userAgent.contains("mac") ? "Mac"
//                         : userAgent.contains("linux") ? "Linux"
//                         : "Unknown";
//         boolean isDesktop = userAgent.contains("windows") || userAgent.contains("mac") || userAgent.contains("linux");
//         boolean isTablet = userAgent.contains("tablet");
//         boolean isPhone = userAgent.contains("mobile");
//         boolean isRobot = userAgent.contains("bot") || userAgent.contains("crawl") || userAgent.contains("spider");
//         String browser = browserDetection.getDetectBrowser(userAgent);
//         String macAddress = localMacAddress.getLocalMacAddress();
        
//         try {
//             // Build JSON request for your API
//             JSONObject authData = new JSONObject();
//             authData.put("email", email);
//             authData.put("oauth_provider", "GOOGLE");
//             authData.put("ip_address", ipAddress);
//             authData.put("location", location);
//             authData.put("timezone", timezone);
//             authData.put("loc_coordinate", locCoordinate);
//             authData.put("device", deviceName);
//             authData.put("platform", platform);
//             authData.put("isDesktop", isDesktop);
//             authData.put("isTablet", isTablet);
//             authData.put("isPhone", isPhone);
//             authData.put("browser", browser);
//             authData.put("isRobot", isRobot);
//             authData.put("mac_address", macAddress);
//             authData.put("full_name", name);
            
//             // Call your existing authentication service
//             String jsonRequest = authData.toString();
//             String WebServiceResponse = authService.userLogin(
//                  wsURLConfig.getWeb_service_url_ser(), 
//                 wsURLConfig.getWeb_service_url_ser_api_key(), 
//                 jsonRequest
//             );
            
//             JSONObject resObj = new JSONObject(WebServiceResponse);
//             if (!resObj.getBoolean("success")) {
//                 throw new OAuth2AuthenticationException("Authentication failed");
//             }
            
//             // Store in session like your API login
//             JSONObject resData = resObj.getJSONObject("data");
//             String passKey = resData.getString("unique_id");
//           //  String encryptedPassKey = encryptionUtil.encrypt(passKey);
//             request.getSession().setAttribute("passKey", passKey);
//         } catch (JSONException e) {
//             throw new OAuth2AuthenticationException("JSON processing error: " + e.getMessage());
//         }
        
//         return oAuth2User;
//     }
// }
