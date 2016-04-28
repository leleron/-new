function resetAccount(){
	$('input[id]').each(function(){
		$(this).val('');
	});
	$('textarea[id]').each(function(){
		$(this).val('');
	});
}
//绑定 现金券 抵用券
function binding_card(divid, type){
	if($('#card_sn').val() == ''){
		baison.alert('卡号不能为空');
		return false;
	}
	if($('#pwd').val() == ''){
		baison.alert('密码不能为空');
		return false;
	}	
	var params="app_fmt=json&card_sn="+$('#card_sn').val()+"&pwd="+$('#pwd').val()+"&type="+type;
	Ajax.call('/mem_center/index/binding_card', params, 
			function (s){		
			    if(s['statusCode'] !=0) {
				    baison.alert(s['status']); 
					
			    }else {
			    	baison.alert(s['status']);
					location.reload();
			    	//show_binding_card_list(divid, type);
						
			    }
		   }
	, 'POST', 'json');
}

function confirm_shipping(order_sn){
	var params="app_fmt=json&order_sn="+order_sn;
	Ajax.call('/mem_center/index/comfirm_shipping', params,
			function (_data){
			    if(_data.code){
			    	return false;
			    }else{
			    	location.reload();
			    	/*if( $("#pinglun_"+order_sn).size() <=0 ){
			    		var obj = $("#confirm_ship");
			    		obj.after("<a id='pinglun_"+order_sn+"' href='/mem_center/index/comment'>评论</a>|");
			    		obj.remove();
			    	}*/
			    	//if( confirm('订单收货已完成，需要对此商品评论吗？') ){
			    		//location.href='/mem_center/index/comment';
			    	//}else{
			    		//location.reload();
			    	//}
					/*
					baison.confirm('订单收货已完成，需要对此商品评论吗？',function(e){
						if(e){
							location.href='/mem_center/index/comment';
						}else{
							location.reload();
						}
					});
					*/
			    }
		    }
	, 'POST', 'JSON');
}

//添加晒单
function show_add_show_order(order_sn, order_id, product_img, goods_sn, goods_name, sku_sn, color_code, show_id){
	var params = 'app_page=null&order_sn='+order_sn+'&id='+order_id+'&product_img='+product_img+'&goods_sn='+goods_sn+'&goods_name='+encodeURI(goods_name,'UTF-8')+'&sku_sn='+sku_sn+'&color_code='+color_code;
	Ajax.call('/mem_center/index/show_add_show_order', params, 
		   function (s){
			    $("#"+show_id).html(s);
		   }
	, 'POST', '');
}

//删除关注
function del_fav(sn){
	var params="app_fmt=json&sn="+sn;
	Ajax.call('/mem_center/index/del_fav', params, 
			function (s){
			    if(s['statusCode'] !=0) {
				    baison.alert(s['status']); 
			    }else {
			    	baison.alert(s['status']); 
			    	location.reload();
			    }
		   }
	, 'POST', 'json');
}
//取消订单
function cancel_order(status,sn){
	var params="app_fmt=json&order_sn="+sn;
	if(status>0){
		params=params+'&api=1';
	}
	baison.confirm('确认取消本订单？取消后订单无法恢复',function(e){
		if( e ){
			Ajax.call('/mem_center/index/cancel_order', params, 
				function (s){
					if(s['code'] ==0) {
						if(status==0){
							baison.alert('订单取消成功！',{'className':'order_cancel_click'});
						}else{
							baison.alert(s['msg'],{'className':'order_cancel_click'}); 						
						}
						$('.order_cancel_click').find('.button').click(function(){
							location.reload();
						});	
					}else {
						baison.alert(s['msg']); 
						//location.reload();
					}
			   }
			, 'POST', 'json');
		}
	})
}
//修改订单
function edit_order(status,sn){
	var params="app_fmt=json&order_sn="+sn;
	if(status==0){
		params=params+'&type=edit';
	}else{
		params=params+'&type=returns';
	}
	Ajax.call('/mem_center/index/edit_order', params, 
		function (s){
			if(s['code'] == 0){
				location.href=s['data'];
			}else{
				baison.alert(s['msg']);
				if(s['code'] == 2){
					location.reload();
				}
			}
	   }
	, 'POST', 'json');
}
var fundsID =1;
function funds(id){
	var fundsObj = document.getElementById('c' + fundsID);
	if(fundsObj){
		 fundsObj.style.display = 'none';
		 document.getElementById('d' + fundsID).className = '';
	}
	var obj1 = document.getElementById('c' + id);
	document.getElementById('d' + id).className = 'current';
	obj1.style.display = '';
	fundsID = id;
}

function delcheck_fav(){
	var str = "";
	$('input[type=checkbox][name*=cbox]').each(function(){
		if($(this).attr('checked')){
			if(str==""){
				str += "'"+this.value+"'";
			}else{
				str += ",'"+this.value+"'";
			}
		};		 
	});
	
	if(str != ""){
		var params = "app_fmt=json&sn="+str; 
		Ajax.call('/mem_center/index/del_fav', params, 
			function (s){
			 	//s = eval('(' + s + ')');
			    if(s['data']['statusCode'] !=0) {
				   baison.alert(s['data']['status']); 
			    }else {
			    	baison.alert(s['data']['status']); 
			    	location.reload();
			    }
		   }
		, 'POST', 'json');
	}
}

function del_user_address(address_id){
	var params="app_fmt=json&address_id="+address_id;
	Ajax.call('/mem_center/index/del_address',params,
			  function(s){
				    if(s['data']['statusCode'] !=0) {
					    baison.alert(s['data']['status']); 
				    }else {
				    	baison.alert(s['data']['status']); 
				    	location.reload();
				    }
			  }
	,'POST','json');
}

function send_email(){
	 
	var email = $('#email').val();
	var checknumber = $('#dr_checknumber').val();
	var reg=/^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(14[0-9]{1}))+\d{8})$/;  
	var reg1 = /^([a-zA-Z0-9._-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
    if(!reg.test(email)&&!reg1.test(email)){ 
    	alert(1);
        $("#email").parent().append("<h2 class='red pa'>请输入邮箱或手机号码</h2>");
        return false;
    }	
	if(checknumber==""){
		$('#dr_checknumber').parent().append("<h2 class='red pa'>验证码不能为空</h2>");
		return false;
	}
	
	if(reg1.test(email)){
	var params="app_page=null&app_fmt=json&email="+email+"&checknumber="+checknumber;
	Ajax.call('/user/index/send_email',params,
			  function(s){
				    if(s['statusCode'] !=0) {
					    baison.alert(s['status']); 
						$('#dregvCode').click();
				    }else {
				    	baison.alert(s['status'],function(){
				    		location.href=$app_url + '';
				    	}); 
				    	
				    }
			  }
	,'POST','json');}else{
		         var phone=encodeURI(email);
		       location.href="/user/index/check_phone_code?phone="+phone;
	}
	
}

function send_change_pwd() {
	var phone_code = $("#phone_code").val();	

	var u = $("#u").val();
	var c = $("#c").val();
	var p = $("#p").val();
	var code = $("#code").val();
	var params = 'app_page=null&app_fmt=json&u='+u+'&c='+c+'&p='+p+'&code='+code+'&phone_code='+phone_code+'&type=phone';
	Ajax.call('/user/index/change_password',params,
			  function(s){
				    if(s['statusCode'] !=0) {
					   baison.alert(s['msg']); 
				    }else {
				    	location.href='/user/index/change_password?u='+u+'&c='+c+'&p='+p+'&type=phone_list';
				    }
			  }
	,'POST','json');
}
var index=60;
function change_time(){
	$("#free_code").html(index);
	if(index>0){
		index--;
		setTimeout("change_time()",1000);
	 }else{
		 $("#free_code").html("<a href='/user/index/pwd'>重新获取</a>");
		 index=60;
		 
    }
}
function send_phone(phone) {
	//var username = $("#username").val();
	var phonenumber =phone;
	//var checknumber = $('#dr_checknumber2').val();
	//var reg=/^(((13[0-9]{1})|159|(15[0-9]{1}))+\d{8})$/;     
	var reg=/^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(14[0-9]{1}))+\d{8})$/;   
    if(!reg.test(phonenumber)){  
        baison.alert("请输入正确的手机号");  
        return false;
    }	
    //if( !username ){
   	 //alert("请输入用户名");  
        //return false;
    //}
    //if( !checknumber ){
   	 //alert("请输入验证码");  
        //return false;
    //}
	//if(username != '' && phonenumber != '' && checknumber !='') {
	if(phonenumber != '') {
		//var params = 'app_page=null&app_fmt=json&username='+username+'&phone='+phonenumber+"&checknumber="+checknumber;
		var params = 'app_page=null&app_fmt=json&phone='+phonenumber;
		Ajax.call('/user/index/send_phone_pwd',params,
				  function(s){
					    if(s['statusCode'] ==0) {
					    	change_time();
					    	baison.alert(s['msg']);
					    	location.href=s['url'];
					    }else if(s['statusCode']==1){
					    	baison.alert(s['msg']);
					    }
				  }
		,'POST','json');
	}
}


var city=0;
var region=0;
var province=0;
function choose_province(obj){
	province=$(obj).val();
	Ajax.call('/mem_center/index/get_city?app_fmt=json&province='+province, '', 
		function (s){
			if(s !== null){
				var option='<option value="no_choose" selected>--请选择--</option>';
				for ( i=0;i<s.length;i++) {
					option+="<option value='"+s[i]['id']+"'>"+s[i]['name']+"</option>";
				}
				$('#city').html(option);
				//$('#add_city').append(option);
				//$('#city').append(option);
				$('#district').html('<option value="no_choose" selected>--请选择--</option>');
			}
		}	, 'POST', 'json'); 
}
function choose_city(obj){
	city=$(obj).val();
	Ajax.call('/mem_center/index/get_region?app_fmt=json&city='+city, '', 
		function (s){
			//s = eval('(' + s + ')');
			if(s!== null && s.length>0){
				$('#district').removeAttr('dist').show();
				var option='<option value="no_choose" selected>--请选择--</option>';
				for ( i=0;i<s.length;i++) {
					option+="<option value='"+s[i]['id']+"'>"+s[i]['name']+"</option>";
				}
				$('#district').html(option);
				//$('#district').append(option);
			}else{
				$('#district').attr('dist','none').hide().html('<option value="0" selected></option>');
			}
		}	, 'POST', 'json'); 
}

function choose_region(obj){
	region=$(obj).val();
}

function showGroupError(){
	var t = this;
	
	for ( var i = 0; this.errorList[i]; i++ ) {
		var error = this.errorList[i];
		alert(error.message);return false;
		this.settings.highlight && this.settings.highlight.call( this, error.element, this.settings.errorClass, this.settings.validClass );

		var elename = error.element.id;
		jQuery('#check'+elename).html('<span class="error_img"></span>');
		jQuery('#check'+elename).show();
		var errsdiv = jQuery('span[htmlfor='+ elename + ']'); 
		if(errsdiv.length == 0){
		errsdiv = jQuery('<span class="errmsg"  style="margin:-10px 0 0 10;" id="errmsg'+elename+'"></span>');
		errsdiv.attr({"for":  this.idOrName(error.element), generated: true})
		errsdiv.appendTo(jQuery('#check'+elename));
	}
	errsdiv.html(error.message || "");
	//jQuery('#'+elename).parent().;
	// 错误信息div
	// 错误信息div

	}

	// 校验成功的去掉错误提示
	for ( var i = 0; this.successList[i]; i++ ) {
		if(this.idOrName(this.successList[i])=='nickname'|| this.idOrName(this.successList[i])=='email'){
			setTimeout("showRight('"+ this.idOrName(this.successList[i]) +"')",1000); 
		}else{
			showRight(this.idOrName(this.successList[i]));
		}
	}
}

function getdaylimit(year, month, currentDay) {
	Ajax.call('/mem_center/index/get_day?year='+year+"&month="+month+"&currentDay="+currentDay, '', 
			function (s){
				$("#birthday_d").html(s);
			}	, 'GET', '');  
}
function add_new_address(num, showid, hideid ,address_id) {
	if(num > 4 ){
		baison.alert('地址最多添加5个');
		return false;
	}
	if(address_id != 0)
		var url = '/mem_center/index/show_address?address_id='+address_id;
	else 
		var url = '/mem_center/index/show_address';
	
	location.href = url;
		/*Ajax.call(url, '', 
				function (s){
					$("#"+showid).html('').html(s);
				}	, 'POST', ''); 
		if(address_id == 0)
			$("#"+hideid).hide();
		else 
			$("#"+hideid).show();
		$("#"+showid).show();*/
}

//删除地址
function address_del(url){	
	var params="app_fmt=json";
	baison.confirm('确定要删除收货地址吗？\n删除后将无法找回',function(e){
		if(e){
			Ajax.call(url,params, 
				function (s){
				    if(s['statusCode'] !=0) {
					    baison.alert(s['status']); 
				    }else {
				    	baison.alert(s['status'],function(){
							location.reload();
						}); 
				    }
				}	, 'POST', 'json'); 
		}
	});
}
function show_consults(obj,consult_url,show_div){
	if($(obj).attr('checked')) {
		var params = "comment_status=1";
	}else {
		//var params = "comment_status=0";
		var params = '';
	}
	Ajax.call(consult_url, params, 
		function (s){
			$("#"+show_div).html(s);
		}
	, 'POST', '');
}
//删除咨询
function consult_del(cmt_id){
	var params="app_fmt=json&cmt_id="+cmt_id+"";
	Ajax.call('/mem_center/index/del_comment', params, 
			function (s){
			 	//s = eval('(' + s + ')');
			    if(s['data']['statusCode'] !=0) {
				   baison.alert(s['data']['status']); 
			    }else {
			    	baison.alert(s['data']['status']); 
			    	location.reload();
			    }
		   }
	, 'POST', 'json');	
}

$(document).ready(function() {
	//点击换图片
	$("#change_dregvCode").click(function(){
		$("#dregvCode").attr('src','/printpic/do_index?type=reg&amp;'+ Math.random());
	});
	$("#update_userInfo").validate({
		event: "blur", 
		rules: {    	
		},  
		 messages: {
		},
		showErrors: showErrors,
		focusInvalid: false,    
		onkeyup: false,
		submitHandler: function(form){
		    var user_name = $("#realname").val();
			var phone = $("#phone").val();
			var alias =$("#alias").val();
			var email= $("#email").val();
			var rule = /^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(14[0-9]{1}))+\d{8})$/;
			if((user_name !='') && (rule.test(phone))){
				var address = $("#address").val();
				var sex =1;
				$("a[name='sex']").each(function(){
					if($(this).hasClass('current')){
						sex = $(this).attr('value');
					}
				});
				var params="app_fmt=json&true_name="+user_name+"&alias="+alias+"&email="+email+"&sex="+sex+"&mobile_phone="+$("#phone").val()+"&province="+$("#province").val()+"&city="+$("#city").val()+"&district="+$("#district").val()+"&address="+$("#address").val();
				var birthday = $("#birthday_y").val()+'-'+$("#birthday_m").val()+'-'+$("#birthday_d").val();
				params+='&birthday='+birthday;
				Ajax.call('/fkwap/integral/add_info', params, 
						function (s){						
							if(s['statusCode'] !=0) {
								baison.alert(s['status']); 
							}else {
								baison.alert(s['status'],function(){
									location.reload();
								});
							}		
					   }
				, 'POST', 'json');
			}else{
				if(user_name==''){
					baison.alert('真实姓名不能为空！');			
				}else{
					baison.alert('请检查手机号码是否正确！');
				}
			}
		}
	});	
	
	$("#update_new_password").validate({
		event: "blur", 
		rules: {    
			new_password:{
				required:true
			},
			new_password1:{
				required: true,
				equalTo:"#new_password"
			}
		},  
		 messages: {    
			old_password: {    
			required:"新密码不能为空"
			},
			new_password1: {    
			required: "请输入您的新密码",
			equalTo:"两次密码不一致"
			}
	    },
		showErrors: showErrors,
		focusInvalid: false,    
		onkeyup: false,
		submitHandler: function(form){
	    	var type = $("#type").val();
	    	var username = $("#username").val();
			var newPwd = $("#new_password").val();
			var reNewPwd = $("#new_password1").val();
			var rule = /^[a-zA-Z0-9]{6,16}$/;
	    	if(username !='') {
					if(rule.test(newPwd) && (newPwd == reNewPwd )){

						var params="app_page=null&app_fmt=json&username="+username+"&new_password="+$('#new_password').val()+"&new_password1="+$('#new_password1').val();
						
						var u = $("#u").val();
						var c = $("#c").val();
						var p = $("#p").val();						
						params += '&u='+u+'&c='+c+'&p='+p;
																
						Ajax.call('/user/index/change_password_value', params, 
								function (s){
									if(s['statusCode'] !=0) {
										baison.alert(s['msg']); 
									}else {
										if(type !='') {
											baison.alert('密码已找回，请重新登录',function(){
												location.href = '/user/index/';
											});
											
										}else {
											baison.alert(s['msg'],function(){
												location.href = '/user/index/';
											}); 
											
										}
									}
							   }
						, 'POST', 'json');					
					}
	    	}else {
	    		baison.alert('用户名不能为空');
	    	}
	    	
		}
	});

	$("#update_password").validate({
		event: "blur", 
		rules: {    
			old_password:{
				required:true
			},
			new_password1:{
				required: true,
				minlength: 6,
				maxlength:16
			},
			new_password2:{
				required: true,
				equalTo:"#new_password1"
			}
		},  
		messages: {    
			old_password: {    
				required:"旧密码不能为空"
			},
			new_password1: {    
				required: "请输入您的新密码",
				minlength: jQuery.validator.format("密码不能小于 {0}位数")
			},
			new_password2: {    
				required: "请再次输入您的新密码",
				equalTo:"两次密码不一致"
			}
	    },
		showErrors: showErrors,
		focusInvalid: false,    
		onkeyup: false,
		submitHandler: function(form){
			var newPwd = $("#new_password1").val();
			var reNewPwd = $("#new_password2").val();
			var url=$("#url").val();
			var params="app_fmt=json&old_password="+base64encode($('#old_password').val())+"&new_password="+base64encode($('#new_password1').val());
			Ajax.call('/mem_center/index/update_password', params, 
					function (s){
						//s = eval('(' + s + ')');
						if(s['statusCode'] !=0) {
							baison.alert(s['status']); 
						}else {
							baison.alert(s['status'],function(){
								location.href=url;
							}); 
							
						}
				   }
			, 'POST', 'json');			
		}
	});
	
	$("#account_recharge").validate({
		event: "blur", 
		rules: {    
			amount:{
				required:true,
				number:true
			}
		},  
		messages: {
			amount:{
				required:"请输入正确的数值"
			}
		},
		showErrors: showErrors,
		focusInvalid: false,    
		onkeyup: false,
		submitHandler: function(form){
			var params="app_fmt=json&amount="+$('#amount').val()+"&user_note="+$('#user_note').val();
			Ajax.call('/mem_center/index/account_recharge',params,
					  function(s){
						    if(s['data']['statusCode'] !=0) {
							    baison.alert(s['data']['status']); 
						    }else {
						    	baison.alert(s['data']['status'],function(){
									location.reload();	
								});
						    	
						    }
					  }
			,'POST','json');
		}
	});

	$("#account_payout").validate({
		event: "blur", 
		rules: {    
			out_amount:{
				required:true,
				number:true
			}
		},  
		messages: {
			out_amount:{
				required:"请输入正确的数值"
			}
		},
		showErrors: showErrors,
		focusInvalid: false,    
		onkeyup: false,
		submitHandler: function(form){
			var params="app_fmt=json&amount="+$('#out_amount').val()+"&user_note="+$('#out_user_note').val();
			Ajax.call('/mem_center/index/account_payout',params,
					  function(s){
						    if(s['data']['statusCode'] !=0) {
							    baison.alert(s['data']['status']); 
						    }else {
						    	baison.alert(s['data']['status'],function(){
									location.reload();
								});
						    		
						    }
					  }
			,'POST','json');
		}
	});

	$("#add_address").validate({
		event: "blur", 
		rules: {    
			consignee:{
				required:true
			},
			province:{
				number: true
			},
			city:{
				number: true
			},
			district:{
				number: true
			},
			address:{
				required: true
			},
			
			phone:{				
				required: true,
				isMobile: true
			}
		},  
		messages: {    
			consignee: {    
				required:"请输入您的收货人姓名"
			},
			province: {    
				number:"请选择您所在省份"
			},
			city: {   
				number:"请选择您所在城市"
			},
			district: {  
				number:"请选择您所在区域"
			},
			add_email: {
				required:"请输入您的email地址",
				email:"您输入的email有误"
			},
			
			phone: {  
				required:"请输入您的手机号码"
			}
	    },
		showErrors: showErrors,
		focusInvalid: false,    
		onkeyup: false,
		submitHandler: function(form){
			//验证固定电话
			var tel_checked = /^(\d*)$/;	
			var fixTel = $('#tel01').val() + $('#tel02').val() + $('#tel03').val();
			if(!tel_checked.test(fixTel)){
				baison.alert('请正确输入固定电话！');
				return false;
			} else {
				var fixTel = $('#tel01').val() + '-' + $('#tel02').val() + '-' + $('#tel03').val();
			}
						
			var params="app_fmt=json&consignee="+$('#consignee').val()+"&province="+$('#province').val()+"&city="+$('#city').val()+"&district="+$('#district').val()+"&address="+$('#address').val()+"&email="+$('#email').val()+"&zipcode="+$('#zipcode').val()+"&tel="+fixTel+"&mobile="+$('#phone').val();
			Ajax.call('/mem_center/index/add_address', params, 
					function (s){
					    if(s['data']['statusCode'] !=0) {
						    baison.alert(s['data']['status']); 
					    }else {
					    	baison.alert(s['data']['status'],function(){
								location.reload();
							});	
					    }
				   }
			, 'POST', 'json');
		}
	});
	//选择默认地址
	$("td[name='default']").click(function() {	
		//$(this).parent().siblings("li").find("input").attr('name','');
		var default_address = $(this).attr('value');
		baison.confirm("确定要把此项作为默认收货地址吗？",function(e){
			if(e){				
				var params = "app_fmt=json&default_address="+default_address;
					Ajax.call('/mem_center/index/update_address_default', params, 
							function (s){
								if(s['statusCode'] !=0) {
									baison.alert(s['status']); 
								}else {
									baison.alert(s['status'],function(){
										location.reload();
									}); 
								}
						   }
					, 'POST', 'json');
			}else{
				return false;
			}
		});
	});
	
	var $coupon=$("#coupon_pwd");
	$coupon.val($coupon.attr('promptvalue'));
	$coupon.keypress(function(e){
		if(e.which==13){
			$('#search').click();
			return false;
		}
	}).click(function(e){
		if($(this).val()==$(this).attr('promptvalue')){
			$(this).val('');
		}
	});
});

function send_to_friends(){
	var emailList = $('#email').val();
    if(!emailList){
        baison.alert ('您还没有添加好友的邮箱地址');
        return false;
    }
    var title = $("#title").val();
    if(!title) {
 	   baison.alert('标题不能为空');
 	   return false;
    }
    var content = $("#content").val();
    if(!content) {
 	   baison.alert('内容不能为空');
 	   return false;
    }
	
	//alert(content);return false;
    $("#result").html('正在给发送邮件~').show();
    $.ajax({
      type: 'POST',
      data: 'app_fmt=json&emaillist='+emailList+'&title='+title+'&content='+content,
      url : '/mem_center/index/invite_friends',
      dataType: "",
      async:true,
      cache:false,
      success : function(s) {
		s = eval('(' + s + ')');
		if(s['statusCode'] !=0) {
			baison.alert(s['status']); 				    
		}else {
			baison.alert(s['status']); 
		}
      }
    });
}

//我的关注加入购物车
function fav_add_cart(sku_sn, price, ext) {
	Ajax.call('/goods/get_sku_price?app_page=null&sku_sn='+sku_sn, '', 
		function (s){			
			var s = eval('('+s+')');			
			if(parseInt(s.number) < 1){
				baison.alert('库存不足！');
			}
			else{
				Ajax.call('/goods/check_cart_sum?app_page=null', '', 
					function (s){
						s=eval('('+s+')');	
						if(s.code==1){
							baison.alert(s.msg);
						}else{	
							var url='/goods/add_product_to_cart?app_page=null';
							url+='&sku_sn='+sku_sn;
							url+='&ext_attr_info='+encodeURI(ext,'utf-8');
							url+='&choose_num=1';
							url+='&price='+price;
							url+='&action=common';
							url+='&type=common';
							ajaxcheck('open_title',url,'','common');
						}
					}	, 'GET', ''); 
			}
		}	, 'GET', ''); 
}

function exchage_bonus(pay_point,bili){
	if( pay_point > 0 ){
		var bouns_value =parseInt( $("a[checked=checked][name=bonus]").attr('value') );
		var exchange_points = bouns_value/bili;
		if( exchange_points <= pay_point ){
			var params="app_fmt=json&bouns_value="+bouns_value;
			Ajax.call('/mem_center/index/exchange_points', params,
				function (data){
				   var data = eval('('+data+')');
				   baison.alert(data['status'],function(){
						location.reload();   
				   });
				}
			, 'POST', 'JSON');
		}else{
			baison.alert('对不起,您当前的积分不足!');return;
		}
	}else{
		baison.alert('对不起,您当前的积分不足!');return;
	}
}

function comment_detail(id){
	var content = $('#comment_content_'+id).html();
	$('#comment_content_'+id).html('<textarea style="width: 688px;" id="comment_content">'+content+'</textarea>');
	$('#comment_content_'+id).next().show();
}

function amend_comment_submit(id){
	var content = $("#comment_content").val();
	if(content != '') {
		$("a[name='comment_submit']").attr('disabled','true');
		var params = 'app_fmt=json&id='+id+'&content='+encodeURIComponent(content);

		if($('[id^=commentitemadd_]').size() > 0) {
			$('[id^=commentitemadd_]').each(function (){
				params += '&'+$(this).attr('id')+'='+parseFloat(parseFloat($(this).find('.score1').html())+ parseFloat($(this).find('.score2').html())).toFixed(1);
			});
		}
		if($('input[type="radio"][name^="commentitemadd_"]').size() >0) {
			$('input[type="radio"][name^="commentitemadd_"]:checked').each(function() {
				params += '&'+$(this).attr('name')+'='+$(this).val();
			})
		}
		Ajax.call('/goods/amend_comment', params,
			function (s){
				s=eval('('+s+')');
				if(s.code == 0) {
					var enable='0';
					if(enable=='1'){
						baison.alert(s.msg+',请等待管理员审核',function(){
							commentFun();
						});
					}else{
						baison.alert(s.msg+',感谢您的评价!',function(){
							commentFun();
						});
					}
					function commentFun(){
						//$("input[name='title']").val('');
						$("textarea[name='comment_content']").val('');
						location.href="/mem_center/index/comment";
					}
					
				} else {
					baison.alert(s.msg);
				}
				$("input[name='comment_submit']").removeAttr('disabled');
			}
		, 'POST', 'JSON');
	} else if (content != '' || title != '') {
		baison.alert('数据填写不完整');
	}
	return false;
}
