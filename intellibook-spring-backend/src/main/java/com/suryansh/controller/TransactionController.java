package com.suryansh.controller;

import com.suryansh.dto.PaginationDto;
import com.suryansh.dto.TransactionFullDto;
import com.suryansh.dto.YearTransReportDto;
import com.suryansh.entity.TransactionEntity;
import com.suryansh.model.AddNewTransactionModel;
import com.suryansh.service.interfaces.TransactionService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;

import java.util.Set;

@Controller
public class TransactionController {
    private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    @MutationMapping
    public String addNewTransaction(@Argument @Validated AddNewTransactionModel addNewTransactionModel) {
        return transactionService.addNewTransaction(addNewTransactionModel);
    }
    @MutationMapping
    public String updateTransaction(@Argument long transactionId, @Argument long categoryId, @Argument Set<String> tags, @Argument float amount,
                                    @Argument String timestamp, @Argument String description, @Argument TransactionEntity.TransactionType transactionType) {
        return transactionService.updateTransaction(transactionId, categoryId, tags, amount, timestamp, description, transactionType);
    }
    @QueryMapping
    public TransactionFullDto getTransactionDetailById(@Argument long transactionId) {
        return transactionService.transactionDetailById(transactionId);
    }
    @MutationMapping
    public String deleteTransaction(@Argument long transactionId) {
        return transactionService.removeTransaction(transactionId);
    }
    @QueryMapping
    public PaginationDto getTransactionByDate(@Argument long userId, @Argument String date, @Argument String sortBy,
                                              @Argument String sortOrder) {
        return transactionService.transactionByDate(userId, date, sortBy, sortOrder);
    }
    @QueryMapping
    public PaginationDto getTransactionBetweenRange(@Argument long userId,
                                                    @Argument String topic,
                                                    @Argument String fromDate,
                                                    @Argument String toDate,
                                                    @Argument int pageSize,
                                                    @Argument int pageNo,
                                                    @Argument String sortBy,
                                                    @Argument String sortOrder) {
        return transactionService.transactionInRange(userId,topic, fromDate, toDate, pageSize, pageNo, sortBy, sortOrder);
    }
    @QueryMapping
    public YearTransReportDto getYearlyTransactionReport(@Argument long userId, @Argument String fromDate,
                                                         @Argument String toDate, @Argument String topic) {
        return transactionService.yearlyTransactionReport(userId,fromDate,toDate,topic);
    }
}
