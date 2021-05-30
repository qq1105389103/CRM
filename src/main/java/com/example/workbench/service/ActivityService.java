package com.example.workbench.service;

import com.example.exception.deleteException;
import com.example.exception.pageDisplayException;
import com.example.workbench.domain.Activity;
import com.example.workbench.vo.ActivityVo;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface ActivityService {
    public List<Activity> displayAll();
    public  List<Activity> displayById(String id);
    public  List<Activity> displayById2(String id);
    public  int saveActivity(Activity activity, HttpServletRequest request);
    public ActivityVo pageDisplay(int pageNum, int pageSize,Activity activity) throws pageDisplayException;
    public int delActivity(String[] ids) throws deleteException;
     int updateByID(Activity activity, HttpServletRequest request);
}
