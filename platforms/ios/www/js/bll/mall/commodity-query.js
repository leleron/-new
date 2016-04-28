$(function() {

    $.afui.launch();

    // 商品首页
    $("#mallIndex").on("panelload",
        function(e) {
            var tokenId = loj.Credential;
            setTimeout(function(){
                svc.getuserinfo(tokenId,function(r){
                    if(r.result.BINDED_FLYCO_ACCOUNT){
                        loj.UserId = r.result.BINDED_FLYCO_USERNAME;
                        loj.updateObj();
                    }else{
                        loj.UserId = r.result.USER_NAME;
                        loj.updateObj();
                    }
                });
            },100);
            if (loj.Credential) {
                //RefreahShopCarIcon();
                //$("#mainview .cartButton .shortCar").show();
            }
            if (loj.mailIndexLoaded) {
                if (mallIndexSwiper) {
                    mallIndexSwiper.destroy(true,true);
                }

                mallIndexSwiper = new Swiper('.mallIndexBanner', {
                    initialSlide: 0,
                    autoplay: 5000,
                    loop: true,
                    loopAdditionalSlides: 0,
                    pagination: '.swiper-pagination'
                });
                return;
            }

            //$.afui.blockUI(0.5);
            //$.afui.showMask('加载中');
            $.afui.blockUIwithMask('加载中');

            hlp.log("before call get mall index");
            svc.getMallIndex(function(r) {

                //window.setTimeout(function(){
                //    $.afui.unblockUI();
                //    $.afui.hideMask();
                //}, 100);
                $.afui.unBlockUIwithMask();

                if (r.status == "SUCCESS") {
                    // 轮播图
                    getIndexLoop(r.data.index_loop);
                    // 热卖商品
                    getHotProduct(r.data.index_hot_product);
                    // 特价产品
                    getBargainPriceProduct(r.data.index_dis_product);
                    //明星产品
                    getStarProduct(r.data.index_star_product);
                    //新品上市
                    getNewList(r.data.index_new_product);


                    /*点击首页上每个商品跳转到商品详情页面的事件*/

                    $(".ta").off("tap").on("tap",
                        function() {
                            var goods_sn = $(this).attr("goods_sn");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": goods_sn
                            };
                            $.afui.loadContent("#commodityDetails1");
                        });
                } else {
                    hlp.myalert(r.message);
                }

                loj.mailIndexLoaded = true;
            });

            //搜索商品
            $(".headSearchIcon").off("tap").on("tap", function() {
                if($(".searchGoodsRes").length>0){
                    $(".searchGoodsRes").remove();
                }
                hlp.log("before getGoodsSearch request...");
                var searchKey = $("#headSearch").val().trim();
                if(searchKey.length==0){
                    searchKey=$("#headSearch").attr("placeholder");
                }
                var page=1;

                //初始化搜索商品成功的callback（有数据）
                var initializeGoodsSearchSucceedCallback=function(r){
                    if(r.data.length<30){
                        $("#mallSearchResult .loadingMore").hide();
                    }else{
                        $("#mallSearchResult .loadingMore").show();
                    }
                    hlp.bindtpl(r.data, "#searchResultList", "tpl_searchResultList");
                    //绑定商品的点击事件
                    bindGoodsTap();
                    var catId = r.data[0].cat_id;
                    //获取底部的推荐商品
                    getPersonHots();
                    $.afui.loadContent("#mallSearchResult");
                };
                //初始化搜索商品失败的callback（没数据）
                var initializeGoodsSearchFailedCallback=function(r){
                    //获取底部的推荐商品
                    getPersonHots();
                    //隐藏加载更多按钮
                    $("#mallSearchResult .loadingMore").hide();
                    $("#searchResultList").text(r.message);
                };
                /*点击搜索结果页面上每个商品跳转到商品详情页面的事件*/
                var bindGoodsTap=function(){
                    $(".srl").off("tap").on("tap",
                        function() {
                            var goods_sn = $(this).attr("id");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": goods_sn
                            };

                            $.afui.loadContent("#commodityDetails1");
                        });
                };
                //获取底部的推荐商品
                var getPersonHots=function(){
                    svc.getPersonHots(
                        function(r) {
                            hlp.log("inside getPersonHots request...!!!!!!!!!!!");
                            if (r.status == "SUCCESS") {
                                hlp.bindtpl(r.data, "#searchResultRecommend", "tpl_searchResultRecommend");
                                /*点击搜索结果页面上底部的推荐商品跳转到商品详情页面的事件*/
                                $(".srr").off("tap").on("tap",
                                    function() {
                                        var thisId = $(this).attr("id");
                                        var goods_sn = thisId.substring(3, thisId.length);
                                        hlp.panelObj["commodityDetails"] = {
                                            "sn": goods_sn
                                        };
                                        $.afui.loadContent("#commodityDetails1");
                                    });
                            } else {
                                hlp.myalert(r.message);
                            }
                        });
                };

                //搜索商品
                getGoodsSearchRes(searchKey,page,initializeGoodsSearchSucceedCallback, initializeGoodsSearchFailedCallback);

                //加载更多
                $("#mallSearchResult .loadingMore").off("tap").on("tap",function(){
                    $("#mallSearchResult .waitLoading").css("display","block");
                    page++;
                    //点击加载更多成功
                    var getGoodsSearchSucceedCallback=function(r){
                        if(r.data.length<30){
                            $("#mallSearchResult .loadingMore").hide();
                        }else{
                            $("#mallSearchResult .loadingMore").show();
                        }
                        var uiId="searchResultList"+page;
                        $("#mallSearchResult .searchList").append("<ul id='"+uiId+"' class='searchGoodsRes'></ul>");
                        hlp.bindtpl(r.data, "#"+uiId, "tpl_searchResultList");
                        //绑定商品的点击事件
                        bindGoodsTap();
                        var catId = r.data[0].cat_id;
                        $("#mallSearchResult .waitLoading").css("display","none");
                    };
                    //点击加载更多失败
                    var getGoodsSearchFailedCallback=function(r){
                        hlp.myalert(r.message);
                        $("#mallSearchResult .waitLoading").css("display","none");
                    };
                    //搜索商品加载更多
                    getGoodsSearchRes(searchKey,page,getGoodsSearchSucceedCallback, getGoodsSearchFailedCallback);
                    //$("#slideThreeComment").append("<ul class='CommentUl' style='display:none'></ul>");
                    //$(".CommentUl").remove("CommentUl").addClass(ulClass);
                });
            });
        });

    //搜索商品
    $("#mallSearchResult").on("panelunload", function(e) {
        if($(".searchGoodsRes").length>0){
            $(".searchGoodsRes").remove();
        }
    });
    $("#mallCategory").on("panelload",function(e){
        setTimeout(function(){
            $("#cateSearchIcon").on("tap", function() {
                if($(".searchGoodsRes").length>0){
                    $(".searchGoodsRes").remove();
                }
                hlp.log("before getGoodsSearch request...");
                var searchKey = $("#search_box").val().trim();
                if(searchKey.length==0){
                    searchKey=$("#search_box").attr("placeholder");
                }
                var page=1;

                //初始化搜索商品成功的callback（有数据）
                var initializeGoodsSearchSucceedCallback=function(r){
                    if(r.data.length<30){
                        $("#mallSearchResult .loadingMore").hide();
                    }else{
                        $("#mallSearchResult .loadingMore").show();
                    }
                    hlp.bindtpl(r.data, "#searchResultList", "tpl_searchResultList");
                    //绑定商品的点击事件
                    bindGoodsTap();
                    var catId = r.data[0].cat_id;
                    //获取底部的推荐商品
                    getPersonHots();
                    $.afui.loadContent("#mallSearchResult");
                };
                //初始化搜索商品失败的callback（没数据）
                var initializeGoodsSearchFailedCallback=function(r){
                    //获取底部的推荐商品
                    getPersonHots();
                    //隐藏加载更多按钮
                    $("#mallSearchResult .loadingMore").hide();
                    $("#searchResultList").text(r.message);
                };
                /*点击搜索结果页面上每个商品跳转到商品详情页面的事件*/
                var bindGoodsTap=function(){
                    $(".srl").off("tap").on("tap",
                        function() {
                            var goods_sn = $(this).attr("id");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": goods_sn
                            };

                            $.afui.loadContent("#commodityDetails1");
                        });
                };
                //获取底部的推荐商品
                var getPersonHots=function(){
                    svc.getPersonHots(
                        function(r) {
                            hlp.log("inside getPersonHots request...!!!!!!!!!!!");
                            if (r.status == "SUCCESS") {
                                hlp.bindtpl(r.data, "#searchResultRecommend", "tpl_searchResultRecommend");
                                /*点击搜索结果页面上底部的推荐商品跳转到商品详情页面的事件*/
                                $(".srr").off("tap").on("tap",
                                    function() {
                                        var thisId = $(this).attr("id");
                                        var goods_sn = thisId.substring(3, thisId.length);
                                        hlp.panelObj["commodityDetails"] = {
                                            "sn": goods_sn
                                        };
                                        $.afui.loadContent("#commodityDetails1");
                                    });
                            } else {
                                hlp.myalert(r.message);
                            }
                        });
                };

                //搜索商品
                getGoodsSearchRes(searchKey,page,initializeGoodsSearchSucceedCallback, initializeGoodsSearchFailedCallback);

                //加载更多
                $("#mallSearchResult .loadingMore").off("tap").on("tap",function(){
                    $("#mallSearchResult .waitLoading").css("display","block");
                    page++;
                    //点击加载更多成功
                    var getGoodsSearchSucceedCallback=function(r){
                        if(r.data.length<30){
                            $("#mallSearchResult .loadingMore").hide();
                        }else{
                            $("#mallSearchResult .loadingMore").show();
                        }
                        var uiId="searchResultList"+page;
                        $("#mallSearchResult .searchList").append("<ul id='"+uiId+"' class='searchGoodsRes'></ul>");
                        hlp.bindtpl(r.data, "#"+uiId, "tpl_searchResultList");
                        //绑定商品的点击事件
                        bindGoodsTap();
                        var catId = r.data[0].cat_id;
                        $("#mallSearchResult .waitLoading").css("display","none");
                    };
                    //点击加载更多失败
                    var getGoodsSearchFailedCallback=function(r){
                        hlp.myalert(r.message);
                        $("#mallSearchResult .waitLoading").css("display","none");
                    };
                    //搜索商品加载更多
                    getGoodsSearchRes(searchKey,page,getGoodsSearchSucceedCallback, getGoodsSearchFailedCallback);
                    //$("#slideThreeComment").append("<ul class='CommentUl' style='display:none'></ul>");
                    //$(".CommentUl").remove("CommentUl").addClass(ulClass);
                });
            });
        },100);
    });
    // 团购
    $("#groupon").on("panelload",
        function(e) {
            buyPromoGoodsCount=1;
            hlp.log("before call get group shopping");
            svc.groupShopping(function(r) {
                if (r.status == "SUCCESS") {
                    //$.each(r.data,
                    //    function(index) {
                    //        r.data[index].goods_thumb = r.data[index].goods_thumb;
                    //    });
                    hlp.bindtpl(r.data, "#tuanInfo", "tpl_groupshopping");
                    $("#groupon .ad_img")[0].innerHTML = r.data.ad_img;
                    $(".groupImg img").off("tap").on("tap",
                        function() {
                            var id = $(this).attr("id");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": id
                            };
                            $.afui.loadContent("#commodityDetails1");
                        });
                    $(".tuanBtn").off("tap").on("tap",
                        function() {
                            var sn = $(this).attr("sn");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": sn
                            };
                            $.afui.loadContent("#commodityDetails1");
                        });
                        //function() {
                        //    buyPromoGoodsCount=1;
                        //    var goodSn = $(this).attr("sn");
                        //    var sku_sn = $(this).attr("sku_sn");
                        //    myPopup=$.afui.popup({
                        //        title: " ",
                        //        message:
                        //        '购买件数: <a id="minus" onclick="promoMinusCount(tuanGouCount);">-</a>'+
                        //        '<input id="tuanGouCount" type="text" value="1"/>'+
                        //        '<a id="plus" onclick="promoPlusCount(tuanGouCount)">+</a>'+
                        //        '<p id="tuanGouCountMsg"></p>',
                        //        cancelText: "取&nbsp;&nbsp;消",
                        //        doneText: "确&nbsp;&nbsp;定",
                        //        cancelCallback: function () {
                        //            myPopup=null;
                        //            return;
                        //        },
                        //        doneCallback: function () {
                        //            var count=$("#tuanGouCount").val();
                        //            if(count.trim().length==0){
                        //                myPopup=null;
                        //                return;
                        //            }else{
                        //                if (loj.CredentialStatus == "inactive") {
                        //                    $.afui.loadContent("#login");
                        //                }else{
                        //                    hlp.panelObj["buyNowGoods"] = {
                        //                        "good": [{
                        //                            "sku_sn": sku_sn,
                        //                            "sn": goodSn,
                        //                            "num": count
                        //                        }],
                        //                        "isCart": "0"
                        //                    };
                        //                    if (loj.Credential) {
                        //                        buyNowFunction(loj.Credential);
                        //                    } else {
                        //                        $.afui.loadContent("#notLoginBuy");
                        //                    }
                        //                }
                        //            }
                        //            myPopup=null;
                        //        },
                        //        cancelOnly:false
                        //    });
                        //    //输入框事件
                        //    $("#tuanGouCount").off("input").on("input", function () {
                        //        var quantity=$("#tuanGouCount").val();
                        //        var numCheck = new RegExp(/^[1-9]*[1-9][0-9]*$/);
                        //        if(quantity.trim().length==0){
                        //            return;
                        //        }else if(numCheck.test(quantity)){
                        //            $("#tuanGouCountMsg").text("");
                        //        }else{
                        //            $("#tuanGouCountMsg").text("件数必须为正整数！");
                        //            $("#tuanGouCount").val("");
                        //            return;
                        //        }
                        //    });
                        //});
                } else {
                    hlp.myalert(r.message);
                }
            });
        });


    //商品分类
    $("#mallCategory").on("panelload",
        function(e) {
            if (loj.mallCategoryLoaded) {
                return;
            }
            hlp.log("before get goodsCategory request...");
            svc.getGoodsCategory(function(r) {
                if (r.status == "SUCCESS") {
                    hlp.bindtpl(r.data, "#goodsCategory", "tpl_goodsCategory");

                    /*商品分类页面，每个商品类型的点击跳到商品列表的页面
                    * 接口数据cat_id字段用于判断商品类型*/
                    $("li[id^='cat']").off("tap").on("tap",
                        function() {
                            var thisId = $(this).attr("id");
                            var catId = thisId.substring(3, thisId.length);
                            /*根据不同的商品类型，有不同的title*/
                            var title = $(this).find("p")[0].innerHTML.trim();
                            hlp.panelObj["catId"] = {
                                "catId": catId
                            };
                            /*listByKey:判断商品列表的排序方式
                            * 1：按销售数量， 2：按上架时间，3：按商品价格，4：按商品人气
                            * 默认按销量排序*/
                            listByKey = "1";

                            hlp.log("before get goodsList request...");
                            //获取商品列表
                            svc.getGoodsList(catId, listByKey,
                                function(r) {
                                    if (r.status == "SUCCESS") {
                                        /*商品销量处理，超过一万以万为单位*/
                                        $.each(r.data,function(index){
                                            if(Number(r.data[index].month_number) > 10000 ){
                                                var currentSalesNumber1 = parseInt(r.data[index].month_number/10000);
                                                var currentSalesNumber2 = parseInt(r.data[index].month_number%10000/1000);
                                                r.data[index].month_number = currentSalesNumber1+"."+currentSalesNumber2+"万";
                                            }
                                        });
                                        /*商品列表的bind*/
                                        hlp.bindtpl(r.data, "#goodsList", "tpl_goodsList");
                                        /*商品列表每个商品点击跳转到商品详情页面*/
                                        $(".gl").off("tap").on("tap",
                                            function() {
                                                var goods_sn = $(this).attr("id");
                                                hlp.panelObj["commodityDetails"] = {
                                                    "sn": goods_sn
                                                };
                                                $.afui.loadContent("#commodityDetails1");
                                            });

                                    } else {
                                        hlp.myalert(r.message);
                                    }
                                });

                            hlp.log("before getPersonHots request...");
                            /*获取推荐商品*/
                            svc.getPersonHots(
                                function(r) {
                                    hlp.log("inside getPersonHots request...");
                                    if (r.status == "SUCCESS") {
                                        /*recommendGoods是02-01-04_mallList.html页面的推荐商品*/
                                        hlp.bindtpl(r.data, "#recommendGoods", "tpl_recommendGoods");
                                        /*recommendCommodity是02-10-01_commodityDetails1.html页面的推荐商品*/
                                        hlp.bindtpl(r.data, "#recommendCommodity", "tpl_recommendCommodity");
                                        /*02-01-04_mallList.html页面底部的推荐商品点击跳转到商品详情*/
                                        $(".mlr").off("tap").on("tap",
                                            function() {
                                                var thisId = $(this).attr("id");
                                                var goods_sn = thisId.substring(3, thisId.length);
                                                hlp.panelObj["commodityDetails"] = {
                                                    "sn": goods_sn
                                                };
                                                cleanCommodityDetailPage();
                                                $.afui.loadContent("#commodityDetails1");
                                            });
                                    } else {
                                        hlp.myalert(r.message);
                                    }
                                });
                            /*显示不同的title*/
                            $("#mallList").attr("data-title",title);
                            $.afui.loadContent("#mallList");
                        });

                } else {
                    hlp.myalert(r.message);
                }
            });

            loj.mallCategoryLoaded = true;

        });

    $("#mallList").on("panelload", function () {
        /*默认显示网格布局*/
        $(".listMenu").attr("src","images/icons-png/grid-show.png");
        $("#goodsListDiv").attr("class","list1");
        /*默认显示销量*/
        switch (listByKey) {
            case "1":
                listByKey = "1";
                $(".listTitle a").removeClass("cur");
                $("#listBySales").addClass("cur");
                break;

            case "2":
                listByKey = "2";
                $(".listTitle a").removeClass("cur");
                $("#listByNew").addClass("cur");
                break;

            case "3":
                listByKey = "3";
                $(".listTitle a").removeClass("cur");
                $("#listByPrice").addClass("cur");
                break;

            case "4":
                listByKey = "4";
                $(".listTitle a").removeClass("cur");
                $("#listByPopular").addClass("cur");
                break;

            default:
                break;
        }
    });

    //新品
    $("#newProduct").on("panelload",
        function() {
            buyPromoGoodsCount=1;
            hlp.log("before get new Product request...");
            //获取新品列表
            svc.getNewProduct(function(r) {
                hlp.log("inside getNewProduct request...");
                if (r.status == "SUCCESS") {
                    hlp.bindtpl(r.data, "#newProductInfo", "tpl_newProductInfo");
                    $("#newProductBannerList")[0].innerHTML = $(r.data.ad_img)[0].innerHTML;
                    $(".NewProductImg img").off("tap").on("tap",
                        function() {
                            var id = $(this).attr("class");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": id
                            };
                            $.afui.loadContent("#commodityDetails1");
                        });
                    $("#newProduct .blueBtn").off("tap").on("tap",
                        function() {
                            var sn = $(this).attr("sn");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": sn
                            };
                            $.afui.loadContent("#commodityDetails1");
                        });
                        //function() {
                        //    buyPromoGoodsCount=1;
                        //    var goodSn = $(this).attr("sn");
                        //    var sku_sn = $(this).attr("sku_sn");
                        //    myPopup=$.afui.popup({
                        //        title: " ",
                        //        message:
                        //        '购买件数: <a id="minus" onclick="promoMinusCount(newProductCount);">-</a>'+
                        //        '<input id="newProductCount" type="text" value="1"/>'+
                        //        '<a id="plus" onclick="promoPlusCount(newProductCount)">+</a>'+
                        //        '<p id="newProductCountMsg"></p>',
                        //        cancelText: "取&nbsp;&nbsp;消",
                        //        doneText: "确&nbsp;&nbsp;定",
                        //        cancelCallback: function () {
                        //            myPopup=null;
                        //            return;
                        //        },
                        //        doneCallback: function () {
                        //            var count=$("#newProductCount").val();
                        //            if(count.trim().length==0){
                        //                myPopup=null;
                        //                return;
                        //            }else{
                        //                if (loj.CredentialStatus == "inactive") {
                        //                    $.afui.loadContent("#login");
                        //                }else{
                        //                    hlp.panelObj["buyNowGoods"] = {
                        //                        "good": [{
                        //                            "sku_sn": sku_sn,
                        //                            "sn": goodSn,
                        //                            "num": count
                        //                        }],
                        //                        "isCart": "0"
                        //                    };
                        //                    if (null != loj.Credential) {
                        //                        buyNowFunction(loj.Credential);
                        //                    } else {
                        //                        $.afui.loadContent("#notLoginBuy");
                        //                    }
                        //                }
                        //            }
                        //            myPopup=null;
                        //        },
                        //        cancelOnly:false
                        //    });
                        //    //输入框事件
                        //    $("#newProductCount").off("input").on("input", function () {
                        //        var quantity=$("#newProductCount").val();
                        //        var numCheck = new RegExp(/^[1-9]*[1-9][0-9]*$/);
                        //        if(quantity.trim().length==0){
                        //            return;
                        //        }else if(numCheck.test(quantity)){
                        //            $("#newProductCountMsg").text("");
                        //        }else{
                        //            $("#newProductCountMsg").text("件数必须为正整数！");
                        //            $("#newProductCount").val("");
                        //            return;
                        //        }
                        //    });
                        //});
                } else {
                    hlp.myalert(r.message);
                }
            });

        });

    //秒杀
    $("#secKill").on("panelload",
        function() {

            //$.afui.blockUI(0.5);
            //$.afui.showMask('加载中');
            $.afui.blockUIwithMask('加载中');
            hlp.log("before get secKill Product request...");
            //获取秒杀商品列表
            svc.getSecKill(function(r) {
                hlp.log("inside getSecKill request...");
                //window.setTimeout(function(){
                //    $.afui.unblockUI();
                //    $.afui.hideMask();
                //}, 100);
                $.afui.unBlockUIwithMask();
                if (r.status == "SUCCESS") {
                    // 绑定数据 把秒杀的时间绑定进去
                    hlp.bindtpl(r.data, "#secKillProInfo", "tpl_secKillProInfo");
                    /*调用处理每个秒杀商品的开始时间和结束时间方法*/
                    setMsFlg();
                    var setNextPageTimerFunc = function(parentDiv) {
                        var timerId = parentDiv.attr("timerId");
                        var testEndTime = parentDiv.find("input.promoEndTime").val().replace(/-/ig, '/');
                        var promoBeginTime = parentDiv.find("input.promoBeginTime").val().replace(/-/ig, '/');

                        var newId = undefined;
                        if (timerId) {
                            clearInterval(timerId);

                            newId = StartCountDown(new Date(promoBeginTime).getTime(),
                                function(remainTime) {
                                    $("#detailSecKill").html("剩 "+remainTime.string+" 开始");
                                });
                        } else {
                            newId = StartCountDown(new Date(testEndTime).getTime(),
                                function(remainTime) {
                                    if(remainTime.string != "end"){
                                        $("#detailSecKill").html("剩 "+remainTime.string+" 结束");
                                    }
                                });
                        }

                        $("input#detailSecKillTimerId").attr("timerId", newId);
                    };

                    $("#secKillBannerList").empty().append(r.data.ad_img);

                    $(".SecKillImg img").off("tap").on("tap",
                        function() {
                            var id = $(this).attr("class");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": id
                            };

                            setNextPageTimerFunc($(this).parents("div.secKillPro"));
                            $.afui.loadContent("#commodityDetails1");
                        });

                    $(".secBtn").off("tap").on("tap",
                        function() {
                            var sn = $(this).attr("sn");
                            hlp.panelObj["commodityDetails"] = {
                                "sn": sn
                            };

                            setNextPageTimerFunc($(this).parents("div.secKillPro"));
                            $.afui.loadContent("#commodityDetails1");
                        });

                } else {
                    hlp.myalert(r.message);
                }
            });

        });

    $("#secKill").on("panelunload",
        function() {
            $("#secKillProInfo .secKillPro").each(function(i) {
                var timerId = $(this).attr("timerId");

                if (timerId) {
                    clearInterval(timerId);
                    $(this).attr("timerId", null);
                }
            });
        });

    //商品详情
    $("#commodityDetails1").on("panelload",
        function () {
            //$.afui.blockUI(0.5);
            //$.afui.showMask('加载中');
            $.afui.blockUIwithMask('加载中');

            $(".cartButton").show();
            $(".showMallButton").show();
            $(".headSearchIcon").hide();
            $("#headSearch").hide();

            //置顶图标的显示与隐藏
            var goToTopDisplayFg = false;
            $("div#goodsDetail div.swiper-wrapper div").scroll(function () {
                if ($(this).scrollTop() > 100) {
                    if (!goToTopDisplayFg) {
                        goToTopDisplayFg = true;
                        $("#back-to-top").show();
                    }
                } else {
                    if (goToTopDisplayFg) {
                        goToTopDisplayFg = false;
                        $("#back-to-top").hide();
                    }
                }
            });

            //当点击置顶图标后，回到页面顶部位置
            $("#back-to-top").off("tap").on("tap", function () {
                // $("#commodityDetails1").animate({scrollTop: 0},500);
                $("div#goodsDetail div.swiper-wrapper div").animate({ scrollTop: 0 }, 500);

                return false;
            });

            //点击客户图标跳转到53客服页面
            $("#go-to-chat").off("tap").on("tap",function(){
                if(loj.CredentialStatus=="active"){
                                           showKefu(function(){},function(){})
//                    cordova.exec(function(){}, function(){}, "InAppBrowser", "open", ['http://kf2.flyco.net.cn/new/client.php?m=Mobile&arg=admin&tokenId='+loj.Credential, '_blank', 'location=no']);
                    /*ref.addEventListener('exit', function () { $.afui.goBack(); });*/
                }else {
                    showLoginController1();
                }
            });

            //详情页面小swiper
            if(myCommoditySwiper){
                myCommoditySwiper.destroy(true,true);
                myCommoditySwiper = null;
            }
            if(goodsDetailSwiper){
                goodsDetailSwiper.destroy(true,true);
                goodsDetailSwiper = null;
            }

            myCommoditySwiper = new Swiper('#CommodityBanner', {
                initialSlide :0,
                pagination: '.swiper-pagination',
                observer:true,//修改swiper自己或子元素时，自动初始化swiper
                observeParents:true, //修改swiper的父元素时，自动初始化swiper
                onTouchEnd: function(swiper, event){
                    if(myCommoditySwiper && myCommoditySwiper.isEnd) {
                        if ((myCommoditySwiper.activeIndex == (myCommoditySwiper.previousIndex+1))
                            || (myCommoditySwiper.activeIndex == myCommoditySwiper.previousIndex)) {
                            goodsDetailSwiper.slideTo(1);
                            $("#headerParameter").removeClass("cur");
                            $("#headerDetail").addClass("cur");
                        }
                    }
                }

            });

            //详情页面大swiper
            goodsDetailSwiper = new Swiper('#goodsDetail', {
                initialSlide :0,
                onSlideChangeStart: function(swiper) {
                    var activeIndex = goodsDetailSwiper.activeIndex;
                    //outside swiper 翻页时，顶部参数、详情、评价的切换
                    if (activeIndex == "0") {
                        $("#headerParameter").addClass("cur");
                    } else {
                        $("#headerParameter").removeClass("cur");
                    }
                    if (activeIndex == "1") {
                        $("#headerDetail").addClass("cur");
                    } else {
                        $("#headerDetail").removeClass("cur");
                    }
                    if (activeIndex == "2") {
                        $("#headerComment").addClass("cur");
                    } else {
                        $("#headerComment").removeClass("cur");
                    }

                    // Bug 699 not a perfect solution:
                    // $("div#goodsDetail div.swiper-wrapper div").animate({ scrollTop: 0 }, 500);
                    //$("#commodityDetails1").animate({ scrollTop: 0 }, 500);
                }
            });

            // fix bug on coolpad mobile
            if (goodsDetailSwiper.activeIndex > 0) {
                goodsDetailSwiper.slideTo(0);
            }
            //参数、详情、评价的点击事件
            $("#detailTab span").off("tap").on("tap",function(e){
                e.preventDefault();
                switch ($(this).attr("id")){
                    case "headerParameter":
                        goodsDetailSwiper.slideTo(0);
                        break;
                    case "headerDetail":
                        goodsDetailSwiper.slideTo(1);
                        break;
                    case "headerComment":
                        goodsDetailSwiper.slideTo(2);
                        break;
                    default :
                        break;
                }
            });

            hlp.log("before getGoodsDetail request ...");
            var goods_sn = hlp.panelObj["commodityDetails"].sn;

            //获取商品详情
            var user_id = loj.UserId;
            if (goods_sn) {
                svc.getGoodsDetail(goods_sn, user_id,
                    function(r) {
                        hlp.log("inside getGoodsDetail request...");
                        if (r.status == "SUCCESS") {
                            hlp.log("inside getGoodsDetail request...");
                            //详情页轮播图
                            hlp.bindtpl(r.data.galleries, "#CommodityBannerSwiper", "tpl_CommodityBannerSwiper");
                            //详情页轮播图底部内容
                            hlp.bindtpl(r.data, "#prodetails_dataPro", "tpl_prodetails_dataPro");
                            hlp.panelObj["cat_id"] = {
                                "cat_id": r.data.cat_id,
                                "comment_enable": r.data.comment_enable
                            };
                            var goods_desc = $(r.data.goods_desc);
                            var goodsDescLength = goods_desc.length;
                            if(goodsDescLength){
                                var goodsDescIndex = goodsDescLength - 1;
                                $(".productParameter")[0].innerHTML = goods_desc.eq(goodsDescIndex)[0].innerHTML;
                                $(".title_top").hide();
                            }else {
                                $(".productParameter")[0].innerHTML = "";
                                $(".title_top").hide();
                            }
                            //当图都加载完成后隐藏图标
                            unBlockCommodityPannel();
                            //window.setTimeout(function(){
                            //	$.afui.unblockUI();
                            //	$.afui.hideMask();
                            //},1000);

                            //针对Tab商品详情的图片进行延迟加载
                            var innerHTMLvar=goods_desc.eq(0)[0].innerHTML;
                            $("#goodsIntroduction")[0].innerHTML = innerHTMLvar;
                            $("#slideTwoDetail")[0].innerHTML = innerHTMLvar;
                            //按照如下格式对图片进行修改,其中url和background会在指定样式中修改
                            //<img class="scrollLoading" data-url="image/mm/00_00.jpg" src="image/pixel.gif" width="630" height="420" style="background:url(image/loading.gif) no-repeat center;" />
                            //此时只对div#slideTwoDetail的图片进行设置延迟加载

//                            $("#slideTwoDetail img").each(function(){
//                                $(this).attr("data-url",$(this).attr("src"));
//                                $(this).addClass("scrollLoading");
//                                $(this).attr("src","images/pixel.gif");
//                            });
                            //图片延迟 加载
//                            $(".scrollLoading").scrollLoading();



                            hlp.panelObj["purchaseQuantity"] = {
                                "inventory": r.data.inventory
                            };
                            var collectFlag = r.data.collect_flag;
                            var user_id = loj.UserId;
                            if (collectFlag == "0") {
                                $("#favoriteFlag").parent().attr("class", "notfav");
                                $("#favoriteFlag").text("收藏");
                            } else {
                                $("#favoriteFlag").parent().attr("class", "fav");
                                $("#favoriteFlag").text("已收藏");
                            }

                            /*收藏功能*/
                            $("#doFav").off("tap").on("tap", function() {
                                doFavorite(user_id,goods_sn);
                            });

                            var sku_sn = $(".sku_sn").val();

                            $("#purchaseQuantity").off("input").on("input",function(){
                                var numCheck = new RegExp(/^[1-9]*[1-9][0-9]*$/);
                                var purchaseQuantity = $("#purchaseQuantity").val();
                                if(purchaseQuantity.trim().length == 0 ){
                                    $("#purchaseQuantity").val("");
                                    return;
                                }else if(numCheck.test(purchaseQuantity) == false){
                                    hlp.myalert("件数必须为正整数");
                                    $("#purchaseQuantity").val("1");
                                }
                            });

                            //立即购买按钮事件
                            $("#commodityDetails1_buyNow").off("tap").on("tap",
                                function() {
                                    if (loj.CredentialStatus == "inactive") {
                                        showLoginController(function(result){},function(result){});
                                    }else{
                                        //判断是否已下架
                                        if (r.data.is_on_sell != "1") {
                                            hlp.myalert("该商品已下架，不能购买");
                                            return;
                                        }

                                        var tokenId = loj.Credential;
                                        var num = $("#purchaseQuantity").val();

                                        // Bug 699
                                        if (num <= 0) {
                                            hlp.myalert("购买的商品数量不能小于1");
                                            return;
                                        }

                                        if (num > parseInt(r.data.inventory)) {
                                            hlp.myalert("亲，该宝贝不能购买比库存更多的数量！");
                                            return;
                                        }

                                        hlp.panelObj["buyNowGoods"] = {
                                            "good": [{
                                                "sku_sn": sku_sn,
                                                "sn": goods_sn,
                                                "num": num
                                            }],
                                            "isCart": "0"
                                        };
                                        if (tokenId) {
                                            buyNowFunction(tokenId);
                                        } else {
                                            showLoginController(function(result){},function(result){});
                                        }
                                    }
                                });

                            //加入购物车事件
                            $('#addToMyCartBtn').off('tap').on('tap',
                                function() {
                                    if (loj.CredentialStatus == "inactive") {
                                        showLoginController1();
                                    }else{
                                        //判断是否已下架
                                        if (r.data.is_on_sell != "1") {
                                            hlp.myalert("该商品已下架，不能加入购物车。");
                                            return;
                                        }

                                        //此时调用加入商品到购物车的接口
                                        //单价及数量
                                        var sku_sn = $(".sku_sn").val();
                                        var quantity = $('.prodetails input#purchaseQuantity').val().trim();

                                        // Bug 699
                                        if (quantity.length == 0) {
                                            hlp.myalert("购买的商品数量不能小于1");
                                            return;
                                        }
                                        quantity=parseInt(quantity);
                                        if ( quantity> parseInt(r.data.inventory)) {
                                            hlp.myalert("亲，该宝贝不能购买比库存更多的数量！");
                                            return;
                                        }

                                        if(loj.Credential){
                                            //调用接口
                                            svc.addToMyCart(loj.UserId, sku_sn, quantity,"",
                                                function(r) {
                                                    //R为返回结果
                                                    if (r.status == 'SUCCESS') {
                                                        //刷新右上角的购物车的图标数字
                                                        var quantityNewInCart = parseInt(loj.QuantityInCart);
                                                        quantityNewInCart = quantityNewInCart + quantity;
                                                        loj.QuantityInCart = quantityNewInCart;
                                                        $('#mainview .shortCar #quantityNewInCart').text(quantityNewInCart);
                                                        $('#mainview .shortCar #quantityNewInCart').css('display', 'block');
                                                        hlp.myalert('已添加到购物车');
                                                    } else {
                                                        hlp.myalert(r.message);
                                                    }
                                                },
                                                function(message) {
                                                    hlp.myalert('调用接口-增加商品到购物车失败');

                                                });

                                        }else{
                                            if(!loj.sessionId){
                                                var sessionId=randomWord(26);
                                                loj.setSessionId(sessionId);
                                            }
                                            svc.addToMyCart("", sku_sn, quantity,loj.sessionId,
                                                function(r) {
                                                    //R为返回结果
                                                    if (r.status == 'SUCCESS') {
                                                        //刷新右上角的购物车的图标数字
                                                        var quantityNewInCart = parseInt(loj.QuantityInCart);
                                                        quantityNewInCart = quantityNewInCart + quantity;
                                                        loj.QuantityInCart = quantityNewInCart;
                                                        $('#mainview .shortCar #quantityNewInCart').text(quantityNewInCart);
                                                        $('#mainview .shortCar #quantityNewInCart').css('display', 'block');
                                                        hlp.myalert('已添加到购物车');
                                                    } else {
                                                        hlp.myalert(r.message);
                                                    }
                                                },
                                                function(message) {
                                                    hlp.myalert('调用接口-增加商品到购物车失败');

                                                });
                                        }
                                    }
                                });

                            //判断是否是手机专享
                            if (r.data.app_price == null || r.data.app_price == '0.00') {
                                $("#mobileExclusive").css("display", "none");
                            } else {
                                $("#mobileExclusive").css("display", "inline-block");
                            }

                            //判断该商品是否有活动
                            getExtensionCode(r);

                            //如果该商品有promo_begin和promo_end说明商品在搞秒杀活动
                            if(r.data.promo_begin || r.data.promo_end){
                                var beginTime = convertDataTime(r.data.promo_begin);
                                var endTime = convertDataTime(r.data.promo_end);
                                var curTime = convertDataTime(currentTime());

                                var testBeginTime = r.data.promo_begin.replace(/-/ig, '/');
                                var testEndTime = r.data.promo_end.replace(/-/ig, '/');

                                if (curTime >= beginTime && curTime < endTime) {
                                    //秒杀正在进行中
                                    StartCountDown(new Date(testEndTime).getTime(),
                                        function(remainTime) {
                                            $("#detailSecKill").html("剩 "+remainTime.string+" 结束");
                                        });

                                } else if (curTime < beginTime) {
                                    //秒杀未开始
                                    StartCountDown(new Date(testBeginTime).getTime(),
                                        function(remainTime) {
                                            $("#detailSecKill").html("剩 "+remainTime.string+" 开始");
                                        });
                                }
                            };

                            var catId = hlp.panelObj["cat_id"].cat_id;
                            //商品详情页面获取推荐商品
                            svc.getPersonHots(
                                function(r) {
                                    hlp.log("inside getPersonHots request...");
                                    if (r.status == "SUCCESS") {
                                        hlp.bindtpl(r.data, "#recommendCommodity", "tpl_recommendCommodity");
                                        $("#recommendCommodity a").off("tap").on("tap", function() {
                                            var goods_sn = $(this).attr("goods_sn");
                                            hlp.panelObj["commodityDetails"] = {
                                                "sn": goods_sn
                                            };
                                            cleanCommodityDetailPage();
                                            $.afui.loadContent("#commodityDetails1");

                                            $("div#goodsDetail div.swiper-wrapper div").animate({ scrollTop: 0 }, 500);
                                            //$("#commodityDetails1").animate({scrollTop: 0},500);
                                            return false;
                                        });
                                    } else {
                                        hlp.myalert(r.message);
                                    }
                                });

                            // 默认选择参数
                            goodsDetailSwiper.slideTo(0);
                        } else {
                            hlp.myalert(r.message);
                        }
                    });
            } else {
                hlp.myalert("sn为空");
            }

            //获取商品评论
            hlp.panelObj["commentPage"] = {
                "page": 1
            };
            var page = hlp.panelObj["commentPage"].page;
            var loadMoreFlag = false;
            getComment(goods_sn,page,loadMoreFlag);

            //加载更多评论
            /*loadMoreFlag用于区别“加载更多评论”按钮和商品详情页面load时候加载评论
             * 每当点击商品详情页面，参数Slide和评价Slide的“加载更多评论”按钮，loadMoreFlag都标识为true
             * loadMoreType用于区别参数Slide和评价Slide的"加载更多评论"按钮
             * loadMoreType==one：表示参数Slide里面的"加载更多评论"
             * loadMoreType==two:表示评价Slide里面的“加载更多评论”*/
            $("#commodityDetails1 .loadMore").off("tap").on("tap",function(){
                $("#commodityDetails1 .waitLoading").css("display","block");
                var page = hlp.panelObj["commentPage"].page + 1;
                var loadMoreFlag = true;
                hlp.panelObj["loadMoreType"] = {
                    "loadMoreType": "one"
                };
                hlp.panelObj["commentPage"] = {
                    "page": page
                };
                /*append一个空的ul，用于存放新加载的评价数据*/
                $("#goodsComment").append("<ul class='CommentUl' style='display:none'></ul>");
                getComment(goods_sn,page,loadMoreFlag);
                var ulClass = "CommentUl"+page;
                $(".CommentUl").removeClass("CommentUl").addClass(ulClass);
            });

            //slideThree加载更多评论
            /*loadMoreFlag用于区别“加载更多评论”按钮和商品详情页面load时候加载评论
             * 每当点击商品详情页面，参数Slide和评价Slide的“加载更多评论”按钮，loadMoreFlag都标识为true
             * loadMoreType用于区别参数Slide和评价Slide的"加载更多评论"按钮
             * loadMoreType==one：表示参数Slide里面的"加载更多评论"
             * loadMoreType==two:表示评价Slide里面的“加载更多评论”*/
            $("#commodityDetails1 .loadingMore").off("tap").on("tap",function(){
                $("#commodityDetails1 .waitLoading").css("display","block");

                var page = hlp.panelObj["commentPage"].page + 1;
                var loadMoreFlag = true;
                hlp.panelObj["loadMoreType"] = {
                    "loadMoreType": "two"
                };
                hlp.panelObj["commentPage"] = {
                    "page": page
                };
                /*append一个空的ul，用于存放新加载的评价数据*/
                $("#slideThreeComment").append("<ul class='CommentUl' style='display:none'></ul>");
                getComment(goods_sn,page,loadMoreFlag);
                var ulClass = "CommentUl"+page;
                $(".CommentUl").removeClass("CommentUl").addClass(ulClass);
            });

            $("div#goodsDetail div.swiper-wrapper div").animate({ scrollTop: 0 }, 500);
            //$("#commodityDetails1").animate({ scrollTop: 0 }, 500);

            // 给swiper Slide动态添加height
            var contentHeight = window.innerHeight - $("div#mainview header:eq(0)").height() - $("div#mainview header:eq(1)").height() - $("div#btnProDiv a#commodityDetails1_buyNow").height();

            if (contentHeight != NaN) {
                $("#slideOne").css({ "height": contentHeight, "overflow-y": "auto","overflow-x": "hidden"});
                $("#slideTwo").css({ "height": contentHeight, "overflow-y": "auto","overflow-x": "hidden"});
                $("#slideThree").css({ "height": contentHeight, "overflow-y": "auto","overflow-x": "hidden"});
            }
        });

    $("#commodityDetails1").on("panelunload",
        function () {
            cleanCommodityDetailPage();
        });

    $("#commoditySuite").on("panelload", function (){
        buyPromoGoodsCount=1;
        var objPromo = hlp.panelObj["promoTitle"];
        if (objPromo!=undefined || objPromo!=null) {
            $("#commoditySuite").attr("data-title", hlp.panelObj["promoTitle"].promoTitle);
        }
    });
});

// 热卖商品
var getHotProduct = function(r) {
    $("#remai_product")[0].innerHTML = r;
    var remai = $("#remai_product .xiaoliang");
    $.each(remai, function(i) {
        var goods_sn = remai.eq(i).find("span").attr("id");
        svc.goodSalesNumber(goods_sn, function(r) {
            if (r.status == "SUCCESS") {
                remai.eq(i).find("span")[0].innerHTML = r.data.month_number;
            } else {
                hlp.myalert(r.message);
            }
        });
    });
};

var cleanCommodityDetailPage = function() {
    $(".cartButton").hide();
    var timerId = $("input#detailSecKillTimerId").attr("timerId");

    if (timerId) {
        clearInterval(timerId);
        $("input#detailSecKillTimerId").attr("timerId", null);
    }

    /*调用清除参数，详情，评价初始化样式的函数*/
    resetCommodityStyle();

    //退出商品详情的时候，把商品的信息清空下
    $('#CommodityBannerSwiper .swiper-slide img').each(function(){
        $(this).attr('src','');
    });
    $('#prodetails_dataPro h4').text('');
    $('#ofNormal strong').text('');
    $('#slideTwo #slideTwoDetail > img').each(function(){
        $(this).attr('src','');
    });

    if(myCommoditySwiper){
        myCommoditySwiper.destroy(true,true);
        myCommoditySwiper = null;
    }
    if(goodsDetailSwiper){
        goodsDetailSwiper.slideTo(0,10);
        goodsDetailSwiper.destroy(true,true);
        goodsDetailSwiper = null;
    }
}

// 特价产品
var getBargainPriceProduct = function(r) {
    $("#tejiaProduct")[0].innerHTML = r;
};

//明星产品
var getStarProduct = function(r) {
    $("#starProduct")[0].innerHTML = r;
};

//新品上市
var getNewList = function(r) {
    $("#newList")[0].innerHTML = r;
};

// 轮播图
var getIndexLoop = function(r) {
    if(r.indexOf("swiper-pagination")<0){
        r=r+'<div class="swiper-pagination"></div>';
    }
    $("#banner").empty().append(r);
    /*mallIndexSwiper是定义在mall.js里面的全部变量
    * 如果已经存在mallIndexSwiper，则销毁，重新初始化swiper*/
    if(mallIndexSwiper){
        mallIndexSwiper.destroy(true,true);
    }
    mallIndexSwiper = new Swiper('.mallIndexBanner', {
        initialSlide :0,
        autoplay : 5000,
        loop:true,
        loopAdditionalSlides:0,
        pagination: '.swiper-pagination'
    });

    //轮播图的点击事件
    $(".bannerSwiper").click(function(){
        var bannerType = $(this).attr("type");

        switch (bannerType){
            case "new":
                $.afui.loadContent("#newProduct");
                break;
            case "team":
                $.afui.loadContent("#groupon");
                break;
            case "spikes":
                $.afui.loadContent("#secKill");
                break;
            case "suit":
                var indexLoopType = "suit";
                getSuitCommodity(indexLoopType);
                $.afui.loadContent("#commoditySuite");
                break;
            default :
                break;
        }
    });
};

//获取套装信息
var getSuitCommodity = function(type){
    svc.getSuit(type,function(r){
        if(r.status == "SUCCESS"){
            $(".father-active")[0].innerHTML = r.data.index_loop_content;
            var promoTitle = $(r.data.index_loop_content).eq(0)[0].innerHTML;
            hlp.panelObj["promoTitle"] = { "promoTitle": promoTitle };
            //立即购买套装
            $(".suitBuy").off("tap").on("tap",function(){
                buyPromoGoodsCount=1;
                var thisSuitCode = $(this).attr("suitCode");
                myPopup = $.afui.popup({
                    title: " ",
                    message:
                    '购买件数: <a id="minus" onclick="promoMinusCount(suiteBuyCount);">-</a>'+
                    '<input id="suiteBuyCount" type="text" value="1" /> '+
                    '<a id="plus" onclick="promoPlusCount(suiteBuyCount)">+</a>'+
                    '<p id="suiteBuyCountMsg"></p>',
                    cancelText: "取&nbsp;&nbsp;消",
                    doneText: "确&nbsp;&nbsp;定",
                    cancelCallback: function () {
                        myPopup = null;
                        return;
                    },
                    doneCallback: function () {
                        var count=$("#suiteBuyCount").val();
                        if(count.trim().length==0){
                            myPopup = null;
                            return;
                        }else{
                            if (loj.CredentialStatus == "inactive") {
                                showLoginController1();
                            }else{
                                hlp.panelObj["buyNowGoods"] = {
                                    "isCart": "0",
                                    "suitCode":thisSuitCode,
                                    "extensionCode":type,
                                    "num": count
                                };
                                if (loj.Credential) {
                                    buyNowFunction(loj.Credential);
                                } else {
                                    $.afui.loadContent("#notLoginBuy");
                                }
                            }
                        }
                        myPopup = null;
                    },
                    cancelOnly:false
                });
                //输入框事件
                $("#suiteBuyCount").off("input").on("input", function () {
                    var quantity=$("#suiteBuyCount").val();
                    var numCheck = new RegExp(/^[1-9]*[1-9][0-9]*$/);
                    if(quantity.trim().length==0){
                        return;
                    }else if(numCheck.test(quantity)){
                        $("#suiteBuyCountMsg").text("");
                    }else{
                        $("#suiteBuyCountMsg").text("件数必须为正整数！");
                        $("#suiteBuyCount").val("");
                        return;
                    }
                });
            });

            //套装页面的单件商品
            $("#commoditySuite .ta").off("tap").on("tap",
                function(){
                    var goods_sn = $(this).attr("goods_sn");
                    hlp.panelObj["commodityDetails"] = {
                        "sn": goods_sn
                    };
                    $.afui.loadContent("#commodityDetails1");
                });

            //返回顶部
            $("#commoditySuite .taBtn").eq(1).off("tap").on("tap",function(){
                $("div#commoditySuite").animate({ scrollTop: 0 }, 500);
            });
        }else{
            hlp.myalert(r.message);
        }
    }, function() {
        $.afui.loadContent("#commoditySuite");
    });
};


//商品详情&&商品评价的点击事件
var showCommodityDetail = function() {
    if ($("#goodsIntroduction").is(":hidden")) {
        $("#goodsIntroduction").css("display", "inline-block");
        $("#showCommodityDetailDiv").addClass("showcanshu");
    } else {
        $("#goodsIntroduction").css("display", "none");
        $("#showCommodityDetailDiv").removeClass("showcanshu");
    }
};
var showCommodityComment = function() {
    if ($("#goodsComment").is(":hidden")) {
        $("#goodsComment").css("display", "inline-block");
        $("#showCommodityCommentDiv").addClass("showcanshu");
    } else {
        $("#goodsComment").css("display", "none");
        $("#showCommodityCommentDiv").removeClass("showcanshu");
    }
};
var showCommodityParameter = function() {
    if ($("#goodsParameter").is(":hidden")) {
        $("#goodsParameter").css("display", "block");
        $("#showCommodityParameterDiv").addClass("showcanshu");
    } else {
        $("#goodsParameter").css("display", "none");
        $("#showCommodityParameterDiv").removeClass("showcanshu");
    }
};

//增&&减购买数量
var minusCount = function() {
    var quantity = $("#purchaseQuantity").val();
    if (Number(quantity) > 1) {
        quantity--;
        $("#purchaseQuantity").val(quantity);
    }
};
var plusCount = function() {
    var quantity = $("#purchaseQuantity").val();
    var purchaseQuantity = hlp.panelObj["purchaseQuantity"].inventory;
    if (Number(quantity) < Number(purchaseQuantity)) {
        quantity++;
        $("#purchaseQuantity").val(quantity);
    }else{
        hlp.myalert("亲，该宝贝不能购买更多！");
    }
};

//切换商品列表
var changeDisplay = function() {
    if ($("#goodsListDiv").attr("class") == "list1") {
        $("#goodsListDiv").removeClass("list1");
        $("#goodsListDiv").addClass("list2");
        $(".listMenu").attr("src","images/icons-png/list-show.png");
    } else {
        $("#goodsListDiv").removeClass("list2");
        $("#goodsListDiv").addClass("list1");
        $(".listMenu").attr("src","images/icons-png/grid-show.png");
    }
};

/*listByKey:判断商品列表的排序方式
 * 1：按销售数量， 2：按上架时间，3：按商品价格，4：按商品人气
 * 默认按销量排序*/
var listByKey="1";
//商品列表筛选
var listBy = function(thisId) {
    var catId = hlp.panelObj["catId"].catId;

    switch (thisId) {
        case "listBySales":
            listByKey = "1";
            break;

        case "listByNew":
            listByKey = "2";
            break;

        case "listByPrice":
            listByKey = "3";
            break;

        case "listByPopular":
            listByKey = "4";
            break;

        default:
            break;
    }

    //筛选后获取商品列表
    svc.getGoodsList(catId, listByKey,
        function(r) {
            if (r.status == "SUCCESS") {
                //商品销量处理
                $.each(r.data,function(index){
                    if(Number(r.data[index].month_number) > 10000 ){
                        var currentSalesNumber1 = parseInt(r.data[index].month_number/10000);
                        var currentSalesNumber2 = parseInt(r.data[index].month_number%10000/1000);
                        r.data[index].month_number = currentSalesNumber1+"."+currentSalesNumber2+"万";
                    }
                });
                hlp.bindtpl(r.data, "#goodsList", "tpl_goodsList");
                $(".gl").off("tap").on("tap",
                    function() {
                        var goods_sn = $(this).attr("id");
                        hlp.panelObj["commodityDetails"] = {
                            "sn": goods_sn
                        };
                        $.afui.loadContent("#commodityDetails1");
                    });
            } else {
                hlp.myalert(r.message);
            }
        });
};

//获取当前时间
var AppendZero = function(obj) {
    if (obj < 10) return "0" + obj;
    else return obj;
};
var currentTime = function() {
    var d = new Date();

    var nowTime = d.getTime();
    var year = d.getFullYear(); //获取当前年份
    var month = d.getMonth() + 1; //获取当前月份（0——11）
    var date = d.getDate();
    var hour = d.getHours();
    var minute = d.getMinutes();
    var second = d.getSeconds();
    var str = year + "-" + AppendZero(month) + "-" + AppendZero(date) + " " + AppendZero(hour) + ":" + AppendZero(minute) + ":" + AppendZero(second);
    return str;
};

// 把日期转化为数字
var convertDataTime = function(times) {
    var times = times.replace("-", "").replace("-", "").replace(" ", "").replace(":", "").replace(":", "");
    return Number(times);
};

var setMsFlg = function() {
    var secKill = $("#secKillProInfo .secKillPro");

    $.each(secKill,
        function(i) {
            var promoBeginTime = convertDataTime(secKill.eq(i).find(".promoBeginTime").val());
            var promoEndTime = convertDataTime(secKill.eq(i).find(".promoEndTime").val());
            var curTime = convertDataTime(currentTime());

            var testBeginTime = secKill.eq(i).find(".promoBeginTime").val().replace(/-/ig, '/');

            if (curTime >= promoBeginTime && curTime < promoEndTime) {
                //秒杀正在进行中
                secKill.eq(i).find("#secKilling").show();
                secKill.eq(i).find("#secKillNoBegin").hide();
                secKill.eq(i).find("#secKillEnd").hide();
            } else if (curTime < promoBeginTime) {
                //秒杀未开始
                secKill.eq(i).find("#secKilling").hide();
                secKill.eq(i).find("#secKillNoBegin").show();
                secKill.eq(i).find("#secKillEnd").hide();

                var button = secKill.eq(i).find("#secKillNoBegin");
                /*StartCountDown()方法用于计算倒计时*/
                var timerId = StartCountDown(new Date(testBeginTime).getTime(),
                    function(remainTime) {
                        button.html("剩 "+remainTime.string+" 开始");
                    });

                secKill.eq(i).attr("timerId", timerId);

            }
        });
};

function StartCountDown(targetTime, callback) {
    return setInterval(function() {
            var remainTime = {};

            remainTime["ms"] = targetTime - new Date().getTime();
            remainTime["day"] = Math.floor(remainTime.ms / (1000 * 60 * 60 * 24)); //天
            remainTime["hour"] = Math.floor(remainTime.ms / (1000 * 60 * 60)) % 24; //小时
            remainTime["minute"] = Math.floor(remainTime.ms / (1000 * 60)) % 60; //分钟
            remainTime["second"] = Math.floor(remainTime.ms / 1000) % 60; //秒
            if (remainTime.ms > 0) {
                remainTime["string"] = remainTime.day + "天" + remainTime.hour + "小时" + remainTime.minute + "分" + remainTime.second + "秒";
            } else {
                remainTime["string"] = "end";
            }

            if (callback) {
                callback(remainTime);
            }
        },
        1000);
};

/*判断ExtensionCode （普通：common；秒杀：spikes；特惠：teams）*/
var getExtensionCode = function(r) {
    var extensionCode = r.data.extension_code;
    switch (extensionCode) {
        case "common":
            //新品&&普通商品
            $("#ofNormal").show();
            $("#ofGroup").hide();
            $("#ofSecKill").hide();
            if ($("#btnProDiv").hasClass("btnSecGroupPro")) {
                $("#btnProDiv").removeClass("btnSecGroupPro").addClass("btnPro");
            }
            break;
        case "spikes":
            //秒杀商品
            $("#ofNormal").hide();
            $("#ofGroup").hide();
            $("#ofSecKill").show();
            $("#commodityDetails1 .num span").text(r.data.promo_number);
            if ($("#btnProDiv").hasClass("btnPro")) {
                $("#btnProDiv").removeClass("btnPro").addClass("btnSecGroupPro");
            }


            break;
        case "teams":
            //团购商品
            $("#ofNormal").hide();
            $("#ofGroup").show();
            $("#ofSecKill").hide();
            $("#commodityDetails1 .num span").text(r.data.promo_number);
            if ($("#btnProDiv").hasClass("btnPro")) {
                $("#btnProDiv").removeClass("btnPro").addClass("btnSecGroupPro");
            }
            break;
        default:
            break;
    }
};

//评价
var getComment  = function(goods_sn,page,loadMoreFlag){
    svc.getCommodityComment(goods_sn,page,
        function(r) {
            hlp.log("inside getCommodityComment request...");
            if (r.status == "SUCCESS") {

                /*循环评价数据，根据comment_rank，设定对应的rankLevel*/
                for (var i = 0; i < r.data.comment.length; i++) {
                    var rank = parseInt(r.data.comment[i].comment_rank);

                    if (rank == 0 || rank == NaN) {
                        r.data.comment[i]["rankStarStyle"] = "display: none;";
                    } else {
                        r.data.comment[i]["rankStarStyle"] = "width: " + ((rank - 1) * 20).toString() + "%;";
                        switch (rank) {
                            case 5:
                                r.data.comment[i]["rankLevel"] = "非常满意";
                                break;
                            case 4:
                                r.data.comment[i]["rankLevel"] = "满意";
                                break;
                            case 3:
                                r.data.comment[i]["rankLevel"] = "一般";
                                break;
                            case 2:
                                r.data.comment[i]["rankLevel"] = "不好";
                                break;
                            case 1:
                                r.data.comment[i]["rankLevel"] = "差评";
                                break;
                        }
                    }
                }

                /*loadMoreFlag用于区别“加载更多评论”按钮和商品详情页面load时候加载评论
                * 每当点击商品详情页面，参数Slide和评价Slide的“加载更多评论”按钮，loadMoreFlag都标识为true
                * loadMoreFlag==false则走商品详情页面默认加载评论*/
                if(loadMoreFlag == false){
                    hlp.bindtpl(r.data, ".goodsCommentUl", "tpl_goodsComment");
                    hlp.bindtpl(r.data, ".slideComment", "tpl_goodsComment");
                    if(r.data.comment.length == "" || r.data.comment.length < 30){
                        $(".loadMore").hide();
                    }

                }else{
                    /*loadMoreFlag==true则走加载更多评论*/
                    var ulclass = "CommentUl"+page;
                    hlp.bindtpl(r.data, "."+ulclass, "tpl_CommentUl");
                    /*loadMoreType用于区别参数Slide和评价Slide的"加载更多评论"按钮
                    * loadMoreType==one：表示参数Slide里面的"加载更多评论"
                    * loadMoreType==two:表示评价Slide里面的“加载更多评论”*/
                    if(hlp.panelObj["loadMoreType"].loadMoreType == "one"){
                        var goods_Comment_Ul = "goodsCommentUl";
                    }else{
                        var goods_Comment_Ul = "slideComment";
                    }
                    /*将新加载的30条评价数据appendTo已加载的评价后面*/
                    $("."+ulclass).appendTo("."+goods_Comment_Ul).css("display","block");
                    /*判断新加载的数据的length，若为空或者是小于30，则表示没有更多评论了*/
                    if(r.data.comment.length == "" || r.data.comment.length < 30){
                        if(hlp.panelObj["loadMoreType"].loadMoreType == "one"){
                            hlp.myalert("已加载全部评论");
                            $(".loadMore").hide();
                        }else{
                            hlp.myalert("已加载全部评论");
                            $(".loadingMore").hide();
                        }
                    }
                }

                // 图片放大缩小
                $("#goodsDetail .imgI img").off("tap").on("tap", function () {
                    if ($(this).hasClass("bigImg")) {
                        $(this).removeClass("bigImg");
                    } else {
                        $("#goodsDetail .imgI img").siblings().removeClass("bigImg");
                        var imgObj = new Image();
                        imgObj.src = $(this).attr("src");
                        $(this).addClass("bigImg");
                        imgObj = null;
                    }
                });

                /*加载完成后，不显示waitLoading*/
                $("#commodityDetails1 .waitLoading").css("display","none");
            } else {
                hlp.myalert(r.message);
            }
        });
};

//搜索商品
var getGoodsSearchRes=function(searchKey,page,succeedHandler, failedHandler){
    svc.getGoodsSearch(searchKey,page,function(r) {
        if (r.status == "SUCCESS") {
            //商品销量处理
            $.each(r.data,function(index){
                if(Number(r.data[index].month_number) > 10000 ){
                    var currentSalesNumber1 = parseInt(r.data[index].month_number/10000);
                    var currentSalesNumber2 = parseInt(r.data[index].month_number%10000/1000);
                    r.data[index].month_number = currentSalesNumber1+"."+currentSalesNumber2+"万";
                }
            });
            if(succeedHandler){
                succeedHandler(r);
            }
        } else {
            if(failedHandler){
                failedHandler(r);
            }
        }
    });
};

//初始化参数，详情，评价的样式
var resetCommodityStyle = function(){
    var mallCdd = $("#showCommodityDetailDiv").hasClass("showcanshu");
    var mallCcd = $("#showCommodityCommentDiv").hasClass("showcanshu");
    var headerDetailCur = $("#headerDetail").hasClass("cur");
    var headerCommentCur = $("#headerComment").hasClass("cur");
    $("#goodsParameter").css("display", "block");
    $("#showCommodityParameterDiv").addClass("showcanshu");
    if (mallCdd != false) { showCommodityDetail(); }
    if (mallCcd != false) { showCommodityComment(); }
    if(headerDetailCur == true){
        $("#headerDetail").removeClass("cur");
        $("#headerParameter").addClass("cur");
    }
    if(headerCommentCur){
        $("#headerComment").removeClass("cur");
        $("#headerParameter").addClass("cur");
    }
};

//活动商品件数加减
var buyPromoGoodsCount=1;
var promoMinusCount=function(btuId){
    if(buyPromoGoodsCount>1){
        buyPromoGoodsCount--;
        $("#"+btuId.id).val(buyPromoGoodsCount);
    }
    return false;
};

var promoPlusCount=function(btuId){
    buyPromoGoodsCount=$("#"+btuId.id).val();
    if(buyPromoGoodsCount.trim().length==0){
        buyPromoGoodsCount=1;
    }else{
        buyPromoGoodsCount=parseInt(buyPromoGoodsCount);
        buyPromoGoodsCount++;
    }
    $("#"+btuId.id).val(buyPromoGoodsCount);
    return false;
};

function unBlockCommodityPannel(iterationTimes){
    isLoaded = false;

    if (!iterationTimes) {
        iterationTimes = 1;
    } else {
        iterationTimes = iterationTimes + 1;
    }

    //console.log(hlp, 'iterationTimes = ' + iterationTimes);

    if (iterationTimes > 10) {
        //$.afui.unblockUI();
        //$.afui.hideMask();
        $.afui.unBlockUIwithMask();
        //isLoaded = true;
        return;
    }

    $("#CommodityBannerSwiper img").each(function(){
        if(this.height > 0 && !isLoaded) {
            $.afui.unblockUI();
            $.afui.hideMask();
            isLoaded = true;
        }
    });

    if (!isLoaded) {
        setTimeout(function(){
            unBlockCommodityPannel(iterationTimes); // 递归
        },500);
    }
}

var doFavorite = function(user_id,goods_sn){
    if (loj.Credential) {
        svc.goodsCollect(user_id, goods_sn,
            function(r) {
                if (r.status == "SUCCESS") {
                    hlp.myalert(r.message);
                    if(r.data.collect_flag == "1"){
                        $("#favoriteFlag").parent().attr("class", "fav");
                        $("#favoriteFlag").text("已收藏");
                    }else{
                        $("#favoriteFlag").parent().attr("class", "notfav");
                        $("#favoriteFlag").text("收藏");
                    }
                } else {
                    hlp.myalert(r.message);
                }
            });
    } else {
        hlp.myalert("您还没登录，请先登录！");
    }
};