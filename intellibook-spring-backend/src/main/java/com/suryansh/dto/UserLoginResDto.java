package com.suryansh.dto;

import com.suryansh.entity.UserDetailEntity;

import java.time.Instant;
import java.time.LocalDateTime;

public record UserLoginResDto(
        long id,
        String firstname,
        String lastname,
        String contact,
        String email,
        UserDetailEntity.Role role,
        LocalDateTime createdAt,
        boolean isVerified,
        boolean isActive,
        Credentials credentials

) {
    public record Credentials(JwtToken jwtToken, RefreshToken refreshToken) {}
    public record RefreshToken(String token, Instant generatedOn, Instant expiresOn){}
    public record JwtToken(String token, String validity){}
}
