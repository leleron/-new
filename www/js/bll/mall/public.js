//文本框输入
$.fn.setDefauleValue = function() {
    return this.each(function() {
    var defauleValue = $(this).val();
	$(this).val(this.defaultValue).css("color","#a9a9a9");
        $(this).focus(function() {
            if ($(this).val() == defauleValue) {
                $(this).val("").css("color","#000");
            }
        }).blur(function() {
            if ($(this).val() == "") {
                $(this).val(defauleValue).css("color","#a9a9a9");
            }
        });
    });
}
$(function(){
	$(".search_box .txt").focus(function() {
            $(".hot_words").hide();           
        }).blur(function() {
            $(".hot_words").show();    
        });

    //返回顶部
	var windowW = $(window).width();
	if($(document).scrollTop() != 0) 
		$("#returnTopBtn").css('display','block');
	$(window).scroll(function (){
		var st=$(document).scrollTop();
		(st > 10)?$("#returnTopBtn").fadeIn():$("#returnTopBtn").css('display','none');
	});
	$("#returnTopBtn").click(function(){
		$('html,body').animate({scrollTop:'0px'},200);
		return false;
	});
    $(".home_show a").last().addClass("last");
    $(".star_goods").each(function(){
        $(this).find(".star_item").last().addClass("starLast");
    })
	
    //$(".search_box .txt").setDefauleValue();
    //$(".reg_content .txt").setDefauleValue();
    //$(".find_wrapper .txt").setDefauleValue();
    //$(".address_layer .txt").setDefauleValue();
    //$(".address_layer textarea").setDefauleValue();
    
    //$(".nav_list li").last().addClass("last");

    //全部商品分类
    /*$(".category_list").each(function(){
        var item = $(this).find(".perfume_list").length;
        if( item <= 11){
            var H = (421-item)/item;
            $(this).find(".perfume_list").height(H);
            $(".perfume_list a").css("line-height",H+"px");    
        }
        else{
            var H = (592-item)/item;
            $(this).find(".perfume_list").height(H);
            $(".perfume_list a").css("line-height",H+"px");    
        }      
    });*/
    //搜索页
    $(".search_item").each(function() {
        if (($(this).index() + 1) % 2 == 0) {
            $(this).addClass("searchMargin");
        }
    });
    
    //tabFun(".order_ticket .ticket_list",".ticket_info>div","order_selected");
    
    $(".pay_item").click(function(){
		$(this).find("span").addClass("selected").end().siblings().find("span").removeClass("selected");  
		$(this).parent().parent().siblings().find("span").removeClass("selected");
    });
    
	$(".gift_code h1").click(function(){
		if( $(this).attr("value")==0 ){
			$(this).attr("value","1");
			$(this).parent().find(".gift_change").show();
		}
		else{
			$(this).attr("value","0");
			$(this).parent().find(".gift_change").hide();
		}
		
	})
	$("#cancel").click(function(){
		$(".gift_change").hide();
	});
	//查看物流
	$(".check_log").hover(
		function(){
			$(this).find(".logistics_info").show();
			//$(this).find(".mini_cart").addClass("mini-cart-on");
            
		},function(){
			$(this).find(".logistics_info").hide();
           // $(this).find(".mini_cart").removeClass("mini-cart-on");
		}
	);

});

//tab切换
function tabFun(tab,content,current){
	var conNum = 0;
	$(tab).click(function(){
		$(this).addClass(current).siblings().removeClass(current);
		conNum =$(this).index();
		$(content).eq(conNum).show().siblings().hide();				
	});
}

//方法调用
$(function(){
	//ie下a标签消除虚线
	$("a").click(function(){
		$(this).blur();					  
	});
	 //地址选择
	
	$(".address_list").on("click",function(){
		$(this).addClass("order_selected").siblings().removeClass("order_selected");
	});
	//侧栏去最后元素下边框
	$(".sidebarBoxContent .borderBot:last-child").removeClass("borderBot");

	//商品详细页商品介绍、商品评论、商品咨询、售后服务tab切换
	tabFun(".informationTitle li",".informationCon>div","current");
	//秒杀列表所有活动、正在进行、即将开场、往期活动
	tabFun(".groupButtonBox a",".seckillMainContent>div","groupCurrentBtn");
	//我的订单tab切换
	tabFun(".myOrdersTab li",".myOrdersCon>div","current");
	tabFun("#reg_tab h3","#reg_con>ul","current");
	//tabFun(".inforTitle a",".information>div","current");
    //添加新收货地址
	$(".layer_bg").height( $(document).height() );
	$(".address_new").click(function(){
		$(".layer_bg").show();
		$(this).find(".address_layer").show();
	});
	$(".address_new").click(function(event){
		var e=window.event || event;
		if(e.stopPropagation){
			e.stopPropagation();
		}else{
			e.cancelBubble = true;
		}
	});
	
	$(".edit").click(function(){
		$(".layer_bg").show();
		$(this).parent().find(".address_layer").show();
	});
	$(".refund_address").click(function(event){
		var e=window.event || event;
		if(e.stopPropagation){
			e.stopPropagation();
		}else{
			e.cancelBubble = true;
		}
	});
	
	document.onclick = function(){
		$(".address_layer").hide();
		$(".layer_bg").hide();
	};
	$(".agress").click(function(){
		$(this).find("em").toggleClass("selected");
	});
	
	

})

//rate快速评价
; (function($) {
    $.fn.rate = function() {
        var obj = $(this);
        //starRate
        var rateFlag = true;
        obj.find("img").click( function() {
				rateFlag = false;
                var $oldSrc = $(this).attr("src");
                var $newSrc = $oldSrc.replace("starE", "starF");
                var $oldSrc = $oldSrc.replace("starF", "starE");
                $(this).attr("src", $newSrc).prevAll("img").attr("src", $newSrc).end().nextAll("img").attr("src", $oldSrc);
                obj.attr("rate",$(this).parent().find("img").index(this) + 1);
            })
        obj.find("img").mouseover(function() {
                if (rateFlag) {
                    var $oldSrc = $(this).attr("src");
                    var $newSrc = $oldSrc.replace("starE", "starF");
                    $(this).attr("src", $newSrc).prevAll("img").attr("src", $newSrc);
                }
            });
       	obj.find("img").mouseleave(function() {
                if (rateFlag) {
                    var $oldSrc = $(this).attr("src");
                    var $newSrc = $oldSrc.replace("starF", "starE");
                    $(this).attr("src", $newSrc).prevAll("img").attr("src", $newSrc);
                }
            });
    };
})(jQuery);
