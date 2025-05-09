package com.suryansh.controller;

import com.suryansh.dto.analytics.CategorySpecificSummary;
import com.suryansh.dto.analytics.CategorySummary;
import com.suryansh.dto.analytics.TagSummary;
import com.suryansh.dto.analytics.TwoVariableDataTrend;
import com.suryansh.security.UserPrincipal;
import com.suryansh.service.interfaces.AnalyticsService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class AnalyticsController {
    private final AnalyticsService analyticsService;

    private long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();
        return Long.parseLong(principal.getUsername());
    }

    public AnalyticsController(AnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public List<TwoVariableDataTrend> getMonthlyTrends(@Argument("fromDate") String fromDate,
                                                       @Argument("toDate") String toDate) {
        return analyticsService.monthlyTrends(getCurrentUserId(), fromDate, toDate);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public List<CategorySummary> categorySummary( @Argument("fromDate") String fromDate,
                                                 @Argument("toDate") String toDate) {
        return analyticsService.generateCategorySummary(getCurrentUserId(),fromDate,toDate);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public TagSummary tagMonthlySummary(@Argument String tagName,@Argument String fromDate,
                                        @Argument String toDate) {
        return analyticsService.generateTagMonthlySummary(getCurrentUserId(),tagName,fromDate,toDate);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public CategorySpecificSummary categorySpecificSummary(@Argument long categoryId){
        return analyticsService.genSpecificCategorySummary(getCurrentUserId(),categoryId);
    }

}
