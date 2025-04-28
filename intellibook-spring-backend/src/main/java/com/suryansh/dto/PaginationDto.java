package com.suryansh.dto;

import java.util.List;

public record PaginationDto(int pageNo, int pageSize,
                            List<?>res, int totalPages,
                            long totalRecords, String sortBy,
                            String sortOrder) {
}
