$.afui.ready(function () {
    $("#main").on("panelload", function (e) {
        hlp.log($("#main").html());
    });

    $("#main").on("panelunload", function (e) {
        $(".popupDevice").hide();
    });
    $("#welcome").on("panelload", function () {
        console.log("in welcome page.::::::::::");
        var swiper = new Swiper('#swiper-welcome', {
            pagination: '.swiper-pagination',
            paginationClickable: true
        });
    });


    //// news_top
    //$("#mytest").on("panelload", function (e) {
    //    /*
    //    hlp.log("this is in my test...");
    //    var fls = $.localStorage;
    //    fls.set("FLYCO.USER", { "UserId": 12, "UserName": "sicon" });
    //    hlp.log(hlp.format("UserID:{0},UserName:{1}", [fls.get("FLYCO.USER").UserId, fls.get("FLYCO.USER").UserName]));
    //
    //    // tpl_mtlist
    //    svc.getuserprofile(12, function (r) {
    //        hlp.log("this is in getuserprofile.");
    //        hlp.binddata(r, "#mtlist", "tpl_mtlist");
    //    });
    //    */
    //});
    //
    //// news_top
    //$("#mtlist").on("panelload", function (e) {
    //    // 取第一个参数
    //    var userid = hlp.getparam(1);
    //    // tpl_mtlist
    //    svc.getuserprofile(userid, function (r) {
    //        hlp.binddata(r, "#mtlist", "tpl_mtlist");
    //    });
    //});

});
