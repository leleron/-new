;(function($){
	$.fn.scrollList = function(o){
		var o = $.extend(
			{
			prev:null,
			next:null,
			visible:5,
			scroll:4,
			auto:false,
			vertical:false,
			speed:700
			},
			o||{}
		);	
		var b=false,animCss,sizeCss,c,sLis,sUl,sSize,v,style,pos,scrolled=0;
			animCss = o.vertical ? "top": "left";
			sizeCss = o.vertical ? "height": "width";
			c = $(this);
			sUl = $("ul",c);
			sLis = $("li:visible",c);
			sSize = sLis.size();
			v = o.visible;
			style = o.vertical ? height(sLis):width(sLis);
			c.css(sizeCss,v*style);
			sUl.css(sizeCss,sSize*style);
			c.css('position','relative');
			sUl.css({position:'absolute',top:0,left:0});
			$(o.next).addClass("next-disabled");
			if(sSize<=o.visible){
				$(o.prev).addClass("prev-disabled");	
			}else{
				var b = true;
				$(o.prev).click(function(){
					sLis = $("li:visible",c);
					sSize = sLis.size();
					pos = o.vertical ? sUl.position().top:sUl.position().left;
					scrolled = Math.round(pos/style);
					if(o.visible-sSize-scrolled<0 && b){
						b = false;
						pos= pos+o.scroll*style;
						$(o.prev).removeClass("prev-disabled");
						$(o.next).removeClass("next-disabled");
						sUl.animate(animCss == 'left' ? {left:"-="+(o.scroll*style)}:{top:"-="+(o.scroll*style)},o.speed,function(){
							b=true;
							pos = o.vertical ? sUl.position().top:sUl.position().left;
							scrolled = Math.round(pos/style);
							if(o.visible-sSize-scrolled>=0){
								$(o.prev).addClass('prev-disabled');
							}
						});
					}else{
						$(o.prev).addClass("prev-disabled");
					}
					
				});
			
				$(o.next).click(function(){
					pos = o.vertical ? sUl.position().top:sUl.position().left;
					sSize = sLis.size();
					if(pos<0 && b){
						b=false;
						sUl.animate(animCss == 'left' ? {left:"+="+(o.scroll*style)}:{top:"+="+(o.scroll*style)},o.speed,function(){
							b=true;
							pos = o.vertical ? sUl.position().top:sUl.position().left;
							scrolled = Math.round(pos/style);
							if(pos>=0){
								$(o.next).addClass("next-disabled");
							}
							if(o.visible-sSize-scrolled<0){
								$(o.prev).removeClass("prev-disabled");
							}
						});
					}
				});
			}
	}
	function width(elem){
		return elem.outerWidth(true);
	};
	function height(elem){
		return elem.outerWidth(true);
	};
})(jQuery);
/*
$(function(){
	var option = {
		prev:'#prev',//向前滚动按钮
		next:'#next',//向后滚动按钮
		visible:4,//设置图片显示的张数，默认为4
		scroll:4,//设置每次图片滚动的次数，默认为4
		vertical:false,//设置滚动的方向，默认为水平（false）
		speed:600//设置图片滚动的速度，默认为600
	};
	$("#scroll-list").picScroll(option);
})
*/
