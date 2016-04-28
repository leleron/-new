$(document).ready(function() {	
	var $params = $('a[type]');
	var attr_len = all_names.length;
	var select_index = new Array(attr_len);
	var select_value = new Array(attr_len);
	var select_str ='';
	for(var i=0;i<attr_len;i++) {
		select_value[i] = '[\\s\\S]*';
	}
	$params.click(function (){
		$("#ext"+$(this).attr('index')).html($(this).attr('value') );
		if($(this).attr('disabled')=='true') return false;
		$(this).addClass('current');		
		if (!$(this).attr('selected')) {
				var objSiblings = $(this).siblings('[selected]');
				if (objSiblings.size() != 0) {
						objSiblings.removeClass('current');
						objSiblings.removeAttr('selected');
				}	
		}
		$params.each(function(){
			$(this).attr('ts', 0);
		});
		$(this).attr('selected', true);
		$params.each(function(){
			if($(this).attr('selected')) {
				select_index[$(this).attr('index')] = $(this).attr('index');
				select_value[$(this).attr('index')] =$(this).attr('value');
			}
		});
		var opt = -1;
		for(var i=0;i<attr_len;i++) {
			if (select_value[i] != '[\\s\\S]*')
				opt++;
		}
		select_str = select_value.join(',');
		select_str = select_str.replace('/^[\,\b]$/','');
		select_str = select_str.replace(/(\()/g,"\\(");	
		select_str = select_str.replace(/(\))/g,"\\)");
		//替换+
	 	var tmp_str = select_str = select_str.replace(/(\+)/g,"\\+");
		//替换*
		select_str = select_str.replace(/(\*)/g,"*\\*");
		var tmp_reg = select_str +"|"+tmp_str;
		var current_index = $(this).attr('index');
		var current_value = $(this).attr('value');
		var select_status = false;
		for (var i = 0; i < all_value_arr.length; i++) {
			if(all_value_arr[i].match(tmp_reg)) {
				select_status = true;
				break;
			}
		}	
		if(!select_status){
			for(var k=0; k < select_value.length; k++) {
				if(k > 0) {
					select_value[k] = '[\\s\\S]*';
					$("a[index="+k+"]").each(function(){
						$(this).removeClass('current');
						$(this).removeAttr('selected');
					});
				}
			}
			$("a[type][value='"+select_value[0]+"']").click();
			return false;
		}
		for (var i = 0; i < all_value_arr.length; i++) {
			var arr = all_value_arr[i].split(',');// 酱紫,XXL
			for(var j=0 ; j<arr.length;j++) {
				if(j!=current_index && arr[current_index] == current_value) {
					$params.each(function() {
						//if (all_value_arr[i].match(select_str)) {
						if ($(this).attr('index') == j) {
							if ($(this).attr('value') != arr[j]) {
								if ($(this).attr('ts') == 0 && j>opt) {
									 $(this).hide();
									$(this).attr('disabled', true);
									//$(this).removeClass('select_disabled_false').addClass('select_disabled_true');
								}
							}else {
								$(this).attr('ts', 1);
								$(this).show();
								$(this).attr('disabled', false);
								//$(this).removeClass('select_disabled_true').addClass('select_disabled_false');
							}
						}						
					});
				}
			}	
		}	
		if(opt == attr_len-1 ) {
			select_str = select_str.replace(/(\\\))/g,"\)");	
			select_str = select_str.replace(/(\\\()/g,"\(");
			select_str = select_str.replace(/(\\\+)/g,"\+");
			select_str = select_str.replace(/(\\\*)/g,"");
			var sku ='';
			for(var i=0; i<all_value_arr.length;i++) {
				if(all_value_arr[i] == select_str) {
					sku = all_inventory_skus[i];
					break;
				} 
			}
			sku = sku.substring(1, sku.length-1);			
			if(sku!=''){
				Ajax.call('/index.php?app_act=goods/get_sku_price&app_page=null&app_fmt=json&sku_sn='+sku, '', 
					function (s){
						if(goods_type=='common'){
							$("#price_current").html(s.price);
							goods_price = s.price;
							$("#actual_number").html(s.number);
						}
						if(s.number <=0) {
							$("#add_detail_shop_cart").hide();
							$("#send__mail_to_user").show();
						}else {
							$("#add_detail_shop_cart").show();
							$("#send__mail_to_user").hide();
						}
					}	, 'GET', 'json'); 
			}else{
				var _attr_len = attr_len-1;
				if(opt > $(this).attr('index')){
					opt = $(this).attr('index');
					for(var i=_attr_len;i>opt;i--){
						select_value[i] = '[\\s\\S]*';					
						$("a[index="+i+"]").each(function(){
							$(this).removeClass('imgselect');
							$(this).removeAttr('selected');
						});
					}
				}else if(opt == $(this).attr('index')){
					select_value[opt] = '[\\s\\S]*';
					$("#actual_number").html(0);
				}
			}
		}
		$("#select_value").html("你选择的是："+select_str.replace(/(\[\\s\\S\]\*)|(,)/g," ")).show();	
	});  
	//商品详情页第一个颜色、尺码，默认让它选中	
	$(".prodetails a[cname]").each(function(){
		$(this).click();
	});

	//商品详情页面添加、减少购物商品
	$(".add,.reduce").click(function(){
		var i=0;
		var status = true;
		var all_names_len = all_names.length;
		var choose_num = parseInt( $('input[name=choose_num]').val() );
		var actual_number = parseInt( $('#actual_number').val() );
		for( i = 0 ; i < all_names_len ; i++  ){
			$("a[type='ext_attr'][index='"+i+"']").each(function(){
				if( $(this).attr('selected') ){
					status = true;
					return false;
				}else{
					status = false;
				}
			});
			if( !status ){
				baison.alert('请选择'+all_values[i]);
				break;
			}
		}
		if( status ){
			if ( !isNaN( choose_num ) ) {
				if( $(this).attr('class')=='add' ){
					if( actual_number <=0 || choose_num >= actual_number ){
						baison.alert('商品库存少于'+( actual_number+1 )+'件');return;
					} else {
						choose_num++;
						$('input[name=choose_num]').val( choose_num );
					}
				}else{
					if( choose_num <= 1 ){
						baison.alert('购买商品至少一件！');return;
					}else{
						choose_num--;
						$('input[name=choose_num]').val( choose_num )
					}
				}
			}else{
				baison.alert('请填写数字！');return;
			}
		}
	});
	
});
function interval(day, hour, minute, second,divid)
{
	if(second>0) second--;
	if(second==0)
	{
		if(minute==0)
		{
			if(hour==0) minute=0;second=0;
		}
		else
		{
			second=60;minute-=1;
		}
	}
	if(minute==0)
	{
		if(hour==0)
		{
			minute=0;hour=0;
		}
		else
		{
			minute=60;hour-=1;
		}
	}
	$("#"+divid).html(day+' 天 '+hour+' 小时 '+minute+' 分 '+second+' 秒 ');
	window.setTimeout(function (){interval(day, hour, minute, second, divid)},1000);
}
var choose_num="";
var buy_user_id='';
var buy_goods_price=0;
function add_shop_cart_promos(uid){	
	if(uid==''){
		window.location.href="/user/index/do_index?return="+encodeURIComponent(location.pathname+"?goods_sn="+buy_goods_sn);	
	}
	var choose_num = $("#choose_num").val();
	var _str = '';
	var status = true;
	var select_pro ='';
	for(var i=0; i<all_names.length;i++) {
		$("a[type='ext_attr'][index='"+i+"']").each(function (){
			if($(this).attr('selected')) {
				_str += '&' + $(this).attr('name') + '=' + $(this).attr('value');
				select_pro += $(this).attr('value')+',';
				status = true;
				return false;
			}else {
				status = false;
			}
		});
		if(!status) {
			baison.alert('请选择属性 '+all_values[i]+' 的值');
			break;
		}
	}
	if(!status) {
		return false;
	}
	select_pro =select_pro .substring(0, select_pro.length-1);
	var sku ='';
	for(var i=0; i<all_value_arr.length;i++) {
		if(all_value_arr[i] == select_pro) {
			sku = all_inventory_skus[i];
			break;
		} 
	}
	var pass=false;	
	Ajax.call($app_url+'goods/check_cart_sum&app_fmt=json&app_page=null', '', 
		function (s){
			if(s.code==1){
				baison.alert(s.msg);
			}else{
				pass=true;
				show_box(sku,buy_goods_sn,buy_user_id,choose_num,buy_goods_price,buy_goods_type);
			}
		}	, 'GET', 'json'); 
}
function show_box(sku,goods_sn,userid,goods_num,goods_money,action){
	if(sku !='') {
		var ext_attr_info ='';
		for(var i in ext_all_desc) {
			if(ext_all_desc[i] == sku) {
				ext_attr_info = ext_all_desc_value[i];
				break;
			}
		}

	if(goods_num<=0){
		goods_num=1;
	}
	var url=$app_url+'spike/add_product_to_cart&app_fmt=json&app_page=null';
	url+='&sku_sn='+sku.substring(1, sku.length-1);
	var param='goods_sn='+goods_sn;
	param+='&ext_attr_info='+encodeURI(ext_attr_info,'UTF-8');
	param+='&goods_num='+goods_num;
	param+='&price='+goods_money;
	param+='&action='+action;
	Ajax.call(url, param, 
		function (s){
			//s=eval('('+s+')');	
			if(s.code==0){
				window.location.href='/orders/';
			}else{
				$('#vCode').attr('src','/printpic/do_index?type=spike&'+ Math.random());
				baison.alert(s.msg);
			}
	   }
	, 'POST', 'json');
	}
}
function go_show_order(user_id) {
	if (user_id == '') {
		$('#vCode').click();
		$('#btn_login').click();
	} else {
		if ($("#show_order_comment").css('display') == 'none') {
			Ajax.call('/index.php?app_act=goods/check_show_order_buy&app_page=null&goods_sn='+goods_sn, '', 
					function (s){
						s=eval('('+s+')');	
						if(s.code == 0) {
							$("#show_order_comment").show();
						} else {
							baison.alert(s.msg);
						}
					}	, 'GET', ''); 
		} else {
			$("#show_order_comment").hide();
		}
	}
}