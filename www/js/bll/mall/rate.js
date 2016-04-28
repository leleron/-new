/*
model:rate.js
author:guoxuemin
created:2012-3-6
email:469477762@qq.com
*/
//商品满意度评分
function get_rate(obj,rate,flg){
	var rate=rate.toString();
	var gradeScore = $(obj);
	var g_scored = $("dl.g_scored");
	var currentScore = $(".currentScore",gradeScore);
	var score1_box = $(".score1",gradeScore);
	var score2_box = $(".score2",gradeScore);
	var score1;
	var score2;
	if(flg == 'false'){
		score1=parseInt(rate.substr(0,1));
		score2=rate.substr(2,1);
		if (score1>=5){
			score1=5;	
			score2=0;
		}else if(rate=="0"){
			score1=0;
			score2=0;
		}else{
			score1=rate.substr(0,1);
			score2=rate.substr(2,1);
		}
		score1_box.text(score1);
		score2_box.text("."+ score2);
		currentScore.animate({width:(parseInt(score1)+parseInt(score2)/10) * 26+7,height:16},1000);
		$("dd",g_scored).each(function(){
			$(this).mouseover(function(){
				g_scored = $(this).parent();
				$(".currentScore",g_scored).width($(this).attr("rate") *26 );
				$(".score1",g_scored).text($(this).attr("rate"));
				$(".score2",g_scored).text(".0");
			})
		})
		gradeScore.mouseout(function(){
			score1_box.text(score1);
			score2_box.text("."+ score2);
			currentScore.width((parseInt(score1)+parseInt(score2)/10) * 26+7);
		})
	}else{
		baison.alert("对不起，您已经评论！");
		return;
	}
	
}

//商品满意度评分
function up_rate(obj,rate,flg){
	var obj = $(obj);
	obj.siblings('.currentScore').width("0");
	get_rate(obj.parent(),rate,flg);
};

//评分绑定单击事件
$(function(){
	var dd = $("dl.g_scored>dd");
	dd.on('click',function(){
		var flg = $(this).parent().attr('is_comment');
		var index = $(this).index();
		up_rate(this,index+'.0',flg);
	});
});

