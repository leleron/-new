//
//  FKConnectNetViewController.m
//  Empty
//
//  Created by leron on 15/8/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKConnectNetViewController.h"
#import <stdio.h>
#import "cooee.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CoreLocation/CoreLocation.h>
#import "KVSearchController.h"

#import "RJONE_LibCallBack.h"
#import "CamObj.h"
#import "GSetting.h"

#import "SQLSingle.h"
#import "FMDatabaseAdditions.h"
#import "addDeviceMock.h"
#import "WToast.h"
#import "UserInfo.h"

#import "AsyncSocket.h"

#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"
#import "AirCleanerViewController.h"
#import "DeviceViewController.h"
#import "DDProgressView.h"
#import "RegardingDeviceMock.h"
#import "EASYLINK.h"
#import "resetWifiMock.h"
@class ConfigNetViewController;
typedef enum{
    ORDER_FIRST,
    ORDER_SECOND,
    ORDER_THIRD
}ORDER_TYPE;

@interface FKConnectNetViewController ()<CLLocationManagerDelegate,AsyncSocketDelegate,EasyLinkFTCDelegate>{
    const char *PWD;
    const char *SSID;
    const char *KEY;
    unsigned int ip;
    NSTimer *Send_cooee;
    NSInteger timerNum;
    BOOL Send;
    AsyncSocket *asyncSocket;
    AsyncSocket* asyncSocket1;
    AsyncSocket* asyncSocket2;
    ConnectionManager *c;
    NSString* macId;
    NSString* easyLink_ip;
    float latitude;
    float longitude;
    NSString* machineType;
    NSString* MachineIP;
    EASYLINK *easylink_config;
    UIAlertView *alert;
    ORDER_TYPE order_type;
    int count;
    float testProgress;
    int progressDir;
    DDProgressView *progressView2 ;
    NSTimer *progressTimer;
    addDeviceParam* param;
}
@property (weak, nonatomic) IBOutlet UIImageView *point1;
@property (weak, nonatomic) IBOutlet UIImageView *point2;
@property (weak, nonatomic) IBOutlet UIImageView *point3;
@property (weak, nonatomic) IBOutlet UIImageView *point4;
@property(strong,nonatomic)addDeviceMock* myAddMock;
@property(strong,nonatomic)addDeviceParam* myAddParam;
@property(strong,nonatomic)RegardingDeviceMock* regardMock;
@property(strong,nonatomic)RegardingDeviceParam* regardParam;
@property(strong,nonatomic)resetWifiMock* resetMock;
@property(strong,nonatomic)resetWifiParam* resetParam;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnAgain;
@property (weak, nonatomic) IBOutlet UIView *viewCha;

@property(strong,nonatomic)CLLocationManager* locManager;
// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;

@end

@implementation FKConnectNetViewController

int num;
SEARCH_CALL_RESP * pSearch;

- (void)viewDidLoad {
    self.navigationBarTitle = @"正在连接";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"Wifi connect");
        Send = false;
        NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
        id info = nil;
        for (NSString *ifnam in ifs) {
            info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            if(info && [info count]){
                break;
            }
        }
        
    }
    else{
        NSLog(@"No Wifi");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Wi-Fi not connected , abort"
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil, nil];
        [alert show] ;
        
    }
    self.viewCha.hidden = YES;
    [self.btnCancel addTarget:self action:@selector(cancelConnect) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAgain addTarget:self action:@selector(backWifi) forControlEvents:UIControlEventTouchUpInside];
    self.btnCancel.hidden = YES;
    self.btnAgain.hidden = YES;
    [WpCommonFunction setView:self.btnAgain cornerRadius:8];
    self.navigationItem.hidesBackButton = YES;
    count = 0;
    
    progressView2 = [[DDProgressView alloc] initWithFrame: CGRectMake(50.0f, 150.0f, SCREEN_WIDTH-100.0f, 0.0f)] ;
    [progressView2 setOuterColor: [UIColor clearColor]] ;
    [progressView2 setInnerColor: [UIColor colorWithRed:0 green:135/255.0 blue:237/255.0 alpha:1]] ;
    [progressView2 setEmptyColor: [UIColor colorWithRed:0 green:60/255.0 blue:123/255.0 alpha:1]] ;
    [self.view addSubview: progressView2] ;
//    [progressView2 release] ;
    testProgress = 0.0f;
    progressDir = 1;
    // set a timer that updates the progress
//    progressTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3f target: self selector: @selector(updateProgress) userInfo: nil repeats: YES] ;
//    [progressTimer fire] ;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initQuickMock{
    self.resetMock = [resetWifiMock mock];
    self.resetMock.delegate = self;
    self.resetParam = [resetWifiParam param];
    UserInfo* user = [UserInfo restore];
    self.resetParam.TOKENID = user.tokenID;
    param = [addDeviceParam param];
}

-(void)viewDidAppear:(BOOL)animated{
    [self connect];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[ConnectionManager sharedConnectionManager] ESPConnectClose];
    [asyncSocket disconnect];
    [asyncSocket1 disconnect];
    [asyncSocket2 disconnect];
    asyncSocket = nil;
    asyncSocket1 = nil;
    asyncSocket2 = nil;
}


-(void)backWifi{
    for (UIViewController* item in self.navigationController.childViewControllers) {
        if ([item isKindOfClass:[ConfigNetViewController class]]) {
            [self.navigationController popToViewController:item animated:YES];
        }
    }
}

- (void)updateProgress
{
    testProgress += (0.005f * progressDir) ;
    [progressView2 setProgress: testProgress] ;
    
    if (testProgress > 1 || testProgress < 0)
//        progressDir *= -1 ;
        [progressTimer invalidate];
}
-(void)stopProgress{
    testProgress = 1;
    [self updateProgress];
    [progressTimer invalidate];
    progressTimer = nil;
}

-(void)cancelConnect{
    [[ConnectionManager sharedConnectionManager] ESPConnectClose];
//    [self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[DeviceViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}
-(void)connect{
    testProgress = 0.0f;
    progressTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3f target: self selector: @selector(updateProgress) userInfo: nil repeats: YES] ;
    [progressTimer fire] ;
    self.viewCha.hidden = YES;
    self.btnCancel.hidden = YES;
    self.btnAgain.hidden = YES;
    self.lblStatus.text = @"正在连接网络";
    Send = !Send;
    Send_cooee = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerNum) userInfo:nil repeats:YES];
    NSArray* arrayModel;
    if (self.productModel) {
        arrayModel = [self.productModel componentsSeparatedByString:@";"];
    }
    
    if (([self.vendor isEqualToString:@"3"] && [self.model isEqualToString:@"1"]) || [arrayModel indexOfObject:@"31"]!= NSNotFound || [self.productCode isEqualToString:@"9001"]) {    //空气净化器配网方案   乐鑫配网
        c = [ConnectionManager sharedConnectionManager];
        c.delegate = self;
        c.apPwd = _psw;
        [c ESPConnectStart];
        MachineIP = c.ip;
    }
     if (([self.vendor isEqualToString:@"2"] && [self.model isEqualToString:@"1"]) || [arrayModel indexOfObject:@"21"]!= NSNotFound){
        
        [self easyLinkConfig];
        
    }
    
    else {      //扫地机器人配网方案
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            pSearch = RJONE_LibOneKey(60, 60, &num);
            
            if (num>0)
            {
                NSLog(@"当前搜索到的设备数目:%d\n",num);
                [Send_cooee invalidate];
                NSString *nsDID;
                CHAR prefix[64], number[64], checkCode[64], Result[64];
                
                nsDID=[NSString stringWithFormat:@"%s", pSearch[0].dev_id];
                
                CamObj* cam = [self isExist:nsDID];
                if (cam) {             //已经存在，说明只是重置网络
                    [self stopProgress];
                    const char* newPsw = [cam.nsViewPwd UTF8String];
                    const char* oldPsw = [@"88888888" UTF8String];
                    [cam Rjone_SetPassword:newPsw : oldPsw];
                    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"重新配网成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    
                    memset(prefix, 0, sizeof(prefix));
                    memset(number, 0, sizeof(number));
                    memset(checkCode, 0, sizeof(checkCode));
                    memset(Result, 0, sizeof(Result));
                    CamObj *camObj=[[CamObj alloc] init];
                    camObj.nsDID    = nsDID;
                    camObj.nsViewPwd  = @"88888888";
                    camObj.nsCamName=nsDID;
                    camObj.addedName = nsDID;
                    
                    self.myAddMock = [addDeviceMock mock];
                    self.myAddMock.delegate = self;
                    addDeviceParam* addparam = [addDeviceParam param];
                    UserInfo* myUserInfo = [UserInfo restore];
                    addparam.TOKENID = myUserInfo.tokenID;
                    addparam.NICKNAME = camObj.nsDID;
                    addparam.GROUP = @"1";
                    addparam.LATITUDE = @"121.406586";
                    addparam.LONGITUDE = @"31.204065";
                    addparam.MACADDRESS = self.macId;
                    addparam.SN = self.macId;
                    
                    addparam.PRODUCTCODE = @"9605";
                    addparam.PASSWORD = @"88888888";
                    [[ViewControllerManager sharedManager]showWaitView:self.view];
                    [self.myAddMock run:addparam];
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    pSearch = nil;
//                    [WToast showWithText:@"配置失败,未发现设备"];
                    Send = NO;
                    [Send_cooee invalidate];
                    return;
                });
                
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            while (Send)
            {
                PWD = [self.psw UTF8String];
                SSID = [self.wifiName  UTF8String];
                KEY = [@"" UTF8String];
                struct in_addr addr;
                inet_aton([[self getIPAddress] UTF8String], &addr);
                ip = CFSwapInt32BigToHost(ntohl(addr.s_addr));
                send_cooee(SSID, (int)strlen(SSID), PWD, (int)strlen(PWD), KEY, 0, ip);
                
            }
            
        });
    }
}

-(CamObj*)isExist:(NSString*)nsDID{
    NSDictionary* deviceData = [[WHGlobalHelper shareGlobalHelper]get:USER_DEVICE_DATA];
    for (NSObject* e in deviceData) {
        if ([e isKindOfClass:[CamObj class]]) {
            CamObj* cam = (CamObj*)e;
            if ([nsDID isEqualToString:cam.nsDID]) {
                return cam;
            }
        }
    }
    return nil;
}


#pragma quMockdelegate
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[addDeviceMock class]]) {
        if (([self.vendor isEqualToString:@"3"] && [self.model isEqualToString:@"1"]) || [self.productModel isEqualToString:@"31"]) {
            DeviceAddEntity* e = (DeviceAddEntity*)entity;
            if ([e.status isEqualToString:RESULT_SUCCESS]) {
                
                NSLog(@"deviceId = %@",e.deviceId);
                UserInfo* myUserInfo = [UserInfo restore];
                self.regardMock = [RegardingDeviceMock mock];
                self.regardMock.operationType = [NSString stringWithFormat:@"/devices/%@/regardingDevice?tokenId=%@",e.deviceId,myUserInfo.tokenID];
                self.regardMock.delegate = self;
                self.regardParam = [RegardingDeviceParam param];
                self.regardParam.sendMethod = @"GET";
                [self.regardMock run:self.regardParam];
                
                

            }
        } else {
            DeviceAddEntity* e = (DeviceAddEntity*)entity;
            if ([e.status isEqualToString:RESULT_SUCCESS]) {
                
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [WToast showWithText:@"发现了一个设备"];
                                   [easylink_config stopTransmitting];
                                   [easylink_config unInit];
                                   easylink_config = nil;
                                   [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                   [Send_cooee invalidate];
            
                               });
            }
        }
    }
    
    if ([mock isKindOfClass:[RegardingDeviceMock class]]) {
        RegardingDeviceEntity* e = (RegardingDeviceEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            if (e.DeviceInfo.count != 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
                
                [Send_cooee invalidate];
                [self stopProgress];
                UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"配网成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [controller addAction:action1];
                [self presentViewController:controller animated:YES completion:nil];

                
//                [self.navigationController popToRootViewControllerAnimated:YES];

            }
        }
    }
}
//30 计时
-(void)timerNum
{
    timerNum++;
    if (timerNum%4 == 1) {
        self.point1.image = [UIImage imageNamed:@"pointBlue"];
        self.point4.image = [UIImage imageNamed:@"point"];
    }
    if (timerNum%4 == 2) {
        self.point2.image = [UIImage imageNamed:@"pointBlue"];
        self.point1.image = [UIImage imageNamed:@"point"];
    }
    if (timerNum%4 == 3) {
        self.point3.image = [UIImage imageNamed:@"pointBlue"];
        self.point2.image = [UIImage imageNamed:@"point"];
    }
    if (timerNum%4 == 0) {
        self.point4.image = [UIImage imageNamed:@"pointBlue"];
        self.point3.image = [UIImage imageNamed:@"point"];
    }

//    NSLog(@" 等待时间:%d",(int)timerNum);
    if (timerNum>70 && easylink_config) {
        timerNum = 0;
        [Send_cooee invalidate];
        Send = NO;
        testProgress = 1;
        self.lblStatus.text = @"连接失败，请检查网络设置";
        [[ConnectionManager sharedConnectionManager] ESPConnectClose];
        if (easylink_config) {
            [easylink_config stopTransmitting];
            [easylink_config unInit];
            easylink_config = nil;
        }
        self.viewCha.hidden = NO;
        self.btnCancel.hidden = NO;
        self.btnAgain.hidden = NO;
    }
    
    if (timerNum > 140)
    {
        timerNum = 0;
        [Send_cooee invalidate];
        Send = NO;
        self.viewCha.hidden = NO;
//        [WToast showWithText:@"配置失败,没有发现设备"];
        self.lblStatus.text = @"连接失败，请检查网络设置";
        [[ConnectionManager sharedConnectionManager] ESPConnectClose];
        if (easylink_config) {
            [easylink_config stopTransmitting];
            [easylink_config unInit];
            easylink_config = nil;
        }
        self.btnAgain.hidden = NO;
        self.btnCancel.hidden = NO;
        if (asyncSocket2) {
            [asyncSocket2 disconnect];
            asyncSocket2 = nil;
        }
    }
}


- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//乐鑫回调
-(void)ESPCallBack:(BOOL)status result:(NSString*)mac{
    if (status) {
        NSLog(@"配网成功mac = %@",mac);
        _macId = mac;
        self.lblStatus.text = @"设备已成功连接网络，正在进行后续操作";
        [self getLocation];
//        [self addOperation:_macId];   //走添加设备流程
        param.PRODUCTMODEL = @"31";
        [self vertifyMacCode];   //验证机器码
    }else{
        timerNum = 0;
        [Send_cooee invalidate];
        Send = NO;
        self.viewCha.hidden = NO;
        self.lblStatus.text = @"连接失败，请检查网络设置";
        [[ConnectionManager sharedConnectionManager] ESPConnectClose];
        if (easylink_config) {
            [easylink_config stopTransmitting];
            [easylink_config unInit];
            easylink_config = nil;
        }
        self.btnAgain.hidden = NO;
        self.btnCancel.hidden = NO;
        testProgress = 1;
        [self updateProgress];
        [progressTimer invalidate];
    }
}

#pragma mark 获取经纬度
-(void)getLocation{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    latitude = [delegate.currentLatitude floatValue];
    longitude = [delegate.currentLongitude floatValue];

}


//获取定位失败回调方法
#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location error!");
}



-(void)addOperation:(NSString*)mac{
    self.myAddMock = [addDeviceMock mock];
    self.myAddMock.delegate = self;
    UserInfo* myUserInfo = [UserInfo restore];
    param.TOKENID = myUserInfo.tokenID;
    param.NICKNAME = mac;
    param.GROUP = @"1";
    
    param.LATITUDE = [NSString stringWithFormat:@"%f",latitude];
    param.LONGITUDE = [NSString stringWithFormat:@"%f",longitude];
    
    param.MACADDRESS = mac;
    param.SN = mac;
    param.PRODUCTCODE = self.productCode;
    [self.myAddMock run:param];

}

-(void)vertifyMacCode{
    count = 0;
    order_type = ORDER_FIRST;
    asyncSocket = [[AsyncSocket alloc ]initWithDelegate:self];
    NSError *err = nil;
    NSString* str = [NSString stringWithFormat:@"\"action_type\":\"authenticated_status\",\"mac_id\":\"%@\",\"action_status\":\"\",\"machine_type\":\"\"",_macId];
    NSString *host = c.ip;
    if (easyLink_ip) {
        host = easyLink_ip;
    }

    int port = 80;
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [NSThread sleepForTimeInterval:1.0f];
//    [asyncSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
    [asyncSocket connectToHost:host onPort:port error:nil];
    [asyncSocket writeData:data withTimeout:5 tag:0];
//    [asyncSocket disconnectAfterWriting];
    

}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port{
    NSLog(@"socket连接成功");
    [sock readDataWithTimeout:-1 tag:0];
    
    if (asyncSocket1) {
        [asyncSocket1 readDataWithTimeout:-1 tag:1];
    }
    if (asyncSocket2) {
        [asyncSocket2 readDataWithTimeout:-1 tag:1];
    }
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"已断开");
    if (order_type == ORDER_FIRST && count<5) {
        order_type = ORDER_FIRST;
//        if (asyncSocket) {
//            [asyncSocket disconnect];
//            asyncSocket = nil;
//        }
        asyncSocket = [[AsyncSocket alloc ]initWithDelegate:self];
        NSError *err = nil;
        NSString* str = [NSString stringWithFormat:@"\"action_type\":\"authenticated_status\",\"mac_id\":\"%@\",\"action_status\":\"\",\"machine_type\":\"\"",_macId];
        NSString *host = c.ip;
        if (easyLink_ip) {
            host = easyLink_ip;
        }
        
        int port = 80;
        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [NSThread sleepForTimeInterval:1.0f];
        count++;
        [asyncSocket connectToHost:host onPort:port error:nil];
        [asyncSocket writeData:data withTimeout:5 tag:0];
    }
    
    if (order_type == ORDER_SECOND) {
        NSString* str = [NSString stringWithFormat:@"\"action_type\":\"dev_status\",\"mac_id\":\"%@\",\"action_status\":\"\",\"machine_type\":\"\"",_macId];
    NSString *host = c.ip;
        if (easyLink_ip) {
            host = easyLink_ip;
        }
    int port = 80;
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//        if (asyncSocket2) {
//            [asyncSocket2 disconnect];
//            asyncSocket2 = nil;
//        }
        asyncSocket2 = [[AsyncSocket alloc ]initWithDelegate:self];
    [asyncSocket2 connectToHost:host onPort:port error:nil];
    [asyncSocket2 writeData:data withTimeout:5 tag:0];
    }
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    [sock readDataWithTimeout:-1 tag:0];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"NSString--------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
        if (jsonDict) {
            if ([[jsonDict objectForKey:@"action_status"] isEqualToString:@"authenticated"]) {
                [self checkMacId:_macId];
//                [self addOperation:_macId];
            }else{
                _macId = [jsonDict objectForKey:@"mac_id"];
                machineType = [jsonDict objectForKey:@"machine_type"];
                if ([self.productCode  isEqualToString:[jsonDict objectForKey:@"machine_type"]]) {    //机器码是对的
                    NSString* str = [NSString stringWithFormat:@"\"action_type\":\"machine_no\",\"mac_id\":\"%@\",\"action_status\":\"success\",\"machine_type\":\"\"",_macId];
                    NSString *host = c.ip;
                    if (easyLink_ip) {
                        host = easyLink_ip;
                    }
                    int port = 80;
                    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//                    if (asyncSocket1) {
//                        [asyncSocket1 disconnect];
//                        asyncSocket1 = nil;
//                    }
                    asyncSocket1 = [[AsyncSocket alloc ]initWithDelegate:self];
                    [asyncSocket1 connectToHost:host onPort:port error:nil];
                    [asyncSocket1 writeData:data withTimeout:5 tag:1];
                    order_type = ORDER_SECOND;
                    
                }else if(![[jsonDict objectForKey:@"action_type"] isEqualToString:@"wifi_connected"]){                                  //机器码是错的
                    NSString* str = [NSString stringWithFormat:@"\"action_type\":\"machine_no\",\"mac_id\":\"%@\",\"action_status\":\"fail\",\"machine_type\":\"\"",_macId];
                    NSString *host = MachineIP;
                    int port = 80;
                    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
                    [asyncSocket setDelegate:nil];
                    [asyncSocket disconnect];
                    asyncSocket = nil;
                    asyncSocket1 = [[AsyncSocket alloc ]initWithDelegate:self];
                    [asyncSocket1 connectToHost:host onPort:port error:nil];
                    [asyncSocket1 writeData:data withTimeout:5 tag:0];
                    
//                    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"此设备无效"];
                    order_type = ORDER_SECOND;
                }

            }
            if ([[jsonDict objectForKey:@"action_type"] isEqualToString:@"wifi_connected"] && [[jsonDict objectForKey:@"action_status"] isEqualToString:@"success"]) {  //设备联网成功
                
                [[ConnectionManager sharedConnectionManager] ESPConnectClose];
                [asyncSocket disconnect];
                [asyncSocket1 disconnect];
                [asyncSocket2 disconnect];
                
                [self addOperation:_macId];   //走添加设备流程
                NSLog(@"设备联网成功");
            }
            if ([[jsonDict objectForKey:@"action_type"] isEqualToString:@"dev_status"]) {
                NSString* type = [jsonDict objectForKey:@"action_status"];
                if ([type isEqualToString:@"mqtt_connected"]) {
                    NSLog(@"连接成功");
                    if (![self.isChongzhi isEqualToString:@"YES"]) {
                        [[ConnectionManager sharedConnectionManager] ESPConnectClose];
                        [asyncSocket disconnect];
                        [asyncSocket1 disconnect];
                        [asyncSocket2 disconnect];
                        [self addOperation:_macId];   //走添加设备流程
                    }else{
                        [self stopProgress];
                        [Send_cooee invalidate];
                        self.resetParam.MACADDRESS = _macId;
                        [self.resetMock run:self.resetParam];
                        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"重新配网成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }];
                        [controller addAction:action1];
                        [self presentViewController:controller animated:YES completion:nil];
                    }

                }
            }
        }
    
}

-(void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    NSLog(@"Received bytes: %lu",(unsigned long)partialLength);
}


#pragma mark - EasyLink delegate -

- (void)onFoundByFTC:(NSNumber *)ftcClientTag withConfiguration: (NSDictionary *)configDict
{
    NSLog(@"New device found!");
    self.lblStatus.text = @"设备已成功连接网络，正在进行后续操作";
    NSArray* array1 = [configDict objectForKey:@"C"];   //4 objects
    NSDictionary* dic1 = [array1 objectAtIndex:1];    // C 7 objects
    NSArray* array2 = [dic1 objectForKey:@"C"];    //  7个array
    NSDictionary* dic2 = [array2 objectAtIndex:3];
    NSString* ip = [dic2 objectForKey:@"C"];
    easyLink_ip = [NSString stringWithString:ip];
    
    [easylink_config configFTCClient:ftcClientTag
                   withConfiguration: [NSDictionary dictionary] ];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    param.PRODUCTMODEL = @"21";
    [self vertifyMacCode];
}

- (void)onDisconnectFromFTC:(NSNumber *)ftcClientTag
{
    NSLog(@"Device disconnected!");
//    timerNum = 0;
//    [Send_cooee invalidate];
//    Send = NO;
//    self.viewCha.hidden = NO;
//    self.lblStatus.text = @"连接失败，请检查网络设置";
//    [[ConnectionManager sharedConnectionManager] ESPConnectClose];
//    if (easylink_config) {
//        [easylink_config stopTransmitting];
//        [easylink_config unInit];
//        easylink_config = nil;
//    }
//    self.btnAgain.hidden = NO;
//    self.btnCancel.hidden = NO;
}

-(void)easyLinkConfig{
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:20];
    NSData *ssidData = [EASYLINK ssidDataForConnectedNetwork];
    NSString *ssidString = [EASYLINK ssidForConnectedNetwork];
    NSString *passwordString = self.psw;

    [wlanConfig setObject:ssidData forKey:KEY_SSID];
    [wlanConfig setObject:passwordString forKey:KEY_PASSWORD];
    [wlanConfig setObject:[NSNumber numberWithBool:YES] forKey:KEY_DHCP];
    if( easylink_config == nil){
        easylink_config = [[EASYLINK alloc]initWithDelegate:self];
    }

    [easylink_config prepareEasyLink_withFTC:wlanConfig info:nil mode:EASYLINK_V2_PLUS];
    [easylink_config transmitSettings];

    NSString *message = [NSString stringWithFormat:@"Sending ssid: %@, password: %@", ssidString, passwordString];

    alert = [[UIAlertView alloc] initWithTitle:@"EasyLink"
                                       message:message
                                      delegate:(id)self
                             cancelButtonTitle:@"stop"
                             otherButtonTitles:nil];
//    [alert show];

}

-(BOOL)checkMacId:(NSString*)mac_Id{
    
    if (![self.isChongzhi isEqualToString:@"YES"]) {
    NSDictionary* deviceData = [[WHGlobalHelper shareGlobalHelper]get:USER_DEVICE_DATA];
    for (NSObject* e in deviceData) {
        if ([e isKindOfClass:[AirCleanerEntity class]]) {
            mac_Id = [mac_Id uppercaseString];
            AirCleanerEntity* ee = (AirCleanerEntity*)e;
            if ([mac_Id isEqualToString:ee.macId] && [ee.userType isEqualToString:@"primary"]) {
                [Send_cooee invalidate];
                Send = NO;
                [self stopProgress];
                UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"该设备已经被绑定" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [controller addAction:action1];
                [self presentViewController:controller animated:YES completion:nil];
                return NO;
            }
        }
    }
    }
    if ([self.isChongzhi isEqualToString:@"YES"]) {
        [Send_cooee invalidate];
        self.resetParam.MACADDRESS = _macId;
        [self.resetMock run:self.resetParam];
        [self stopProgress];
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"重新配网成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [controller addAction:action1];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [self addOperation:mac_Id];
    }
//    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"重新配网成功"];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    return YES;
   
}

@end
