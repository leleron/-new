var tel='';
var city=0;
var region=0;
var province=0;
function choose_province(obj){
	province=$(obj).val();
	Ajax.call($app_url+'orders/get_citys&app_page=null&app_fmt=json&province='+province, '', 
		function (s){
			var option="<option value='no_choose'>--请选择--</option>";
			for(i=0;i<s.length;i++){
				option+="<option value='"+s[i].id+"'>"+s[i].name+"</option>";
			}
			$('#city').html(option);
			$('#region').html("<option value='no_choose'>--请选择--</option>");
			$('#city_list').html(option);
			$('#region_list').html("<option value='no_choose'>--请选择--</option>");
		}	, 'POST', 'json'); 
}
function choose_city(obj){
	city=$(obj).val();
	Ajax.call($app_url+'orders/get_region&app_page=null&app_fmt=json&city='+city, '', 
		function (s){			
			if(s!== null && s.length>0){
				$('#region').removeAttr('dist').show();
				$('#region_list').removeAttr('dist').show();
				var option="<option value='no_choose'>--请选择--</option>";
				for(i=0;i<s.length;i++){
					option+="<option value='"+s[i].id+"'>"+s[i].name+"</option>";
				}
				$('#region').html(option);
				$('#region_list').html(option);
			}else{
				$('#region').attr('dist','none').hide().html('<option value="0" selected></option>');
				$('#region_list').attr('dist','none').hide().html('<option value="0" selected></option>');
			}
		}	, 'POST', 'json'); 
}
function getTelNumber(){
	//var tel01=$("#tel01").val();
	var tel02=$("#tel02").val();
	//var tel03=$("#tel03").val();
	tel=tel02;
	//if(tel02!='') tel +='-'+tel02;
	//if(tel03!='') tel +='-'+tel03;
}
function cancel_address(){
	$("div.p_goods_detail").find('p.close').click();//关闭弹出层
}
$(document).ready(function() {
	
	/*jQuery("#tel01").blur(function () { 
		getTelNumber();
	} ); 
	jQuery("#tel03").blur( function () { 
		getTelNumber();
	} ); */
	jQuery("#tel02").blur(function () { 
		getTelNumber();
	} ); 
	
	$("li[name=best_time]").click(function(){
		$(this).addClass("current").siblings().removeClass("current");
	});	
	$("#addressForm").validate({
		event:"blur", 
		rules: {    
			consignee: {     
				required: true,
				string:true 	
			},    
			province: {    
				required: true,
				min:1    
			} ,
			city: {    
				required: true, 
				min:1  
			} ,
			region: {    
				required: true,
				number:true
			} ,
			address: {    
				required: true,
				string:true,    
				maxlength:240   
			},  
			
			
			tel02:{
				number:true ,
				TelAll:true
			},
			
			phone:{
				MobileOrPhone:true,
				isMobile:true
			}
		},  
		messages: {    
			consignee: {    
				required: "请填写联系人"
			},  
			address: {
				required:"请填写收货地址",
				string:"地址只能是字符",
				maxlength:"地址长度不能超过240"
			},
			province: {    
				min: "请选择省份"
			} ,
			city: {    
				min: "请选择城市"
			} ,
			
			region: {    
				number: "请选择所在区域"
			}
		},
		showErrors: showErrors,
		focusInvalid: false,    
		onkeyup: false,
		submitHandler: function(form){
			//$('#checkphone').html('');
			var address_id = $('#address_id').val();
			getTelNumber()
			var params="&app_page=null&app_fmt=json&consignee="+encodeURI($('#consignee').val())+"&province="+$('#province').val()+"&city="+$('#city').val()+"&district="+$('#region').val()+"&address="+encodeURI($('#address').val())+"&zipcode="+$('#zipcode').val()+"&tel="+tel+"&mobile="+$('#phone').val();
			
			params +="&check_code="+$("#check_code").val();
			if($("#default_address:checked").size()>0){
				params+="&default_address=1";
			}
			if(address_id !=0) {
				var url= '/index.php?app_act=orders/update_address&';
				params += '&address_id='+address_id;
			}else {
				var url= '/index.php?app_act=orders/add_address';
			}
			Ajax.call(url, params, 
					function (s){
						if(s.statusCode == 0){
							window.top.location='/orders/';
						}else{
							alert(s.status);
							window.top.location='/orders/';
						}
				   }
			, 'POST', 'json');
		}
	});
});