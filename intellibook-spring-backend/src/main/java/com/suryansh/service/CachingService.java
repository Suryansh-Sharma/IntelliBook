package com.suryansh.service;

import com.suryansh.entity.InvalidJwtEntity;
import com.suryansh.entity.UserEntity;
import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.repository.InvalidJwtRepo;
import com.suryansh.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Optional;

@Service
@Transactional
public class CachingService {
    private static final Logger logger = LoggerFactory.getLogger(CachingService.class);

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
    public boolean addInvalidJwt(InvalidJwtEntity jwt) {
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

    @CacheEvict(value = "blackListedToken",allEntries = true)
    @Scheduled(fixedDelay = 3600000)
    public void removeInvalidJwt() {
        Instant nowInIndia = ZonedDateTime.now(ZoneId.of("Asia/Kolkata")).toInstant();
        try{
            invalidJwtRepo.deleteByExpiresAtBefore(nowInIndia);
            logger.info("Successfully removed expired jwt from cache");
        }catch (Exception e){
            logger.error("Unable to remove expired jwt from cache {}",e.getMessage());
        }
    }
}
