package com.suryansh.service;

import com.suryansh.dto.UserLoginResDto;
import com.suryansh.entity.RefreshTokenEntity;
import com.suryansh.entity.UserDetailEntity;
import com.suryansh.entity.UserEntity;
import com.suryansh.model.AddNewUserModel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

@Service
public class MappingService {
    @Value("${expiration_time}")
    private String EXPIRATION_TIME;
    private final PasswordEncoder passwordEncoder;

    public MappingService(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    public UserEntity mapUserModelToEntity(AddNewUserModel model) {
        ZonedDateTime zonedDateTime = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        UserDetailEntity userDetailEntity = UserDetailEntity.builder()
                .contact(model.getContact())
                .email(model.getEmail())
                .password(passwordEncoder.encode(model.getPassword()))
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

    public UserLoginResDto mapUserEntityToLoginDto(UserEntity user, UserDetailEntity userDetail,
                                                   String token, RefreshTokenEntity rt) {
        LocalDateTime localDateTime = LocalDateTime.ofInstant(user.getUserDetail().getCreatedAt(), ZoneId.of("Asia/Kolkata"));
        UserLoginResDto.JwtToken jwtToken = new UserLoginResDto.JwtToken(
                token,
                "Token will expire in "+EXPIRATION_TIME+" minutes"
        );
        UserLoginResDto.RefreshToken refreshToken = new UserLoginResDto.RefreshToken(
                rt.getToken(),
                rt.getCreatedAt(),
                rt.getExpiresAt()
        );
        UserLoginResDto.Credentials credentials= new UserLoginResDto.Credentials(
            jwtToken,
                refreshToken
        );
        return new UserLoginResDto(
                user.getId(),
                user.getFirstname(),
                user.getFirstname(),
                user.getUserDetail().getContact(),
                user.getUserDetail().getEmail(),
                user.getUserDetail().getRole(),
                localDateTime,
                user.getUserDetail().isVerified(),
                user.getUserDetail().isActive(),
                credentials
        );
    }
}
