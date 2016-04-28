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

function wbLogin(successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "wbLogin",
                 []
                 );
};

function GetPicture(successfunc,errorfunc)
{
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "getPicture",
                 []
                 );
};


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
function getPictureFromLibAsFileURI(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "GetPicture",
                 "getPicture",
                 ['Album']
                 );
};
//【从相册获取图片的插件】-------------------------

//【通过摄像头获取图片的插件】-------------------------
function getPictureFromCameraAsFileURI(successFunc,errorFunc){
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

//alipay
function alipay(successFunc, errorFunc, trade_no, order_no, total_fee) {
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "alipay",
                 [trade_no,order_no,total_fee]
                 );
}
//wxpay
function wxpay(successFunc,errorFunc,trade_no,order_no,total_fee){
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "wxpay",
                 [trade_no,order_no,total_fee]
                 );
}
//Unionpay
function unionpay(successFunc, errorFunc, trade_no, order_no, total_fee) {
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "unionpay",
                 [trade_no,order_no,total_fee]
                 );
}

function getNetworkState(successFunc,errorFunc){
    cordova.exec(successfunc,
                 errorfunc,
                 "iOSPlugins",
                 "netWork"
                 );
    
}



function GetLoginInfo(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "GetLoginInfo"
                 );
    
}

function hideTabBar(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "hideTabBar"
                 );
}

function showTabBar(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "showTabBar"
                 );
    
}

function showLoginController(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "showLoginController"
                 );
}


function showKefu(successFunc,errorFunc){
    cordova.exec(successFunc,
                 errorFunc,
                 "iOSPlugins",
                 "showKefu"
                 );
}




