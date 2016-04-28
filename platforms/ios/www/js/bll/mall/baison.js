/*
model:baison.js
author:guoxuemin
created:2012-3-29
email:469477762@qq.com
*/
var baison = {
	smoketimeout: [],
	init: false,
	zindex: 9999,//遮罩层初始层叠顺序
	
	bodyload: function(id){
		var ff = document.createElement('div');
				ff.setAttribute('id','baison-out-'+id);
				ff.className = 'baison-base';
				ff.style.zIndex = baison.zindex;
				baison.zindex++;
				document.body.appendChild(ff);
	},

	newdialog: function(){
		var newid = new Date().getTime();
			newid = Math.random(1,99) + newid;//当前时间毫秒数+随机数,避免id重复的可能性
			
		if (!baison.init){		
	    baison.listen(window,"load", function(){
		    baison.bodyload(newid);
			});
		}else{
	    baison.bodyload(newid);		
		}

		return newid;
	},

	forceload: function(){},

	build: function (e, f) {
		e = e.replace(/\n/g,'<br />');
		e = e.replace(/\r/g,'<br />');
		e = "<div class='dialog-con'>"+e+"</div>";
		var prompt = '',
		    ok = '确定',
		    cancel = '取消',
		    className = '',
		    buttons = '',
			popup = '',
			title = f.params.title ? f.params.title:'提示',
			close = '<p id="close-'+f.newid+'" class="close">×</p>',
		    box = '',
			timeout='';
		if (f.type === 'prompt'){
			prompt = 
				'<div class="dialog-prompt">'+
					'<input id="dialog-input-'+f.newid+'" type="text" ' + (f.params.value ? 'value="' + f.params.value + '"' : '') + ' />'+
				'</div>';
		}
		if (f.params.ok){
			ok = f.params.ok;
		}
		if (f.params.cancel){
			cancel = f.params.cancel;
		}
		
		if (f.params.className){
			className = f.params.className;
		}
		if(f.type=='signal'){
			//alert(f.timeout);
			timeout = "<div class='timeout'>还剩<b id='timeout-"+f.newid+"'>"+f.timeout/1000+"</b>秒自动关闭</div>"
		}
		if (f.type !== 'signal' && f.type !== 'popup'){
			buttons = '<div class="dialog-buttons">';
			if (f.type === 'alert'){
				buttons +=
					'<p class="button" id="alert-ok-'+f.newid+'">'+ok+'</p>';
			} else if (f.type === 'prompt' || f.type === 'confirm'){
				if (f.params.reverseButtons) {
					buttons +=
						'<p class="button cancel" id="'+f.type+'-cancel-'+f.newid+'">'+cancel+'</p>'+
						'<p class="button ok" id="'+f.type+'-ok-'+f.newid+'">'+ok+'</p>';		
				} else {
					buttons +=
						'<p class="button ok" id="'+f.type+'-ok-'+f.newid+'">'+ok+'</p>' +
						'<p class="button cancel" id="'+f.type+'-cancel-'+f.newid+'" >'+cancel+'</p>';	
				}
			}
			buttons += '</div>';
		}
		
		box = 
			'<div id="baison-bg-'+f.newid+'" class="smokebg"></div>'+
			'<div class="dialog baison '+className+'">'+
				'<div class="dialog-inner"><div class="inner-inner">'+
					'<div class="dialog-title">'+title+close+'</div>'+
						e+
						prompt+
						timeout+
						buttons+			
				'</div></div>'+
			'</div>';

		if (!baison.init){		
			baison.listen(window,"load", function(){
				baison.finishbuild(e,f,box);
			});
		} else{
			baison.finishbuild(e,f,box);
		}

	},

	finishbuild: function(e, f, box) {
		var ff = document.getElementById('baison-out-'+f.newid);
		ff.className = 'baison-base baison-visible baison-' + f.type;
		ff.innerHTML = box;
		while (ff.innerHTML === ""){
			ff.innerHTML = box;
		}
		
		// 清除队列事件
		if(baison.smoketimeout[f.newid+1]){
			clearInterval(baison.smoketimeout[f.newid+1]);
		}
		if (baison.smoketimeout[f.newid]){
			clearTimeout(baison.smoketimeout[f.newid]);
		}
		// 点击当前背景关闭
		baison.listen(
			document.getElementById('baison-bg-'+f.newid),
			"click", 
			function () {
				baison.destroy(f.type, f.newid);
				if (f.type === 'prompt' || f.type === 'confirm'){
					f.callback(false);
				} else if (f.type === 'alert' && typeof f.callback !== 'undefined') {
					f.callback();
				}	
			}
		);
		baison.listen(
			document.getElementById('close-'+f.newid),
			"click", 
			function () {
				baison.destroy(f.type, f.newid);
				if (f.type === 'prompt' || f.type === 'confirm'){
					f.callback(false);
				} else if (f.type === 'alert' && typeof f.callback !== 'undefined') {
					f.callback();
				}	
			}
		);
		// 按钮事件
		switch (f.type) {
			case 'alert': 
				baison.finishbuildAlert(e, f, box);
				break;
			case 'popup':
				baison.finishbuildPopup(e,f,box);
				break;
			case 'confirm':
				baison.finishbuildConfirm(e, f, box);
				break;
			case 'prompt':
				baison.finishbuildPrompt(e, f, box);
				break;
			case 'signal':
				baison.finishbuildSignal(e, f, box);
				break;
			default:
				throw "Unknown type: " + f.type;
		}
	},
	
	finishbuildAlert: function (e, f, box)
	{
		baison.listen(
			document.getElementById('alert-ok-'+f.newid),
			"click", 
			function () {
				baison.destroy(f.type, f.newid);
				if (typeof f.callback !== 'undefined') {
					f.callback();
				}
			}
		);
	
		//绑定回车、空格、退出键 关闭事件
		document.onkeyup = function (e){
			if (!e) {
				e = window.event;
			}
			if (e.keyCode === 13 || e.keyCode === 32 || e.keyCode === 27){
				baison.destroy(f.type, f.newid);
				if (typeof f.callback !== 'undefined') {
					f.callback();
				}					
			}
		};	
	},
	finishbuildPopup:function(e,f){
		//绑定回车、空格、退出键 关闭事件
		document.onkeyup = function (e){
			if (!e) {
				e = window.event;
			}
			if (e.keyCode === 27){
				baison.destroy(f.type, f.newid);
			}
		};	
	},
	finishbuildConfirm: function (e, f, box){
		baison.listen(
			document.getElementById('confirm-cancel-' + f.newid),
			"click", 
			function () 
			{
				baison.destroy(f.type, f.newid);
				f.callback(false);
			}
		);
		
		baison.listen(
			document.getElementById('confirm-ok-' + f.newid),
			"click", 
			function () 
			{
				baison.destroy(f.type, f.newid);
				f.callback(true);
			}
		);
				
		// 回车键和空格键关闭并返回true,退出键关闭并返回false；
		document.onkeyup = function (e){
			if (!e) {
				e = window.event;
			}
			if (e.keyCode === 13 || e.keyCode === 32){
				baison.destroy(f.type, f.newid);
				f.callback(true);
			} else if (e.keyCode === 27){
				baison.destroy(f.type, f.newid);
				f.callback(false);
			}
		};	
	},
	
	finishbuildPrompt: function (e, f, box){
		var pi = document.getElementById('dialog-input-'+f.newid);
		setTimeout(function () {
			pi.focus();
			pi.select();
		}, 100);
	
		// 绑定‘取消按钮’事件
		baison.listen(
			document.getElementById('prompt-cancel-'+f.newid),
			"click", 
			function () {
				baison.destroy(f.type, f.newid);
				f.callback(false);
			}
		);
	
		// 绑定“确定按钮”事件
		baison.listen(
			document.getElementById('prompt-ok-'+f.newid),
			"click", 
			function () {
				baison.destroy(f.type, f.newid);
				f.callback(pi.value);
			}
		);
				
		// 回车键关闭并返回true,退出键关闭并返回false；
		document.onkeyup = function (e) {
			if (!e) {
				e = window.event;
			}
			
			if (e.keyCode === 13){
				
				//回车不做处理baison.destroy(f.type, f.newid);
				//f.callback(pi.value);
			} else if (e.keyCode === 27){
				baison.destroy(f.type, f.newid);
				f.callback(false);
			}
		};
	},
	
	//定时器
	finishbuildSignal: function (e, f, box){
		var time = parseInt(f.timeout)/1000;
		baison.smoketimeout[f.newid+1] = setInterval(function(){
			time -=1;
			document.getElementById('timeout-'+f.newid).innerHTML = time;
		},
		1000);
		baison.smoketimeout[f.newid] = setTimeout(function () {
			baison.destroy(f.type, f.newid);
			clearInterval(baison.smoketimeout[f.newid+1]);
			baison.smoketimeout[f.newid+1] = null;
		}, f.timeout);
	},
	
			
	destroy: function (type,id) {
		var box = document.getElementById('baison-out-'+id), 
		    okButton  = document.getElementById(type+'-ok-'+id), 
		    cancelButton = document.getElementById(type+'-cancel-'+id);
		while (box==null){return true;}
		box.className = 'baison-base';//通过重置类实现隐藏关闭
		// 取消“确定按钮”绑定事件
		if (okButton){
			baison.stoplistening(okButton, "click", function(){});
			document.onkeyup = null;
		}
		if(baison.smoketimeout[id+1]){
			clearInterval(baison.smoketimeout[id+1]);
		}
		// 取消“取消按钮”绑定事件
		if (cancelButton){
			baison.stoplistening(cancelButton, "click", function(){});
		}
		//box.innerHTML = '';
		document.body.removeChild(box);
	},

	alert: function (e, f, g) {
		if (typeof f !== 'object'){
			g = f;
			f = false;
		}
		var id = baison.newdialog();
		baison.build(e, {
			type:'alert',
			callback: g,
			params:f,
			newid:id
		});
	},
	
	signal: function (e, f) {
		if (typeof f === 'undefined'){
			f = 1000;
		}
		
		var id = baison.newdialog();
		baison.build(e, {
			type:'signal',
			timeout:f,
			params:false,
			newid:id
		});
	},
	popup:function(e,f){
		if (typeof e == 'object'){
			f = e;
			e = '';
		}
		if(typeof f !== 'object'){
			f = false;
		}
		var id = baison.newdialog();
		baison.build(e,{
			type:'popup',
			callback: false,
			params:f,
			newid:id
		});
	},
	confirm: function (e, f, g) {
		if (typeof g !== 'object'){
			g = false;
		}
		
		var id = baison.newdialog();
		baison.build(e, {
			type:'confirm',
			callback: f,
			params:g,
			newid:id
		});
	},
	
	prompt: function (e, f, g) {
		if (typeof g !== 'object'){
			g = false;
		}
		
		var id = baison.newdialog();
		return baison.build(e,{
			type:'prompt',
			callback:f,
			params:g,
			newid:id
		});
	},
	
	listen: function (e, f, g) {
		if (e.addEventListener) {
		  return e.addEventListener(f, g, false);
		}; 
		if (e.attachEvent){
		  return e.attachEvent('on'+f, g);
		};
			return false;
	},
	
	stoplistening: function (e, f, g) {	
		if (e.removeEventListener) {
		  return e.removeEventListener("click", g, false);
		}
		
		if (e.detachEvent){
		  return e.detachEvent('on'+f, g);
		}
		return false;
	}
};
if (!baison.init) {		
  baison.listen(window, "load", function () {
    baison.init = true;
	});
}