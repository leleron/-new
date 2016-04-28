//
//  FKUpdateDeviceViewController.m
//  Empty
//
//  Created by leron on 15/8/28.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKUpdateDeviceViewController.h"
#import "deviceVersionCompareMock.h"
#import "updateDeviceVersionMock.h"
#import "CheckUpdateStatusMock.h"
#import "robotUpdateVersionMock.h"
#import "checkRobotUpdateMock.h"


@interface FKUpdateDeviceViewController (){
    NSString *firmID;
    NSString* version;
    NSTimer* checkUpdateTimer;
    int count;
}
@property (weak, nonatomic) IBOutlet UILabel *CenterInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property (weak, nonatomic) IBOutlet UILabel *firmVersionLabel;
@property(strong,nonatomic)deviceVersionCompareMock* myDeviceVersionCompareMock;
@property(strong,nonatomic)updateDeviceVersionMock* myUpdateMock;
@property(strong,nonatomic)CheckUpdateStatusMock* checkUpdateStatusMock;
@property(strong,nonatomic)robotUpdateVersionMock* myCompareMock;
@property(strong,nonatomic)checkRobotUpdateMock* myCheckUpdateMock;

@end

@implementation FKUpdateDeviceViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"固件升级";
    [super viewDidLoad];
    if (!self.air.deviceVersion || [self.air.deviceVersion isEqualToString:@""]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请重新插拔设备的电源"];
        _CenterInfoLabel.hidden = NO;
        _downLoadButton.hidden = NO;
    }else{
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    self.myDeviceVersionCompareMock = [deviceVersionCompareMock mock];
    self.myDeviceVersionCompareMock.delegate = self;
    deviceVersionCompareParam* param = [deviceVersionCompareParam param];
//    param.firmwareId = @"20150922";
    param.sendMethod = @"GET";
    UserInfo* myUserInfo = [UserInfo restore];
    if (self.cam) {
        [self checkUpdate];
    }else{
        _firmVersionLabel.text = [NSString stringWithFormat:@"版本号为:1.00.00%@",self.air.deviceVersion];;
        self.myDeviceVersionCompareMock.operationType = [NSString stringWithFormat:@"/devices/%@/firmwareUpdateVersion?tokenId=%@",self.air.deviceId,myUserInfo.tokenID];
    }
    [self.myDeviceVersionCompareMock run:param];
 }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[deviceVersionCompareMock class]]) {
        deviceVersionCompareEntity* e = (deviceVersionCompareEntity*)entity;
        if ([e.status isEqualToString:@"NEWEST"]) {
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:e.message];
            _CenterInfoLabel.hidden = NO;
            _downLoadButton.hidden = YES;
        }
        else if([e.status isEqualToString:@"SUCCESS"]) {
            //有更新
            UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"当前有新版本" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                
            }];
            [controller addAction:action1];
            [self presentViewController:controller animated:YES completion:nil];
            _CenterInfoLabel.hidden = YES;
            _downLoadButton.hidden = NO;
            
//            _firmVersionLabel.text = [NSString stringWithFormat:@"版本号为:%@",e.firmwareVersion];
            firmID = e.firmwareId;
        } else {
            _CenterInfoLabel.hidden = NO;
            _downLoadButton.hidden = NO;
//            _firmVersionLabel.text = @"";
        }
    }
    if ([mock isKindOfClass:[updateDeviceVersionMock class]]) {
        identifyEntity* e = (identifyEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            //开一个线程等一段时间后更新UI
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // long-running task
                [NSThread sleepForTimeInterval:DEVICE_UPDATE_WAIT_TIME];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 请求访问确定升级是否成功
                    count = 0;
                    self.checkUpdateStatusMock = [CheckUpdateStatusMock mock];
                    UserInfo* myUserInfo = [UserInfo restore];
                    self.checkUpdateStatusMock.operationType = [NSString stringWithFormat:@"/devices/%@/checkFirmwareUpdateStatus?tokenId=%@",_air.deviceId,myUserInfo.tokenID];
                    self.checkUpdateStatusMock.delegate = self;
                    CheckUpdateStatusParam *param = [CheckUpdateStatusParam param];
                    param.sendMethod = @"POST";
                    param.firmwareId = firmID;
                    [self.checkUpdateStatusMock run:param];
                    
                });
            });
        } else {
            _downLoadButton.hidden = NO;
            _CenterInfoLabel.hidden = YES;
        }
    }
    
    if ([mock isKindOfClass:[CheckUpdateStatusMock class]]) {
        deviceVersionCompareEntity* e  = (deviceVersionCompareEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            _firmVersionLabel.text = [NSString stringWithFormat:@"版本号为:1.00.00%@",e.firmwareVersion];
            _downLoadButton.hidden = YES;
            _CenterInfoLabel.hidden = NO;
        } else {
            if (count<6) {
                [NSThread sleepForTimeInterval:5.0f];
                self.checkUpdateStatusMock = [CheckUpdateStatusMock mock];
                UserInfo* myUserInfo = [UserInfo restore];
                self.checkUpdateStatusMock.operationType = [NSString stringWithFormat:@"/devices/%@/checkFirmwareUpdateStatus?tokenId=%@",_air.deviceId,myUserInfo.tokenID];
                self.checkUpdateStatusMock.delegate = self;
                CheckUpdateStatusParam *param = [CheckUpdateStatusParam param];
                param.sendMethod = @"POST";
                param.firmwareId = firmID;
                [self.checkUpdateStatusMock run:param];
                count++;
            }else{
                _downLoadButton.hidden = NO;
                _CenterInfoLabel.hidden = YES;

            }
            
        }
    }
    
    if ([mock isKindOfClass:[robotUpdateVersionMock class]]) {
        deviceVersionCompareEntity* e = (deviceVersionCompareEntity*)entity;
        [self.cam Rjone_SetUpdate:e.downloadUrl filenamestr:e.firmwareName filemd5str:e.md5];
        version = e.firmwareVersion;
        
        _CenterInfoLabel.hidden = YES;
        _downLoadButton.hidden = NO;
        _firmVersionLabel.text = [NSString stringWithFormat:@"版本号为:%@",e.firmwareVersion];
        firmID = e.firmwareId;

        checkUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkDeviceVersion) userInfo:nil repeats:YES];
        
    }
    if ([mock isKindOfClass:[checkRobotUpdateMock class]]) {
        identifyEntity* e = (identifyEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            _firmVersionLabel.text = [NSString stringWithFormat:@"版本号为:%@",version];
            _downLoadButton.hidden = YES;
            _CenterInfoLabel.hidden = NO;
        } else {
            _downLoadButton.hidden = NO;
            _CenterInfoLabel.hidden = YES;
        }

    }
}
- (IBAction)downLoad:(id)sender {
    _downLoadButton.hidden = YES;
    _CenterInfoLabel.hidden = YES;
    [[ViewControllerManager sharedManager]showWaitView:self.navigationController.view];
    
    
    self.myUpdateMock = [updateDeviceVersionMock mock];
    UserInfo* myUserInfo = [UserInfo restore];
    self.myUpdateMock.operationType = [NSString stringWithFormat:@"%@%@/upgrade",AC_BASE_URL,_air.macId];
    self.myUpdateMock.delegate = self;
    updateDeviceVersionParam *param = [updateDeviceVersionParam param];
    param.sendMethod = @"POST";
    param.tokenid = myUserInfo.tokenID;
    param.action = @"upgrade";
    param.source = @"app";
    
    [self.myUpdateMock run:param];
    
    
//   int result = [self.cam Rjone_SetUpdate:@"http://120.26.73.254:80/flyco_resource/firmware_test/FC/9605/1/" filenamestr:@"A103-HW01HS-FLYCO-1.0.10.20150924.bin" filemd5str:@"023B5D8E54288670895B73CFFE47BC04"];
//    NSLog(@"%@",self.cam.version);
}

-(void)checkUpdate{
    count = 0;
    self.myCompareMock = [robotUpdateVersionMock mock];
    self.myCompareMock.delegate = self;
    UserInfo* me = [UserInfo restore];
    self.myCompareMock.operationType = [NSString stringWithFormat:@"/devices/%@/robotFirmwareUpdateVersion?tokenId=%@",self.cam.nsDeviceId,me.tokenID];
    robotUpdateVersionParam* param = [robotUpdateVersionParam param];
    //    param.DEVICEID = self.cam.nsDeviceId;
    //    param.TOKENID = me.tokenID;
    param.sendMethod = @"GET";
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [self.myCompareMock run:param];
    
}


-(void)checkDeviceVersion{
    count++;
    if (count>60) {
        [checkUpdateTimer invalidate];
    }
    NSLog(@"%ld",(long)self.cam.version);
    if ([version intValue] == self.cam.version) {
        [checkUpdateTimer invalidate];
        UserInfo* u = [UserInfo restore];
        self.myCheckUpdateMock = [checkRobotUpdateMock mock];
        self.myCheckUpdateMock.delegate = self;
        self.myCheckUpdateMock.operationType = [NSString stringWithFormat:@"/devices/%@/checkRobotFirmwareUpdateStatus?tokenId=%@",self.cam.nsDeviceId,u.tokenID];
        checkRobotUpdateParam* param = [checkRobotUpdateParam param];
        param.firmwareVersion = version;
        [[ViewControllerManager sharedManager]showWaitView:self.view];
        [self.myCheckUpdateMock run:param];
    }
    
}


@end
