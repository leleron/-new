//
//  SetViewController.m
//  KV8
//
//  Created by Leron on 15/8/7.
//  Copyright (c) 2015年 李荣  . All rights reserved.
//

#import "ConfigNetViewController.h"
#import <stdio.h>
#import "cooee.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#import "KVSearchController.h"

#import "RJONE_LibCallBack.h"
#import "CamObj.h"
#import "GSetting.h"

#import "SQLSingle.h"
#import "FMDatabaseAdditions.h"
#import "addDeviceMock.h"
#import "WToast.h"
#import "UserInfo.h"
#import "FKConnectNetViewController.h"
#import "AirCleanerTipViewController.h"
#import "addProductViewController.h"
@interface ConfigNetViewController ()<QUMockDelegate>
{
    BOOL Send;
    NSString *wifiName;
    const char *PWD;
    const char *SSID;
    const char *KEY;
    unsigned int ip;
    NSTimer *Send_cooee;
    
    NSInteger timerNum;
    
    MBProgressHUD *HUD;
    
    UIButton *okButton;
}
@property (weak, nonatomic) IBOutlet UILabel *lblWifiName;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITextField *textPsw;


@end

@implementation ConfigNetViewController

- (void)viewDidLoad
{
    
    self.navigationBarTitle = @"连接Wi-Fi";
    [super viewDidLoad];
    
    [self showLeftNormalButton:@"go_back" highLightImage:@"go_back" selector:@selector(myBack)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWIFI) name:@"Get_WIFI" object:nil];
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0, 0, 25, 26.43);
//    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    UIColor* color = [UIColor whiteColor];
    self.textPsw.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机当前连接Wi-Fi的密码" attributes:@{NSForegroundColorAttributeName: color}];
    
    [WpCommonFunction setView:self.btnNext cornerRadius:8];
    [self.btnNext addTarget:self action:@selector(comfirm) forControlEvents:UIControlEventTouchUpInside];
    [WpCommonFunction setView:self.btnNext cornerRadius:8];
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];


}

-(void)getWIFI{
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"Wifi connect");
        Send = false;
        [okButton setTitle:@"Start" forState:UIControlStateNormal];
        NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
        id info = nil;
        for (NSString *ifnam in ifs) {
            info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            if(info && [info count]){
                NSDictionary *dic = (NSDictionary*)info; //取得网卡咨询
                wifiName = [dic objectForKey:@"SSID"];   //取得ssid
                break;
            }
        }
        self.lblWifiName.text = wifiName;
        
    }
    else{
        NSLog(@"No Wifi");
        //        UIAlertView *alert = [[UIAlertView alloc]
        //                              initWithTitle:@"请先连接WiFi网络再进行配网"
        //                              message:nil
        //                              delegate:self
        //                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
        //                              otherButtonTitles:nil, nil];
        //        [alert show] ;
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"Wi-Fi未连接" message:@"请先配置Wi-Fi" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }];
        [controller addAction:action1];
        [self presentViewController:controller animated:YES completion:nil];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [self getWIFI];
    self.textPsw.text = nil;
}

- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//int num;
//SEARCH_CALL_RESP * pSearch;


-(void)comfirm{
    [self.textPsw resignFirstResponder];
    if ( self.lblWifiName.text) {
        
        if ([self.productModel isEqualToString:@"31"] || [self.snInfoEntity.type isEqualToString:@"9001"] || [self.snInfoEntity.type isEqualToString:@"9002"] || [self.productCode isEqualToString:@"9001"] || [self.productCode isEqualToString:@"9002"]) {
            AirCleanerTipViewController* controller = [[AirCleanerTipViewController alloc]initWithNibName:@"AirCleanerTipViewController" bundle:nil];
            controller.wifiName = wifiName;
            controller.psw = self.textPsw.text;
            controller.sn = self.sn;
            controller.macId = self.macId;
            controller.isChongzhi = self.isChongzhi;
            if (self.snInfoEntity) {
                controller.model = self.snInfoEntity.model;
                controller.vendor = self.snInfoEntity.vendor;
                controller.productCode = self.snInfoEntity.type;
            }
            if (self.productCode) {
                controller.productCode = self.productCode;
            }
            controller.productModel = self.productModel;    //模组型号
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            FKConnectNetViewController* controller = [[FKConnectNetViewController alloc]initWithNibName:@"FKConnectNetViewController" bundle:nil];
            controller.wifiName = wifiName;
            controller.psw = self.textPsw.text;
            controller.sn = self.sn;
            controller.macId = self.macId;
            controller.model = self.snInfoEntity.model;
            controller.vendor = self.snInfoEntity.vendor;
            controller.productCode = self.snInfoEntity.type;
            controller.productModel = self.productModel;    //产品型号
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (!self.lblWifiName.text){
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请先连接Wi-Fi"];
    }
    if (self.textPsw.text.length == 0) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入密码"];
    }
}

//-(void)OK:(id)sender
//{
//    Send = !Send;
//    
//    [self.textPsw resignFirstResponder];
//    
//    if (!HUD)
//    {
//        HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
//    }
//    [self.navigationController.view addSubview:HUD];
//    HUD.delegate = self;
//    HUD.labelText = LOCAL(@"setting");
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        [HUD show:YES];
//    });
//    
//    
//    if (Send )
//    {
//        [sender setTitle:@"Stop" forState:UIControlStateNormal];
//        
//        Send_cooee = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerNum) userInfo:nil repeats:YES];
//    
//        //接收,收到一个设备即添加返回
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//           pSearch = RJONE_LibOneKey(60, 60, &num);
//            
//            if (num>0)
//            {
//                NSLog(@"当前搜索到的设备数目:%d\n",num);
//            
//                NSString *nsDID;
//                CHAR prefix[64], number[64], checkCode[64], Result[64];
//            
//                nsDID=[NSString stringWithFormat:@"%s", pSearch[0].dev_id];
//                
//                memset(prefix, 0, sizeof(prefix));
//                memset(number, 0, sizeof(number));
//                memset(checkCode, 0, sizeof(checkCode));
//                memset(Result, 0, sizeof(Result));
//                CamObj *camObj=[[CamObj alloc] init];
//                camObj.nsDID    = nsDID;
//                camObj.nsViewPwd  = @"88888888";
//                camObj.nsCamName=nsDID;
//                camObj.addedName = nsDID;
//                
//                self.myAddMock = [addDeviceMock mock];
//                self.myAddMock.delegate = self;
//                addDeviceParam* param = [addDeviceParam param];
//                UserInfo* myUserInfo = [UserInfo restore];
//                param.TOKENID = myUserInfo.tokenID;
//                param.NICKNAME = @"扫地机器人";
//                param.GROUP = @"1";
//                param.LATITUDE = @"65";
//                param.LONGITUDE = @"123";
//                param.MACADDRESS = camObj.nsDID;
//                param.SN = self.sn;
//                param.PRODUCTCODE = @"9605";
//                param.PASSWORD = @"88888888";
//                [self.myAddMock run:param];
//                }
//            else
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    pSearch = nil;
//                    [HUD hide:YES];
//                    [WToast showWithText:@"配置失败,未发现设备"];
//                    Send = NO;
//                    [Send_cooee invalidate];
//                    [self.btnNext  setTitle:@"开始" forState:UIControlStateNormal];
//                    return;
//                });
//                
//            }
//                   });
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            while (Send)
//            {
//                PWD = [[self.textPsw text] UTF8String];
//                SSID = [self.lblWifiName.text  UTF8String];
//                KEY = [@"" UTF8String];
//                struct in_addr addr;
//                inet_aton([[self getIPAddress] UTF8String], &addr);
//                ip = CFSwapInt32BigToHost(ntohl(addr.s_addr));
//                send_cooee(SSID, (int)strlen(SSID), PWD, (int)strlen(PWD), KEY, 0, ip);
////                NSLog(@"SSID = %s" , SSID);
////                NSLog(@"strlen(SSID) = %lu" , strlen(SSID));
////                NSLog(@"PWD = %s" , PWD);
////                NSLog(@"strlen(PWD) = %lu" , strlen(PWD));
////                NSLog(@"[self getIPAddress] = %@" , [self getIPAddress]);
////                NSLog(@"ip = %08x", ip);
//               
//            }
//            
//        });
//    }
//    else
//    {
//        [self.btnNext  setTitle:@"开始" forState:UIControlStateNormal];
//
//        dispatch_async(dispatch_get_main_queue(), ^(void)
//        {
//            [self.btnNext setTitle:@"开始" forState:UIControlStateNormal];
//        });
//        [HUD hide:YES afterDelay:0];
//    }
//
//}


#pragma quMockdelegate
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[addDeviceMock class]]) {
        DeviceAddEntity* e = (DeviceAddEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {

        dispatch_async(dispatch_get_main_queue(),
                       ^{
//                           [WToast showWithText:@"发现了一个设备"];
//                           [HUD hide:YES afterDelay:0];
                           [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
                           [self.navigationController popToRootViewControllerAnimated:YES];
                           [Send_cooee invalidate];
                       });
        }
        
    }
}
//30 计时
-(void)timerNum
{
    timerNum++;
    NSLog(@" 等待时间:%d",(int)timerNum);
    if (timerNum > 150)
    {
        [HUD hide:YES afterDelay:0];
        timerNum = 0;
        [Send_cooee invalidate];
        Send = NO;
        [WToast showWithText:@"配置失败,没有发现设备"];
        [okButton  setTitle:@"Start" forState:UIControlStateNormal];
        
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textPsw resignFirstResponder];
}
    
#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == _passwordField && SCREEN_HEIGHT == 480)
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.25];
//        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-70);
//        [UIView commitAnimations];
//    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (SCREEN_HEIGHT == 480) {
//        if (iOSVERSION <7.0) {
//            self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-32);
//            return;
//        }
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.25];
//        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        [UIView commitAnimations];
//    }
    [textField resignFirstResponder];
}


-(void)back{
    BOOL mark = NO;
    for (MyViewController* controller in self.navigationController.childViewControllers) {
        if ([controller isKindOfClass:[addProductViewController class]]) {
            addProductViewController* e = (addProductViewController*)controller;
            [self.navigationController popToViewController:e animated:YES];
            mark = YES;
        }
    }
    if (mark == NO) {
//        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
