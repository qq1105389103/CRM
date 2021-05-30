package com.example.web.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Objects;

@WebFilter(urlPatterns = {"/stat2/*","*.do","*.jsp"})
public class login_filter implements Filter {
    @Override
    public void doFilter(ServletRequest Srequest, ServletResponse Sresponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request= (HttpServletRequest) Srequest;
        HttpServletResponse response= (HttpServletResponse) Sresponse;
        String access=request.getRequestURI();
        System.out.println(request.getContextPath());
        System.out.println(access);
        if(request.getSession().getAttribute("user")!=null||access.contains("login")||Objects.equals(request.getContextPath()+"/",access)) {
            chain.doFilter(request, response);
            return;
        }
        else
            response.sendRedirect(request.getContextPath());
    }


}
