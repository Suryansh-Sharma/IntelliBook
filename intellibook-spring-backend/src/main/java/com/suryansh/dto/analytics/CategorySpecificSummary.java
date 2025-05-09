package com.suryansh.dto.analytics;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CategorySpecificSummary {
    private int categoryId;
    private String categoryName;
    private BigDecimal totalSpent;
    private Long transactionCount;
    private Instant firstTransactionDate;
    private Instant lastTransactionDate;
    private BigDecimal highestTransaction;
    private BigDecimal lowestTransaction;
    private Double averageTransactionAmount;
    private List<MonthlySpending> monthlySpending;

    @Data
    @AllArgsConstructor
    public static class MonthlySpending {
        private String month;
        private BigDecimal amount;
    }
}