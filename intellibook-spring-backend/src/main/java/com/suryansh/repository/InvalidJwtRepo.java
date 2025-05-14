package com.suryansh.repository;

import com.suryansh.entity.InvalidJwtEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;

public interface InvalidJwtRepo extends JpaRepository<InvalidJwtEntity, String> {
    void deleteByExpiresAtBefore(Instant nowInIndia);
}
