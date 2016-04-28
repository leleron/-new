$(document).ready(function() {
	//小图片的轮转
	$(".picList").scrollList({prev:'.btnPrevious',next:'.btnNext'});	
	var $params = $('a[type][code]');
	var attr_len = all_names.length;
	var select_index = new Array(attr_len);
	var select_value = new Array(attr_len);
	var select_str ='';
	for(var i=0;i<attr_len;i++) {
		select_value[i] = '[\\s\\S]*';
	}
	$(".add").click(function() {
		$obj = $(this).prev("input[type='button']");
		var num = parseInt($obj.val());
		if (isNaN(num)) {
			$obj.val(1);
		} else {
			$obj.val(num+1);
		}
		//$("#choose_num").val(num+1);
	});
	$(".reduce").click(function() {
		$obj = $(this).next("input[type='button']");
		var num = parseInt($obj.val());
		if (num <= 1)
		{
		return false;
		}
		if (isNaN(num)) {
			$obj.val(1);
		} else {
			$obj.val(num-1);
		}
	});
	$params.click(function (){
		$("#ext"+$(this).attr('index')).html($(this).attr('value') );
		if($(this).attr('disabled')=='true') return false;		
		$(this).removeClass('current').addClass('current');
		$f_obj = $("a[type][code='"+$(this).attr('code')+"'][index="+$(this).attr('index')+"]");
		$f_obj.removeClass('current').addClass('current');
		
		if (!$(this).attr('selected')) {
			var objSiblings = $(this).siblings('[selected]');
			var f_objSiblings = $f_obj.siblings('[selected]')
			
			if (objSiblings.size() != 0) {
					objSiblings.removeClass('current');
					objSiblings.removeAttr('selected');
			}
			if (f_objSiblings.size() != 0) {
				f_objSiblings.removeClass('current');
				f_objSiblings.removeAttr('selected');
			}
		}
		$params.each(function(){
			$(this).attr('ts', 0);
		});
		$(this).attr('selected', true);
		$f_obj.attr('selected', true);
		
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
				var choose_num = $("input[id='choose_num']").val();
				Ajax.call('/index.php?app_act=goods/get_sku_price&app_page=null&app_fmt=json&sku_sn='+encodeURI(sku,'UTF-8')+'&goods_number='+choose_num, '', 
					function (s){
						if( goods_type=='common' || goods_type=='promos' ){
							$("#price_current").html(s.price);
							goods_price = s.price;
							$("#actual_number").html(s.number);
						}
						/*if(s.number <=0) {
							$("#add_detail_shop_cart").hide();
							$("#send__mail_to_user").show();
						}else {
							$("#add_detail_shop_cart").show();
							$("#send__mail_to_user").hide();
						}*/
					}	, 'GET', 'json'); 
			}else{
				var _attr_len = attr_len-1;
				if(opt > $(this).attr('index')){
					opt = $(this).attr('index');
					for(var i=_attr_len;i>opt;i--){
						select_value[i] = '[\\s\\S]*';					
						$("a[index="+i+"]").each(function(){
							$(this).removeClass('current');
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
		/**判断是不是有组合购买 start*/
		if($('#gourp_select_'+goods_sn)) {
			var all_product_ext =  new Array(all_names.length);
			for(var k = 0; k < all_product_ext.length; k++) {
				all_product_ext[k] = '';
			}
			$("a[name][value]").each(function(){
				if($(this).attr('selected'))
					all_product_ext[$(this).attr('index')] = $(this).attr('value');
			})
			var select_product_propro = '<div class="current-chose pa clearfix b0 l0 tl"><b>当前选择：</b><dl class="clearfix pr">';
			for(var k = 0; k < all_product_ext.length; k++) {
				if(k > 0){
					if(all_product_ext[k] != '') {
						select_product_propro +='<dt class="ml15">'+all_values[k]+'：</dt><dd>'+all_product_ext[k]+'</dd>';
					}
				} else {
					if(all_product_ext[k] != '') {
						select_product_propro +='<dt >'+all_values[k]+'：</dt><dd>'+all_product_ext[k]+'</dd>';
					}
				}
			}
			select_product_propro +='</dl></div>';
			$('#gourp_select_'+goods_sn).html(select_product_propro);
		}
		/**判断是不是有组合购买 end*/
		
		
	});
    var options = {
        zoomWidth: 320,
        zoomHeight: 280,
        showEffect:'show',
        hideEffect:'hide',
        fadeoutSpeed: 'slow',
        title :false,
        yOffset:0,
        showPreload:false
    }
	$("#jqzoom").jqzoom(options);	
    $('.image_list img').click(function(){
    	if($(this).attr('source')!='')
		$('#current_img').attr('src', $(this).attr('source'));
    	if($(this).attr('original')!='')
        $('#current_img').parent().attr('href', $(this).attr('original'));	
        $(".picList").find('li').removeClass('current');
		$(this).parent().parent().addClass('current');
    });  
    $(".color_img").click(function(){
    	if($(this).attr('source')!='')
    		$('#current_img').attr('src', $(this).attr('source'));
		if($(this).attr('original')!='')
			$('#current_img').parent().attr('href', $(this).attr('original'));	
		$(".image_list").hide().removeClass('current');
		$("li[class='image_list'][code='"+$(this).attr('code')+"']").show();
		$(".image_list:visible").eq(0).addClass("current");
		//重置图片滚动列表
		var lUl = $(".picList>ul");
		lUl.css("left","0");
		$('.btnNext').addClass("next-disabled");
			if($('li:visible',lUl).size()<=4){
				$('.btnPrevious').addClass("prev-disabled");	
			}else{
				$('.btnPrevious').removeClass("prev-disabled");
			}
    }); 
	
	
	
	//浮动tab选择框
	/*var floatCS = $("#floatColorSize");
	var floatLT = $('.inforTitle').offset().top;
	$(window).scroll(function() {
		//浮动tab选择框
		if($(document).scrollTop() > floatLT){
			$('.inforTitle').addClass('stayHere');
			$('.inforTitle_bg').show();
			$(".inforTitle").css({"border-top":"none","border-right":"none"});
			$(".stayHere").css("border-left","none");
			$(".inforTitle").css("border-left","none");
		}else{
			$('.inforTitle').removeClass('stayHere');
			$(".inforTitle").css({"border-top":"1px solid #ccc","border-right":"1px solid #ccc"});
			$(".stayHere").css("border-left","1px solid #ccc");
			$(".inforTitle").css("border-left","1px solid #ccc");
			$('.inforTitle_bg').hide();	
		}
		if ($(window).scrollTop() <= $(window).height()) {
			floatCS.hide();
		}else{
			floatCS.show();
		}
	});
	//当tab选择框浮动时，点击tab，回到顶部
	$('.inforTitle a').click(function(){
		if($(this).parent().hasClass('stayHere')){
			$('html,body').scrollTop(floatLT);
		}
	});
	//关闭浮动颜色尺码框
	floatCS.find('.close_float').click(function(){
		floatCS.addClass('hidden').hide();
	});
	$(".float_capacity a").click(function(){
		$(this).addClass("current").siblings().removeClass("current");
	});*/
	
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
	
	//tabFun(".inforTitle a",".information>div","current");
	
	
	//商品详情页第一个颜色、尺码，默认让它选中	
	$(".prodetails>.clearfix>div").each(function(){
		 $(this).find('a[type=ext_attr]').first().click();
	});
	
});

function add_shop_cart(obj) {
	var choose_num = $("input[name='choose_num']").val();
	var actural_num = parseInt($("#actual_number").html());
	if(actural_num <=0) {
		baison.alert('对不起，该商品库存不足！');
		return false;
	}
	if(choose_num <= 0) {
		baison.alert('购买的数量必须为正整数');
		return  false;
	}
	if(choose_num>actural_num){
		baison.alert('对不起，该商品库存不足！');
		return false;
	}
	var _str ='';
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
	Ajax.call('/index.php?app_act=goods/check_cart_sum&app_fmt=json&app_page=null', '', 
		function (s){
			if(s.code==1){
				baison.alert(s.msg);
			}else{
				go_to_cart(sku,choose_num,goods_price,goods_type,obj);
			}
		}	, 'GET', 'json'); 
}
function go_to_cart(sku,choose_num,goods_money, action,gotype) {
	if(sku !='') {
		var ext_attr_info ='';
		for(var i in ext_all_desc) {
			if(ext_all_desc[i] == sku) {
				ext_attr_info = ext_all_desc_value[i];
				break;
			}
		}
		var url='/index.php?app_act=goods/add_product_to_cart&app_page=null&app_fmt=json';
		url+='&sku_sn='+encodeURI(sku.substring(1, sku.length-1),'UTF-8');
		url+='&ext_attr_info='+encodeURI(ext_attr_info,'UTF-8');
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
function go_comment(user_id) {
	if (user_id == '') {
		$('#vCode').click();
		$('#popdiv').show();
	} else {
		if ($("#commment_form").css('display') == 'none') {
			Ajax.call('/index.php?app_act=goods/check_buy&app_page=null&goods_sn='+goods_sn, '', 
					function (s){
						s=eval('('+s+')');	
						if(s.code == 0) {
							$("#commment_form").show();
						} else {
							baison.alert(s.msg);
						}
					}	, 'GET', ''); 			
		} else {
			$("#commment_form").hide();
		}
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

function send_mail_to_user(user_id){
	if(user_id) {
		var str = '';
		var sku_sn = goods_sn;
		$("a[type='ext_attr']").each(function () {
			if($(this).attr('selected')) {
				sku_sn = sku_sn + $(this).attr('code');
				str = str+ '&'+$(this).attr('name')+'='+$(this).attr('code');
			}
		})
		str ='&user_id='+user_id+'&goods_sn='+goods_sn+'&sku_sn='+sku_sn +str;
		Ajax.call('/index.php?app_act=goods/record_user_to_base&app_page=null&app_fmt=json', str, 
			function (s){
				baison.alert(s.msg);
			}	, 'GET', 'json'); 
	}else {
		//$("#btn_login").click();
		baison.alert("请先登录",function(){
			location.href='/user/index/';
		});
		
	}
}

function show_send_promo_notice(user_id,goods_sn){
	if( user_id ){
		var email_reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
		if( !email_reg.test( user_id ) ){
			user_id = false;
		}
	}
	baison.prompt('请输入正确的邮箱地址！',function(e){
		if (e){
			var email_reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
			if( !email_reg.test( e ) ){
				baison.alert('请输入正确的邮箱地址！');
			}else{
				send_promo_notice(user_id,goods_sn,e);
			}
		}
	},{'value':user_id});
}

function send_promo_notice(user_id,goods_sn,send_email){
	
	url = '/index.php?app_act=goods/send_promo_notice&app_page=null&app_fmt=json' ;
	params = '&goods_sn='+goods_sn+'&send_email='+send_email;
	//params = '&goods_sn='+goods_sn+'&telephone='+telephone;
	Ajax.call( url , params ,
			function( s ){
				s=eval('('+s+')');	
				if( s.code ){
					baison.alert(s.msg);
				}else{
					baison.alert(s.msg);
					$("div.p_goods_detail").find('p.close').click();
				}
	} , 'get' , 'JSON' );
}
function add_suit_to_cart(){
	if($('#gourp_select_'+goods_sn)) {
		$("#group_result").html('');
		var all_product_ext =  new Array(all_names.length);
		for(var k = 0; k < all_product_ext.length; k++) {
			all_product_ext[k] = '';
		}
		$("a[name][value]").each(function(){
			if($(this).attr('selected'))
				all_product_ext[$(this).attr('index')] = $(this).attr('value');
		})
		var select_product_str = all_product_ext.join(',');
		var select_sku_index = $.inArray(select_product_str, all_value_arr);
		var select_goods = [];
		var select_sku = ''; //sku的值
		if( select_sku_index >= 0) {
			select_sku = all_inventory_skus[select_sku_index].substring(1, all_inventory_skus[select_sku_index].length-1);
		}
		/*
		if(select_sku == '') {
			alert('首件商品为必选');
			return false;
		}
		*/
		var group_sku = [];
		var group_code = '';
		$('input[type="checkbox"][name="group_proudcts"]:checked').each(function(i,v){
			group_sku[i] = $(this).attr('group_sku');
			select_goods[i] = $(this).attr('gs');
			group_code = $(this).attr('group_code');
		})
		if(group_sku.length == 0) {
			//$("#group_result").html('请至少保留两件商品');
			baison.alert('请至少保留两件商品');
			return false;
		}
		
		if(select_sku != '') {
			group_sku.push(select_sku);
			select_goods.push(goods_sn);
		}
		$.getJSON( '/goods/add_suit_product?app_page=null&app_fmt=json' , {suit_code: group_code,suit_skus:group_sku.join('_'), goods_sns:select_goods.join('_')} ,
			function( data ){
				if(data.code == 7) {
					baison.alert(data.msg);			
				}else {
					if($("#div_popup").length > 0 ) {
						data.msg += '\n<a href="/">前往首页</a>&nbsp;&nbsp;&nbsp;<a href="javascript:histroy.back();">返回</a>';
						baison.alert(data.msg);
					} else {
						add_car_success();
						//$.get("/?app_act=index/get_cart_info&"+ Math.random(),"",function(data){$('#topcart_info').html(data)},"html");
					}
			   }
		    });
	}
}

