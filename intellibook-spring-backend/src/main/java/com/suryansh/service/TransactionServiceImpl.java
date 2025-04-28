package com.suryansh.service;

import com.suryansh.dto.*;
import com.suryansh.entity.CategoryEntity;
import com.suryansh.entity.TagEntity;
import com.suryansh.entity.TransactionEntity;
import com.suryansh.entity.UserEntity;
import com.suryansh.exception.SpringIntelliBookEx;
import com.suryansh.model.AddNewTransactionModel;
import com.suryansh.repository.TagRepository;
import com.suryansh.repository.TransactionRepository;
import com.suryansh.repository.UserRepository;
import com.suryansh.service.interfaces.TransactionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Transactional
public class TransactionServiceImpl implements TransactionService {
    private static final Logger logger = LoggerFactory.getLogger(TransactionServiceImpl.class);
    private final UserRepository userRepository;
    private final TransactionRepository transactionRepository;
    private final TagRepository tagRepository;

    public TransactionServiceImpl(UserRepository userRepository, TransactionRepository transactionRepository, TagRepository tagRepository) {
        this.userRepository = userRepository;
        this.transactionRepository = transactionRepository;
        this.tagRepository = tagRepository;
    }

    @Override
    public String addNewTransaction(AddNewTransactionModel model) {
        // Parse the timestamp and handle format exception
        ZonedDateTime zonedDateTime;
        try {
            zonedDateTime = ZonedDateTime.parse(model.getTimestamp());
        } catch (DateTimeParseException e) {
            throw new SpringIntelliBookEx("Invalid timestamp format. Use 'yyyy-MM-dd'T'HH:mm:ss.SSSXXX' for timestamp.",
                    "WRONG_FORMAT", HttpStatus.BAD_REQUEST);
        }

        // Retrieve user and validate
        UserEntity user = userRepository.findUserWithCategories(model.getUserId())
                .orElseThrow(() -> new SpringIntelliBookEx("User not found for ID: " + model.getUserId(),
                        "USER_NOT_FOUND", HttpStatus.NOT_FOUND));

        // Retrieve category and validate
        CategoryEntity category = user.getCategories().stream()
                .filter(c -> c.getId() == model.getCategoryId())
                .findFirst()
                .orElseThrow(() -> new SpringIntelliBookEx("Category not found for ID: " + model.getCategoryId(),
                        "CATEGORY_NOT_FOUND", HttpStatus.NOT_FOUND));

        // Ensure that the tags exist in the category
        Set<String> categoryTags = category.getTags().stream()
                .map(TagEntity::getName)
                .collect(Collectors.toSet());
        model.getTags().forEach(tag -> {
            if (!categoryTags.contains(tag)) {
                throw new SpringIntelliBookEx("Tag not found in category: " + tag,
                        "TAG_NOT_FOUND", HttpStatus.BAD_REQUEST);
            }
        });

        // Ensure the tags are persistent and load them if necessary
        Set<TagEntity> tagEntities = category.getTags().stream()
                .filter(tag -> model.getTags().contains(tag.getName()))
                .collect(Collectors.toSet());

        // Create and build the TransactionEntity
        TransactionEntity transaction = TransactionEntity.builder()
                .amount(BigDecimal.valueOf(model.getAmount()))
                .timestamp(zonedDateTime.toInstant())
                .createdOn(ZonedDateTime.now(ZoneId.of("Asia/Kolkata")).toInstant())
                .description(model.getDescription())
                .transactionType(model.getTransactionType())
                .category(category)
                .tags(tagEntities)
                .user(user)
                .build();

        try {
            transactionRepository.save(transaction);  // Save the transaction
            logger.info("Transaction added successfully with ID: {}", transaction.getId());
            return "SUCCESS";
        } catch (Exception e) {
            logger.error("Unable to add new transaction: {}", e.getMessage(), e);
            throw new SpringIntelliBookEx("Unable to add new Transaction", "INTERNAL_SERVER_ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public TransactionFullDto transactionDetailById(long id) {
        TransactionEntity transaction = transactionRepository.findTransactionFullDetailById(id)
                .orElseThrow(() -> new SpringIntelliBookEx("Transaction not found for ID: " + id,
                        "TRANSACTION_NOT_FOUND", HttpStatus.NOT_FOUND));
        return mapTransactionToFullDto(transaction);
    }

    @Override
    public String updateTransaction(long transactionId, long categoryId, Set<String> tags, float amount,
                                    String timestamp, String description, TransactionEntity.TransactionType transactionType) {
        try {
            // Parse timestamp safely
            ZonedDateTime zonedDateTime = ZonedDateTime.parse(timestamp);
            // Fetch existing transaction
            TransactionEntity existingTransaction = transactionRepository.findById(transactionId)
                    .orElseThrow(() -> new SpringIntelliBookEx("Transaction not found for ID: " + transactionId, "TRANSACTION_NOT_FOUND",
                            HttpStatus.NOT_FOUND));
            // Fetch category-associated tags
            Set<TagEntity> availableTags = tagRepository.findTagsByCategory(categoryId);
            if (tags == null || tags.isEmpty()) {
                throw new SpringIntelliBookEx("Tags cannot be empty.", "TAG_VALIDATION_ERROR", HttpStatus.BAD_REQUEST);
            }
            // Normalize tag names (convert input to uppercase for case-insensitive matching)
            Set<String> normalizedTags = tags.stream()
                    .map(String::toUpperCase)
                    .collect(Collectors.toSet());
            // FilterDto only the tags that exist in the category
            Set<TagEntity> newTags = availableTags.stream()
                    .filter(tag -> normalizedTags.contains(tag.getName()))
                    .collect(Collectors.toSet());
            // Validate: Ensure all input tags exist in the category
            if (newTags.size() != normalizedTags.size()) {
                throw new SpringIntelliBookEx("Some tags are not part of category ID: " + categoryId,
                        "TAG_NOT_FOUND", HttpStatus.BAD_REQUEST);
            }
            // **Replace the old tags with the new tags**
            existingTransaction.setTags(newTags);
            existingTransaction.setAmount(BigDecimal.valueOf(amount));
            existingTransaction.setTimestamp(zonedDateTime.toInstant());
            existingTransaction.setDescription(description);
            existingTransaction.setTransactionType(transactionType);
            transactionRepository.save(existingTransaction);
            return "Transaction updated successfully!";
        } catch (DateTimeParseException e) {
            throw new SpringIntelliBookEx("Invalid timestamp format. Use 'yyyy-MM-dd'T'HH:mm:ss.SSSXXX'.",
                    "WRONG_FORMAT", HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            logger.error("Unable to update transaction: {}", e.getMessage(), e);
            throw new SpringIntelliBookEx("Unable to update transaction: " + e.getMessage(),
                    "INTERNAL_SERVER_ERROR", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public String removeTransaction(long transactionId) {
        TransactionEntity existingTransaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new SpringIntelliBookEx("Transaction not found for ID: " + transactionId, "TRANSACTION_NOT_FOUND",
                        HttpStatus.NOT_FOUND));
        existingTransaction.getTags().clear();
        try {
            transactionRepository.save(existingTransaction);
            transactionRepository.delete(existingTransaction);
            return "Transaction deleted successfully! of Id: " + transactionId;
        } catch (Exception e) {
            logger.error("Unable to delete transaction: {}", e.getMessage(), e);
            throw new SpringIntelliBookEx("Unable to delete transaction !!", "INTERNAL_SERVER_ERROR",
                    HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public PaginationDto transactionByDate(long userId, String date, String sortBy, String sortOrder) {
        LocalDate localDate;
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            localDate = LocalDate.parse(date, formatter);
        } catch (DateTimeParseException e) {
            throw new SpringIntelliBookEx("Invalid date format. Use 'yyyy-MM-dd'",
                    "WRONG_DATE_FORMAT", HttpStatus.BAD_REQUEST);
        }
        List<String> allowedSortFields = List.of("amount", "createdOn");
        if (sortBy != null && !allowedSortFields.contains(sortBy)) {
            throw new SpringIntelliBookEx(
                    sortBy + " is not available. Use only amount, createdOn, or leave it empty.",
                    "SORT_BY_NOT_AVAILABLE",
                    HttpStatus.BAD_REQUEST
            );
        }
        if (sortBy == null) {
            sortBy = "createdOn";
        }
        Sort.Direction direction = (sortOrder != null && sortOrder.equals("ASC"))
                ? Sort.Direction.ASC
                : Sort.Direction.DESC;
        Sort sort = Sort.by(direction, sortBy);

        List<TransactionFullDto> res = transactionRepository.getByDate(userId, localDate, sort).stream()
                .map(this::mapTransactionToFullDto).toList();

        return new PaginationDto(0, 0,
                res, 0, res.size(), sortBy, direction.toString()
        );
    }

    @Override
    public PaginationDto transactionInRange(long userId, String topic,
                                            String fromDate, String toDate,
                                            int pageSize, int pageNo,
                                            String sortBy, String sortOrder) {
        // Collect Topic and validate its format.
        String title, name;
        if (topic.contains(":")) {
            String[] split = topic.split(":", 2);
            title = split[0].trim().toLowerCase();
            name = split[1].trim();
        } else {
            throw new SpringIntelliBookEx(
                    "Invalid topic format. Use 'general:all' or 'category:name' or 'tag:name' . Example: 'general:all' or 'category:Food' or 'tag:Arvind' ",
                    "WRONG_TOPIC_FORMAT",
                    HttpStatus.BAD_REQUEST
            );
        }
        // Parse and check date.
        LocalDate from, to;
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            from = LocalDate.parse(fromDate, formatter);
            to = LocalDate.parse(toDate, formatter);
        } catch (DateTimeParseException e) {
            throw new SpringIntelliBookEx("Invalid date format. Use 'yyyy-MM-dd'",
                    "WRONG_DATE_FORMAT", HttpStatus.BAD_REQUEST);
        }
        if (from.isAfter(to)) {
            throw new SpringIntelliBookEx("FromDate cannot be after ToDate.",
                    "WRONG_DATE_FORMAT", HttpStatus.BAD_REQUEST);
        }
        Instant fromInstant = from.atStartOfDay(ZoneId.of("Asia/Kolkata")).toInstant();
        Instant toInstant = to.atTime(23, 59, 59).atZone(ZoneId.of("Asia/Kolkata")).toInstant();

        List<String> allowedSortFields = List.of("amount", "timestamp", "createdOn");
        if (sortBy != null && !allowedSortFields.contains(sortBy)) {
            throw new SpringIntelliBookEx(
                    sortBy + " is not available. Use only amount, timestamp, createdOn, or leave it empty.",
                    "SORT_BY_NOT_AVAILABLE",
                    HttpStatus.BAD_REQUEST
            );
        }
        if (sortBy == null) {
            sortBy = "timestamp";
        }
        // prepare pagination logic and sort logic.
        Sort.Direction direction = (sortOrder != null) ? Sort.Direction.fromString(sortOrder) : Sort.Direction.DESC;
        Sort sort = Sort.by(direction, sortBy);
        Pageable pageable = PageRequest.of(pageNo, pageSize, sort);
        // Prepare Pagination page and Fetch Data According to topic
        Page<TransactionEntity> resPage;
        switch (title) {
            case "general" -> {
                if (!name.equalsIgnoreCase("all")) {
                    throw new SpringIntelliBookEx(
                            "For 'general', only 'general:all' is allowed.",
                            "INVALID_GENERAL_TOPIC",
                            HttpStatus.BAD_REQUEST
                    );
                }
                resPage = transactionRepository.getTransactionsBetweenDate(userId, fromInstant, toInstant, pageable);
            }
            case "category" -> {
                if (name.isEmpty()) {
                    throw new SpringIntelliBookEx(
                            "Category name cannot be empty. Use format 'category:Food'.",
                            "INVALID_CATEGORY_NAME",
                            HttpStatus.BAD_REQUEST
                    );
                }
                resPage = transactionRepository.getTransactionsBetweenDateByCategory(userId,name.toUpperCase(), fromInstant, toInstant, pageable);
            }
            case "tag" -> {
                if (name.isEmpty()) {
                    throw new SpringIntelliBookEx("Tag name cannot be empty. Use format 'tag:Arvind",
                            "INVALID_CATEGORY_NAME",
                            HttpStatus.BAD_REQUEST);
                }
                resPage = transactionRepository.getTransactionsBetweenDateByTag(userId, name.toUpperCase(), fromInstant, toInstant, pageable);
            }
            default -> throw new SpringIntelliBookEx(
                    "Invalid topic. Use 'general:all' for all transactions or 'category:name' for category-wise reports. or 'tag:name' for tag-wise reports.",
                    "INVALID_TOPIC",
                    HttpStatus.BAD_REQUEST);
        }
        if (resPage==null) {
            throw new SpringIntelliBookEx("No data found for your query !!",
                    "NO_DATA_FOUND",HttpStatus.BAD_REQUEST);
        }
        return new PaginationDto(
                resPage.getNumber(),
                resPage.getSize(),
                resPage.getContent().stream()
                        .map(this::mapTransactionToFullDto)
                        .toList(),
                resPage.getTotalPages(),
                resPage.getTotalElements(),
                sortBy,
                direction.toString() 
        );
    }

    @Override
    public YearTransReportDto yearlyTransactionReport(long userId, String fromDate, String toDate, String topic) {
        Instant fromDateInstant, toDateInstant;
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            fromDateInstant = LocalDate.parse(fromDate, formatter).atStartOfDay(ZoneId.of("Asia/Kolkata")).toInstant();
            toDateInstant = LocalDate.parse(toDate, formatter).atTime(23, 59, 59).atZone(ZoneId.of("Asia/Kolkata")).toInstant();
        } catch (DateTimeParseException e) {
            throw new SpringIntelliBookEx("Invalid date format. Use 'yyyy-MM-dd'",
                    "WRONG_DATE_FORMAT", HttpStatus.BAD_REQUEST);
        }
        String title;
        String name;

        if (topic.contains(":")) {
            String[] parts = topic.split(":", 2);
            title = parts[0].trim().toLowerCase();
            name = parts[1].trim();
        } else {
            throw new SpringIntelliBookEx(
                    "Invalid topic format. Use 'general:all' or 'category:name' or 'tag:name' . Example: 'general:all' or 'category:Food' or 'tag:Arvind' ",
                    "WRONG_TOPIC_FORMAT",
                    HttpStatus.BAD_REQUEST
            );
        }
        List<Object[]> monthlyData;
        switch (title) {
            case "general" -> {
                if (!name.equalsIgnoreCase("all")) {
                    throw new SpringIntelliBookEx(
                            "For 'general', only 'general:all' is allowed.",
                            "INVALID_GENERAL_TOPIC",
                            HttpStatus.BAD_REQUEST
                    );
                }
                monthlyData = transactionRepository.getMonthlySummary(userId, fromDateInstant, toDateInstant);
            }
            case "category" -> {
                if (name.isEmpty()) {
                    throw new SpringIntelliBookEx(
                            "Category name cannot be empty. Use format 'category:Food'.",
                            "INVALID_CATEGORY_NAME",
                            HttpStatus.BAD_REQUEST
                    );
                }
                monthlyData = transactionRepository
                        .getMonthlySummaryByCategory(userId, fromDateInstant, toDateInstant, name.toUpperCase());
            }
            case "tag" -> {
                if (name.isEmpty()) {
                    throw new SpringIntelliBookEx("Tag name cannot be empty. Use format 'tag:Arvind",
                            "INVALID_CATEGORY_NAME",
                            HttpStatus.BAD_REQUEST);
                }
                monthlyData = transactionRepository.getMonthlySummaryByTag(userId, fromDateInstant, toDateInstant, name.toUpperCase());
            }
            default -> throw new SpringIntelliBookEx(
                    "Invalid topic. Use 'general:all' for all transactions or 'category:name' for category-wise reports. or 'tag:name' for tag-wise reports.",
                    "INVALID_TOPIC",
                    HttpStatus.BAD_REQUEST
            );
        }

        String highestPaidMonth = "";
        String mostFrequentMonth = "";
        int highestPaidMonthCount = 0;
        int mostFrequentMonthCount = 0;
        BigDecimal totalAmount = BigDecimal.ZERO;
        List<YearTransReportDto.MonthlySummaryDto> monthlySummaryDto = new ArrayList<>();
        for (Object[] row : monthlyData) {
            String month = (String) row[0];
            int monthTransactionCount = ((Number) row[1]).intValue();
            BigDecimal amount = BigDecimal.valueOf(((Number) row[2]).doubleValue()).setScale(2, RoundingMode.HALF_UP);
            totalAmount = totalAmount.add(amount);
            if (monthTransactionCount > highestPaidMonthCount) {
                highestPaidMonthCount = monthTransactionCount;
                highestPaidMonth = month;
            }
            if (amount.compareTo(BigDecimal.valueOf(mostFrequentMonthCount)) > 0) {
                mostFrequentMonthCount = amount.intValue();
                mostFrequentMonth = month;
            }
            YearTransReportDto.MonthlySummaryDto newMonthlySummary =
                    new YearTransReportDto.MonthlySummaryDto(month, amount, monthTransactionCount);
            monthlySummaryDto.add(newMonthlySummary);
        }
        return new YearTransReportDto(
                topic,
                fromDate,
                toDate,
                totalAmount.setScale(2, RoundingMode.HALF_UP),
                mostFrequentMonth,
                highestPaidMonth,
                monthlySummaryDto,
                null
        );
    }


    private TransactionFullDto mapTransactionToFullDto(TransactionEntity transaction) {
        CategoryDto category = new CategoryDto(
                transaction.getCategory().getId(),
                transaction.getCategory().getName(),
                LocalDateTime.ofInstant(transaction.getCategory().getCreatedOn(),
                        ZoneId.of("Asia/Kolkata")),
                null
        );
        List<TransactionFullDto.TagDto> tags = transaction.getTags().stream()
                .map(t -> new TransactionFullDto.TagDto(
                        t.getId(),
                        t.getName(),
                        t.getDescription()
                )).toList();
        return new TransactionFullDto(
                transaction.getId(),
                transaction.getAmount(),
                LocalDateTime.ofInstant(transaction.getTimestamp(), ZoneId.of("Asia/Kolkata")),
                LocalDateTime.ofInstant(transaction.getCreatedOn(), ZoneId.of("Asia/Kolkata")),
                transaction.getDescription(),
                transaction.getTransactionType(),
                tags,
                category,
                new UserLoginResDto(
                        transaction.getUser().getId(),
                        transaction.getUser().getFirstname(),
                        transaction.getUser().getLastname(),
                        transaction.getUser().getUserDetail().getContact(),
                        transaction.getUser().getUserDetail().getEmail(),
                        transaction.getUser().getUserDetail().getRole(),
                        null,
                        false,
                        false
                )
        );
    }
}