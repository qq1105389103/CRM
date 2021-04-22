package com.example.settings.service;

import com.example.exception.LoginException;
import com.example.settings.domain.User;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface myService {
    public List<User> display();
           void login(String loginAct, String loginPsw, HttpServletRequest request) throws LoginException;
}
