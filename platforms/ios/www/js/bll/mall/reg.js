$(document).ready(function() {
    var emailInfo = {
        email:function(){
            return jQuery("#d_reg_email").val();
        }
    };
	var nickname = {
		nickname:function(){
			return jQuery("#d_nickname").val();
		}
	};
	//点击换图片
	$("#change_dregvCode").click(function(){
		$("#dregvCode").attr('src','/printpic/do_index?type=reg&amp;'+ Math.random());
	});
	var  emailremoteInfo= GetRemoteInfo('/index.php?app_act=user/index/do_check_email', emailInfo);  
    var  nicknameremoteInfo= GetRemoteInfo('/index.php?app_act=user/index/do_check_nickname', nickname);  
    /*
	$("#d_reg_email").keyup(function(){
		var regemail = $("#d_reg_email").val().split('@');
		if(regemail['0']!=='')
		$("#d_nickname").val(regemail['0']);
		
	});*/
	
    $("#d_register").validate({
        event: "blur", 
        rules: {    
    		dr_checknumber:{
                required: false 
            },
            d_reg_email:{
                required:true,
                email:true,
                remote:emailremoteInfo 
            },
            d_reg_pwd1:{
                required: true,
                string:true,    
                minlength: 6,
                maxlength:16
            },
            d_reg_pwd2:{
                required: true,
                string:true,    
                minlength: 6,
                maxlength:16,
                equalTo:"#d_reg_pwd1" 
            }
        },  
        messages: {
            d_reg_email: {    
                required:"email不能为空",    
                isUserName:"请输入合法EMAIL" 
            } ,			
            d_reg_pwd1: {    
                required: "密码不能为空",    
                minlength: jQuery.validator.format("密码不能小于 {0}位数")   
            },
            d_reg_pwd2:{
                required: "重复密码不能为空",  
                minlength: jQuery.validator.format("密码不能小于 {0}位数"),
                equalTo	:"两次密码输入不一样"
            },
            dr_checknumber:{
                required: "验证码不能为空"  
            } 
        },
        showErrors: showErrors,
        focusInvalid: false,    
        onkeyup: false,
        submitHandler: function(form){           
            //$('.reg_reg_btn').parent().html('注册申请中,请稍后...');
            var params="app_fmt=json&email="+base64encode(encodeURI($('#d_reg_email').val(),'utf-8'))+"&nickname="+base64encode(encodeURI($('#d_reg_email').val(),'utf-8'))+"&password="+base64encode($('#d_reg_pwd1').val())+"&repassword="+base64encode($('#d_reg_pwd2').val())+"&checknumber="+$('#dr_checknumber').val()+"&u="+request('u')+"&c="+request('c');	
			
            Ajax.call('/index.php?app_act=user/index/do_adduser', params, 
                function (s){
                    s = eval('(' + s + ')');
                    if(s['statusCode']==1) {
                        baison.alert(s['status']);
                        location.href="/user/index/active"
                    }else{
                        if(s['statusCode']==0) {
                            baison.alert(s['status']);
                            location.href="/mem_center/index/do_index";									
                        }else{						
                            baison.alert(s['status']);
                            if(s['statusCode'] == -102){
                                $("#dregvCode").click();
                            }
                            $("#misun_btn_agree").attr('class','misun_btn_agree1');
                        }
                    }
				
                }
                , 'POST', 'JSON');        
        }
    });
});