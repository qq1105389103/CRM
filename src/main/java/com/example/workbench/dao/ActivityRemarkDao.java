package com.example.workbench.dao;

import com.example.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
 List<ActivityRemark> selectByAid(String id);
 int getTotalById(String id);
 int deleteRemark(String id);
 int updateRemark(ActivityRemark activityRemark);
 int saveRemark(ActivityRemark activityRemark);
}
