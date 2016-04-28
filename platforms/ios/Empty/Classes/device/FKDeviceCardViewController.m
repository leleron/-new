//
//  FKDeviceCardViewController.m
//  Empty
//
//  Created by leron on 15/8/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKDeviceCardViewController.h"
#import "ConfigNetViewController.h"
#import "deviceCardMock.h"
#import "deviceCardAttentionMock.h"
#import "getDeivceIdMock.h"
@interface FKDeviceCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblNo;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnConfigNet;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property(strong,nonatomic)deviceCardMock* cardMock;
@property(strong,nonatomic)deviceCardAttentionMock* myAttentionMock;  //添加关注
@property(strong,nonatomic)getDeivceIdMock* myDeviceIdMock;
//@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* deviceStatus;
@property(strong,nonatomic)NSString* productModel;
@end

@implementation FKDeviceCardViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"设备名片";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnConfigNet addTarget:self action:@selector(gotoConfigNet) forControlEvents:UIControlEventTouchUpInside];
    if (!self.deviceId) {
        [self getDeviceId];
    }else{
        deviceCardParam* param = [deviceCardParam param];
        param.sendMethod = @"GET";
        UserInfo* myUserInfo = [UserInfo restore];
        self.cardMock.operationType = [NSString stringWithFormat:@"/devices/%@/card?tokenId=%@",self.deviceId,myUserInfo.tokenID];
        [self.cardMock run:param];

    }
    [WpCommonFunction setView:self.btnAdd cornerRadius:8];
}

-(void)initQuickMock{
    self.myDeviceIdMock = [getDeivceIdMock mock];
    self.myDeviceIdMock.delegate = self;
    self.cardMock = [deviceCardMock mock];
    self.cardMock.delegate = self;
    self.myAttentionMock = [deviceCardAttentionMock mock];
    self.myAttentionMock.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoConfigNet{
    ConfigNetViewController* controller = [[ConfigNetViewController alloc]initWithNibName:@"ConfigNetViewController" bundle:nil];
    controller.productModel = self.productModel;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    
    
//    if ([mock isKindOfClass:[getDeivceIdMock class]]) {
//        getDeviceIdEntity* e = (getDeviceIdEntity*)entity;
//        self.deviceId = [e.DeviceInfo objectForKey:@"deviceId"];
//        
//        deviceCardParam* param = [deviceCardParam param];
//        param.sendMethod = @"GET";
//        UserInfo* myUserInfo = [UserInfo restore];
//        self.cardMock.operationType = [NSString stringWithFormat:@"/devices/%@/card?tokenId=%@",self.deviceId,myUserInfo.tokenID];
//        [self.cardMock run:param];
//
//    }
    
    if ([mock isKindOfClass:[deviceCardMock class]]) {
        deviceCardEntity* e = (deviceCardEntity*)entity;
        self.lblName.text = [e.result objectForKey:@"deviceNickName"];
        self.lblNo.text = [NSString stringWithFormat:@"%@%@",[e.result objectForKey:@"productCategory"],[e.result objectForKey:@"deviceProductCode"]];
        self.productModel = [e.result objectForKey:@"productModel"];
        if ([[e.result objectForKey:@"deviceProductCode"] hasPrefix:@"90"]) {
            self.imgIcon.image = [UIImage imageNamed:@"airCleaner"];
        }else if([[e.result objectForKey:@"deviceProductCode"] isEqualToString:@"9605"]){
            self.imgIcon.image = [UIImage imageNamed:@"9605"];
        }else if ([[e.result objectForKey:@"deviceProductCode"] isEqualToString:@"9606"]){
            self.imgIcon.image = [UIImage imageNamed:@"9606"];
        }
        
        self.deviceStatus = [e.result objectForKey:@"onlineStatus"];
        if ([self.deviceStatus isEqualToString:@"online"]) {
            self.btnConfigNet.hidden = YES;
        }
        
        [self.btnAdd addTarget:self action:@selector(addDevice) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if([mock isKindOfClass:[deviceCardAttentionMock class]]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [WpCommonFunction showNotifyHUDAtViewBottom:appDelegate.window  withErrorMessage:@"添加设备成功！"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


-(void)getDeviceId{
    UserInfo* myUserInfo = [UserInfo restore];
//    self.snCode = [self.snCode substringWithRange:NSMakeRange(5, 12)];
    self.myDeviceIdMock.operationType = [NSString stringWithFormat:@"/devices/%@/deviceDetail?tokenId=%@",self.snCode,myUserInfo.tokenID];
    getDeivceIdParam* param = [getDeivceIdParam param];
    param.sendMethod = @"GET";
    [self.myDeviceIdMock run:param];
}




-(void)addDevice{
    deviceCardAttentionParam* param = [deviceCardAttentionParam param];
    param.DEVICEID = self.deviceId;
    UserInfo* myUserInfo = [UserInfo restore];
    param.TOKENID = myUserInfo.tokenID;
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [self.myAttentionMock run:param];
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
