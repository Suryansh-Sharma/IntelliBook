package com.suryansh.service.interfaces;

import com.suryansh.dto.analytics.CategorySummary;
import com.suryansh.dto.analytics.TagSummary;
import com.suryansh.dto.analytics.TwoVariableDataTrend;

import java.util.List;

public interface AnalyticsService {
    List<TwoVariableDataTrend> monthlyTrends(long userId, String fromDate, String toDate);

    List<CategorySummary> generateCategorySummary(long userId, String fromDate, String toDate);

    TagSummary generateTagMonthlySummary(long userId, String tagName, String fromDate, String toDate);
}
