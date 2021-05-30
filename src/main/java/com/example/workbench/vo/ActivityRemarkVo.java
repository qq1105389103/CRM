package com.example.workbench.vo;

import java.util.List;

public class ActivityRemarkVo<E> {
  private List<E> activityRemark;
  private  int Total;

    public ActivityRemarkVo(List<E> activityRemark, int total) {
        this.activityRemark = activityRemark;
        Total = total;
    }

    public List<E> getActivityRemark() {
        return activityRemark;
    }

    public void setActivityRemark(List<E> activityRemark) {
        this.activityRemark = activityRemark;
    }

    public int getTotal() {
        return Total;
    }

    public void setTotal(int total) {
        Total = total;
    }
}
