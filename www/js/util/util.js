// 扩展String的replaceall方法
String.prototype.replaceall = function (s1, s2) {
    return this.replace(new RegExp(s1, "gm"), s2);
}

// 系统可能用到的帮助类
var helper = function () { };
helper.prototype = {
    panelObj: [],
    lastPage: "",
    specialGoBack:"",
    /* Console打出log */
    log: function (msg) {
        if (debugMode == true) {
            console.log("APP.LOG::" + msg);
        }
    },
    /* 格式化时间
     * dt : /Date(1429769991000)/
     * fmt : date formate:
     *      f : 2015-04-23- 14:19:51
     *      s : 04-23- 14:19
     *      fd: 2015-04-23
     *      sd: 15-04
     *      l : 1秒前, 5分前, 6小时前, 04-23 14:19
    */
    dateformat: function (dt, fmt) {
        var ds = ""; // return value

        dt = dt.replace("/Date(", "").replace(")/", "");
        if (dt.indexOf("+") > 0) {
            dt = dt.substring(0, dt.indexOf("+"));
        }
        else if (dt.indexOf("-") > 0) {
            dt = dt.substring(0, dt.indexOf("-"));
        }

        var intlong = parseInt(dt, 10);
        var date = new Date(intlong);

        if (fmt == "l") {
            var cdt = new Date();
            var intclong = cdt.getTime();

            // within 1 mins, shows seconds
            if ((intclong - intlong) < 1 * 60000) {
                ds = parseInt(((intclong - intlong) / 1000)) + "秒前";
                return ds;
            }
            // within 1 hours, shows mins
            if ((intclong - intlong) < 1 * 3600000) {
                ds = parseInt(((intclong - intlong) / 60000)) + "分前";
                return ds;
            }
            // within 6 hours, shows hours
            if ((intclong - intlong) < 6 * 3600000) {
                ds = parseInt(((intclong - intlong) / 3600000)) + "小时前";
                return ds;
            }
        }

        var month = date.getMonth() + 1 < 10 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1;
        var currentDate = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();

        if (fmt == "f") {
            ds = date.getFullYear() + "-" + month + "-" + currentDate + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
            return ds;
        }

        if (fmt == "fd") {
            ds = date.getFullYear() + "-" + month + "-" + currentDate;
            return ds;
        }

        if (fmt == "sd") {
            ds = month + "-" + currentDate;
            return ds;
        }

        ds = month + "-" + currentDate + " " + date.getHours() + ":" + date.getMinutes();
        return ds;
    },
    //private
    sethsh: function (h, v) {
        var t = $.localStorage;
        t.set("HSH_" + h, v);
    },
    // private
    gethsh: function (h) {
        var t = $.localStorage;
        return t.get("HSH_" + h);
    },
    /* 取得参数
     * eg : #main/3/2/1 ==> idx[1]=3,idx[2]=2,idx[3]=1....
     * hlp.getpm(1) = 3; hlp.getpm(2) = 2; hlp.getpm(3) = 1;
     */
    getpm: function (idx) {
        // sicon
        console.log(document.location.hash);

        params = document.location.hash.split('/');
        if (params.length > idx) {
            // put the hash data into localstorage, 
            this.sethsh(params[0], document.location.hash);
            return params[idx];
        } else {
            // if the requested value param is null, then try to read local storage
            params = this.gethsh(params[0]).split('/');
            if (params.length > idx) {
                return params[idx];
            }
            else {
                return null;
            }
        }
    },
    /* 绑定数据到模板
     * data: 数据
     * target: 容器ID 需要带 #
     * template: 模板ID
     */
    bindtpl: function (data, target, template) {
        $(target).setTemplateElement(template);
        $(target).processTemplate(data);
    },
    /* 格式化输出 
     * eg: hlp.format("Name:{0},Age:{1}", "linda", 12) => Name:Linda,Age:12
     */
    format: function (str, args) {
        return str.replace(/\{(\d+)\}/g, function () {
            var p = arguments[0].replace(/[\{\}]/g, "");
            return args[p];
        });
    },
    myalert: function (m) {
        $.afui.popup({
            title: "提示",
            message: m,
            cancelOnly: true,
            cancelText: "确定"
        });
    },
    apdf:function(url){
        var d = new Date();
        return url + "?r="+d.getTime();
    }
};