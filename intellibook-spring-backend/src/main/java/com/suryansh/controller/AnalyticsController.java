package com.suryansh.controller;

import com.suryansh.dto.analytics.CategorySummary;
import com.suryansh.dto.analytics.TagSummary;
import com.suryansh.dto.analytics.TwoVariableDataTrend;
import com.suryansh.service.interfaces.AnalyticsService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class AnalyticsController {
    private final AnalyticsService analyticsService;

    public AnalyticsController(AnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    @QueryMapping
    public List<TwoVariableDataTrend> getMonthlyTrends(@Argument long userId, @Argument("fromDate") String fromDate,
                                                       @Argument("toDate") String toDate) {
        return analyticsService.monthlyTrends(userId, fromDate, toDate);
    }

    @QueryMapping
    public List<CategorySummary> categorySummary(@Argument long userId, @Argument("fromDate") String fromDate,
                                                 @Argument("toDate") String toDate) {
        return analyticsService.generateCategorySummary(userId,fromDate,toDate);
    }

    @QueryMapping
    public TagSummary tagMonthlySummary(@Argument long userId, @Argument String tagName,@Argument String fromDate,
                                        @Argument String toDate) {
        return analyticsService.generateTagMonthlySummary(userId,tagName,fromDate,toDate);
    }


}
