package com.example.workbench.service;

import com.example.exception.deleteRemarkException;
import com.example.workbench.domain.Activity;
import com.example.workbench.domain.ActivityRemark;
import com.example.workbench.vo.ActivityRemarkVo;
import com.example.workbench.vo.ActivityVo;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface ActivityRemarkService {
   ActivityRemarkVo selectByAId(String id, int pageNum, int pageSize);
   int deleteRemark(String id) throws deleteRemarkException;
   int updateRemark(ActivityRemark activityRemark, HttpServletRequest request);
   int saveRemark(ActivityRemark activityRemark,HttpServletRequest request);
}
