package com.suryansh.dto;

import java.time.LocalDateTime;
import java.util.List;

public record CategoryDto(
        Long id,
        String name,
        LocalDateTime createdOn,
        List<Tags> tags
) {
    public record Tags(
            Long id,
            String name,
            String description
    ){}
}


