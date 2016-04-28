$(function () {
    //是否是设备控制者的标志
    hlp.panelObj["deviceControlerFlg"] = {"deviceControlerFlg": 0};
    $.afui.launch();

    // 手动添加
    $("#manuallyAdd").on("panelload", function (e) {
        hlp.log("before call get manuallyAddList");
        //获取当前用户的tokenId
        var tokenId = loj.Credential;
        //获取手动添加设备列表
        svc.getmanuallyAddDeviceData(tokenId, function (r) {
            hlp.log("inside call get manuallyAddList");
            if (r.status == "SUCCESS") {
                hlp.bindtpl(r.result, "#manuallyAddDivs", "tpl_manuallyAdd");
                $("#manuallyAddDivs li").off("tap").on("tap", function () {
                    var productCode = $(this).attr("id");
                    var productModel = $(this).attr("productModel");
                    var productName = $(this).attr("productName");
                    $.afui.loadContent("#deviceSearchResult");
                    hlp.panelObj["productObj"] = {
                        "productCode": productCode,
                        "productModel": productModel,
                        "productName": productName,
                        "macAddress": "",
                        "sn": ""
                    };
                });
                //$("div[id^='pro']").off("tap").on("tap", function () {
                //    var this_id = $(this).attr("id");
                //    var productCode = this_id.substring(4, this_id.length);
                //    var productModel = $(this).attr("productModel");
                //    var productName = $(this).attr("productName");
                //    hlp.panelObj["productObj"] = {
                //        "productCode": productCode,
                //        "productModel": productModel,
                //        "productName": productName,
                //        "macAddress": "",
                //        "sn": ""
                //    };
                //    $.afui.loadContent("#wifiCon");
                //});
            } else {
                hlp.myalert(r.message);
            }
        });
    });

    //在线已配置设备查找结果
    $("#deviceSearchResult").on("panelload", function () {
        var r = {
            "deviceList": [
                {"name": "BayMax", "deviceId": "8a2b4d084f8cc75b014f8ce19d690003"},
                {"name": "钢铁侠", "deviceId": "8945c4c44d9e970e014d9e9dbf2e0001"},
                {"name": "008", "deviceId": "8a2b4d084e24f71d014e28a6f2e20001"}]
        };
        hlp.bindtpl(r.deviceList, "#thelist", "tpl_thelist");
        $("#thelist li").off("tap").on("tap", function () {
            var deviceId = $(this).attr("id");
            var tokenId = loj.Credential;
            hlp.panelObj["cardDeviceId"] = {"deviceId": deviceId};
            //var deviceId = $(this).find(".deviceId").val();
            //hlp.panelObj["cardDeviceId"] = {
            //    "deviceId": deviceId
            //};
            $.afui.loadContent("#nameCard");
            event.stopPropagation();
        });
    });

    //设备名片
    $("#nameCard").on("panelload", function (e) {
        var tokenId = loj.Credential;
        var cardDeviceId = hlp.panelObj["cardDeviceId"];
        if (!cardDeviceId) {
            return;
        }
        var deviceId = cardDeviceId.deviceId;
        var flg = hlp.panelObj["deviceControlerFlg"];
        if (!flg) {
            return;
        };
        hlp.log("begin device.js get device card");
        svc.getDeviceCard(deviceId, tokenId, function (r) {
            hlp.log("inside device.js get device card");
            if (r.status == "SUCCESS") {
                hlp.log("device.js get device card result" + r.message);
                var deviceCardInfo = r.result;
                var ConcernFlg = deviceCardInfo.isUserConcernDevice;
                var ControlFlg = deviceCardInfo.isUserControlDevice;
                if (ControlFlg == "CONTROLLED") {
                    var userControl = ControlFlg.split(":");
                    var userType = userControl[1];
                } else {
                    var userType = "visitor";
                };
                hlp.bindtpl(deviceCardInfo, "#deviceCardInfo", "tpl_deviceCard");
                var device = {"deviceId": deviceId, "userType": userType};
                hlp.panelObj["deviceDtl"] = {"device": device};
                //判断是否在线
                if (deviceCardInfo.onlineStatus == "online") {
                    //$("#online").show();
                    //$("#reWifi").remove();
                    $("#nameCard .button").eq(0).hide();
                } else {
                    $("#nameCard .button").eq(0).show();
                    //$("#offline").show();
                }
                //判断设备是否被控制
                if (ControlFlg == "UNCONTROLLED") {
                    //该设备还未被控制
                    $("#nameCard .button").eq(1).removeClass("disabled");
                    $("#nameCard .button").eq(1).text("添加");
                    //if (deviceCardInfo.controlSettingStatus == 1) {
                    //设备设置控制权限开,控制设置设置为是，允许其他人进行控制
                    //$("#control").removeClass("disabled");
                    //} else {
                    //设备设置控制权限关
                    //$("#deviceCardButtonGroup").remove($("#concern"));
                    //$("#control").remove();
                    //$("#controlSettingStatus").show();
                    //}
                } else {
                    //$("#control").addClass("");
                    //$("#control").text("已控制");
                    //$("#concern").remove();
                    $("#nameCard .button").eq(1).addClass("disabled");
                    $("#nameCard .button").eq(1).text("已添加");
                };
                //判断空气净化器，口气质量级别
                //if (deviceCardInfo.airQuality == "") {
                //    $("#airQuality").text("暂无数据");
                //} else if (deviceCardInfo.airQuality >= 90) {
                //    $("#airQuality").text("优");
                //} else if (deviceCardInfo.airQuality >= 80) {
                //    $("#airQuality").text("良");
                //} else {
                //    $("#airQuality").text("差");
                //}
                //;
                //点击设备名片的设备头像
                $("#deviceCardImg").off("tap").on("tap", function () {
                    if ($("#control").hasClass("disabled")) {
                        //用户身份为主控或副控时
                        flg.deviceControlerFlg = 1;
                    } else {
                        //用户身份为游客或粉丝时
                        flg.deviceControlerFlg = 0;
                    }
                    ;
                    $.afui.loadContent("#deviceIndex");
                });

                //设备名片控制
                $("#nameCard #control").off("tap").on("tap", function () {
                    if ($("#nameCard .button").eq(1).hasClass("disabled")) {
                        return;
                    };
                    cardDeviceAdd(tokenId, deviceId, flg);
                    //if (ConcernFlg == "CONCERNED") {
                    //    hlp.log("begin device.js device card delete followed device ");
                    //    svc.deleteDeviceFollow(deviceId, tokenId, function (r) {
                    //        hlp.log("inside device.js device card delete followed device ");
                    //        if (r.status == "SUCCESS") {
                    //            cardDeviceAdd(tokenId, deviceId, flg);
                    //        } else {
                    //            hlp.myalert(r.message);
                    //        }
                    //        ;
                    //    });
                    //} else {
                    //    cardDeviceAdd(tokenId, deviceId, flg);
                    //}
                });
                //设备名片wifi重置
                $("#reWifi").off("tap").on("tap", function () {
                    var proObj = hlp.panelObj["productObj"];
                    if (!proObj) {
                        return;
                    };
                    svc.getProductInfo(tokenId, proObj.productCode, function (pr) {
                        if (pr.status == "SUCCESS") {
                            hlp.log("getProductInfo result" + pr.message);
                            proObj.productName = pr.product.productName;
                            proObj.sn = "";
                        } else {
                            hlp.log("getProductInfo result" + pr.message);
                        }
                    });
                    $.afui.loadContent("#wifiCon");
                });

            } else {
                hlp.log("device.js get device card result" + r.message);
            }
        });
    });
    $("#nameCard").on("panelunload", function (e) {
        $("#online").hide();
        $("#offline").hide();
        $("#nameCardMes").hide();
    });

    // 我的设备列表
    $("#deviceList").on("panelload", function (e) {

        var tokenId = loj.Credential;
        hlp.log("begin to get devicelist");
        if (!tokenId){
            var NoTokenIdList = [
                {
                    "deviceName": "飞科智能扫地机器人",
                    "image": "",
                    "information": "飞科智能扫地机器人",
                    "runningStatus": "offline",
                    "productCategory": "FC"
                },
                {
                    "deviceName": "飞科智能空气净化器",
                    "image": "",
                    "information": "飞科智能空气净化器",
                    "runningStatus": "offline",
                    "productCategory": "FP"
                }
            ];
            hlp.bindtpl(NoTokenIdList, "#myDeviceContent", "tpl_deviceList");
            if (deviceIndexSwiper) { deviceIndexSwiper.destroy(true,true); }
            deviceIndexSwiper = new Swiper('#myDeviceContent', {
                direction: 'vertical',
                //loop: true,
                slidesPerView : 5,
                centeredSlides : true,
                //loopedSlides :5,
                initialSlide:$(".swiper-slide").length,
                loopAdditionalSlides : 0,
                spaceBetween : (400-window.innerHeight),
                watchSlidesProgress : true,
                watchSlidesVisibility : true,
                touchRatio:0.1,
                iOSEdgeSwipeDetection : true,
                shortSwipes:false
            });
        }else {
            svc.getdevicelist(tokenId,function(r) {
                hlp.log("inside in getting devicelist");
                if (r.status == "SUCCESS"){
                    if(r.OwnedStatus == "EMPTY") {
                        r.OwnedDeviceList = [
                            {
                                "deviceName": "飞科智能扫地机器人",
                                "image": "",
                                "information": "飞科智能扫地机器人",
                                "runningStatus": "offline",
                                "productCategory": "FC"
                            },
                            {
                                "deviceName": "飞科智能空气净化器",
                                "image": "",
                                "information": "飞科智能空气净化器",
                                "runningStatus": "offline",
                                "productCategory": "FP"
                            }
                        ];
                        hlp.bindtpl(r.OwnedDeviceList, "#myDeviceContent", "tpl_deviceList");


                    } else {
                        // 空气净化器标志
                        var fp = false;
                        //扫地机器人标志
                        var fc = false;
                        $.each(r.OwnedDeviceList, function(i) {
                            if (r.OwnedDeviceList[i].productCategory == "FP") {
                                fp = true;
                            } else if (r.OwnedDeviceList[i].productCategory == "FC") {
                                fc = true;
                            }
                        });
                        //var str = JSON.stringify(r.OwnedDeviceList).replace("[","").replace("]","");
                        var str =r.OwnedDeviceList;
                        //如果数据库内没有扫地机器人增加默认
                        if (!fc) {
                            var json_fc =
                                [{
                                    "deviceName": "飞科智能扫地机器人",
                                    "image": "",
                                    "information": "飞科智能扫地机器人",
                                    "runningStatus": "offline",
                                    "productCategory": "FC"
                                }];
                            var str1 = json_fc.concat(str);
                            hlp.bindtpl(str1,"#myDeviceContent","tpl_deviceList");
                        }
                        //如果数据库内没有净化器增加默认
                        if (!fp) {
                            var json_fp =
                                [{
                                    "deviceName": "飞科智能空气净化器",
                                    "image": "",
                                    "information": "飞科智能空气净化器",
                                    "runningStatus": "offline",
                                    "productCategory": "FP"
                                }];
                            var str2 = json_fp.concat(str);
                            hlp.bindtpl(str2,"#myDeviceContent","tpl_deviceList");
                        }
                        if (fc&&fp) {
                            hlp.bindtpl(str,"#myDeviceContent","tpl_deviceList");
                        }
                        $(".round_pic").off("tap").on("tap", function () {
                            var macId = $(this).attr("macId");
                            var productCategory = $(this).attr("productCategory");
                            var runningStatus = $(this).attr("runningStatus");
                            var deviceName = $(this).attr("deviceName");
                            var deviceId = $(this).attr("deviceId");
                            var userType = $(this).attr("userType");
                            var device={
                                "macId": macId,
                                "productCategory": productCategory,
                                "runningStatus": runningStatus,
                                "deviceName": deviceName,
                                "deviceId": deviceId,
                                "userType": userType
                            };
                            hlp.panelObj["deviceDtl"] = {"device":device};
                            if (runningStatus == "online") {
                                if (productCategory == "FP") {
                                    $.afui.loadContent("#cleanerIndex");
                                }
                            } else {
                                //TODO 请点击试用页面
                            }
                        });
                    }
                    if (deviceIndexSwiper) { deviceIndexSwiper.destroy(true,true); }
                    deviceIndexSwiper = new Swiper('#myDeviceContent', {
                        direction: 'vertical',
                        //loop: true,
                        slidesPerView : 5,
                        centeredSlides : true,
                        //loopedSlides :5,
                        initialSlide:$(".swiper-slide").length,
                        loopAdditionalSlides : 0,
                        spaceBetween : (400-window.innerHeight),
                        watchSlidesProgress : true,
                        watchSlidesVisibility : true,
                        touchRatio:0.1,
                        iOSEdgeSwipeDetection : true,
                        shortSwipes:false
                    });
                } else {
                    hlp.myalert("获取设备列表失败");
                }
            });
        }

        ////基础的的callback
        //var barCheckBaseCallback = function (r) {
        //    hlp.myalert("message>>" + r.message);
        //    hlp.log("checkBarcode if bind result" + r.message);
        //};
        ////二维码未被使用的callback
        //var barCheckSuccessCallback = function (r, tokenId, proObj) {
        //    barCheckBaseCallback(r);
        //    svc.getProductInfo(tokenId, proObj.productCode, function (pr) {
        //        if (pr.status == "SUCCESS") {
        //            hlp.log("getProductInfo result" + pr.message);
        //            proObj.productName = pr.product.productName;
        //        } else {
        //            hlp.log("getProductInfo result" + pr.message);
        //        }
        //    });
        //    $.afui.loadContent("#wifiCon");
        //};
        ////二维码已存在的callback
        //var barCheckExistCallback = function (r) {
        //    barCheckBaseCallback(r);
        //    if (r.shareSwitch == 1) {
        //        hlp.panelObj["cardDeviceId"] = {
        //            "deviceId": r.deviceId
        //        }
        //        $.afui.loadContent("#nameCard");
        //    } else {
        //        hlp.myalert("该设备设置隐私保护，无法察看名片信息");
        //    }
        //};
        //
        ////点击支付宝
        //$("#alipay").off("tap").on("tap", function (event) {
        //    alipay(
        //        function (result) {
        //            alert(result);
        //        },
        //        function (err) {
        //            alert("error" + err);
        //        },
        //        "subject", "detail", "0.01"
        //    );
        //});
        ////点击扫一扫
        $(".scanQRcode").off("tap").on("tap", function (event) {
            qRcodeScanner(function (result) {
                    var barcode = result.text;
                    //var barcode="001500900830000001";
                    var barcodeLength = barcode.length;
                    if (barcodeLength != 18) {
                        hlp.myalert("无效设备，请重新扫描飞科智能产品二维码!");
                    } else {
                        var productCode = barcode.substring(6, 10);
                        var productModel = barcode.substring(10, 11);
                        var sn = barcode;
                        hlp.panelObj["productObj"] = {
                            "productCode": productCode,
                            "productModel": productModel,
                            "productName": "",
                            "macAddress": "",
                            "sn": sn
                        };
                        var proObj = hlp.panelObj["productObj"];
                        hlp.myalert("sn>>" + sn);
                        checkBarcode(tokenId, sn, proObj, barCheckSuccessCallback, barCheckExistCallback, barCheckBaseCallback);
                    }
                },
                function (error) {
                    hlp.myalert("Scanning failed: " + error);
                });
        });
        //DeviceListInit();
    });
    $("#deviceList").on("panelunload", function (e) {
    });



    //添加设备页面
    $("#addMenu").on("panelload", function (e) {}
    );

    //我关注的设备页面
    $("#followDeviceList").on("panelload", function (e) {

        $.afui.setBackButtonVisibility(false);
        hlp.log("before call get Famiallydevicelist");
        //获取关注的设备
        getFollowDeviceList();
        //我的设备页面绑定滑动事件
        $("#followDeviceList").bind("swipe", function () {
            hlp.log("inside followDeviceList swipe function...");
            $.afui.loadContent("#deviceList");
        });
    });
    $("#followDeviceList").on("panelunload", function (e) {
        $.afui.setBackButtonVisibility(true);
    });

    // 设备控制主页
    $("#deviceIndex").on("panelload", function (e) {
        $(".menuButton").show();
        //创建控制圆盘
        //creatKnob('#mainKnob');
        //creatKnob('#modeKnob');
        //creatKnob('#speedKnob');
        //creatKnob('#timingKnob');
        //creatKnob('#lightKnob');
        //creatKnob('#ionKnob');
        //creatKnob('#sensorKnob')

        //TODO 获取设备开关状态并显示相应button,目前暂时显示开
        $('#powerButtons .on').show();


        //转盘显示
        $(".knob .top").on("touchend", function (e) {
            var buttonsId = '#' + $('.colorBar.active').attr("id") + 'Buttons';
            $('#purifierScreen ul').show();
            $('.button').css({'margin-top': '13%','padding':'10%'});
            $('.button').hide();
            if ($(buttonsId + ' .button').hasClass('on')) {
                $(buttonsId + ' .on').show();
            } else {
                $(buttonsId + ' .off').show();
            }
        });

        //选择选项返回状态主页+点击按钮显示选项
        $('.button').off("tap").on("tap", function (e) {
            if ($('#purifierScreen ul').css('display') == 'none') {
                $('#purifierScreen ul').show();
                $('.button').css({'margin-top': '13%','padding':'10%'});
                $(this).siblings('.on').removeClass('white').removeClass('on').addClass('transparent');
                $(this).siblings().hide();
                if (!$(this).hasClass('off')) {
                    $(this).addClass('white on').removeClass('transparent');
                }
            } else {
                $('#purifierScreen ul').hide();
                $('.button').css({'margin-top': '0','padding':'3%'});
                $(this).siblings().show();
            }
        });

    });
    $("#deviceIndex").on("panelunload", function (e) {
        $(".menuButton").hide();
        $(".popupMyDevice").hide();
        $(".popupMyFollowedDevice").hide();
    });

    // 净化器主页
    $("#cleanerIndex").on("panelload", function (e) {
        $("#deviceList .addScan").hide();
        var deviceDetail = hlp.panelObj["deviceDtl"];
        //var mac_id = "18fe34a2e9b0";
        var mac_id = deviceDetail.device.macId;
        var tokenId = loj.Credential;
        $("#cleanerIndex").attr("data-title",deviceDetail.device.deviceName);
        $.de.context = { "tokenid": tokenId, "mac_id": mac_id };
        renderStatusBoard();

        //点击滤网图标
        $(".filter").off("tap").on("tap", function() {
           $(".cleaner-control").hide();
            $(".filter-control").show();
            $(".cleanerFooter").hide();
            $(".netFooter").show();
        });

        //点击滤网返回
        $(".to-cleaner-control").off("tap").on("tap", function() {
            $(".cleaner-control").show();
            $(".filter-control").hide();
            $(".cleanerFooter").show();
            $(".netFooter").hide();
        });

        //定时关机
        //初始化选择控件
        //$("#scroller").mobiscroll().timer({
        //    theme: 'ios',
        //    lang: 'zh',
        //    display: 'bottom',
        //    countDirection: 'down',
        //    targetTime: 10,
        //    maxWheel: 'hours',
        //    minWidth: 100,
        //    onFinish: function () { alert('Countdown finished!'); }
        //});

        // 开关净化器
        $(".mask").attr("data-name","");
        $(".mask img").off("tap").on("tap", function() {
            trunOnOff(mac_id);
        });

        //开关离子净化
        $(".cleanerFooter a").eq(0).attr("data-name","");
        $(".cleanerFooter a").eq(0).off("tap").on("tap", function() {
            liziOnOff(mac_id);
        });

        //灯效控制
        $(".cleaner-control .light").off("tap").on("tap",function() {
            lightPopup = $.afui.popup({
                title: " ",
                message:
                '<p id="lightNormal">正常</p>'+'<br>'+'<p id="lightHalf">半开</p>'+'<br>'+'<p id="lightOff">关闭</p>',
                cancelText: "确&nbsp;&nbsp;定",
                cancelCallback: function () {
                    myPopup = null;
                    return;
                },
                cancelOnly:true
            });
            //正常
            $("#lightNormal").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("Normal");
                $(".cleaner-control .light").attr("src","images/cleaner-index/light_full.png");
            });
            //半开
            $("#lightHalf").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("Half");
                $(".cleaner-control .light").attr("src","images/cleaner-index/light_half.png");
            });
            //关闭
            $("#lightOff").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("LightOff");
                $(".cleaner-control .light").attr("src","images/cleaner-index/light_off.png");
            });
        });

        //风速控制
        $(".cleanerFooter a").eq(2).off("tap").on("tap", function() {
            windPopup = $.afui.popup({
                title: " ",
                message:
                '<p id="windAuto">智能模式</p>'+'<br>'+'<p id="windSleep">睡眠模式</p>'+'<br>'+'<p id="windStrong">强劲模式</p>'+
                '<br>'+'<p id="windOne">1档</p>'+'<br>'+'<p id="windTwo">2档</p>'+'<br>'+'<p id="windThree">3档</p>',
                cancelText: "确&nbsp;&nbsp;定",
                cancelCallback: function () {
                    windPopup = null;
                    return;
                },
                cancelOnly:true
            });
            //智能模式
            $("#windAuto").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.context = { "tokenid": tokenId, "mac_id": mac_id };
                $.de.triggeropt("runmodelauto");
                $(".status-bar .col3").eq(2).text("智能模式");
            });
            //睡眠模式
            $("#windSleep").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("runmodelsleep");
                $(".status-bar .col3").eq(2).text("睡眠模式");
            });
            //强劲模式
            $("#windStrong").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("runmodelstrong");
                $(".status-bar .col3").eq(2).text("强劲模式");
            });
            //1档
            $("#windOne").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("HandOne");
                $(".status-bar .col3").eq(2).text("1档");
            });
            //2档
            $("#windTwo").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("HandTwo");
                $(".status-bar .col3").eq(2).text("2档");
            });
            //3档
            $("#windThree").off("tap").on("tap",function() {
                console.log("TST::tokenId:" + tokenId);
                $.de.triggeropt("HandThree");
                $(".status-bar .col3").eq(2).text("3档");
            });
        });
    });

    var renderStatusBoard = function () {
        $.de.getStatus(function (r) {
            console.log("RESULT:" + JSON.stringify(r));

            //空气质量圆圈
            $('.circle').each(function(index, el) {
                $(this).find('span').text(r.pmValue);
                var num = $(this).find('span').text() * 3.6 / 5;

                //旋转
                if (num <= 180) {
                    $(this).find('.right').css('transform', "rotate(" + num + "deg)");
                } else {
                    $(this).find('.right').css('transform', "rotate(180deg)");
                    $(this).find('.left').css('transform', "rotate(" + (num - 180) + "deg)");
                };

                //颜色和文字
                if (num <= 72) {
                    $(".left,.right").css("background", "#0088ff");
                    $(".indoor-air-level").text("室内空气优");
                } else if (num <= 144) {
                    $(".left,.right").css("background", "#ff7700")
                    $(".indoor-air-level").text("室内空气良");
                } else {
                    $(".left,.right").css("background", "#ff0022")
                    $(".indoor-air-level").text("室内空气差");
                };
            });

            //滤网剩余时间


            //判断初始净化器开关机状态
            if (r.powerSwitch == "poweron") {
                $.de.startmonitor();
                $(".mask").attr("data-name","TrunOn");
                $(".mask img").attr("src","images/cleaner-index/on.png");
            } else {
                $.de.stopmonitor();
                $(".mask").attr("data-name","TrunOff");
                $(".mask img").attr("src","images/cleaner-index/off.png");
            }

            //判断初始净化器离子净化开关状态
            if (r.anionSwitch == "anionon") {
                $(".cleanerFooter a").eq(0).attr("data-name","LiziOn");
                $(".status-bar .col3").eq(0).text("已开启");
            } else {
                $(".cleanerFooter a").eq(0).attr("data-name","LiziOff");
                $(".status-bar .col3").eq(0).text("已关闭");
            }

            //判断初始净化器灯效状态
            if (r.light_status == "lighton") {
                $(".cleaner-control .light").attr("src","images/cleaner-index/light_full.png");
            } else if (r.light_status == "lighthalfon") {
                $(".cleaner-control .light").attr("src","images/cleaner-index/light_half.png");
            } else {
                $(".cleaner-control .light").attr("src","images/cleaner-index/light_off.png");
            }

            //判断初始净化器风速状态
            if (r.runningMode == "one") {
                $(".status-bar .col3").eq(2).text("1档");
            } else if (r.runningMode == "two") {
                $(".status-bar .col3").eq(2).text("2档");
            } else if (r.runningMode == "three") {
                $(".status-bar .col3").eq(2).text("3档");
            } else if (r.runningMode == "strong") {
                $(".status-bar .col3").eq(2).text("强劲模式");
            } else if (r.runningMode == "auto") {
                $(".status-bar .col3").eq(2).text("智能模式");
            } else if (r.runningMode == "sleep") {
                $(".status-bar .col3").eq(2).text("睡眠模式");
            }

            $("#dsplboard").html("");

            var s = $.de.entities.ShowInfo;
            var tmp = null;
            $.each(r, function (k, v) {
                tmp = eval("s." + k);
                if (!!tmp) {
                    var tmpObj = $("#dbk__" + k + "");
                    if (tmpObj.length == 0)
                        $("#dsplboard").append("<div class='wt' id='dbk__" + k + "'>" + tmp + ":" + v + "</div>");
                    //else
                    //    $("#dbk__" + k + "").toggleClass("wtg").html(tmp + ":" + v);
                }
            });
        });
    };

    //开关净化器
    var trunOnOff = function(mac_id) {
        var tokenId = loj.Credential;
        console.log("TST::tokenId:" + tokenId);
        var trunType =  $(".mask").attr("data-name").trim();
        if (trunType.length == 0 || trunType == "TrunOff") {
            $.de.triggeropt("TrunOn");
            $.de.monitor = function () {
                $.de.getStatus(function (r) {
                    console.log("RESULT:" + JSON.stringify(r));
                });
            };
            $.de.startmonitor();
            $(".mask").attr("data-name","TrunOn");
            $(".mask img").attr("src","images/cleaner-index/on.png");
        } else if (trunType == "TrunOn") {
            $.de.triggeropt("TrunOff");
            $.de.stopmonitor();
            $(".mask").attr("data-name","TrunOff");
            $(".mask img").attr("src","images/cleaner-index/off.png");
        }
    };

    //开关离子净化
    var liziOnOff = function(mac_id) {
        var tokenId = loj.Credential;
        console.log("TST::tokenId:" + tokenId);
        var trunType =  $(".cleanerFooter a").eq(0).attr("data-name").trim();
        if (trunType.length == 0 || trunType == "LiziOff") {
            $.de.triggeropt("LiziOn");
            $(".cleanerFooter a").eq(0).attr("data-name","LiziOn");
            $(".status-bar .col3").eq(0).text("已开启");
        } else if (trunType == "LiziOn") {
            $.de.triggeropt("LiziOff");
            $(".cleanerFooter a").eq(0).attr("data-name","LiziOff");
            $(".status-bar .col3").eq(0).text("已关闭");
        }
    }

    //wifi配置
    $("#wifiCon").on("panelload", function (e) {
        //password输入框初始化
        $("#wifiCon #wifiPassword").val("");

        //wifiCon初期化时获取SSID
        try {
            getssid(function (data) {
                var ssid = data.lan.SSID;
                if (ssid.indexOf("unknown") > 0) {
                    hlp.bindtpl("检测您没有连接WIFI，将无法绑定！", "#wifiSSIDDiv", "tpl_wifi");
                    jQuery('#wifissid').val("");
                } else {
                    hlp.bindtpl(data.lan.SSID, "#wifiSSIDDiv", "tpl_wifi");
                    jQuery('#wifissid').val(data.lan.SSID);
                }
            }, function (error) {
                hlp.log("getssid error:" + error);
            });
        } catch (e) {
            hlp.bindtpl("手机插件加载失败", "#wifiSSIDDiv", "tpl_wifi");
            jQuery('#wifissid').val("");
        }

        //window.setInterval(function () {
        //}, 1000);
        //var ssid_new="ssid123";
        //hlp.bindtpl(ssid_new, "#wifiSSIDDiv", "tpl_wifi");
        //jQuery('#wifissid').val(ssid_new);

        //配置WIFI界面，点击下一步按钮事件
        $("#wifiSure").off("tap").on("tap", function () {
            var ssid = jQuery('#wifiCon #wifissid').val();
            var password = jQuery('#wifiCon #wifiPassword').val();
            if(ssid.trim().length>0){
                if(password.trim().length>0){
                    $.afui.loadContent("#connecting");
                }else{
                    hlp.myalert("请输入密码！");
                }
            }else{
                hlp.myalert("请确认网络连接状态！");
            }
        });
    });

    $("#wifiCon").on("panelunload", function (e) {
        hlp.panelObj["deviceWifiReset"] = {
            "isReset": false
        };
    });

    //wifi配置正在连接中
    $("#connecting").on("panelload", function (e) {
        $.afui.setBackButtonVisibility(false);
        setTimeout(function(){
            connectingFunction();
        },3000)
        $("#connectBtn a").eq(1).off("tap").on("tap",function(){
            connectingFunction();
        });
    });

    $("#connecting").on("panelunload", function (e) {
        $.afui.setBackButtonVisibility(true);
    });

//setting

    //editDeviceName
    $("#editDeviceName").on("panelload", function (e) {
        var tokenId = loj.Credential;
        var deviceDtl=hlp.panelObj["deviceDtl"];
        if(!deviceDtl){
            return;
        }else{
            deviceDtl=deviceDtl.device;
            hlp.bindtpl(deviceDtl.deviceName, "#deviceEditName_Div", "tpl_deviceEditName");
        }

        $(".saveButton").off("tap").on("tap", function () {
            var deviceEditName = $("#deviceEditName").val();
            if (deviceEditName.trim().length == 0 ) {
                deviceEditName = $("#deviceEditName").attr("placeholder");
            }
            //var deviceEditImg=$("#showMyImg").attr("src");
            updateDeviceInfo(deviceDtl.deviceId, tokenId, deviceEditName, "");

        });

    });

    //设备权限
    $("#deviceAuthority").on("panelload", function (e) {
        var deviceId = "";
        var tokenId = loj.Credential;
        var pt = hlp.panelObj["deviceDtl"];
        if (pt) {
            deviceId = pt.device.deviceId;
            svc.getDeviceAuthority(deviceId, tokenId, function (r) {
                if (r.status == "SUCCESS") {
                    var primaryOwner = "";
                    var secondaryOwner = [];
                    var allOwner = "";
                    hlp.log("get deviceAuthority list result" + r.message);
                    var ownerList = r.deviceOwners;
                    for (var i = 0; i < ownerList.length; i++) {
                        if (ownerList[i].userType == "primary") {
                            primaryOwner = ownerList[i];
                        } else if (ownerList[i].userType == "secondary") {
                            secondaryOwner.push(ownerList[i]);
                        }
                    }
                    ;
                    allOwner = {"primaryOwner": primaryOwner, "secondaryOwnerList": secondaryOwner};
                    hlp.bindtpl(allOwner, "#Owner", "tpl_deviceAuthority");
                    $("li[id^='assOwner']").off("longTap").on("longTap", function () {
                        if (pt.device.userType == "primary") {
                            var li_userId = $(this).attr("id");
                            var userId = li_userId.substring(8, li_userId.length);
                            var ownerName = $(this).attr("userName");
                            //var deleteFlg = confirm("是否确认要解除该设备主人" + ownerName + "的控制权限？");
                            $.afui.popup({
                                title: "提示",
                                message: "是否确认要解除该设备主人" + ownerName + "的控制权限？?",
                                cancelText: "取&nbsp;&nbsp;消",
                                doneText: "确&nbsp;&nbsp;定",
                                cancelCallback: function () {
                                    hlp.log("deleteSecondary cancel");
                                    return;
                                },
                                doneCallback: function () {
                                    hlp.log("deleteSecondary do");
                                    svc.deleteSecondary(deviceId, tokenId, userId, function (r) {
                                        if (r.status == "SUCCESS") {
                                            hlp.log("deleteSecondary result" + r.message);
                                            $("#" + li_userId).remove();
                                        } else {
                                            hlp.log("deleteSecondary result" + r.message);
                                        }
                                    })
                                }
                            });
                        } else {
                            return;
                        }
                    });
                } else {
                    hlp.log("get deviceAuthority list result" + r.message);
                }
            });
        }
    });

    //设备粉丝
    $("#deviceFans").on("panelload", function (e) {
        hlp.log("before call get device fans list");
        //获取当前用户的tokenId
        var pt = hlp.panelObj["deviceDtl"];
        if (!pt) {
            return;
        }
        //获取当前用户的tokenId
        var deviceId = pt.device.deviceId.toString();
        var tokenId = loj.Credential;
        //获取手动添加粉丝列表
        svc.getDeviceFans(deviceId, tokenId, function (r) {
            if (r.status == "SUCCESS") {
                hlp.log("get device fans list result " + r.message);
                hlp.bindtpl(r, "#deviceFansList", "tpl_deviceFansListAdd");
            } else {
                hlp.log("get device fans list error result" + r.message);
            }
        });
    });

    //设备日志
    $("#deviceLog").on("panelload", function (e) {
        $(".searchButton").show();
        var pt = hlp.panelObj["deviceDtl"];
        var deviceId = "";
        if (pt) {
            deviceId = pt.device.deviceId;
        }
        var tokenId = loj.Credential;
        var date = "";
        var handlerId = "";
        var source = "";
        //操作用户列表
        var ownerList = "";
        //操作时间
        var logTime = getNowDate();

        svc.getDeviceAuthority(deviceId, tokenId, function (r) {
            if (r.status == "SUCCESS") {
                hlp.log("get deviceAuthority list result" + r.message);
                ownerList = r.deviceOwners;
                var deviceLogData = {"logList": "", "handlerList": ownerList, "logTime": logTime};
                getLogList(deviceId, date, tokenId, handlerId, source, deviceLogData);
            } else {
                hlp.log("get deviceAuthority list result" + r.message);
            }
        });
    });
    $("#deviceLog").on("panelunload", function (e) {
        $(".searchButton").hide();
        $("#filterForm").hide();
    });

    // 设备故障列表
    $("#deviceErrorList").on("panelload", function (e) {
        hlp.log("before call get device error list");
        var pt = hlp.panelObj["deviceDtl"];
        if (!pt) {
            return;
        }
        //获取当前用户的tokenId
        var deviceId = pt.device.deviceId.toString();
        var tokenId = loj.Credential;
        //获取手动添加设备列表
        svc.getDeviceErrorList(deviceId, tokenId, function (r) {
            hlp.log("inside call get device error list");
            if (r.status == "SUCCESS") {
                hlp.bindtpl(r, "#deviceErrorInfo", "tpl_deviceErrorListAdd");
                var li = $("#deviceErrorInfo li");
                $.each(li, function (i) {
                    var status = li.eq(i).find(".deviceMsgStatus").val();
                    if (status == "Y") {
                        li.eq(i).css("color", "gray");
                    } else {
                        li.eq(i).css("color", "black");
                    }
                });
                // delete button
                $("li .archive").off("tap").on("tap", function () {
                    var myDevice = $($(this)[0].parentElement);
                    var deviceMsgId = $(myDevice[0].parentElement).find(".deviceMsgId").val();
                    var pt = hlp.panelObj["deviceDtl"];
                    var userType = pt.device.userType.toString();
                    if (userType != "primary") {
                        hlp.myalert("您没有权限删除!");
                        return;
                    }
                    svc.deleteDeviceErrorInfo(deviceMsgId, tokenId, function (r) {
                        if (r.status == "SUCCESS") {
                            myDevice.closest('.swipe-reveal').remove();
                            hlp.myalert("删除成功!");
                        } else {
                            hlp.myalert(r.message);
                        }
                    });
                });
                $("li .swipe-content").off("tap").on("tap", function () {
                    var myDevice = $($(this)[0].parentElement);
                    var deviceMsgId = myDevice.find(".deviceMsgId").val();
                    var deviceMsgContent = myDevice.find(".deviceMsgContent").val();
                    var deviceMsgStatus = myDevice.find(".deviceMsgStatus").val();
                    var deviceMsgTime = myDevice.find(".deviceMsgTime").val();
                    var deviceMsgDetailTime = myDevice.find(".deviceMsgDetailTime").val();
                    var deviceMsgTitle = myDevice.find(".deviceMsgTitle").val();
                    hlp.panelObj["deviceErrorListObj"] = {
                        "deviceMsgId": deviceMsgId,
                        "deviceMsgContent": deviceMsgContent,
                        "deviceMsgStatus": deviceMsgStatus,
                        "deviceMsgTime": deviceMsgTime,
                        "deviceMsgDetailTime": deviceMsgDetailTime,
                        "deviceMsgTitle": deviceMsgTitle,
                        "phoneNumber": ""
                    };
                    svc.updateDeviceErrorInfo(deviceMsgId, tokenId, function (r) {
                        if (r.status == "SUCCESS") {
                            myDevice.css("color", "gray");
                            $.afui.loadContent("#deviceErrorDetail");
                        } else {
                            hlp.myalert(r.message);
                        }
                    });
                });
            } else {
                hlp.myalert(r.message);
            }
        });
    });

    // 设备故障详情
    $("#deviceErrorDetail").on("panelload", function (e) {
        var pt = hlp.panelObj["deviceErrorListObj"];
        if (pt) {
            svc.getPhoneNumber(function (r) {
                hlp.log("inside call get phone number");
                if (r.status == "SUCCESS") {
                    pt.phoneNumber = r.result.CustomerServicePhone;
                    //初期化昵称和分组
                    hlp.bindtpl(pt, "#deviceErrorDetailInfo", "tpl_deviceErrorDetailAdd");
                    $(".online-advisory").on("tap", function () {
                        $.afui.loadContent("#chatHelp");
                    });
                    $(".spots-nearby").on("tap", function () {
                        $.afui.loadContent("#spotsNearby");
                    });
                } else {
                    hlp.myalert(r.message);
                }
            });
        }
    });

    //设备设置
    $("#deviceSetting").on("panelload", function (e) {
        hlp.log("before call device setting");
        //获取当前用户的tokenId
        var pt = hlp.panelObj["deviceDtl"];
        if (!pt) {
            return;
        }
        //获取当前用户的tokenId
        var deviceId = pt.device.deviceId.toString();
        var tokenId = loj.Credential;
        var userType = pt.device.userType.toString();
        if (userType != "primary") {
            $("#deviceSetting input").attr("disabled", true);
            hlp.myalert("您没有权限设置!");
        } else {
            $("#deviceSetting input").attr("disabled", false);
        }
        svc.getDeviceSetting(deviceId, tokenId, function (r) {
            if (r.status == "SUCCESS") {
                var result = r.result;
                $.each(result, function (i) {
                    var settingType = Number(result[i].settingType);
                    var settingStatus = Number(result[i].settingStatus);
                    switch (settingType) {
                        case 1: // 定时开关
                            getDeviceSetting(settingStatus, $("#timingSwitch"));
                            break;
                        case 2: // 控制设置
                            getDeviceSetting(settingStatus, $("#controlSwitch"));
                            break;
                        case 3: // 分享设置
                            getDeviceSetting(settingStatus, $("#shareSwitch"));
                            break;
                        default:
                            break;
                    }
                });
            } else {
                hlp.myalert(r.message);
            }
        });
        $(".switchTiming #timingSwitch").off("click").on("click", function (event) {
            setDeviceSetting(1, $("#timingSwitch"));
        });
        $(".switchTiming #controlSwitch").off("click").on("click", function () {
            setDeviceSetting(2, $("#controlSwitch"));
        });
        $(".switchTiming #shareSwitch").off("click").on("click", function () {
            setDeviceSetting(3, $("#shareSwitch"));
        });
        $(".switchTiming").off("tap").on("tap", function (e) {
            var pt = hlp.panelObj["deviceDtl"];
            if (!pt) {
                return;
            }
            var userType = pt.device.userType.toString();
            if (userType != "primary") {
                hlp.myalert("您没有权限设置!");
                return;
            }
            var attr = $(e.target).attr("st");
            if (attr != "ts") {
                var settingStatus = $("#timingSwitch").val();
                if (settingStatus == 1) {
                    $.afui.loadContent("#timing");
                }
            }
        });
        //传感器开关默认值
        //传感器设置
        $("#sensor_switch").off("click").on("click",function(){
            hlp.log("before setMySetting function...");
            var flg = $("#sensor_switch").val();

        });
    });

    //定时开关
    $("#timing").on("panelload", function (e) {
        hlp.log("before call timing setting");
        //获取当前用户的tokenId
        var pt = hlp.panelObj["deviceDtl"];
        if (!pt) {
            return;
        }
        //获取当前用户的tokenId
        var deviceId = pt.device.deviceId.toString();
        var tokenId = loj.Credential;
        svc.getTiming(deviceId, tokenId, function (r) {
            if (r.status == "SUCCESS") {
                $("#timing1").val(r.deviceTimer.powerOnTime.toString());
                $("#timing2").val(r.deviceTimer.powerOffTime.toString());
                $(".timingSave .button").off("tap").on("tap", function () {
                    var timing1 = $("#timing1").val();
                    var timing2 = $("#timing2").val();
                    svc.setTiming(deviceId, tokenId, timing1, timing2, function (r) {
                        $("#timing1").val(timing1);
                        $("#timing2").val(timing2);
                        if (r.status == "SUCCESS") {
                            hlp.myalert("保存成功!");
                        } else {
                            hlp.myalert(r.message);
                        }
                    });
                });
            } else {
                hlp.myalert(r.message);
            }
        });
    });

    //昵称查找按钮
    //$("#deviceSearch").on("panelload", function () {
    //    $("#search").on("tap", function () {
    //        var InputNickName = document.getElementById("searchInput").value;
    //        loj.setInputNickName(InputNickName);
    //        $.afui.loadContent("#deviceSearchResult");
    //
    //    });
    //    var nickname = loj.InputNickName;
    //    var tokenId = loj.Credential;
    //    svc.getnickdevicelist(nickname, tokenId, function (r) {
    //        hlp.log("inside call get Nickdevice list.");
    //        if (r.status == "SUCCESS") {
    //            hlp.bindtpl(r.deviceList, "#device1", "tpl_nickdevice");
    //            $("li.nickdev-info").off("tap").on("tap", function () {
    //                var deviceId = $(this).find(".deviceId").val();
    //                hlp.panelObj["cardDeviceId"] = {
    //                    "deviceId": deviceId
    //                };
    //                $.afui.loadContent("#nameCard");
    //            });
    //        } else {
    //            hlp.bindtpl("", "#device1", "tpl_nickdevice");
    //            hlp.log(r.message);
    //        }
    //    });
    //});

    //关注度设备排名
    $("#attentionRank").on("panelload", function () {
        var tokenId = loj.Credential;
        svc.getattentdevicelist(tokenId, function (r) {
            hlp.log("inside call get attentiondevice list.");
            if (r.status == "SUCCESS") {
                hlp.bindtpl(r.result, "#attentdevic", "tpl_attentdevice");
                $("li.attentionrank-info").off("tap").on("tap", function () {
                    var deviceId = $(this).find(".deviceId").val();
                    hlp.panelObj["cardDeviceId"] = {
                        "deviceId": deviceId
                    };
                    $.afui.loadContent("#nameCard");
                });
            } else {
                hlp.bindtpl("", "#attentdevic", "tpl_attentdevice");
                hlp.log(r.message);
            }
        });

    });

    //附近设备查询
    $("#deviceNearby").on("panelload", function () {
        var tokenId = loj.Credential;
        getTude(function (la, lo) {
            //var la = "31.3105555555";
            //var lo = "121.50416666667";
            //alert("latitude>>>"+la+",,,longitude>>>"+lo);
            svc.nearbydevice(tokenId, la, lo, function (r) {
                hlp.myalert("inside nearby device list");
                if (r.status == "SUCCESS") {
                    hlp.bindtpl(r.result, "#nearbydevic", "tpl_nearbydevice");
                    $("li.nearbydevice-info").off("tap").on("tap", function () {
                        var deviceId = $(this).find(".deviceId").val();
                        hlp.panelObj["cardDeviceId"] = {
                            "deviceId": deviceId
                        };
                        $.afui.loadContent("#nameCard");
                    });
                } else {
                    hlp.bindtpl("", "#nearbydevic", "tpl_nearbydevice");
                    hlp.myalert(r.message);
                }
            });
        });

    });
    
    //关于设备
    $("#aboutDevice").on("panelload", function (e) {
        var deviceDtl = hlp.panelObj["deviceDtl"];
        var tokenId = loj.Credential;
        var deviceId = "";
        var deviceImg = "";
        if (!deviceDtl) {
            return;
        } else {
            deviceId = deviceDtl.device.deviceId;
        }
        ;
        svc.getDeviceDtl(deviceId, tokenId, function (r) {
            if (r.status == "SUCCESS") {
                var device = r.DeviceInfo;
                device.image = device.image == "" ? "./images/mydevicelist/" + device.productCode + ".png" : device.image;
                //关于设备页面初始化
                hlp.bindtpl(device, "#deviceDtl", "tpl_aboutDevice");
                //设备昵称页面初始化
                hlp.bindtpl(device.deviceName, "#deviceEditName_Div", "tpl_deviceEditName");
                //二维码
                $('#barCode').qrcode({
                    width: "50",
                    height: "50",
                    text: toUtf8(device.barCode)
                });
                var canvas = $('#barCode canvas')[0];
                var dataURL = canvas.toDataURL();
                hlp.panelObj["barcodeDataURL"] = {"dataURL": dataURL};

                //check当前版本是否需要更新
                svc.getFirmwareUpdateFlg(device.deviceId, tokenId, function (r) {
                    if (r.status == "SUCCESS") {
                        hlp.log("device.js FirmwareUpdateFlg result" + r.message);
                        $("#deviceVersionFlag").text("下载新版本");
                        var firmwareId = r.firmwareId;
                        $("#deviceVersionFlag").off("tap").on("tap", function () {
                            $.afui.blockUIwithMask();
                            svc.updateFirmware(tokenId, firmwareId, function (r) {
                                if (r.status == "SUCCESS") {
                                    //固件升级成功！
                                    hlp.myalert(r.message);
                                    $("#deviceVersionFlag").text("");
                                    setTimeout(function () {
                                        $.afui.unBlockUIwithMask();
                                    }, 1000);
                                } else {
                                    hlp.myalert("device.js updateFirmware result" + r.message);
                                    setTimeout(function () {
                                        $.afui.unBlockUIwithMask();
                                    }, 1000);
                                }
                                ;
                            });
                        });
                    } else {
                        hlp.log("device.js FirmwareUpdateFlg result" + r.message);
                    }
                });

                //点击设备昵称进入昵称修改界面
                $("#toEditDeviceName").off("tap").on("tap", function () {
                    if (device.userType == "primary") {
                        $.afui.loadContent("#editDeviceName");
                    }
                });
                //修改设备昵称
                $("#aboutDeviceUpdate").off("tap").on("tap", function () {
                    var deviceEditName = $("#deviceEditName").val();
                    if (deviceEditName == "") {
                        deviceEditName = $("#deviceEditName").attr("placeholder");
                    }
                    //var deviceEditImg=$("#showMyImg").attr("src");
                    updateDeviceInfo(device.deviceId, tokenId, deviceEditName, "");
                    $("#deviceNike").text(deviceEditName);
                    device.deviceName = deviceEditName;
                });
                //修改设备头像时点击图片
                $("#deviceDtlImg").off("tap").on("tap", function () {
                    if (device.userType == "primary") {
                        imageRcodeScanner(function (imgdata) {
                            hlp.log("inside device.js getPicture function...");
                            var imageSrc = imgdata;
                            //var imageSrc="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";
                            //var imageSrc="iVBORw0KGgoAAAANSUhEUgAAAUAAAAFACAYAAADNkKWqAAAACXBIWXMAAAsTAAALEwEAmpwYAAA4KmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMwMTQgNzkuMTU2Nzk3LCAyMDE0LzA4LzIwLTA5OjUzOjAyICAgICAgICAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKICAgICAgICAgICAgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIgogICAgICAgICAgICB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIKICAgICAgICAgICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIj4KICAgICAgICAgPHhtcDpDcmVhdG9yVG9vbD5BZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoTWFjaW50b3NoKTwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8eG1wOkNyZWF0ZURhdGU+MjAxNS0wNS0yN1QxMTo1MTo0NyswODowMDwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDE1LTA2LTExVDEwOjMzOjUzKzA4OjAwPC94bXA6TW9kaWZ5RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAxNS0wNi0xMVQxMDozMzo1MyswODowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9wbmc8L2RjOmZvcm1hdD4KICAgICAgICAgPHBob3Rvc2hvcDpDb2xvck1vZGU+MzwvcGhvdG9zaG9wOkNvbG9yTW9kZT4KICAgICAgICAgPHhtcE1NOkluc3RhbmNlSUQ+eG1wLmlpZDoxYTBmZjcxNS05MjRlLTQ3YjYtYTgxZC02NDMzYTA1OWM3MjU8L3htcE1NOkluc3RhbmNlSUQ+CiAgICAgICAgIDx4bXBNTTpEb2N1bWVudElEPnhtcC5kaWQ6MWEwZmY3MTUtOTI0ZS00N2I2LWE4MWQtNjQzM2EwNTljNzI1PC94bXBNTTpEb2N1bWVudElEPgogICAgICAgICA8eG1wTU06T3JpZ2luYWxEb2N1bWVudElEPnhtcC5kaWQ6MWEwZmY3MTUtOTI0ZS00N2I2LWE4MWQtNjQzM2EwNTljNzI1PC94bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+CiAgICAgICAgIDx4bXBNTTpIaXN0b3J5PgogICAgICAgICAgICA8cmRmOlNlcT4KICAgICAgICAgICAgICAgPHJkZjpsaSByZGY6cGFyc2VUeXBlPSJSZXNvdXJjZSI+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDphY3Rpb24+Y3JlYXRlZDwvc3RFdnQ6YWN0aW9uPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6aW5zdGFuY2VJRD54bXAuaWlkOjFhMGZmNzE1LTkyNGUtNDdiNi1hODFkLTY0MzNhMDU5YzcyNTwvc3RFdnQ6aW5zdGFuY2VJRD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OndoZW4+MjAxNS0wNS0yN1QxMTo1MTo0NyswODowMDwvc3RFdnQ6d2hlbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnNvZnR3YXJlQWdlbnQ+QWRvYmUgUGhvdG9zaG9wIENDIDIwMTQgKE1hY2ludG9zaCk8L3N0RXZ0OnNvZnR3YXJlQWdlbnQ+CiAgICAgICAgICAgICAgIDwvcmRmOmxpPgogICAgICAgICAgICA8L3JkZjpTZXE+CiAgICAgICAgIDwveG1wTU06SGlzdG9yeT4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzIwMDAwLzEwMDAwPC90aWZmOlhSZXNvbHV0aW9uPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjAwMDAvMTAwMDA8L3RpZmY6WVJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgICAgIDxleGlmOkNvbG9yU3BhY2U+NjU1MzU8L2V4aWY6Q29sb3JTcGFjZT4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5zaW9uPjMyMDwvZXhpZjpQaXhlbFhEaW1lbnNpb24+CiAgICAgICAgIDxleGlmOlBpeGVsWURpbWVuc2lvbj4zMjA8L2V4aWY6UGl4ZWxZRGltZW5zaW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAg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";
                            updateDeviceInfo(device.deviceId, tokenId, "", imageSrc);
                            $("#dtlP").attr("src", "data:image/jpg;image/png;base64," + imageSrc);
                            device.image = "data:image/jpg;image/png;base64," + imageSrc;
                        }, function (error) {
                            hlp.myalert(error);
                        });
                    }
                });
                //弹出二维码action sheet
                $("#barCode").off("tap").on("tap", function () {
                    $.afui.actionsheet(
                        '<a onclick="saveBarcodePicture()" >保存二维码图片</a>' +
                        '<a  onclick="shareBarcode()">分享二维码</a>');
                });
            } else {
                hlp.myalert(r.message);
            }
            ;
        });
    });

    // init.
    DeviceListInit();
});

var DeviceListInit = function () {
    hlp.log("::::::::devicelist");
    var tokenId = loj.Credential;

    // 获取设备列表
    if (loj.IsLogin == true) {
        hlp.log("login..");
        getDeviceList();
    }
    else {
        hlp.log("not login..");
        //hlp.bindtpl("", "#myDeviceDiv", "tpl_main");
    }

    //我的设备页面绑定滑动事件
    //$("#deviceList").bind("swipe", function () {
    //    $.afui.loadContent("#followDeviceList");
    //});
};

//MacCheck
var getMacCheck = function (tokenId, macAddress, succeedHandler, otherBoundHandler, boundHandler, failedHandler) {
    //获取配置WIFI时，Mac地址有无得校验
    svc.getMacIfBindedFlg(tokenId, macAddress, function (r) {
        if (r.status == "SUCCESS") {
            //mac地址未使用
            hlp.log("setting wifi result" + r.message);
            if (succeedHandler) {
                succeedHandler();
            }
        } else if (r.status == "OTHERBOUND") {
            //mac地址被他人使用
            hlp.log("setting wifi result" + r.message);
            if (otherBoundHandler) {
                otherBoundHandler(r);
            }
        } else if (r.status == "BOUND") {
            //mac地址已被自己使用
            hlp.log("setting wifi result" + r.message);
            if (boundHandler) {
                boundHandler(r);
            }
        } else {
            if (failedHandler) {
                failedHandler(r);
            }
        }
    });
};

//Check二维码是否已存在
var checkBarcode = function (tokenId, sn, proObj, succeedHandler, existHandler, baseHandler) {
    svc.getCheckIfBinded(tokenId, sn, proObj.productCode, function (r) {
        if (r.status == "SUCCESS") {
            if (succeedHandler) {
                succeedHandler(r, tokenId, proObj);
            }
            ;
        } else if (r.status == "EXIST") {
            if (existHandler) {
                existHandler(r);
            }
            ;
        } else {
            if (baseHandler) {
                baseHandler(r);
            }
            ;
        }
        ;
    });
};

//设备绑定入库动作
var addDeviceInsert=function(){
    var nickname ="";
    var group = "我的设备";
    var tokenId = loj.Credential;
    var proCode = "";
    var macAddress = "";
    var sn = "";
    var pt = hlp.panelObj["productObj"];
    if (pt) {
        proCode = pt.productCode;
        macAddress = pt.macAddress;
        sn = pt.sn;
        nickname=pt.productName;
    }
    getTude(function (la, lo) {
        //hlp.myalert("latitude>>>" + la + ",,,longitude>>>" + lo);
        //var la = "31.204065";
        //var lo = "121.406586";
        if (sn == "") {
            //手动绑定
            sn = macAddress;
            addDevice(tokenId, nickname, group, la, lo, sn, macAddress, proCode);
        } else {
            //Check二维码是否已存在
            svc.getCheckIfBinded(tokenId, sn, proCode, function (r) {
                if (r.status == "SUCCESS") {
                    svc.getMacIfBindedFlg(tokenId, macAddress, function (r) {
                        if (r.status == "SUCCESS") {
                            addDevice(tokenId, nickname, group, la, lo, sn, macAddress, proCode);
                        } else {
                            hlp.myalert(r.message);
                        }
                    });
                } else {
                    hlp.myalert(r.message);
                }
                ;
            });
        }
    });
};

//添加设备
var addDevice = function (tokenId, nickname, group, la, lo, sn, macAddress, proCode) {
    svc.deviceAdd(tokenId, nickname, group, la, lo, sn, macAddress, proCode, function (r) {
        if (r.status == "SUCCESS") {
            hlp.log("setting group name result" + r.message);
            var flg = hlp.panelObj["deviceControlerFlg"];
            if (!flg) {
                return;
            } else {
                flg.deviceControlerFlg = 1;
            };
            var device = {"deviceId": r.deviceId, "userType": r.userType};
            hlp.panelObj["deviceDtl"] = {"device": device};
            showToast(r.message);
            //$("#wifiConfigMes").show();
            setTimeout(function(){
                $.afui.loadContent("#deviceIndex");
            }, 3000);
        } else {
            hlp.myalert(r.message);
        }
    });
};

//设备名片添加控制
var cardDeviceAdd = function (tokenId, deviceId, flg) {
    hlp.log("begin device.js deviceCard control device ");
    svc.deviceCardControl(tokenId, deviceId, function (r) {
        hlp.log("inside device.js deviceCard control device");
        if (r.status == "SUCCESS") {
            hlp.panelObj["deviceDtl"].device.userType = "secondary";
            //用户身份为副控时
            flg.deviceControlerFlg = 1;
            //showToast("控制成功！");
            $("#nameCardMes").text("控制成功！");
            $("#nameCardMes").show();
            setTimeout(function () {
                $.afui.loadContent("#deviceIndex");
            }, 3000);
        } else {
            hlp.myalert("device.js device.js deviceCard control device result:" + r.message);
        }
    });
};

//根据模板厂商，选择不同的获取mac地址的方式
var getProModSync = function (productModel, tokenId, ssid, password, succeedHandler, failedHandler) {
    productModel = "3";
    alert("productModel = " + productModel);
    hlp.log("productModel = " + productModel);
    if (productModel == "2") {
        //SmartLinkConnect
        sConnect(ssid, password, function (result) {
                hlp.log("result.mac::::" + result.mac);
                if (result.mac == undefined) {
                    hlp.myalert("设备连接失败！");
                    if (failedHandler) {
                        failedHandler();
                    }
                } else {
                    if (succeedHandler) {
                        succeedHandler(result);
                    }
                }
                return result;
            }, function (error) {
                hlp.log(error);
                if (failedHandler) {
                    failedHandler();
                }
                return null;
            }
        );
    } else if (productModel == "1") {
        rConnect(ssid, password, function (result) {
            hlp.log("result.mac::::" + result.mac);
            if (result.mac == undefined) {
                hlp.myalert("设备连接失败！");
                if (failedHandler) {
                    failedHandler();
                }
            } else {
                if (succeedHandler) {
                    succeedHandler(result);
                }
            }
            return result;
        }, function (error) {
            hlp.log(error);
            if (failedHandler) {
                failedHandler();
            }
            return null;
        });
    } else if (productModel == "3") {
        //EspressifConnect
//        var result= {"mac": "18fe349ab002"};
//        if (succeedHandler) {
//            succeedHandler(result);
//        }
//        return result;
        eConnect(ssid, password, function (result) {
            hlp.log("result.mac::::" + result.mac);
            if (result.mac == undefined) {
                hlp.myalert("设备连接失败！");
                if (failedHandler) {
                    failedHandler();
                }
            } else {
                if (succeedHandler) {
                    succeedHandler(result);
                }
            }
            return result;
        }, function (error) {
            hlp.log(error);
            if (failedHandler) {
                failedHandler();
            }
            return null;
        });
    }
};

//wifi配置
var connectingFunction=function(){
    $("#connectBtn").hide();
    $("#wifiConnect").show();
    $("#wifiConnectError").hide();
    $("#connecting p").text("正在连接网络");
    /*    var ssid = jQuery('#wifiCon #wifissid').val();
     var password = jQuery('#wifiCon #wifiPassword').val();*/
    var ssid ="Flyco-930";
    var password ="mobile@flyco";
    var pt = hlp.panelObj["productObj"];

    //标志是wifi重置还是wifi配置
    var deviceWifiReset = hlp.panelObj["deviceWifiReset"];
    //获取当前用户的tokenId
    var tokenId = loj.Credential;

    //链接wifi失败的callback
    var setWifiFailedCallback = function () {
        clearTimeout(wifiConnectTimeout);
        //$.afui.unBlockUIwithMask();
        $("#connecting p").text("连接失败，请检查网络设置！");
        $("#wifiConnect").hide();
        $("#wifiConnectError").show();
        $("#connectBtn").show();
    };
    //未连接wifi
    if (ssid.length == 0) {
        //hlp.myalert("检测您没有连接WIFI，将无法绑定！");
        setWifiFailedCallback();
        return;
    }

    //30秒后自动timeout
    var wifiConnectTimeout=setTimeout(setWifiFailedCallback, 30000);

    //$.afui.blockUIwithMask();
    //$("#waiting").show();

    //wifi配置成功获取到mac地址的回调函数
    var setWifiSucceedCallback = function (result) {
        alert("wifi配置成功获取到mac地址的回调函数");
        //清除30秒后自动timeout
        clearTimeout(wifiConnectTimeout);
        //macCheck通过的回调函数
        var setMacCheckCallback = function () {
            //$.afui.loadContent("#nameGroup");
            addDeviceInsert();
        };
        var macAddressException=function(mes){
            $("#connecting p").text(mes);
            $("#wifiConnect").show();
            $("#wifiConnectError").hide();
            $("#connectBtn").show();
            $("#connectBtn a").eq(1).hide();
        };
        //获取到的mac地址
        pt.macAddress = result.mac;
        //check mac
        getMacCheck(tokenId, result.mac, setMacCheckCallback,
            function (r) {
                // otherBound
                var pt = hlp.panelObj["productObj"];
                if (!pt) {
                    return;
                } else {
                    var sn = pt.sn;
                    if (sn == "") {
                        setMacCheckCallback();
                    } else {
                        macAddressException(r.message);
                    }
                }
            },
            function (r) {
                // self bond
                macAddressException(r.message);
            },
            function (r) {
                //faile
                macAddressException(r.message);
            });
    };

    // 判断重置 OR 配置
    if (deviceWifiReset && deviceWifiReset.isReset == true) {
        hlp.log("wifi重置");

        var checkMacSucceed = function (result) {
            svc.updateInfoForWifiReset(deviceWifiReset.device.deviceId, tokenId, result.mac, position.coords.latitude, position.coords.longitude,
                function (e) {
                    hlp.myalert("重置wifi成功");
                    finishedCallback();
                });
        };
        // wifi重置
        getProModSync(deviceWifiReset.device.productModel, tokenId, ssid, password,
            function (result) {
                // Succeed Callback.
                if (result) {
                    getPst(function onSuccess(position) {
                        hlp.log("getTude succeed. la:" + position.coords.latitude + " lo:" + position.coords.longitude);
                        getMacCheck(tokenId, result.mac,
                            function (r) {
                                svc.updateInfoForWifiReset(deviceWifiReset.device.deviceId, tokenId, result.mac, position.coords.latitude, position.coords.longitude,
                                    function (e) {
                                        hlp.myalert("重置wifi成功");
                                        finishedCallback();
                                    });
                            }, function (e) {
                                hlp.myalert("重置wifi失败");
                                finishedCallback();
                            }, function (r) {
                                svc.updateInfoForWifiReset(deviceWifiReset.device.deviceId, tokenId, result.mac, position.coords.latitude, position.coords.longitude,
                                    function (e) {
                                        hlp.myalert("重置wifi成功");
                                        finishedCallback();
                                    });
                            }, function (r) {
                                hlp.myalert("重置wifi失败");
                                finishedCallback();
                            });
                    });
                } else {
                    finishedCallback();
                }
            }, finishedCallback);
        hlp.log("WifiReset normal ended, Unlock UI. :" + e.toString());

    } else {
        hlp.log("wifi配置");
        // wifi配置
        if (pt) {
            getProModSync(pt.productModel, tokenId, ssid, password, setWifiSucceedCallback, setWifiFailedCallback);
        } else {
            hlp.myalert("设备信息有误");
        }
    }
};

//获取当前时间
var getNowDate = function () {
    var now = new Date();
    var year = now.getFullYear();       //年
    var month = now.getMonth() + 1;     //月
    var day = now.getDate();            //日
    var logTime = {"year": year, "month": month, "day": day};
    return logTime;
};

//获取log
var getLogList = function (deviceId, date, tokenId, handlerId, source, deviceLogData) {
    svc.deviceLog(deviceId, date, tokenId, handlerId, source, function (r) {
        if (r.status == "SUCCESS") {
            hlp.log("get deviceLog result" + r.message);
            deviceLogData.logList = r.deviceLogList;
            hlp.bindtpl(deviceLogData, "#deviceLog_div", "tpl_deviceLog");

        } else if (r.status == "EMPTY") {
            hlp.log("get deviceLog result" + r.message);
            deviceLogData.logList = "";
            hlp.bindtpl(deviceLogData, "#deviceLog_div", "tpl_deviceLog");
        }
        $("#searchLog").off("tap").on("tap", function () {
            var handlerId = $("#controller").val();
            var source = $("#controlSource").val();
            var year = $("#yearId").val();
            var month = $("#monthId").val();
            var day = $("#dayId").val();
            var date = new Date(year, month, day);
            //var date=new Date(2015,6,11);
            if (date.getFullYear() == year & date.getMonth() == month & date.getDate() == day) {
                if (month < 10) {
                    month = "0" + month;
                }
                ;
                if (day < 10) {
                    day = "0" + day;
                }
                var searchDate = year + "" + month + "" + day;
                hlp.log(hlp.format("deviceId:{0},date:{1},tokenId:{2},handlerId:{3},source:{4},deviceLogData:{5}", [deviceId, date, tokenId, handlerId, source, deviceLogData]));
                getLogList(deviceId, searchDate, tokenId, handlerId, source, deviceLogData);
            } else {
                hlp.myalert("日期不合法！");
            }
        });
    });
};

// get device setting
var getDeviceSetting = function (settingStatus, obj) {
    if (settingStatus == 0) {
        obj.removeAttr("checked");
        obj.val(0);
    } else {
        obj.attr("checked", "true");
        obj.val(1);
    }
};

// set device setting
var setDeviceSetting = function (settingType, obj) {
    //获取当前用户的tokenId
    var pt = hlp.panelObj["deviceDtl"];
    if (!pt) {
        return;
    }
    //获取当前用户的tokenId
    var deviceId = pt.device.deviceId.toString();
    var userType = pt.device.userType.toString();
    var tokenId = loj.Credential;
    if (userType == "primary") {
        var settingStatus = obj.val();
        var oldSettingStatus = obj.val();
        if (settingStatus == 0) {
            settingStatus = 1;
            obj.val(1);
        } else {
            settingStatus = 0;
            obj.val(0);
        }
        svc.updateDeviceSetting(deviceId, settingStatus, settingType, tokenId, function (r) {
            hlp.log("device setting result: " + r.message);
            if (r.status == "FAILURE") {
                hlp.myalert(r.message);
                if (oldSettingStatus == 0) {
                    obj.removeAttr("checked");
                    obj.val(0);
                } else {
                    obj.attr("checked", "true");
                    obj.val(1);
                }
            }
        });
    }
};

// delete device
var deleteSelectDevice = function () {
    var tokenId = loj.Credential;
    var userType = $(".myUserType").val();
    var deviceId = $(".myDeviceId").val();
    var delDeviceId = "#dev" + deviceId;
    if (userType == "primary") {
        var deleteFlg = confirm("一旦删除设备,将删除该设备所有的历史数据. 是否确认删除?");
        if (deleteFlg) {
            deleteDevice(deviceId, tokenId, $(delDeviceId));
        } else {
            return;
        }
    } else {
        deleteDevice(deviceId, tokenId, $(delDeviceId));
    }
};

// delete follow device
var deleteSelectFollowDevice = function () {
    var tokenId = loj.Credential;
    var userType = $(".myUserType").val();
    var deviceId = $(".myDeviceId").val();
    var delDeviceId = "#dev" + deviceId;
    deleteFollowDevice(deviceId, tokenId, $(delDeviceId));
};

// 删除设备
var deleteDevice = function (deviceId, tokenId, my) {
    svc.deleteDevice(deviceId, tokenId, function (r) {
        hlp.log("delete device result " + r.message);
        if (r.status == "SUCCESS") {
            my.remove();
        } else {
            hlp.myalert("删除失败!");
            $(".del-icon").hide();
        }
    });
};

// 删除我关注的设备
var deleteFollowDevice = function (deviceId, tokenId, my) {
    svc.deleteDeviceFollow(deviceId, tokenId, function (r) {
        hlp.log("delete device follow result " + r.message);
        if (r.status == "SUCCESS") {
            my.remove();
        } else {
            hlp.myalert("删除失败!");
            $(".dela-icon").hide();
        }
    });
}

//updateDeviceInfo
var updateDeviceInfo = function (deviceId, tokenId, nickName, img) {
    hlp.log("before device.js  updateDeviceInfo call...");
    svc.updateDeviceInfo(deviceId, tokenId, nickName, img, function (r) {
        if (r.status == "SUCCESS") {
            hlp.log("inside device.js updateDeviceInfo function...");
            $.afui.loadContent("#deviceSetting");
        } else {
            hlp.myalert(r.message);
        }
    });
};

// wifi重置
var wifiReset = function () {
    $.afui.loadContent("#wifiCon");

    var deviceWifiReset = hlp.panelObj["deviceWifiReset"];

    // 判断重置 OR 配置
    if (deviceWifiReset) {
        hlp.panelObj["deviceWifiReset"].isReset = true;
    }
};

// 获取设备列表
var getDeviceList = function () {
    console.log("inside getDeviceList...");
    var tokenId = loj.Credential;
    svc.getdevicelist(tokenId, function (r) {
        hlp.log("inside call get device list.");

        //function fixPagesHeight() {
        //    $('.swiper-container').css({
        //        height: $(window).height()
        //    });
        //    $('.swiper-slide').css({
        //        height: ($(window).height()/2)
        //    });
        //}
        //$(window).on('resize', function() {
        //    fixPagesHeight();
        //});
        //fixPagesHeight();


        /*var mySwiper = new Swiper('#myDeviceContent', {
            direction: 'vertical',
            //loop: true,
            slidesPerView : 5,
            centeredSlides : true,
            //loopedSlides :5,
            initialSlide:$(".swiper-slide").length,
            loopAdditionalSlides : 0,
            spaceBetween : (400-window.innerHeight),
            watchSlidesProgress : true,
            watchSlidesVisibility : true,
            touchRatio:0.5,
            iOSEdgeSwipeDetection : true,
            shortSwipes:false
        });*/
            //onInit: function(swiper) {
            //    swiper.myactive = 0;
            //
            //},
            //onProgress: function(swiper) {
            //    for (var i = 0; i < swiper.slides.length; i++) {
            //        var slide = swiper.slides[i];
            //        var progress = slide.progress;
            //        var translate, boxShadow;
            //
            //        translate = progress * swiper.height * 0.8;
            //        scale = 1 - Math.min(Math.abs(progress * 0.2), 1);
            //        boxShadowOpacity = 0;
            //
            //        slide.style.boxShadow = '0px 0px 10px rgba(0,0,0,' + boxShadowOpacity + ')';
            //
            //        if (i == swiper.myactive) {
            //            es = slide.style;
            //            es.webkitTransform = es.MsTransform = es.msTransform = es.MozTransform = es.OTransform = es.transform = 'translate3d(0,' + (translate) + 'px,0) scale(' + scale + ')';
            //            es.zIndex=0;
            //
            //
            //        }else{
            //            es = slide.style;
            //            es.webkitTransform = es.MsTransform = es.msTransform = es.MozTransform = es.OTransform = es.transform ='';
            //            es.zIndex=1;
            //
            //        }
            //
            //    }
            //
            //},
            //
            //
            //onTransitionEnd: function(swiper, speed) {
            //    for (var i = 0; i < swiper.slides.length; i++) {
            //        //	es = swiper.slides[i].style;
            //        //	es.webkitTransform = es.MsTransform = es.msTransform = es.MozTransform = es.OTransform = es.transform = '';
            //
            //        //	swiper.slides[i].style.zIndex = Math.abs(swiper.slides[i].progress);
            //
            //
            //    }
            //
            //    swiper.myactive = swiper.activeIndex;
            //
            //},
            //onSetTransition: function(swiper, speed) {
            //
            //    for (var i = 0; i < swiper.slides.length; i++) {
            //        //if (i == swiper.myactive) {
            //
            //        es = swiper.slides[i].style;
            //        es.webkitTransitionDuration = es.MsTransitionDuration = es.msTransitionDuration = es.MozTransitionDuration = es.OTransitionDuration = es.transitionDuration = speed + 'ms';
            //        //}
            //    }
            //
            //}

        //});
        //if (r.OwnedStatus == "SUCCESS") {
        //    hlp.bindtpl(r.OwnedDeviceList, "#myDeviceDiv", "tpl_deviceAdd");
        //    var deviceList = r.OwnedDeviceList;
        //    $("#myDeviceDiv .lt").off("tap").on("tap", function () {
        //        var this_deviceId = $(this).attr("device-id");
        //        for (var i = 0; i < deviceList.length; i++) {
        //            if (deviceList[i].deviceId == this_deviceId) {
        //                hlp.panelObj["deviceDtl"] = {
        //                    "device": deviceList[i]
        //                };
        //                var flg = hlp.panelObj["deviceControlerFlg"];
        //                if (!flg) {
        //                    return;
        //                } else {
        //                    flg.deviceControlerFlg = 1;
        //                }
        //            }
        //        }
        //        $.afui.loadContent("#deviceIndex");
        //    });
        //    //我的设备长按显示菜单
        //    $("#myDeviceDiv .lt").bind("longTap", function () {
        //        var userType = $(this).attr("user-type");
        //        var deviceId = $(this).attr("device-id");
        //        $(".myUserType").val(userType);
        //        $(".myDeviceId").val(deviceId);
        //
        //        var deviceWifiReset = null;
        //
        //        for (var i = 0; i < deviceList.length; i++) {
        //            if (deviceList[i].deviceId == deviceId) {
        //                deviceWifiReset = {
        //                    "isReset": false,
        //                    "deviceId": $(".myDeviceId").val(),
        //                    "userType": $(".myUserType").val(),
        //                    "device": deviceList[i]
        //                };
        //            }
        //        }
        //
        //        if (deviceWifiReset) {
        //            hlp.panelObj["deviceWifiReset"] = deviceWifiReset;
        //            $.afui.actionsheet(
        //                '<a onclick="setDeviceTop(0)">设备置顶</a>' +
        //                '<a onclick="deleteSelectDevice()">删除设备</a>' +
        //                '<a onclick="wifiReset()">WIFI重置</a>');
        //        }
        //    });
        //} else {
        //    // 没有绑定设备
        //    if (r.AttentionedStatus == "SUCCESS") {
        //        hlp.bindtpl("", "#myDeviceDiv", "tpl_deviceAdd");
        //    } else {
        //        // $.afui.loadContent("#main");
        //        console.log("show main panel content");
        //        hlp.bindtpl("", "#myDeviceDiv", "tpl_main");
        //    }
        //    hlp.log(r.OwnedMessage);
        //}
    });
};

// 关于设备列表
var getFollowDeviceList = function () {
    var tokenId = loj.Credential;
    // get myfamilly device list
    svc.getdevicelist(tokenId, function (r) {
        hlp.log("inside call get Familallydevice list.");
        if (r.AttentionedStatus == "SUCCESS") {
            hlp.bindtpl(r.AttentionedDeviceList, "#myFollowDeviceDiv", "tpl_FollowdeviceAdd");
            $("#myFollowDeviceDiv .lt").off("tap").on("tap", function (event) {
                var my = $(this);
                var deviceId = my.attr("device-id");
                var device = {"deviceId": deviceId};
                hlp.panelObj["deviceDtl"] = {"device": device};
                var flg = hlp.panelObj["deviceControlerFlg"];
                if (!flg) {
                    return;
                } else {
                    flg.deviceControlerFlg = 0;
                }
                ;
                $.afui.loadContent("#deviceIndex");
            });
        } else {
            if (r.OwnedStatus == "SUCCESS") {
                hlp.bindtpl("", "#myFollowDeviceDiv", "tpl_FollowdeviceAdd");
            } else {
                $.afui.loadContent("#deviceList");
            }
            hlp.log(r.AttentionedMessage);
        }
        //我的关注设备长按删除
        $("#myFollowDeviceDiv .lt").bind("longTap", function () {
            var userType = $(this).attr("user-type");
            var deviceId = $(this).attr("device-id");
            $(".myUserType").val(userType);
            $(".myDeviceId").val(deviceId);
            $.afui.actionsheet(
                '<a onclick="setDeviceTop(1)">设备置顶</a>' +
                '<a onclick="deleteSelectFollowDevice()">取消关注</a>');
        });
    });
}

// 设备置顶
var setDeviceTop = function (type) {
    var tokenId = loj.Credential;
    var deviceId = $(".myDeviceId").val();
    var myType = "";
    if (type == 0) {
        myType = "controll";
    } else {
        myType = "concern";
    }
    svc.setDeviceTop(deviceId, tokenId, myType, function (r) {
        if (r.status == "SUCCESS") {
            hlp.log("set device top successful...");
            if (type == 0) {
                getDeviceList();
            } else {
                getFollowDeviceList();
            }
        } else {
            hlp.myalert(r.message);
        }
    });
};

//按钮弹出日志筛选框
var showSearch = function () {
    $("#filterForm").toggle(200);
};

//按钮隐藏日志筛选框
var hideSearch = function () {
    $("#filterForm").hide(200);
};

//二维码分享
var shareBarcode = function () {
    var deviceDtl = hlp.panelObj["deviceDtl"];
    var tokenId = loj.Credential;
    var deviceId = "";
    if (!deviceDtl) {
        return;
    } else {
        deviceId = deviceDtl.device.deviceId;
    }
    ;
    svc.shareBarCode(tokenId, deviceId, function (r) {
        if (r.status == "SUCCESS") {
            hlp.log(hlp.format("URL:{0,picUrl:{1},theme:{2},content:{3},", [r.URL, r.picUrl, r.theme, r.content]));
            share(r.theme, r.content, r.picUrl, r.URL, r.barCodePath, function (result) {
                /*成功后的处理*/
                hlp.myalert("二维码分享成功！");
            }, function (error) {
                /*失败后的处理*/
                hlp.myalert("二维码分享失败！");
            });
        } else {
            hlp.myalert(r.message);
        }
    });
};

//二维码保存
var saveBarcodePicture = function () {
    var barcodeDataURL = hlp.panelObj["barcodeDataURL"];
    var dataURL;
    if (!barcodeDataURL) {
        return;
    } else {
        dataURL = barcodeDataURL.dataURL;
    }
    ;
    hlp.myalert("bitmap>>>" + dataURL);
    savePicture(dataURL,
        function (event) {
            hlp.myalert("二维码保存成功 ");
        },
        function (error) {
            hlp.myalert("Scanning failed: " + error);
        });
};

//按汉堡包弹出设备菜单
var showMyDevice = function () {
    var flg = hlp.panelObj["deviceControlerFlg"];
    if (!flg) {
        return;
    }
    var controlFlg = flg.deviceControlerFlg;
    if (controlFlg == 0) {
        //用户身份为游客或粉丝时
        $(".popupMyFollowedDevice").toggle(100);
    } else {
        //用户身份为主控或副控时
        $(".popupMyDevice").toggle(100);
    }
};