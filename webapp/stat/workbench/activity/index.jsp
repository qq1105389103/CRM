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

	$(function(){
		//绑定点击事件,打开模态窗口
		$("#addActivity").on("click",function (){
			$("#createActivityModal").modal("show")
		})


		$("#editActivity").on("click",function (){
			if($(".singleCheck:checked").length==1) {
				$("#editActivityModal").modal("show")
				//编辑部分的初始化

				$.ajax({
					url: "activity/displayById.do",
					data: {"id": $(".singleCheck:checked:first").val()},
					dataType: "json",
					success: function (data) {
						$.each(data, function (i, e) {
							$("#edit-owner").val(e.owner)  //此处所有者不默认选自己,应该是原本的,而且不用返回名字,返回id即可
							$("#edit-name").val(e.name)
							$("#edit-startDate").val(e.startDate)
							$("#edit-endDate").val(e.endDate)
							$("#edit-describe").val(e.description)
							$("#edit-cost").val(e.cost)

						})
					}
				})
			}
			else {
				$("#activityEditForm")[0].reset()
                alert("请选择\"一条\"需要修改的记录")
			}
		})

		//创建,修改模态窗口的用户列表初始化
		$.ajax({url:"user/get.do",
			data:{},
			dataType:"json",
			type:"get",
			success:function (data){
			$("#create-owner").empty()
				var html="";
				$.each(data,function (i,e){
					var name =e.name
					$("#create-owner").append("<option value='"+e.id+"'>"+e.name+"</option>")
					html+="<option value='"+e.id+"'>"+e.name+"</option>"
				})
				$("#edit-owner").html(html);

			}
		})
		$("#create-owner").val("${user.id}")
		$(".time").datetimepicker({
			minView:"month",
			language:"zh-CN",
			format:"yyyy-mm-dd",
			autoclose:true,
			todayBtn:true,
			pickerPosition:"bottom-left"
		});



		//提交创建表单
		$("#saveBtn").on("click",function (){
			if(confirm("确认添加")){
			if($.trim($("#create-name").val()).length>=3&&($("#create-endDate").val()>=$("#create-startDate").val()))
			{
				$.ajax({
					url:"activity/save.do",
					data:{
						"owner":$.trim($("#create-owner").val()),
						"name":$.trim($("#create-name").val()),
						"startDate":$.trim($("#create-startDate").val()),
						"endDate":$.trim($("#create-endDate").val()),
						"cost":$.trim($("#create-cost").val()),
						"description":$.trim($("#create-description").val())
					},
					type: "post",
					dataType: "json",//返回一个true或者false
					success:function (data){
						if(data.success) {
							alert("添加成功")
							$("#activityAddForm")[0].reset();
							$("#createActivityModal").modal("hide");
							pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'))

						}
						else
							alert("添加失败")

					}
				})}
			else alert("名称不小于3位,开始日期大于等于结束日期")

			}
		})
		//修改模态窗口的编辑与提交
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
					"id": $.trim($(".singleCheck:checked").val())
				},
				dataType: "json",
				success: function (data) {
					if ("true" == data.success) {
						alert("更新成功")
						$("#editActivityModal").modal("hide")
						pageList($("#activityPage").bs_pagination('getOption','currentPage'), $("#activityPage").bs_pagination('getOption','rowsPerPage'))
					}
				}
			})
		}
		})
		//查询
		$("#searchBtn").on("click",function (){
			$("#hide-name").val($.trim($("#search-name").val()))
			$("#hide-owner").val($.trim($("#search-owner").val()))
			$("#hide-startDate").val($.trim($("#search-startDate").val()))
			$("#hide-endDate").val($.trim($("#search-endDate").val()))
			pageList(1,5)
		})
		pageList(1,3)
		//全选框选中       //其他单选框要在生成后绑定事件,动态生成的元素不特殊处理不能页面加载完成时绑定事件 ,用on绑定事件特殊处理
		$("#allcheck").on("click",function (){


			$(".singleCheck").prop("checked",this.checked)  //this指第一个数组中第一个DOM元素
		})
         //单选框影响全选框,动态绑定,特殊处理 ,需要找到动态生成元素的有效外层静态元素,如tbody绑定
		$("#displayActivity").on("click",$(".singleCheck"),function (){

			$("#allcheck")[0].checked=$(".singleCheck").length==$(".singleCheck:checked").length

	})
		 //删除
		$("#delActivity").on("click",function (){
			var $ckb=$(".singleCheck:checked")
			if($ckb.length==0){
				alert("请勾选要删除的市场活动")
			}
			else{
				var param=""
				$ckb.each(function (i,e) {
					param += "id=" + e.value;
					if (i < $ckb.length - 1)
						param += "&"

				})
			$.ajax({
				url:"activity/delete.do",
				data:param,
				dataType:"json",
				success:function (data){
					alert(data.msg)
					pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'))
				}
			})
			}
		})
	})
	pageList=function (pageNum,pageSize){
		$("#search-name").val($.trim($("#hide-name").val()))
		$("#search-owner").val($.trim($("#hide-owner").val()))
		$("#search-startDate").val($.trim($("#hide-startDate").val()))
		$("#search-endDate").val($.trim($("#hide-endDate").val()))

		$.ajax({
			url:"activity/select.do",
			data:{"pageNum":pageNum,
				"pageSize":pageSize,
			     "name":$.trim($("#search-name").val()),
			     "owner":$.trim($("#search-owner").val()),
			     "startDate":$.trim($("#search-startDate").val()),
			     "endDate":$.trim($("#search-endDate").val())},
			dataType:"json",
			success:function (data){
				if(!data.error){
					$("#totalDisplay").html(data.total)
					$("#displayActivity").empty()
					html=""
					$.each(data.activity,function (i,e){
						html+="<tr class='active'><td><input class='singleCheck' type='checkbox' name='id' value='"+e.id+"'></td>"
						html+="<td><a href='activity/displayDetail.do?id="+e.id+"'>"+e.name+"</a></td>"
						html+="<td>"+e.owner+"</td>"
						html+="<td>"+e.startDate+"</td>"
						html+="<td>"+e.endDate+"</td></tr>"

					})
					$("#displayActivity").html(html);


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
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}
				else
					$("#displayActivity").html("异常")

			}
		})
	}
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="activityAddForm"role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label ">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" maxlength="0">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label ">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" maxlength="0">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary"  id="saveBtn" >保存</button>
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
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id='activityEditForm' role="form">
					
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
                                <input type="text" class="form-control" id="edit-name" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label time">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" value="2020-10-10">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label time">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
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
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addActivity"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <%--<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>--%>
				  <button type="button" class="btn btn-default"  id="editActivity"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delActivity"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="allcheck"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="displayActivity">
						<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='<%=basePath%>stat/workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalDisplay">50</b>条记录</button>
				</div>
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
<input type="hidden" id="hide-name">
	<input type="hidden" id="hide-owner">
	<input type="hidden" id="hide-startDate">
	<input type="hidden" id="hide-endDate">
</body>
</html>