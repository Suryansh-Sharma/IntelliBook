package com.suryansh.repository;

import com.suryansh.entity.RefreshTokenEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RefreshTokenRepo extends JpaRepository<RefreshTokenEntity, String> {
}
