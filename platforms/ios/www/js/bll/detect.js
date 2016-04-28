$(function () {

    // news_top
    $("#UserCenter").on("panelload", function (e) {
        // $.afui.loadContent("#main");

        var uid = hlp.getparam(1);

        // tpl_mtlist
        svc.getuserprofile(uid, function (r) {

            hlp.binddata(r, "#mtlist", "tpl_mtlist");

        });
    });

    $("#miscellaneous").on("panelload", function (e) {
        hlp.log("before call get customerServicePhone");
        $("#onlineConsult").off("tap").on("tap",function(){
            var tokenId=loj.Credential;
            if(tokenId){
                $.afui.loadContent("#chatHelp");
            }else{
                hlp.lastPage = "#miscellaneous";
                $.afui.loadContent("#login");
            }
        });
        svc.getPhoneNumber(function(r){
            hlp.log("inside call get customerServicePhone");
            if(r.status=="SUCCESS"){
                var phoneNumber=r.result.CustomerServicePhone;
                hlp.bindtpl(phoneNumber, "#customerServicePhone","tpl_CustomerServicePhone");
                hlp.log("call get customerServicePhone result"+r.message);
            }else{
                hlp.log("call get customerServicePhone result"+r.message);
            }
        });
    });

    $("#spotsNearby").on("panelload", function (e) {
        hlp.log("before call get nearbyBranch");
        //获取经纬度
        getMapTude(function(la,lo){
            //var la="31.3105555555";
            //var lo="121.50416666667";
            svc.nearbyBranch(la,lo,function(r){
                hlp.log("inside call get nearbyBranch");
                if(r.status=="SUCCESS"){
                    var nearbybranchList=r.result;
                    for(var i=0;i<nearbybranchList.length;i++){
                        nearbybranchList[i].distance=parseInt(nearbybranchList[i].distance);
                    }
                    hlp.bindtpl(nearbybranchList, "#spotListView","tpl_nearbyBranchList");
                    hlp.log("call get nearbyBranch result"+r.message);
                }else{
                    hlp.log("call get nearbyBranch result"+r.message);
                }
            });
        });
        $("#resetPosition").off("tap").on("tap",function(){
            var tokenId = loj.Credential;
            var resetPosition = $("#currentDddress").val();
            hlp.log("resetPosition:   "+ resetPosition);
            var map = new BMap.Map("allmap");
            var point = "";
            map.centerAndZoom(point,12);
            // 创建地址解析器实例
            var myGeo = new BMap.Geocoder();
            // 将地址解析结果显示在地图上并调整地图视野
            myGeo.getPoint(resetPosition, function(point){
                if (point) {
                    map.centerAndZoom(point, 17);
                    map.addOverlay(new BMap.Marker(point));
                    //hlp.myalert("point.lat:  "+ point.lat+"<<<point.lng:  "+point.lng);
                    var gpsPoint = new BMap.Point(point.lng,point.lat);
                    BMap.Convertor.translate(gpsPoint,0,translateCallback);

                    function translateCallback(point){
                        var la = point.lat;
                        var lo = point.lng;
                        svc.nearbyBranch(la,lo,function(r){
                        	hlp.log("inside call get nearbyBranch");
                            if(r.status=="SUCCESS"){
                                var nearbybranchList=r.result;
                                for(var i=0;i<nearbybranchList.length;i++){
                                    nearbybranchList[i].distance=parseInt(nearbybranchList[i].distance);
                                }
                                hlp.bindtpl(nearbybranchList, "#spotListView","tpl_nearbyBranchList");
                                hlp.log("call get nearbyBranch result"+r.message);
                            }else{
                                hlp.log("call get nearbyBranch result"+r.message);
                            }
                        });
                    }
                }else{
                    hlp.myalert("您选择地址没有解析到结果!");
                }
            });
        });

    });
    $("#hints").on("panelload", function (e) {
        hlp.log("before call detect.js get HintsDetail");
        var tokenId = loj.Credential;
        svc.getHintsDetail(function(r){
            hlp.log("inside call detect.js get HintsDetail");
            if(r.status=="SUCCESS"){
                var helpInfoList=r.helpInfo;
                hlp.bindtpl(helpInfoList, "#div_hints","tpl_hints");
                $("#div_hints a").off("tap").on("tap",function(){
                    var id=$(this).attr("id");
                    for(var i=0;i<helpInfoList.length;i++){
                        if (helpInfoList[i].helpInfoId==id) {
                            hlp.bindtpl(helpInfoList[i].infoContent, "#div_hintsDtl","tpl_hintsDtl");
                            $.afui.loadContent("#hintsDetail");
                        }
                    }
                });
            }else{
                hlp.log(r.message);
            }
        });
    });

    // 在线咨询
    $("#chatHelp").on("panelload", function (e) {
        hlp.log("#chatHelp panelload.");

        cordova.exec(function(){}, function(){}, "InAppBrowser", "open", ['http://kf2.flyco.net.cn/new/client.php?m=Mobile&arg=admin&tokenId='+loj.Credential, '_blank', 'location=no']);
        // ReSharper disable once Html.EventNotResolved
        /*ref.addEventListener('exit', function () { $.afui.goBack(); });*/
    });
});