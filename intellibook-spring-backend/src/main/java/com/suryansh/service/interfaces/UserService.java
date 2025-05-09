package com.suryansh.service.interfaces;


import com.suryansh.dto.SearchRecordDto;
import com.suryansh.dto.UserInfoDto;
import com.suryansh.model.AddNewUserModel;
import com.suryansh.dto.UserLoginResDto;
import com.suryansh.model.SearchRecordModel;
import jakarta.validation.Valid;

public interface UserService {
    UserLoginResDto addNewUser(@Valid AddNewUserModel addNewUserModel);

    UserInfoDto userById(long id);

    SearchRecordDto searchRecords(long userId, SearchRecordModel searchRecordModel);

    UserLoginResDto handleLoginUser(String username, String password);

    UserLoginResDto.JwtToken reGenToken(String refreshToken);
}
