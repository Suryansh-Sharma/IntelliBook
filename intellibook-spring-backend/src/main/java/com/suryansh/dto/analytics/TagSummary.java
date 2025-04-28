package com.suryansh.dto.analytics;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TagSummary {
    private String tagName;
    private BigDecimal totalAmount;
    private int transactionCount;
    private List<MonthlyTagSummary> monthlySummaries; // plural

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class MonthlyTagSummary {
        private String month;
        private BigDecimal totalAmount;
        private List<CategorySummary> categorySummaries; // plural
    }

    @Data
    public static class CategorySummary {
        private String categoryName;
        private BigDecimal totalAmount;
    }
}
