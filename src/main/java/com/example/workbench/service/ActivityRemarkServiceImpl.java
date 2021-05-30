package com.example.workbench.service;

import com.example.exception.deleteRemarkException;
import com.example.settings.domain.User;
import com.example.utils.DateTimeUtil;
import com.example.utils.UUIDUtil;
import com.example.workbench.dao.ActivityRemarkDao;
import com.example.workbench.domain.ActivityRemark;
import com.example.workbench.vo.ActivityRemarkVo;
import com.example.workbench.vo.ActivityVo;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    ActivityRemarkDao dao;
    @Override
    public ActivityRemarkVo<ActivityRemark> selectByAId(String id, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);
         List<ActivityRemark> activityRemarks= dao.selectByAid(id);
         int total= dao.getTotalById(id);
          return  new ActivityRemarkVo<ActivityRemark>(activityRemarks,total);
    }

    @Override
    public int deleteRemark(String id) throws deleteRemarkException {
         int res=dao.deleteRemark(id);
         if(res==1)
             return res;
         else
             throw new deleteRemarkException("删除失败");
    }

    @Override
    public int updateRemark(ActivityRemark activityRemark, HttpServletRequest request) {
        String   editTime= DateTimeUtil.getSysTime();
        User user=(User)request.getSession().getAttribute("user");
        String editBy=user.getName();
        activityRemark.setEditBy(editBy);
        activityRemark.setEditTime(editTime);
        activityRemark.setEditFlag("1");
      return dao.updateRemark(activityRemark);
    }

    @Override
    public int saveRemark(ActivityRemark activityRemark, HttpServletRequest request) {
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        User user= (User) request.getSession().getAttribute("user");
        activityRemark.setCreateBy(user.getName());
        activityRemark.setId(UUIDUtil.getUUID());

      return   dao.saveRemark(activityRemark);
    }
}
