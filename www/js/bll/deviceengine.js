/**************************
  * device engine: 
  * 2015-8-1
  */
(function ($) {
    "use strict";
    var version = "1.0";
    var deviceEngin = function () {
        this.dal = new DataAccess();
    };
    deviceEngin.prototype = {
        dal: null,
        config: "./js/bll/devicecfg.json",
        isReady: false,
        qStatus: false,
        entities: null, // json entity
        instance: [],
        interval: 100000,
        monitorins:0,
        context: null, // parameters will be loaded from here.
        init: function () {
            this.isReady = false;
            var that = this;
            $.ajax({
                'type': 'GET',
                'url': this.config,
                'contentType': 'application/json; charset=UTF-8',
                'async':false,
                'dataType': 'json',
                'beforeSend': function () {
                },
                'success': function (r) {
                    that.entities = r;
                    $(document).trigger("de:ready");
                },
                'complete': function () {
                    that.isReady = true;
                },
                'error': function (msg) {
                }
            });
        },
        // 发送命令到服务器
        // cmd:FunctionName
        triggeropt: function (cmd) {
            var tmpObj = null;
            $.each(this.entities.Operations, function (k, v) {
                if (v.FunctionName == cmd) {
                    tmpObj = v;
                    return false;
                }
            });
            var url = this.entities.Domain + this.format(tmpObj.Location, this.context);
            var dataStr = this.format(JSON.stringify(tmpObj.Parameters), this.context);
            var data = {};
            if (dataStr != "")
                data = JSON.parse(dataStr);
            /*
            console.log("::::::::::::::CONTEXT:" + JSON.stringify($.de.context));
            console.log("::::::::::::::ShowName:" + tmpObj.ShowName);
            console.log("::::::::::::::FunctionName:" + tmpObj.FunctionName);
            console.log("::::::::::::::Options:" + JSON.stringify(tmpObj.Options));
            console.log("::::::::::::::Location:" + url);
            console.log("::::::::::::::Method:" + tmpObj.Options.Method);
            console.log("::::::::::::::Parameters:" + JSON.stringify(data));
            console.log("::::::::::::::::::::::::::::::::::::::::::::::::::::");
            */

            if (tmpObj.Options.Action == "Y") {
                return $.ajax({
                    'type': tmpObj.Options.Method,
                    'url': url,
                    'contentType': 'application/json; charset=UTF-8',
                    'data': JSON.stringify(data),
                    'dataType': 'json',
                    'beforeSend': function () {
                        console.log(":::REQUEST OPT::::" + url);
                    },
                    'success': function (r) {
                        console.log("success");
                    },
                    'complete': function () {
                        console.log("complete");
                    },
                    'error': function (msg) {
                        // console.log(msg.message);
                    }
                });
            }
        },
        getStatus: function (callback) {
            var url = this.entities.Domain + $.de.entities.Status.Location;
            url = this.format(url, this.context);
            //console.log(url);
            console.log("READY:::STATUS::" + $.de.qStatus);
            if ($.de.qStatus == false) {
                $.ajax({
                    'type': 'GET',
                    'url': url,
                    'contentType': 'application/json; charset=UTF-8',
                    'dataType': 'json',
                    'beforeSend': function () {
                        console.log(":::GET STATUS::::BEFORE");
                        $.de.qStatus = true;
                        console.log("BEFORE:::STATUS::" + $.de.qStatus);
                    },
                    'success': function (r) {
                        callback(r);
                    },
                    'complete': function () {
                        console.log(":::GET STATUS::::COMPLETE");
                        $.de.qStatus = false;
                        console.log("COMPLELTE:STATUS::" + $.de.qStatus);
                    },
                    'error': function (msg) {
                        // console.log();
                    }
                });
            }
        },
        // str: /devices/light/{deviceid}
        // args: {"tokenid":"TKID0001","deviceid":"DVI0002"}
        format: function (str, args) {
            if (str == null) return "";
            /*
            console.log(":::::::::::::::::STR:" + str);
            console.log(":::::::::::::::::ARGS:" + JSON.stringify(args));
            */
            return str.replace(/\{(\w+)\}/g, function () {
                var p = arguments[0].replace(/[\{\}]/g, "");
                return eval("args." + p);
            });
        },
        monitor: function () {
            console.log("get status from server:");
        },
        //打开监视器
        startmonitor: function () {
            if (this.monitorins != 0) return;
            this.monitorins = self.setInterval(this.monitor, this.interval);
            console.log("monitor start...& the id is:" + this.monitorins);
        },
        //关闭监视器
        stopmonitor: function () {
            window.clearInterval(this.monitorins);
            this.monitorins = 0;
            console.log("monitor stop...& the id is:" + this.monitorins);
        },
        /*ready: function (fn) {
            if (this.isReady) {
                fn();
            }
            else {
                $(document).one("de:ready", function () {
                    fn();
                });
            }
        }*/
        };

    $.de = new deviceEngin();
    $.de.init();
})(jQuery);