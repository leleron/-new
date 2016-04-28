var Authentication = function (t, c) {
    switch (c) {
        case "s_login":
            if (loj.IsLogin == true) {
                return true;
            } else {
                $.afui.loadContent("#login");
            };
            break;
        case "s_loginReplace":
            if (loj.IsLogin == true) {
                if (loj.CredentialStatus == "inactive") {
                    $.afui.loadContent("#login");
                } else{
                    return true;
                };
            } else {
                $.afui.loadContent("#login");
            };
            break;
        case "":
            return true;
        default:
            return true;
    }
};

var showToast = function (msg) {
    $.afui.toast({
        message: msg,
        position: "tc",
        autoClose: true, //have to click the message to close
        type: "success"
    });
};

//按加号弹出
var showDevice = function () {
    $(".addScan").toggle();
};

var setPlusButton = function (bool) {
    if (bool)
        $(".plusButton").show();
    else
        $(".plusButton").hide();
};
//长按删除用户消息
$('.usermessage .swipe-reveal').on('longTap', function () {
    $('.usermessage .tag').show();
    $(document).on('tap', function (e) {
        if ($(e.target).attr('class') != 'tag') {
            $('.usermessage .tag').hide();
        }
    });
});

var getPst = function (callback) {
    navigator.geolocation.getCurrentPosition(callback, onError);

    function onError(error) {
        hlp.log('code: ' + error.code + '\n' + 'message: ' + error.message + '\n');
    }
};

var getTude = function (callback) {
    var latitude, longitude;

    navigator.geolocation.getCurrentPosition(onSuccess, onError);

    function onSuccess(position) {
        latitude = position.coords.latitude;
        longitude = position.coords.longitude;
        //longitude,latitude是真实的经纬度标注
        var gpsPoint = new BMap.Point(longitude, latitude);
        //通过translate将真实的latitude, longitude转换为百度标注
        BMap.Convertor.translate(gpsPoint, 0, translateCallback);

        function translateCallback(point) {
            loj.setTude(point.lat, point.lng);
            //创建地址解析器
            var gc = new BMap.Geocoder();
            gc.getLocation(point, function (rs) {
                var addComp = rs.addressComponents;
                address = addComp.city + addComp.district + addComp.street + addComp.streetNumber;
                $("#currentDddress").val(address);
            });
            callback(loj.Latitude, loj.Longitude, point);
        }
    }

    function onError(error) {
        hlp.log('code: ' + error.code + '\n' + 'message: ' + error.message + '\n');
    }
};

var getMapTude = function (callback) {
    var latitude, longitude;

    navigator.geolocation.getCurrentPosition(onSuccess, onError);

    function onSuccess(position) {
        latitude = position.coords.latitude;
        longitude = position.coords.longitude;
        //longitude,latitude是真实的经纬度标注
        var map = new BMap.Map("allmap"); // 创建地图实例
        var gpsPoint = new BMap.Point(longitude, latitude);
        //通过translate将真实的latitude, longitude转换为百度标注
        BMap.Convertor.translate(gpsPoint, 0, translateCallback);

        function translateCallback(point) {
            //localStorage.setItem("longitude", point.lng);
            //localStorage.setItem("latitude", point.lat);
            loj.setTude(point.lat, point.lng);
            //创建地址解析器
            var gc = new BMap.Geocoder();
            gc.getLocation(point, function (rs) {
                var addComp = rs.addressComponents;
                address = addComp.city + addComp.district + addComp.street + addComp.streetNumber;
                $("#currentDddress").val(address);
            });
            var marker = new BMap.Marker(point);  // 创建标注
            map.centerAndZoom(point, 17); // 初始化地图，设置中心点坐标和地图级别
            map.setCenter(point);
            map.enableScrollWheelZoom();
            map.addControl(new BMap.NavigationControl()); //添加默认缩放平移控件
            map.addOverlay(marker);               // 将标注添加到地图中
            callback(loj.Latitude, loj.Longitude, point);
        }
    }

    function onError(error) {
        hlp.log('code: ' + error.code + '\n' + 'message: ' + error.message + '\n');
    }
};

//生成一个随机数
var randomWord= function (randomWordLength) {
    var str = "";
    var arr = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

    for(var i=0; i<randomWordLength; i++){
        var pos = Math.round(Math.random() * (arr.length-1));
        str += arr[pos];
    }
    return str;
};
