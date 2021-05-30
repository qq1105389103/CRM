<%@ page import="com.example.workbench.domain.ActivityRemark" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"   %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>

<base href="<%=basePath%>">
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="stat/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="stat/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="stat/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="stat/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="stat/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="stat/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link href="stat/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" src="stat/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="stat/jquery/bs_pagination/en.js"></script>


    <script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","140px");
                $("#remark").css("height","120")
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});

		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
            $("#remark").css("height","60")
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		$("#showRemark").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		})
		$("#showRemark").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		})
		$("#showRemark").on("mouseover",".myHref",function (){
			$(this).children("span").css("color","red");
		})
		$("#showRemark").on("mouseout",".myHref",function (){
			$(this).children("span").css("color","#a94442");
		})
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#a94442");
		});

		$("#editActivity").on("click",function (){
			$("#editActivityModal").modal("show")
		})
		$.ajax({url:"user/get.do",
			data:{},
			dataType:"json",
			type:"get",
			success:function (data){
				var html="";
				$.each(data,function (i,e){
					html+="<option value='"+e.id+"'>"+e.name+"</option>"
				})
				$("#edit-owner").html(html);
				$("#edit-owner").val("${uid}");//注 要放在双引号中

			}
		})
		$("#editBtn").on("click",function (){
			if(confirm("确定修改?")) {
				$.ajax({
					url: "activity/update.do",
					data: {
						"owner": $.trim($("#edit-owner").val()),
						"name": $.trim($("#edit-name").val()),
						"startDate": $.trim($("#edit-startDate").val()),
						"endDate": $.trim($("#edit-endDate").val()),
						"cost": $.trim($("#edit-cost").val()),
						"description": $.trim($("#edit-describe").val()),
						"id": $.trim($("#edit-id").val())
					},
					dataType: "json",
					success: function (data) {
						if ("true" == data.success) {
							alert("更新成功")
							$("#editActivityModal").modal("hide")
							document.location.href='activity/displayDetail.do?id=${activity.id}'
						}
					}
				})
			}
		})
		$("#delBtn").on("click",function (){
			if(confirm("确定修改?")){
				$.ajax({
					url:"activity/delete.do",
					data:{"id":"${activity.id}"},  //el表达式代表参数时放在双引号中 ,未放在双引号中不知道参数类型,模态窗口都打不开了
					dataType:"json",
					success:function (data){
						alert(data.msg)
						document.location.href='stat/workbench/activity/index.jsp'
					}
				})
			}
		})
        //编辑备注
        $("#RemarkEditBtn").on("click",function (){

        /*    var $noteContent=$("#noteContent");
            var s=$noteContent.val()
            var s2= s.replace(/'/g,"\\\'")*/

            $.ajax({

                url:"activity/updateRemark.do",
                data:{"id":$("#remarkId").val(),
                    "noteContent":$("#noteContent").val()} ,
                dataType:"json",
                success:function (data){
                    if(data.msg=="更新成功"){
                        alert("更新成功")
                        RPageList($("#activityPage").bs_pagination('getOption','currentPage'), $("#activityPage").bs_pagination('getOption','rowsPerPage'))
                        $("#editRemarkModal").modal("hide");
                    }
                    else alert("更新失败")
                }
            })
        })
        //添加备注
        $("#remarkSaveBtn").on("click",function (){

            /*//对' \等字符进行操作
            var $noteContent=$("#remark");
            var s=$noteContent.val()
            var s2= s.replace(/'/g,"\\\'")*/

            $.ajax({
                url:"activity/saveRemark.do",
                data:{"noteContent":$("#remark").val(),
                "activityId":"${activity.id}"},
                dataType:"json",
                success:function (data){
                 if(data.msg=="添加成功")
                 {
                     alert(data.msg)
                     RPageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'))
                     $("#remark").val("")
                 }
                }
            })
        })
		$(".time").datetimepicker({
			minView:"month",
			language:"zh-CN",
			format:"yyyy-mm-dd",
			autoclose:true,
			todayBtn:true,
			pickerPosition:"bottom-left"
		});
		RPageList(1,5)
	});

        deleteRemark=function (id){
	    if(confirm("确定删除吗?")) {
            $.ajax({
                url: "activity/deleteRemark.do",
                data: {"id": id},
                dataType: "json",
                success: function (data) {
                    if (data.msg == "true") {
                        alert("删除成功")
                        RPageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                    } else (alert(data.msg))
                }
            })
        }
		}

		editRemark=function (id){
	    $("#editRemarkModal").modal("show");
        $("#remarkId").val(id);
         $("#noteContent").val($("#e"+id).html())
        }



        //分页查询备注
		RPageList=function (pageNum,pageSize){
		    var html=''
		    $.ajax({
                url:"activity/selectRemark.do",
                data:{"id":"${activity.id}",
                     "pageNum":pageNum,
                    "pageSize":pageSize,
                },
                dataType:"json",
                success:function (data){
                    html+='<div id="RemarkList">'
                    $.each(data.activityRemark,function (i,e){

                        html+='<div class="remarkDiv" style="height: 60px; " id="'+e.id+'">'
                        html+='	<img title="zhangsan" src="stat/image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html+='		<div style="position: relative; top: -40px; left: 40px;" >'
                        html+='			<h5 id="e'+e.id+'">'+e.noteContent+'</h5>'  // \作为参数才会被转义,才会减少,故不作为参数,给H5设置个id读取其内容
                        html+='		<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+(e.editFlag=="0"?e.createTime:e.editTime)+' 由'+(e.editFlag=="0"?e.createBy:e.editBy)+'</small>'
                        html+='		<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display:none;">'

                        html+='			<a class="myHref" href="javascript:void(0);" onclick=editRemark(\''+e.id+'\')><span class="glyphicon glyphicon-edit" style="font-size: 20px; color:#a94442;"></span></a>'
                        html+='			&nbsp;&nbsp;&nbsp;&nbsp;'
                        html+='			<a class="myHref" href="javascript:void(0);" onclick=deleteRemark(\''+e.id+'\')><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:#a94442;"></span></a>'
                        html+='		</div>'
                        html+='	</div>'
                        html+='</div>'

                    })
                    html+='</div>'
                    $("#RemarkList").remove();
                    $("#activityPage").before(html);
                    $("#showTotal").html(data.total)
                    var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1; //? : js中做加法要转一下
                    $("#activityPage").bs_pagination({
                        currentPage: pageNum, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,
                        //该回调函数在点击分页组件时触发的,调用我们的pageList方法,参数不能改
                        onChangePage : function(event, data){
                            RPageList(data.currentPage , data.rowsPerPage);
                        }
                    });
                }
            })

	}
</script>

</head>
<body>
<h4>${uid}</h4>
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel1">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label" id="remarkContent">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="RemarkEditBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">
                                    <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>
                                </select>
                            </div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="${activity.name}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startDate" value="${activity.startDate}">
                            </div>
                            <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endDate" value="${activity.endDate}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="${activity.cost}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe" >${activity.description}</textarea>
								<input type="hidden" value="${activity.id}" id="edit-id">
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="editBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>2020-10-10 ~ 2020-10-20</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editActivity"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			<input type="hidden" value="${activity.id}" id="AId">
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="showRemark">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<%--<% List<ActivityRemark> list= (List<ActivityRemark>) request.getAttribute("remark");
		list.toArray(new ActivityRemark[list.size()]);
		int i=1;
		for(ActivityRemark e:list){
			%>
		<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="stat/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5><%=e.getNoteContent()%></h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"><%=e.getCreateTime()%> 由<%=e.getCreateBy()%></small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="hidden" value="<%=e.getId()%>" id="remarkid<%=i%>">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		<% i++;}%>--%>
		
		<!-- 备注2 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="stat/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
        <div id="activityPage"></div>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="remarkSaveBtn">保存</button>
				</p>
			</form>
		</div>
        <b id="showTotal"></b>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>