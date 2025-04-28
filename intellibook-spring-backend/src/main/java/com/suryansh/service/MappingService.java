package com.suryansh.service;

import com.suryansh.entity.UserDetailEntity;
import com.suryansh.entity.UserEntity;
import com.suryansh.model.AddNewUserModel;
import com.suryansh.dto.UserLoginResDto;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

@Service
public class MappingService {
    public UserEntity mapUserModelToEntity(AddNewUserModel model) {
        ZonedDateTime zonedDateTime = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        UserDetailEntity userDetailEntity = UserDetailEntity.builder()
                .contact(model.getContact())
                .email(model.getEmail())
                .password(model.getPassword())
                .role(model.getRole())
                .createdAt(zonedDateTime.toInstant())
                .isActive(false)
                .isVerified(false)
                .build();

        UserEntity userEntity = UserEntity.builder()
                .firstname(model.getFirstname())
                .lastname(model.getLastname())
                .userDetail(userDetailEntity)
                .transactions(null)
                .categories(null)
                .build();
        userDetailEntity.setUser(userEntity);
        return userEntity;

    }

    public UserLoginResDto mapUserEntityToLoginDto(UserEntity user) {
        LocalDateTime localDateTime = LocalDateTime.ofInstant(user.getUserDetail().getCreatedAt(), ZoneId.of("Asia/Kolkata"));
        return new UserLoginResDto(
                user.getId(),
                user.getFirstname(),
                user.getFirstname(),
                user.getUserDetail().getContact(),
                user.getUserDetail().getEmail(),
                user.getUserDetail().getRole(),
                localDateTime,
                user.getUserDetail().isVerified(),
                user.getUserDetail().isActive()
        );
    }
}
