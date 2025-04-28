package com.suryansh.model;

import lombok.Data;

import java.util.List;

@Data
public class SearchRecordModel {
    private String value;
    private List<FilterModel> filters;
    private String sortBy;
    private String sortOrder;

    @Data
    public static class FilterModel {
        private String key;
        private String value;
    }
}
