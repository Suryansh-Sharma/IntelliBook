package com.suryansh.dto;

import com.suryansh.entity.TransactionEntity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record TransactionFullDto(
        Long id,
        BigDecimal amount,
        LocalDateTime timestamp,
        LocalDateTime createdOn,
        String description,
        TransactionEntity.TransactionType transactionType,
        List<TagDto> tags,
        CategoryDto category,
        UserLoginResDto userInfo
) {
    public record TagDto(long id, String name, String description) {}
}
