function quick_buy(goods_sn,a){
	var choose_num =1;//快速购买
	Ajax.call('/index.php?app_act=goods/get_info&app_fmt=json&app_page=null&goods_sn='+goods_sn, '', 
			function (s){
				if(s.code==1){
					baison.alert(s.msg);
				}else{
					//获得价格 价格类型
					var goods_price=(s.product_info.goods_info.sales_type==4)?s.product_info.goods_info.price_promo:s.product_info.goods_info.price_current;
					var goods_type=(s.product_info.goods_info.sales_type==4&&s.product_info.goods_info.promo_begin<=0&&s.product_info.goods_info.promo_end>=0&&s.product_info.goods_info.is_active)?"promos":"common";
                    if(a==1){
                        go_to_cart(s.msg.sku_sn,choose_num,goods_price,goods_type,'order',goods_sn);
                    }
                    if(a==2){
                        go_to_cart(s.msg.sku_sn,choose_num,goods_price,goods_type,'cart',goods_sn);
                    }
				}
			}	, 'GET', 'json'); 
}
function go_to_cart(sku,choose_num,goods_money, action,gotype,goods_sn) {//加入到购物车
	if(sku !='') {
		var url='/index.php?app_act=goods/add_product_to_cart&app_page=null&app_fmt=json';
		url+='&sku_sn='+encodeURI(sku.substring(0, sku.length),'UTF-8');
		//url+='&ext_attr_info='+encodeURI(ext_attr_info,'UTF-8');
		url+='&choose_num='+choose_num;
		url+='&price='+goods_money;
		url+='&action='+action;
		url+='&type='+action;
		if(action=='second'){
			url+='&checknumber='+$('#checknumber_spkie').val();
		}
		ajaxcheck('open_title',url,'',action,gotype,goods_sn);
	}else {
		baison.alert('赠品不能购买');
	}
}
function interval(day, hour, minute, second,divid){
	
	if(second>0) second--;
	if(second==0){
		if(minute==0){
			if(hour==0) minute=0;second=0;
		}else{
			second=60;minute-=1;
		}
	}
	if(minute==0){
		if(hour==0){
			minute=0;hour=0;
		}else{
			minute=60;hour-=1;
		}
	}
	
	//var content=day+"<em class='fm f14'>天</em>"+hour+"<em class='fm f14'>小时</em>"+minute+"<em class='fm f14'>分</em>"+second+"<em class='fm f14'>秒</em></span>";
  
     document.getElementById(divid).innerHTML=day+"天"+hour+"小时"+minute+"分"+second+"秒";
	window.setTimeout(function (){interval(day, hour, minute, second, divid)},1000);
	//clearTimeout(iTimeoutID)
}
function interval1(day, hour, minute, second,divid){
	if(second>0) second--;
	if(second==0){
		if(minute==0){
			if(hour==0) minute=0;second=0;
		}else{
			second=60;minute-=1;
		}
	}
	if(minute==0){
		if(hour==0){
			minute=0;hour=0;
		}else{
			minute=60;hour-=1;
		}
	}
	$("#"+divid).val(day+"天"+hour+"小时"+minute+"分"+second+"秒 开始");
	window.setTimeout(function (){interval1(day, hour, minute, second, divid)},1000);
}

function get_class(obj) {
	var class_str ='';
	class_arr = $(obj).attr('class').split('_');
	var len =class_arr.length;
	var new_class_arr = new Array();
	for(var i=0; i<len; i++) {
		if(class_arr[i] !='curr') {
			new_class_arr[i] = class_arr[i];
		}
	}
	return new_class_arr.join("_");
}

//以下分页方式为无刷新
function _doPost(cType){
	var url = $url;
	var svalue=$("#search_box").val();
	var pvalue=$("#search_box").attr('promptvalue');
	url += getLinkStr()+getOrders(cType);
	page_ajax(1,url,'showGoodsLists');	
}
function getLinkStr(){
	
	var str = "";
	$('a[group]').each(function(){
		if( $(this).parent().hasClass("current") ){
			if ($(this).attr('value')) {
				if($(this).attr('attr_group')){
					str += '&' + $(this).attr('group') + '='+$(this).attr('value') + ',' + $(this).attr('key');
				}else{
					str += '&' + $(this).attr('group') + '=' + $(this).attr('value');
				}
			} else {
				if($(this).attr('attr_group')){
	
				}else{
					str += '&' + $(this).attr('group') + '=0';
				}				
			}
		}
	});
	return str;
}
function getOrders(cType){
	
	var str = "";
	var orderby="";
	$('[cType="order_id"]').each(function(){
		if ($(this).attr('selected')) {
			orderby=$("#order"+$(this).attr('value')).val();
			str += '&' + $(this).attr('cType') + '=' + $(this).attr('value');
			return false;
		}
	});
	
	if (cType == 'order_id') {
		$('[cType="order_id"]').each(function(){
			if ($(this).attr('selected')) {
				$("#order"+$(this).attr('value')).val(1-orderby);
				if(1-orderby){
					$(this).addClass('up');
				}else{
					$(this).addClass('down');
				}
				$(this).addClass('current');
				return false;
			}
		});
	} else {
		$('[cType="order_id"]').each(function(){
			if ($(this).attr('selected')) {
				orderby=$("#order"+$(this).attr('value')).val();
				orderby = 1 - orderby;
				return false;
			}
		});
	}
	
	str += '&orderby='+orderby;
	$show = $('[view="show"]');
	str += '&' + $show.attr('view') + '=' + $show.attr('value');
	return str;
}
//以下分页方式为页面跳转
function _doJumpPost(cType){
	var url = $url;
	var svalue=$("#search_box").val();
	var pvalue=$("#search_box").attr('promptvalue');
	
	if($url == '/list'){
		url += "-"+$cid;
	}else{
		if(svalue!=pvalue){
			url += "-"+svalue;
		}else{
			url += "-0";
		}
	}
	url += getJumpLinkStr()+getJumpOrders(cType);
	location.href=url+".html";
}
function getJumpLinkStr(){
	var str = "";
	$('[group][class="pr current"]').each(function(){
		if ($(this).attr('value')) {
			if($(this).attr('attr_group')){
				str += '-'+$(this).attr('value') + ',' + $(this).attr('key');
			}else{
				str += '-' + $(this).attr('value');
			}
		} else {
			str += '-0';
		}
	});
	return str;
}
function getJumpOrders(cType){
	var str = "";
	var orderby="";
	$('[cType="order_id"]').each(function(){
		if ($(this).attr('selected')) {
			orderby=$("#order"+$(this).attr('value')).val();
			str += '-' + $(this).attr('value');	
			return false;
		}
	});
	
	if (cType == 'order_id') {
		$('[cType="order_id"]').each(function(){
			if ($(this).attr('selected')) {
				$("#order"+$(this).attr('value')).val(1-orderby);
				if(1-orderby){
					$(this).addClass('screenUp');
				}else{
					$(this).addClass('screenUp_curr');
				}
				$(this).addClass('screenSelect');			
				return false;
			}
		});
	} else {
		$('[cType="order_id"]').each(function(){
			if ($(this).attr('selected')) {
				orderby=$("#order"+$(this).attr('value')).val();
				orderby = 1 - orderby;
				return false;
			}
		});
	}
	
	str += '-'+orderby;
	$show = $('[view="show"]');
	str += '-' + $show.attr('value');
	return str;
}

$(document).ready(function() {
	$('[group]').click(function(){
		var group_value = $(this).attr('group');
	   	$('[group="'+group_value+'"]').parent().removeClass('current');
	   	//$('[group="'+group_value+'"][ts="1"]').attr('ts',0);
	   	
		if($(this).attr('ts')==0) {
			$(this).parent().addClass('current');
			if( $(this).attr("parent") == "parent" ){
				$(".second_cate div").each(function(){
					$(this).addClass("none");
				})
				if( $(".cat_"+$(this).attr('value') ).size() >0 ){
					$(".cat_"+$(this).attr('value') ).removeClass("none");
				}
			}
			$('[group="'+group_value+'"]').attr('ts',0);
			$(this).attr('ts',1);
		}else {
			$('[group="'+group_value+'"]').attr('ts',0);
			$('[group="'+group_value+'"][type="all"]').addClass('current');			
		}
		_doPost('');
	});
	$("[cType]").click(function(){
		var objSiblings = $(this).siblings();
		if (objSiblings.size() != 0) {
			objSiblings.removeClass('current').removeClass('up').removeClass("down");
			objSiblings.removeAttr('selected');
		}
		if (!$(this).attr('selected')) {
			$(this).attr('selected', true);
		}
		$(this).removeClass('up').removeClass('down').removeClass('current');
		_doPost($(this).attr('cType'));
	});
	$("[view]").click(function() {
		$(this).toggleClass("list-toggle-curr");
		if ($(this).attr('view') == 'show') {
			if ($(this).attr('value') == 0) {
				$("#show").val(1);
				$(this).attr('value', '1');
			} else {
				$("#show").val(0);
				$(this).attr('value', '0');
			}
		}
		_doPost($(this).attr('view'));
	});	
});