package com.suryansh.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
@Table(name = "user_detail")
public class UserDetailEntity {
    @Id
    private Long id;
    private String contact;
    private String email;
    private String password;
    @Enumerated(EnumType.STRING)
    private Role role;
    private Instant createdAt;
    private boolean isVerified;
    private boolean isActive;

    @OneToOne
    @MapsId
    @JoinColumn(name = "id")
    private UserEntity user;
    public enum Role {
        ADMIN,
        USER,
        MANAGER,
        NOT_AVAILABLE
    }


}
