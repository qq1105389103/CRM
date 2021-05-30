package com.example.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Objects;

public class login_interceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String access=request.getRequestURI();
        if(request.getSession().getAttribute("user")!=null||access.contains("login")|| Objects.equals(request.getContextPath()+"/",access)) {
            return true;
        }
        else {
            response.sendRedirect(request.getContextPath());
            return false;
        }
    }
}
