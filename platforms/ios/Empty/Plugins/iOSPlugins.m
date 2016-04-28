//
//  iOSPlugins.m
//  飞科智能家电
//
//  Created by duye on 15/5/26.
//
//

#import "iOSPlugins.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "WXAccessTokenMock.h"
#import "WXUserInfoMock.h"
#import "WXUpdateTokenMock.h"
#import "MainViewController.h"
#import "ZYQAssetPickerController.h"
#import "Reachability.h"
#import "MyWebViewController.h"
static iOSPlugins* myPlugins = nil;

@interface iOSPlugins()<TencentSessionDelegate,WBHttpRequestDelegate,WXApiDelegate,WeiboSDKDelegate,ZYQAssetPickerControllerDelegate>
{
    BOOL Send;
    NSString* _wifiName;
    unsigned int ip;
    const char *SSID;
    const char *PWD;
    const char *KEY;
    NSTimer *Send_cooee;
    NSMutableArray *_searchResultArray;
    NSInteger timecount;
    NSTimer*  _timer;
    UINavigationController* kefuViewController;
    CDVInvokedUrlCommand* wxpayCommand;
    CDVInvokedUrlCommand* unionpayCommand;
    CDVInvokedUrlCommand* wbCommand;
    CDVInvokedUrlCommand* qqCommand;
    CDVInvokedUrlCommand* wxCommand;
    CDVInvokedUrlCommand* picCommand;
}
@property(strong,nonatomic)TencentOAuth* tencentOAuth;
@property(strong,nonatomic)NSArray* permissions;
@property(strong,nonatomic)WXAccessTokenMock* myWXTokenMock;    //获取微信token
@property(strong,nonatomic)WXUserInfoMock* myWXUserInfoMock;   //获取微信用户信息
@property(strong,nonatomic)WXUpdateTokenMock* myWXupdateMock;  //刷新微信token
@property(strong,nonatomic)WBAuthorizeRequest* request;

@end
@implementation iOSPlugins

+(iOSPlugins*)sharePlugins{
    if (!myPlugins) {
        myPlugins = [[iOSPlugins alloc]init];
    }
    return myPlugins;
}

- (MainViewController *)getMainViewController{
    if (!mainViewController) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        mainViewController = (MainViewController*)window.rootViewController;
    }
    return mainViewController;
}




//【扫一扫二维码】-----------------------------------------------------------------------------

#pragma mark QQ登陆delelgate


//图片保存至本地
- (void)savePicture:(CDVInvokedUrlCommand*)command{
    [self.commandDelegate runInBackground:^{
        savPicCommand = command;
        NSString *encodedImageStr = [command.arguments objectAtIndex:0];
        NSURL *url = [NSURL URLWithString: encodedImageStr];
        NSData *data = [NSData dataWithContentsOfURL: url];
        UIImage* image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    CDVPluginResult* pluginResult;
    if (!error) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"成功保存到相册"];
    }else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error description]];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:savPicCommand.callbackId];
}


-(void)GetLoginInfo:(CDVInvokedUrlCommand*)command{
    
    
    [self.commandDelegate runInBackground:^{
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        
        UserInfo* myUserInfo = [UserInfo restore];
        if (myUserInfo.tokenID) {
            
            NSString* nickName = myUserInfo.nickName;
            if (!myUserInfo.nickName) {
                nickName = myUserInfo.phoneNum;
            }
                dict = [NSMutableDictionary dictionaryWithObjects:@[nickName,myUserInfo.tokenID,myUserInfo.userLoginType,myUserInfo.userName] forKeys:@[@"realName",@"tokenId",@"loginType",@"userName"]];
            
            if (myUserInfo.phoneNum) {
                [dict setObject:myUserInfo.phoneNum forKey:@"Mobile"];
            }
        }
        
        //    NSDictionary* dict2 = [NSDictionary dictionaryWithObject:dict forKey:@"FLX_USER"];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    
}

-(void)hideTabBar:(CDVInvokedUrlCommand*)command{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"hideTabBar" object:nil];
//    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    [WpCommonFunction hideTabBar];
    
}

-(void)showTabBar:(CDVInvokedUrlCommand*)command{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTabBar" object:nil];
    [WpCommonFunction showTabBar];

}


-(void)showLoginController:(CDVInvokedUrlCommand*)command{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showLoginController" object:nil];
}


-(void)IndexJump:(CDVInvokedUrlCommand*)command{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpShop" object:nil];
}


-(void)showBuyCount:(CDVInvokedUrlCommand*)command{
    NSString *count = [command.arguments objectAtIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showBuyCount" object:count];
}

-(void)loginWithQQ:(CDVInvokedUrlCommand*)command{
    //    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    delegate.login_type = LOGIN_QQ;
    //    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPKey andDelegate:self];
    //    _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    //    [_tencentOAuth authorize:_permissions inSafari:NO];
    
}

- (void)wxpay:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    wxpayCommand = command;
    AppDelegate *ap = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ap.login_type = LOGIN_WECHAT;
    ap.plugins = self;
    [WXApi registerApp:WXAPPKey withDescription:@"demo 2.0"];
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        NSString *out_trade_no = [command.arguments objectAtIndex:0];
        NSString *order_sn = [command.arguments objectAtIndex:1];
        NSString *order_amount = [command.arguments objectAtIndex:2];
        NSDictionary *requestBody_dic = @{@"order_sn":order_sn,@"out_trade_no":out_trade_no,@"order_amount":order_amount};
        NSLog(@"-----------%@-----------",requestBody_dic);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestBody_dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *requestBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",requestBody);
        NSString *url = weixinpay_url;
        //将请求的url数据放到NSData对象中
        NSData *response = [WXUtil httpSend:url method:@"POST" data:requestBody];
        NSError *error;
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        if(dict == nil){
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-99",@"message":@"未知错误，支付失败"}];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:wxpayCommand.callbackId];
        }else{
            NSLog(@"%@",dict);
            NSLog(@"%@",[dict objectForKey:@"message"]);
            NSMutableString *status = [dict objectForKey:@"status"];
            NSDictionary *data = [dict objectForKey:@"data"];
            if ([status isEqualToString:@"SUCCESS"]){
                NSLog(@"%@",data);
                //            [self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
                NSMutableString *stamp  = [data objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [data objectForKey:@"appid"];
                req.partnerId           = [data objectForKey:@"partnerid"];
                req.prepayId            = [data objectForKey:@"prepayid"];
                req.nonceStr            = [data objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [data objectForKey:@"package"];
                req.sign                = [data objectForKey:@"sign"];
                
                [WXApi sendReq:req];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-99",@"message":@"未知错误，支付失败"}];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:wxpayCommand.callbackId];
            }
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-3",@"message":@"微信未安装或者版本过低"}];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:wxpayCommand.callbackId];
    }
}

- (void)alipay:(CDVInvokedUrlCommand*)command{
    AppDelegate *ap = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    ap.plugins = self;
    ap.login_type = PAY_ALI;
    /*
     *从服务器获取签名信息
     */
    NSString *out_trade_no = [command.arguments objectAtIndex:0];
    NSString *order_sn = [command.arguments objectAtIndex:1];
    NSString *order_amount = [command.arguments objectAtIndex:2];
    NSDictionary *requestBody_dic = @{@"order_sn":order_sn,@"out_trade_no":out_trade_no,@"order_amount":order_amount};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestBody_dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *requestBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",requestBody);
    NSString *url = alipay_url;
    //将请求的url数据放到NSData对象中
    NSData *response = [WXUtil httpSend:url method:@"POST" data:requestBody];
    NSError *error;
    NSMutableDictionary *dict = NULL;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",dict);
    NSLog(@"%@",[dict objectForKey:@"message"]);
    if(dict == nil){
        NSLog(@"dict is nil!!!!!");
    }else{
        NSMutableString *status = [dict objectForKey:@"status"];
        NSDictionary *data = [dict objectForKey:@"data"];
        if ([status isEqualToString:@"SUCCESS"]) {
            NSString *orderSpec = [data objectForKey:@"para_string"];
            NSString *privateKey = [data objectForKey:@"key_string"];
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"FKZN";
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                NSLog(@"%@",orderString);
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    CDVPluginResult* pluginResult = nil;
                    NSLog(@"==========================alipayCallBack");
                    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                    NSLog(@"%@",resultStatus);
                    NSString *memo = [resultDic objectForKey:@"memo"];
                    if ([resultStatus isEqualToString:@"9000"]) {
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"SUCCESS",@"code":resultStatus,@"message":memo}];
                    }else{
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":resultStatus,@"message":memo}];
                    }
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }];
            }
        } else {
            NSLog(@"没获得到数据");
        }
    }
}

- (void)wxpayCallBack:(BaseResp*)resp{
    CDVPluginResult* pluginResult = nil;
    PayResp *response = (PayResp *)resp;
    switch (response.errCode) {
        case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"SUCCESS",@"code":@"0",@"message":@"支付成功"}];
            
            break;
        case WXErrCodeCommon:
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-1",@"message":@"支付失败"}];
            break;
        case WXErrCodeUserCancel:
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-2",@"message":@"支付取消"}];
            break;
        default:
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-99",@"message":@"未知错误，支付失败"}];
            break;
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:wxpayCommand.callbackId];
}

- (void)unionpay:(CDVInvokedUrlCommand*)command{
    unionpayCommand = command;
    NSString *out_trade_no = [command.arguments objectAtIndex:0];
    NSString *order_sn = [command.arguments objectAtIndex:1];
    NSString *order_amount = [command.arguments objectAtIndex:2];
    NSDictionary *requestBody_dic = @{@"order_sn":order_sn,@"out_trade_no":out_trade_no,@"order_amount":order_amount};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestBody_dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *requestBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"requestBody = %@",requestBody);
    NSString *url = unionpay_url;
    //将请求的url数据放到NSData对象中
    NSData *response = [WXUtil httpSend:url method:@"POST" data:requestBody];
    NSError *error;
    NSMutableDictionary *dict = NULL;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",dict);
    NSLog(@"message = %@",[dict objectForKey:@"message"]);
    if (dict != nil) {
        if ([[dict objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            NSDictionary *data = [dict objectForKey:@"data"];
            [UPPayPlugin startPay:[data objectForKey:@"tn"] mode:@"00" viewController:[self getMainViewController] delegate:self];
        } else {
            NSLog(@"请求失败");
        }
    } else {
        NSLog(@"请求结果为空");
    }
}

-(void)UPPayPluginResult:(NSString*)result{
    CDVPluginResult* pluginResult = nil;
    if ([result isEqualToString:@"success"]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"SUCCESS",@"code":@"0",@"message":@"支付成功"}];
    } else if ([result isEqualToString:@"fail"]){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-1",@"message":@"支付失败"}];
    } else if ([result isEqualToString:@"cancel"]){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-2",@"message":@"支付取消"}];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"status":@"FAILURE",@"code":@"-99",@"message":@"未知错误，支付失败"}];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:unionpayCommand.callbackId];
}


-(void)getPicture:(CDVInvokedUrlCommand *)command{
    picCommand = command;
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    MainViewController* controller = [self getMainViewController];
    [controller presentViewController:picker animated:YES completion:NULL];
    
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSData *data = UIImageJPEGRepresentation(tempImg,1.0);
        NSString* dataStr= [WpCommonFunction transformImageDataToBase64String:data];
        [array addObject:dataStr];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:picCommand.callbackId];
    
    //    });
}


-(void)netWork:(CDVInvokedUrlCommand *)command{
    int network = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:network];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


-(void)showKefu:(CDVInvokedUrlCommand *)command{
    UserInfo* u = [UserInfo restore];
    MyWebViewController* controller = [MyWebViewController controllerWithUrl:[NSString stringWithFormat:@"http://kf2.flyco.net.cn/new/client.php?m=Mobile&arg=admin&tokenId=%@",u.tokenID]];
//    [controller showLeftNormalButton:@"go_back" highLightImage:@"go_back" selector:@selector(dismissController)];

//    UIImage* normalImage = [UIImage imageNamed:@"go_back"];
//    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:normalImage forState:UIControlStateNormal];
//    backButton.frame = CGRectMake(20.f, 0, normalImage.size.width, normalImage.size.height);
//    [backButton addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
//    [controller.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
    MainViewController* top = [self getMainViewController];
//    kefuViewController = top;
//    [top.navigationController pushViewController:controller animated:YES];
//    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:controller];
    [top presentViewController:controller animated:YES completion:nil];
    
}
//-(void)deleteUserInfo:(CDVInvokedUrlCommand *)command{
//
//    [UserInfo deleteData];
//    [[WHGlobalHelper shareGlobalHelper]removeByKey:@"login"];
//}

//-(void)dismissController{
//    [kefuViewController dismissViewControllerAnimated:YES completion:nil];
//}
@end











