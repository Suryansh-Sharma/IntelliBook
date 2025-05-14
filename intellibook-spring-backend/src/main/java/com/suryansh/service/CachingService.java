package com.suryansh.service;

import com.suryansh.entity.InvalidJwtEntity;
import com.suryansh.entity.UserEntity;
import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.repository.InvalidJwtRepo;
import com.suryansh.repository.UserRepository;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class CachingService {
    private final UserRepository userRepository;
    private final InvalidJwtRepo invalidJwtRepo;
    public CachingService(UserRepository userRepository, InvalidJwtRepo invalidJwtRepo) {
        this.userRepository = userRepository;
        this.invalidJwtRepo = invalidJwtRepo;
    }

    @Cacheable(value = "user_entity", key = "#userId")
    public UserEntity fetchUser(long userId) {
        return userRepository.getUserInfoById(userId)
                .orElseThrow(() ->
                        new SpringIntelliBookEx("Unable to find user of id " + userId, "USER_NOT_FOUND",
                                HttpStatus.BAD_REQUEST)
                );
    }

    @CachePut(value = "blackListedToken",key = "#jwt")
    public boolean addInvalidJwt(String token,InvalidJwtEntity jwt) {
        try{
            invalidJwtRepo.save(jwt);
            return true;
        }catch (Exception e) {
            throw new SpringIntelliBookEx("Unable to add invalid jwt " + jwt, "INVALID_JWT", HttpStatus.BAD_REQUEST);
        }
    }

    @Cacheable(value = "blackListedToken",key = "#token")
    public boolean isTokenInValid(String token) {
        Optional<InvalidJwtEntity> res= invalidJwtRepo.findById(token);
        return res.isPresent();
    }
}
