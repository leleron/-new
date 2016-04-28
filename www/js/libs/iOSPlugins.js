//【获取当前连接Wi-Fi的SSID】---------------
function getssid(successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "getssid",
                 []
                 );
};
//【获取当前连接Wi-Fi的SSID】---------------

//【乐鑫WiFi配网】-------------------------
function eConnect(ssid,password,successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "espconfirmMethod",
                 [ssid,password]
                 );
};
//【乐鑫WiFi配网】-------------------------

//【汉枫WiFi配网】-------------------------
function sConnect(successfunc,errorfunc,ssid,password)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "hanFeng",
                 [ssid,password]
                 );
};
//【汉枫WiFi配网】-------------------------

//【扫一扫二维码】-------------------------
function qRcodeScanner(successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "qRcodeScanner",
                 []
                 );
};
//【扫一扫二维码】-------------------------

//【微信登录】-------------------------
function wxLogin(successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "wxLogin",
                 []
                 );
};
//【微信登录】-------------------------

//【QQ登录】-------------------------
function qqLogin(successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "qqLogin",
                 []
                 );
};
//【QQ登录】-------------------------

//【京东登录】-------------------------
function jdLogin(successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "jdLogin",
                 []
                 );
};
//【京东登录】-------------------------

//【社会化分享】-------------------------
function share(title,context,imgurl,target_url,barcodeimageurl,successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "share",
                 [title,context,imgurl,target_url,barcodeimageurl]
                 );
};
//【社会化分享】-------------------------

//【扫地机器人专用配网插件】-------------------------
function rConnect(ssid,spwd,successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "configNetWork",
                 [ssid,spwd]
                 );
};
//【扫地机器人专用配网插件】-------------------------

//【弹出扫地机器人主控页面的插件】-------------------------
function showRobotController(spwd,sn,successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "pushVideoController",
                 [spwd,sn]
                 );
};
//【弹出扫地机器人主控页面的插件】-------------------------

//【从相册获取图片的插件】-------------------------
function imageRcodeScanner(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "GetPicture",
                 "getPicture",
                 ['Album']
                 );
};
//【从相册获取图片的插件】-------------------------

//【通过摄像头获取图片的插件】-------------------------
function getPictureFromCamera(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "GetPicture",
                 "getPicture",
                 ['Camera']
                 );
};
//【通过摄像头获取图片的插件】-------------------------

//【从相册获取图片二维码值】-------------------------
function imageQRcodeScanner(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "ZXingPlugin",
                 "getQRCodeFromAlbum",
                 []
                 );
};
//【从相册获取图片二维码值】-------------------------

//【将图片保存至相册】-------------------------
function savePicture(img,successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "savePicture",
                 [img]
                 );
};
//【将图片保存至相册】-------------------------

//【支付宝支付】-------------------------
function pay(subject,body,price,tradeNo,successfunc,errorfunc){
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "alipay",
                 [subject,body,price,tradeNo]
                 );
};
//【支付宝支付】-------------------------

//空气净化器配网插件
function configEasyLink(ssid,spwd,successfunc,errorfunc){
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "easyLinkConfigNetWork",
                 [ssid,spwd]
                 );
    
}

function loc()
{
    cordova.exec(function(result) {},
                 function(error) {alert("Error: \r\n"+error);},
                 "Echo",
                 "startlocation",
                 []
                 );
};


function myclick()
{
    alert("aaa");
    
    var myla,mylo;
    
    
    cordova.exec(function(result)
                 {
                 var array=result.split('-');
                 alert(array.toString());
                 
                 var map = new BMap.Map("allmap"); // 创建地图实例
                 var point = new BMap.Point(array[1],array[0]); // 创建点坐标
                 setTimeout(function(){
                            BMap.Convertor.translate(point,0,translateCallback);     //真实经纬度转成百度坐标
                            }, 2000);
                 
                 //坐标转换完之后的回调函数
                 translateCallback = function (points){
                 alert(points.lng + "," + points.lat);
                 var marker = new BMap.Marker(points);  // 创建标注
                 map.addOverlay(marker);               // 将标注添加到地图中
                 //marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
                 
                 var customLayer;
                 customLayer=new BMap.CustomLayer({
                                                  geotableId: 103479,
                                                  q: '', //检索关键字
                                                  tags: '', //空格分隔的多字符串
                                                  filter: '' //过滤条件,参考http://developer.baidu.com/map/lbs-geosearch.htm#.search.nearby
                                                  });
                 map.addTileLayer(customLayer);
                 //        customLayer.addEventListener('hotspotclick',callback);
                 //        function callback(e)//单击热点图层
                 //        {
                 //            var customPoi = e.customPoi;//poi的默认字段
                 //            var contentPoi=e.content;//poi的自定义字段
                 
                 //        var customPoi = e.customPoi;//poi的默认字段
                 //        var contentPoi=e.content;//poi的自定义字段
                 //        var content = '<p style="width:280px;margin:0;line-height:20px;">地址：' + customPoi.address + '<br/>价格:'+contentPoi.dayprice+'元'+'</p>';
                 //        getElementById("info").innerHTML = customPoi.address + customPoi.coords;
                 //        }
                 
                 
                 
                 //        var options = {
                 //            renderOptions: {
                 //                map: map
                 //            },
                 //            onSearchComplete: function(results) {
                 //                alert('Search Completed');
                 //                //可添加自定义回调函数
                 //            }
                 //        };
                 //        var localSearch = new BMap.LocalSearch(map, options);
                 //        map.addEventListener("load", function() {
                 //                             var circle = new BMap.Circle(points, 5000, {
                 //                                                          fillColor: "blue",
                 //                                                          strokeWeight: 1,
                 //                                                          fillOpacity: 0.00000000001,
                 //                                                          strokeOpacity: 0.000000000001
                 //                                                          });
                 //                             map.addOverlay(circle);
                 //                             localSearch.searchNearby('飞科', points, 5000, {
                 //                                                      customData: {
                 //                                                        geotableId: 103479
                 //                                                      }
                 //                                                      });
                 //                             });
                 map.centerAndZoom(points, 12); // 初始化地图，设置中心点坐标和地图级别
                 map.enableScrollWheelZoom();
                 map.addControl(new BMap.NavigationControl()); //添加默认缩放平移控件
                 };
                 
                 },
                 function(error) {alert("Error: \r\n"+error);},
                 "Echo",
                 "getmylatitude",
                 []
                 );
    cordova.exec(function(result) {},
                 function(error) {alert("Error: \r\n"+error);},
                 "Echo",
                 "getmylongitude",
                 []
                 );
    //    alert(myla + "," +  mylo);
    
    
};

function onError(error) {
    alert('code: ' + error.code + '\n' + 'message: ' + error.message + '\n');
};







