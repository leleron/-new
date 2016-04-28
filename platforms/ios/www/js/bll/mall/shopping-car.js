$(function () {

    $.afui.launch();

    // 在线支付
    $("#pay").on("panelload", function (e) {
        hlp.log("before call get pay type");
        var panelObj = hlp.panelObj["payInformation"];
        hlp.bindtpl(panelObj,"#orderDetailInfo","tpl_orderdetail");
        hlp.bindtpl(panelObj,"#orderPrice","tpl_orderprice");
        svc.getPayType(function(r) {
            if (r.status == "SUCCESS") {
                hlp.bindtpl(r.data,"#payType","tpl_paytype");
                $("#payType li").eq(0).attr("class","act");
                $("#selectPayType").val($("#payType li").eq(0).attr("id"));
                var payType = $("#payType li");
                payType.off("tap").on("tap", function () {
                    $.each(payType, function(index) {
                        payType.eq(index).removeClass("act");
                    });
                    $(this).attr("class","act");
                    $("#selectPayType").val($(this).attr("id"));
                });
                $("#actionPay").off("tap").on("tap", function () {
                    var orderSn = $(".payOrderId").val();
                    var payType = $("#selectPayType").val();
                    var price = $(".payOrderPrice").val();
                    if (payType == "appalipay") {
                        flycoAlipay(loj.UserId,orderSn, price, payType);
                    } else if (payType == "appunionpay") {
                        flycoUnionPay(loj.UserId,orderSn, price, payType);
                    } else if (payType == "appscwxpay") {
//                                        flycoWxPay(orderSn, price, "appscwxpay");
                        flycoWxPay(loj.UserId,orderSn, price, payType);
                    }
                });
                $("#cancelPay").off("tap").on("tap", function () {
                    loj.payActioned = true;
                    hlp.panelObj["order"] = { "sn": $(".payOrderId").val() };
                    $.afui.loadContent("#unpayedOrder");
                });
            } else {
                hlp.myalert(r.message);
            }
        });
    });

    //免注册购买
    $("#notLoginBuy").off("panelload").on("panelload",function(){
        $("#notLoginMPoneNumber").val("");
        $("#notLoginVericode").val("");
        var registerFlg=false;
        //未注册购买，获取登录获积分message接口
        svc.getPromo(function(r){
            if (r.status == "SUCCESS") {
                //显示message
                $("#notLoginBuy .list .tips").text(r.data.desc);
            }else{
                hlp.myalert("未注册购买，获取登录获积分message未取到");
            }
        });
        //验证码按钮
        $("#notLoginBuySendCode").off("tap").on("tap", function () {
            if (notLoginSendCodeEnableFg) {
                var mPoneNumber=$("#notLoginMPoneNumber").val();
                if (mPoneNumber.trim().length==0){
                    hlp.myalert("请输入手机号码！");
                } else if (!checkMobile(mPoneNumber)) {
                    hlp.myalert("请输入正确的手机号码！");
                }
                $("#notLoginBuySendCode").text("发送中");
                $("#notLoginBuySendCode").addClass("disabled");
                //check用户有没有注册，注册:FAILURE,未注册：SUCCESS
                hlp.log("before call shopping-car.js userCheck");
                svc.userCheck(mPoneNumber, function(userCheck_result) {
                    notLoginBuyerGetNumber();
                    hlp.log("inside call shopping-car.js userCheck");
                    if (userCheck_result.status == "SUCCESS") {//未注册
                        hlp.log(userCheck_result.message);
                        registerFlg=false;
                    }else if(userCheck_result.code=="104"){//已注册
                        registerFlg=true;
                        //发送验证码
                        hlp.log("before call shopping-car.js forgerPassSend");
                        svc.forgerPassSend(mPoneNumber, function(r){
                            hlp.log("inside call shopping-car.js forgerPassSend");
                            if (r.status == "SUCCESS"){
                                hlp.log(r.message);
                            }else{
                                hlp.log(r.message);
                            }
                        });
                    }
                });
            }
        });
        //免注册购买提交按钮事件
        $("#notLoginBuyBtnConfirm").off("tap").on("tap", function () {
            var notLoginVericode=$("#notLoginVericode").val();
            var mPoneNumber=$("#notLoginMPoneNumber").val();
            if (mPoneNumber.trim().length==0){
                hlp.myalert("请输入手机号码！");
            } else if (!checkMobile(mPoneNumber)) {
                hlp.myalert("请输入正确的手机号码！");
            }else if(notLoginVericode.trim().length==0) {
                hlp.myalert("请填写验证码！");
            } else{
                //check验证码是否正确
                hlp.log("before call shopping-car.js identifyCodeCheck");
                svc.identifyCodeCheck(mPoneNumber, notLoginVericode, function(codeCheck_result) {
                    hlp.log("inside call shopping-car.js identifyCodeCheck");
                    if (codeCheck_result.status == "SUCCESS") {
                        clearTimeout(notLoginHandler);
                        count=60;
                        clearRegTmNotLogin();
                        hlp.log(codeCheck_result.message);
                        //点击确认
                        if(registerFlg){
                            //用户已注册，自动登录

                            //自动登录成功
                            var codeLoginSuccessCallback=function(){
                                var tokenId=loj.Credential;
                                if(loj.sessionId){
                                    updateShopCart(function(){
                                        //判断用户的收货地址信息，并做出正确的迁移
                                        buyNowFunction(tokenId);
                                    },undefined);
                                }else{
                                    //判断用户的收货地址信息，并做出正确的迁移
                                    buyNowFunction(tokenId);
                                }
                            };
                            codeLogin(mPoneNumber,codeLoginSuccessCallback, undefined);
                        }else{
                            //用户未注册，自动注册并登录
                            //自动注册
                            hlp.log("before call shopping-car.js userRegister");
                            svc.userRegister(mPoneNumber, mPoneNumber, notLoginVericode, notLoginVericode, function(userRegister_res){
                                hlp.log("inside call shopping-car.js userRegister");
                                if (userRegister_res.status == "SUCCESS") {
                                    hlp.log(userRegister_res.message);
                                    //密码登录成功
                                    var passwordLoginSuccessCallback=function(){
                                        if(loj.sessionId){
                                            updateShopCart(function(){
                                                hlp.panelObj["notLoginBuyMobile"]={"mobile":mPoneNumber};
                                                $.afui.loadContent("#addressAdd");
                                            },undefined);
                                        }else{
                                            hlp.panelObj["notLoginBuyMobile"]={"mobile":mPoneNumber};
                                            $.afui.loadContent("#addressAdd");
                                        }
                                    };
                                    passwordLogin(mPoneNumber, notLoginVericode,passwordLoginSuccessCallback, undefined);
                                } else {
                                    hlp.myalert(userRegister_res.message);
                                }
                            });
                        }
                    }else{
                        hlp.myalert(codeCheck_result.message);
                    }
                });
            }
        });
    });

    //提交订单
    $("#submitOrder").off("panelload").on("panelload",function(){
        $.afui.blockUIwithMask('加载中');
        $("#div_submitOrder_totalPrice span").text("0元");
        $(document).off('touchstart').on('touchstart',function(){
            $('#integral').blur();
        });
        //画面初始化
        $("#integralDiv").css("display","block");
        $("#showIntegralDiv").attr("class","orderBg orderBg2 canshu showcanshu")
        $("#goodList").css("display","block");
        $("#div_submitOrder_goods").attr("class","orderBg orderBg2 canshu showcanshu");
        $("#person").attr("class","cur");
        $("#company").removeClass("cur");
        $("#companyName").hide();
        $("#submitOrderCheckbox").removeClass("checked");
        $("#integral").val("");
        //$("#integral").attr("readonly","readonly");
        $("#integralToCash").text("0");

        var goodsOdj=hlp.panelObj["buyNowGoods"];
        if(!goodsOdj){
            hlp.myalert("没有购买的商品！");
            return;
        }else if(goodsOdj.good==undefined){
            var suitCode=goodsOdj.suitCode;
            var extensionCode=goodsOdj.extensionCode;
            var num=goodsOdj.num;
            var goodSuit={
                "suitCode":suitCode,
                "extensionCode":extensionCode,
                "num":num
            };
        }else{
            var goods=goodsOdj.good;
        }
        var isCart=goodsOdj.isCart;
        var tokenId=loj.Credential;
        var userId=loj.UserId;
        var addressId="";
        var invType="0";
        var companyName="";

        //发票
        $("#invoice a").off("tap").on("tap", function () {
            var this_id = $(this).attr("id");
            if(this_id=="person"){
                $("#company").removeClass("cur");
                $(this).attr("class","cur");
                $("#companyName").attr("style", "display: none");
            }else{
                $("#person").removeClass("cur");
                $(this).attr("class","cur");
                $("#companyName").attr("style", "display: block");
            }
        });

        //地址获取失败
        var failedCallBack=function(message){
            hlp.log(message);
        };
        //地址获取成功
        var getAddressSucceedCallBack=function(success_res){
            var data_address=success_res.data;
            if(data_address){
                addressId=data_address.address_id;
                //显示地址
                showTheAddress(data_address);

                var getGoodsSimpleInfoSucceedCallBack=function(sum_price,sum_price_isSpecial){
                    var priceCanUseIntegral=parseInt(sum_price-sum_price_isSpecial);//可用积分抵扣的钱

                    //成功获取包邮标准的callback
                    var getBaoYouLineSuccessCallback=function(baoYouLine){
                        //邮费
                        var shipping_fee=parseFloat(baoYouLine.shipping_fee);
                        //包邮标准
                        var payLine=parseFloat(baoYouLine.promo);

                        //成功获取积分信息的callback
                        var getIntegralSuccessCallback=function(integral){
                            //根据总额是否超过包邮标准，判断邮费
                            if(sum_price>=payLine){
                                var freight=0;
                                $("#forFree").show();
                            }else{
                                var freight=shipping_fee;
                                $("#forFree").hide();
                            };
                            var integralObj={"all":integral,"canUse":priceCanUseIntegral};
                            var thisOrderCanUserIntegra=0;
                            if(integral<priceCanUseIntegral){
                                integralObj.canUse=priceCanUseIntegral;
                                thisOrderCanUserIntegra=integral;
                            }else{
                                integralObj.canUse=priceCanUseIntegral;
                                thisOrderCanUserIntegra=priceCanUseIntegral;
                            }
                            hlp.bindtpl(integralObj, "#div_submitOrder_integral", "tpl_submitOrder_integral");

                            //积分的checkBox
                            $("#submitOrderCheckbox").off("tap").on("tap", function () {
                                if($(this).hasClass("checked")){
                                    $(this).removeClass("checked");
                                    //$("#integral").attr("readonly","readonly");
                                    $("#integral").val("");
                                    //刷新价格列表
                                    updateAllPrice(sum_price,"0",freight);

                                }else{
                                    if(parseInt(thisOrderCanUserIntegra)>0){
                                        if(priceCanUseIntegral==0){
                                            hlp.myalert("活动商品不可以使用积分！");
                                        }else{
                                            $(this).addClass("checked");
                                            //$("#integral").removeAttr("readonly");
                                            $("#integral").val(thisOrderCanUserIntegra);
                                            updateAllPrice(sum_price,thisOrderCanUserIntegra,freight);
                                        }
                                    }else{
                                        $('#integral').val("");
                                        hlp.myalert("当前可用积分为0 ！");
                                    }
                                }
                            });
                            $("#cancel_voucher").off("tap").on("tap",function(){
                                $("#vouchers1").show();
                                $("#vouchers2").hide();
                                $("#voucherPrice").text("0元");
                                var sumTotalPrice = parseFloat($("#sumTotalPrice").text().split("元")[0]) + parseFloat(hlp.panelObj["voucherPrice"]);
                                sumTotalPrice = sumTotalPrice.toFixed(2);
                                $("#sumTotalPrice").text(sumTotalPrice+"元");
                                hlp.panelObj["voucherPrice"] = 0;
                            })
                            $("#usevouchers").off("tap").on("tap",function(){
                                console.log(goods);
                                var goodsArr = [];
                                goods.forEach(function(item,i){
                                    goodsArr.push(item.sn)
                                });
                                var goodsStr = goodsArr.join(',');
                                svc.promoCheckVouchers(goodsStr,$("#voucher_value").val(),function(r){
                                    if(r.status=="SUCCESS"){
                                        $("#vouchers1").hide();
                                        $("#vouchers2").show();
                                        $("#voucherCode").text($("#voucher_value").val());
                                        hlp.panelObj["voucherPrice"] =  r.data.cv_amount;
                                        $("#voucherMoney,#voucherPrice").text(r.data.cv_amount+"元");
                                        var sumTotalPrice = $("#sumTotalPrice").text().split("元")[0] - hlp.panelObj["voucherPrice"];
                                        sumTotalPrice = sumTotalPrice.toFixed(2);
                                        $("#sumTotalPrice").text(sumTotalPrice+"元");

                                    }else{
                                        hlp.myalert(r.message);
                                    }
                                })
                            });
                            $('#integral').off("input").on("input", function () {
                                if(parseInt(thisOrderCanUserIntegra)>0){

                                    if(!$("#submitOrderCheckbox").hasClass("checked")){
                                        $("#submitOrderCheckbox").addClass("checked");
                                    }
                                    var integral_now=$('#integral').val();
                                    var numCheck = new RegExp(/^[1-9]*[1-9][0-9]*$/);
                                    if(integral_now.trim().length==0){
                                        $('#integral').val("");
                                        updateAllPrice(sum_price,"0",freight);
                                        return;
                                    }else if(numCheck.test(integral_now)){
                                        if(parseInt(integral_now)>parseInt(thisOrderCanUserIntegra)){
                                            $('#integral').val(thisOrderCanUserIntegra);
                                            updateAllPrice(sum_price,thisOrderCanUserIntegra,freight);
                                            return;
                                        }else{
                                            //刷新价格列表
                                            updateAllPrice(sum_price,integral_now,freight);
                                        }
                                    }else{
                                        hlp.myalert("请输入正整数！");
                                        $('#integral').val("");
                                        updateAllPrice(sum_price,"0",freight);
                                    }
                                }else{
                                    $('#integral').val("");
                                    hlp.myalert("当前可用积分为0 ！");
                                }
                            });
                            //刷新价格列表
                            updateAllPrice(sum_price,"0",freight);
                            $("#submitOrderPay").off("tap").on("tap", function () {

                                var integral=$('#integral').val();
                                var sumTotalPrice=$('#sumTotalPrice').text().split("元")[0];
                                var submitOrderAddress=$('#submitOrderAddress').text();
                                var addressInfo=submitOrderAddress.split(" (")[0];
                                var personalInfo=submitOrderAddress.split(")")[1];
                                if(!$("#vouchers2").is(":hidden")){
                                    var voucher = $("#voucherCode").text();
                                }

                                if (sumTotalPrice == 0) {
                                	hlp.myalert("订单异常.");
                                	return false;
                                }


                                if($("#company").attr("class")=="cur"){
                                    invType="1";
                                    companyName=$("#companyName").val();
                                }else{
                                    invType="0";
                                    companyName="";
                                };
                                hlp.panelObj["payInformation"] = {
                                    "orderId": "",
                                    "orderPrice": sumTotalPrice,
                                    "addressInfo":addressInfo ,
                                    "personalInfo": personalInfo,
                                    "invoice": invType
                                };
                                //订单生成
                                hlp.log("before call shopping-car.js addOrder");
                                svc.addOrder(userId,addressId,goods,goodSuit,invType,companyName,integral,isCart,voucher,function(r){
                                    hlp.log("inside call shopping-car.js addOrder");
                                    if (r.status == "SUCCESS") {
                                        hlp.log(r.message);
                                        hlp.panelObj["payInformation"].orderId= r.data.order_sn;
                                        $.afui.loadContent("#pay");
                                    }else{
                                        hlp.myalert(r.message);
                                    }
                                })
                            });
                        };
                        //获取积分
                        getIntegral(tokenId,getIntegralSuccessCallback,undefined);
                    };
                    getBaoYouLine(getBaoYouLineSuccessCallback,undefined);
                };
                //获取商品清单
                getGoodsSimpleInfo(goods,goodSuit, getGoodsSimpleInfoSucceedCallBack, failedCallBack);
            }else{
                //$.afui.loadContent("#addressSelect");
                hlp.myalert("地址获取失败！");
            }
        };
        //选择的AddressId
        var selectAddressId=hlp.panelObj["selectAddressId"];
        if(!selectAddressId){
            //获取默认地址
            getDefaultAddress(userId,getAddressSucceedCallBack, failedCallBack);
        }else{
            //获取选择的地址
            getSelectedAddress(userId,selectAddressId.address_id,getAddressSucceedCallBack, failedCallBack);
        };
    });
    $("#submitOrder").on("panelunload", function (e){
        $(".homeButton").hide();
        delete hlp.panelObj["voucherPrice"];
        $("#voucher_value").val("");
        $("#vouchers2").hide();
        $("#vouchers1").show();
        delete hlp.panelObj["selectAddressId"];
    });

    //我的购物车
    $("#mallMyCart").on("panelload", function (e) {
        $(".cartButton").hide();
        $(".showMallButton").hide();
        hlp.log("before call get my cart");

        //清空右上角购物车图标上的数字
        $('#mainview .shortCar #quantityNewInCart').text(0);
        $('#mainview .shortCar #quantityNewInCart').css("display","none");
        loj.QuantityInCart=0;

        //if (!loj.IsLogin) { return; }

            var getMyCartSucceed=function(r){
                var shopingCartGoods= r.data;
                hlp.bindtpl(shopingCartGoods,"#mallMyCart_Div","tpl_cartgoodslist");

                //下面绑定方法
                //点击全选的方法
                $('.checkAll').off('tap').on('tap',function(){
                    //首先得到全选框的当前状态
                    var current;
                    if ($('#checkAll').hasClass('checked')){
                        current='checkAll';
                        $('#checkAll').removeClass('checked');
                    }else{
                        current='notCheckAll';
                        $('#checkAll').addClass('checked');
                    }
                    //首先得到checkbox 列表
                    var checkList = $('li .checkbox');
                    //如果当前是选中，那么本次点击就是取消。如果当前没有选中，那么本次点击就是选中
                    for(var i=0;i<checkList.length;i++){
                        if(current=='notCheckAll'){
                            checkList.eq(i).addClass('checked');
                        }else{
                            checkList.eq(i).removeClass('checked');
                        }
                    }

                    //刷新总金额
                    refreshTotalCount();

                });
                //点击某一条商品的check box,如果是取消，则要把checkAll也置为not checked
                $('li div.checkbox').off('tap').on('tap',function(){
                    var current;
                    //获得点击前的状态，选中或未选中
                    if($(this).hasClass('checked')){
                        current='checked';
                        $(this).removeClass('checked');
                    }else{
                        current='unchecked';
                        $(this).addClass('checked');
                    }

                    //如果之前是选中，那么此次就是取消，那么就要将checkAll的状态置为未选中
                    $('#checkAll').removeClass('checked');

                    //刷新总金额
                    refreshTotalCount();
                });

                //点击删除，从购物车中把这条商品删除并刷新该页面
                $('li a.del').off('tap').on('tap',function(){
                    //调用方法，删除该商品
                    hlp.log('delete goods in my cart');
                    var rec_id;
                    rec_id=$(this).parent().attr("id");
                    $.afui.popup({
                        title: "提示",
                        message: "是否确认删除该商品?",
                        cancelText: "取&nbsp;&nbsp;消",
                        doneText: "确&nbsp;&nbsp;定",
                        cancelCallback: function () {
                            hlp.log("deleteGoodsInMyCart cancel");
                        },
                        doneCallback: function () {
                            svc.deleteGoodsInMyCart(loj.UserId,rec_id,loj.sessionId, function(r){
                                if(r.status=='SUCCESS'){
                                    //删除成功,重新加载该页面
                                    getMyShopCartGoods(function(shopingCartGoods){
                                        //购物城还有商品
                                        $.afui.loadContent('#mallMyCart');
                                    },function(r){
                                        //购物城空了
                                        $.afui.loadContent("#mallMyCartNull");
                                    });
                                }else{
                                    //删除失败 
                                    hlp.log('删除商品失败!');
                                }

                            });
                        }
                    });
                });

                //点击清空购物车，会把购物车进行清空，所有商品都删除
                $('div.delAll').off('tap').on('tap',function(){
                    //调用方法，清空购物车
                    hlp.log('clean my cart');
                    
                    $.afui.popup({
                        title: "提示",
                        message: "是否确认清空全部商品?",
                        cancelText: "取&nbsp;&nbsp;消",
                        doneText: "确&nbsp;&nbsp;定",
                        cancelCallback: function () {
                            hlp.log("deleteGoodsInMyCart cancel");
                        },
                        doneCallback: function () {
                            svc.clearnMyCart(loj.UserId,loj.sessionId,function(r){
                        		if(r.status=='SUCCESS'){
                            		//删除成功,重新加载该页面
                                    $.afui.loadContent("#mallMyCartNull");
                            		refreshTotalCount();
                        		}else{
                            		//删除失败
                            		hlp.log('删除商品失败!');
                        		}
                    		});
                        }
                    });
                });

                //点击立即购买
                $('.fixedBuy a').off('tap').on('tap',function(){
                    var tokenId=loj.Credential;
                    var s="";
                    var sku_sn;
                    var goods_sn;
                    var quantity;
                    var length;
                    var goodCartList=[];
                    var goNextFlg=true;
                    //遍历所有记录
                    $('#cartGoodsList li div.checkbox').each(function(){
                        if($(this).hasClass('checked')){
                            //只统计选中的记录
                            sku_sn=$(this).attr('sku_sn');
                            goods_sn=$(this).attr('goods_sn');
                            quantity=$(this).parent().find('div.putNum input').val();
                            if(quantity.trim().length==0){
                                hlp.myalert("存在件数为空的商品！");
                                goNextFlg=false;
                                return;
                            }else{
                                s={"sku_sn":sku_sn,"sn":goods_sn,"num":quantity};
                                goodCartList.push(s);
                            }
                        }
                    });
                    if(goNextFlg){
                        if(goodCartList.length<=0){
                            hlp.myalert("未选中任何商品！");
                            return;
                        }
                        hlp.panelObj["buyNowGoods"]={"good":goodCartList,"isCart":"1"};

                        if(tokenId){
                            //判断用户的收货地址信息，并做出正确的迁移
                            buyNowFunction(tokenId);
                        }else{
                            showLoginController(function(result){},function(result){});
                        }
                    }

                });

                //现在统计下总金额
                var count=r.data.length;
                var price;
                var quantity;
                var totalPrice=parseFloat(0.00);
                var totalNum=0;
                for(var i=0;i<count;i++){
                    price=parseFloat(r.data[i].goods_price);
                    quantity=parseInt(r.data[i].goods_number);
                    totalPrice=totalPrice+price*quantity;
                    totalNum=totalNum+quantity;
                }
                totalPrice=totalPrice.toFixed(2);
                $('#totalMoney').text(totalPrice);
                $('.fixedBuy a span').text(totalNum);
            };
            var getMyCartFailed=function(r){
                $.afui.loadContent("#mallMyCartNull");
            }
        getMyShopCartGoods(getMyCartSucceed,getMyCartFailed);
    });
    $("#mallMyCart").on("panelunload", function (e) {
        $(".cartButton").show();
        $(".showMallButton").show();
    });

    //我的购物车为空时mallMyCartNull
    $("#mallMyCartNull").off("panelload").on("panelload", function (e){
        $(".cartButton").hide();
        $(".showMallButton").hide();
        hlp.specialGoBack="mallIndex";
        $.afui.setBackButtonVisibility(false);
    });
    $("#mallMyCartNull").on("panelunload", function (e) {
        $(".cartButton").show();
        $(".showMallButton").show();
        hlp.specialGoBack="";
        $.afui.setBackButtonVisibility(true);
    });
});
//获取默认地址
var getDefaultAddress=function(userId,succeedHandler, failedHandler){
    hlp.log("before call shopping-car.js getDefaultAddress");
    svc.getDefaultAddress(userId, function(getDefaultAddress_res){
        hlp.log("inside call shopping-car.js getDefaultAddress");
        if (getDefaultAddress_res.status == "SUCCESS") {
            hlp.log(getDefaultAddress_res.message);
            //var data_address=r.data;
            if(succeedHandler){
                succeedHandler(getDefaultAddress_res);
            }
        }else{
            if(failedHandler){
                failedHandler(getDefaultAddress_res.message);
            }
        }
    });
};

//获取选择的地址
var getSelectedAddress=function(userId,address_id,succeedHandler, failedHandler){
    hlp.log("before call shopping-car.js getAddressList with addressId");
    svc.getAddressListByAddressId(userId, address_id, function(getSelectedAddress_res){
        hlp.log("inside call shopping-car.js getAddressList with addressId");
        if (getSelectedAddress_res.status == "SUCCESS") {
            hlp.log(getSelectedAddress_res.message);
            if(succeedHandler){
                succeedHandler(getSelectedAddress_res);
            }
        }else{
            if(failedHandler){
                failedHandler(r.message);
            }
        }
    });
};

//显示地址
var showTheAddress=function(data_address){
    var address=data_address.province_name+" "+data_address.city_name+" "+data_address.district_name+" "+data_address.address+" "+"("+data_address.zipcode+")";
    var mobileAndName=data_address.consignee+" "+data_address.mobile;
    var defaultAddress={"address":address,"mobileAndName":mobileAndName};
    hlp.panelObj["selectAddressId"]={"address_id":data_address.address_id};
    hlp.bindtpl(defaultAddress, "#div_submitOrder_address", "tpl_submitOrder_address");
};

//提交表单，商品清单
var getGoodsSimpleInfo=function(goods,goodSuit,succeedHandler, failedHandler){
    if(goods){
        var snString="";
        //普通商品
        for(var i=0;i<goods.length;i++){
            if(snString==""){
                snString= goods[i].sn;
            }else{
                snString=snString+","+goods[i].sn;
            }
        };
        hlp.log("before call shopping-car.js getGoodsSimpleInfo");
        svc.getGoodsSimpleInfo(snString,"","",function(r){
            hlp.log("inside call shopping-car.js getGoodsSimpleInfo");
            if (r.status == "SUCCESS") {
                hlp.log(r.message);
                var goodsSimpleInfoList= r.data;
                var sum_price_isSpecial=0;
                var sum_price=0;
                var num=0;
                for(var i=0;i<goodsSimpleInfoList.length;i++){
                    for(var j=0;i<goods.length;i++){
                        if(goodsSimpleInfoList[i].goods_sn==goods[i].sn){
                            if(goodsSimpleInfoList[i].extension_code=="common"){
                                //普通价（手机价，商城价）
                                goodsSimpleInfoList[i].promo_price="";//将活动价置空
                                if(goodsSimpleInfoList[i].app_price=="0.00"||goodsSimpleInfoList[i].app_price==null){
                                    //商场价
                                    goodsSimpleInfoList[i].app_price="";
                                    var price=parseFloat(goodsSimpleInfoList[i].shop_price);
                                }else{
                                    //手机价
                                    goodsSimpleInfoList[i].shop_price="";
                                    var price=parseFloat(goodsSimpleInfoList[i].app_price);
                                }
                            }else{
                                //活动价
                                goodsSimpleInfoList[i].app_price="";
                                goodsSimpleInfoList[i].shop_price="";
                                var price=parseFloat(goodsSimpleInfoList[i].promo_price);
                            }
                            //单样商品的数量
                            var sum=parseFloat(goods[i].num);
                            //单样商品的总价
                            var totalPrice=price * sum;

                            //商品总数量
                            num=num+sum;
                            //商品总价
                            sum_price=sum_price+totalPrice;
                            //判断是否是特殊商品，特殊商品不能用积分抵扣
                            if(goodsSimpleInfoList[i].is_special==1){
                                sum_price_isSpecial=sum_price_isSpecial+totalPrice;
                            }
                            goodsSimpleInfoList[i]["sum"]=sum;
                            goodsSimpleInfoList[i]["totalPrice"]=totalPrice;
                        }
                    };
                };
                var submitOrder_goods_data={"num":num,"goodsSimpleInfoList":goodsSimpleInfoList};
                hlp.bindtpl(submitOrder_goods_data, "#div_submitOrder_goods", "tpl_submitOrder_goods");

                if(succeedHandler){
                    succeedHandler(sum_price,sum_price_isSpecial);
                }
            }else{
                if(failedHandler){
                    failedHandler(r.message);
                }
            }
        });
    }else if(goodSuit){
        //套装商品
        hlp.log("before call shopping-car.js getGoodsSimpleInfo");
        svc.getGoodsSimpleInfo("",goodSuit.suitCode,goodSuit.extensionCode,function(r){
            hlp.log("inside call shopping-car.js getGoodsSimpleInfo");
            if (r.status == "SUCCESS") {
                hlp.log(r.message);
                var goodsSimpleInfo=r.data;
                var goodsSimpleInfoList=[];
                var sum_price=parseFloat(goodsSimpleInfo.promo_price);
                var num=parseInt(goodSuit.num);
                var sum_price_isSpecial=0;
                if(goodsSimpleInfo.is_special==1){
                    //特殊商品
                    sum_price_isSpecial=sum_price;
                }else{
                    //非特殊商品
                    sum_price_isSpecial=0;
                }
                goodsSimpleInfo["sum"]=num;
                goodsSimpleInfo["totalPrice"]= sum_price=sum_price*num;
                goodsSimpleInfoList.push(goodsSimpleInfo);

                var submitOrder_goods_data={"num":num,"goodsSimpleInfoList":goodsSimpleInfoList};
                hlp.bindtpl(submitOrder_goods_data, "#div_submitOrder_goods", "tpl_submitOrder_goods");

                if(succeedHandler){
                    succeedHandler(sum_price,sum_price_isSpecial);
                }
            }else{
                if(failedHandler){
                    failedHandler(r.message);
                }
            }
        });
    }else{
        hlp.myalert("没有购买的商品！");
    }
};

//可用积分
var getIntegral=function (tokenId,succeedHandler, failedHandler){
    hlp.log("before call shopping-car.js getIntegral");
    svc.getintegraln(tokenId,"tokenId",function(r){
        hlp.log("inside call shopping-car.js getIntegral");
        if (r.status == "SUCCESS") {
            hlp.log(r.message);
            if(r.userIntegral=="empty"){
                var integral="0";
            }else{
                var integral=parseFloat(r.userIntegral);
                if(succeedHandler){
                    succeedHandler(integral);
                }
            }
        }else{
            hlp.myalert(r.message);
            if(failedHandler){
                failedHandler();
            }
        }
    });
};

//验证码登录
var codeLogin=function(mPoneNumber,succeedHandler, failedHandler){
    //验证码正确后，直接login
    svc.codeLogin(mPoneNumber, function(codeLogin_result) {
        if (codeLogin_result.status == "SUCCESS") {
            //codeLogin_result["userId"]=mPoneNumber;
            loj.setOnline(codeLogin_result,"flyco");
            hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
            hlp.log(hlp.format("UserId:{0}",[loj.UserId]));
            hlp.log(hlp.format("LoginType:{0}",[loj.LoginType]));
            hlp.myalert("已自动登录了您的飞科账户！");
            if(succeedHandler){
                succeedHandler();
            };
        }else{
            if(failedHandler){
                failedHandler();
            };
            hlp.myalert("codeLogin result:"+codeLogin_result.message);
        }
    });
};

//密码登陆
var passwordLogin=function(mPoneNumber, buyWithoutVericode,succeedHandler, failedHandler){
    hlp.log("before call shopping-car.js userAuthentication");
    svc.userAuthentication(mPoneNumber, buyWithoutVericode, function(userAuthentication_res){
        hlp.log("inside call shopping-car.js userAuthentication");
        if (userAuthentication_res.status == "SUCCESS") {
            hlp.log( userAuthentication_res.message);
            //userAuthentication_res.userId=mPoneNumber;
            loj.setOnline(userAuthentication_res,"flyco");
            hlp.log(hlp.format("Credential:{0}",[loj.Credential]));
            hlp.log(hlp.format("UserId:{0}",[loj.UserId]));
            hlp.log(hlp.format("LoginType:{0}",[loj.LoginType]));
            hlp.myalert("系统已经为您自动创建了飞科账户！"+"<br>"+"用户名为手机号，密码为验证码！");
            if(succeedHandler){
                succeedHandler();
            }
        }else{
            if(failedHandler){
                failedHandler();
            }
            hlp.log( userAuthentication_res.message);
        };
    });
};

//增&&减购买数量
var minusCount1 = function(recId){
    var quantity = $("#shoppingCartQuantity").val();
    if(Number(quantity)>1){
        var succeedCallback=function(){
            $("#popMsg").text("");
            $("#shoppingCartQuantity").val(quantity);
        };
        var failedCallback=function(){
            $("#popMsg").text("购买数量仍大于库存！");
            $("#shoppingCartQuantity").val(quantity);
        };
        quantity--;
        changeCartGoods(loj.UserId,recId,quantity,succeedCallback, failedCallback);
    }
};
var plusCount1 = function(recId){
    var quantity = $("#shoppingCartQuantity").val();
    var succeedCallback=function(){
        $("#popMsg").text("")
        $("#shoppingCartQuantity").val(quantity);
    };
    var failedCallback=function(){
        $("#popMsg").text("亲，该宝贝不能购买更多！");
    };
    quantity++;
    changeCartGoods(loj.UserId,recId,quantity,succeedCallback, failedCallback);
};

//减号在数量为1的时候显示灰色
var minus_grey=function(){
    var quantity=$("#shoppingCartQuantity").val();
    if (Number(quantity)<=1) {
        $(".afPopup.show a#minus").css({"color": "#e5e5e5"});
    } else {
        $(".afPopup.show a#minus").css({"color": "#000"});
    }
};

var refreshTotalCount = function(){
    var price=0.0;
    var totalPrice=0.0;
    var quantity=0;
    var totalNum=0;
    //取出所有记录
    $('#cartGoodsList li div.checkbox').each(function(){
        if( $(this).hasClass('checked')){
            //只统计选中的行
            price=$(this).attr("price");
            quantity=$(this).parent().find('.putNum input').val();
            if(quantity.trim().length==0){
                quantity=0;
            }else{
                quantity=parseInt(quantity);
            }
            totalPrice=totalPrice+price*quantity;
            totalNum=totalNum+quantity;
        }
    });

    //将总金额显示
    totalPrice=totalPrice.toFixed(2);
    $('.fixedBuy #totalMoney').text(totalPrice);
    $('.fixedBuy a span').text(totalNum);
};

//获取包邮标准
var getBaoYouLine=function(succeedHandler, failedHandler){
    hlp.log("before call shopping-car.js getBaoYouLine");
    svc.getBaoYouLine(function(r){
        hlp.log("inside call shopping-car.js getBaoYouLine");
        if (r.status == "SUCCESS") {
            hlp.log(r.message);
            if(succeedHandler){
                succeedHandler(r.data);
            }
        } else {
            if(failedHandler){
                failedHandler();
            }
            hlp.log(r.message);
            hlp.myalert("添加地址失败");
        }
    });
};

var clearRegTmNotLogin = function(){
    $("#notLoginBuySendCode").text("发送验证码");
    $("#notLoginBuySendCode").removeClass("disabled");
    clearInterval(notLoginHandler);
    notLoginSendCodeEnableFg = true;
};

//发送验证码的倒计时
var notLoginHandler = 0;
var count = 60;
var notLoginSendCodeEnableFg = true;
var notLoginBuyerGetNumber = function () {
    notLoginSendCodeEnableFg = false;
    $("#notLoginBuySendCode").text(count + "秒后重发");
    $("#notLoginBuySendCode").addClass("disabled");
    count--;
    if (count > 0) {
        notLoginHandler = setTimeout(notLoginBuyerGetNumber, 1000);
    } else {
        var mPoneNumber=$("#notLoginMPoneNumber").val();
        hlp.log("before call shopping-car.js deleteCode");
        svc.deleteCode(mPoneNumber,function(r){
            hlp.log("inside call shopping-car.js deleteCode");
            if(r.status=="SUCCESS"){
                hlp.log(r.message);
            }else{
                hlp.log(r.message);
            }
        });
        $("#notLoginBuySendCode").text("获取动态验证码");
        $("#notLoginBuySendCode").removeClass("disabled");
        notLoginSendCodeEnableFg = true;
        count = 60;
    }
};

//使用积分点击事件
var showIntegral = function(){
    if($("#integralDiv").is(":hidden")){
        $("#integralDiv").css("display","block");
        $("#showIntegralDiv").addClass("showcanshu");
    }else{
        $("#integralDiv").css("display","none");
        $("#showIntegralDiv").removeClass("showcanshu");
    }
};

//使用优惠券
var showCoupon = function(){
    $("#vouchers1").toggle();
};

//商品清单点击事件
var showGoodList = function(){
    if($("#goodList").is(":hidden")){
        $("#goodList").css("display","block");
        $("#div_submitOrder_goods").addClass("showcanshu");
    }else{
        $("#goodList").css("display","none");
        $("#div_submitOrder_goods").removeClass("showcanshu");
    }
};

//支付宝
var flycoAlipay = function(userId,orderSn, price, payType) {
    svc.getPayPrepare(userId,orderSn, price, payType, function(r) {
        if (r.status == "SUCCESS") {
            // 交易号
            var tradeNo = r.data.out_trade_no;
            alipay(
                function (r1) {
                    if (r1.status == "SUCCESS") {
                        //hlp.myalert("r1.status: " + r1.status);
                        //判断是否成功调用并跳转到相应的页面
                        svc.getPayStatus(orderSn, function(r2) {
                            //hlp.myalert("r2.status: " + r2.status);
                            //hlp.myalert("orderSn: " + orderSn);
                            if (r2.status == "SUCCESS") {
                                loj.payActioned = true;
                                hlp.panelObj["order"] = { "sn": orderSn };
                                $.afui.loadContent("#orderDetail1");
                            } else {
                                hlp.myalert("订单状态更新失败!");
                            }
                        });
                    } else {
                        if (r1.code == '6001') {
                            loj.payActioned = true;
                            hlp.panelObj["order"] = { "sn": orderSn };
                            $.afui.loadContent("#unpayedOrder");
                            loj.payActioned = true;
                        } else {
                            hlp.myalert(r1.message);
                        }
                    }
                },
                function (err) {
                    hlp.myalert(err);
                },
                tradeNo, orderSn, price
            );
        } else {
            hlp.myalert("交易号获取失败!");
        }
    });
};

// 微信支付
var flycoWxPay = function(userId,orderSn, price, payType) {
    svc.getPayPrepare(userId,orderSn, price, payType, function(r) {
        console.log(r)
        if (r.status == "SUCCESS") {
            console.log(r)
            // 交易号
            var tradeNo = r.data.out_trade_no;
            wxpay(
                function (r1) {
                    if (r1.status == "SUCCESS") {
                        //hlp.myalert("r1.status: " + r1.status);
                        //判断是否成功调用并跳转到相应的页面
                        svc.getPayStatus(orderSn, function(r2) {
                            //hlp.myalert("r2.status: " + r2.status);
                            //hlp.myalert("orderSn: " + orderSn);
                            if (r2.status == "SUCCESS") {
                                loj.payActioned = true;
                                hlp.panelObj["order"] = { "sn": orderSn };
                                $.afui.loadContent("#orderDetail1");
                            } else {
                                hlp.myalert("订单状态更新失败!");
                            }
                        });
                    } else {
                        hlp.myalert(r1.message);
                        if (r1.code == '-1' || r1.code == '-2' || r1.code == '-3') {
                            loj.payActioned = true;
                            hlp.panelObj["order"] = { "sn": orderSn };
                            $.afui.loadContent("#unpayedOrder");
                        }
                    }
                },
                function (err) {
                    hlp.myalert(err);
                },
                tradeNo, orderSn, price
            );
        } else {
            hlp.myalert("交易号获取失败!");
        }
    });
};

// 银联支付
var flycoUnionPay = function(userId,orderSn, price, payType) {
    svc.getPayPrepare(userId,orderSn, price, payType, function(r) {
        if (r.status == "SUCCESS") {
            // 交易号
            var tradeNo = r.data.out_trade_no;
            unionpay(
                function (r1) {
                    if (r1.status == "SUCCESS") {
                        //hlp.myalert("r1.status: " + r1.status);
                        //判断是否成功调用并跳转到相应的页面
                        svc.getPayStatus(orderSn, function(r2) {
                            //hlp.myalert("r2.status: " + r2.status);
                            //hlp.myalert("orderSn: " + orderSn);
                            if (r2.status == "SUCCESS") {
                                loj.payActioned = true;
                                hlp.panelObj["order"] = { "sn": orderSn };
                                $.afui.loadContent("#orderDetail1");
                            } else {
                                hlp.myalert("订单状态更新失败!");
                            }
                        });
                    } else {
                        hlp.myalert(r1.message);
                        if (r1.code == '-1' || r1.code == '-2' || r1.code == '-3') {
                            loj.payActioned = true;
                            hlp.panelObj["order"] = { "sn": orderSn };
                            $.afui.loadContent("#unpayedOrder");
                        }
                    }
                },
                function (err) {
                    hlp.myalert(err);
                },
                tradeNo, orderSn, price
            );
        } else {
            hlp.myalert("交易号获取失败!");
        }
    });
};

//购物车修改
var changeCartGoods=function(userId,id,num,succeedHandler, failedHandler){
    svc.editCart(userId,id,num,loj.sessionId,function(r){
        if(r.status=="SUCCESS"){
            hlp.log(r.message);
            if(succeedHandler){
                succeedHandler();
            }
        }else{
            hlp.log(r.message);
            if(failedHandler){
                failedHandler();
            }
        }
    })
};

// 手机号码验证
var checkMobile = function(str) {
    var re = /^1\d{10}$/;
    if (re.test(str)) {
        return true;
    } else {
        return false;
    }
};

//将未登录状态下加到购物车里的数据，更新到当前登录的用户下
var updateShopCart=function(succeedHandler, failedHandler){
    svc.sessionIdToUserId(loj.sessionId,loj.UserId,function(sessionIdToUserId_res){
        if (sessionIdToUserId_res.status == "SUCCESS") {
            loj.sessionId="";
            if(succeedHandler){
                succeedHandler();
            }
        }else{
            hlp.myalert("购物车表更新失败！");
        }
    });
};

//刷新价格列表
var updateAllPrice=function(sum_price,integral_now,freight){
    if(hlp.panelObj["voucherPrice"]==undefined){
        hlp.panelObj["voucherPrice"] = 0;
    }
    //用积分抵扣的钱
    var useIntegralCutPrice=parseInt(integral_now)/10;
    //刷新积分抵扣金额
    $('#integralToCash').text(useIntegralCutPrice);
    var sumTotalPrice=sum_price-useIntegralCutPrice+freight - hlp.panelObj["voucherPrice"];
    sumTotalPrice = sumTotalPrice.toFixed(2);
    var summation={"price":sum_price,"integralPrice":useIntegralCutPrice,"freight":freight,"sumTotalPrice":sumTotalPrice};//最后的结算
    hlp.bindtpl(summation, "#div_submitOrder_totalPrice", "tpl_submitOrder_totalPrice");
    $("#voucherPrice").text(hlp.panelObj["voucherPrice"]+"元");
    $.afui.unBlockUIwithMask();
};

//获取购物车里的商品
var getMyShopCartGoods=function(succeedHandler, failedHandler){
    svc.getMyCart(loj.UserId, loj.sessionId,function(r) {
        if (r.status == "SUCCESS") {
            if(succeedHandler){
                succeedHandler(r);
            }
        }else{
            if(failedHandler){
                failedHandler(r);
            }
        }
    });
};

//购物车手动输入件数
var changeQuantity= function (recId) {
    var iniNum=$("#quantity"+recId).val();
    myPopup=$.afui.popup({
        title: " ",
        message:
        '购买件数: ' +
        '<a id="minus" onclick="minusCount1('+recId+');">-</a> ' +
        '<input type="text" id="shoppingCartQuantity" value="'+iniNum+'"/>' +
        '<a id="plus" onclick="plusCount1('+recId+')">+</a>' +
        '<p id="popMsg"></p>',
        cancelText: "取&nbsp;&nbsp;消",
        doneText: "确&nbsp;&nbsp;定",
        cancelOnly:false,
        cancelCallback: function () {
            myPopup=null;
            return;
        },
        doneCallback: function () {
            var quantity=$("#shoppingCartQuantity").val();
            if(quantity.trim().length==0){
                $("#quantity"+recId).val(iniNum);
            }else{
                $("#quantity"+recId).val(quantity);
            }
            refreshTotalCount();
            myPopup=null;
        }
    });
    var quantity=$("#shoppingCartQuantity").val();
    $("#shoppingCartQuantity").focus().val(quantity);
    //输入框事件
    $("#shoppingCartQuantity").off("input").on("input", function () {
        var quantity=$("#shoppingCartQuantity").val();
        var numCheck = new RegExp(/^[1-9]*[1-9][0-9]*$/);
        if(quantity.trim().length==0){
            return;
        }else if(numCheck.test(quantity)){
            var succeedCallback=function(){
                $("#popMsg").text("");
            };
            var failedCallback=function(){
                $("#popMsg").text("您购买的数量大于当前库存！");
                $("#shoppingCartQuantity").val("");
            };
            changeCartGoods(loj.UserId,recId,quantity,succeedCallback, failedCallback);
        }else{
            $("#popMsg").text("件数必须为正整数！");
            $("#shoppingCartQuantity").val("");
            return;
        }
    });
}



