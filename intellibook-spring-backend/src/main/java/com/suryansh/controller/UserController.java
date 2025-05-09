package com.suryansh.controller;

import com.suryansh.dto.SearchRecordDto;
import com.suryansh.dto.UserInfoDto;
import com.suryansh.dto.UserLoginResDto;
import com.suryansh.model.AddNewUserModel;
import com.suryansh.model.SearchRecordModel;
import com.suryansh.security.UserPrincipal;
import com.suryansh.service.interfaces.UserService;
import jakarta.validation.Valid;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

@Controller
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    private long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserPrincipal principal = (UserPrincipal) authentication.getPrincipal();
        return Long.parseLong(principal.getUsername());
    }

    @MutationMapping
    public UserLoginResDto addNewUser(@Argument @Valid AddNewUserModel addNewUserModel) {
        return userService.addNewUser(addNewUserModel);
    }

    @MutationMapping
    public UserLoginResDto login(@Argument String username, @Argument String password) {
        return userService.handleLoginUser(username,password);
    }

    @MutationMapping
    public UserLoginResDto.JwtToken regenerateJwtFromRefreshToken(@Argument String refreshToken) {
        return userService.reGenToken(refreshToken);
    }

    @QueryMapping
    public UserInfoDto getUserById(@Argument long id) {
        return userService.userById(id);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public SearchRecordDto searchDataRecords(
            @Argument("model") SearchRecordModel model
    ) {
        return userService.searchRecords(getCurrentUserId(), model);
    }


}
