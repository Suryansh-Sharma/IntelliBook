package com.suryansh.service;

import com.suryansh.dto.analytics.CategorySpecificSummary;
import com.suryansh.dto.analytics.CategorySummary;
import com.suryansh.dto.analytics.TagSummary;
import com.suryansh.dto.analytics.TwoVariableDataTrend;
import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.repository.TransactionRepository;
import com.suryansh.service.interfaces.AnalyticsService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;

@Service
public class AnalyticsServiceImpl implements AnalyticsService {
    private final TransactionRepository transactionRepository;

    public AnalyticsServiceImpl(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    @Override
    public List<TwoVariableDataTrend> monthlyTrends(long userId, String fromDate, String toDate) {
        ParsedDate parsedDate = parseDate(fromDate, toDate);
        Instant fromDateInst = parsedDate.start;
        Instant toDateInst = parsedDate.end;
        return transactionRepository.getGroupedTransactionByTag(userId, fromDateInst, toDateInst)
                .stream()
                .map(r -> new TwoVariableDataTrend((String) r[0], (BigDecimal) r[1]))
                .toList();
    }

    @Override
    public List<CategorySummary> generateCategorySummary(long userId, String fromDate, String toDate) {
        ParsedDate parsedDate = parseDate(fromDate, toDate);
        Instant start = parsedDate.start;
        Instant end = parsedDate.end;
        List<CategorySummary> summaries = transactionRepository.getCategorySummary(userId, start, end)
                .stream()
                .map(row -> new CategorySummary(
                        (int) row[0],
                        (String) row[1],
                        (BigDecimal) row[2],
                        ((Number) row[3]).intValue(),
                        ((Number) row[4]).intValue(),
                        List.of()
                ))
                .toList();
        List<Object[]> tagData = transactionRepository.getTagSummaryPerCategory(userId, start, end);

        Map<Integer, List<CategorySummary.TopTag>> tagMap = new HashMap<>();
        for (Object[] row : tagData) {
            int categoryId = (int) row[0];
            String tagName = String.valueOf(row[1]);
            BigDecimal amount = (BigDecimal) row[2];
            System.out.println("categoryId:" + categoryId + " tagName:" + tagName + " amount:" + amount);
            tagMap.computeIfAbsent(categoryId, k -> new ArrayList<>())
                    .add(new CategorySummary.TopTag(tagName, amount));
        }

        for (CategorySummary dto : summaries) {
            dto.setTopTags(tagMap.getOrDefault(dto.getCategoryId(), Collections.emptyList()));
        }


        return summaries;
    }

    @Override
    public TagSummary generateTagMonthlySummary(long userId, String tagName, String fromDate, String toDate) {
        ParsedDate parsedDate = parseDate(fromDate, toDate);
        BigDecimal totalAmount = BigDecimal.ZERO;
        int totalTransactionCount = 0;
        Instant start = parsedDate.start;
        Instant end = parsedDate.end;
        Map<String, TagSummary.MonthlyTagSummary> monthlyMap = new LinkedHashMap<>();

        List<Object[]> rawRes=transactionRepository
                .getCategorySummaryByTag(userId, start, end, tagName);

        for(Object[] r:rawRes){
            String monthName = (String) r[0];
            String categoryName = (String) r[2];
            BigDecimal amount = (BigDecimal) r[4];
            int transactionCount = ((Number) r[5]).intValue();

            totalAmount = totalAmount.add(amount);
            totalTransactionCount += transactionCount;
            TagSummary.CategorySummary categorySummary = new TagSummary.CategorySummary();
            categorySummary.setCategoryName(categoryName);
            categorySummary.setTotalAmount(amount);

            TagSummary.MonthlyTagSummary monthlySummary = monthlyMap.get(monthName);
            if (monthlySummary == null) {
                monthlySummary = new TagSummary.MonthlyTagSummary();
                monthlySummary.setMonth(monthName);
                monthlySummary.setTotalAmount(amount);
                monthlySummary.setCategorySummaries(new ArrayList<>(
                        List.of(categorySummary)
                ));
                monthlyMap.put(monthName, monthlySummary);
            }else{
                monthlySummary.setTotalAmount(monthlySummary.getTotalAmount().add(amount));
                monthlySummary.getCategorySummaries().add(categorySummary);
            }
        }
        TagSummary tagSummary = new TagSummary();
        tagSummary.setTagName(tagName);
        tagSummary.setTotalAmount(totalAmount);
        tagSummary.setTransactionCount(totalTransactionCount);
        tagSummary.setMonthlySummaries(new ArrayList<>(monthlyMap.values()));
        return tagSummary;
    }

    @Override
    public CategorySpecificSummary genSpecificCategorySummary(long userId, long categoryId) {
        List<CategorySpecificSummary.MonthlySpending> monthlySpending = transactionRepository
                .getTransactionMonSumForCate(userId,categoryId).stream()
                .map(row -> new CategorySpecificSummary.MonthlySpending(
                        (String) row[0],
                        (BigDecimal) row[1]
                )).toList();

        CategorySpecificSummary summary = transactionRepository.genCategorySummary(userId, categoryId);
        summary.setMonthlySpending(monthlySpending);
        return summary;
    }


    private ParsedDate parseDate(String fromDate, String toDate) {
        Instant start, end;
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate from = LocalDate.parse(fromDate, formatter);
            LocalDate to = LocalDate.parse(toDate, formatter);
            // Validation: at least one-month difference
            if (from.plusMonths(1).isAfter(to)) {
                throw new SpringIntelliBookEx("The date range must be at least one month apart.",
                        "DATE_RANGE_TOO_SHORT", HttpStatus.BAD_REQUEST);
            }
            start = from.atStartOfDay(ZoneId.of("Asia/Kolkata")).toInstant();
            end = to.atTime(23, 59, 59).atZone(ZoneId.of("Asia/Kolkata")).toInstant();
        } catch (DateTimeParseException e) {
            throw new SpringIntelliBookEx("Invalid date format. Use 'yyyy-MM-dd'",
                    "WRONG_DATE_FORMAT", HttpStatus.BAD_REQUEST);
        }
        return new ParsedDate(start, end);
    }

    private record ParsedDate(Instant start, Instant end) {
    }
}
