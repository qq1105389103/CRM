package com.example.settings.controller;

import com.example.exception.LoginException;
import com.example.settings.domain.User;
import com.example.settings.service.myService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
public class User_Controller {
    @Autowired
    private myService service;
    @RequestMapping("/user/select.do")
    @ResponseBody
    public List<User> selectById(HttpServletRequest request){
System.out.println("ip地址为"+request.getLocalAddr());
        return service.display();
    }
    @RequestMapping(value = "/user/login.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,String> login(String loginAct, String loginPsw, HttpServletRequest request) throws LoginException {
            service.login(loginAct,loginPsw,request);
            return Map.of("success","true");
//将异常处理交给异常处理类

    }
   /* public Map<String,String> login(String loginAct, String loginPsw, HttpServletRequest request){
        try {
            service.login(loginAct,loginPsw,request);
            return Map.of("success","true");
        } catch (LoginException e) {
            String msg="异常";
            msg=e.getMessage();
            return Map.of("success","false","message",msg);
        }
    }*/
}
