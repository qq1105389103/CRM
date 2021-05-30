package com.example.workbench.controller;

import com.example.exception.deleteException;
import com.example.exception.deleteRemarkException;
import com.example.exception.pageDisplayException;
import com.example.settings.domain.User;
import com.example.settings.service.User_Service;
import com.example.utils.UUIDUtil;
import com.example.workbench.domain.Activity;
import com.example.workbench.domain.ActivityRemark;
import com.example.workbench.service.ActivityRemarkService;
import com.example.workbench.service.ActivityService;
import com.example.workbench.vo.ActivityRemarkVo;
import com.example.workbench.vo.ActivityVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Controller
public class ActivityController {
    @Autowired
    private ActivityService service;
    @Autowired
    private User_Service u_service;
    @Autowired
    private ActivityRemarkService RemarkService;
    //查询活动
    @RequestMapping("/activity/displayAll.do")
    @ResponseBody
    public List<Activity> displayAll(){
        System.out.println("展示全部活动");
        return service.displayAll();
    }
    @RequestMapping("/activity/displayById.do")
    @ResponseBody
    public List<Activity> displayById(String id){
        return service.displayById(id);
    }
  //活动详情页
    @RequestMapping("/activity/displayDetail.do")
    public ModelAndView displayDetails(String id){
       Activity activity=  service.displayById2(id).get(0);
        ActivityRemarkVo activityRemarkVo=RemarkService.selectByAId(id,1,10);
       ModelAndView mv=new ModelAndView();
       mv.addObject("activity",activity);
       User user=u_service.selectId(id);
       mv.addObject("uid",user.getId());
       mv.addObject("remark",activityRemarkVo.getActivityRemark());
       mv.setViewName("forward:/stat/workbench/activity/detail.jsp");
       return mv;
    }
    //分页显示活动备注
    @RequestMapping("/activity/selectRemark.do")
    @ResponseBody
    public ActivityRemarkVo selectRemarkByAId(String id, int pageSize, int pageNum){
       return   RemarkService.selectByAId(id,pageNum,pageSize);
    }
    //删除活动备注
    @RequestMapping("/activity/deleteRemark.do")
    @ResponseBody
    public Map<String,String> deleteRemark(String id) throws deleteRemarkException {
        RemarkService.deleteRemark(id);
        return Map.of("msg","true");
    }
    //添加活动备注
    @RequestMapping("/activity/saveRemark.do")
    @ResponseBody
    public Map<String,String> saveRemark(ActivityRemark activityRemark,HttpServletRequest request){
      int res= RemarkService.saveRemark(activityRemark,request);
        if(res==1)
            return  Map.of("msg","添加成功");
        else
            return Map.of("msg","添加失败");
    }
    //更新活动备注
    @RequestMapping("/activity/updateRemark.do")
    @ResponseBody
    public Map<String,String> updateRemark(ActivityRemark activityRemark,HttpServletRequest request){
        int res=RemarkService.updateRemark(activityRemark,request);
        if(res==1)
            return  Map.of("msg","更新成功");
        else
            return Map.of("msg","更新失败");
    }

    //更新活动
 @RequestMapping("/activity/update.do")
 @ResponseBody
    public Map<String,String> updateById(Activity activity,HttpServletRequest request){

        int res=service.updateByID(activity,request);
        if(res==1)
        return Map.of("success","true");
        else
            return Map.of("success","false");
    }
    //创建活动
    @RequestMapping("/activity/save.do")
    @ResponseBody
    public Map<String,Boolean> saveActivity(Activity activity, HttpServletRequest request){
        activity.setId(UUIDUtil.getUUID());
            int res=  service.saveActivity(activity,request);
            if(res==1)
                return Map.of("success",true);
            else
                return Map.of("success",false);
    }

    @RequestMapping("/user/get.do")
    @ResponseBody
    public List<User> selectAll(HttpServletRequest request){
        System.out.println("ip地址为"+request.getLocalAddr());
        return u_service.display();
    }
    @RequestMapping("/activity/select.do")
    @ResponseBody
    public ActivityVo pageDisplay(Activity activity,int pageNum, int pageSize) throws pageDisplayException {
        System.out.println(activity);
       return service.pageDisplay(pageNum,pageSize,activity);

    }
    @RequestMapping("/activity/delete.do")
    @ResponseBody
    public Map<String,String> deleteActivity(HttpServletRequest request) throws deleteException {
       String[] ids = request.getParameterValues("id");
       for(String s:ids){
           System.out.println(s);
       }
        service.delActivity(ids);
        return Map.of("success","true","msg","删除成功");

    }

}
