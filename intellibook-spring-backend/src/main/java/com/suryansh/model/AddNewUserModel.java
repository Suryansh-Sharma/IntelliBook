package com.suryansh.model;

import com.suryansh.entity.UserDetailEntity;
import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class AddNewUserModel {
    @NotBlank(message = "First name is required")
    @Size(min = 2, max = 50, message = "First name must be between 2 and 50 characters")
    private String firstname;

    @NotBlank(message = "Last name is required")
    @Size(min = 2, max = 50, message = "Last name must be between 2 and 50 characters")
    private String lastname;

    @NotBlank(message = "Contact is required")
    @Pattern(regexp = "\\d{10}", message = "Contact must be a 10-digit number")
    private String contact;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters long")
    private String password;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotNull(message = "Role is required")
    private UserDetailEntity.Role role;
}
