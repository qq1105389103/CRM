package com.example.workbench.service;

import com.example.exception.deleteException;
import com.example.exception.pageDisplayException;
import com.example.settings.domain.User;
import com.example.utils.DateTimeUtil;
import com.example.workbench.dao.ActivityDao;
import com.example.workbench.domain.Activity;
import com.example.workbench.vo.ActivityVo;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityDao dao;

    @Override
    public int saveActivity(Activity activity, HttpServletRequest request) {
        User user= (User) request.getSession().getAttribute("user");
        activity.setCreateBy(user.getName());//这个应该是用用户id还是name?
        activity.setCreateTime(DateTimeUtil.getSysTime());
        return dao.saveActivity(activity);

    }

    @Override
    public ActivityVo pageDisplay(int pageNum, int pageSize,Activity activity) throws pageDisplayException {
        PageHelper.startPage(pageNum,pageSize);
        List<Activity> list=dao.pageDisplayByCondition(activity);
        String total=dao.getTotalByCondition(activity);
       if(list==null)
           throw new pageDisplayException("没有查询到数据");
        ActivityVo vo=new ActivityVo();
        vo.setActivity(list);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public List<Activity> displayAll() {
        return dao.displayAllActivities();
    }

    @Override
    public  List<Activity> displayById(String id){
        return dao.displayById(id);
    }

    @Override
    public List<Activity> displayById2(String id) {
        return  dao.displayById2(id);
    }

    @Override
    public int delActivity(String[] ids) throws deleteException {
        int count = dao.selectRemark(ids);
        System.out.println("count1======="+count);
        if (count > 0) {
            int num = dao.delRemark(ids);
            if (num != count)
                throw new deleteException("删除备注失败");
        }
        count = dao.ActivityCount(ids);//直接count=dao.length 数组长度即可
        System.out.println("count=================="+count);
        if (count > 0) {
            int res = dao.delActivity(ids);
            System.out.println("res============"+res);
            if (res!=count)
                throw new deleteException("删除活动失败");
        }
            return 1;
        }

    @Override
    public int updateByID(Activity activity, HttpServletRequest request) {
        User user= (User) request.getSession().getAttribute("user");
        activity.setEditBy(user.getName());  //注意在服务器端添加编辑人与编辑时间
        activity.setEditTime(DateTimeUtil.getSysTime());
       return dao.updateById(activity);
    }

}

