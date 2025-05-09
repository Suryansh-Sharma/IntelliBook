package com.suryansh.controller;

import com.suryansh.dto.PaginationDto;
import com.suryansh.dto.TransactionFullDto;
import com.suryansh.dto.YearTransReportDto;
import com.suryansh.entity.TransactionEntity;
import com.suryansh.model.AddNewTransactionModel;
import com.suryansh.security.UserPrincipal;
import com.suryansh.service.interfaces.TransactionService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;

import java.util.Set;

@Controller
public class TransactionController {
    private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    private long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();
        return Long.parseLong(principal.getUsername());
    }

    @PreAuthorize("isAuthenticated()")
    @MutationMapping
    public String addNewTransaction(@Argument @Validated AddNewTransactionModel addNewTransactionModel) {
        return transactionService.addNewTransaction(addNewTransactionModel);
    }

    @PreAuthorize("isAuthenticated()")
    @MutationMapping
    public String updateTransaction(@Argument long transactionId, @Argument long categoryId, @Argument Set<String> tags, @Argument float amount,
                                    @Argument String timestamp, @Argument String description, @Argument TransactionEntity.TransactionType transactionType) {
        return transactionService.updateTransaction(transactionId, categoryId, tags, amount, timestamp, description, transactionType);
    }

    @PreAuthorize("isAuthenticated()")
    @QueryMapping
    public TransactionFullDto getTransactionDetailById(@Argument long transactionId) {
        return transactionService.transactionDetailById(transactionId);
    }

    @MutationMapping
    @PreAuthorize("isAuthenticated()")
    public String deleteTransaction(@Argument long transactionId) {
        return transactionService.removeTransaction(transactionId);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public PaginationDto getTransactionByDate(@Argument String date, @Argument String sortBy,
                                              @Argument String sortOrder) {
        return transactionService.transactionByDate(getCurrentUserId(), date, sortBy, sortOrder);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public PaginationDto getTransactionBetweenRange(@Argument String topic,
                                                    @Argument String fromDate,
                                                    @Argument String toDate,
                                                    @Argument int pageSize,
                                                    @Argument int pageNo,
                                                    @Argument String sortBy,
                                                    @Argument String sortOrder) {
        return transactionService.transactionInRange(getCurrentUserId(),topic, fromDate, toDate, pageSize, pageNo, sortBy, sortOrder);
    }

    @PreAuthorize("isAuthenticated()")
    @QueryMapping
    public YearTransReportDto getYearlyTransactionReport(@Argument String fromDate,
                                                         @Argument String toDate, @Argument String topic) {
        return transactionService.yearlyTransactionReport(getCurrentUserId(),fromDate,toDate,topic);
    }
}
