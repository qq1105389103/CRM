package com.example.settings.service;

import com.example.exception.LoginException;
import com.example.settings.domain.User;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface User_Service {
    public List<User> display();
           void login(String loginAct, String loginPsw, HttpServletRequest request) throws LoginException;
           public  User selectId(String id);
}

