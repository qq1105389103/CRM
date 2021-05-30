package com.example.workbench.dao;

import com.example.workbench.domain.Activity;
import com.example.workbench.service.ActivityService;
import com.example.workbench.vo.ActivityVo;

import java.util.List;

public interface ActivityDao {
    public List<Activity> displayAllActivities();
    List<Activity> displayById(String id);
    List<Activity> displayById2(String id);
    int updateById(Activity activity);

    public int saveActivity(Activity activity);

    public List<Activity> pageDisplayByCondition(Activity activity);

    String getTotalByCondition(Activity activity);

    int delActivity(String[] ids);

    int selectRemark(String[] ids);

    int delRemark(String[] ids);

    int ActivityCount(String[] ids);
}
