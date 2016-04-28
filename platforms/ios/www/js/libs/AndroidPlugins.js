//SmartLinkConnect
function sConnect(ssid, spwd, successFunc, errorFunc) {
    window.plugins.SmartLinkConnect.Push2Dvc(ssid, spwd, successFunc, errorFunc);
}
//EspressifConnect
function eConnect(ssid, spwd, successFunc, errorFunc) {
    window.plugins.EspressifConnect.Push2Dvc(ssid, spwd, successFunc, errorFunc);
}
//EasyLinkeConnect
function easylinkConnect(ssid, spwd, successFunc, errorFunc) {
	window.plugins.EasyLinkConnect.Push2Dvc(ssid, spwd, successFunc, errorFunc);
}
//wifiinfo
function getssid(successFunc, errorFunc) {
    window.wifi.message(successFunc, errorFunc);
}
//Isfirst
function isFirst(successFunc, errorFunc) {
    window.plugins.IsFirst.isfirst(successFunc, errorFunc);
}
//barcodesscanner
function qRcodeScanner(successFunc, errorFunc) {
    window.plugins.CodeScan.codeScan(successFunc, errorFunc);
}
//FromCameraScanner
function imageQRcodeScanner(successFunc, errorFunc) {
    navigator.camera.getPicture(successFunc, errorFunc, {
        quality: 50,
        sourceType: Camera.PictureSourceType.QRCODE,
        destinationType: Camera.DestinationType.DATA_URL
    });
};

function getPictureFromCameraAsFileURI(successFunc, errorFunc) {
    navigator.camera.getPicture(successFunc, errorFunc, {
        quality: 50,
        destinationType: Camera.DestinationType.DATA_URL,
        sourceType: Camera.PictureSourceType.CAMERA,
        targetWidth: 1280,
        targetHeight: 1280,
        encodingType: Camera.EncodingType.JPEG,
        mediaType: Camera.MediaType.PICTURE,
        allowEdit: false,
        cameraDirection: Camera.Direction.BACK
    });
};

function getPictureFromLibAsFileURI(successFunc, errorFunc) {
    navigator.camera.getPicture(successFunc, errorFunc, {
        quality: 50,
        destinationType: Camera.DestinationType.DATA_URL,
        sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
        targetWidth: 1280,
        targetHeight: 1280,
        encodingType: Camera.EncodingType.JPEG,
        mediaType: Camera.MediaType.PICTURE,
        allowEdit: false,
        cameraDirection: Camera.Direction.BACK
    });
}

//
function imageRcodeScanner(successFunc, errorFunc) {
    window.plugins.PicOperate.takePhoto(successFunc, errorFunc);
}
function getPictureFromCamera(successFunc, errorFunc) {
    window.plugins.PicOperate.takeCamra(successFunc, errorFunc);
}
//ThirdLogin
function qqLogin(successFunc, errorFunc) {
    window.plugins.ThirdLogin.qqLogin(successFunc, errorFunc);
}
function wxLogin(successFunc, errorFunc) {
    window.plugins.ThirdLogin.wxLogin(successFunc, errorFunc);
}
function jdLogin(successFunc, errorFunc) {
    window.plugins.ThirdLogin.jdLogin(successFunc, errorFunc);
}
//FileOperate
function savePicture(bitmap, successFunc, errorFunc) {
    window.plugins.FileOperate.savepng(bitmap, successFunc, errorFunc);
}
//Baidushare
function share(title, content, imgurl, successFunc, errorFunc) {
    window.plugins.Baidushare.bdshare(title, content, "", imgurl, successFunc, errorFunc);
}
//alipay
function alipay(successFunc, errorFunc, trade_no, order_no, total_fee) {
    window.plugins.Alipay.alipay(successFunc, errorFunc, trade_no, order_no, total_fee);
}
//alipay share 
function alipayshare(successFunc, errorFunc) {
    window.plugins.Alipay.share(successFunc, errorFunc);
}
//wxpay
function wxpay(successFunc,errorFunc,trade_no,order_no,total_fee){
	window.plugins.Wxpay.wxpay(successFunc,errorFunc,trade_no,order_no,total_fee);
}
//Unionpay
function unionpay(successFunc, errorFunc, trade_no, order_no, total_fee) {
    window.plugins.Unionpay.unionpay(successFunc, errorFunc, trade_no, order_no, total_fee);
}
