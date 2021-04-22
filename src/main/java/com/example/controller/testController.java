package com.example.controller;

import com.example.domain.Student;
import com.example.service.myService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class testController {
@Autowired
 private myService service;
    @RequestMapping("/test.do")
    @ResponseBody
    public List<Student> test(){
       List<Student> slist=service.display();
       return slist;
    }
}
