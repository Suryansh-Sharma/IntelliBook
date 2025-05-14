package com.suryansh.security;

import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.service.CachingService;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UserInfoService userInfoService;
    private final CachingService cachingService;

    public JwtAuthFilter(JwtService jwtService, UserInfoService userInfoService, CachingService cachingService) {
        this.jwtService = jwtService;
        this.userInfoService = userInfoService;
        this.cachingService = cachingService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String userId=null;
        String token=null;
        try {
            // Extract token from the Authorization header
            String authHeader = request.getHeader("Authorization");
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                token = authHeader.substring(7);
                userId = jwtService.extractUserId(token);
            }
            if (authHeader != null && !authHeader.startsWith("Bearer ")) {
                throw new SpringIntelliBookEx("Please provide JWT Token 'Bearer <Your Token>' ", "BAD_REQUEST",
                        HttpStatus.BAD_REQUEST);
            }

            if (userId != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                // Check token is logout or not
                if (cachingService.isTokenInValid(token)){
                    throw new ExpiredJwtException(null, null, "The token has been blacklisted or expired");
                }
                // Load user details from the user service
                UserDetails userDetails = userInfoService.loadUserByUsername(userId);

                // If the token is valid, authenticate the user
                if (jwtService.validateToken(token, userDetails.getUsername())) {

                    // Create an authentication object and set it in the SecurityContext
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());

                    // Set authentication in the SecurityContext
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
            }
        } catch (Exception e) {
            throw new SpringIntelliBookEx("JWT is Expired ", "EXPIRED_JWT",
                    HttpStatus.FORBIDDEN);
        }
        filterChain.doFilter(request, response);
    }
}
