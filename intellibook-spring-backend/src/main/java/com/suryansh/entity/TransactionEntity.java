package com.suryansh.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Cascade;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.HashSet;
import java.util.Set;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@Table(name = "transaction")
public class TransactionEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private BigDecimal amount;
    private Instant timestamp;
    private Instant createdOn;
    private String description;
    @Enumerated(EnumType.STRING)
    private TransactionType transactionType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(columnDefinition = "category_id", referencedColumnName = "id")
    private CategoryEntity category;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(columnDefinition = "user_id", referencedColumnName = "id")
    private UserEntity user;


    @ManyToMany
    @JoinTable(
            name = "transaction_tags",
            joinColumns = @JoinColumn(name = "transaction_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    @Cascade(org.hibernate.annotations.CascadeType.ALL)
    Set<TagEntity> tags = new HashSet<>();

    public enum TransactionType {
        INCOME,
        EXPENSE
    }
}
