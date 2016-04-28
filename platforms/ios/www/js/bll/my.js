$.afui.ready(function () {

    //登录页面
    $("#login").on("panelload",function(e){
        $("#userName").val("");
        $("#userPassWord").val("");
        //登录功能
        $("#doLogin").off("tap").on("tap",function(){
            //$("#flycoAccountBind").hide();
            var userName = $("#userName").val();
            var passWord = $("#userPassWord").val();
            hlp.log("before login call...");
            hlp.log(hlp.format("UserName:{0},Password:{1}",[userName,passWord]));
            svc.userAuthentication(userName,passWord,function(r){
                hlp.log("inside login call...");
                if(r.status=="SUCCESS"){
                    loj.setOnline(r,"flyco");
                    hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
                    hlp.log(hlp.format("LoginType:{0}",[loj.LoginType]));
					
                    if (hlp.lastPage != "") {
                        var t = hlp.lastPage;
                        hlp.lastPage = "";
                        $.afui.loadContent(t);
                    }
                    else
                        $.afui.goBack();
						
                }else{
                    hlp.myalert(r.message);
                }
            });
        });

        //点击注册按钮跳转到注册发送验证码页面
        $("#login .doRegister").off("tap").on("tap",function(){
            if(count<1||count==60){
                //验证码倒计时结束
                $.afui.loadContent("#regist");
            }else{
                //验证码倒计时未结束
                hlp.myalert("验证码60秒发送一次，请稍后重试！");
            };
        });

        //点击忘记密码
        $("#todoForgetPassword").off("tap").on("tap",function(){
            if(count<1||count==60){
                //验证码倒计时结束
                $.afui.loadContent("#forgetPassword")
            }else{
                //验证码倒计时未结束
                hlp.myalert("验证码60秒发送一次，请稍后重试！");
            }
        });

        //京东登录
        $("#jd_Login").off("tap").on("tap",function(){
            hlp.log("before jdLogin function...");
            jdLogin(function(result){
                hlp.log("inside jdLogin function...");
                hlp.log(hlp.format("jdLoginResult:{0}",[result]));
                var uid = result.uid;
                var accessToken = result.accesstoken;
                var nickName = result.nickname;
                var loginType = "jd";
                hlp.log("before thirdPartyLoginIn call...");
                svc.thirdPartyLoginIn(loginType,uid,accessToken,nickName,function(r){
                    hlp.log("inside thirdPartyLoginIn call...");
                    if(r.status=="SUCCESS"){
                        loj.setOnline(r,loginType);
                        hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
                        hlp.log(hlp.format("LoginType:{0}",[loj.LoginType]));
                        $.afui.loadContent("#my");
                    }else{
                        hlp.log(r.message);
                    }
                });
                /*hlp.myalert("uid:  " +uid  +"accessToken:   "+ accessToken +"nickName:  "+nickName);*/
            },function(error){
                hlp.myalert(error);
            });
        });

        //微信登录
        $("#wx_Login").off("tap").on("tap",function(){
            hlp.log("before wxLogin function...");
            wxLogin(function(result){
                hlp.log("inside wxLogin function...");
                hlp.log(hlp.format("wxLoginResult:{0}",[result]));
                var uid = result.uid;
                var accessToken = result.accesstoken;
                var nickName = result.nickname;
                var loginType = "wechat";
                hlp.log("before thirdPartyLoginIn call...");
                svc.thirdPartyLoginIn(loginType,uid,accessToken,nickName,function(r){
                    hlp.log("inside thirdPartyLoginIn call...");
                    if(r.status=="SUCCESS"){
                        loj.setOnline(r,loginType);
                        hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
                        hlp.log(hlp.format("LoginType:{0}",[loj.LoginType]));
                        $.afui.loadContent("#my");
                    }else{
                        hlp.log(r.message);
                    }
                });
                /*hlp.myalert("uid:  " +uid  +"accessToken:   "+ accessToken +"nickName:  "+nickName);*/
            },function(error){
                hlp.myalert(error);
            });
        });

        //QQ登录
        $("#qq_Login").off("tap").on("tap",function(){
            //$("#thirdAccountBind").hide();
            hlp.log("before qqLogin function...");
            qqLogin(function(result){
                hlp.log("inside qqLogin function...");
                hlp.log(hlp.format("qqLoginResult:{0}",[result]));
                var uid = result.uid;
                var accessToken = result.accesstoken;
                var nickName = result.nickname;
                var loginType = "qq";
                hlp.log("before thirdPartyLoginIn call...");
                svc.thirdPartyLoginIn(loginType,uid,accessToken,nickName,function(r){
                    hlp.log("inside thirdPartyLoginIn call...");
                    if(r.status=="SUCCESS"){
                        loj.setOnline(r,loginType);
                        hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
                        hlp.log(hlp.format("LoginType:{0}",[loj.LoginType]));
                        $.afui.loadContent("#my");
                    }else{
                        hlp.log(r.message);
                    }
                });
                /*hlp.myalert("uid:  " +uid  +"accessToken:   "+ accessToken +"nickName:  "+nickName);*/
            },function(error){
                hlp.myalert(error);
            });
        });
    });

    //注册发送验证码页面
    $("#regist").on("panelload", function(e) {
        // 清空输入框的内容 开发缺陷 #346
        $("#userAccount").val("");
        $("#vericode").val("");
        $("#oldMobile").val("");
        $(".registVeri #userPassWord").val("");

        //用户验证
        $("#sendCode").off("tap").on("tap", function() {
            if (SendCodeEnableFg) {
                var mobile = $("#userAccount").val();
                if(mobile.trim().length == 0){
                    hlp.myalert("请输入手机号！");
                }else{
                    re = /^1\d{10}$/;
                    if(!re.test(mobile)){
                        hlp.myalert("请检查手机号是否正确！");
                    }else{
                        hlp.log("before userCheck call...");
                        hlp.log(hlp.format("Mobile:{0}", [mobile]));
                        $("#oldMobile").val(mobile);
                        $("#sendCode").text("发送中");
                        $("#sendCode").addClass("disabled");
                        svc.userCheck(mobile, function(r) {
                            registerGetNumber(mobile);
                            hlp.log("inside userCheck call...");
                            if (r.status == "SUCCESS") {
                                hlp.log("userCheck request success...");
                                // hlp.myalert(r.message);
                            } else {
                                count=60;
                                hlp.myalert(r.message);
                                clearRegTm();
                            }
                        });
                    }
                };
            }
        });

        //验证码验证和密码检验注册
        $("#toRegistPassword").off("tap").on("tap", function() {
            var mobile = $("#userAccount").val();
            var vericode = $("#vericode").val();
            var oldMobile = $("#oldMobile").val();
            var passWord = $(".registVeri #userPassWord").val();
            var userName = $("#userAccount").val();
            if (oldMobile.trim().length > 0 && mobile != oldMobile) {
                hlp.myalert("您输入的手机号无效");
            } else {
                hlp.log("before identifyCodeCheck call...");
                svc.identifyCodeCheck(mobile, vericode, function (r) {
                    hlp.log("inside identifyCodeCheck call...");
                    hlp.log(hlp.format("Mobile:{0},IdentifyCode:{1}", [mobile, vericode]));
                    if (r.status == "SUCCESS") {
                        //hlp.log("identifyCodeCheck request success...");
                        //$.afui.loadContent("#registPassword");
                        var Regx = /^[A-Za-z0-9]*$/;
                        if (Regx.test(passWord)) {
                            if (passWord.trim().length >= 6 && passWord.trim().length <= 20) {
                                hlp.log("before userRegist call ....");
                                hlp.log(hlp.format("userAccount:{0},passWord:{1}", [mobile, passWord]));
                                svc.userRegister(userName, mobile, vericode, passWord, function (r) {
                                    hlp.log("inside userRegister call....");
                                    if (r.status == "SUCCESS") {
                                        loj.setOnline(r);
                                        hlp.log(hlp.format("Credential:{0}", [loj.Credential]));
                                        $("#oldMobile").val("");
                                        $.afui.loadContent("#login");
                                    } else {
                                        hlp.myalert(r.message);
                                    }
                                });
                            } else {
                                hlp.myalert("密码长度不能超过20位");
                            }
                        } else {
                            hlp.myalert("密码只能包含数字和字母！");
                        }
                    } else {
                        hlp.myalert(r.message);
                    }
                });
            }
            //if (Regx.test(passWord)){
            //    if(passWord.trim().length>=6&&passWord.trim().length<=12){
            //        hlp.log("before userRegist call ....");
            //        hlp.log(hlp.format("userAccount:{0},passWord:{1}",[mobile,passWord]));
            //        svc.userRegister(userName,mobile,vericode,passWord,function(r){
            //            hlp.log("inside userRegister call....");
            //            if(r.status == "SUCCESS"){
            //                loj.setOnline(r);
            //                hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
            //                $.afui.loadContent("#login");
            //            }else{
            //                hlp.myalert(r.message);
            //            }
            //        });
            //    }else{
            //        hlp.myalert("密码长度必须为6至12位！");
            //    }
            //}else{
            //    hlp.myalert("密码只能包含数字和字母！");
            //}
        });
    });

    ////注册页面
    //$("#registPassword").on("panelload",function(e){
    //    $.afui.setBackButtonVisibility(false);
    //    hlp.specialGoBack="login";
    //    $("#passWord").val("");
    //    $("#passwordconfirm").val("");
    //    //用户注册
    //    $("#userRegist").off("tap").on("tap",function(){
    //        var mobile = $("#userAccount").val();
    //        var userName = $("#userAccount").val();
    //        var passWord = $("#passWord").val();
    //        var passwordconfirm = $("#passwordconfirm").val();
    //        var vericode = $("#vericode").val();
    //        if(passWord==passwordconfirm){
    //            var Regx = /^[A-Za-z0-9]*$/;
    //            if (Regx.test(passWord)){
    //                if(passWord.trim().length>=6&&passWord.trim().length<=12){
    //                    hlp.log("before userRegist call ....");
    //                    hlp.log(hlp.format("userAccount:{0},passWord:{1}",[mobile,passWord]));
    //                    svc.userRegister(userName,mobile,vericode,passWord,function(r){
    //                        hlp.log("inside userRegister call....");
    //                        if(r.status == "SUCCESS"){
    //                            loj.setOnline(r);
    //                            hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
    //                            $.afui.loadContent("#my");
    //                        }else{
    //                            hlp.myalert(r.message);
    //                        }
    //                    });
    //                }else{
    //                    hlp.myalert("密码长度必须为6至12位！");
    //                }
    //            }else{
    //                hlp.myalert("密码只能包含数字和字母！");
    //            }
    //        }else{
    //            hlp.myalert("两次输入的密码不一致。");
    //        }
    //    });
    //    var cancleBtnFlg=true;
    //    $("#userRegistCancel").off("tap").on("tap",function(){
    //        if(cancleBtnFlg==true){
    //            $.afui.popup({
    //                title: "提示",
    //                message: "是否放弃本次操作?",
    //                cancelText: "取&nbsp;&nbsp;消",
    //                doneText: "确&nbsp;&nbsp;定",
    //                cancelCallback: function () {
    //                    hlp.log("do regist");
    //                    cancleBtnFlg=true;
    //                    return;
    //                },
    //                doneCallback: function () {
    //                    hlp.log("Give up regist");
    //                    $.afui.loadContent("#login");
    //                }
    //            });
    //            cancleBtnFlg=false;
    //        }
    //    });
    //});
    //$("#registPassword").on("panelunload", function (e) {
    //    $.afui.setBackButtonVisibility(true);
    //    hlp.specialGoBack="";
    //});

    //用户信息页面
    $("#my").on("panelload",function(e){
        var tokenId = loj.Credential;
        hlp.log("before getuserinfo call ...xxx....");
        hlp.log(hlp.format("tokenId:{0}",[tokenId]));
        $(".messageCount span").hide();

        if(tokenId){
            //获取用户信息
            svc.getuserinfo(tokenId,function(r){
                hlp.log("inside getuserinfo call...");
                if(r.status == "SUCCESS"){
                    var result = r.result.OTHRE_USER_TO_THIS;
                    hlp.log("getuserinfo request success..yyy.");
                    console.log("before set:"+JSON.stringify(loj));
                    loj.setEntity(r.result);
                    loj.setRealName(r.result.REAL_NAME);
                    console.log("after set:" + JSON.stringify(loj));
                    //hlp.bindtpl(r.result,"#Info","tpl_Info");
                    //hlp.bindtpl(r.result.MOBILE,"#currentAccount","tpl_currentAccount");
                    var imgSrc = r.result.IMAGE == "" ? "images/icons-png/nouser.png" : userImgDomain+r.result.IMAGE;
					$("#myUserImage").attr("src", imgSrc);
                    $("#myUserName")[0].innerHTML = "<name>"+ r.result.REAL_NAME + "</name><br><span class='isLogin'>已登录</span>";
                    $("#myUserName").css("line-height","68px");
                    $("#currentAccount").text(r.result.USER_NAME);
                    $("#currentAccountImg").attr("src", "images/icons-png/" + loj.LoginType + ".png");
                    hlp.log("R:" + JSON.stringify(result));

                    //关联按钮初始化
                    $("#myInfo #qq a").text("关联");
                    $("#myInfo #weChat a").text("关联");
                    $("#myInfo #jd a").text("关联");
                    $("#myInfo #flycoAccountBind .bigli a").text("关联");

                    //判断第三方账号绑定状态
                    if(result){
                        $.each(result, function (i) {
                            var bindType = result[i];
                            switch (bindType) {
                                case "qq":
                                    $("#myInfo #qq a").text("删除");
                                    $("#myInfo #flycoAccountBind .bigli a").text("删除");
                                    //$("#qqAccountBind .addStatus").removeClass("addStatus").addClass("minStatus");
                                    break;
                                case "wechat":
                                    $("#myInfo #weChat a").text("删除");
                                    $("#myInfo #flycoAccountBind .bigli a").text("删除");
                                    //$("#wxAccountBind .addStatus").removeClass("addStatus").addClass("minStatus");
                                    break;
                                case "jd":
                                    $("#myInfo #jd a").text("删除");
                                    $("#myInfo #flycoAccountBind .bigli a").text("删除");
                                    //$("#jdAccountBind .addStatus").removeClass("addStatus").addClass("minStatus");
                                    break;
                                default:
                                    break;
                            }
                        });
                    }

                    //判断飞科账号绑定状态
                    if(r.result.BINDED_FLYCO_ACCOUNT){
                        $("#myInfo #flycoAccountBind .bigli a").text("删除");
                    }

                    // 未读消息数量
                    svc.getUserMessage(tokenId, function(r) {
                        if(r.status == "SUCCESS"){
                            var result = r.result;
                            var wd_count = 0;
                            $.each(r.result, function(i) {
                                if (r.result[i].messageStatus == 0) {
                                    wd_count = wd_count + 1;
                                }
                            });
                            if (wd_count == 0) {
                                $(".messageCount span").hide();
                            } else {
                                $(".messageCount span").show();
                                $(".messageCount span")[0].innerHTML = wd_count;
                            }
                        }else{
                           hlp.log(r.message);
                        }
                        $("#ToUserMess").off("tap").on("tap",function(){
                            if(r.status == "SUCCESS"){
                                $.afui.loadContent("#userMessage");
                            }else{
                                hlp.myalert("您当前还没有消息！");
                            }
                        });
                    });
                } else {
                    $("#myUserImage").attr("src","images/icons-png/nouser.png");
                    $(".bigli").off("tap").on("tap",function(){
                        hlp.lastPage = "#my";
                        $.afui.loadContent("#login");
                    });
                }
            });
            $(".bigli").off("tap").on("tap",function(){
                $.afui.loadContent("#myInfo");
            });
        }else{
            $("#myUserImage").attr("src","images/icons-png/nouser.png");
            $(".bigli").off("tap").on("tap",function(){
                hlp.lastPage = "#my";
                $.afui.loadContent("#login");
            });
        }
    });

    //意见反馈页面
    $("#feedback").on("panelload",function(e){
        $("#textarea").val("");
        $("#textinput").val("");
        var tokenId = loj.Credential;
        hlp.log("before submitFeedback call...");

        //提交意见反馈
        $("#feedback .submitButton").off("tap").on("tap",function(){
            var flg = true;
            var feedbackContent = $("#textarea").val();
            var emailContent = $("#textinput").val();

            if(feedbackContent.trim().length == 0){
                hlp.myalert("请输入意见内容");
                flg = false;
            } else if (emailContent.trim().length != 0){
                var Re = /\w@\w*\.\w/;
                if (!Re.test(emailContent)){
                    hlp.myalert("邮箱格式不正确");
                    flg = false;
                }
            }

            if(flg) {
                updateFeedBack(tokenId, feedbackContent, emailContent);
            }
        });

        // 意见反馈更新
        var updateFeedBack = function(tokenId,feedbackContent,emailContent) {
            svc.submitFeedback(tokenId,feedbackContent,emailContent,function(r){
                hlp.log("inside submitFeedback call...");
                if(r.status == "SUCCESS"){
                    hlp.myalert(r.message);
                    $("#feedbackContent").val("");
                    $("#emailContent").val("");
                    $.afui.loadContent("#my");
                }else{
                    hlp.myalert(r.message);
                }
            });
        }
    });

    //系统更新
    $("#update").on("panelload", function(e) {
        var currentVersion=device.app_version;
    	//var currentVersion="0.0.1";
        $("#appVerUpdate").val(currentVersion);
        $("#update #version")[0].innerHTML = "飞科智能平台" + currentVersion;
        hlp.log("get current version is: " + currentVersion);
        //版本比较
        $.afui.blockUIwithMask('正在检查更新');
        svc.getVersionInfo(currentVersion, "jiadian_android", function(r){
            hlp.log("inside current version compare call...");
            if (r.status == "NEW" ) {
                $(".downloadVer").show();
                $(".verInfo").hide();
                $(".downloadVer").off("tap").on("tap",function(){
                    window.open(r.newVersion.downloadUrl);
                });
            } else if (r.status == "SUCCESS") {
                $(".downloadVer").hide();
                $(".verInfo").show();
            } else {
                $(".downloadVer").hide();
                $(".verInfo").show();
            }
            $.afui.unBlockUIwithMask();
        });
    });

    //关于我们
    $("#aboutUs").on("panelload",function(e){
        var currentVersion=device.app_version;
    	//var currentVersion="0.0.1";
        $("#aboutUs #appVerAboutUs").val(currentVersion);
        $("#version")[0].innerHTML = "飞科智能平台" + currentVersion;
    });

    //验证手机号输入是否正确
    function checkSubmitMobil(mobile) {
        var reg = /^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9]|17[0-9])[0-9]{8}$/;
        if (!reg.test(mobile)) {
            showToast("手机号码格式不正确！");
            $("#mobile").focus();
            return false;
        }
        return true;
    }

    //验证邮箱输入是否正确
    function checkSubmitEmail(email) {
        var reg = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
        if (!reg.test(email)) {
            showToast("邮箱格式不正确");
            $("#mobile").focus();
            return false;
        }
        return true;
    }

    //重置密码发送验证码
    $("#forgetPassword").on("panelload",function(e){
        $("#userMobile").val("");
        $("#forgetPassword .button.blue").off("tap").on("tap",function(){
            if ($("#userMobile").val()) {
                if (!isNaN($("#userMobile").val())) {
                    if (checkSubmitMobil($("#userMobile").val())) {
                        $.afui.loadContent("#phoneVer");
                    }
                } else if($("#userMobile").val().indexOf("@") >= 0) {
                    if (checkSubmitEmail($("#userMobile").val())) {
                        $.afui.loadContent("#mailVer");
                    }
                }else{
                    showToast("请输入手机号或邮箱地址！");
                }
            }else{
                showToast("请输入手机号或邮箱地址！");
            }
        });
    });

    $("#phoneVer").on("panelload",function(e){
        $("#forgetVericode").val("");
        $("#forgetSendCode").off("tap").on("tap",function(){
            if(SendCodeEnableFg){
                var userMobile = $("#userMobile").val();
                hlp.log("before forgerPassSend call...");
                $("#forgetSendCode").text("发送中");
                $("#forgetSendCode").addClass("disabled");
                svc.forgerPassSend(userMobile,function(r){
                    forgetPasswordGetNumber(userMobile);
                    hlp.log("inside forgerPassSend call...");
                    if(r.status == "SUCCESS"){
                        hlp.log("userCheck request success...");
                    }else{
                        count=60;
                        hlp.myalert(r.message);
						clearFgtTm();
                    }
                });
            }
        });
        $("#toResetPassword").off("tap").on("tap",function(){
            var userMobile = $("#userMobile").val();
            var forgetVericode = $("#forgetVericode").val();
            hlp.log("before identifyCodeCheck call...");
            svc.identifyCodeCheck(userMobile,forgetVericode,function(r){
                hlp.log("inside identifyCodeCheck call...");
                hlp.log(hlp.format("Mobile:{0},IdentifyCode:{1}",[userMobile,forgetVericode]));
                if(r.status == "SUCCESS"){
                    hlp.log("identifyCodeCheck request success...");
                    $.afui.loadContent("#resetPassword");
                }else{
                    hlp.myalert(r.message);
                }
            });
        });
    });

    $("#mailVer").on("panelload",function(e){
        $("#mailVeriCode").val("");
        var code;
        svc.getRandomcode(function(r){
            if(r.status == "SUCCESS"){
                imgSrc="data:image/png;base64,"+r.picture;
                $("#verCodePic").attr("src",imgSrc);
                code= (r.randomCode).toLocaleLowerCase();
            }else{
                showToast(r.message);
            }
        });
        $("#verCodePic").off("tap").on("tap",function(){
            $("#mailVeriCode").val("");
            svc.getRandomcode(function(r){
                if(r.status == "SUCCESS"){
                    imgSrc="data:image/png;base64,"+r.picture;
                    $("#verCodePic").attr("src",imgSrc);
                    code= (r.randomCode).toLocaleLowerCase();
                }else{
                    showToast(r.message);
                }
            });
        });
        $("#checkMail").off("tap").on("tap",function(){
            if ($("#mailVeriCode").val() == "") {
                showToast("请输入验证码！");
            } else if ($("#mailVeriCode").val().toLocaleLowerCase() == code){
                svc.resetPwdByEmail($("#userMobile").val(),function(r1){
                    if(r1.status == "SUCCESS"){
                        showToast(r1.message);
                        $.afui.loadContent("#login");
                    }else{
                        showToast(r1.message);
                    }
                });
            }else{
                showToast("验证码不正确！");
            }
        });
    });

    //重置密码
    $("#resetPassword").on("panelload",function(e){
        $.afui.setBackButtonVisibility(false);
        hlp.specialGoBack="login";
        $("#newPassWord").val("");
        $("#newPassWordConfirm").val("");
        $("#passwordReset").off("tap").on("tap",function(){
            var userMobile = $("#userMobile").val();
            var resetPassword = $("#newPassWord").val();
            var resetPasswordConfirm = $("#newPassWordConfirm").val();
            if(resetPassword === resetPasswordConfirm){
                var Regx = /^[A-Za-z0-9]*$/;
                if (Regx.test(resetPassword)){
                    if(resetPassword.trim().length>=6&&resetPassword.trim().length<=20){
                        hlp.log("before restPassword call...");
                        svc.resetPassword(userMobile,resetPassword,function(r){
                            if(r.status == "SUCCESS"){
                                hlp.log("inside restPassword call...");
                                hlp.lastPage = "#deviceList";
                                $.afui.loadContent("#login");
                            }else{
                                hlp.myalert(r.message);
                            }
                        });
                    }else{
                        hlp.myalert("密码长度不能超过20位");
                    }
                }else{
                    hlp.myalert("密码只能包含数字和字母！");
                }
            }else{
                hlp.myalert("两次输入的密码不一致。");
            }
        });
        //$("#passwordResetCancel").off("tap").on("tap",function(){
        //    $.afui.popup({
        //        title: "提示",
        //        message: "是否放弃本次重置操作?",
        //        cancelText: "取&nbsp;&nbsp;消",
        //        doneText: "确&nbsp;&nbsp;定",
        //        cancelCallback: function () {
        //            hlp.log("do reset password");
        //            return;
        //        },
        //        doneCallback: function () {
        //            hlp.log("Give up reset password");
        //            $.afui.loadContent("#login");
        //        }
        //    });
        //});
    });
    $("#resetPassword").on("panelunload", function (e) {
        $.afui.setBackButtonVisibility(true);
        hlp.specialGoBack="";
    });

    //用户信息页面
    $("#myInfo").on("panelload",function(e){
        var tokenId = loj.Credential;
        hlp.log("before getuserinfo call...");
        svc.getuserinfo(tokenId,function(r){
            hlp.log("inside getuserinfo call...");
            if(r.status == "SUCCESS"){
                hlp.bindtpl(r.result,"#userInfo","tpl_userInfo");

                //显示或隐藏飞科账号绑定和第三方账号绑定模块
                if(loj.LoginType == "flyco"){
                    $("#flycoAccountBind").css("display","none");
                    $("#thirdAccountBind").css("display","block");
                }else{
                    $("#thirdAccountBind").css("display","none");
                    $("#flycoAccountBind").css("display","block");
                }

				$("#showicon").attr("src",userImgDomain + r.result.IMAGE);
                $("#myInfoName").off("tap").on("tap",function(){
                    $("#editUserName").val(loj.RealName);
                    $.afui.loadContent("#editName");
                });

                //修改用户名称
                $("#myInfoUpdate").off("tap").on("tap",function(){
                    var tokenId = loj.Credential;
                    var username = $("#editUserName").val();
                    if (username.length > 50) {
                        hlp.myalert("您输入的长度过长");
                        $("#editUserName").val(loj.RealName);
                    } else if(username.trim().length == 0) {
                        hlp.myalert("用户名不能为空");
                        $("#editUserName").val(loj.RealName);
                    } else {
                        var imageSrc = "";
                        hlp.log("before saveUpdate call...");
                        hlp.log(hlp.format("tokenId:{0},username:{1}",[tokenId,username]));
                        svc.updateUserInfo(tokenId,username,imageSrc,function(r){
                            if(r.status == "SUCCESS"){
                                $("#myInfoName").text(username);
                                loj.setRealName(username);
                                hlp.log("inside saveUpdate call...");
                                $.afui.loadContent("#myInfo");
                            }else{
                                hlp.myalert(r.message);
                            }
                        });
                    }
                });

                //用户退出登录
                $("#doLogout").off("tap").on("tap",function(){
                    hlp.log("before doLogout call...");
                    var tokenId = loj.Credential;
                    svc.userLoginOut(tokenId,function(r){
                        hlp.log("inside doLoginOut call...");
                        if(r.status == "SUCCESS"){
                            $("#myUserImage").attr("src","images/icons-png/nouser.png");
                            $("#myUserName")[0].innerHTML = "登录/注册";
                            $("#myUserName").css("line-height","90px");
                            loj.setOffline();
                            hlp.log("doLogout success , after setOffline... ");
                            $(".messageCount span").hide();
                            $.afui.loadContent("#deviceList");
                            $("#thirdAccountBind").show();
                            $("#flycoAccountBind").show();
                        }else{
                            hlp.myalert(r.message);
                        }
                    });
                });

                //飞科账号绑定
                $(".myInfo .bigli").eq(1).find("a").off("tap").on("tap",function(event){
                    var tokenId = loj.Credential;
                    if($(".myInfo .bigli").eq(1).find("a").text() == "关联"){
                        $.afui.loadContent("#flycoAccountAuth");
                    }else{
                        hlp.log("before accountUnbind call function...");
                        svc.accountUnbind(tokenId,function(r){
                            hlp.log("inside accountUnbind call function...");
                            if(r.status == "SUCCESS"){
                                hlp.log("accountUnbind request success...");
                                $(".myInfo .bigli").eq(1).find("a").text("关联");
                                //$("#fkAccountBind .minStatus").removeClass("minStatus").addClass("addStatus");
                            }else{
                                hlp.myalert(r.message);
                            }
                        });
                    }
                    event.stopPropagation();
                });

                //飞科账户授权页面
                $("#flycoAccountAuth").on("panelload",function(e){
                    var tokenId = loj.Credential;
                    $("#doAuth").off("tap").on("tap",function(){
                        var authUserName = $("#authUserName").val();
                        var authUserPassWord = $("#authUserPassWord").val();
                        hlp.log("before thirdUserBindFlyco call function...");
                        svc.thirdUserBindFlyco(tokenId,authUserName,authUserPassWord,function(r){
                            hlp.log("inside thirdUserBindFlyco call function...");
                            if(r.status == "SUCCESS"){
                                hlp.log("thirdUserBindFlyco request function...");
                                $(".myInfo .bigli").eq(1).find("a").text("删除");
                                $.afui.loadContent("#myInfo");
                            }else{
                                hlp.myalert(r.message);
                            }
                        });
                    });
                });

                //第三方账号绑定
                $("#thirdAccountBind li").off("tap").on("tap",function(){
                    switch ($(this).attr("id")) {
                        case  "qq":
                            qqAccountBind();
                            break;
                        case "weChat":
                            weChatAccountBind();
                            break;
                        case "weBo":
                            break;
                        case "jd":
                            jdAccountBind();
                            break;
                        default :
                            break;
                    }
                });
            }else{
                hlp.myalert(r.message);
            }
        });
    });

    //修改用户名称页面
    $("#editName").on("panelload",function(e){
        $(".saveButton").show();
        //修改用户名称
        /*$("#myInfoUpdate").on("tap",function(){
         var tokenId = loj.Credential;
         var username = $("#editUserName").val();
         var imageSrc = "";
         hlp.log("before saveUpdate call...");
         hlp.log(hlp.format("tokenId:{0},username:{1}",[tokenId,username]));
         svc.updateUserInfo(tokenId,username,imageSrc,function(r){
         if(r.status == "SUCCESS"){
         hlp.log("inside saveUpdate call...");
         $.afui.loadContent("#myInfo");
         }else{
         hlp.myalert(r.message);
         }
         });
         });*/
    });
    $("#editName").on("panelunload",function(e){
        $(".saveButton").hide();
    });

    $("#editAvatar").on("panelload",function(e){
        $(".saveButton").show();
    });
    $("#editAvatar").on("panelunload",function(e){
        $(".saveButton").hide();
    });

    //我的消息页面
    $("#userMessage").on("panelload", function () {
        //$(".selectCircle").hide();
        $(".bianji").show().off("tap").on("tap", function () {
            $(".unreadMessage").toggle();
            $("#userMessage label").toggleClass("selectCircle");
            $(".messageFooter").toggle();
        });
        $(".usermessage li").hide();
        /*$(".selectCircle").off("tap").on("tap", function () {
            //this.toggleClass("checked");
        });*/
        var tokenId = loj.Credential;
        hlp.log("before getUserMessage call...");
        svc.getUserMessage(tokenId, function (r) {
            hlp.log("inside getUserMessage call...");
            if (r.status == "SUCCESS") {
                $(".usermessage li").show();
                var result = r.result;
                $.each(result, function (i) {
                    if (result)
                    //var settingType = Number(result[i].SETTINGTYPE);
                    //消息时间，格式为"2015-07-01 11:31:03.0"
                    var inputDate =result[i].messageReceiveTime;
                    //消息详细时间
                    var dtlDate="";
                    //result[i]["messageReceiveDtlTime"]=inputDate;
                    //var a=result[i].messageReceiveDtlTime;
                    //2015-07-01 11:31:03.0
                    //月/日 上午/下午 十二小时制时间点
                    //当前时间
                    var now = new Date();
                    var month = now.getMonth() + 1;
                    var day=now.getDate();
                    if(month<10){
                        month="0"+month;
                    };
                    if(day<10){
                        day="0"+day;
                    };
                    var n_yy=month + "/" + day;

                    //消息时间inputDateList[0]:年月日；inputDateList[1]：时间
                    var inputDateList =inputDate.split(" ");
                    //月日
                    var yy = inputDateList[0].substring(5,10);
                    yy=yy.replace("-","/")
                    //时间
                    var tt = inputDateList[1];
                    //小时
                    var hour = tt.split(":")[0];
                    //分
                    var min = tt.split(":")[1];
                    if (hour >= 12){
                        hour = hour - 12;
                        var hh = "下午" + hour +":" + min;
                    }else{
                        var hh  = "上午" + hour +":" + min;
                    };
                    dtlDate=yy+" "+hh;
                    result[i]["messageReceiveDtlTime"]=dtlDate;
                    if (n_yy == yy) {
                        //  result[i].messageReceiveTime = inputdate.split(" ")[1].substring(0,5);
                        result[i].messageReceiveTime = hh;
                    }else{
                        result[i].messageReceiveTime = yy;
                    }
                });
                hlp.bindtpl(r.result, ".usermessage", "tpl_myUserMessage");
                hlp.log("after bindtpl ...");

                $(".usermessage li label").off("tap").on("tap", function (event) {
                    var isCheckBox = $(".usermessage li").find("label").attr("class");
                    if (isCheckBox == "selectCircle") {
                        event.stopPropagation();
                    }
                });

                $(".usermessage li").off("tap").on("tap", function (event) {
                    var isCheckBox = $(this).find("label").attr("class");
                    if (isCheckBox == "selectCircle") {
                        if($(this).find(".msgSelect").prop('checked')){
                            $(this).find(".msgSelect").prop('checked',false);
                        }else{
                            $(this).find(".msgSelect").prop('checked',true);
                        }
                    }else{
                        //var myMessage = $($(this)[0].childElement)
                        var messageTitle = $(this).find(".messageTitle").val();
                        var messageContent = $(this).find(".messageContent").val();
                        var messageReceiveTime = $(this).find(".messageReceiveTime").val();
                        var messageReceiveDtlTime= $(this).find(".messageReceiveDtlTime").val();
                        var messageSender = $(this).find(".messageSender").val();
                        var messageId = $(this).find(".messageId").val();
                        hlp.panelObj["messageObj"] = {
                            "messageTitle": messageTitle,
                            "messageContent": messageContent,
                            "messageReceiveDtlTime": messageReceiveDtlTime,
                            "messageSender": messageSender
                        };
                        //消息已读
                        svc.updateUserMessage(tokenId, messageId, function (r) {
                            if  (r.status == "SUCCESS") {
                                $.afui.loadContent("#userMessageDetail");
                            }else{
                                hlp.myalert(r.message);
                            }
                        });
                    }
                });
            }else{
                hlp.myalert(r.message);
            };
        });

        //删除按钮
        $("#delete").off("tap").on("tap", function () {
            $("div.usermessage li").each(function(){
                if( $(this).find(".msgSelect").prop('checked')){
                    var messageid1 = $(this).find(".msgSelect").val();
                    //var messageId = $(messagecontent.parentElement).find(".messageId").val();
                    svc.delUserMessage(tokenId, messageid1, function (r1) {
                        if  (r1.status == "SUCCESS") {
                            showToast(r1.message);
                            $.afui.loadContent("#userMessage");
                            $(".messageFooter").hide();
                        }else{
                            hlp.myalert(r.message);
                        }
                    });
                }
            });
         });

        //标为已读
        $("#markAsRead").off("tap").on("tap", function () {
            $("div.usermessage li").each(function(){
                if( $(this).find(".msgSelect").prop('checked')){
                    var messageid1 = $(this).find(".msgSelect").val();
                    //var messageId = $(messagecontent.parentElement).find(".messageId").val();
                    svc.updateUserMessage(tokenId, messageid1, function (r) {
                        if  (r.status == "SUCCESS") {
                            showToast(r.message);
                            $.afui.loadContent("#userMessage");
                            $(".messageFooter").hide();
                        }else{
                            hlp.myalert(r.message);
                        }
                    });
                }
            });
        });
    });
    $("#userMessage").on("panelunload", function (){
        $(".bianji").hide();
        $(".messageFooter").hide();
    });

    //我的消息详细
    $("#userMessageDetail").on("panelload", function (e) {
        var pt = hlp.panelObj["messageObj"];
        if (pt) {
            hlp.bindtpl(pt, "#usermessage", "tpl_message");
        }
    });
    //手势密码设置
    //$("#gesturePW").on("panelload", function (e) {
    //    hlp.bindtpl("请输入手势密码", "#gesturePw", "tpl_gesturepw");
    //    var patternpw = 0;
    //    var lock = new PatternLock('#patternContainer', {
    //        onDraw: function (pattern) {
    //            if (patternpw == 0) {
    //                patternpw = pattern;
    //                lock.reset();
    //                hlp.bindtpl("请再输入手势密码", "#gesturePw", "tpl_gesturepw");
    //            } else {
    //                if (pattern == patternpw) {
    //                    console.log("PATTERN:" + pattern);
    //                    loj.setpatternPw(pattern);
    //                    lock.reset();
    //                    hlp.bindtpl("输入手势密码成功", "#gesturePw", "tpl_gesturepw");
    //                    //$.afui.dismissView("#gesturePW",":dismiss");
    //                    $.afui.loadContent("#mySettings");
    //                }
    //                else {
    //                    loj.setpatternPw("0");
    //                    hlp.bindtpl("输入手势密码失败，请重新输入！", "#gesturePw", "tpl_gesturepw");
    //                    patternpw = 0;
    //                    lock.reset();
    //                }
    //
    //            }
    //
    //        }
    //    });
    //});
    //手势密码check
    //$("#gesturePWsetting").on("panelload", function (e) {
    //    hlp.bindtpl("请输入手势密码", "#gesturePWset", "tpl_gesturepwset");
    //    var error_in = 4;
    //    var patternpw = loj.patternPw;
    //    var lock = new PatternLock('#patternContainerset', {
    //        onDraw: function (pattern) {
    //            if (pattern == patternpw) {
    //                loj.setpatternPw(pattern);
    //                lock.reset();
    //                hlp.bindtpl("输入手势密码成功", "#gesturePWset", "tpl_gesturepwset");
    //                //$.afui.dismissView("#gesturePW",":dismiss");
    //                $.afui.loadContent("#deviceList");
    //            }
    //            else {
    //                error_in = error_in - 1;
    //                //loj.setpatternPw("0");
    //                hlp.bindtpl("密码错误，还可以输入" + error_in + "次", "#gesturePWset", "tpl_gesturepwset");
    //                lock.reset();
    //                if (error_in <= 0) {
    //                    hlp.log("before doLogout call...");
    //                    var tokenId = loj.Credential;
    //                    svc.userLoginOut(tokenId, function (r) {
    //                        hlp.log("inside doLoginOut call...");
    //                        if (r.status == "SUCCESS") {
    //                            loj.setOffline();
    //                            hlp.log("doLogout success , after setOffline... ");
    //                            $.afui.loadContent("#login");
    //                        }else{
    //                            hlp.myalert(r.message);
    //                        }
    //                    });
    //                }
    //            }
    //        }
    //    });
    //});
    //我的设置
    $("#mySettings").on("panelload",function(e){
        var tokenId = loj.Credential;
        hlp.log("before getMySetting call..");
        svc.getMySetting(tokenId,function(r){
            hlp.log("inside getMySetting call..");
            if (r.status == "SUCCESS") {
                var result = r.result;
                $.each(result, function (i) {
                    var settingType = Number(result[i].SETTINGTYPE);
                    var settingValue = Number(result[i].SETTINGVALUE);
                    switch (settingType) {
                        case 1: // 手势密码
                            mySetting(settingValue, $("#gesturePassword"));
                            $("#gesturePassword").off("click").on("click",function(){
                                hlp.log("before setMySetting function...");
                                setMySetting(1,$("#gesturePassword"));
                            });
                            break;
                        case 2: // 账号绑定
                            mySetting(settingValue, $("#accountBinding"));
                            $("#accountBinding").off("click").on("click",function(){
                                hlp.log("before setMySetting function...");
                                setMySetting(2,$("#accountBinding"));
                            });
                            break;
                        case 3: // 消息推送
                            mySetting(settingValue, $("#messageSwitch"));
                            $("#messageSwitch").off("click").on("click",function(){
                                hlp.log("before setMySetting function...");
                                setMySetting(3, $("#messageSwitch"));
                            });
                            break;
                        default:
                            break;
                    }
                });
            } else {
                showToast(r.message);
            }
        });
        /*svc.getMySetting(tokenId,function(r){
            hlp.log("inside getMySetting call..");
            if (r.status == "SUCCESS") {
                var result = r.result;
                $.each(result, function (i) {
                    var settingType = Number(result[i].SETTINGTYPE);
                    var settingValue = Number(result[i].SETTINGVALUE);
                    switch (settingType) {
                        case 1: // 手势密码
                            mySetting(settingValue, $("#gesturePassword"));
                            break;
                        case 2: // 账号绑定
                            mySetting(settingValue, $("#accountBinding"));
                            break;
                        default:
                            break;
                    }
                });
            } else {
                hlp.myalert(r.message);
            }
        });
        $("#gesturePassword").off("click").on("click",function(){
            hlp.log("before setMySetting function...");
            setMySetting(1,$("#gesturePassword"));
        });
        $("#accountBinding").off("click").on("click",function(){
            hlp.log("before setMySetting function...");
            setMySetting(2,$("#accountBinding"));
        });*/
    });
});

//设置我的设置开关的默认值
var mySetting = function (settingValue, obj) {
    if (settingValue == 0) {
        obj.removeAttr("checked");
        obj.val(0);
        $("#bindOtherAccount").css("display","none");
    } else {
        obj.attr("checked", "true");
        obj.val(1);
        $("#bindOtherAccount").css("display","block");
    }
};
//修改我的设置开关状态
var setMySetting = function (settingType, obj) {
    //获取当前用户的tokenId
    var settingType = settingType;
    hlp.log(hlp.format("settingType:{0}",[settingType]));
    var tokenId = loj.Credential;
    var settingValue = obj.val();
    var oldSettingValue = obj.val();
    if (settingValue == 0) {
        settingValue = 1;
        obj.val(1);
    } else {
        settingValue = 0;
        obj.val(0);
    }
    svc.updateMySetting(tokenId,settingValue,settingType,function (r) {
        hlp.log("inside updateMySetting call...");
        if (r.status == "FAILURE") {
            showToast(r.message);
            if (oldSettingValue == 0) {
                obj.removeAttr("checked");
                obj.val(0);
            } else {
                obj.attr("checked", "true");
                obj.val(1);
            }
        }else if(r.status == "SUCCESS" && settingType == "1" && oldSettingValue == "0"){
            loj.setpatternPw("0");
            $.afui.loadContent("#gesturePW");
        }else if(r.status == "SUCCESS" && settingType == "1" && oldSettingValue == "1"){
            loj.setpatternPw("0");
        }else if(r.status == "SUCCESS" && settingType == "2" && oldSettingValue == "0"){
            $("#bindOtherAccount").css("display","block");
        }else if(r.status == "SUCCESS" && settingType == "2" && oldSettingValue == "1"){
            $("#bindOtherAccount").css("display","none");
        }else if(r.status == "SUCCESS" && settingType == "3") {
            showToast(r.message);
        }
    });
};

//我的 页面修改头像选项
var changeAvatar = function(){
    $.afui.actionsheet(
        '<a onclick="formCameraFunction()">拍照</a>' +
        '<a onclick="fromAlbumFunction()">从手机相册选择</a>');
};

//从手机相册选择图片
var fromAlbumFunction = function(){
    imageRcodeScanner(function (imgdata) {
        var imageSrc = imgdata;
        $("#showicon").attr("src","data:image/jpg;image/png;base64," + imageSrc);
        hlp.log("before updateUserInfo call...");
        var tokenId = loj.Credential;
        var username = "";
        svc.updateUserInfo(tokenId,username,imageSrc,function(r){
            if(r.status == "SUCCESS"){
                hlp.log("inside updateUserInfo call...");
                $.afui.loadContent("#myInfo");
            }else{
                hlp.myalert(r.message);
            }
        });
    }, function (error) {
        hlp.myalert(error);
    });
};

//拍照选取图片
var formCameraFunction = function(){
    getPictureFromCamera(function (imgdata){
        var imageSrc = imgdata;
        $("#showicon").attr("src","data:image/jpg;image/png;base64," + imageSrc);
        hlp.log("before updateUserInfo call...");
        var tokenId = loj.Credential;
        var username = "";
        svc.updateUserInfo(tokenId,username,imageSrc,function(r){
            if(r.status == "SUCCESS"){
                hlp.log("inside updateUserInfo call...");
                $.afui.loadContent("#myInfo");
            }else{
                hlp.myalert(r.message);
            }
        });
    },function(error){
        hlp.myalert(error);
    });
};

var fgtHandler = 0;

//发送验证码的倒计时
var count = 60;
var SendCodeEnableFg = true;
var forgetPasswordGetNumber = function (mobile) {
    SendCodeEnableFg = false;
    $("#forgetSendCode").text(count + "秒后重发");
    $("#forgetSendCode").addClass("disabled");
    count--;
    if (count > 0) {
        fgtHandler = setTimeout(forgetPasswordGetNumber, 1000);
    } else {
        $("#forgetSendCode").text("发送验证码");
        $("#forgetSendCode").removeClass("disabled");
        SendCodeEnableFg = true;
        var mobile=$("#forgetPassword #userMobile").val();
        svc.deleteCode(mobile,function(r){
            if(r.status == "SUCCESS"){
                hlp.log("deleteCode request success ...");
            }else{
                hlp.log("deleteCode request fail ...");
            }
        });
        count = 60;
    }
};

var clearFgtTm = function(){
	$("#forgetSendCode").text("发送验证码");
    $("#forgetSendCode").removeClass("disabled");
	clearInterval(fgtHandler);
    SendCodeEnableFg = true;
};

var regHandler = 0;

var registerGetNumber = function (mobile) {
    SendCodeEnableFg = false;
    $("#sendCode").text(count + "秒后重发");
    $("#sendCode").addClass("disabled");
    count--;
    if (count > 0) {
        regHandler = setTimeout(registerGetNumber, 1000);
    } else {
        $("#sendCode").text("发送验证码");
        $("#sendCode").removeClass("disabled");
        SendCodeEnableFg = true;
        var mobile=$("#regist #userAccount").val();
        svc.deleteCode(mobile,function(r){
            if(r.status == "SUCCESS"){
                hlp.log("deleteCode request success ...");
            }else{
                hlp.log("deleteCode request fail ...");
            }
        });
        count = 60;
    }
};

var clearRegTm = function(){
	$("#sendCode").text("发送验证码");
    $("#sendCode").removeClass("disabled");
	clearInterval(regHandler);
    SendCodeEnableFg = true;
};

var refundApplyHandler = 0;

var refundApplyGetNumber = function () {
    SendCodeEnableFg = false;
    $("#refundApplyCode").text(count + "秒后重发");
    $("#refundApplyCode").addClass("disabled");
    count--;
    if (count > 0) {
        refundApplyHandler = setTimeout(refundApplyGetNumber, 1000);
    } else {
        $("#refundApplyCode").text("获取动态验证码");
        $("#refundApplyCode").removeClass("disabled");
        SendCodeEnableFg = true;
        var mobile = $("#regMobile span").attr("reg-mobile");
        svc.deleteCode(mobile,function(r){
            if(r.status == "SUCCESS"){
                hlp.log("deleteCode request success ...");
            }else{
                hlp.log("deleteCode request fail ...");
            }
        });
        count = 60;
    }
};

var clearRefundApplyTm = function(){
    $("#refundApplyCode").text("获取动态验证码");
    $("#refundApplyCode").removeClass("disabled");
    clearInterval(refundApplyHandler);
    SendCodeEnableFg = true;
};

//qq账号绑定
var qqAccountBind = function(){
    var loginType = "qq";
    var tokenId = loj.Credential;
    if($("#myInfo #qq a").text() == "关联"){
        hlp.log("before qqLogin function...");
        qqLogin(function(result){
            hlp.log("inside qqLogin function...");
            hlp.log(hlp.format("qqLoginResult:{0}",[result]));
            var uid = result.uid;
            var accessToken = result.accesstoken;
            hlp.log("before flycoBindThirdParty call function...");
            svc.flycoBindThirdParty(uid,loginType,tokenId,function(r){
                hlp.log("inside flycoBindThirdParty call function...");
                if(r.status == "SUCCESS"){
                    hlp.log("flycoBindThirdParty request success...");
                    $("#myInfo #qq a").text("删除");
                    //$("#qqAccountBind .addStatus").removeClass("addStatus").addClass("minStatus");
                }else{
                    hlp.myalert(r.message);
                }
            });
            /*hlp.myalert("uid:  " +uid  +"accessToken:   "+ accessToken);*/
        },function(error){
            hlp.myalert(error);
        });
    }else{
        hlp.log("before accountUnbind call function...");
        svc.flycoUnbindThirdUser(tokenId,loginType,function(r){
            hlp.log("inside accountUnbind call function...");
            if(r.status == "SUCCESS"){
                hlp.log("accountUnbind request success...");
                $("#myInfo #qq a").text("关联");
                //$("#qqAccountBind .minStatus").removeClass("minStatus").addClass("addStatus");
            }else{
                hlp.myalert(r.message);
            }
        });
    }
};

//微信账号绑定
var weChatAccountBind = function(){
    var loginType = "weixin";
    var tokenId = loj.Credential;
    if($("#myInfo #weCaht a").text() == "关联"){
        hlp.log("before wxLogin function...");
        wxLogin(function(result){
            hlp.log("inside wxLogin function...");
            hlp.log(hlp.format("wxLoginResult:{0}",[result]));
            var uid = result.uid;
            var accessToken = result.accesstoken;
            hlp.log("before flycoBindThirdParty call function...");
            svc.flycoBindThirdParty(uid,loginType,tokenId,function(r){
                hlp.log("inside flycoBindThirdParty call function...");
                if(r.status == "SUCCESS"){
                    hlp.log("flycoBindThirdParty request success..");
                    $("#myInfo #weCaht a").text("删除");
                    //$("#wxAccountBind .addStatus").removeClass("addStatus").addClass("minStatus");
                }else{
                    hlp.myalert(r.message);
                }
            });
            /*hlp.myalert("uid:  " +uid  +"accessToken:   "+ accessToken);*/
        },function(error){
            hlp.myalert(error);
        });
    }else{
        hlp.log("before accountUnbind call function...");
        svc.flycoUnbindThirdUser(tokenId,loginType,function(r){
            hlp.log("inside accountUnbind call function...");
            if(r.status == "SUCCESS"){
                hlp.log("accountUnbind request success...");
                $("#myInfo #weCaht a").text("关联");
                //$("#wxAccountBind .minStatus").removeClass("minStatus").addClass("addStatus");
            }else{
                hlp.myalert(r.message);
            }
        });
    }
};

//京东账号绑定
var jdAccountBind = function(){
    var loginType = "jd";
    var tokenId = loj.Credential;
    if($("#myInfo #jd a").text() == "关联"){
        hlp.log("before jdLogin function...");
        jdLogin(function(result){
            hlp.log("inside jdLogin function...");
            hlp.log(hlp.format("jdLoginResult:{0}",[result]));
            var uid = result.uid;
            var accessToken = result.accesstoken;
            hlp.log("before flycoBindThirdParty call function...");
            svc.flycoBindThirdParty(uid,loginType,tokenId,function(r){
                hlp.log("inside flycoBindThirdParty call function...");
                if(r.status == "SUCCESS"){
                    hlp.log("flycoBindThirdParty request success...");
                    $("#myInfo #jd a").text("删除");
                    //$("#jdAccountBind .addStatus").removeClass("addStatus").addClass("minStatus");
                }else{
                    hlp.myalert(r.message);
                }
            });
            /*hlp.myalert("uid:  " +uid  +"accessToken:   "+ accessToken);*/
        },function(error){
            hlp.myalert(error);
        });
    }else{
        hlp.log("before accountUnbind call function...");
        svc.flycoUnbindThirdUser(tokenId,loginType,function(r){
            hlp.log("inside accountUnbind call function...");
            if(r.status == "SUCCESS"){
                hlp.log("accountUnbind request success...");
                $("#myInfo #jd a").text("关联");
                //$("#jdAccountBind .minStatus").removeClass("minStatus").addClass("addStatus");
            }else{
                hlp.myalert(r.message);
            }
        });
    }
};
