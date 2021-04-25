package com.example.settings.service;

import com.example.exception.LoginException;
import com.example.settings.dao.UserDao;
import com.example.settings.domain.User;
import com.example.utils.DateTimeUtil;
import com.example.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
@Service
public class myServiceImpl implements myService {
    @Autowired
    private UserDao dao;
    @Override
    public List<User> display() {
        return  dao.selectById();
    }

    @Override
    public void login(String loginAct, String loginPsw, HttpServletRequest request) throws LoginException {
        loginPsw= MD5Util.getMD5(loginPsw);
       User user= dao.login(loginAct,loginPsw);
       if(user==null){
           throw new LoginException("账号或密码错误");
       }
           stateCheck(user,request);


    }

    private void stateCheck(User user,HttpServletRequest request) throws LoginException {
       String now= DateTimeUtil.getSysTime();
      String expireTime=  user.getExpireTime();
        int timeOk=0,lockOk=0,ipOk=1;
      if(now!=null&&expireTime!=null) {
          timeOk = now.compareTo(expireTime);
          if("0".equals(user.getLockState())){
              throw new LoginException("你的账号已经被锁定");
          }
         if(timeOk>0)
             throw new LoginException("你的账号已经失效");
      }
         request.getSession().setAttribute("user",user);

    }


}
