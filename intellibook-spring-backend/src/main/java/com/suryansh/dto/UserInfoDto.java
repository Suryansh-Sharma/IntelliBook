package com.suryansh.dto;

import com.suryansh.entity.UserDetailEntity;

import java.time.LocalDateTime;

public record UserInfoDto(
        long id,
        String firstname,
        String lastname,
        String contact,
        String email,
        UserDetailEntity.Role role,
        LocalDateTime createdAt,
        boolean isVerified,
        boolean isActive
) {
}
