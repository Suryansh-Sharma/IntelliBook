package com.suryansh.controller;

import com.suryansh.dto.SearchRecordDto;
import com.suryansh.dto.UserLoginResDto;
import com.suryansh.model.AddNewUserModel;
import com.suryansh.model.SearchRecordModel;
import com.suryansh.service.interfaces.UserService;
import jakarta.validation.Valid;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @MutationMapping
    public UserLoginResDto addNewUser(@Argument @Valid AddNewUserModel addNewUserModel) {
        return userService.addNewUser(addNewUserModel);
    }

    @QueryMapping
    public UserLoginResDto getUserById(@Argument int id) {
        return userService.userById(id);
    }

    @QueryMapping
    public SearchRecordDto searchDataRecords(
            @Argument("userId") int userId,
            @Argument("model") SearchRecordModel model
    ) {
        return userService.searchRecords(userId, model);
    }


}
