package com.example.service;

import com.example.dao.StudentDao;
import com.example.domain.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class testService implements myService {
    @Autowired
    private StudentDao dao;
    @Override
    public List<Student> display(){
      List<Student> slist=  dao.selectStudents();
      return slist;
    }
}
