package com.suryansh.dto.analytics;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@NoArgsConstructor
@Getter
@Setter
@Builder
@AllArgsConstructor
@ToString
public class CategorySummary {
    private int categoryId;
    private String categoryName;
    private BigDecimal totalAmount;
    private int transactionCount;
    private int averageCount;
    private List<TopTag> topTags;

    @AllArgsConstructor
    @NoArgsConstructor
    @Getter
    @Setter
    @ToString
    public static class TopTag {
        private String tagName;
        private BigDecimal tagAmount;
    }
}
