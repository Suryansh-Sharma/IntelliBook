package com.suryansh.service.interfaces;

import com.suryansh.dto.PaginationDto;
import com.suryansh.dto.TransactionFullDto;
import com.suryansh.dto.YearTransReportDto;
import com.suryansh.entity.TransactionEntity;
import com.suryansh.model.AddNewTransactionModel;

import java.util.Set;

public interface TransactionService {
    String addNewTransaction(AddNewTransactionModel addNewTransactionModel);

    TransactionFullDto transactionDetailById(long id);

    String updateTransaction(long transactionId,long categoryId,Set<String> tags, float amount, String timestamp, String description, TransactionEntity.TransactionType transactionType);

    String removeTransaction(long transactionId);

    PaginationDto transactionByDate(long userId,String date, String sortBy, String sortOrder);

    PaginationDto transactionInRange(long userId,String topic, String fromDate, String toDate, int pageSize,int pageNo,String sortBy, String sortOrder);

    YearTransReportDto yearlyTransactionReport(long userId, String fromDate, String toDate, String topic);
}
