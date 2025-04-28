package com.suryansh.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Builder
@Table(name = "user_entity")
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String firstname;
    private String lastname;


    @OneToOne(mappedBy = "user",cascade = CascadeType.ALL)
    @PrimaryKeyJoinColumn
    private UserDetailEntity userDetail;

    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<CategoryEntity>categories;

    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<TransactionEntity>transactions;
}
