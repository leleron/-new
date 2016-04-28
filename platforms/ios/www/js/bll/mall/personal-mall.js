$(function () {

    $.afui.launch();

    // 选择地址
    $("#addressSelect").on("panelload", function (e) {
        hlp.log("before call get address list");
        svc.getAddressList(loj.UserId, function(r) {
             if (r.status == "SUCCESS") {
                 hlp.bindtpl(r.data,"#addressChoose","tpl_addresschoose");
                 getSelectAddressInfo(r.data);
             } else {
                hlp.myalert(r.message);
             }
         });
    });

    // 我的订单 订单列表
    $("#myOrders").on("panelload", function (e) {
        hlp.log("before call get my orders list");
        if (loj.UserId == null || loj.UserId.length == 0) { return; }
        svc.getOrderList(loj.UserId, function(r) {
            if (r.status == "SUCCESS") {
                hlp.bindtpl(r.data,"#myOrdersList","tpl_myorderslist");
                $("#myOrdersList li").off("tap").on("tap", function () {
                    hlp.panelObj["order"] = { "sn": $(this).attr("id") };
                    switch(Number($(this).attr("order-status"))){
                        case 1: // 待付款
                            $.afui.loadContent("#unpayedOrder");
                            break;
                        case 2: // 已付款
                            $.afui.loadContent("#orderDetail1");
                            break;
                        case 3: // 已发货
                            $.afui.loadContent("#orderDetail2");
                            break;
                        case 4: // 已取消
                            $.afui.loadContent("#orderDetail3");
                            break;
                        case 5: // 已完成
                            $.afui.loadContent("#orderDetail4");
                            break;
                        default:
                            break;
                    }
                });
            } else {
                $("#myOrdersList")[0].innerHTML = '<p align="center" class="topMessage"><a href="#">没有查询到订单信息!</a></p>';
            }
        });
    });

    // 待付款订单 订单列表
    $("#unpayedOrderList").on("panelload", function (e) {
        hlp.log("before call get my orders list");
        if (loj.UserId == null || loj.UserId.length == 0) { return; }
        svc.getOrderList(loj.UserId, function(r) {
            if (r.status == "SUCCESS") {
                hlp.bindtpl(r.data,"#myUnPayOrdersList","tpl_myunpayorderslist");
                $("#myUnPayOrdersList li").off("tap").on("tap", function () {
                    hlp.panelObj["order"] = { "sn": $(this).attr("id") };
                    $.afui.loadContent("#unpayedOrder");
                });
            } else {
                $("#myUnPayOrdersList")[0].innerHTML = '<p align="center" class="topMessage"><a href="#">没有查询到订单信息!</a></p>';
            }
        });
    });

    // 订单详情
    // 待付款
    $("#unpayedOrder").on("panelload", function (e) {
        hlp.log("before call get my orders detail");
        getOrderDetail(0);
    });
    // 已付款
    $("#orderDetail1").on("panelload", function (e) {
        hlp.log("before call get my orders detail");
        getOrderDetail(0);
    });
    // 已发货
    $("#orderDetail2").on("panelload", function (e) {
        hlp.log("before call get my orders detail");
        getOrderDetail(0);
    });
    // 已取消
    $("#orderDetail3").on("panelload", function (e) {
        hlp.log("before call get my orders detail");
        getOrderDetail(0);
    });
    // 已完成
    $("#orderDetail4").on("panelload", function (e) {
        hlp.log("before call get my orders detail");
        getOrderDetail(0);
    });

    // 物流信息
    $("#logisticsDetail").on("panelload", function (e) {
        var orderId = hlp.panelObj["orderSn"].order_sn;
        svc.getLogisticsDetail(orderId, function(r) {
            if (r.status == "SUCCESS") {
                hlp.bindtpl(r,"#logisticsDetail0","tpl_logisticsdetail0");
                hlp.bindtpl(r,"#logisticsDetail1","tpl_logisticsdetail1");
                hlp.bindtpl(r,"#logisticsDetail2","tpl_logisticsdetail2");
            } else {
                hlp.myalert(r.message);
            }
        });
    });

    // 申请退款
    $("#refundApply").on("panelload", function (e) {
        hlp.log("before call get my refund apply");
        hlp.bindtpl(hlp.panelObj["refund_apply"],"#regMobile","tpl_refundapply");
        $(".tksm").val("");
        $(".refundGetCode").val("");
        $(".tkyy").val("0");
        $("#regMobile span")[0].innerHTML = "将验证码发送到您的手机：" + setMobileStar(hlp.panelObj["refund_apply"].mobile);
        $("#refundApplySubmit").off("tap").on("tap", function () {
            var tkInfo = $("#tkInfo");
            var tkyy = tkInfo.find("select").val();
            var tksm = tkInfo.find("textarea").val().trim();
            var yzm = $(".refundGetCode").val().trim();
            if (tkyy == "0") {
                hlp.myalert("请选择退款原因.");
            } /*else if(tksm.trim().length == 0) {
                hlp.myalert("请输入退款说明.");
            }*/ else if(tksm.trim().length > 255) {
                hlp.myalert("输入的字符不能超过255个.");
            } else if (yzm.length == 0) {
                hlp.myalert("请输入验证码.");
            } else {
                var refundMobile = $("#regMobile span").attr("reg-mobile");
                var regCode = $(".refundGetCode").val();
                svc.identifyCodeCheck(refundMobile,regCode,function(r){
                    hlp.log("call identify reg code.");
                    hlp.log(hlp.format("Mobile:{0},IdentifyCode:{1}",[refundMobile,regCode]));
                    if(r.status == "SUCCESS"){
                       var refund_apply_data = {
                            "order_sn": $(".tkOrderSn").val(),
                            "user_id": loj.UserId,
                            "reason": tkyy,
                            "remark": tksm
                        };
                        svc.refundApply(refund_apply_data, function(r) {
                            if (r.status == "SUCCESS") {
                                loj.orderActioned=true;
                                $.afui.loadContent("#refundList");
                            } else {
                                hlp.myalert(r.message);
                            }
                        });
                    } else{
                        hlp.myalert("输入的验证码不正确.");
                    }
                });
            }
        });
        $("#refundApplyCode").off("tap").on("tap", function() {
            if (SendCodeEnableFg) {
                var refundMobile = $("#regMobile span").attr("reg-mobile");
                $("#refundApplyCode").text("发送中");
                $("#refundApplyCode").addClass("disabled");
                svc.regPassSend(refundMobile, function(r){
                    refundApplyGetNumber();
                    hlp.log("before call get my reg code...");
                    if (r.status == "SUCCESS"){
                        hlp.log("get reg code success...");
                    }else{
                        hlp.myalert(r.message);
                        clearRefundApplyTm();
                    }
                });
            }
        });
    });

    // 申请退货
    $("#returnApply").on("panelload", function (e) {
        hlp.log("before call get my return apply");
        if (hlp.panelObj["empty"].is) {
            $(".questionDesc textarea").val("");
            hlp.panelObj["empty"].is = false;
        }
        getOrderDetail(1);
    });

    // 确认联系人信息
    $("#addressConfirm").on("panelload", function (e) {
        hlp.log("before call set address confirm");
        var form = $("#qrlxrxx");
        var options = addressFromVaildOptions;
        options["errorPlacement"] = function (error, element) {
            if (form.attr("check_status") == "false") {
                form.attr("check_status", "true");
                if (error[0]) {
                    hlp.myalert(error[0].innerHTML);
                }
            }
        };
        form.validate(options).resetForm();
        var panObj = hlp.panelObj["infoEdit"];
        if (panObj != null) {
            $(".acConsignee").val(panObj.consignee);
            $(".acAddress").val(panObj.address);
            $(".acZipCode").val(panObj.zipcode);
            $(".acTel").val(panObj.tel);
            $(".acMobile").val(panObj.mobile);
            InitAddressSelects("#qrxxProvince", "qrxxProvince", "#qrxxCity", "qrxxCity", "#qrxxDistrict", "qrxxDistrict", "qrxxAddressInsert", {
                "province": panObj.province,
                "city": panObj.city,
                "district": panObj.district
            });
        } else {
            InitAddressSelects("#qrxxProvince", "qrxxProvince", "#qrxxCity", "qrxxCity", "#qrxxDistrict", "qrxxDistrict", "qrxxAddressInsert", null);
        }
        // 确认
        $(".qrshSubmit").off("tap").on("tap", function () {
            form.attr("check_status", "false");
            var validStatus = form.valid();
            if (validStatus) {
                hlp.panelObj["infoEdit"].consignee = $(".acConsignee").val();
                hlp.panelObj["infoEdit"].province = $("#qrxxProvince").val();
                hlp.panelObj["infoEdit"].city = $("#qrxxCity").val();
                hlp.panelObj["infoEdit"].district = $("#qrxxDistrict").val();
                var province = $("#qrxxProvince option:selected").text() + " ";
                var city = $("#qrxxCity option:selected").text() + " ";
                var district = $("#qrxxDistrict option:selected").text() + " ";
                hlp.panelObj["infoEdit"].address = province + city +  district + $(".acAddress").val();
                hlp.panelObj["infoEdit"].zipcode = $(".acZipCode").val();
                hlp.panelObj["infoEdit"].tel = $(".acTel").val();
                hlp.panelObj["infoEdit"].mobile = $(".acMobile").val();
                $.afui.loadContent("#returnApply");
            }
        });
        // 取消
        $(".qrshCancel").off("tap").on("tap", function () {
            $.afui.loadContent("#returnApply");
        });
    });
});

// 获取选中的地址
var getSelectAddressInfo = function(obj) {
    var addr = $("#addressChoose li");
    var panelObj = hlp.panelObj["selectAddressId"];
    if (panelObj != null) {
        if (obj.length == 0) {
            $("#selectAddressId").val("");
        } else {
            $("#selectAddressId").val(panelObj.address_id);
        }
        $.each(addr, function (index) {
            var id = addr.eq(index).attr("id");
            if (id == panelObj.address_id) {
                addr.eq(index).find("a").attr("class", "cur");
            } else {
                addr.eq(index).find("a").removeClass("cur");
            }
        });
    }
    addr.off("tap").on("tap", function () {
        $.each(addr, function(index) {
            addr.eq(index).find("a").removeClass("cur");
        });
        var this_id = $(this).attr("id");
        $(this).find("a").attr("class","cur");
        $("#selectAddressId").val(this_id);
    });
    $(".addrSubmit").off("tap").on("tap", function () {
        var id = $("#selectAddressId").val();
        if (id.length == 0) {
            hlp.myalert("请选择一个地址.");
        }
        else {
            hlp.panelObj["selectAddressId"] = {"address_id": id};
            $.afui.loadContent("#submitOrder");
        }
    });
}

// 订单详情
var getOrderDetail = function(type) {
     if (loj.UserId.length == 0) { return; }
     svc.getOrderDetail(hlp.panelObj["order"].sn, loj.UserId, function(r) {
         if (r.status == "SUCCESS") {
             if (type == 0) {
                 switch(Number(r.data.order_info.code)) {
                     case 1: // 待付款
                         hlp.bindtpl(r.data.order_info,"#myOrdersDetail11","tpl_myordersdetail11");
                         hlp.bindtpl(r.data.goods_info,"#myOrdersDetail12","tpl_myordersdetail12");
                         /*var totalPrice = 0;
                         var trans = $(".transaction_price");
                         $.each(trans, function(i) {
                             totalPrice = totalPrice + Number(trans.eq(i).val());
                         });
                         $(".totalPrice").val(totalPrice);*/
                         $(".fixedBuy span")[0].innerHTML = "应付总额：" + $(".payTotalFee").val() + "元";
                         orderPay();
                         break;
                     case 2: // 已付款
                         hlp.bindtpl(r.data.order_info,"#myOrdersDetail1","tpl_myordersdetail1");
                         hlp.bindtpl(r.data.goods_info,"#myOrdersDetail2","tpl_myordersdetail2");
                         getRefundApply();
                         break;
                     case 3: // 已发货
                         hlp.bindtpl(r.data.order_info,"#myOrdersDetail3","tpl_myordersdetail3");
                         hlp.bindtpl(r.data.goods_info,"#myOrdersDetail4","tpl_myordersdetail4");
                         getReturnApply();
                         getLogisticsInfo();
                         setQrsh();
                         break;
                     case 4: // 已取消
                         hlp.bindtpl(r.data.order_info,"#myOrdersDetail5","tpl_myordersdetail5");
                         hlp.bindtpl(r.data.goods_info,"#myOrdersDetail6","tpl_myordersdetail6");
                         break;
                     case 5: // 已完成
                         hlp.bindtpl(r.data.order_info,"#myOrdersDetail7","tpl_myordersdetail7");
                         hlp.bindtpl(r.data.goods_info,"#myOrdersDetail8","tpl_myordersdetail8");
                         getReturnApply();
                         getLogisticsInfo();
                         setPj();
                         break;
                     default:
                         break;
                 }
             } else {
                 hlp.bindtpl(r.data.goods_info,"#myOrdersDetail9","tpl_myordersdetail9");
                 hlp.bindtpl(r.data.order_info,"#myOrdersDetail10","tpl_myordersdetail10");
                 var panObj = hlp.panelObj["infoEdit"];
                 if (panObj != null) {
                     $(".returnApplyConsignee")[0].innerHTML = panObj.consignee;
                     $(".returnApplyMobile")[0].innerHTML = panObj.mobile;
                     $(".returnApplyAddress")[0].innerHTML = panObj.address;
                     $(".hdnConsignee").val(panObj.consignee);
                     $(".hdnMobile").val(panObj.mobile);
                     $(".hdnAddress").val(panObj.address);
                     $(".hdnTel").val(panObj.tel);
                     $(".hdnProvince").val(panObj.province);
                     $(".hdnCity").val(panObj.city);
                     $(".hdnDistrict").val(panObj.district);
                     $(".hdnZipCode").val(panObj.zipcode);
                 }
                 $(".returnApplyMobile")[0].innerHTML = setMobileStar($(".returnApplyMobile")[0].innerHTML);
                 setReturnApply();
             }
         } else {
            hlp.myalert(r.message);
         }
     });
}

// 物流信息
var getLogisticsInfo = function() {
    $(".logisticsDetail").off("tap").on("tap", function () {
        var sn = $(this).attr("order-sn");
        hlp.panelObj["orderSn"] = {"order_sn": sn};
        $.afui.loadContent("#logisticsDetail");
    });
}

// 申请退款
var getRefundApply = function() {
    $(".sqtk").off("tap").on("tap", function () {
        var sn = $(this).attr("order-sn");
        if(count < 1 || count == 60) {
            var mobile = $(this).attr("mobile");
            hlp.panelObj["refund_apply"] = {
                "order_sn": sn,
                "mobile": mobile
            };
            $.afui.loadContent("#refundApply");
        } else {
            hlp.myalert("验证码60秒发送一次，请稍后重试！");
        }
    });
}

// 申请退货
var getReturnApply = function() {
    $(".sqth").off("tap").on("tap", function () {
        var sn = $(this).attr("order-sn");
        hlp.panelObj["orderSn"] = {"order_sn": sn};
        hlp.panelObj["infoEdit"] = null;
        hlp.panelObj["empty"] = {"is": true};
        $.afui.loadContent("#returnApply");
    });
}

// 付款
var orderPay = function() {
    $(".orderPay").off("tap").on("tap", function () {
        hlp.panelObj["payInformation"] = {
            "orderId": $(".payOrderSn").val(),
            "orderPrice": $(".payTotalFee").val(),
            "addressInfo": $(".payAddressInfo").val(),
            "personalInfo": $(".payPersonalInfo").val(),
            "invoice":  $(".payInvoice").val()
        };
        $.afui.loadContent("#pay");
    });
    $(".qxdd").off("tap").on("tap", function() {
        $.afui.popup({
            title: "提示",
            message: "确定取消订单吗?",
            cancelText: "取&nbsp;&nbsp;消",
            doneText: "确&nbsp;&nbsp;定",
            cancelCallback: function () {
                console.log("cancelled");
            },
            doneCallback: function () {
                svc.cancelOrder($(".payOrderSn").val(), loj.UserId, function(r){
                    hlp.log("before call cancel order...");
                    if (r.status == "SUCCESS"){
                        loj.orderActioned = true;
                        $.afui.loadContent("#orderDetail3");
                    }else{
                        hlp.myalert(r.message);
                    }
                });
            }
        });
    });
}

// 已完成评价
var setPj =  function () {
    $(".yshPj").off("tap").on("tap", function () {
        var ywcOrderSn = $(".ywcOrderSn").val();
        var ywcGoodsSn = $(this).attr("goods-sn");

        // hlp.panelObj["sppj"] = { "order_sn": ywcOrderSn, "goods_sn": ywcGoodsSn }

        if (loj.CredentialStatus=="active") {
            svc.getGoodsNocomment(loj.UserId, 1, function (res) {
                hlp.log("Call svc.getGoodsNocomment and get bought goods:" + JSON.stringify(res));
                //add_time: "2014-10-11 15:28:34"
                //goods_name: "飞科FR5211毛球修剪器"
                //goods_sn: "FR5211"
                //goods_thumb: "/sources/goods/FR5211//FR5211_big.jpg"
                //order_sn: "141011111096"
                //shop_price: "49.00"

                if (res.data == null) {
                    hlp.myalert("已提交过该商品的评价");
                } else {
                    var goodInfo = undefined;

                    for (var i = 0; i < res.data.length; i++) {
                        if (ywcGoodsSn == res.data[i].goods_sn &&
                            ywcOrderSn == res.data[i].order_sn) {
                            goodInfo = res.data[i];
                        }
                    }

                    if (goodInfo) {
                        hlp.panelObj["goodInfo"] = goodInfo;

                        $.afui.loadContent("#evaluationSubmit");
                    } else {
                        hlp.myalert("已提交过该商品的评价");
                    }
                }
            });
        } else {
            //$.afui.loadContent("#login");
            showLoginController1();
        }
    });
}

// 确认收货
var setQrsh = function() {
    $(".qrshBtn").off("tap").on("tap", function () {
        var qrshOrderSn = $(".qrshOrderSn").val();
        svc.confirmRecept(qrshOrderSn, loj.UserId, function (r) {
            if (r.status == "SUCCESS") {
                loj.orderActioned=true;
                $.afui.loadContent("#orderDetail4");
            } else {
                hlp.myalert(r.message);
            }
        });
    });
}

// 设置手机当中四位为星号
var setMobileStar = function(mobile) {
    return mobile.substring(0,3) + "****" + mobile.substring(8,11);
}

// 申请退货事件
var setReturnApply = function() {
    // 应需求需要以下注释以下代码, 但暂时不删除, 以免需要恢复.
    /*// 商品个数减少
    $(".cutNum").off("tap").on("tap", function () {
        var gn = $($(this)[0].parentNode);
        var goodsNum = Number(gn.find(".goodsNum").val());
        goodsNum = goodsNum - 1;
        if (goodsNum >= 1) {
            gn.find(".goodsNum").val(goodsNum);
        }
    });
    // 商品个数添加
    $(".addNum").off("tap").on("tap", function () {
        var gn = $($(this)[0].parentNode);
        var goodsNum = Number(gn.find(".goodsNum").val());
        var goodsNumHidden = Number(gn.find(".goodsNumHidden").val());
        goodsNum = goodsNum + 1;
        if (goodsNum <= goodsNumHidden) {
            gn.find(".goodsNum").val(goodsNum);
        }
    });*/
    // 编辑
    $(".infoEdit").off("tap").on("tap", function () {
        var hdnConsignee = $(".hdnConsignee").val();
        var hdnMobile = $(".hdnMobile").val();
        var hdnAddress = $(".hdnAddress").val();
        var hdnTel = $(".hdnTel").val();
        var hdnProvince = $(".hdnProvince").val();
        var hdnCity = $(".hdnCity").val();
        var hdnDistrict = $(".hdnDistrict").val();
        var hdnZipCode = $(".hdnZipCode").val();
        hlp.panelObj["infoEdit"] = {
            "consignee": hdnConsignee,
            "mobile": hdnMobile,
            "address": hdnAddress.split(" ")[3],
            "tel": hdnTel,
            "province": hdnProvince,
            "city": hdnCity,
            "district": hdnDistrict,
            "zipcode": hdnZipCode
        };
        $.afui.loadContent("#addressConfirm");
    });
    /*// 选择商品
    $(".selectReturn").off("tap").on("tap", function () {
        var isChecked = $(this).find(".isChecked").val();
        var id = $(this).attr("id");
        if (isChecked == "0") {
            $(this).attr("class","check selectReturn checked");
            $(this).find(".isChecked").val(id);
        } else {
            $(this).attr("class","check selectReturn");
            $(this).find(".isChecked").val("0");
        }
    });*/
    // 我已阅读并同意
    $(".selectAgree").off("tap").on("tap", function () {
        var isAgree = $(".isAgree").val();
        if (isAgree == "0") {
            $(".selectAgree").attr("class","check selectAgree checked");
            $(".isAgree").val("1");
        } else {
            $(".selectAgree").attr("class","check selectAgree");
            $(".isAgree").val("0");
        }
    });
    /*// 个数输入框
    $(".goodsNum").on("input", function () {
        var s = /^[0-9]*$/;
        var inputStatus = false;
        // 输入数字
        if (!s.test($(".goodsNum").val())) {
            inputStatus = true;
        // 输入的个数大于原有的个数
        } else if (Number($(".goodsNum").val()) > Number($(".goodsNumHidden").val())) {
            inputStatus = true;
        // 至少要保留一个商品
        } else if (!(Number($(".goodsNum").val()) > 0)) {
            inputStatus = true;
        // 起始数字不能为0.
        } else if ($(".goodsNum").val().length > 1) {
            if ($(".goodsNum").val()[0] == 0) {
                inputStatus = true;
            }
        }
        if (inputStatus) {
            $(".goodsNum").val($(".goodsNumHidden").val());
        }
    });*/
    // 提交
    $(".sqthSubmit").off("tap").on("tap", function () {
        var questionDesc = $(".questionDesc textarea").val().trim();
        /*var isChkCount = 0;
        $.each($(".isChecked"), function(i) {
            var isChk = $(".isChecked").eq(i).val();
            if (isChk != "0") { isChkCount = isChkCount + 1; }
        });*/
        /*if (isChkCount == "0") {
            hlp.myalert("请选择您需要退货的商品.");
        } else*/ if (questionDesc.trim().length == 0) {
            hlp.myalert("请输入问题描述.");
        } else if (questionDesc.trim().length > 255) {
            hlp.myalert("最多输入255个字符.");
        } else if ($(".isAgree").val() == "0") {
            hlp.myalert("请选择我已阅读并同意.");
        } else {
            var return_goods = "";
            /*$.each($(".isChecked"), function(i) {
                var isChk = $(".isChecked").eq(i).val();
                var num = $(".goodsNum").eq(i).val();
                if (isChk != "0") {
                        return_goods  = return_goods + "," +  '{"sku_sn": "' + isChk + '", "goods_num": "' + num + '"}';
                    }
             });*/
            var od = $("#myOrdersDetail9");
            $.each(od.find("li"), function(i) {
                var num = $(od.find("li")[i]).find(".goodsNum").val();
                var skn = $(od.find("li")[i]).find(".skuSn").val();
                return_goods  = return_goods + "," +  '{"sku_sn": "' + skn + '", "goods_num": "' + num + '"}';
             });
            var order_sn = hlp.panelObj["orderSn"].order_sn;
            var return_data = {
                "order_sn": order_sn,
                "user_id": loj.UserId,
                "receiver_address": {
                    "name": $(".hdnConsignee").val(),
                    "address": $(".hdnAddress").val(),
                    "zipcode": $(".hdnZipCode").val(),
                    "mobile": $(".hdnMobile").val(),
                    "tel": $(".hdnTel").val(),
                    "province": $(".hdnProvince").val(),
                    "city":  $(".hdnCity").val(),
                    "district": $(".hdnDistrict").val()
                },
                "return_goods": jQuery.parseJSON('[' + return_goods.substring(1) + ']')
            };
            svc.returnApply(return_data, function(r) {
                if (r.status == "SUCCESS") {
                    loj.orderActioned=true;
                    hlp.log("Call svc.returnApply success. response:" + JSON.stringify(r));
                    //hlp.panelObj["orderInfo"] = { "returns_order_sn": r.data.returns_order_sn };
                    hlp.panelObj["infoEdit"] = null;
                    $.afui.loadContent("#returnList");
                } else {
                    hlp.myalert(r.message);
                }
            });
        }
    });
}