package com.suryansh.security;

import com.suryansh.entity.UserDetailEntity;
import com.suryansh.entity.UserEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

public class UserPrincipal implements UserDetails {
    String id;
    String password;
    Set<GrantedAuthority> authorities=new HashSet<>();
    Boolean iActive;
    Boolean isVerified;

    public UserPrincipal(UserEntity user) {
        UserDetailEntity userDetail = user.getUserDetail();
        id = String.valueOf(user.getId());
        password = userDetail.getPassword();
        iActive=userDetail.isActive();
        isVerified=userDetail.isVerified();
        authorities.add(new SimpleGrantedAuthority("ROLE_"+userDetail.getRole()));
    }

    @Override
    public boolean isEnabled() {
        return isVerified&&iActive;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public String getUsername() {
        return id;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }
}
