$(function () {

    $("#mallIndex").on("loadcomplete", function () {
        console.log("show me:mall index...");
        showfooter(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("mallIndex", true);
    });
    $("#mallIndex").on("panelload", function () {
        console.log("show me:mall index...");
        showfooter(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("mallIndex", true);
        $(".mallFooter").show();
        $(".categoryButton").show();
        $(".cartButton").show();
        $(".headSearchIcon").show();
        $("#headSearch").show();
        $(".cartButton").off("tap").on("tap",function(){
            svc.getMyCart(loj.UserId, loj.sessionId,function(r) {
                if (r.status == "SUCCESS") {
                    $.afui.loadContent("#mallMyCart");
                }else{
                    $.afui.loadContent("#mallMyCartNull");
                }
            });
        });
        
        //$("#search_box").width($(window).width()-180).css("display","block");

        //显示右上角的购物车的数字，如果数字为0，则不显示<span id="quantityNewInCart"></span>
        var quantityNewInCart=parseInt(loj.QuantityInCart);
        if(quantityNewInCart==0) {
            $('#mainview .shortCar #quantityNewInCart').css("display","none");
        }
        else {
            $('#mainview .shortCar #quantityNewInCart').text(quantityNewInCart);
        }
    });
    $("#mallIndex").on("panelunload", function () {
        console.log("show me:mall index...");
        showfooter(false);
        $.afui.setBackButtonVisibility(true);
        showSelected("mallIndex", false);
        $(".mallFooter").hide();
        $(".categoryButton").hide();
        $(".cartButton").hide();
        $(".headSearchIcon").hide();
        $("#headSearch").hide();
    });
    $("#main").on("loadcomplete", function () {
        console.log("show me:main...");
        showfooter(true);
        setPlusButton(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("deviceList", true);
    });
    $("#deviceList").on("loadcomplete", function () {
        console.log("show me:deviceList...");
        showfooter(true);
        setPlusButton(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("deviceList", true);

        //this.setBackButtonVisibility(true);
        $(".categoryButton").hide();
        $(".cartButton").hide();
        $(".headSearchIcon").hide();
        $("#headSearch").hide();
    });




    $("#followDeviceList").on("loadcomplete", function () {
        showfooter(true);
        setPlusButton(false);
        $.afui.setBackButtonVisibility(false);
    });
    $("#find").on("loadcomplete", function () {
        showfooter(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("find", true);
    });
    $("#my").on("loadcomplete", function () {
        showfooter(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("my", true);
    });
    //$("#shop").on("loadcomplete", function () {
    //    showfooter(true);
    //    $.afui.setBackButtonVisibility(false);
    //    showSelected("shop", true);
    //});

    // panel load
    $("#main,#deviceList").on("panelload", function () {
        showfooter(true);
        setPlusButton(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("deviceList", true);
    });

    $("#cleanerIndex").on("panelload", function (e) {
        $(".cleanerFooter").show();
        $(".moreButton").show();
    });

    $("#scanQRcode").on("panelload", function () {
        $(".scanFooter").show();
    });

    $("#editDeviceName").on("panelload", function () {
        $(".saveButton").show();
    });

    $("#followDeviceList").on("panelload", function () {
        showfooter(true);
        setPlusButton(false);
        $.afui.setBackButtonVisibility(false);
    });
    $("#find").on("panelload", function () {
        showfooter(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("find", true);
    });
    $("#my").on("panelload", function () {
        showfooter(true);
        $.afui.setBackButtonVisibility(false);
        showSelected("my", true);
    });

    // panel unload
    $("#main,#deviceList").on("panelunload", function () {
        showfooter(false);
        setPlusButton(false);
        $.afui.setBackButtonVisibility(true);
        showSelected("deviceList", false);
    });

    $("#cleanerIndex").on("panelunload", function (e) {
        $(".cleanerFooter").hide();
        $(".moreButton").hide();
    });

    $("#scanQRcode").on("panelunload", function () {
        $(".scanFooter").hide();
    });

    $("#editDeviceName").on("panelunload", function () {
        $(".saveButton").hide();
    });

    $("#followDeviceList").on("panelunload", function () {
        showfooter(false);
        $.afui.setBackButtonVisibility(true);
    });
    $("#find").on("panelunload", function () {
        showfooter(false);
        $.afui.setBackButtonVisibility(true);
        showSelected("find", false);
    });
    $("#my").on("panelunload", function () {
        showfooter(false);
        $.afui.setBackButtonVisibility(true);
        showSelected("my", false);
    });
    $("#shop").on("panelunload", function () {
        showfooter(false);
        $.afui.setBackButtonVisibility(true);
    });

    // add by luyuan for back issue
    //登陆界面
    $("#login").on("panelload", function () {
        $.afui.setBackButtonVisibility(false);
        $(".jumpBackButton").show();
    });
    $("#login").on("panelunload", function () {
        $.afui.setBackButtonVisibility(true);
        $(".jumpBackButton").hide();
    });
    //代付款订单
    $("#unpayedOrder").on("panelload", function () {
        if (loj.payActioned) {
            $.afui.setBackButtonVisibility(false);
            $(".jumpBackButton").show();
        }
    });
    $("#unpayedOrder").on("panelunload", function () {
        if (loj.payActioned) {
            $.afui.setBackButtonVisibility(true);
            $(".jumpBackButton").hide();
            loj.payActioned = false;
        }
    });
    //已付款订单页面
    $("#orderDetail1").on("panelload", function () {
        if (loj.payActioned) {
            $.afui.setBackButtonVisibility(false);
            $(".jumpBackButton").show();
        }
    });
    $("#orderDetail1").on("panelunload", function () {
        if (loj.payActioned) {
            $.afui.setBackButtonVisibility(true);
            $(".jumpBackButton").hide();
            loj.payActioned = false;
        }
    });
    //$("#orderDetail2").on("panelload", function () {
    //    if (loj.orderActioned) {
    //        $.afui.setBackButtonVisibility(false);
    //    }
    //});
    //$("#orderDetail2").on("panelunload", function () {
    //    if (loj.orderActioned) {
    //        $.afui.setBackButtonVisibility(true);
    //        loj.orderActioned = false;
    //    }
    //});
    $("#orderDetail3").on("panelload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(false);
            $(".jumpBackButton").show();
        }
    });
    $("#orderDetail3").on("panelunload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(true);
            $(".jumpBackButton").hide();
            loj.orderActioned = false;
        }
    });
    //已完成订单
    $("#orderDetail4").on("panelload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(false);
            $(".jumpBackButton").show();
        }
    });
    $("#orderDetail4").on("panelunload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(true);
            $(".jumpBackButton").hide();
            loj.orderActioned = false;
        }
    });
    //退货详情
    //$("#returnDetail").on("panelload", function () {
    //    if (loj.orderActioned) {
    //        $.afui.setBackButtonVisibility(false);
    //    }
    //});
    //$("#returnDetail").on("panelunload", function () {
    //    if (loj.orderActioned) {
    //        $.afui.setBackButtonVisibility(true);
    //        loj.orderActioned = false;
    //    }
    //});
    //支付界面
    $("#pay").on("panelload", function () {
        $.afui.setBackButtonVisibility(false);
    });
    $("#pay").on("panelunload", function () {
        $.afui.setBackButtonVisibility(true);
    });
    //退款单
    $("#refundList").on("panelload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(false);
            $(".jumpBackButton").show();
        }
    });
    $("#refundList").on("panelunload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(true);
            $(".jumpBackButton").hide();
            loj.orderActioned = false;
        }
    });
    //退货单
    $("#returnList").on("panelload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(false);
            $(".jumpBackButton").show();
        }
    });
    $("#returnList").on("panelunload", function () {
        if (loj.orderActioned) {
            $.afui.setBackButtonVisibility(true);
            $(".jumpBackButton").hide();
            loj.orderActioned = false;
        }
    });

    // public
    var showfooter = function (bool) {
        if (bool == true)
            $(".mallFooter").show();
        else
            $(".mallFooter").hide();
    };

    // selected icons
    var showSelected = function (objid, bool) {
        $("footer a").removeClass("selected");
        if (bool == true) {
            $("footer a[href=#" + objid + "]").addClass("selected");
        }
        else
            $("footer a[href=#" + objid + "]").removeClass("selected");
    };

    $.afui.ready(function () {
        // show welecome page..

        if (loj.WelecomePage == true) {
            loj.setWelecomePage(false);
            //$.afui.loadContent("#welcome");
            return;
        }

        if (loj.IsLogin == true) {
            // show gestrue password page.
            if (loj.patternPw > 0) {
                $.afui.loadContent("#gesturePWsetting");
                return;
            }
        } else {
            ShowLoginMsg(true);
        }

        $.afui.loadContent("#deviceList");
    });
});