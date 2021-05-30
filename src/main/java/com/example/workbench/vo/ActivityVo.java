package com.example.workbench.vo;

import com.example.workbench.domain.Activity;

import java.util.List;

public class ActivityVo<E> {

    private List<E> activity;
    private String total;

    public ActivityVo() {
    }

    public ActivityVo(List<E> activity, String total) {
        this.activity = activity;
        this.total = total;
    }

    public List<E> getActivity() {
        return activity;
    }

    public void setActivity(List<E> activity) {
        this.activity = activity;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }
}
