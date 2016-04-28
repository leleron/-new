//
//  AppDelegate.m
//  Empty
//
//  Created by 李荣 on 15/5/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "ShopViewController.h"
#import "NativeShopViewController.h"
#import "DeviceViewController.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#import "TencentOAuth.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "UserInfo.h"
#import "ASIHTTPRequest.h"
#import "MyWebViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "NMBottomTabBarController.h"
#import "Reachability.h"
#import "UMessage.h"
#import "MainViewController.h"
#import "versonUpdateMock.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "ConfigNetViewController.h"
#import "messageReadMock.h"
#import "productDetailViewController.h"
@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,QUMockDelegate,CLLocationManagerDelegate>
{
    Reachability* reach;
}
@property(strong,nonatomic)versonUpdateMock* myMock;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CLLocation *checkinLocation;
@property(strong,nonatomic)UIAlertController* alert;
@property(strong,nonatomic)messageReadMock* myreadMock;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;    //修改为白色状态栏
    [self versionUpdate];   //检测版本更新
    [self createMainView];    //显示主页
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoShop) name:@"gotoShop" object:nil];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SinaAppKey];
    [WXApi registerApp:WXAPPKey];
    //友盟SDK
    [UMessage startWithAppkey:YMAPPKey launchOptions:launchOptions];
//    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerYouMeng) name:@"loginSuccess" object:nil];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(IOS8_OR_LATER)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
    [self getUserLocation];
    
    [self checkNetwork];
    
    
    return YES;
}



-(void)checkNetwork{
     reach = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    
    [reach startNotifier];

}

-(void)netWorkStatusChanged:(NSNotification*)notification{
    Reachability *verifyConnection = [notification object];
    NetworkStatus netStatus = [verifyConnection currentReachabilityStatus];
    if (netStatus == NotReachable) {
        self.alert = [UIAlertController alertControllerWithTitle:@"没有网络" message:@"请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=AIRPLANE_MODE"]];
            [self.alert dismissViewControllerAnimated:YES completion:nil];
        }];
        //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [self.alert addAction:cancelAction];
        //        [self.alert addAction:okAction];
        [self.topController presentViewController:self.alert animated:YES completion:^{
            
            //            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    if ([self.topController isKindOfClass:[ConfigNetViewController class]]) {
        if (netStatus != ReachableViaWiFi) {
            [WpCommonFunction showNotifyHUDAtViewBottom:self.topController.view withErrorMessage:@"请先连接WIFI"];
        }
    }

}



-(void)getUserLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.distanceFilter = 10;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无法进行定位操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    if (IOS8_OR_LATER) {
        [self.locManager requestAlwaysAuthorization];//添加这句
    }else{
        
    }
    [self.locManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.checkinLocation = [locations lastObject];
    CLLocationCoordinate2D cool = self.checkinLocation.coordinate;
    self.currentLatitude  = [NSString stringWithFormat:@"%.4f",cool.latitude];
    self.currentLongitude = [NSString stringWithFormat:@"%.4f",cool.longitude];
    NSLog(@"%@,%@",self.currentLatitude,self.currentLongitude);
    [self.locManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

-(void)versionUpdate{
    self.myMock = [versonUpdateMock mock];
    self.myMock.delegate = self;
    versonUpdateParam* param = [versonUpdateParam param];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    param.CURRENTVERSION = app_Version;
    param.APPTYPE = @"jiadian_ios";
    [self.myMock run:param];
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[versonUpdateMock class]]) {
        versonEntity* e = (versonEntity*)entity;
        if ([e.status isEqualToString:@"NEW"]) {
            NSString* url = [e.theVerson objectForKey:@"downloadUrl"];
            //            WpCommonFunction
            //            NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
            //         NSDictionary* dic = [WpCommonFunction toArrayOrNSDictionary:data];
            //            NSString* url = [dic objectForKey:@"downloadUrl"];
            UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"升级" message:@"发现新版本" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }];
            UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
                
                [controller dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [controller addAction:action1];
            [controller addAction:action2];
            [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
        }
    }
}



-(void)createMainView{
    NSMutableArray *itemViewControllers = [NSMutableArray arrayWithCapacity:3];
    _nmtabBarController = [[NMBottomTabBarController alloc] init];
    self.window.rootViewController = _nmtabBarController;
    DeviceViewController* controller1 = [[DeviceViewController alloc]initWithNibName:@"DeviceViewController" bundle:nil];
//        productDetailViewController *controller1 = [[productDetailViewController alloc] initWithNibName:@"productDetailViewController" bundle:nil];
    UINavigationController* nav1 = [[UINavigationController alloc]initWithRootViewController:controller1];
    [itemViewControllers addObject:nav1];
//    NativeShopViewController* controller2 = [[NativeShopViewController alloc]initWithNibName:@"NativeShopController" bundle:nil];
    MainViewController* controller2 = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    
//    UINavigationController* nav2 = [[UINavigationController alloc]initWithRootViewController:controller2];
//    nav2.navigationBar.barTintColor = Color_Bg_cellldarkblue;
    [itemViewControllers addObject:controller2];
    UserViewController* controller4 = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    UINavigationController* nav4 = [[UINavigationController alloc]initWithRootViewController:controller4];
//    nav4.navigationBar.barTintColor = Color_Bg_cellldarkblue;
    [itemViewControllers addObject:nav4];
    
    _nmtabBarController.controllers = itemViewControllers;
    _nmtabBarController.delegate = self;
    [_nmtabBarController.tabBar configureTabAtIndex:0 andTitleOrientation :kTItleToBottomOfIcon  withUnselectedBackgroundImage:[UIImage imageNamed:@"unselected.jpeg"] selectedBackgroundImage:[UIImage imageNamed:@"icon-sb-sel"] iconImage:[UIImage imageNamed:@"icon-sb"]  andText:@"我的设备"andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    [_nmtabBarController.tabBar configureTabAtIndex:1 andTitleOrientation : kTItleToBottomOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"unselected.jpeg"] selectedBackgroundImage:[UIImage imageNamed:@"icon-sc-sel"] iconImage:[UIImage imageNamed:@"icon-sc"]  andText:@"飞科商城" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    [_nmtabBarController.tabBar configureTabAtIndex:2 andTitleOrientation : kTItleToBottomOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"unselected.jpeg"] selectedBackgroundImage:[UIImage imageNamed:@"icon-wd-sel"] iconImage:[UIImage imageNamed:@"icon-wd"]  andText:@"个人中心" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    //
    [_nmtabBarController selectTabAtIndex:0];

}

-(void)gotoShop{
    [_nmtabBarController.tabBar setTabSelectedWithIndex:1];
}

#pragma mark  UMDelegate

-(void)registerYouMeng{
    UserInfo* u = [UserInfo restore];
    [UMessage addAlias:[NSString stringWithFormat:@"flyco%@",u.userid] type:@"Flyco" response:^(id responseObject, NSError *error) {
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken success");
    
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    NSDictionary* alert = [userInfo valueForKey:@"aps"];
    NSDictionary* alertContent = [alert valueForKey:@"alert"];
    NSString* content= [alertContent valueForKey:@"content"];
    NSString* messageId = [alertContent valueForKey:@"messageId"];
//    self.messageReadMock.operationType = [NSString stringWithFormat:@"/devices/messages/read/%@?tokenId=%@",messageId,info.tokenID];

    
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:content message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        
        if (messageId) {
            self.myreadMock = [messageReadMock mock];
            self.myreadMock.delegate = self;
            UserInfo* info = [UserInfo restore];
            messageReadParam *readParam = [messageReadParam param];
            readParam.TOKENID = info.tokenID;
            readParam.MESSAGEID = messageId;
            [self.myreadMock run:readParam];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDeviceTable" object:nil];
        if (![self.topController isKindOfClass:[DeviceViewController class]]) {
            [self.topController.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [controller addAction:action1];
    [self.topController presentViewController:controller animated:YES completion:nil];
}

-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    NSString *error_str = [NSString stringWithFormat: @"%@", err];
    NSLog(@"Failed to get token, error:%@", error_str);
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([self.login_type isEqualToString: LOGIN_QQ]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    if ([self.login_type isEqualToString: LOGIN_WEIBO]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if ([self.login_type isEqualToString: LOGIN_WECHAT]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([self.login_type isEqualToString: LOGIN_QQ]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    if ([self.login_type isEqualToString: LOGIN_WEIBO]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    if ([self.login_type isEqualToString: LOGIN_WECHAT]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma weiboSDKDelegate
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    UserInfo* myUserInfo = [UserInfo restore];
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WBAuthorizeResponse* resp = (WBAuthorizeResponse*)response;
        if (!myUserInfo) {
            UserInfo* myUserInfo = [[UserInfo alloc]init];
            [myUserInfo store];
        }
        myUserInfo = [UserInfo restore];
        myUserInfo.wbUserID = resp.userID;
        myUserInfo.wbTokenID = resp.accessToken;
        [myUserInfo store];
        [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_WB_SUCCESS object:nil];
    }
    //    myUserInfo.
    //    myUserInfo.wbUserID = response.userInfo objectForKey:(nonnull id)
}


-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

#pragma mark 微信delegate

-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* request = (SendAuthResp*)resp;
        NSString* code = request.code;
        NSString* oldCode = [[NSUserDefaults standardUserDefaults]valueForKey:WXCode];
        if (oldCode) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:WXCode];
        }
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:WXCode];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (code) {
            [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_WX_SUCCESS object:nil];
            //            iOSPlugins* plugins = [iOSPlugins sharePlugins];
            //            [plugins getWXUserInfo];
            
        }
        
        //        ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:nil];
        
        
    } else if ([resp isKindOfClass:[PayResp class]]) {
        [self.plugins wxpayCallBack:resp];
    }
    
        //        ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:nil];
        
        
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if ([self.topController isKindOfClass:[ConfigNetViewController class]]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Get_WIFI" object:nil];

//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

@end
