package com.example.settings.dao;

import com.example.settings.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {
    List<User> selectById();
    User login(@Param("loginAct") String loginAct, @Param("loginPsw") String loginPsw);
}
