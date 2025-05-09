package com.suryansh.security;

import com.suryansh.entity.UserEntity;
import com.suryansh.service.CachingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserInfoService implements UserDetailsService {
    @Autowired
    private CachingService cachingService;

    public UserInfoService(){

    }

    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
        long userId = Long.parseLong(id);
        UserEntity u = cachingService.fetchUser(userId);
        return new UserPrincipal(u);
    }
}
