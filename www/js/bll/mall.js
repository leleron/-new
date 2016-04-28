$(function () {
    $.afui.launch();

    // 商城主页
    $("#mallIndex,#mallSearchResult,#mallCategory,#mallList,#newProduct,#secKill,#groupon,#seckillItem,#grouponItem,#commodityDetails1,#commodityDetails2,#commodityDetails3").on("backcomplete", function (e) {
        $(".cartButton").show();
    });

    var is_keyboard = false;
    var is_landscape = false;
    var initial_screen_size = window.innerHeight;
    window.addEventListener("resize", function () {
        is_keyboard = (window.innerHeight < initial_screen_size);
        var hash = window.location.hash;
        switch (hash) {
        	case "#mallIndex":
        		hideFooter(is_keyboard);
        		break;
        	case "#commodityDetails1":
        		commodity(is_keyboard, hash);
        		break;
        	case "#evaluationSubmit":
        		evaluate(is_keyboard, hash, initial_screen_size);
        		break;
        	case "#evaluateMore":
        		evaluate(is_keyboard, hash, initial_screen_size);
        		break;
        	default:
        		break;
        }
    }, false);
    
    var hideFooter = function (is_keyboard) {
    	if (is_keyboard) {
            $(".mallFooter").hide();
        } else {
            $(".mallFooter").show();
        }
    }
    
    var commodity = function (is_keyboard, hash) {
    	if (is_keyboard) {
    		var purchaseTop = $('#purchaseQuantity').offset().top;
    		var dgTop = $("div#goodsDetail div.swiper-wrapper div").offset().top;
    		if (purchaseTop > (window.innerHeight / 2)) {
    			$(hash).animate({ scrollTop: purchaseTop - dgTop }, 500);
    		}
        } else {
        	$(hash).animate({ scrollTop: 0 }, 500);
        }
    }
    
    var evaluate = function (is_keyboard, hash, initial_screen_size) {
    	if (is_keyboard) {
        	$(hash).animate({ scrollTop: initial_screen_size }, 500);
        } else {
        	$(hash).animate({ scrollTop: 0 }, 500);
        }
    }

    $("#mallSearchResult").on("panelload", function (e) {
        $(".cartButton").show();
        $(".headSearchIcon").show();
        $("#headSearch").show();
    });
    $("#mallSearchResult").on("panelunload", function (e) {
        $(".cartButton").show();
        $(".headSearchIcon").show();
        $("#headSearch").show();
        $("#headSearch").val("");
    });

    $("#mallCategory").on("panelload", function (e) {
        $(".cartButton").show();
    });
    $("#mallCategory").on("panelunload", function (e) {
        $(".cartButton").hide();
    });

    $("#mallList").on("panelload", function (e) {
        $(".cartButton").show();
    });
    $("#mallList").on("panelunload", function (e) {
        $(".cartButton").hide();
    });

    $("#newProduct").on("panelload", function (e) {
        $(".cartButton").show();
    });
    $("#newProduct").on("panelunload", function (e) {
        $(".cartButton").hide();
    });

    $("#secKill").on("panelload", function (e) {

        $(".cartButton").show();
        //    console.log("secKill:panel load");
    });
    $("#secKill").on("panelunload", function (e) {
        $(".cartButton").hide();
        //console.log("secKill:panel unload");
    });
    //
    $("#groupon").on("panelload", function (e) {
        $(".cartButton").show();
    });
    $("#groupon").on("panelunload", function (e) {
        $(".cartButton").hide();
    });
    //
    //$("#groupon").on("panelload", function (e) {
    //    $(".cartButton").show();
    //});
    //$("#groupon").on("panelunload", function (e) {
    //    $(".cartButton").hide();
    //});

    $("#pay").on("panelload", function (e) {
        //TODO 隐藏backbutton
    });
    $("#pay").on("panelunload", function (e) {
        //TODO 显示backbutton
    });

    //$("#seckillItem").on("panelload", function (e) {
    //    $(".cartButton").show();
    //});
    //$("#seckillItem").on("panelunload", function (e) {
    //    $(".cartButton").hide();
    //});
    //
    //$("#grouponItem").on("panelload", function (e) {
    //    $(".cartButton").show();
    //});
    //$("#grouponItem").on("panelunload", function (e) {
    //    $(".cartButton").hide();
    //});

    //商品详情页面
    $("#commodityDetails1").on("panelload", function (e) {
        //$(".cartButton").show();
        $(".prodetails .fav span").css('background', 'url("../images/greyStar.png")');
    });
    $("#commodityDetails1").on("panelunload", function (e) {
        //$(".cartButton").hide();
    });

    //$("#commodityDetails2").on("panelload", function (e) {
    //    $(".cartButton").show();
    //});
    //$("#commodityDetails2").on("panelunload", function (e) {
    //    $(".cartButton").hide();
    //});
    //
    //$("#commodityDetails3").on("panelload", function (e) {
    //    $(".cartButton").show();
    //});
    //$("#commodityDetails3").on("panelunload", function (e) {
    //    $(".cartButton").hide();
    //});

    // news_top
    $("#UserCenter").on("panelload", function (e) {
        // $.afui.loadContent("#main");

        var uid = hlp.getparam(1);

        // tpl_mtlist
        svc.getuserprofile(uid, function (r) {

            hlp.binddata(r, "#mtlist", "tpl_mtlist");

        });
    });

    // 3.1.4.1.1 个人商城
    $("#myMall").on("panelload", function (e) {
        "use strict";

        // 刷新购物车图标
        //RefreahShopCarIcon();
    });

    // 3.1.4.1.4.1 退款单
    $("#refundList").on("panelload", function (e) {
        "use strict";

        svc.getRefundList(loj.UserId, function (res) {
            if (res.data == null) {
                res.data = "";
            }

            //apply_time: "2015-03-24 15:12:38"
            //goods_thumb: "/sources/goods/FH6618/FH6618_big.jpg"
            //order_sn: "150228000097"
            //refund_money: "133"
            //returns_order_sn: "14271811589586"
            //returns_status: "1"
            //returns_statusString: "已提交"
            //total_money: "153.00"

            for (var i = 0; i < res.data.length; i++) {
                res.data[i]["returns_statusString"] = ReturnsStatusMapping[res.data[i].returns_status];
            }

            hlp.bindtpl(res.data, "#refundListDiv", "refundList_itemAdd");

            // 退款列表画面： 按下订单 处理
            $("#refundList a.tkListItem").bind("tap", function (e) {
                var returnsOrderSn = $(this).attr("returns_order_sn");

                var selectedOrderInfo = undefined;

                for (var i = 0; i < res.data.length; i++) {
                    if (returnsOrderSn == res.data[i].returns_order_sn) {
                        selectedOrderInfo = res.data[i];
                        break;
                    }
                }

                hlp.log("Navigate to good detial page. returns_order_sn:" + returnsOrderSn + " User id:" + loj.UserId + " orderInfo:" + selectedOrderInfo);

                hlp.panelObj["orderInfo"] = selectedOrderInfo;

                $.afui.loadContent("#refundDetail");
            });
        });
    });

    // 3.1.4.1.4.1 退款单详细 画面参数：hlp.panelObj["orderInfo"];
    $("#refundDetail").on("panelload", function (e) {
        "use strict";

        var orderInfo = hlp.panelObj["orderInfo"];

        svc.getRefundOrReturnDetail(orderInfo.returns_order_sn, function (res) {
            res.data.order_info["returns_statusString"] = ReturnsStatusMapping[res.data.order_info.returns_status];

            // 商品单价 * 商品数量 = 商品总价
            for (var i = 0; i < res.data.goods_info.length; i++) {
                res.data.goods_info[i]["goodsTotalPrice"] = parseInt(res.data.goods_info[i].goods_number) * parseInt(res.data.goods_info[i].goods_price);

                if (res.data.goods_info[i].lastupdate_time == null) {
                    res.data.goods_info[i].lastupdate_time = "";
                }
            }

            hlp.bindtpl(res.data.order_info, "#refundDetailorderDetailDiv", "refundDetail_orderDetailAdd");

            // 使用 退货单详细 画面的模板
            hlp.bindtpl(res.data.goods_info, "#refundDetailDiv", "returnDetail_itemAdd");

            $("#refundDetail li.tkListItem a.returnDetailItem").bind("tap", function (e) {
                var goodsSn = $(this).attr("goods_sn");

                hlp.log("Navigate to good detial page. goodsSn:" + goodsSn + " User id:" + loj.UserId);
            });
        });
    });

    $("#refundDetail").on("panelunload", function (e) {
        "use strict";

        delete hlp.panelObj["orderInfo"];
    });

    // 3.1.4.1.4.2 退货单
    $("#returnList").on("panelload", function (e) {
        "use strict";

        svc.getReturnList(loj.UserId, function (res) {
            if (res.data == null) {
                res.data = "";
            }

            //apply_time: "2015-03-24 18:44:13"
            //goods_thumb: "http://121.41.169.212:30002/sources/goods/FS372/FS372_000_01--w_80_h_80.jpg"
            //order_sn: "141205000157"
            //refund_goods: "a:1:{i:0;a:9:{s:7:"barcode";s:13:"6949123303725";s:10:"goods_name";s:9:"剃须刀";s:8:"ext_attr";s:0:"";s:11:"goods_price";s:5:"99.00";s:12:"goods_number";s:1:"2";s:9:"deal_code";s:12:"141205000157";s:9:"goods_img";s:37:"/sources/goods/FS372/FS372_000_01.jpg";s:8:"goods_sn";s:5:"FS372";s:6:"reason";s:3:"dAD";}}"
            //returns_order_sn: "14271938539292"
            //returns_status: "2"
            //total_money: 99

            for (var i = 0; i < res.data.length; i++) {
                res.data[i]["returns_statusString"] = ReturnsStatusMapping[res.data[i].returns_status];
            }

            hlp.bindtpl(res.data, "#returnListDiv", "returnList_itemAdd");

            // 退货列表画面： 按下订单 处理
            $("#returnList a.tkListItem").bind("tap", function (e) {
                var returnsOrderSn = $(this).attr("returns_order_sn");

                var selectedOrderInfo = undefined;

                for (var i = 0; i < res.data.length; i++) {
                    if (returnsOrderSn == res.data[i].returns_order_sn) {
                        selectedOrderInfo = res.data[i];
                    }
                }

                hlp.log("Navigate to good detial page. returns_order_sn:" + returnsOrderSn + " User id:" + loj.UserId + " orderInfo:" + selectedOrderInfo);

                hlp.panelObj["orderInfo"] = selectedOrderInfo;

                $.afui.loadContent("#returnDetail");
            });
        });
    });

    // 3.1.4.1.4.2.1 退货单详细 画面参数：hlp.panelObj["orderInfo"];
    $("#returnDetail").on("panelload", function (e) {
        "use strict";

        // order_info
        //lastupdate_time: null
        //pay_name: "支付宝"
        //returns_order_sn: "14271928878121"
        //returns_status: "0"
        //shipping_fee: "0.00"
        //total_goods_price: "198.00"
        //total_trans_price: "198.00"

        // goods_info
        //goods_name: "剃须刀"
        //goods_number: "2"
        //goods_price: "99.00"
        //goods_thumb: "http://121.41.169.212:30002/sources/goods/FS372/FS372_big--w_80_h_80.jpg"

        var orderInfo = hlp.panelObj["orderInfo"];

        var changeTwoDecimal = function (x) {
            var f_x = parseFloat(x);
            if (isNaN(f_x)) {
                alert('function:changeTwoDecimal->parameter error');
                return false;
            }
            var f_x = Math.round(x * 100) / 100;
            var s_x = f_x.toString();
            var pos_decimal = s_x.indexOf('.');
            if (pos_decimal < 0) {
                pos_decimal = s_x.length;
                s_x += '.';
            }
            while (s_x.length <= pos_decimal + 2) {
                s_x += '0';
            }
            return s_x;
        }

        svc.getRefundOrReturnDetail(orderInfo.returns_order_sn, function (res) {
            hlp.log("Call svc.getRefundOrReturnDetail. response:" + JSON.stringify(res));

            res.data.order_info["returns_statusString"] = ReturnsStatusMapping[res.data.order_info.returns_status];

            if (!res.data.order_info.lastupdate_time || res.data.order_info.lastupdate_time == null) {
                res.data.order_info.lastupdate_time = "未处理";
            }

            // 商品单价 * 商品数量 = 商品总价
            for (var i = 0; i < res.data.goods_info.length; i++) {
                res.data.goods_info[i]["goodsTotalPrice"] = changeTwoDecimal(parseFloat(res.data.goods_info[i].goods_number) * parseFloat(res.data.goods_info[i].goods_price));
            }

            hlp.bindtpl(res.data.order_info, "#returnDetailorderDetailDiv", "returnDetail_orderDetailAdd");

            hlp.bindtpl(res.data.goods_info, "#returnDetailDiv", "returnDetail_itemAdd");

            $("#returnDetail li.tkListItem a.returnDetailItem").bind("tap", function (e) {
                var goodsSn = $(this).attr("goods_sn");

                hlp.log("Navigate to good detial page. goodsSn:" + goodsSn + " User id:" + loj.UserId);
            });
        });


    });

    $("#returnDetail").on("panelunload", function (e) {
        "use strict";

        delete hlp.panelObj["orderInfo"];
    });

    // 3.1.4.1.5.1 收货地址管理
    $("#addressManage").on("panelload", function (e) {
        "use strict";

        svc.getAddressList(loj.UserId, function (res) {
            if (res.data == null) {
                res.data = "";
            }

            svc.setDefaultAddress("", loj.UserId, function (res1) {
                if (res1.data != null) {
                    // 设置默认地址
                    for (var i = 0; i < res.data.length; i++) {
                        if (res.data[i].address_id == res1.data.address_id) {
                            res.data[i]["default_address_prop"] = "cur";
                            break;
                        }
                    }
                }

                hlp.bindtpl(res.data, "#addressManageDiv", "addressManage_itemAdd");

                // Bug 658
                // $("#addressManageDiv li.tkListItem a").bind("tap", function (e) {
                $("#addressManageDiv li.tkListItem a").bind("click", function (e) {
                    var addressId = $(this).attr("address_id");

                    var selectedAddressInfo = undefined;

                    for (var i = 0; i < res.data.length; i++) {
                        if (addressId == res.data[i].address_id) {
                            selectedAddressInfo = res.data[i];
                        }
                    }

                    hlp.panelObj["addressInfo"] = selectedAddressInfo;

                    hlp.log("Navigate to Addredd edit page. address_id:" + addressId + " User id:" + loj.UserId + " addressInfo:" + selectedAddressInfo);

                    $.afui.loadContent("#addressEdit");
                });

                $("#addressManageDiv li.addBtn a").one("tap", function (e) {
                    hlp.log("Navigate to Addredd add page. User id:" + loj.UserId);
                    $.afui.loadContent("#addressAdd");
                });

            });
        });
    });

    // 3.1.4.1.5.2 新增收货地址
    $("#addressAdd").on("panelload", function (e) {
        "use strict";

        // 地址Selection初始化
        InitAddressSelects(
            "#addressAdd form#addAddressForm div.addressBg select#addAddress_province", "addAddress_province",
            "#addressAdd form#addAddressForm div.addressBg select#addAddress_city", "addAddress_city",
            "#addressAdd form#addAddressForm div.addressBg select#addAddress_district", "addAddress_district",
            "address_itemAdd");
        var emptySelection = '<option value="-1"> --请选择--  </option>';
        $("#addressAdd form#addAddressForm div.addressBg select#addAddress_city").empty();
        $("#addressAdd form#addAddressForm div.addressBg select#addAddress_city").append(emptySelection);
        $("#addressAdd form#addAddressForm div.addressBg select#addAddress_district").empty();
        $("#addressAdd form#addAddressForm div.addressBg select#addAddress_district").append(emptySelection);

        svc.getPromo(function (res) {
            if (res.status == "SUCCESS") {
                $("#addressAdd div#addAddressMessage").text(res.data.desc);
            } else {
                hlp.log("Call svc.getPromo failed. message:" + res.message);
            }
        });

        // 重置表单
        $("#addressAdd #addAddressForm input").each(function () {
            $(this).val("");
        });
        $("#addressAdd #addAddressForm select").each(function () {
            if ($(this) && $(this)[0]) {
                $(this)[0].selectedIndex = 0;
            }
        });

        var mobile = hlp.panelObj["notLoginBuyMobile"];
        if (mobile) {
            $("#addressAdd_mobile").val(mobile.mobile);
        }
        ;

        var form = $("#addressAdd #addAddressForm");
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

        $("#addressAdd #addAddressForm").attr("submitted", "false");
    });

    $("#addressAdd").on("panelunload", function (e) {
        "use strict";

        delete hlp.panelObj["notLoginBuyMobile"];
    });

    // 3.1.4.1.5.3 收货地址修改
    $("#addressEdit").on("panelload", function (e) {
        "use strict";

        // 初始化表单
        var addressInfo = hlp.panelObj["addressInfo"];

        if (addressInfo.default_address_prop == "cur") {
            $("#addressEdit form#editAddressForm #SetAsDefaultAddressDiv").css("display", "none");
            $("#addressEdit form#editAddressForm #DelAddressButtonDiv").css("display", "none");
        } else {
            $("#addressEdit form#editAddressForm #SetAsDefaultAddressDiv").css("display", "");
            $("#addressEdit form#editAddressForm #DelAddressButtonDiv").css("display", "");
        }

        // 地址Selection初始化
        InitAddressSelects(
            "#addressEdit form#editAddressForm div.addressBg select#editAddress_province", "editAddress_province",
            "#addressEdit form#editAddressForm div.addressBg select#editAddress_city", "editAddress_city",
            "#addressEdit form#editAddressForm div.addressBg select#editAddress_district", "editAddress_district",
            "addressEdit_itemAdd", addressInfo);

        svc.getAddressListByAddressId(loj.UserId, addressInfo.address_id, function (res) {

            $("#addressEdit #editAddressForm input[name=address_consignee]").val(res.data.consignee);
            $("#addressEdit #editAddressForm input[name=address_address]").val(res.data.address);
            $("#addressEdit #editAddressForm input[name=address_zipcode]").val(res.data.zipcode);
            $("#addressEdit #editAddressForm input[name=address_tel]").val(res.data.tel);
            $("#addressEdit #editAddressForm input[name=address_mobile]").val(res.data.mobile);
            $("#addressEdit #editAddressForm input[name=address_id]").val(res.data.address_id);

            var form = $("#addressEdit #editAddressForm");

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

        });

        // 收货地址 删除 对话框 确定按钮
        $("#addressEdit div.layOutDel a.btnOk").off("tap").on("tap", function (e) {
            hlp.log("myFavorite del item submit. addressId:" + addressInfo.address_id + " User id:" + loj.UserId);

            $("#addressEdit div.layOutDel").fadeTo("fast", 0, function () {
                $("#addressEdit div.layOutDel").css("display", "none");
            });

            svc.delAddress(addressInfo.address_id, loj.UserId, function (res) {
                hlp.log("myFavorite del item submitted. status:" + res.status + " message:" + res.message);

                $.afui.goBack();
            });
        });

        // 收货地址 删除 对话框 取消按钮
        $("#addressEdit div.layOutDel a.btnNo").off("tap").on("tap", function (e) {
            $("#addressEdit div.layOutDel").fadeTo("fast", 0, function () {
                $("#addressEdit div.layOutDel").css("display", "none");
            });
        });

        $("#addressEdit #editAddressForm").attr("submitted", "false");
    });

    $("#addressEdit").on("panelunload", function (e) {
        "use strict";

        var emptySelection = '<option value="-1"> --请选择--  </option>';
        $("#addressEdit form#editAddressForm div.addressBg select#editAddress_province").empty();
        $("#addressEdit form#editAddressForm div.addressBg select#editAddress_province").append(emptySelection);
        $("#addressEdit form#editAddressForm div.addressBg select#editAddress_city").empty();
        $("#addressEdit form#editAddressForm div.addressBg select#editAddress_city").append(emptySelection);
        $("#addressEdit form#editAddressForm div.addressBg select#editAddress_district").empty();
        $("#addressEdit form#editAddressForm div.addressBg select#editAddress_district").append(emptySelection);

        // 重置表单
        $("#addressEdit form#editAddressForm input").each(function () {
            $(this).val("");
        });
        $("#addressEdit form#editAddressForm select").each(function () {
            if ($(this) && $(this)[0]) {
                $(this)[0].selectedIndex = 0;
            }
        });

        delete hlp.panelObj["addressInfo"];
    });

    // 3.1.4.1.6 我的收藏
    $("#myFavorite").on("panelload", function (e) {
        "use strict";

        hlp.log("#myFavorite panelload.");

        // 我的收藏 列表刷新
        var refreshMyFavoriteFunc = function () {
            hlp.log("RefreshMyFavorite svc.getMyFavouriteList.");

            svc.getMyFavouriteList(loj.UserId, 1, function (res) {
                if (res.data == null) {
                    res.data = "";
                }

                //add_time: "2015-07-14 09:40:35"
                //goods_img: "/sources/goods/FH6618/FH6618_big.jpg"
                //goods_name: "飞科FH6618电吹风"
                //goods_sn: "FH6618"
                //is_attention: "0"
                //promo_price: "0.00"
                //rec_id: "150"
                //sales_number: "1253295"
                //sales_type: "0"
                //shop_price: "79.00"
                //user_id: "15696126517"

                hlp.bindtpl(res.data, "#myFavouriteDiv", "myFavouriteList_itemAdd");

                $("#myFavorite div.tkListItem a.del").bind("tap", function (e) {
                    $("#myFavorite div.layOutDel").css({display: "block", opacity: "0"});
                    $("#myFavorite div.layOutDel").fadeTo("fast", 1);

                    var goodsSn = $(this).attr("goods_sn");
                    $(".myGoodsSn").val(goodsSn);
                });

                $("#myFavorite div.tkListItem img, #myFavorite div.tkListItem strong, #myFavorite div.tkListItem span").bind("tap", function (e) {
                    if (hlp.panelObj["commodityDetails"] == null || hlp.panelObj["commodityDetails"] == undefined) {
                        hlp.panelObj["commodityDetails"] = {};
                    }
                    hlp.log("Navigate to good detial page. goodsSn:" + $(this).attr("goods_sn") + " User id:" + loj.UserId);
                    hlp.panelObj["commodityDetails"].sn = $(this).attr("goods_sn");
                    //hlp.panelObj["commodityDetails"].sales_type = "0";
                    $.afui.loadContent("#commodityDetails1");
                });
            });
        };

        refreshMyFavoriteFunc();

        // 我的收藏 删除 对话框 确定按钮
        $("#myFavorite div.layOutDel a.btnOk").off("tap").on("tap", function (e) {
            var goodsSn = $(".myGoodsSn").val();

            hlp.log("myFavorite del item submit. goodsSn:" + goodsSn + " User id:" + loj.UserId);

            $(".layOutDel").fadeTo("fast", 0, function () {
                $(".layOutDel").css("display", "none");
            });

            svc.delFavourite(loj.UserId, goodsSn, function (res) {
                refreshMyFavoriteFunc();
            });
        });

        // 我的收藏 删除 对话框 取消按钮
        $("#myFavorite div.layOutDel a.btnNo").off("tap").on("tap", function (e) {
            $("#myFavorite div.layOutDel").fadeTo("fast", 0, function () {
                $("#myFavorite div.layOutDel").css("display", "none");
            });
        });
    });

    // 3.1.4.1.7.1 已评价商品
    $("#evaluatedList").on("panelload", function (e) {
        "use strict";

        hlp.log("#evaluatedList panelload.");

        svc.getGoodsComment(loj.UserId, 1, function (res) {
            if (res.data == null) {
                res.data = "";
            }

            hlp.log("Call svc.getGoodsComment success. response:" + JSON.stringify(res));

            //add_time: "2015-07-13 14:10:06"
            //allow_amend: "1"
            //answer: null
            //append_comment: Object
            //comment_id: "12937"
            //comment_img: false
            //comment_rank: "1"
            //content: "卷毛！"
            //goods_name: "飞科FR5211毛球修剪器"
            //goods_sn: "FR5211"
            //goods_thumb: "/sources/goods/FR5211//FR5211_big.jpg"
            //order_sn: "141011111096"
            //status: "0"

            //add_time: "2015-07-13 16:09:00"
            //allow_amend: "1"
            //answer: null
            //comment_id: "12938"
            //comment_img: ""
            //comment_rank: "1"
            //content: "还是卷毛！！！"
            //status: "0"

            var data = {
                "status": "SUCCESS",
                "message": "查询成功",
                "data": [
                    {
                        "order_sn": "150803000019",
                        "goods_sn": "FS359",
                        "goods_name": "飞科FS359剃须刀",
                        "goods_thumb": "http://121.41.169.212:30002/sources/goods/FS359/FS359_big--w_80_h_80.jpg",
                        "comment_rank": "5",
                        "content": "初次评价123",
                        "answer": null,
                        "comment_img": "",
                        "comment_id": "13016",
                        "status": "0",
                        "allow_amend": "1",
                        "add_time": "2015-08-03 10:08:51",
                        "append_comment": []
                    },
                    {
                        "order_sn": "150731000171",
                        "goods_sn": "FS359",
                        "goods_name": "飞科FS359剃须刀",
                        "goods_thumb": "http://121.41.169.212:30002/sources/goods/FS359/FS359_big--w_80_h_80.jpg",
                        "comment_rank": "5",
                        "content": "评价3",
                        "answer": null,
                        "comment_img": "",
                        "comment_id": "13004",
                        "status": "0",
                        "allow_amend": "1",
                        "add_time": "2015-07-31 15:07:31",
                        "append_comment": []
                    },
                    {
                        "order_sn": "150731000502",
                        "goods_sn": "FS359",
                        "goods_name": "飞科FS359剃须刀",
                        "goods_thumb": "http://121.41.169.212:30002/sources/goods/FS359/FS359_big--w_80_h_80.jpg",
                        "comment_rank": "5",
                        "content": "评价2",
                        "answer": null,
                        "comment_img": "",
                        "comment_id": "13003",
                        "status": "0",
                        "allow_amend": "1",
                        "add_time": "2015-07-31 15:03:29",
                        "append_comment": {
                            "comment_rank": "5",
                            "content": "追加评价",
                            "answer": null,
                            "comment_img": "",
                            "comment_id": "13025",
                            "status": "0",
                            "allow_amend": "1",
                            "add_time": "2015-08-03 12:54:51"
                        }
                    }
                ]
            };

            // commentObj.comment_img = "[url1,url2]"  -> commentObj.CommentImages = "[<img src=url1>, <img src=url2>]"
            var createCommentImageDom = function (commentObj, logFlag) {
                if (commentObj.comment_id == undefined) {
                    if (logFlag == true) {
                        hlp.log("Call createCommentImageDom set undefined to commentObj:" + JSON.stringify(commentObj));
                    }
                    return undefined;
                }

                // hlp.log("Call createCommentImageDom accept:" + JSON.stringify(commentObj));

                try {
                    if (commentObj && commentObj.comment_img) {
                        var imageArr = JSON.parse(commentObj.comment_img);
                        var temp = "";

                        for (var j = 0; j < 5; j++) {
                            if (j >= imageArr.length) {
                                break;
                            }

                            if (imageArr[j] != "\"" && imageArr[j] != "[" && imageArr[j] != "]") {
                                temp = temp + "<img src='" + imageArr[j] + "' class=\"defaultEvaluteImg\"/>";
                            } else {
                                if (logFlag == true) {
                                    hlp.log("Call createCommentImageDom ignore imageUrl:" + imageArr[j]);
                                }
                            }
                        }

                        commentObj["CommentImages"] = temp;
                    }

                    if (logFlag == true) {
                        hlp.log("Call createCommentImageDom return:" + JSON.stringify(commentObj));
                    }

                    return commentObj;
                } catch (e) {
                    try {
                        if (commentObj && commentObj.comment_img) {

                            if (Object.prototype.toString.call(commentObj.comment_img) == "[object Array]") {
                                var temp = "";

                                for (var j = 0; j < 5; j++) {
                                    if (j >= commentObj.comment_img.length) {
                                        break;
                                    }

                                    var imageUrl = commentObj.comment_img[j];

                                    if (imageUrl != "\"" && imageUrl != "[" && imageUrl != "]") {
                                        temp = temp + "<img src='" + commentObj.comment_img[j] + "' class=\"defaultEvaluteImg\"/>";
                                    } else {
                                        if (logFlag == true) {
                                            hlp.log("Call createCommentImageDom ignore imageUrl:" + imageUrl);
                                        }
                                    }
                                }
                            } else {
                                temp = "<img src='" + commentObj.comment_img + "' class=\"defaultEvaluteImg\"/>";
                                ;
                            }

                            commentObj["CommentImages"] = temp;
                        }

                        if (logFlag == true) {
                            hlp.log("Call createCommentImageDom return:" + JSON.stringify(commentObj));
                        }

                        return commentObj;
                    } catch (e1) {
                        commentObj["CommentImages"] = "";
                        commentObj.comment_img = [];

                        if (logFlag == true) {
                            hlp.log("Call createCommentImageDom set undefined to commentObj['CommentImages']" + JSON.stringify(commentObj));
                        }

                        return commentObj;
                    }
                }
            };

            for (var i = 0; i < res.data.length; i++) {
                var rank = parseInt(res.data[i].comment_rank);

                // 初始化星级显示
                if (rank == 0 || rank == NaN) {
                    res.data[i]["rankStarStyle"] = "display: none;";
                } else {
                    res.data[i]["rankStarStyle"] = "width: " + ((rank - 1) * 20).toString() + "%;";
                }

                // 初始化评论内容
                if (res.data[i].answer == null) {
                    // res.data[i].answer = "";

                    res.data[i]["answerStyle"] = "display: none;";
                }

                if (res.data[i].append_comment == null || res.data[i].append_comment == undefined || res.data[i].append_comment.length == 0) {
                    res.data[i]["appendCommentStyle"] = "display: none;";
                    res.data[i]["answerForAppendStyle"] = "display: none;";
                } else {
                    if (res.data[i].append_comment.answer == null || res.data[i].append_comment.answer == undefined) {
                        res.data[i]["answerForAppendStyle"] = "display: none;";
                    }
                }

                res.data[i]["commentRankString"] = CommentRankMapping[res.data[i].comment_rank];

                // 初始化首次评价上传的照片
                res.data[i] = createCommentImageDom(res.data[i]);

                // 初始化追加评价上传的照片
                res.data[i].append_comment = createCommentImageDom(res.data[i].append_comment);

                if (res.data[i] && res.data[i].append_comment == undefined) {
                    res.data[i]["moreEvaluteStyle"] = "display: block;";
                } else {
                    res.data[i]["moreEvaluteStyle"] = "display: none;";
                }

                hlp.log("Item " + i + " moreEvaluteStyle " + res.data[i]["moreEvaluteStyle"]);
            }

            hlp.bindtpl(res.data, "#evaluatedListDiv", "evaluatedList_itemAdd");

            //for (i = 0; i < res.data.length; i++) {
            //    if (res.data[i].CommentImages) {
            //        $("#evaluatedListDiv li.tkListItem[comment_id=" + res.data[i].comment_id + "][goods_sn=" + res.data[i].goods_sn + "][order_sn=" + res.data[i].order_sn + "] div#evaluatedList_FirstCommentImages").append(res.data[i].CommentImages);
            //    }

            //    if (res.data[i].append_comment && res.data[i].append_comment.CommentImages) {
            //        $("#evaluatedListDiv li.tkListItem[comment_id=" + res.data[i].comment_id + "][goods_sn=" + res.data[i].goods_sn + "][order_sn=" + res.data[i].order_sn + "] div#evaluatedList_SecondCommentImages").append(res.data[i].append_comment.CommentImages);
            //    }
            //}

            for (i = 0; i < res.data.length; i++) {
                if (res.data[i].CommentImages) {
                    $("#evaluatedListDiv li.tkListItem div#evaluatedList_FirstCommentImages")[i].innerHTML = res.data[i].CommentImages;
                }

                if (res.data[i].append_comment && res.data[i].append_comment.CommentImages) {
                    $("#evaluatedListDiv li.tkListItem div#evaluatedList_SecondCommentImages")[i].innerHTML = res.data[i].append_comment.CommentImages;
                }
            }

            // 点击图片放大事件
            var imageClickFun = function () {
                if ($(this).attr("class") == "defaultEvaluteImg") {
                    var imgObj = new Image();
                    imgObj.src = $(this).attr("src");

                    //if (imgObj.height > imgObj.width) {
                    //$.afui.blockUI(0.5);
                    $(this).attr("class", "scaredEvaluteImg");
                    //} else {
                    //    $(this).attr("class", "scaredRotatedEvaluteImg");
                    //}

                    imgObj = null;
                } else {
                    $(this).attr("class", "defaultEvaluteImg");
                }
            };

            $("#evaluatedListDiv li.tkListItem div#evaluatedList_FirstCommentImages img").bind("tap", imageClickFun);
            $("#evaluatedListDiv li.tkListItem div#evaluatedList_SecondCommentImages img").bind("tap", imageClickFun);

            // 点击追加评价事件
            var gotoMoreEvaluteFun = function (e) {
                var orderSn = $(this).attr("order_sn");

                var goodSn = $(this).attr("goods_sn");

                var goodInfo = undefined;

                for (var i = 0; i < res.data.length; i++) {
                    if (goodSn == res.data[i].goods_sn && orderSn == res.data[i].order_sn) {
                        goodInfo = res.data[i];
                    }
                }

                if (goodInfo && goodInfo.append_comment == undefined) {
                    hlp.panelObj["goodInfo"] = goodInfo;
                    hlp.log("Navigate to evaluation append page. order_sn:" + orderSn + " goods_sn:" + goodSn + " User id:" + loj.UserId + " goodInfo:" + goodInfo);

                    $.afui.loadContent("#evaluateMore");
                } else {
                    hlp.myalert("请不要多次追加评论");
                }
            };

            // $("#evaluatedListDiv li.tkListItem div#evaluatedListImgAndLink a").bind("tap", gotoMoreEvaluteFun);
            $("#evaluatedListDiv li.tkListItem div#evaluatedListImgAndLink span").on("tap", gotoMoreEvaluteFun);

            var gotoCommodityDetailsFun = function (e) {
                if (hlp.panelObj["commodityDetails"] == null || hlp.panelObj["commodityDetails"] == undefined) {
                    hlp.panelObj["commodityDetails"] = {};
                }
                hlp.log("Navigate to good detial page. goodsSn:" + $(this).attr("goods_sn") + " User id:" + loj.UserId);

                hlp.panelObj["commodityDetails"].sn = $(this).attr("goods_sn");
                hlp.panelObj["commodityDetails"].sales_type = "0";
                $.afui.loadContent("#commodityDetails1");
            };

            $("#evaluatedListDiv li.tkListItem #evaluatedListImgAndLink img").bind("tap", gotoCommodityDetailsFun);
            $("#evaluatedListDiv li.tkListItem .score.score2 strong").bind("tap", gotoCommodityDetailsFun);

        });

    });

    // 3.1.4.1.7.2 未评价商品
    $("#evaluateReadyList").on("panelload", function (e) {
        "use strict";

        hlp.log("#evaluateReadyList panelload.");

        svc.getGoodsNocomment(loj.UserId, 1, function (res) {
            if (res.data == null) {
                res.data = "";
            }

            //add_time: "2014-10-11 15:28:34"
            //goods_name: "飞科FR5211毛球修剪器"
            //goods_sn: "FR5211"
            //goods_thumb: "/sources/goods/FR5211//FR5211_big.jpg"
            //order_sn: "141011111096"
            //shop_price: "49.00"

            hlp.bindtpl(res.data, "#evaluateReadyListDiv", "evaluateReadyList_itemAdd");


            $("#evaluateReadyListDiv li.tkListItem em").bind("tap", function (e) {
                var orderSn = $(this).attr("order_sn");

                var goodSn = $(this).attr("goods_sn");

                var goodInfo = undefined;

                for (var i = 0; i < res.data.length; i++) {
                    if (goodSn == res.data[i].goods_sn && orderSn == res.data[i].order_sn) {
                        goodInfo = res.data[i];
                    }
                }

                hlp.panelObj["goodInfo"] = goodInfo;

                hlp.log("Navigate to evaluation add page. order_sn:" + orderSn + " goods_sn:" + goodSn + " User id:" + loj.UserId + " goodInfo:" + goodInfo);

                $.afui.loadContent("#evaluationSubmit");
            });

            var gotoCommodityDetailsFun = function (e) {
                if (hlp.panelObj["commodityDetails"] == null || hlp.panelObj["commodityDetails"] == undefined) {
                    hlp.panelObj["commodityDetails"] = {};
                }
                hlp.log("Navigate to good detial page. goodsSn:" + $(this).attr("goods_sn") + " User id:" + loj.UserId);

                hlp.panelObj["commodityDetails"].sn = $(this).attr("goods_sn");
                hlp.panelObj["commodityDetails"].sales_type = "0";
                $.afui.loadContent("#commodityDetails1");
            };

            $("#evaluateReadyListDiv li.tkListItem img").bind("tap", gotoCommodityDetailsFun);
            $("#evaluateReadyListDiv li.tkListItem name").bind("tap", gotoCommodityDetailsFun);
        });
    });

    // 3.1.4.1.8 我的签到
    $("#checkin").on("panelload", function (e) {
        "use strict";

        hlp.log("#checkin panelload.");
        var checkinConnt=0;

        $("div#bonus").off("tap").on("tap", function (e) {
            $.afui.loadContent("#myPoints");
        });

        svc.getintegraln(loj.Credential, "tokenId", function (res) {
            hlp.log("Call svc.getintegraln. response:" + JSON.stringify(res));

            if (res.userIntegral) {
                $("#checkin div.signCon span#checkInHeaderSpan2").text(res.userIntegral);
            }
        });

        svc.getCheckInInfo(loj.UserId, function (res) {

            //sign_flag: 0
            //sign_total_integral: null

            $("#checkin div#checkInButtonDiv").empty();

            if (res.data.sign_flag == "0") {
                $("#checkin div#checkInButtonDiv").append('<a class="blueBtn">签到</a>');
            } else {
                $("#checkin div#checkInButtonDiv").append('<a class="blueBtn grey">今天已签到，请明天再来吧！</a>');
            }

            if (res.data.sign_total_integral == null) {
                res.data.sign_total_integral = "0";
            }

            $("#checkin div.signCon span#checkInHeaderSpan1").text(res.data.sign_total_integral);

            $("#checkin div#checkInButtonDiv .blueBtn").off("tap").on("tap",function(){
                var blueBtnFlg=$(this).attr("class");
                if(blueBtnFlg.indexOf("grey")>0){
                    return;
                }else{
                    if(checkinConnt>0){
                        return;
                    }else{
                        svc.doCheckIn(loj.UserId, function (res) {
                            if (res.status == "SUCCESS") {
                                checkinConnt++;
                                $.afui.loadContent("#checkinSuccess");

                                // response:{"status":"SUCCESS","message":"连续第1天签到+3积分","data":""}

                                hlp.myalert(res.message);
                                hlp.log("Call svc.doCheckIn success. response:" + JSON.stringify(res));

                            } else {
                                hlp.myalert("签到失败");
                            }
                        });
                    }
                }
            })
        });

        svc.getSignDesc(function(r) {
            if (r.status == "SUCCESS"){
                $(".signDesc").empty().append(r.data.sign_desc);
            } else{
                hlp.myalert(r.message);
            }
        });

        //svc.getMyPointsList(loj.UserId, 1, getNowDate().year, currentMonth, function (res1) {
        //    // datetime: "2015-07-07 09:43:17"
        //    // id: "1850"
        //    // integral: "900"
        //    // integral_desc: "注册送积分"
        //    // integral_type: "1"
        //    // invite_user_id: ""
        //    // order_integral_status: "0"
        //    // order_sn: ""
        //    // remark: "+900"
        //    // status: "0"
        //    // type: "1"
        //    // user_id: "15696126517"

        //    $("#checkin div.signCon span#checkInHeaderSpan2").text(res1.data[0].integral);
        //});
    });

    $("#checkinSuccess").on("panelload", function (e) {
        "use strict";

        // 3秒后自动返回
        setTimeout(function () {
            $.afui.loadContent("#checkin");
        }, 3000);

        $("#checkinSuccess img#checkInSuccessImg").off("tap").on("tap", function (e) {
            $.afui.loadContent("#checkin");
        });
    });

    // 3.1.4.1.9 我的积分
    $("#myPoints").on("panelload", function (e) {
        "use strict";

        hlp.log("#myPoints panelload.");

        hlp.bindtpl(null, "#myPointsListDiv", "myPoints_itemAdd");

        var currentYear = getNowDate().year;
        var currentMonth = getNowDate().month;

        var tempYear = [];
        for (var i = 0; i <= 41; i++) {
            tempYear[i] = {};
            tempYear[i]["value"] = currentYear - 20 + i;
            tempYear[i]["label"] = currentYear - 20 + i + " 年";
        }
        hlp.bindtpl(tempYear, "#myPointsSearchYear", "myPointsDate_itemAdd");
        $("#myPoints select#myPointsSearchYear").val(currentYear);

        var tempMonth = [];
        for (var j = 0; j < 12; j++) {
            tempMonth[j] = {};

            if ((1 + j) < 10) {
                tempMonth[j]["value"] = "0" + (1 + j).toString();
                tempMonth[j]["label"] = "0" + (1 + j).toString() + " 月";
            } else {
                tempMonth[j]["value"] = (1 + j).toString();
                tempMonth[j]["label"] = (1 + j).toString() + " 月";
            }
        }
        hlp.bindtpl(tempMonth, "#myPointsSearchMonth", "myPointsDate_itemAdd");
        if (currentMonth < 10) {
            $("#myPoints select#myPointsSearchMonth").val("0" + currentMonth);
        } else {
            $("#myPoints select#myPointsSearchMonth").val(currentMonth);
        }

        // 我的积分 查询
        $("#myPoints a#myPointsSearchBtn").off("tap").on("tap", function (e) {
            var selectedYear = $("#myPoints select#myPointsSearchYear").val();
            var selectedMonth = $("#myPoints select#myPointsSearchMonth").val();

            //svc.getMyPointsList(loj.UserId, 1, selectedYear, selectedMonth, function (res) {
            //    if (res.data == null) {
            //        res.data = "";
            //    }

            //    // datetime: "2015-07-07 09:43:17"
            //    // id: "1850"
            //    // integral: "900"
            //    // integral_desc: "注册送积分"
            //    // integral_type: "1"
            //    // invite_user_id: ""
            //    // order_integral_status: "0"
            //    // order_sn: ""
            //    // remark: "+900"
            //    // status: "0"
            //    // type: "1"
            //    // user_id: "15696126517"

            //    for (var i = 0; i < res.data.length; i++) {
            //        if (parseInt(res.data[i].remark) > 0) {
            //            res.data[i]["remarkClass"] = "blue";
            //        } else {
            //            res.data[i]["remarkClass"] = "red";
            //        }
            //    }

            //    hlp.bindtpl(res.data, "#myPointsListDiv", "myPoints_itemAdd");
            //});

            svc.getMyPointsList2(loj.Credential, selectedYear, selectedMonth, function (res) {
                if (res.userIntegralInfoList == null) {
                    res.userIntegralInfoList = "";
                }

                // "event": "完成订单150805000204送消费积分",
                // "eventTime": "2015-08-06",
                // "value": "+58"

                for (var i = 0; i < res.userIntegralInfoList.length; i++) {
                    if (parseInt(res.userIntegralInfoList[i].value) > 0) {
                        res.userIntegralInfoList[i]["remarkClass"] = "blue";
                    } else {
                        res.userIntegralInfoList[i]["remarkClass"] = "red";
                    }
                }

                hlp.bindtpl(res.userIntegralInfoList, "#myPointsListDiv", "myPoints_itemAdd");
            });
        });

        // 获取用户信息
        svc.getintegraln(loj.Credential, "tokenId", function (res) {
            hlp.log("Call svc.getintegraln. response:" + JSON.stringify(res));

            if (res.userIntegral) {
                $("#myPoints div.signCon span#myPointsHeaderSpan").text(res.userIntegral);
            }
        });
    });

    // 追加评价
    $("#evaluateMore").on("panelload", function (e) {
        "use strict";

        var goodInfo = hlp.panelObj["goodInfo"];
        var imageCount;

        $("#evaluateMoreDiv input#evaluateMoreOrderSn").val(goodInfo.order_sn);
        $("#evaluateMoreDiv input#evaluateMoreGoodSn").val(goodInfo.goods_sn);
        $("#evaluateMoreDiv input#evaluateMoreCommentId").val(goodInfo.comment_id);

        $("#evaluateMoreDiv div#evaluateMore_comment_rank div").each(function () {
            $(this).attr("class", "starGrey");
        });
        $("#evaluateMoreDiv textarea#evaluateMore_textarea").val("");
        $("#evaluateMoreDiv span#evaluateMore_textCount").html("140字");

        // 设置商品图片
        $("#evaluateMoreDiv img#evaluateMoreGoodsThumb").attr("src", goodInfo.goods_thumb);

        // 默认五星
        for (var j = 1; j <= 5; j++) {
            $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar" + j).attr("class", "star");
        }

        // 初始化星级评价控件
        $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar1").off("tap").on("tap", function (e) {
            if ($(this).attr("class") == "star") {
                if ($("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar2").attr("class") == "star") {
                    for (var j = 2; j <= 5; j++) {
                        $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar" + j).attr("class", "starGrey");
                    }
                } else {
                    for (var j = 1; j <= 5; j++) {
                        $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar" + j).attr("class", "starGrey");
                    }
                }
            } else {
                $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar1").attr("class", "star");
            }
        });
        for (var i = 2; i <= 5; i++) {
            $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar" + i).off("tap").on("tap", function (e) {
                var currentStarId = $(this).attr("id");

                hlp.log("div#evaluateMoreRankStar tap event handled id:" + currentStarId);

                for (var j = 1; j <= 5; j++) {
                    if (("evaluateMoreRankStar" + j) <= currentStarId) {
                        $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar" + j).attr("class", "star");
                    } else {
                        $("#evaluateMoreDiv div#evaluateMore_comment_rank div#evaluateMoreRankStar" + j).attr("class", "starGrey");
                    }
                }
            });
        }

        // 设置评价内容控件
        $("#evaluateMoreDiv textarea#evaluateMore_textarea").off("keyup").on("keyup", function (e) {
            hlp.log("#evaluateMoreDiv textarea#evaluateMore_textarea keyup event handled");

            var textContent = $(this).val();

            $("#evaluateMoreDiv span#evaluateMore_textCount").html((140 - textContent.length).toString() + "字");
        });

        // 清空评价图片
        $("#evaluateMore div#evaluateMore_UploadImage").empty();
        delete hlp.panelObj["imageArray"];
        hlp.panelObj["imageArray"] = [];

        $("#evaluateMoreDiv div#evaluateMore_photo").off("tap").on("tap", function (e) {
            hlp.log("#evaluateMoreDiv div#evaluateMore_photo tap event handled");

            imageCount = $("div#evaluateMore_UploadImage img").length;
            if (imageCount >= 4) {
                hlp.myalert("评论图片最多只能添加4张");
                return;
            }

            $("#evaluateMore div#SelectImageSource").css({display: "block", opacity: "0"});
            $("#evaluateMore div#SelectImageSource").fadeTo("fast", 1);
        });

        $("#evaluateMore div#SelectImageSource a#fromLib").off("tap").on("tap", function (e) {
            getPictureFromLibAsFileURI(function (imageData) {
                hlp.log("Call android plugin getPictureFromLibAsFileURI succeed: imageData:" + imageData.length);

                $("div#evaluateMore_UploadImage").append("<img src='data:image/jpg;base64," + imageData + "' style=\"width: 50px; height: 50px; margin-left: 5px; margin-right: 5px\"/>");
                hlp.panelObj["imageArray"].push("data:image/jpg;base64," + imageData);

                var imageNo = imageCount.toString();
                var controlName = "evaluationSubmitFileUpload" + imageNo;

                hlp.log("Image control count:" + $("div#evaluateMore_UploadImage img").length);

                hlp.log("Add image to div#evaluateMore_UploadImage. controlName:" + controlName);
            }, function (message) {
                hlp.log("Call android plugin getPictureFromLibAsFileURI failed: message:" + message);
            });

            $("#evaluateMore div#SelectImageSource").fadeTo("fast", 0, function () {
                $("#evaluateMore div#SelectImageSource").css("display", "none");
            });
        });

        $("#evaluateMore div#SelectImageSource a#fromCarm").off("tap").on("tap", function (e) {
            getPictureFromCameraAsFileURI(function (imageData) {
                hlp.log("Call android plugin getPictureFromCameraAsFileURI succeed: imageData:" + imageData.length);

                $("div#evaluateMore_UploadImage").append("<img src='data:image/jpg;base64," + imageData + "' style=\"width: 50px; height: 50px; margin-left: 5px; margin-right: 5px\"/>");
                hlp.panelObj["imageArray"].push("data:image/jpg;base64," + imageData);

                var imageNo = imageCount.toString();
                var controlName = "evaluationSubmitFileUpload" + imageNo;

                hlp.log("Image control count:" + $("div#evaluateMore_UploadImage img").length);

                hlp.log("Add image to div#evaluateMore_UploadImage. controlName:" + controlName);
            }, function (message) {
                hlp.log("Call android plugin getPictureFromCameraAsFileURI failed: message:" + message);
            });

            $("#evaluateMore div#SelectImageSource").fadeTo("fast", 0, function () {
                $("#evaluateMore div#SelectImageSource").css("display", "none");
            });
        });

        $("#evaluateMore div#SelectImageSource a.btnNo").off("tap").on("tap", function (e) {
            $("#evaluateMore div#SelectImageSource").fadeTo("fast", 0, function () {
                $("#evaluateMore div#SelectImageSource").css("display", "none");
            });
        });

    });

    $("#evaluateMore").on("panelunload", function (e) {
        "use strict";

        delete hlp.panelObj["goodInfo"];
    });

    // 发表评价
    $("#evaluationSubmit").on("panelload", function (e) {
        "use strict";

        var goodInfo = hlp.panelObj["goodInfo"];
        var imageCount;

        $("#evaluationSubmitDiv input#evaluationSubmitOrderSn").val(goodInfo.order_sn);
        $("#evaluationSubmitDiv input#evaluationSubmitGoodSn").val(goodInfo.goods_sn);

        $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div").each(function () {
            $(this).attr("class", "starGrey");
        });
        $("#evaluationSubmitDiv textarea#evaluationSubmit_textarea").val("");
        $("#evaluationSubmitDiv span#evaluationSubmit_textCount").html("140字");

        // 设置商品图片
        $("#evaluationSubmitDiv img#evaluationSubmitGoodsThumb").attr("src", goodInfo.goods_thumb);

        // 默认五星
        for (var j = 1; j <= 5; j++) {
            $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar" + j).attr("class", "star");
            $("#evaluation_texture").text("非常满意");
        }

        // 初始化星级评价控件
        //$("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar1").off("tap").on("tap", function (e) {
        //    if ($(this).attr("class") == "star") {
        //        if ($("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar2").attr("class") == "star") {
        //            for (var j = 2; j <= 5; j++) {
        //                $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar" + j).attr("class", "starGrey");
        //            }
        //        } else {
        //            for (var j = 1; j <= 5; j++) {
        //                $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar" + j).attr("class", "starGrey");
        //            }
        //        }
        //    } else {
        //        $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar1").attr("class", "star");
        //    }
        //});
        for (var i = 1; i <= 5; i++) {
            $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar" + i).off("tap").on("tap", function (e) {
                var currentStarId = $(this).attr("id");

                hlp.log("div#evaluationSubmitRankStar tap event handled id:" + currentStarId);

                switch(currentStarId){
                    case "evaluationSubmitRankStar1":
                        $("#evaluation_texture").text("差评");
                        break;
                    case "evaluationSubmitRankStar2":
                        $("#evaluation_texture").text("不好");
                        break;
                    case "evaluationSubmitRankStar3":
                        $("#evaluation_texture").text("一般");
                        break;
                    case "evaluationSubmitRankStar4":
                        $("#evaluation_texture").text("满意");
                        break;
                    case "evaluationSubmitRankStar5":
                        $("#evaluation_texture").text("非常满意");
                        break;
                }
                //显示星星数
                for (var j = 1; j <= 5; j++) {
                    if (("evaluationSubmitRankStar" + j) <= currentStarId) {
                        $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar" + j).attr("class", "star");
                    } else {
                        $("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div#evaluationSubmitRankStar" + j).attr("class", "starGrey");
                    }
                }
                //显示解释文字
            });
        }

        // 设置评价内容控件
        $("#evaluationSubmitDiv textarea#evaluationSubmit_textarea").off("keyup").on("keyup", function (e) {
            hlp.log("#evaluationSubmitDiv textarea#evaluationSubmit_textarea keyup event handled");

            var textContent = $(this).val();

            $("#evaluationSubmitDiv span#evaluationSubmit_textCount").html((140 - textContent.length).toString() + "字");
        });

        // 清空评价图片
        $("#evaluationSubmit div#evaluationSubmit_UploadImage").empty();
        delete hlp.panelObj["imageArray"];
        hlp.panelObj["imageArray"] = [];

        $("#evaluationSubmitDiv div#evaluationSubmit_photo").off("tap").on("tap", function (e) {
            hlp.log("#evaluationSubmitDiv div#evaluationSubmit_photo tap event handled");

            //// TODO Android only
            //getPictureFromCameraAsFileURI(function(imageData) {
            //    hlp.log("Call plugIn navigator.camera.getPicture success:" + imageData);

            //    // $("#evaluateMoreDiv div.evaluateMore_photo").append("<img src='" + "data:image/jpg;base64," + imageData + "' width=\"50px\" height=\"50px\"/>");

            //    $("#evaluateMoreDiv div input#evaluationSubmitFileUpload").val(imageData);


            // 1st step: upload by browser element input:file
            //var file = $("#evaluationSubmitDiv input#evaluationSubmitFileUpload").val();

            //svc.uploadImageFile(loj.UserId, goodInfo.goods_sn, "evaluationSubmitFileUpload", file, function (res) {
            //    hlp.log("Call uploadImageFile:" + res.message);

            //    $("#evaluationSubmit_UploadImage").append("<img src='" + res.image_name + "' style=\"width: 50px; height: 50px\"/>");
            //});

            imageCount = $("div#evaluationSubmit_UploadImage img").length;
            if (imageCount >= 4) {
                hlp.myalert("评论图片最多只能添加4张");
                return;
            }

            $("#evaluationSubmit div#SelectImageSource").css({display: "block", opacity: "0"});
            $("#evaluationSubmit div#SelectImageSource").fadeTo("fast", 1);
        });

        $("#evaluationSubmit div#SelectImageSource a#fromLib").off("tap").on("tap", function (e) {
            getPictureFromLibAsFileURI(function (imageData) {
                hlp.log("Call android plugin getPictureFromLibAsFileURI succeed: imageData:" + imageData);
                hlp.panelObj["imageArray"].push("data:image/jpg;base64," + imageData);

                $("div#evaluationSubmit_UploadImage").append("<img src='data:image/jpg;base64," + imageData + "' style=\"width: 50px; height: 50px; margin-left: 5px; margin-right: 5px\"/>");

                hlp.log("Image control count:" + $("div#evaluationSubmit_UploadImage img").length);
            }, function (message) {
                hlp.log("Call android plugin getPictureFromLibAsFileURI failed: message:" + message);
            });

            $("#evaluationSubmit div#SelectImageSource").fadeTo("fast", 0, function () {
                $("#evaluationSubmit div#SelectImageSource").css("display", "none");
            });
        });

        $("#evaluationSubmit div#SelectImageSource a#fromCarm").off("tap").on("tap", function (e) {
            getPictureFromCameraAsFileURI(function (imageData) {
                hlp.log("Call android plugin getPictureFromCameraAsFileURI succeed: imageData:" + imageData);
                hlp.panelObj["imageArray"].push("data:image/jpg;base64," + imageData);

                $("div#evaluationSubmit_UploadImage").append("<img src='data:image/jpg;base64," + imageData + "' style=\"width: 50px; height: 50px; margin-left: 5px; margin-right: 5px\"/>");

                hlp.log("Image control count:" + $("div#evaluationSubmit_UploadImage img").length);
            }, function (message) {
                hlp.log("Call android plugin getPictureFromCameraAsFileURI failed: message:" + message);
            });

            $("#evaluationSubmit div#SelectImageSource").fadeTo("fast", 0, function () {
                $("#evaluationSubmit div#SelectImageSource").css("display", "none");
            });
        });

        $("#evaluationSubmit div#SelectImageSource a.btnNo").off("tap").on("tap", function (e) {
            $("#evaluationSubmit div#SelectImageSource").fadeTo("fast", 0, function () {
                $("#evaluationSubmit div#SelectImageSource").css("display", "none");
            });
        });

        $("#evaluationSubmitDiv").attr("submitted", "false");
    });

    $("#evaluationSubmit").on("panelunload", function (e) {
        "use strict";

        delete hlp.panelObj["goodInfo"];
    });
});

jQuery.validator.addMethod("checkAddressSelectionRequire",
    function (value, element, param) {
        if (param) {
            return value != "-1";
        }

        return true;
    }, "请选择省市");

jQuery.validator.addMethod("regularExpressCheck",
    function (value, element, param) {
        if (value == "") {
            return false;
        } else {
            if (!param.test(value)) {
                return false;
            }
        }
        return true;
    }, "输入的数据不合法");

jQuery.validator.addMethod("regularExpressCheckNullable",
    function (value, element, param) {
        if (value == "") {
            return true;
        } else {
            if (!param.test(value)) {
                return false;
            }
        }
        return true;
    }, "输入的数据不合法");

// TODO 我的收藏 添加到收藏
function AddToFavourite(e) {
    "use strict";

    var goodsSn = $(".myGoodsSn").val();

    hlp.log("goodsSn:" + goodsSn + " User id:" + loj.UserId);

    // $.afui.loadContent("#myFavorite");
};

// 画面右上角 购物车图表初始化用 返回购物车内商品数量
//function GetItemCountInShopCar(callback) {
//    "use strict";
//
//    svc.getCartList(loj.UserId, function (res) {
//        //var shopCarData = {
//        //    "status": "SUCCESS",
//        //    "message": "查询成功",
//        //    "data": [
//        //        { "rec_id": "26240", "goods_sn": "FS360", "goods_name": "\u98de\u79d1FS359\u5243\u987b\u52000", "market_price": "298.01", "goods_price": "149.01", "goods_thumb": "\/sources\/goods\/FS359\/FS359_big.jpg", "goods_img": "\/sources\/goods\/FS359\/FS359_big.jpg" },
//        //        { "rec_id": "26241", "goods_sn": "FS361", "goods_name": "\u98de\u79d1FS359\u5243\u987b\u52001", "market_price": "298.02", "goods_price": "149.02", "goods_thumb": "\/sources\/goods\/FS359\/FS359_big.jpg", "goods_img": "\/sources\/goods\/FS359\/FS359_big.jpg" },
//        //        { "rec_id": "26242", "goods_sn": "FS362", "goods_name": "\u98de\u79d1FS359\u5243\u987b\u52002", "market_price": "298.03", "goods_price": "149.03", "goods_thumb": "\/sources\/goods\/FS359\/FS359_big.jpg", "goods_img": "\/sources\/goods\/FS359\/FS359_big.jpg" },
//        //    ]
//        //};
//
//        if (callback) {
//            callback(res.data.length);
//        }
//
//        return res.data.length;
//    });
//};

// 刷新购物车图标的商品数量
//function RefreahShopCarIcon() {
//    "use strict";
//
//    GetItemCountInShopCar(function (count) {
//        $("header a.cartButton div.shortCar span").each(function () {
//            $(this).text(count);
//        });
//    });
//};

// 添加新的收货地址
function AddAddress() {
    "use strict";

    hlp.log("AddAddress() Called. UserName:" + loj.UserId);

    var form = $("#addressAdd #addAddressForm");

    form.attr("check_status", "false");

    if (form.valid()) {

        if ($("#addressAdd #addAddressForm").attr("submitted") == "true") {
            return;
        } else {
            $("#addressAdd #addAddressForm").attr("submitted", "true");
        }

        hlp.log("AddAddress() Submit. UserName:" + loj.UserId);

        var data = {
            "user_id": loj.UserId,
            "consignee": $("#addressAdd #addAddressForm input[name=address_consignee]").val(),
            "province": $("#addressAdd #addAddressForm select[name=address_province]").val(),
            "city": $("#addressAdd #addAddressForm select[name=address_city]").val(),
            "district": $("#addressAdd #addAddressForm select[name=address_district]").val(),
            "address": $("#addressAdd #addAddressForm input[name=address_address]").val(),
            "email": "",
            "zipcode": $("#addressAdd #addAddressForm input[name=address_zipcode]").val(),
            "tel": $("#addressAdd #addAddressForm input[name=address_tel]").val(),
            "mobile": $("#addressAdd #addAddressForm input[name=address_mobile]").val()
        };

        hlp.log("AddAddress() data:" + JSON.stringify(data));

        svc.addAddress(data, function (res) {
            if (res.status == "SUCCESS") {
                hlp.myalert(res.message);
                var mobile = hlp.panelObj["notLoginBuyMobile"];
                if (mobile) {
                    buyNowFunction(loj.Credential);
                } else {
                    $.afui.goBack();
                }
            } else {
                hlp.log("svc.addAddress failed. message:" + res.message);

                hlp.myalert("添加地址失败");
            }
        });
    } /*else {
        hlp.myalert("输入的信息有误");
    }*/
};

// 编辑收货地址 提交
function EditAddress() {
    "use strict";

    hlp.log("EditAddress() Called. UserName:" + loj.UserId);

    var form = $("#addressEdit #editAddressForm");

    form.attr("check_status", "false");

    if (form.valid()) {

        if ($("#addressEdit #editAddressForm").attr("submitted") == "true") {
            return;
        } else {
            $("#addressEdit #editAddressForm").attr("submitted", "true");
        }

        hlp.log("EditAddress() Submit. UserName:" + loj.UserId);

        var data = {
            "user_id": loj.UserId,
            "address_id": $("#addressEdit #editAddressForm input[name=address_id]").val(),
            "consignee": $("#addressEdit #editAddressForm input[name=address_consignee]").val(),
            "province": $("#addressEdit #editAddressForm select[name=address_province]").val(),
            "city": $("#addressEdit #editAddressForm select[name=address_city]").val(),
            "district": $("#addressEdit #editAddressForm select[name=address_district]").val(),
            "address": $("#addressEdit #editAddressForm input[name=address_address]").val(),
            "email": "",
            "zipcode": $("#addressEdit #editAddressForm input[name=address_zipcode]").val(),
            "tel": $("#addressEdit #editAddressForm input[name=address_tel]").val(),
            "mobile": $("#addressEdit #editAddressForm input[name=address_mobile]").val()
        };

        svc.editAddressList(data, function (res) {
            if (res.status == "SUCCESS") {
                hlp.myalert(res.message);

                $.afui.goBack();
            } else {
                hlp.log("svc.editAddressList failed. message:" + res.message);

                hlp.myalert("更新地址失败");
            }
        });
    }
    ;
};

// 设置默认售后地址
function SetAsDefaultAddress() {
    "use strict";

    hlp.log("SetAsDefaultAddress() Called. UserName:" + loj.UserId);

    var addressId = $("#addressEdit #editAddressForm input[name=address_id]").val();

    svc.setDefaultAddress(addressId, loj.UserId, function (res) {
        if (res.status == "SUCCESS") {
            hlp.log(res.message);

            $("#addressEdit form#editAddressForm #SetAsDefaultAddressDiv").css("display", "none");
            $("#addressEdit form#editAddressForm #DelAddressButtonDiv").css("display", "none");

            hlp.myalert("设置默认地址成功");

            // $.afui.goBack();
        } else {
            hlp.log("svc.setDefaultAddress failed. message:" + res.message);

            hlp.myalert("设置默认地址失败");
        }
    });
};

// 编辑收货地址 删除
function DelAddress() {
    "use strict";

    $("#addressEdit div.layOutDel").css({display: "block", opacity: "0"});
    $("#addressEdit div.layOutDel").fadeTo("fast", 1);
};

// 提交评价
// type = 0 首次评价
// type = 1 追加评价
function SubmitEvaluation(type) {
    "use strict";

    hlp.log("Call SubmitEvaluation() type:" + type);

    // "user_id":"15397668177",
    // "order_sn":"15062515444542961695",
    // "goods_sn":"FS360",
    // "comment_rank":"5",
    // "content":"非常好用！",
    // "comment_img":"/sources/goods/A01/A01_big.jpg"

    var getStarCount = function (starJq) {
        var star = 0;
        $(starJq).each(function () {
            if ($(this).attr("class") == "star") {
                star++;
            }
        });

        return star.toString();
    };

    var orderSn;
    var goodSn;
    var commentRank;
    var content;
    var commentId = "";

    // 初始图片的数量
    var imageCount;
    // 上传完成的图片URL Array
    var imageArray;

    // 监听器最大执行次数, 执行周期
    var MAX_TIMER_EXEC_COUNT = 12;
    var PERIOD = 5000;

    // 监听器执行次数
    var timerExeCount;
    // 监听器句柄
    var timerId;

    var uploadFailedFlag = false;

    var imgTags = undefined;

    if (type == "0") {
        if ($("#evaluationSubmitDiv").attr("submitted") == "true") {
            return;
        } else {
            $("#evaluationSubmitDiv").attr("submitted", "true");
        }

        orderSn = $("#evaluationSubmitDiv input#evaluationSubmitOrderSn").val();
        goodSn = $("#evaluationSubmitDiv input#evaluationSubmitGoodSn").val();
        commentRank = getStarCount("#evaluationSubmitDiv div#evaluationSubmit_comment_rank div");
        content = $("#evaluationSubmitDiv textarea#evaluationSubmit_textarea").val();
        if (content.trim().length == 0) {
            hlp.myalert("请输入评论信息");
            $("#evaluationSubmitDiv").attr("submitted", "false");
            return false;
        }
        // 1st step: upload by browser element input:file
        //var file = $("#evaluationSubmitDiv input#evaluationSubmitFileUpload").val();

        //svc.uploadImageFile(loj.UserId, goodInfo.goods_sn, "evaluationSubmitFileUpload", file, function (res) {
        //    hlp.log("Call uploadImageFile:" + res.message);

        //    $("#evaluationSubmit_UploadImage").append("<img src='" + res.image_name + "' style=\"width: 50px; height: 50px\"/>");
        //});

        $.afui.blockUI(0.5);
        $("#waiting").show();

        imageCount = $("#evaluationSubmit div#evaluationSubmit_UploadImage img").length;
        imageArray = [];
        hlp.log("SubmitEvaluation total file. imageCount:" + imageCount);

        imgTags = $("#evaluationSubmit div#evaluationSubmit_UploadImage img");
    } else {
        orderSn = $("#evaluateMoreDiv input#evaluateMoreOrderSn").val();
        goodSn = $("#evaluateMoreDiv input#evaluateMoreGoodSn").val();
        commentRank = getStarCount("#evaluateMoreDiv div#evaluateMore_comment_rank div");
        content = $("#evaluateMoreDiv textarea#evaluateMore_textarea").val();
        if (content.trim().length == 0) {
            hlp.myalert("请输入评论信息");
            return false;
        }
        commentId = $("#evaluateMoreDiv input#evaluateMoreCommentId").val();

        $.afui.blockUI(0.5);
        $("#waiting").show();

        imageCount = $("#evaluateMore div#evaluateMore_UploadImage img").length;
        imageArray = [];
        hlp.log("SubmitEvaluation total file. imageCount:" + imageCount);

        imgTags = $("#evaluateMore div#evaluateMore_UploadImage img");

    }

    //imgTags.each(function (index) {
    //    var file = $(this).attr("src");

    //    hlp.log("SubmitEvaluation uploading file. file:" + file);

    //    svc.uploadPhoto(loj.UserId, goodSn, file, function (res) {
    //        hlp.log("Call uploadPhoto succeed. " + JSON.stringify(res));

    //        hlp.log("Call uploadPhoto res.status:" + res.status + " image_name:" + res.data.image_name);

    //        imageArray.push(res.data.image_name);
    //    }, function (res) {
    //        hlp.log("Call uploadPhoto failed. " + JSON.stringify(res));
    //        uploadFailedFlag = true;
    //    });
    //});

    //if (uploadFailedFlag) {
    //    hlp.myalert("上传图片失败");

    //    $.afui.unblockUI();
    //    $("#waiting").hide();

    //    return;
    //}

    //imgTags.each(function (index) {
    //    var file = $(this).attr("src");

    //    var i = 0;

    //    imageArray.push(file);

    //    hlp.log("SubmitEvaluation collecting file. count:" + i);
    //});

    //timerExeCount = 0;
    //timerId = setInterval(function () {
    //    if (timerExeCount >= MAX_TIMER_EXEC_COUNT) {
    //        hlp.myalert("上传图片超时");

    //        clearInterval(timerId);
    //        $.afui.unblockUI();
    //        $("#waiting").hide();

    //        return;
    //    }
    //    timerExeCount++;

    //    if (imageArray.length < imageCount) {
    //        hlp.log("imageArray.length:" + imageArray.length + " continue waiting...");
    //    } else {
    //        hlp.log("All files uploaded, submitting..., imageArray.length:" + imageArray.length + " imageArray:" + JSON.stringify(imageArray));

    //        clearInterval(timerId);

    //        svc.addComment(loj.UserId, orderSn, goodSn, commentRank, content, type, imageArray, commentId, function (res) {
    //            hlp.log("SubmitEvaluation committed. res.message:" + res.message);

    //            hlp.myalert("发表评价成功");

    //            $.afui.unblockUI();
    //            $("#waiting").hide();

    //            $.afui.goBack();
    //        });
    //    }
    //}, PERIOD);

    imgTags.each(function (index) {
        var file = $(this).attr("src");
        imageArray.push(file);

        hlp.log("SubmitEvaluation collecting file. count:" + imageArray.length);
    });

    if (imageArray.length == 0) {
        imageArray = "";
    }

    svc.addComment(loj.UserId, orderSn, goodSn, commentRank, content, type, imageArray, commentId, function (res) {
        hlp.log("SubmitEvaluation committed.");
        hlp.log("SubmitEvaluation committed. res.message:" + JSON.stringify(res));

        hlp.myalert("发表评价成功");

        $.afui.unblockUI();
        $("#waiting").hide();

        $.afui.goBack();
    });
};

// 初始化地址选择器
// provinceJq： 选择省所用的select标签的jquery选择器字串
// provinceElemId： 选择省所用的select标签的ID
// cityJq： 选择市所用的select标签的jquery选择器字串
// cityElemId： 选择市所用的select标签的ID
// districtJq： 选择市区所用的select标签的jquery选择器字串
// districtElemId： 选择市区所用的select标签的ID
// templateId： 模板标签ID
// addressInfo: addressInfo.province, addressInfo.city, addressInfo.district
function InitAddressSelects(provinceJq, provinceElemId, cityJq, cityElemId, districtJq, districtElemId, templateId, addressInfo) {
    var emptySelection = '<option value="-1"> --请选择--  </option>';

    svc.getRegionList(1, 1, function (res) {
        hlp.bindtpl(res.data, "#" + provinceElemId, templateId);

        if (addressInfo && addressInfo != null && typeof (addressInfo) != "undefined" && addressInfo.province && addressInfo.province != "") {
            $(provinceJq).val(addressInfo.province);

            svc.getRegionList(addressInfo.province, 2, function (res2) {
                hlp.bindtpl(res2.data, "#" + cityElemId, templateId);

                if (addressInfo.city && addressInfo.city != "") {
                    $(cityJq).val(addressInfo.city);
                }

                svc.getRegionList(addressInfo.city, 3, function (res3) {
                    hlp.bindtpl(res3.data, "#" + districtElemId, templateId);

                    if (addressInfo.district && addressInfo.district != "") {
                        $(districtJq).val(addressInfo.district);
                    }
                });
            });
        }

        $(provinceJq).bind("change", function (e) {
            var selectedProvinceValue = $(this).val();
            hlp.log(provinceJq + " change event handled. selected value:" + selectedProvinceValue);

            $(cityJq).empty();
            $(cityJq).append(emptySelection);
            $(districtJq).empty();
            $(districtJq).append(emptySelection);

            $(cityJq).val("-1");
            $(districtJq).val("-1");

            if (selectedProvinceValue == "-1") {
                return;
            }

            svc.getRegionList(selectedProvinceValue, 2, function (res1) {
                hlp.bindtpl(res1.data, "#" + cityElemId, templateId);

                $(cityJq).bind("change", function (e) {
                    var selectedCityValue = $(this).val();
                    hlp.log(cityJq + " change event handled. selected value:" + selectedCityValue);

                    $(districtJq).empty();
                    $(districtJq).append(emptySelection);

                    $(districtJq).val("-1");

                    if (selectedCityValue == "-1") {
                        return;
                    }

                    svc.getRegionList(selectedCityValue, 3, function (res2) {
                        hlp.bindtpl(res2.data, "#" + districtElemId, templateId);
                    });
                });
            });
        });

        $(cityJq).bind("change", function (e) {
            var selectedCityValue = $(this).val();
            hlp.log(cityJq + " change event handled. selected value:" + selectedCityValue);

            $(districtJq).empty();
            $(districtJq).append(emptySelection);

            $(districtJq).val("-1");

            if (selectedCityValue == "-1") {
                return;
            }

            svc.getRegionList(selectedCityValue, 3, function (res2) {
                hlp.bindtpl(res2.data, "#" + districtElemId, templateId);
            });
        });
    });
};

var CommentRankMapping = {
    "1": "差评",
    "2": "不好",
    "3": "一般",
    "4": "满意",
    "5": "非常满意"
};

var ReturnsStatusMapping = {
    "0": "取消",
    "1": "已提交",
    "2": "已受理",
    "3": "已完成"
};

var addressFromVaildOptions = {
    rules: {
        address_consignee: {
            required: true,
            maxlength: 20
        },
        address_province: {
            checkAddressSelectionRequire: true
        },
        address_city: {
            checkAddressSelectionRequire: true
        },
        address_district: {
            checkAddressSelectionRequire: true
        },
        address_address: {
            required: true,
            maxlength: 60,
            minlength: 5,
            regularExpressCheck: /^.*[^\d].*$/
        },
        //address_zipcode: {
        //    digits: true,
        //    maxlength: 6,
        //    minlength: 6
        //},
        address_tel: {
            regularExpressCheckNullable: /^([0-9]{3,4}[-－—])?[0-9]{7,8}$/
        },
        //address_mobile: {
        //    required: true,
        //    digits: true,
        //    maxlength: 11
        //},
        address_zipcode: {
            regularExpressCheckNullable: /^[0-9][0-9]{5}$/
        },
        address_mobile: {
            regularExpressCheck: /^0{0,1}(13[0-9]|15[0-9]|18[0-9]|14[0-9]|17[0-9])[0-9]{8}$/
        }

    },
    onfocusout: false,
    onclick: false,
    messages: {
        address_consignee: {
            required: "请填写姓名",
            maxlength: "姓名请保持在20个字符以内"
        },
        address_province: {
            checkAddressSelectionRequire: "请选择省"
        },
        address_city: {
            checkAddressSelectionRequire: "请选择市"
        },
        address_district: {
            checkAddressSelectionRequire: "请选择市区"
        },
        address_address: {
            required: "请输入详细地址",
            maxlength: "地址内容太长",
            minlength: "地址内容太短",
            regularExpressCheck: "地址不能为纯数字"
        },
        //address_zipcode: {
        //    digits: "邮编请输入数字",
        //    maxlength: "邮编请输入6位数字"
        //},
        address_tel: {
            regularExpressCheckNullable: "请输入正确的电话号码"
        },
        //address_mobile: {
        //    required: "请输入手机号码",
        //    digits: "手机号码请输入数字",
        //    maxlength: "手机号码请输入11位数字"
        //},
        address_zipcode: {
            regularExpressCheckNullable: "邮编请输入6位数字"
        },
        address_mobile: {
            regularExpressCheck: "请输入正确的11位数字作为手机号码"
        }
    }
};

//function OpenMyFavouriteLayOutDel(e) {
//    $(".layOutDel").removeAttr("style");
//    $(".layOutDel").attr("style", "display: blank; -ms-opacity: 0; opacity: 0;");
//    $(".layOutDel").fadeTo("slow", 1);
//};

//用户在登陆的情况下，各个画面的立即购买按钮的迁移处理
var buyNowFunction = function (tokenId) {
    if (tokenId) {
        hlp.log("before call mall.js getDefaultAddress");
        svc.getDefaultAddress(loj.UserId,
            function (getDefaultAddress_res) {
                hlp.log("inside call mall.js getDefaultAddress");
                if (getDefaultAddress_res.status == "SUCCESS") {
                    hlp.log(getDefaultAddress_res.message);
                    $.afui.loadContent("#submitOrder");
                } else {
                    hlp.log(getDefaultAddress_res.message);
                    hlp.log("before call mall.js getAddressList");
                    svc.getAddressList(loj.UserId, function (getAddressList_res) {
                        hlp.log("inside call mall.js getAddressList");
                        if (getAddressList_res.status == "SUCCESS") {
                            hlp.log(getAddressList_res.message);
                            var addressList = getAddressList_res.data;
                            if (addressList.length == 1) {
                                hlp.panelObj["selectAddressId"] = {"address_id": addressList[0].address_id};
                                $.afui.loadContent("#submitOrder");
                            } else {
                                $.afui.loadContent("#addressSelect");
                            }
                        } else {
                            hlp.log(getAddressList_res.message);
                        }
                    });
                }
            });
    } else {
        $.afui.loadContent("#notLoginBuy");
    }
};

//清空购物车
var clearnShoppingCart = function () {
    svc.clearnMyCart("", loj.sessionId, function (r) {
        if (r.status == 'SUCCESS') {
            hlp.log(r.message);
        } else {
            //删除失败
            hlp.myalert(r.message);
        }
    });
};

var mallIndexSwiper;
var myCommoditySwiper;
var goodsDetailSwiper;
var deviceIndexSwiper;
var myPopup = null;
