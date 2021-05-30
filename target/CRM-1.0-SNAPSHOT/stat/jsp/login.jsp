<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2021/4/22
  Time: 9:36
  To change this template use File | Settings | File Templates.
--%>
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
    <script type="text/javascript" src="stat/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="stat/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function (){
        $("#loginAct").focus();
        $("#submitBtn").on("click",function (){
            login();
        })
         $(window).keydown(function (e){
             if(e.keyCode===13) {
                 login();
             }
            })
            aok=false
            $("#loginAct").on("focus",function (){
                $("#msg").html("")
            })
            $("#loginPsw").on("focus",function (){
                if(!aok)
                    $("#msg").html("<p style='color: #ac2925'>账号格式异常</p>")
                else
                $("#msg").html("")
            })
            $("#loginAct").on("blur",function (){
                var reg=/^[A-Za-z#,.?][A-Za-z0-9]{5,}$/g
                 aok=reg.test($(this).val())
                if(!aok)
                    $("#msg").html("<p style='color: #ac2925'>账号格式异常</p>")
            })
            <% if(request.getSession().getAttribute("user")!=null) {%>
            window.top.location='${pageContext.request.contextPath}/stat2/jsp/index.jsp'
            <% }%>
            if(window.top!=window.self)
                window.top.location=window.self.location
        })
        //方法定义放在$(function)外边,不会出错
        login=function (){
            var reg=/^[A-Za-z#,.?][A-Za-z0-9]{5,}$/g
            var reg2=/[A-Za-z0-9#$?.,]+/g
            var username=$.trim($("#loginAct").val())
            var password=$.trim($("#loginPsw").val().trim())
               ok=false;
            if(username==null||username==''||password==null||password=='')
            {
                $("#msg").html("<p style='color: #ac2925'>用户名和密码不能为空</p>")
                return false;
            }

                user_ok=reg.test(username)
                psw_ok=reg2.test(password)

                if (user_ok&&psw_ok) {
                    ok = true;
                } else {
                    $("#msg").html("<p style='color: #ac2925'>用户名或密码格式不正确</p>")
                }
                if (ok == true) {
                    $.ajax({url:"${pageContext.request.contextPath}/user/login.do",
                    dataType:"json",
                    data:{"loginAct":username,"loginPsw":password},
                    type:"post",

                        success:function (data){
                        if("true"==data.success)
                            $("#login_form").submit();
                        else
                            $("#msg").html("<p style='color: #ac2925'> "+data.message+"</p>")
                        },
                        error:function (){
                            $("#msg").html("<p style='color: #ac2925'> 请求超时</p>")
                        }
                    })

                }
                ok = false;


        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="stat/image/IMG_0069.JPG" style="width: 115%; height: 15%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;硕哥</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="stat2/jsp/index.jsp" class="form-horizontal" role="form" id="login_form" method="post" >
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct" name="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPsw" name="loginPsw">
                </div>
                <div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

                    <span id="msg"></span>

                </div>
                <button id ="submitBtn"type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>