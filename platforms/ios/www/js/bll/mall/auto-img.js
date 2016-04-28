;(function($){
	$.fn.autoImgSlide = function(o){
		var o = $.extend(
			{
				button:false,  	//是否有按钮,默认是false
				num:'show',		//数字按钮显示还是隐藏,默认是show
				hover:'scroll',	//移动到图片上可否继续轮显，默认为scroll
				speed:5000		//轮显速度,默认是5000
			},
			o||{}
		);
		return this.each(function(){
			var s = $(this);
			var index=1;
			var $maxList = s.find('ul li');
			var len = $maxList.length;
			var $minList;
			brandFun();

			$maxList.eq(0).fadeTo(500,1);
			
			starting();
			
			function starting(){
				
				var nums='';
				for(var i=0;i<len;i++){
					var nums = nums+'<span><b>'+(i+1)+'</b></span>';
				}
				var numList = '<div class="num-list">'+nums+'</div>';
				s.append(numList);
				$minList = $('.num-list span');
				setTimeout(function(){$minList.eq(0).addClass('num-on');},200);
				$('.num-list').css({'width':(($minList.outerWidth()+parseInt($minList.css('margin-right')))*len)+'px','display':'none'});
				if(o.num == 'show'){
					if(len>1){
						$('.num-list').css('display','block');
						$(".num-list span").last().addClass("last");
						auto(index);
					}else{
						return false;
					}
				}else{
					auto(index);	
				}
				
				if(o.button == true){
					$('.btn-prev').click(function(e){				//上一张
						clearInterval(sign);
						var numPrev = $minList.index($('.num-on'))-1;
						buttonClick(numPrev);
					});
				
					$('.btn-next').click(function(e){				//下一张
						clearInterval(sign);
						var numNext = $minList.index($('.num-on'))+1;
						buttonClick(numNext);
					});
					
					function buttonClick(myIndex){					//点击按钮之后的计数
						if(myIndex < 0){
							myIndex = len-1
						}else if(myIndex == len){
							myIndex = 0;	
							}
						autoScroll(myIndex);
						myIndex++;
						if(myIndex == len) {myIndex = 0;}
						auto(myIndex);
					}
				}
				
			}
		
			if(o.num == 'show'){
				$minList.on('mouseenter',function(){	//移动到数字上
					clearInterval(sign);
					var thisObj = $minList.index($(this));
					autoScroll(thisObj);
				});
				$minList.on('mouseleave',function(){
						index = $minList.index($(this))+1;
						if(index>=len){
							index=0;
						}
						auto(index);
				});
			}
		
			if(o.hover == 'scroll'){
				$maxList.on('mouseenter',function(){	//移动到图片上
					clearInterval(sign);
				});
				$maxList.on('mouseleave',function(){
					auto(index); 
				});
			}
			
			function auto(num){
				sign = setInterval(function(){		//循环
					autoScroll(num);
					num++;
					if(num>=len){
						num=0;
					}
					index=num;
				},o.speed);
			}
		
			function autoScroll(idx){				//显隐
				$maxList.eq(idx).stop(true,false).fadeTo(500,1).css('z-index','2');
				$maxList.eq(idx).siblings().fadeTo(500,0).css('z-index','1');
				$minList.eq(idx).addClass('num-on').siblings().removeClass('num-on');
			}
			
			function brandFun(){
				if(s.hasClass('brandScrollImg')){
					for(var j=0;j<len;j++){
						var src = $maxList.eq(j).find('img').attr('src');
						var bg = 'background:url("'+src+'") no-repeat center 0;';
						$maxList.eq(j).find('a').attr('style',bg);	
					}
					$maxList.find('img').addClass('none');	
				}	
			}
		})
	}
}) (jQuery);


