//
//  FKDevicePswViewController.m
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKDevicePswViewController.h"
#import "deviceCardAttentionMock.h"
#import "getDeivceIdMock.h"
#import "resetDevicePswMock.h"
#import "vertifyPswMock.h"
#import "FKDeviceCardViewController.h"
@interface FKDevicePswViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textPsw;
@property(strong,nonatomic)deviceCardAttentionMock* myAttentionMock;
@property(strong,nonatomic)getDeivceIdMock* myDeviceIdMock;
@property(strong,nonatomic)resetDevicePswMock* myResetPswMock;
@property(strong,nonatomic)vertifyPswMock* myVertifyPswMock;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* snCode;
@end

@implementation FKDevicePswViewController

-(void)initQuickMock{
    self.myAttentionMock = [deviceCardAttentionMock mock];
    self.myAttentionMock.delegate = self;
    self.myDeviceIdMock = [getDeivceIdMock mock];
    self.myAttentionMock.delegate = self;
    self.myResetPswMock = [resetDevicePswMock mock];
    self.myResetPswMock.delegate = self;
    self.myVertifyPswMock = [vertifyPswMock mock];
    self.myVertifyPswMock.delegate = self;
}

- (void)viewDidLoad {
    if ([self.type isEqualToString:@"vertifyPsw"]) {
        self.navigationBarTitle = @"验证密码";
    }else{
        self.navigationBarTitle = @"设置密码";
    }
    [super viewDidLoad];
    UIColor * color = [UIColor whiteColor];
    self.textPsw.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入设备密码" attributes:@{NSForegroundColorAttributeName:color}];
    if ([self.type isEqualToString:@"vertifyPsw"]) {
        [self showRightButtonTitle:@"确认" andSelector:@selector(vertifyPsw)];
    }else{
        [self showRightButtonTitle:@"确认" andSelector:@selector(fixPsw)];

    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fixPsw{
   const char* newPsw = [self.textPsw.text UTF8String];
    const char* oldPsw = [self.obj.nsViewPwd UTF8String];
    [self.obj Rjone_SetPassword:oldPsw :newPsw];
//    [self getDeviceId];
    self.myResetPswMock.operationType = [NSString stringWithFormat:@"/devices/%@/resetDevicePassword",self.obj.nsDeviceId];
    resetDevicePswParam* param = [resetDevicePswParam param];
    UserInfo *myUserInfo = [UserInfo restore];
    param.TOKENID = myUserInfo.tokenID;
    param.NEW_PASSWORD = self.textPsw.text;
    [self.myResetPswMock run:param];
    //缺少向服务器发送修改设备密码的接口
}

-(void)vertifyPsw{
    vertifyPswParam* param = [vertifyPswParam param];
    UserInfo* u = [UserInfo restore];
    param.TOKENID = u.tokenID;
    param.PASSWORD = self.textPsw.text;
    self.myVertifyPswMock.operationType = [NSString stringWithFormat:@"/devices/%@/checkDevicePassword",self.obj.nsDeviceId];
    [self.myVertifyPswMock run:param];
}


//-(void)addDevice{
//    [self getDeviceId];
//    deviceCardAttentionParam* param = [deviceCardAttentionParam param];
//    NSString* deviceId = [self.obj.nsDID substringWithRange:NSMakeRange(5, 12)];
//    param.DEVICEID = deviceId;
//    UserInfo* myUserInfo = [UserInfo restore];
//    param.TOKENID = myUserInfo.tokenID;
//    [[ViewControllerManager sharedManager]showWaitView:self.view];
//    [self.myAttentionMock run:param];
//}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    
//    if ([mock isKindOfClass:[getDeivceIdMock class]]) {
//        getDeviceIdEntity* e = (getDeviceIdEntity*)entity;
//        self.deviceId = [e.DeviceInfo objectForKey:@"deviceId"];
//        
//    }
    if ([mock isKindOfClass:[resetDevicePswMock class]]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"修改成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([mock isKindOfClass:[vertifyPswMock class]]) {
        FKDeviceCardViewController* controller = [[FKDeviceCardViewController alloc]initWithNibName:@"FKDeviceCardViewController" bundle:nil];
        controller.deviceId = self.obj.nsDeviceId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)getDeviceId{
    UserInfo* myUserInfo = [UserInfo restore];
    self.snCode = [self.obj.nsDID substringWithRange:NSMakeRange(5, 12)];
    self.myDeviceIdMock.operationType = [NSString stringWithFormat:@"devices/%@/deviceDetail?tokenId=%@",self.snCode,myUserInfo.tokenID];
    getDeivceIdParam* param = [getDeivceIdParam param];
    param.sendMethod = @"GET";
    [self.myDeviceIdMock run:param];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textPsw resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
