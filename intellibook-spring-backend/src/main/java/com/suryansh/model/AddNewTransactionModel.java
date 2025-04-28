package com.suryansh.model;

import com.suryansh.entity.TransactionEntity;
import lombok.Data;

import java.util.List;

@Data
public class AddNewTransactionModel {
    private long userId;
    private long categoryId;
    private List<String> tags;
    private Float amount;
    private String timestamp;
    private String description;
    private TransactionEntity.TransactionType transactionType;
}
