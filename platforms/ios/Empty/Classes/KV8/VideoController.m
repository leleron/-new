//
//  VideoController.m
//  KV8
//
//  Created by lirong on 14-8-13.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "VideoController.h"
#import <AVFoundation/AVFoundation.h>
#import "WToast.h"
#import "AppDelegate.h"
#import "StatusView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RJONE_LibCallBack.h"
//#import "record_format.h"
#import "const.h"
#import "FKSetTimeViewController.h"
#import "FKManageDeviceViewController.h"
#import "errorMessageMock.h"
#import "DeviceErrorViewController.h"
#import "FKDevicePswViewController.h"
#import "robotUpdateVersionMock.h"
#import "checkRobotUpdateMock.h"
#import "timeSelectSection.h"
#import "FKSelectDateViewController.h"
typedef enum
{
    IOCTRL_QUALITY_QQVGA	       = 0x00,	// 160*120
    IOCTRL_QUALITY_QVGA		= 0x01,	// 320*240
    IOCTRL_QUALITY_VGA		= 0x02,	// 640*480
    IOCTRL_QUALITY_720P		= 0x03,	// 1280*720
    
}ENUM_RESOLUTION_LEVEL;


// IOCTRL PTZ Command Value
typedef enum
{
    IOCTRL_PTZ_STOP,
    IOCTRL_PTZ_UP,
    IOCTRL_PTZ_DOWN,
    IOCTRL_PTZ_LEFT,
    IOCTRL_PTZ_RIGHT,
    IOCTRL_PTZ_LEFT_UP,
    IOCTRL_PTZ_LEFT_DOWN,
    IOCTRL_PTZ_RIGHT_UP,
    IOCTRL_PTZ_RIGHT_DOWN,
    IOCTRL_LENS_ZOOM_IN,
    IOCTRL_LENS_ZOOM_OUT,
    IOCTRL_PTZ_SET_POINT,
    IOCTRL_PTZ_CLEAR_POINT,
    IOCTRL_PTZ_GOTO_POINT,
    IOCTRL_PTZ_FORWARD_SHORT,            // add for ZhiGuan PTZ
    IOCTRL_PTZ_BACKWARD_SHORT,           // add for ZhiGuan PTZ
    IOCTRL_PTZ_MOTO_TURN_L,              // add for ZhiGuan PTZ
    IOCTRL_PTZ_MOTO_TURN_R,              // add for ZhiGuan PTZ
    
    IOCTRL_CLEANER_POWER_ONOFF,	         //Power of cleaner is on or off
    IOCTRL_CLEANER_AUTO_CLEAN,	         //Cleaner clean auto automatically
    IOCTRL_CLEANER_FIXED_CLEAN,	         //Cleaner clean to fixed place
    IOCTRL_CLEANER_SPEED,		         //Cleaner speed
    IOCTRL_CLEANER_CHARGE,		         //Cleaner come back and charge
    
}ENUM_PTZCMD;


@interface VideoController ()<timeSelectDelegate,UIGestureRecognizerDelegate>
{
    //    UIImageView *_imageView;
    //    UIView *_panelView;
    NSTimer *_timer;
    NSTimer* _connect_timer;
    ENUM_RESOLUTION_LEVEL _resolution;
    UIButton *_HD;
    MBProgressHUD *HUD;
    StatusView *_statusView;
    UIButton *_speed;
    UILabel *_FPSLabel;
    UILabel *_contrastValue;
    UILabel *_lightValue;
    UILabel *_contrast;
    UISlider *_contrastSlider;
    UILabel *_light;
    UISlider *_lightSlider;
    //    UIView *_middleView;
    //    UIView *_middleView1;
    BOOL _showError;
    
    int   _isSaveImgStatus;//141129 EngelChen
    BOOL _isSaveImg;
    
    RJONE_macvideo *_rjone ;
    CGRect SaveImageFrame;
    UIButton *power;
    UIButton *optionButton;      //菜单键
    timeSelectSection* timeSelect;   //选择时间
    UIView* empty;    //空白层
    
    //mp4 record
    UIButton *redpot;
    NSTimer *timer; // 控制红点
    NSTimer *checkUpdateTimer;   //检测升级
    NSString* version;    //服务器端固件版本
    int count;
    UIAlertController* alert;
    int batteryCount;
    NSInteger connect;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnCamUp;
@property (weak, nonatomic) IBOutlet UIButton *btnCamDown;
@property (weak, nonatomic) IBOutlet UIImageView *imgBattery;
@property (weak, nonatomic) IBOutlet UIButton *btnDef;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (weak, nonatomic) IBOutlet UIButton *btnAuto;
@property (weak, nonatomic) IBOutlet UIButton *btnLocal;
@property (weak, nonatomic) IBOutlet UIButton *btnAppoint;
@property (weak, nonatomic) IBOutlet UIButton *btnRecharge;
@property (weak, nonatomic) IBOutlet UILabel *lblCamera;
@property (weak, nonatomic) IBOutlet UILabel *lblShow1;
@property (weak, nonatomic) IBOutlet UILabel *lblShow2;
@property (weak, nonatomic) IBOutlet UIImageView *imgPauseBg;
@property (weak, nonatomic) IBOutlet UIView *viewFunction;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircle;

@property(weak,nonatomic)IBOutlet UIView* bottomView;



@property (assign,nonatomic) BOOL isAuto;
@property(assign,nonatomic) BOOL isLocal;
@property(assign,nonatomic) BOOL isCharge;
@property(assign,nonatomic) BOOL isOn;
@property(strong,nonatomic)SKDropDown *drop;
@property(strong,nonatomic)NSString* TOKENID;
@property(strong,nonatomic)robotUpdateVersionMock* myCompareMock;
@property(strong,nonatomic)checkRobotUpdateMock* myCheckUpdateMock;
@end

VideoController *instance;
@implementation VideoController

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationBarTitle = self.cam.nsCamName;
    [self getConnected];
    if (!_connect_timer)
    {
        _connect_timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getConnected) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_connect_timer forMode:NSDefaultRunLoopMode];
    }
    
}

- (void)getConnected
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        GSetting *gSetting=[GSetting instance];
        //        NSArray *array = [NSArray arrayWithArray:gSetting.arrCam];
        //        for (CamObj   *cam in array)
        //        {
        if ([self.cam getLastError] <0)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
               connect = [self.cam startConnect:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (connect>0) {
                        [[ViewControllerManager sharedManager]hideWaitView];
                        [self deviceConnected];
                        [_cam Rjone_getBattCapacity];
                    }
                });
            });
        }
        //        }
    });
}


//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self)
//    {
//        // Custom initialization
//        m_bTimer=NO;
//        m_bSpeak=0;
//        _isSaveImg = NO;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeResolution) name:@"ChangeResolution" object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeStatus) name:@"ChangeStatus" object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeWork:) name:@"changeWork" object:nil];
//
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeContrastVideo:) name:@"ChangeContrast" object:nil];
//
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector
//         (ChangeBrightVideo:) name:@"ChangeBright" object:nil];
//    }
//    return self;
//}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    self.cam.m_delegateCam=self;
    NSInteger nRet=[_cam startVideo:AV_TYPE_REALAV withTime:0L];
    
    if(nRet>=0) [self startTimer];
    
    BOOL initResult=[_rjone RJONE_InitDecode:640 andHe:480 andFrame:SaveImageFrame];//141128 EngelChen
    
    if (!initResult)
    {
        [NSThread sleepForTimeInterval:100000000];
    }
    savetime = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(StartSaveOneImg2Doc:) userInfo:nil repeats:YES];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [super viewDidAppear:animated];
    
    if (self.deviceName) {
        self.title = self.deviceName;
    }
    
    [self.view sendSubviewToBack:self.imgVideo];
    
    
    
    if (timeSelect) {
        timeSelect.dateArray = self.dateArray;
        [timeSelect showDate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if (self.cam) {
        _cam.m_delegateCam=nil;
        //        [_statusView myRelease];
        [self stopTimer];
        
        [_cam stopVideo:AV_TYPE_REALAV withTime:0L];
        
        [savetime invalidate];
        
        _cam.cleanFifo = true;
        [_rjone RJONE_UninitDecode];  //141128   EngelChen
        
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        
    }
    alert = nil;
    [super viewWillDisappear:animated];
    
}

+(VideoController *)share
{
    return instance;
}
- (void)viewDidLoad
{
    if (iPhone4 || iPad12mini || iPad34Air) {
        for (NSLayoutConstraint *aspectConstraint in self.imgVideo.constraints) {
            if ([aspectConstraint.identifier isEqualToString:@"WidthHeight"]) {
                [self.imgVideo removeConstraint:aspectConstraint];
            }
        }
        [self.imgVideo addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.imgVideo
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.imgVideo
                                      attribute:NSLayoutAttributeWidth
                                      multiplier:0.6f
                                      constant:0]];
    }
    
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    //视频解密
    NSString *code = @"test_encrpt";
    unsigned char *charCode = (unsigned char *)[code UTF8String];
    RJONE_LibSetAesCode(charCode);
    [self.view bringSubviewToFront:self.btnCamDown];
    [self.view bringSubviewToFront:self.btnCamUp];
    [self.view bringSubviewToFront:self.lblCamera];
    
    instance = self;
    //根据语言做相应布局
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    m_colorSpaceRGB   = CGColorSpaceCreateDeviceRGB();
    m_bytesPerRow	  =0;
    m_nWidth=m_nHeight=0;
    m_nImgDataSize    =0;
    _cam.m_delegateCam=self;
    
    
    
    self.dateArray = [[NSMutableArray alloc]init];
    
    [super viewDidLoad];
    
    //    [self checkUpdate];    //检测版本升级
    
    //    [self checkPsw];      //检测是否是初始密码
    
    int capacity = [self.cam Rjone_getBattCapacity];  //获取电量信息
    
    
    self.title = _cam.nsCamName;
    
    optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    optionButton.frame = CGRectMake(0, 0, 28, 37);
    [optionButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    
    [optionButton addTarget:self action:@selector(myEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:optionButton];
    
    [self.btnPause addTarget:self action:@selector(power) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDef addTarget:self action:@selector(ChangeResolution) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPhoto addTarget:self action:@selector(take_pic) forControlEvents:UIControlEventTouchUpInside];
    [self.btnUp addTarget:self action:@selector(Up) forControlEvents:UIControlEventTouchDown];
    [self.btnUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnDown addTarget:self action:@selector(Down) forControlEvents:UIControlEventTouchDown];
    [self.btnDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnLeft addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchDown];
    [self.btnLeft addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLeft addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.btnRight addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchDown];
    [self.btnRight addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.btnCamUp addTarget:self action:@selector(camUp) forControlEvents:UIControlEventTouchDown];
    [self.btnCamUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnCamDown addTarget:self action:@selector(camDown) forControlEvents:UIControlEventTouchDown];
    [self.btnCamDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.btnAuto addTarget:self action:@selector(autoClean) forControlEvents:UIControlEventTouchUpInside];
    //    [self.btnRecharge addTarget:self action:@selector(power) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnRecharge addTarget:self action:@selector(charge) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnLocal addTarget:self action:@selector(local) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamera addTarget:self action:@selector(myRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAppoint addTarget:self action:@selector(yuyue) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPhoto setImage:[UIImage imageNamed:@"photo_camera_selected"] forState:UIControlStateSelected];
    
    //
    
    self.isLocal = false;
    self.isAuto = false;
    self.isCharge = false;
    self.isOn = true;
    
    
    redpot = [[UIButton alloc] initWithFrame:CGRectMake(40, 24, 15, 15)];
    redpot.hidden = YES;
    [redpot setBackgroundImage:IMAGE(@"red dot-rec") forState:UIControlStateNormal];
    [self.view addSubview:redpot];
    
    
    if (_cam.resolution == IOCTRL_QUALITY_QVGA)
    {
        [self.btnDef setTitle:@"标清" forState:UIControlStateNormal];
        _resolution = IOCTRL_QUALITY_QVGA;
    }
    if (_cam.resolution == IOCTRL_QUALITY_VGA)
    {
        [self.btnDef setTitle:@"高清" forState:UIControlStateNormal];
        _resolution = IOCTRL_QUALITY_VGA;
    }
    [self.btnDef addTarget:self action:@selector(myResolutionChange) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDeviceName) name:@"updateDeviceName" object:nil];
    
    //////////////////////////////////////   141128 EngelChen
    _rjone = [[RJONE_macvideo alloc]init];
    [_rjone SettView:self.view andImg:self.imgVideo];
    [_rjone setDelegate:self ];
    CGRect rect = CGRectMake(self.imgVideo.frame.origin.x, self.imgVideo.frame.origin.y, SCREEN_WIDTH, SCREEN_WIDTH/3*2);
    SaveImageFrame = rect;
    
    _isSaveImgStatus = -1;
    
    if (self.cam && self.cam.mCamState != CONN_INFO_CONNECTED) {
        self.btnDown.hidden = YES;
        self.btnUp.hidden = YES;
        self.btnRight.hidden = YES;
        self.btnLeft.hidden = YES;
        self.btnPause.hidden = YES;
        self.lblShow1.hidden = NO;
        self.lblShow2.hidden = NO;
        self.imgPauseBg.hidden = YES;
        [self.btnAuto setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnLocal setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnRecharge setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnAppoint setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnCamDown setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnCamUp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnCamera setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnDef setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnPhoto setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.viewFunction.hidden = YES;
    }
    
    //    [_cam addObserver:self forKeyPath:@"errorMessage" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    //    [self postError];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postError) name:@"ChangeStatus" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeResolution) name:@"ChangeResolution" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeWork:) name:@"changeWork" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getBatteryCount:) name:@"batteryCount" object:nil];
    
    UserInfo* myUserInfo = [UserInfo restore];
    self.TOKENID = myUserInfo.tokenID;
    
    
}


-(void)getBatteryCount:(NSNotification *)notification{
    int batteryCount = [[[notification userInfo]objectForKey:@"key"]intValue];
    dispatch_async(dispatch_get_main_queue(), ^(){
        if (batteryCount>=80) {
            self.imgBattery.image = [UIImage imageNamed:@"battery_3"];
        }else if (batteryCount>=50){
            self.imgBattery.image = [UIImage imageNamed:@"battery_2"];
        }else if (batteryCount>=30){
            self.imgBattery.image = [UIImage imageNamed:@"battery_1"];
        }else if(batteryCount<30){
            self.imgBattery.image = [UIImage imageNamed:@"battery_0"];
        }
    });
}

-(void)deviceConnected{
    self.btnDown.hidden = NO;
    self.btnUp.hidden = NO;
    self.btnRight.hidden = NO;
    self.btnLeft.hidden = NO;
    self.btnPause.hidden = NO;
    self.lblShow1.hidden = YES;
    self.lblShow2.hidden = YES;
    self.imgPauseBg.hidden = NO;
    [self.btnAuto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRecharge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAppoint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCamDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCamUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDef setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.viewFunction.hidden = NO;

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

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[robotUpdateVersionMock class]]) {
        deviceVersionCompareEntity* e = (deviceVersionCompareEntity*)entity;
        [self.cam Rjone_SetUpdate:e.downloadUrl filenamestr:e.firmwareName filemd5str:e.md5];
        //        [self checkDeviceVersion:e.firmwareVersion];
        version = e.firmwareVersion;
        checkUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkDeviceVersion) userInfo:nil repeats:YES];
        
    }
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

-(void)checkPsw{
    if ([_cam.nsViewPwd isEqualToString:DEVICE_DEFAULT_PSW]) {
        
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"设置密码" message:@"请设置设备密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* aciton1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            FKDevicePswViewController* controller = [[FKDevicePswViewController alloc]initWithNibName:@"FKDevicePswViewController" bundle:nil];
            controller.obj = self.cam;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        [controller addAction:aciton1];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//
//    if ([keyPath isEqualToString:@"errorMessage"]) {
//
//        [[ViewControllerManager sharedManager]showWaitView:self.view];
//        [self postError];
//    }
//
//}

#pragma mark 状态改变
- (void)changeWork:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int result = [[[notification userInfo]objectForKey:@"key"]intValue];
        if (4 != result)
        {
            [self.btnPause setImage:[UIImage imageNamed:@"deviceon"] forState:UIControlStateNormal];
            self.imgPauseBg.image = nil;
            
        }
        if (result == 1 || result == 2) {
            [self.btnPause setImage:[UIImage imageNamed:@"PLAY default"] forState:UIControlStateNormal];
            //            self.imgPauseBg.image = [UIImage imageNamed:@"pause_bg"];
            
        }
        if(result == 4)
        {
            [self.btnPause setImage:[UIImage imageNamed:@"deviceoff"] forState:UIControlStateNormal];
            self.imgPauseBg.image = nil;
        }
    });
    
}


-(void)postError{
    
    if (_cam.error != 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            DeviceErrorViewController* controller = [[DeviceErrorViewController alloc]initWithNibName:@"DeviceErrorViewController" bundle:nil];
            controller.error = _cam.error;
            controller.deviceId = _cam.nsDeviceId;
            if (!alert) {
             alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"故障号%ld",(long)controller.error] message:@"出现故障" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                [self.navigationController pushViewController:controller animated:YES];
            }];
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
            }
        });
        
        
    }
    
}


-(void)updateDeviceName{
    self.title = self.deviceName;
}
//mp4 record

-(void)yuyue{
     empty = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.imgVideo.frame.size.height)];
    empty.backgroundColor = [UIColor blackColor];
    empty.alpha = 0.5;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideYuyue)];
    [empty addGestureRecognizer:gesture];
    [self.view addSubview:empty];
    timeSelect = [[[NSBundle mainBundle]loadNibNamed:@"timeSelectSection" owner:self options:nil]lastObject];
    timeSelect.delegate = self;
    timeSelect.dateArray = self.dateArray;
    timeSelect.cam = self.cam;
    timeSelect.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.bottomView.frame.size.height);
    [timeSelect showDate];
    [self.bottomView addSubview:timeSelect];
}

-(void)hideYuyue{
    if (timeSelect) {
        [timeSelect removeFromSuperview];
        [empty removeFromSuperview];
    }
}


-(void)myRecord:(UIButton *)sender
{
    self.isRecordOn = !self.isRecordOn;
    if (self.isRecordOn)
    {
        NSLog(@"ison");
        
        //        [self.btnCamera setBackgroundImage:IMAGE(@"video_hover") forState:UIControlStateNormal ];
        [self.btnCamera setImage:[UIImage imageNamed:@"video_camera_selected"] forState:UIControlStateNormal];
        _cam.mp4Handle = [self Createfile];
        _cam.ifClose = NO;
        
        timer = [NSTimer  scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(shine) userInfo:nil repeats:YES];
    }
    else
    {
        [timer invalidate];
        redpot.hidden = YES;
        NSLog(@"off");
        [self.btnCamera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        //        [sender setImage:IMAGE(@"camera") forState:UIControlStateNormal];
        _cam.ifClose = YES;
        
//        RF_CloseRecordFile(_cam.mp4Handle);
//        RF_DestroyFormatLib();
        [_rjone RJONE_uninitMp:_cam.mp4Handle];

        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path))
        {
            dispatch_async(dispatch_get_global_queue(0, 0),
                           ^{
                               UISaveVideoAtPathToSavedPhotosAlbum(path, self, nil, nil);
                           });
        }
    }
    
}
-(void)local{
    //    if (self.isAuto || self.isCharge || !self.isLocal) {
    //        [self.btnLocal setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //        [self.btnAuto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [self.btnRecharge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        self.isAuto = false;
    //        self.isCharge = false;
    //        self.isLocal = true;
    //    }
    //    else {
    //        [self.btnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        self.isLocal = false;
    //    }
    
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_FIXED_CLEAN :1 :0 :0];
}

-(void)shine
{
    redpot.hidden = !redpot.hidden;
}

- (void)startTimer
{
    if(mThreadTimer==nil){
        mLockTimer=[[NSConditionLock alloc] initWithCondition:NOTDONE];
        mThreadTimer=[[NSThread alloc] initWithTarget:self selector:@selector(ThreadTimer) object:nil];
        [mThreadTimer start];
    }
}

-(void)stopTimer
{
    m_bTimer=NO;
    if(mThreadTimer!=nil){
        [mLockTimer lockWhenCondition:DONE];
        [mLockTimer unlock];
        
        mLockTimer  =nil;
        mThreadTimer=nil;
    }
    [_connect_timer invalidate];
    _connect_timer = nil;
}
- (void)ThreadTimer
{
    NSLog(@"    ThreadTimer going...\n");
    [mLockTimer lock];
    m_bTimer=YES;
    while(m_bTimer)
    {
        [NSThread sleepForTimeInterval:3];
    }
    [mLockTimer unlockWithCondition:DONE];
    
    NSLog(@"=== ThreadTimer exit ===");
}
- (void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)take_pic
{
    [_rjone StartShot];    //141128   EngelChen
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:YES];
}
- (void)myPanel
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.25];
    //    _panelView.hidden = !_panelView.hidden;
    [UIView commitAnimations];
}
- (void)myResolutionChange
{
    if (_cam.resolution == IOCTRL_QUALITY_QVGA)
    {
        [_cam Rjone_SetParameter:0x02 :(char)IOCTRL_QUALITY_720P :(char)NULL :(char)NULL];
        _cam.m_delegateCam=nil;
        _resolution = IOCTRL_QUALITY_VGA;
    }
    if (_cam.resolution == IOCTRL_QUALITY_VGA)
    {
        [_cam Rjone_SetParameter:0x02 :(char)IOCTRL_QUALITY_QVGA :(char)NULL :(char)NULL];
        
        _cam.m_delegateCam=nil;
        _resolution = IOCTRL_QUALITY_QVGA;
    }
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = LOCAL(@"please_wait");
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:10];
    
    _cam.cleanFifo = true;
}
- (void)mystop
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    [_cam Rjone_PtzControl:IOCTRL_PTZ_STOP :1 :0 :0];
    
}
- (void)camUp
{
    [_cam Rjone_PtzControl:IOCTRL_PTZ_UP :1 :0 :0];
}
- (void)camDown
{
    [_cam Rjone_PtzControl:IOCTRL_PTZ_DOWN :1 :0 :0];
}
- (void)Up
{
    //    int i = RJONE_LibUpdateGetVersion ([_cam setHandle]);
    //    NSLog(@"%ld",(long)self.cam.version);
    [_cam Rjone_PtzControl:IOCTRL_PTZ_FORWARD_SHORT :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_FORWARD_SHORT]} repeats:YES];
}
- (void)Down
{
    [_cam Rjone_PtzControl:IOCTRL_PTZ_BACKWARD_SHORT :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_BACKWARD_SHORT]} repeats:YES];
}
- (void)left
{
    [_cam Rjone_PtzControl:IOCTRL_PTZ_MOTO_TURN_L :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_MOTO_TURN_L]} repeats:YES];
}
- (void)right
{
    
    [_cam Rjone_PtzControl:IOCTRL_PTZ_MOTO_TURN_R :1 :0 :0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(longTap:) userInfo:@{@"key": [NSNumber numberWithChar:IOCTRL_PTZ_MOTO_TURN_R]} repeats:YES];
}
- (void)longTap:(NSTimer *)timer
{
    [_cam Rjone_PtzControl:[[[timer userInfo] objectForKey:@"key"] charValue] :1 :0 :0];
}
- (void)power
{
    //    self.isOn = !self.isOn;
    //    if (self.isOn == NO) {
    //        self.isLocal = false;
    //        self.isAuto = false;
    //        self.isCharge = false;
    //        [self.btnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [self.btnAuto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [self.btnRecharge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    //    }
    [_cam Rjone_getBattCapacity];
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_POWER_ONOFF :1 :0 :0];
    
    
}
//RECORD_FORAMT_STREAM_INFO stVideoStream;
//RECORD_FORAMT_STREAM_INFO stAudioStream;
void * FileReadHandle = NULL;
void * FileWriteHandle = NULL;
//RECORD_FILE_INFO stFileInfo;
int iFrameSize = 0;
char * pFrameData = NULL;
int iFilePlayTime = 0;
int iStreamIndex = 0;
int isKeyFrame= 0;
int ret;
NSString *  filename_recv;
NSString* path;
-(void *)Createfile
{
    
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString* currentDateStr=[dateFormatter stringFromDate:[NSDate date]];
    NSString* fileName=[NSString stringWithFormat:@"Flyco_%@.mp4",currentDateStr];
    path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
    void *  FileWriteHandle =  [_rjone RJONE_InitMp4File:path andwidth:640 andheight:480 andisaudio:0 andframe:20];
    if( FileWriteHandle != NULL )
    {
        printf("new.mp4 ok\n");
        _cam.ifClose = NO;
    }
    else
    {
        _cam.ifClose = YES;
        printf("new.mp4 failed!\n");
    }
    return FileWriteHandle;
    return nil;
}
-(void)myDust:(UIButton *)dust
{
    NSLog(@"dust");
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_FIXED_CLEAN :1 :0 :0];
    
}
- (void)charge
{
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_CHARGE :1 :0 :0];
    
}
- (void)mySpeed
{
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_SPEED :1 :0 :0];
}
- (void)autoClean
{
    
    [_cam Rjone_PtzControl:IOCTRL_CLEANER_AUTO_CLEAN :1 :0 :0];
}



- (void)Question:(UIButton *)question
{
    _showError = !_showError;
    if (_showError)
    {
        [question setTitle:[NSString stringWithFormat:@"%02ld",(long)_cam.error] forState:UIControlStateNormal];
        question.titleLabel.font = [UIFont fontWithName:@"DS-Digital" size:25];
    }
    else
    {
        [question setTitle:LOCAL(@"question") forState:UIControlStateNormal];
        question.titleLabel.font = [UIFont systemFontOfSize:11];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 右上角菜单键
-(void)myEdit{
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.camDID = @"";
    FKManageDeviceViewController* controller = [[FKManageDeviceViewController alloc]initWithNibName:@"FKManageDeviceViewController" bundle:nil];
    controller.userType = self.cam.userType;
    controller.deviceId = self.cam.nsDeviceId;
    controller.cam = self.cam;
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event{
    if (_drop) {
        [_drop hideDropDown:optionButton];
        [_drop removeFromSuperview];
        _drop = nil;
    }
}

#pragma mark -
#pragma mark DelegateCamera
- (void) refreshFrame:(uint8_t *)imgData withVideoWidth:(NSInteger)width videoHeight:(NSInteger)height withObj:(NSObject *)obj
{
    if(m_nWidth!=width || m_nHeight!=height)
    {
        m_nWidth =width;
        m_nHeight=height;
        m_bytesPerRow =m_nWidth*3;
        m_nImgDataSize=m_nWidth*m_nHeight*3;
    }
    CGDataProviderRef provider=CGDataProviderCreateWithData(NULL, imgData, m_nImgDataSize, NULL);
    CGImageRef ImgRef=CGImageCreate(width,
                                    height,
                                    8,
                                    24,
                                    m_bytesPerRow,
                                    m_colorSpaceRGB, kCGBitmapByteOrderDefault,
                                    provider, NULL,true,kCGRenderingIntentDefault);
    if(provider!=nil) CGDataProviderRelease(provider);
    if(self.imgVideo.contentMode!=UIViewContentModeScaleToFill) self.imgVideo.contentMode=UIViewContentModeScaleToFill;
    self.imgVideo.image=[UIImage imageWithCGImage:ImgRef];
    
    if (!_isSaveImg)
    {
        //退出视图时保存最后一帧会crash,改成保存首帧
        //取document目录
        //        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString *path = [arr objectAtIndex:0];
        //        NSData *data = UIImageJPEGRepresentation(self.imgVideo.image,0.5);
        //        [data writeToFile:[path stringByAppendingPathComponent:_cam.nsDID] atomically:YES];
        _isSaveImg = YES;
    }
    
    if(ImgRef!=nil)   CGImageRelease(ImgRef);
    
    //    [self.view bringSubviewToFront:self.btnCamDown];
    //    [self.view bringSubviewToFront:self.btnCamUp];
    //    [self.view bringSubviewToFront:self.lblCamera];
    
}

//如果进入页面设备未连接.待设备连接成功后,后调用该方法,重新启动音视频
- (void) refreshSessionInfo:(int)infoCode withObj:(NSObject *)obj withString:(NSString *)strValue;
{
    if(obj==nil) return;
    if(infoCode==CONN_INFO_CONNECTED)
    {
//        [self deviceConnected];
        [_cam startVideo:AV_TYPE_REALAV withTime:0L];
    }
    [self.view sendSubviewToBack:self.imgVideo];
}

- (void) refreshSessionInfo:(NSInteger)mode
                   OnlineNm:(NSInteger)onlineNm
                 TotalFrame:(NSInteger)totalFrame
                       Time:(NSInteger)time_s
{
    float fFPS=0.0f;
    if(time_s>0)
        fFPS=totalFrame*1.0f/time_s;
    
    NSString *nsMode=@"Unknown";
    if(mode==CONN_MODE_P2P) nsMode=@"P2P";
    else if(mode==CONN_MODE_RLY) nsMode=@"Relay";
    _FPSLabel.text = [NSString stringWithFormat:@"N=%ld, %0.2fFPS",(long)onlineNm,fFPS];
}


#pragma skDropDownDelegate
- (void) skDropDownDelegateMethod: (SKDropDown *) sender
{
    [self closeDropDown];
}

-(void)closeDropDown{
    [self.drop hideDropDown:optionButton];
    self.drop = nil;
}


- (void) updateRecvIOCtrl:(int)ioType withIOData:(char *)pIOData withSize:(int)nIODataSize withObj:(NSObject *)obj
{
}


- (void)ChangeResolution
{
    _cam.m_delegateCam=self;
    _cam.resolution = _resolution;
    if (_cam.resolution == IOCTRL_QUALITY_QVGA)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            //            [_HD setBackgroundImage:IMAGE(@"normal_hd_normal") forState:UIControlStateNormal];
            [self.btnDef setTitle:@"标清" forState:UIControlStateNormal];
            [WToast showWithText:LOCAL(@"normal")];
        });
    }
    if (_cam.resolution == IOCTRL_QUALITY_VGA)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            //            [_HD setBackgroundImage:IMAGE(@"normal_hd_pressed") forState:UIControlStateNormal];
            [self.btnDef setTitle:@"高清" forState:UIControlStateNormal];
            [WToast showWithText:LOCAL(@"hd")];
        });
    }}

- (void)ChangeStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _statusView.statusType = _cam.statusType;
        
        if (_cam.speed)
        {
            [_speed setTitle:LOCAL(@"slow") forState:UIControlStateNormal];
        }
        else
        {
            [_speed setTitle:LOCAL(@"fast") forState:UIControlStateNormal];
        }
    });
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark -
#pragma mark DelegateCamera

-(void)GetImage:(UIImage*)img
{
    if(img != nil)
    {
        if(_isSaveImgStatus == 1 || _isSaveImgStatus == 3 || _isSaveImgStatus == -1)
        {
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            //查看是否具有访问相册权限
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusDenied)
            {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
                SaveImage  = -2;
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:NO];
                return;
            }
            
            if (author == ALAuthorizationStatusAuthorized)
            {
                SaveImage = 1;
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:NO];
            }
        }
    }
    else  if(_isSaveImgStatus == 1 || _isSaveImgStatus == 3 || _isSaveImgStatus == -1)
    {
        SaveImage = -1;
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(TimeShowImageStatus:) userInfo:nil repeats:NO];
    }
    if(img != nil)
    {
        if (!_isSaveImg && _isSaveImgStatus == 2)
        {
            //退出视图时保存最后一帧会crash,改成保存首帧
            //取document目录
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [arr objectAtIndex:0];
            NSData *data = UIImageJPEGRepresentation(img,0.5);
            [data writeToFile:[path stringByAppendingPathComponent:_cam.nsDID] atomically:YES];
            _isSaveImg = YES;
            _isSaveImgStatus = 3;
        }
        
    }
}
-(void) TimeShowImageStatus:(NSTimer*) timer
{
    if(SaveImage != 0)
    {
        if(-2 == SaveImage)
        {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:LOCAL(@"canNotAccessAlbum1") message:LOCAL(@"canNotAccessAlbum2") delegate:self cancelButtonTitle:LOCAL(@"confirm") otherButtonTitles:nil, nil];
            [alter show];
            
        }
        else if(-1 == SaveImage)
        {
            [WToast showWithText:LOCAL(@"screenshot_fail")];
        }
        else if(1 == SaveImage)
        {
            [WToast showWithText:LOCAL(@"screenshot_success")];
        }
        SaveImage = 0;
        [timer invalidate];
    }
}


-(void)postVideoStartResp:(int)type
{
    if(-1 == _isSaveImgStatus)
    {
        _isSaveImgStatus = 1;
    }
}

-(void)postVideoStopResp:(int) type
{
    
}


-(void) StartSaveOneImg2Doc:(NSTimer*) timer
{
    if(1 == _isSaveImgStatus)
    {
        _isSaveImgStatus = 2;
        //    [_rjone StartShot];
        
        [timer invalidate];
    }
}



typedef enum
{
    CODECID_UNKN = 1,
    CODECID_V_MJPEG,
    CODECID_V_MPEG4,
    CODECID_V_H264,
    
    CODECID_A_PCM ,
    CODECID_A_ADPCM,
    CODECID_A_SPEEX,
    CODECID_A_AMR,
    CODECID_A_AAC,
    CODECID_A_G711A,
    CODECID_A_G726,
    CODECID_A_AC3,
    CODECID_A_MP3,
}RJONE_CODE_TYPE;

typedef struct _GET_RECORD_PARAMETERS_RESP
{
    INT32 	s32Result;			//RJONE_SUCCESS ≥…π¶:    ß∞‹∑µªÿ¥ÌŒÛ‘≠“Ú
    UINT32 u32RecordTimeSec;				//  ”–¥•∑¢ ¬º˛ ±£¨¬º∂‡…Ÿ√Îµƒ¬ºœÒ°£
    unsigned char   u8RecordFileFormat;			//  ¬ºœÒŒƒº˛∏Ò Ω £¨≤Œøº RJONG_FILE_FORMAT
    unsigned char    u8Reserved[7];
}RJONE_GET_RECORD_PARAMETERS_RESP;




//IOCTRL_TYPE_SET_RECORD_PARAMETERS_REQ,
//IOCTRL_TYPE_SET_RECORD_PARAMETERS_RESP,
typedef struct _SET_RECORD_PARAMETERS_REQ
{
    UINT32 u32RecordTimeSec;				//  ”–¥•∑¢ ¬º˛ ±£¨¬º∂‡…Ÿ√Îµƒ¬ºœÒ°£
    unsigned char   u8RecordFileFormat;			//  ¬ºœÒŒƒº˛∏Ò Ω £¨≤Œøº RJONG_FILE_FORMAT
    unsigned char    u8Reserved[7];
}RJONE_SET_RECORD_PARAMETERS_REQ;

enum
{
    FILE_FORMAT_NONE    = 0,
    FILE_FORMAT_AVI,
    FILE_FORMAT_MP4,
}RJONG_FILE_FORMAT;

typedef enum
{
    ADATABITS_8	= 0,
    ADATABITS_16	= 1,
}RJONE_AUDIO_DATABITS;

typedef enum
{
    ACHANNEL_MONO	= 0,
    ACHANNEL_STEREO	= 1,
}RJONE_AUDIO_CHANNEL;



#pragma mark DelegateCamera
-(void)postH264InitDecode:(int) type
{
    
}

- (void)postH264DecodeData:(unsigned char *)data anddatasize:(int)length
{
    [_rjone RJONE_H264DecodeData:( uint8_t  *)data anddatasize:length];
    if (self.isRecordOn && _cam.ifClose == NO&& _cam.mp4Handle)
        [_rjone RJONE_StartwriteVideoFrame:_cam.mp4Handle data:data length:length];}
-(void)postH264FiniDecode:(int) type
{
    
}

#pragma mark timeSelectDelegate
-(void)clickCancel{
    [timeSelect removeFromSuperview];
    [empty removeFromSuperview];
}

-(void)clickConfirm{
    [timeSelect removeFromSuperview];
    [timeSelect removeFromSuperview];
}

-(void)chooseDate{
        FKSelectDateViewController* controller = [[FKSelectDateViewController alloc]initWithNibName:@"FKSelectDateViewController" bundle:nil];
        controller.dateArray = timeSelect.dateArray;
        [self.navigationController pushViewController:controller animated:YES];

}
@end
