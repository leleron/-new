var need_bill=0;//是否发票
var my_balance=0;//账户余额
var last_balance=0;

var payment_id=0;//支付方式ID
var shipping_id=0;//配送方式ID
var shipping_fee=0;//当前配送方式运费
var is_shipping_free=0;//是否免邮
var shipping_fee_array=new Array();//配送方式费用数组
var shipping_fee_cod_array=new Array();//货到付款运费数组


var use_balance=0;//订单使用余额
var use_integral=0;//订单使用积分
var use_coupon=0;//订单使用现金券
var use_vouchers=0;//订单使用抵用券
var ticket_type=0; //判断是公司还是个人
var ticket_attr=1; //判断是电子发票还是普通发票
var  card_sn='';

var final_price=0;//订单需支付金额
var final_goods_price=0;//订单商品金额
//以上变量页面加载完成存入JS缓存，不直接从页面获取
var use_coupon_voucher_list = new Array();
//送货地址变化时重新查询支付方式和配送方式
function get_shipping_payment(address,obj,type){
	if(address!=''){
		address_id=address;
		//$('#inv_payee').val($('#consignee_'+address).html());
		/*$('#selectaddress input[type=button]').each(function(){
			$(this).removeClass('addressCurrBtn').addClass('addressBtn');
		});*/
		//$(obj).addClass("current").siblings().removeClass("current").attr('checked','true');
		
		Ajax.call($app_url+'orders/list_shippings&app_page=null&address_id='+address+'&is_shipping_free='+is_shipping_free+'&type='+type, '', 
				function (s){
					shipping_id = 0;
					payment_id = 0;
					$('#order_shipping_payment').html(s);
			   }
		, 'GET', '');
	}
}
//初始化运费数组
function set_shipping_fee(){
	$('span[name=shipping_fee]').each(function(){
		var id=$(this).attr('id');
		var value=parseFloat($.trim($(this).html()));
		shipping_fee_array[id]=value;
	});
	$('span[name=shipping_fee_cod]').each(function(){
		var id=$(this).attr('id');
		var value=parseFloat($.trim($(this).html()));
		shipping_fee_cod_array[id]=value;
	});
}
//选择支付方式
function selectPayment(obj){

	//$(obj).addClass("current").siblings('[name=pay_id]').removeClass("current").attr('checked','true');
	var user_price = 0;
	payment_id=$(obj).val();

	if($("[name='use_balance']").hasClass('curent')){
		user_price = my_balance;
	}
	$('#shipping_list input[type=redio]').each(function(){
		if($(this).attr('support_cod')!=1){
			$(this).removeAttr("disabled"); 
		}
	});

	final_price=final_goods_price-use_balance-use_integral-use_coupon-use_vouchers;
	$('li[type="checkbox"]').each(function(){	
		if($(this).attr('pay_value') != payment_id) {
			$(this).removeAttr('checked').remoeClass('current');
		}
		if($(this).hasClass('current') && shipping_id!=0){
			if($(this).attr('pay_code')=='cod'){
				shipping_fee=parseFloat(shipping_fee_cod_array[shipping_id]);
			}else{
				shipping_fee=parseFloat(shipping_fee_array[shipping_id]);
			}
		}
	});
	if(typeof(shipping_fee)=='undefined'){
		shipping_fee=0;
	}
	$('#shipping_price').html(shipping_fee.toFixed(2));

	final_price = final_price+shipping_fee;
	use_last_balance();
	
	/*$("#pay_only").html(parseFloat(shipping_fee)+parseFloat($("#point_by_price").val()));
	if(final_price>0){
		$('#must_pay').html(parseFloat(final_price).toFixed(2));
	}else {
		$('#must_pay').html(0);
	}*/
	order_init();
}
//选择配送方式
function selectShipping(obj){
	shipping_id=$(obj).attr('sid_value');
	$(obj).addClass("current").siblings().removeClass("current");
	
	final_price=final_goods_price-use_balance-use_integral-use_coupon-use_vouchers;
	var flag = $("[name='pay_id'][class='current']");
	if( flag ){
		if(flag.attr('is_cod')==1 && payment_id!=99){
			shipping_fee=parseFloat(shipping_fee_cod_array[shipping_id]);
		}else{
			shipping_fee=parseFloat(shipping_fee_array[shipping_id]);
		}
	}else{
		shipping_fee=parseFloat(shipping_fee_array[shipping_id]);
	}
	if( typeof(shipping_fee) =='undefined' ){
		shipping_fee=0;
	}

	final_price=final_price+shipping_fee;
	use_last_balance();

	$('#shipping_price').html(shipping_fee.toFixed(2));
	$("#pay_only").html(parseFloat(shipping_fee)+parseFloat($("#point_by_price").val()));
	if(final_price>0) {
		$('#must_pay').html(final_price.toFixed(2));
	}else {
		$('#must_pay').html(0);
	}
	order_init();
}
//使用积分
function os_integral(integrals,integral_rate,total,total_integrals){
	if(integrals==0){
	 $("#use_integration").attr("checked","");
	  baison.alert('使用积分时可用积分不能为0');
	  return false;
	}
	if(!order_rate){
		baison.alert('该订单不能使用积分');
	 $("#use_integration").attr("checked","");
		return false;
	}
	if( $("#use_integration").is(":checked") ){
		//获取总积分
		var jifen = $("#pay_point").val();	
		if(jifen =='') jifen = integrals;	
		//确定使用积分，只能使用40%,如果现有积分小于商品总金额40%，
		if(integrals){
		if( jifen =='' || jifen*integral_rate > total*order_rate ){
			jifen = Math.floor((total*order_rate)/integral_rate);
			if(jifen>integrals){
				jifen=integrals;
			}
			
		}
		}else{
			jifen=0;
		}
		$("#pay_point").val(jifen);
		$("#youhui").html((jifen*integral_rate).toFixed(2));
		$("#total_use_intergral").html((jifen*integral_rate).toFixed(2));
	}else{
		$("#pay_point").val('');
		$("#youhui").html('0');
		$("#total_use_intergral").html('0');
	}
	order_init();
}

//使用余额付款
function user_balance(total){	
	var $obj = $("#use_balance");
	if(my_balance==0){
		baison.alert('余额为0');
		$obj.removeClass("current");	
		return false;
	}
	if($obj.hasClass('current')){
		$obj.removeClass("current");
	}else{
		$("#use_balance").addClass("current");
	}
	order_init();	
}
function cancel_gift(){
	use_coupon = 0;
	use_vouchers = 0;
	order_init();
	$("#gift_voucher").removeClass("current");
	$(".gift_change").hide();
}
 function check_voucher(){
	
   card_sn=$('#voucher_value').val();
	if(!card_sn){
		baison.alert("请输入礼品券码");
		return false;
	}
	 var url = "/orders/check_voucher&app_page=null&app_fmt=json";
	$.post(url,{"card_sn":card_sn},function(data){
		var data=jQuery.parseJSON(data);
	   if(data.code){
		   $("#gift_voucher").addClass('current');
		  if(data.code==1){
			  if( typeof use_coupon_voucher_list[ card_sn ] =="undefined" ){
				  use_coupon = parseFloat(data.amount);
				  use_coupon_voucher_list[ card_sn ] = use_coupon;
				  order_init();
			  }
		  }
		  if(data.code==2){
			  if( typeof use_coupon_voucher_list[ card_sn ] =="undefined" ){
				  use_vouchers = parseFloat(data.amount);
				  use_coupon_voucher_list[ card_sn ] = use_vouchers;
				  order_init();
			  }
		  }
	   }else{
		 baison.alert(data.msg);  
	   }
	   
	})
 }
//使用抵用券
function user_vouchers(obj, total){
	if($(obj).attr('chk')=='0'){
		$(obj).addClass("current").siblings().removeClass("current");
		$('li[name="vouchers"]').attr('chk','0');
		$(obj).attr('chk','1');			
	}else{
		$(obj).removeClass('current');
		$(obj).attr('chk','0');	
	}
	
	//更新
	var vouchers_sn = "";
	$('li[name=vouchers]').each(function(){
		if($(this).attr('chk')=='1'){
			vouchers_sn = $(this).attr('card_sn');	
		}		
	});
	if( typeof id != "undefined" && id !="" ){
		$.post("/orders/edit_vouchers&app_fmt=json&app_page=null",{id:id,vouchers:vouchers_sn},function(data){
			//编辑抵用券
			/*
			var data = $.parseJSON(data);
			if( data.code == 0 ){
				//0k
				order_init();
			}else{
				baison.alert(data.msg);
			}
			*/
			var is_market = 0;
			if($(obj).attr('pr_type')==1 && $(obj).hasClass('current')){
				is_market = 1;
			}
			//$(obj).addClass("current").siblings().removeClass("current");
			if(false){
				var url = $app_url+'orders/pay_info&is_market='+is_market+'&app_page=null';
				if( typeof id != "undefined" && id !="" ){
					url +="&is_active=2&type=_edit&id="+id;
				}
				Ajax.call(url,'',function(s){
					if(s !='') {
						$("#payinfo_list").html(s);
						//var $vouchers=$('li[name="vouchers"]');
						//$vouchers.removeAttr('checked').removeClass('current');
						
						//choose_vouchers();
						//order_init();
					}
				},'post','');
			}else{	
				order_init();
				//choose_vouchers();
			}
			
		});
	}else{
		//0k
		//order_init();
		var is_market = 0;
		if($(obj).attr('pr_type')==1 && $(obj).hasClass('current')){
			is_market = 1;
		}
		//$(obj).addClass("current").siblings().removeClass("current");
		if(false){
			var url = $app_url+'orders/pay_info&is_market='+is_market+'&app_page=null';
			if( typeof id != "undefined" && id !="" ){
				url +="&is_active=2&type=_edit&id="+id;
			}
			Ajax.call(url,'',function(s){
				if(s !='') {
					$("#payinfo_list").html(s);
					//var $vouchers=$('li[name="vouchers"]');
					///$vouchers.removeAttr('checked').removeClass('current');
					
					//choose_vouchers();
					order_init();
				}
			},'post','');
		}else{	
		
			order_init();
			//choose_vouchers();
		}
		
	}
	
	
	
	//order_init();
}
//编辑订单选择抵用券
function choose_vouchers(){
	var vouchers_sn = "";
	$('li[name=vouchers]').each(function(){
		if($(this).attr('chk')=='1'){
			vouchers_sn = $(this).attr('card_sn');	
		}		
	});
	if( typeof id != "undefined" && id !="" ){
		$.post("/orders/edit_vouchers&app_fmt=json&app_page=null",{id:id,vouchers:vouchers_sn},function(data){
			//编辑抵用券
			var data = $.parseJSON(data);
			if( data.code == 0 ){
				//0k
				order_init();
			}else{
				baison.alert(data.msg);
			}
		});
	}else{
		//0k
		order_init();
	}
}
//绑定抵用券
function binding_card(type, total_money){
	var order_url = $("#order_url").val();
	var params="app_fmt=json&pwd="+$('#id_'+type).val()+"&type="+type;
	Ajax.call('/index.php?app_act=mem_center/index/binding_card', params, 
			function (s){
			    if(s.statusCode!=0) {
				    baison.alert(s.status); 
			    }else {
			    	baison.alert(s.status);
					if(type == 'coupon') {
						var url = $app_url+'orders/get_user_info&app_page=null&app_fmt=json';
						Ajax.call(url, '', 
							function (u){		
								u = eval('('+u+')');
								$("#my_balance").html(u.user_money);
								//判断是否使用余额支付
								if($("input[type='checkbox'][name='use_balance']").attr('checked')) {
									user_balance(must_pay);
								}
								$("#use_coupon_id").hide();
								$("#use_coupon_id_title").click();
								$('#id_'+type).val('');
							}, 
							'POST', 
							'JSON'
						);
					  } else if (type == 'vouchers') {
						  if(s['data']['lowest_amount'] <= total_money) {
							  var str = $("#my_vourchers_list").html();
							  $("#my_vourchers_list").append('<li><input type=\"checkbox\" onclick=\"user_vouchers(this,'+must_pay+')\" mon=\"'+s['data']['card']['amount']+'\" name=\"vouchers\" value=\"'+s['data']['card']['card_sn']+'\"> 抵用券：'+s['data']['card']['card_sn']+'(可用金额：'+s['data']['card']['amount']+' 元)</li>');
						  }
						  $("#use_vouchers_id").hide();
						  $("#use_coupon_id_title").click();
						  $('#id_'+type).val('');
					  }
					}
			   }
		, 'POST', 'json');
}
//使用现金券
function user_coupon(obj, total){
	//$(obj).addClass("current").siblings().removeClass("current");
	var coumon_money = parseFloat($(obj).attr('mon'));
	if($(obj).attr('chk')=='0'){		
		$(obj).addClass("current");
		$(obj).attr('chk','1');
	}else{
		$(obj).removeClass("current");
		$(obj).attr('chk','0');
	}
	var coupon='';
	$('li[name="coupon[]"]').each(function(){
		if($(this).hasClass('current')){
			coupon+=','+$(this).attr('card_sn');
		}
	});
	if(coupon!=''){
		coupon = coupon.substring(1);
	}
	if( typeof id != "undefined" && id !="" ){
		$.post("/orders/edit_coupon&app_fmt=json&app_page=null",{id:id,coupon:coupon},function(data){
			//编辑抵用券
			var data = $.parseJSON(data);
			if( data.code == 0 ){
				//0k
				order_init();
			}else{
				baison.alert(data.msg);
			}
		});
	}else{
		//0k
		order_init();
	}
}
function use_last_balance(){
	if(last_balance>=final_price){
		last_balance=last_balance-final_price;
		use_balance=use_balance+final_price;
		final_price=0;
	}else{
		final_price=final_price-last_balance;
		use_balance=last_balance;
		last_balance=0;
	}
}
/**
 * 订单计算
 * @return
 */
function order_init(){	
	//初始化运费
	
	var is_cod = 0;
	$("[name=pay_id]").each(function(){
		if($(this).hasClass('current')){
			if($(this).attr('pay_code') == 'cod'){
				is_cod = 1;
			}
		}
	});
	$("[name=sid]").each(function(){
		if($(this).hasClass('current')){
			shipping_id = $(this).attr('sid_value');			
		}		
	});	
	if(is_cod){
		if(shipping_fee_cod_array.hasOwnProperty(shipping_id)){
			shipping_fee=parseFloat(shipping_fee_cod_array[shipping_id]);		
		}else{
			shipping_fee = 0;
		}
	}else{			
		if(shipping_fee_array.hasOwnProperty(shipping_id)){
			shipping_fee=parseFloat(shipping_fee_array[shipping_id]);		
		}else{
			shipping_fee = 0;
		}
	}
	$("#shipping_price").html(shipping_fee.toFixed(2));	
	
	//初始化金额
	final_price = final_goods_price + shipping_fee;	
	
	
	final_price = final_price - use_vouchers;
	
	final_price = final_price - use_coupon;
	
	$("#total_use_vouchers").html((use_coupon+use_vouchers).toFixed(2));
	
	//-----积分----------
	if($("input[type='checkbox'][name='use_integration']").attr("checked")){
		use_integral = $('#pay_point').val()*integration_rate;
	}else{
		$("#pay_point").val("");
		use_integral = 0;
	}
	
	if(final_price>use_integral){
		final_price = final_price - use_integral;
	}else{
		use_integral = final_price;
		final_price = 0;		
	}	
	//$("#integrate_monney_id").html(use_integral.toFixed(2));	
	
	//余额
	if($("#use_balance").hasClass('current')){
		use_balance = my_balance;		
	}else{
		use_balance = 0;
	}
	
	if(final_price>use_balance){
		final_price = final_price - use_balance;
	}else{
		use_balance = final_price;
		final_price = 0;		
	}
	//$("#user_pay_monney_id").html(use_balance.toFixed(2));
	
	if(final_price>=0) {
		$('#must_pay').html(final_price.toFixed(2));
	}else {
		$('#must_pay').html(0);
	}
	$(".ticket_list").each(function(){
        if($(this).hasClass('order_selected')){
      	ticket_attr=$(this).find('span').attr('ticket_attr');
          }
        })
	$(".ticket_content").each(function(){
        if($(this).hasClass('ticket_select')){
      	ticket_type=$(this).find('span').attr('ticket_type');
          }
        })
	
}
//个人||公司
function check_man(){
	$("#inv_content").toggle();
}
//是否需要发票
function invoice(flag){
	need_bill=flag;
	$('#invoice_content').toggle();
}
var button='';
function checkForm(returnurl,gotourl,type,sn){

	var msg='';
	var remark = $("#remark");
	if(remark.length>0 && remark.val() !='') {
		remark_value = remark.val();
		var remark_num = countByteLength(remark_value, 1);
		if(remark_num>200) {
			baison.alert('留言不能超过200字');
			return false;
		}
	}
	
	var curr_addr=$('[name="address"]');
	var address_id = 0;	
	curr_addr.each(function(){
		if($(this).hasClass('order_selected')){
			address_id = $(this).attr('add_value');	
		}
	});	
	if(typeof address_id == 'undefined'){
		msg+="请选择送货地址\n";
	}else if(address_id == 0){
		msg+="请提交送货地址\n";
	}
	
	if(payment_id==0){
		msg+="请选择支付方式\n";
	}
	if(ticket_type==1){
		if($("#invoice_title").val()==""){
		msg+="请输入公司抬头\n";
		}
	}
	 
	if(shipping_id==0){
		msg+="请选择配送方式\n";
	}else{
		$('[name="pay_id"]').each(function(){	
			if($(this).hasClass('current')){
				if($(this).attr('pay_code')=='cod'){
					shipping = $('#is_cod_'+shipping_id).val();
					if(shipping==0){
						msg+="该配送方式不支持货到付款！\n";
					}
				}
			}
		});
	}
	var last_payment_id = 0;
	$('[name="pay_id"]').each(function(){	
		if($(this).attr('checked')) {
			last_payment_id = $(this).attr('pay_value');
			return false;
		}
	})
	if(last_payment_id == 0){
		var total_money = parseFloat($('#must_pay').html() ) || parseFloat( $('#pay_only').html());
		if( total_money > 0 && payment_id > 0 ){
			msg+="请选择支付方式\n";
		}
	}
	order_all_fee=final_goods_price+shipping_fee;
	order_after_rate=order_all_fee*order_rate;
	pay_point_money=parseInt($('#pay_point').val())*integration_rate;
    if(order_after_rate<pay_point_money){
    	msg+="积分支付只能占订单的"+order_rate*100+'%';
    }
	if(msg==''){
		var params = '';
		button=$('#suborderbutton').html();
		$('#suborderbutton').html("<font color='#BC9A55' style='float:right;'>提交中……</font>");
		if(type != ''){
			params='type='+type;
		}
		if(sn!=''){
			params+='&order_sn='+sn;
		}
		$.post($app_url+'carts/check_cart_stock&app_page=null&app_fmt=json', params, 
			function (s){
				//s=eval('('+s+')');
				if(s.code==0){
					delaycheck(returnurl,gotourl,type,sn);
					return true;
				}else{
					msg='';
					if(s.msg!=null && s.msg.length>0){
						msg+=s.msg;
					}
					if(s.gift_list!=null && s.gift_list.length>0){
						msg+='以下商品：\n';
						for(i=0;i<s.gift_list.length;i++){
							msg+=s.gift_list[i].name+'　'+s.gift_list[i].ext_attr+'\n';
						}
						msg+='赠品不允许单独购买';
					}
					if(s.sell_list!=null && s.sell_list.length>0){
						msg+='以下商品：\n';
						for(i=0;i<s.sell_list.length;i++){
							msg+=s.sell_list[i].name+'　'+s.sell_list[i].ext_attr+'\n';
						}
						msg+='已下架';
					}
					if(s.stock_list!=null && s.stock_list.length>0){
						msg='以下商品：\n';
						for(i=0;i<s.stock_list.length;i++){
							msg+=s.stock_list[i].name+'　'+s.stock_list[i].ext_attr+'\n';
						}
						msg+='库存不足';
					}
					if(s.second_list!=null && s.second_list.length>0){
						msg='以下商品：\n';
						for(i=0;i<s.second_list.length;i++){
							msg+=s.second_list[i].name+'\n';
						}
						msg+='秒杀已结束';
					}
					baison.alert(msg,function(data){location.href='/fkwap/d_orders/failture';});
					//msg+='\n<a href="/">前往首页</a>&nbsp;&nbsp;&nbsp;<a href="javascript:history.back();">返回</a>';
					//$('#suborderbutton').html(button);
					//baison.alert(msg);
				}
			}, 'json'
		);
	}else{
		baison.alert(msg);
	}
}

function delaycheck(returnurl,gotourl,type,sn){
	//var curr_addr=$("li[name='address'][checked]");
	//var address_id = curr_addr.attr('add_value');
	var curr_addr=$("[name='address']");
	var address_id = 0;	
	curr_addr.each(function(){
		if($(this).hasClass('order_selected')){
			address_id = $(this).attr('add_value');	
		}
	});	
	var param='address_id='+address_id+'&payment_id='+payment_id+'&shipping_id='+shipping_id+'&need_bill='+need_bill;
	if($('#remark').length>0){
		param+='&remark='+$('#remark').val();
	}
	/*
	if(need_bill){
		if($('#inv_payee').length>0){
			if($('#inv_payee:checked').val()!='个人'){
				param+='&inv_payee='+$("#inv_content").val();
			}else{
				param+='&inv_payee='+$('#inv_payee:checked').val();
			}
		}
		if($('#inv_content').length>0){
			param+='&inv_content='+$('#inv_content').val();
		}
	}
	*/
	//判断发票
	
	  param +="&inv_payee="+$("#invoice_title").val();	
	  var inv_attr=ticket_type+','+ticket_attr;
      param +="&inv_attr="+inv_attr;
	
	
	
	if(typeof(shipping_fee)!="undefined"){
		param+='&shipping_fee='+shipping_fee;
	}
	if($('#stairs_fee').attr('checked')){
		param+='&stairs_fee=1';
	}
	if($('#fix_fee').attr('checked')){
		param+='&fix_fee=1';
	}
	if($('#use_integration').attr('checked')){
		param+='&integral='+$('#pay_point').val();
	}
	if($("#use_integration").attr('checked')){
		param+='&points_pay=1';
	}
	if(use_coupon!=''){
		param+='&coupon='+card_sn;
	}
	if(use_vouchers){
	 param+='&vouchers='+card_sn;
	}
	var best_time='';
	$('[name=best_time]').each(function(){
		if($(this).attr("checked")){
			best_time=$(this).val();
		}
	});
	if(best_time!=''){
		param+='&best_time='+best_time;
	}
//	alert(param);return ;
	/*
	var user_money = parseFloat($("#user_money").val());
	if(user_money >0) {
		param+='&user_money='+user_money;
	}
	*/
	var user_money = 0;//余额支付金额
	if($("[name='use_balance']").hasClass('current')) {
		user_price = my_balance;
		user_money = my_balance; 
		param+='&user_money='+user_money;
	}
	switch(type){
		case 'returns':
			var act = 'return_order';
			break;
		case 'edit':
			var act = 'edit_order';
			break;
		default:
			var act = 'add_order';
			break;
	}
	
	if(sn!=''){
		param+='&order_sn='+sn;
	}
	$.post($app_url+'orders/'+act+'&app_fmt=json', param, 
		function (s){	
			if(s.code==0){
				location.href=gotourl+"&order_sn="+s.order_sn;
			}else if(s.code==2){
				baison.alert(s.msg,function(data){location.href='/fkwap/d_orders/failture';});
				//location.href = '/';
			/*
			}else if(s.code==1){
				alert(s.msg);
				location.href = '/user/index/';
			*/
			}else{
				baison.alert(s.msg,function(data){location.href='/fkwap/d_orders/failture';});
				//baison.alert(s.msg);
				//$('#suborderbutton').html(button);
				return false;
			}
		}, 'json'
	);
}
function check_phone(url){
	var phone=$("#phone").val();
	if(phone.length==11){
		$.post('/fkwap/index/check_phone&app_fmt=json',{teleNumber:phone},function(s){
			s=eval('('+s+')');
			
			if(s.statusCode==1){
				$("#title_msg").css('display','block');
				//$("#title_msg").html("<span style='color:red'>该手机号已经注册官网</span><input type=\"text\"><div class='getCode' onclick=\"location.href='"+url+"'\" >立即登录</div>").css("display","block");
				$("#free_code").css("display","none");
				$("#li_code").css("display","none");
			}else if(s.statusCode==2){
				$("#title_msg").html("").hide();
				$("#free_code").css("display","block");
				$("#li_code").show();
			}else{
				$("#title_msg").html("请手机号保持畅通!");
			}
		});
	}
}
var index=60;
function change_time(){
	$("#free_code").html(index+"秒后重新获取");
	$("#free_code").addClass("free_code");
	$("#free_code").unbind("click");
	if(index>0){
		index--;
		setTimeout("change_time()",1000);
	 }else{
		 $("#free_code").html("重新获取");
		 $("#free_code").removeClass("free_code");
		 index=60;
		 $.post('/fkwap/index/des_code&app_fmt=json','',function(){
		     $("#free_code").bind("click",function(){
		    	 get_phoneCode();
		     });
		});
    }
}
function get_phoneCode(){
	$("#check_code").focus();
	var pattern=/^1[358]\d{9}$/;
	var tele_value=$("#phone").val();
	if(tele_value==""){
	    baison.alert("请输入手机号");
	}else if(!pattern.test(tele_value)){
        baison.alert("请输入正确的手机");
	}else{
		/*********************/
		var teleNumber=$("#phone").val();
		$.post('/fkwap/index/check_phone&app_fmt=json',{teleNumber:teleNumber},function(s){
			s=eval('('+s+')');
			if(s.statusCode==1){
				//$("#title_msg").html("<span style='color:red'>该手机号已经注册官网</span><input type=\"text\"><div class='getCode' onclick=\"location.href='"+url+"'\" >立即登录</div>").css("display","block");
				$("#title_msg").css('display','block');
				$("#free_code").css("display","none");
				$("#li_code").css("display","none");
			}else if(s.statusCode==2){
				
				$.post("/fkwap/index/send_phone&app_fmt=json",{teleNumber:teleNumber},function(){
		             change_time();
		            $("#title_msg").html("").hide();
					$("#free_code").css("display","block");
					$("#li_code").css("display","block");
				});
				
			}else{
				
				$("#title_msg").html("请手机号保持畅通!");
			}
		});
		/*********************/
	}
}
$(document).ready(function(){
	$("#invoice").click();
	shipping_fee=0;
	shipping_id=0;//select_shipping
	is_shipping_free=0;//shipping_free
	
	final_price=parseFloat($('#baseprice').val());
	my_balance=parseFloat($("#my_balance").val());
	
	final_goods_price=final_price;

	var curr_addr=$(".order_selected");	
	if(curr_addr.length>0 && curr_addr.attr('value')!=0){
		get_shipping_payment(curr_addr.attr('value'),$("li[name='address'][checked]"),'')
	};
	
	$("#free_code").bind("click",function(){
		get_phoneCode();
	});
	/*
	if( $("#addressForm1").size() >0 ){
		$("#addressForm1").validate({
			event:"blur",
			rules:{
				consignee:{
					required:true,
		            string:true
				},
				province:{
					required:true,
					min:1
				},
				city:{
					required:true,
					min:1
				},
				region:{
					required:true,
					number:true
				},
				address:{
					required:true,
					string:true,
					maxlength:240
				},
				
				tel01:{
					number:true,
					TelAll:true
				},
				tel02:{
					number:true,
					TelAll:true
				},
				tel03:{
					number:true,
					TelAll:true
				},
				phone:{
					MobileOrPhone:true,
					isMobile:true
				},
				check_code:{
					required:true,
					number:true
				}
			},
			message:{
				consignee:{
					required:"请填写联系人",
				},
				address:{
					required:"请填写地址",
					string:"地址只能是字符",
					maxlength:"地址长度不能超过240"
				},
				province:{
					required:"请选择省份"
				},
				city:{
					required:"请选择城市"
				},
				region:{
					required:"请选择所在区域"
				},
				
				check_code:{
					required:"请填写验证码",
					number:"验证码为数字"
				}
			},
			showErrors:showErrors,
			focusInvalid:false,
			onkeyup:false,
			submitHandler:function(form){
				var consignee=$("#consignee").val();
				var province=$("#province").val();
				var city=$("#city").val();
				var region=$("#region").val();
				var address=$("#address").val();
				var zipcode=$("#zipcode").val();
				var tel01=$("#tel01").val();
				var tel02=$("#tel02").val();
				var tel03=$("#tel03").val();
				tel=tel01;
				if(tel02!='') tel +='-'+tel02;
				if(tel03!='') tel +='-'+tel03;
				var phone=$("#phone").val();
				var check_code=$("#check_code").val();
				//验证手机号并检查是否存在，存在则登陆，不存在则注册
				if($("#li_code").css("display")!="none"){
					Ajax.call('/index.php?app_act=orders/sub_order','&app_page=null&app_fmt=json&check_code='+check_code+'&phone='+phone,function(data){
						if(data.code==0){//验证成功并且登陆
							var address_id=$("#address_id").val();
							var params="&app_page=null&app_fmt=json&consignee="+encodeURI(consignee)+"&province="+province+"&city="+city+"&district="+region+"&address="+encodeURI(address)+"&zipcode="+zipcode+"&tel="+tel+"&mobile="+phone;
							if($("#default_address:checked").size()>0){
								params+="&default_address=1";
							}
							if(address_id!=0){
								var url="/index.php?app_act=orders/update_address&";
								params+="&address_id="+address_id;
							}else{
								var url="/index.php?app_act=orders/add_address";
							}
							Ajax.call(url,params,function(s){
								if(s.statusCode==0){
									window.top.location='/orders/';
								}else{
									baison.alert(s.status);
								}
							},'POST','json');
						}else{
							baison.alert(data.status);
						}
					},'POST','json');
				}else{
					baison.alert("请您登录后再提交订单");
				}
			}
		});
	
	}*/
});   