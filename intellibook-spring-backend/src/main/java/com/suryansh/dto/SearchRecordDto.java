package com.suryansh.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

@Data
public class SearchRecordDto {
    String value;
    List<SearchResCategoryDto>categories;
    List<SearchResTransactionDto>transactions;
    List<SearchResTagDto>tags;

    private HashMap<String,String>filters;
    private String sortBy;
    private String sortOrder;

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class SearchResCategoryDto{
        private long id;
        private String name;
    }

    @Data
    public static class SearchResTransactionDto{
        private long id;
        private BigDecimal amount;
    }

    @Data
    public static class SearchResTagDto{
        private long id;
        private String name;
    }
}