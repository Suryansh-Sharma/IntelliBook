package com.suryansh.repository;

import com.suryansh.entity.InvalidJwtEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InvalidJwtRepo extends JpaRepository<InvalidJwtEntity, String> {
}
