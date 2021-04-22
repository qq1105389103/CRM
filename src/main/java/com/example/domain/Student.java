package com.example.domain;

public class Student {
    private String name;
    private Integer id;
    private  Integer classnum;

    public Student(String name, Integer id, Integer classnum) {
        this.name = name;
        this.id = id;
        this.classnum = classnum;
    }

    public Student() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getClassnum() {
        return classnum;
    }

    public void setClassnum(Integer classnum) {
        this.classnum = classnum;
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", id=" + id +
                ", classnum=" + classnum +
                '}';
    }
}
