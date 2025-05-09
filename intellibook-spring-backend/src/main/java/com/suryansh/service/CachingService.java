package com.suryansh.service;

import com.suryansh.entity.UserEntity;
import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.repository.UserRepository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
public class CachingService {
    private final UserRepository userRepository;

    public CachingService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Cacheable(value = "user_entity", key = "#userId")
    public UserEntity fetchUser(long userId) {
        return userRepository.getUserInfoById(userId)
                .orElseThrow(() ->
                        new SpringIntelliBookEx("Unable to find user of id " + userId, "USER_NOT_FOUND",
                                HttpStatus.BAD_REQUEST)
                );
    }
}
