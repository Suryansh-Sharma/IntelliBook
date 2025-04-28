package com.suryansh.dto;

import java.math.BigDecimal;
import java.util.List;

public record YearTransReportDto(
        String title,
        String fromDate,
        String toDate,
        BigDecimal totalAmount,
        String mostFrequentMonth,
        String highestPaidMonth,
        List<MonthlySummaryDto> monthlySummary,
        UserLoginResDto userInfo
) {
    public record MonthlySummaryDto(String name,
                                    BigDecimal amount,int count) {}
}
