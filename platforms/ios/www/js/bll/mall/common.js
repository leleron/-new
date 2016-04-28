//document.domain="openshop.com";

var $app_url='/';
	
function redirectPage(id,url,div,sum_page,current) {	
	page = $("#"+id,"#"+div).val();
	if(page ==''|| page ==0) {
    	baison.alert('请填写页数！');
        page = current;
		return;
    }
    if(!/^[0-9]{1,}$/.test(page)) {
    	baison.alert('页数只能填写数字！');
    	return ;
    }
    if(page > sum_page) {
    	baison.alert('页数不存在!');
    	page = current;
		return;
    }
    page_ajax(page, url, div);
}
function myKeyDown() {
    var k = window.event.keyCode;
    if ((k == 46) || (k == 8) || (k == 189) || (k == 109) || (k == 190) || (k == 110) || (k >= 48 && k <= 57) || (k >= 96 && k <= 105) || (k >= 37 && k <= 40))
    { }
    else if (k == 13) {
        window.event.keyCode = 9;
    }
    else {
        window.event.returnValue = false;
    }
}
function page_ajax(page,url,div) {
    return;
	var params ="page="+page+"&ajax_url="+encodeURIComponent(url,'UTF-8')+"&ajax_div="+div;
	Ajax.call(url, params, 
		function (s){
			if(s !='') {
				$("#"+div).html(s);
				if($("#"+div).css('display') =='block' || $("#"+div).css('display') =='' ) {
					$("#"+div).show();
				}else {
					$("#"+div).hide();
				}
				//$("html,body").animate({scrollTop: $("#"+div).offset().top}, 1000);
			}else{
				$("#"+div).hide();
			}
		}
	, 'POST', '');
}

function page_ajax2(page,url,div) {
    return;
	var params ="page="+page+"&ajax_url="+encodeURIComponent(url,'UTF-8')+"&ajax_div="+div;
	Ajax.call(url, params, 
		function (s){
			if(s !='') {
				$("#"+div).html(s);
				if($("#"+div).css('display') =='block' || $("#"+div).css('display') =='' || $("#"+div).css('display') =='none' ) {
					$("#"+div).show();
				}else {
					$("#"+div).hide();
				}
				//$("html,body").animate({scrollTop: $("#"+div).offset().top}, 1000);
			}else{
				$("#"+div).hide();
			}
		}
	, 'POST', '');
}

function setCookie(name, value, seconds) {  
	  seconds = seconds || 0;   
	  var expires = "";  
	  if (seconds != 0 ) {      
		  var date = new Date();  
		  date.setTime(date.getTime()+(seconds*1000));  
		  expires = "; expires="+date.toGMTString();  
	  }  
	  document.cookie = name+"="+escape(value)+expires+"; path=/;domain="+document.domain;   
}  
function getCookie(Name) { 
    var search = Name + "=" 
    if(document.cookie.length > 0) { 
        offset = document.cookie.indexOf(search) 
        if(offset != -1){ 
            offset += search.length 
            end = document.cookie.indexOf(";", offset) 
            if(end == -1) end = document.cookie.length 
            return unescape(document.cookie.substring(offset, end)) 
        } 
        else return "" 
    } 
} 
function send_to_search(obj) {
	var send_to_value = $(obj).find('i').text();
	if(send_to_value !='') {
		$("#search_box").val(send_to_value);
		$("#search").click();
	}
}
function check_user_status(status, url){
	if(status ==0) {
		$("#btn_login").click();
	}else {
		location.href= url;
	}
	return false;
}
function show_goods_detail(goods_sn, type){
	baison.popup("<div id='show_goods_detail'><img src='/theme/default/images/loading.gif' class='m20' /></div>",{className:'p_goods_detail',title:'快速加入购物车'});
	if(goods_sn != '') {
		$.post('/goods/detail', {app_page:null, goods_sn: goods_sn, type: type}, function(s) {
			if(s.length > 0) {
				$("#show_goods_detail").html(s);
			} else {
				baison.popup('该商品库存不足');
			}
		})
	}else{return false;}
}

function show_gallery_detail(goods_sn){
	baison.popup("<div id='show_gallery_detail'><img src='/theme/default/images/loading.gif' class='m20' /></div>",{className:'p_goods_detail',title:'快速图片浏览'});
	if(goods_sn != '') {
		$.post('/goods/gallery', {app_page:null, goods_sn: goods_sn}, function(s) {
			if(s.length > 0) {
				$("#show_gallery_detail").html(s);
			} else {
				baison.popup('');
			}
		})
	}
}
function add_collect_goods(goods_sn){
	Ajax.call('/index.php?app_act=goods/collect&app_page=null&app_fmt=json&goods_sn='+goods_sn, '', 
			function (s){
				s = eval('('+s+')');
				if(s.code == 0) {
					baison.popup("<div class='add_success'><h1 class='fm f24'><img class='vm in_b mr20 png_bg' src='/images/success.png' width='31' height='30' />成功加入收藏夹！</h1><button class='fm f18 mt25' onclick='go_my_fav();'>去收藏夹看看</button><a href='javascript:;' class='colorRed ml10 in_b' onclick='close_popup();'>关闭页面</a></div>",{className:'show_add_goods_div',title:'  '});
					//$("#popdiv_collect").css('display','block');
				} else {
					//$("#vCode").click();
					//$("#popdiv_unlogin").css('display','block');
					baison.alert(s.msg);
				}
				
		   }
	, 'POST', 'JSON');
}
function go_my_fav(){
	location.href='/mem_center/index/fav';
}
function add_car_success(){
	baison.popup("<div class='add_success'><h1 class='fm f24'><img class='vm in_b mr20 png_bg' src='/images/success.png' width='31' height='30' />成功加入购物车！</h1><button class='fm f18 mt25' onclick='go_shopping();'>去购物车结算</button><a href='javascript:;' class='colorRed ml10 in_b' onclick='close_popup();'>关闭页面</a></div>",{className:'show_add_goods_div',title:'  '});
}
function close_popup(){
	$("div.show_add_goods_div").find('p.close').click();//关闭弹出层
}
function go_shopping(){
	location.href='/carts/';
}
function ajaxcheck(objname,checkurl,param,action,type,goods_sn){
	Ajax.call(checkurl, param, 
			function (s){
				s=eval('('+s+')');
				if(s.code ==0) {
					if( type == 'order' ){
						window.top.location = '/orders/do_index&goods_sn='+goods_sn;
					}else if(type=='cart'){
						window.top.location = '/carts/do_index&goods_sn='+goods_sn;
					}else{
						add_car_success();
						//$.get("/?app_act=index/get_cart_info&"+ Math.random(),"",function(data){$('#topcart_info').html(data)},"html");
						
						//$.get("/index/get_cart_info&"+ Math.random(),"",
                        //		function(data){
                        //			$('#top_cart_info').html(data)
                        //},"html");
					}
				}else {
					if(action=='second'){
						$('#vCode').attr('src','/index.php?app_act=printpic/do_index&type=spike&'+ Math.random());
					}
					baison.alert(s.msg);	
				}
		  }
	, 'POST', '');
}
function cartclose(){
	$("#shopping_cart_open").hide();  
}
function cartopen(){
	$("#shopping_cart_open").show();   
}
var new_inside_desID = '';
function new_inside_des(id){
	$('#new_inside_des_b' + new_inside_desID).removeClass('new_inside_des_tb');
	$('#new_inside_des_a' + new_inside_desID).hide();
	
	$('#new_inside_des_b' + id).addClass('new_inside_des_tb');
	$('#new_inside_des_a' + id).show();
	
	new_inside_desID = id;
}
function close_box(){
   document.getElementById('info_box').style.visibility='hidden';
   document.getElementById('mask').style.visibility='hidden'
}
function clearBr(key){
    key = key.replace(/<\/?.+?>/g,"");
    key = key.replace(/[\r\n]/g, "");
    return key;
}
function format(str){
	if(str.toString().length<2){
		str = '0'+str;
	}
	return str;
}
function search_goods(url,search_goods){
	if(search_goods){
		$('#search_box').val(search_goods);
	}
	var $srch_box=$('#search_box');
	if($srch_box.val()!=''){
		//url+="-"+base64encode(encodeURIComponent($srch_box.val()))+".html";
		url+='&key_search='+base64encode(encodeURIComponent($srch_box.val()));
		location.href=url;
	}else{
		
			location.href='/list_goods/';
		
		
	}
	return false;
}

//清除浏览历史
function clearhistroy(){
	var exp=new Date();
	exp.setTime(exp.getTime()-10000);
	document.cookie="ETT[history]=',';expire="+exp.toGMTString()+ ";path=" + "/";
//	loadData.history_goods();
	$('#history_list').remove();
}
var timeout = '';
function showErrors(){
	var t = this;
	for ( var i = 0; this.errorList[i]; i++ ) {
		var error = this.errorList[i];
		baison.alert(error.message);return false;
		this.settings.highlight && this.settings.highlight.call( this, error.element, this.settings.errorClass, this.settings.validClass );
		var elename = this.idOrName(error.element);
		var obj = jQuery('#check'+elename);
		obj.parent().removeClass('mb15').addClass('selected') ;
		obj.html('');
		//obj.show();
		obj.removeClass('none');
		var errsdiv = jQuery('#check'+elename);
		/*jQuery('span[htmlfor='+ elename + ']'); 
		if(errsdiv.length == 0){
			errsdiv = jQuery('<span class="error_img" id="errmsg'+elename+'"></span>');
			errsdiv.attr({"for":  this.idOrName(error.element), generated: true})
			errsdiv.appendTo(jQuery('#check'+elename));
		}*/
		errsdiv.html(error.message || "");
		//jQuery('#'+elename).parent().;
		// 错误信息div
		// 错误信息div
	}

	// 校验成功的去掉错误提示
	for ( var i = 0; this.successList[i]; i++ ) {
		if(this.idOrName(this.successList[i])=='nickname'|| this.idOrName(this.successList[i])=='email'){
			timeout = setTimeout("showRight('"+ this.idOrName(this.successList[i]) +"')",1000); 
		}else{
			showRight(this.idOrName(this.successList[i]));
		}
	}
}
function showRight(dd){
     jQuery('#check'+dd).parent().addClass('mb15').removeClass('selected') ;
     jQuery('#check'+dd).html('');
     jQuery('#check'+dd).addClass('none');
}
//获取URL参数
function request(paras){ 
	var url = location.href; 
	var paraString = url.substring(url.indexOf("?")+1,url.length).split("&");  
	var paraObj = {}  
	for (i=0; j=paraString[i]; i++){  
		paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length);  
	}  
	var returnValue = paraObj[paras.toLowerCase()];  
	if(typeof(returnValue)=="undefined"){  
		return "";  
	}else{  
		return returnValue; 
	}
}
function addFavorite(sURL, sTitle){
	var ua = navigator.userAgent.toLowerCase();
	if(ua.indexOf("msie 8")>-1){
		//ie下收藏点击失败修复
		external.AddToFavoritesBar(sURL,sTitle,'');//IE8
	}else{
		try{
			window.external.addToFavoritesBar(sURL, sTitle,"slice");
		}catch (e){
			try{
				window.external.addFavorite(sURL, sTitle);
			}catch (e){
				try{
					window.sidebar.addPanel(sTitle, sURL, "");
				}catch (e){
					baison.alert("加入收藏失败，请使用Ctrl+D进行添加");
					//\n或者\n1、点击 开始-运行-regedit\n2、寻找HKEY_CLASSES_ROOT/TypeLib/{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}/1.1/0/win32\n3、点击‘Default’，如果它的值是C:/WINDOWS/system32/shdocvw.dll 就把它用C:/WINDOWS/system32/ieframe.dll 替换掉就可以了。
				}
			}
		}
	}
}
function URLdecode(str) {
	var ret = "";
	for(var i=0;i<str.length;i++) {
		var chr = str.charAt(i);
		if(chr == "+") {
			ret += " ";
		}else if(chr=="%") {
			var asc = str.substring(i+1,i+3);
			if(parseInt("0x"+asc)>0x7f) {
				ret += decodeURI("%"+ str.substring(i+1,i+9));
				i += 8;
			}else {
				ret += String.fromCharCode(parseInt("0x"+asc));
				i += 2;
			}
		}else {
			ret += chr;
		}
	}
	return ret;
}
/* *
  * 调用此方法发送HTTP请求。
  *
  * @public
  * @param   {string}    url             请求的URL地址
  * @param   {mix}       params          发送参数
  * @param   {Function}  callback        回调函数
  * @param   {string}    transferMode     请求的方式，有"GET"和"POST"两种
  * @param   {string}    responseType    响应类型，有"JSON"、"XML"和"TEXT"三种
  * @param   {boolean}   asyn            是否异步请求的方式
  * @param   {boolean}   quiet           是否安静模式请求
  */
var Ajax = jQuery;
Ajax.call = function (url, params, callback, transferMode, responseType, asyn, quiet){
	this.ajax({
		url: url+'&t='+Math.random()+'&is_ajax',
		async: asyn,
		data: params,
		type: transferMode,
		dataType: responseType,
		success: callback
	});	
}
//删除地址
function address_del(url){	
	var params="app_fmt=json";
	baison.confirm('确定要删除收货地址吗？',function(e){
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
function set_default_address(address_id){
	baison.confirm("确定要把此项作为默认收货地址吗？",function(e){
		if(e){				
			var params = "app_fmt=json&default_address="+address_id;
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
}

function countByteLength(str, cnCharByteLen){
    var byteLen = 0;
    for (var i=0; i<str.length; i++){
       if ((/[\x00-\xff]/g).test(str.charAt(i)))
            byteLen += 1;
       else
            byteLen += cnCharByteLen;
    }
    return byteLen;
}
function do_sign(user_id,flag) {
	if (user_id == '') {
		baison.alert('请登录后继续您的操作',function(){
			location.href = '/user/index/';
		});
	} else {
		var params = 'app_fmt=json&user_id='+user_id;
		Ajax.call('/index.php?app_act=user/index/sign', params, 
			function (s){
				if (s.statusCode == 0) {
					if(flag=='2'){
						location.href="/signok.html";
						//baison.alert(s.status,function(){window.location.reload()});
					}
				} else {
					baison.alert(s.status);
				}
			}
		, 'POST', 'json');
	}
}
//base64加密函数
function base64encode(str) {
	var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var base64DecodeChars = new Array(
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
         -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
         52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
         -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9, 10, 11, 12, 13, 14,
         15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
         -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
         41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1);
     var out, i, len;
     var c1, c2, c3;

     len = str.length;
     i = 0;
     out = "";
     while(i < len) {
         c1 = str.charCodeAt(i++) & 0xff;
         if(i == len)
         {
             out += base64EncodeChars.charAt(c1 >> 2);
             out += base64EncodeChars.charAt((c1 & 0x3) << 4);
             out += "==";
             break;
         }
         c2 = str.charCodeAt(i++);
         if(i == len)
         {
             out += base64EncodeChars.charAt(c1 >> 2);
             out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));
             out += base64EncodeChars.charAt((c2 & 0xF) << 2);
             out += "=";
             break;
         }
         c3 = str.charCodeAt(i++);
         out += base64EncodeChars.charAt(c1 >> 2);
         out += base64EncodeChars.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));
         out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >>6));
         out += base64EncodeChars.charAt(c3 & 0x3F);
     }
     return out;
}

//tab切换
function tabFun(tab,content,current){
	var conNum = 0;
	$(tab).click(function(){
		$(this).addClass(current).siblings().removeClass(current);
		conNum =$(this).index();
		$(content).eq(conNum).show().siblings().hide();	
	});	
}
/**
 * 购物车更新
 * @param id
 * @param sku_sn
 * @param num
 * @param type
 * @return
 */
function cart(id,sku_sn,num,type){
	if(id=='all'){
		id='';
		$('input[type=checkbox][name=check]').each(function(){
			id += ","+this.value;
		});
	}else if(id=='check'){
		id='';
		$('input[type=checkbox][name=check]').each(function(){
			if(this.checked){
				id += ","+this.value;
			}
		});
	}else if(id=='do_one'){
		id = sku_sn;
	}
	if(id!=''){		
		var params ='id='+id+'&app_fmt=json&app_page=null&type='+type+'&sku_sn='+sku_sn+'&oldnum='+num;
		var url='/carts/cart_add_del';
		if( type=='del' && num<=1 ){
			//baison.confirm('你确定要删除选中的这件商品吗？',function(e){
				//if(e){
					Ajax.call(url,params, 
							function (s){
								if(s.code==0){
									location.reload();
								}else{
									baison.alert(s.msg);
								}
						   }
					, 'POST', 'json');
				//}
			//});
		}else{
			Ajax.call(url,params, 
					function (s){
						if(s.code==0){
							location.reload();
						}else{
							baison.alert(s.msg);
						}
				   }
			, 'POST', 'json');
		}
	}else{
		baison.alert('请选择要删除的商品！',{"title":"温馨提示","ok":"关闭"});
	}
}

