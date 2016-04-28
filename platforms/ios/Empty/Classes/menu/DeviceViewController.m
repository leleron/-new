//
//  DeviceViewController.m
//  Empty
//
//  Created by leron on 15/5/12.
//  Copyright (c) 2015年 李荣. All rights reserved.
//


#import "DeviceViewController.h"
//#import "HomeController.h"
#import "GSetting.h"
#import "CamObj.h"
#import "FMDatabaseAdditions.h"
#import "SplashViewController.h"
#import "SQLSingle.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "VideoController.h"
#import "WToast.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "deviceListMock.h"
#import "UserInfo.h"
#import "deviceListSection.h"
#import "deviceInfoEntity.h"
#import "cleanerCell.h"
#import "deleteDeviceMock.h"
#import "CycleScrollView.h"
#import "WXApi.h"
#import "WXApiObject.h"
//#import "MNWheelView.h"
#import "addDevice.h"
#import "deviceView.h"
#import "AirCleanerViewController.h"
#import "AirCleanerEntity.h"
#import "MYBlurIntroductionView.h"
#import "MYIntroductionPanel.h"
#import "TryDeviceViewController.h"
#import "TryAirCleanerViewController.h"
#import "DeviceViewController.h"
#import "TryDeviceListViewController.h"
#import "AddDeviceViewController.h"
#import "Reachability.h"
#import "bleInfoEntity.h"
#import "BTDeviceViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

DeviceViewController* device_instance;

@interface DeviceViewController ()<MYIntroductionDelegate,CBCentralManagerDelegate, CBPeripheralDelegate>
{
    UITapGestureRecognizer* tableViewTap;   //点击tableView
    AVAudioPlayer *player;
    UIButton* trydevice;
}
@property (weak, nonatomic) IBOutlet UIButton *btnTryDevice;

@property(strong,nonatomic)MYBlurIntroductionView* myView;

@property(strong,nonatomic) NSArray* imgArray;
@property(strong,nonatomic) NSArray* nameArray;
@property(strong,nonatomic)NSTimer* timer;
@property(strong,nonatomic)deviceListMock* myListMock;
@property(strong,nonatomic)CamObj* obj;
@property(strong,nonatomic)NSMutableArray* dataSource;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnAddDevice;


@property (strong,nonatomic)deleteDeviceMock* myDeleteMock;
@property(strong,nonatomic)CycleScrollView* adView;
@property(strong,nonatomic)addDevice* myAddDevice;     //增加设备
@property(strong,nonatomic)NSMutableArray* deviceViewArray;   //设备显示view
//@property(strong,nonatomic)MNWheelView* myWheelView;
@property(strong,nonatomic)UIAlertController* alert;
@property(strong,nonatomic)UILabel *loginTagView;
@property(strong,nonatomic)NSMutableArray* KVTableCellArray;   //存放kvcell
@property(strong,nonatomic)NSMutableArray* AirCleanerCellArray;  //存放airCell
@property(strong,nonatomic)NSTimer* refreshTableTimer;
@property(strong,nonatomic)AirCleanerMock* airCleanerMock;
@property(strong,nonatomic)AirCleanerParam* airCleanerParam;
@property(strong,nonatomic)NSString* hasCam;
@property(strong,nonatomic)NSString* hasAirCleaner;
@property(strong,nonatomic)NSString* hasBle;
@property (nonatomic, strong) CBCentralManager *manager;//本地中央
@property (nonatomic, strong) CBPeripheral *peripheral;//标示当前连接的外围
@property (nonatomic, strong) NSMutableArray *blueDataSource;//搜索到外围设备

@end

@implementation DeviceViewController
{
    GSetting *_gSetting;
    BOOL _isTableEdit;
    
    UIButton *addButton;
    BOOL ifAdd; //判断下拉菜单是否收回
    SKDropDown *drop;

}

+(DeviceViewController *)share
{
    return device_instance;
}


- (void)viewDidLoad {
    
    self.navigationItem.title = @"我的设备";
    [super viewDidLoad];
    
    self.KVTableCellArray = [[NSMutableArray alloc]init];
    self.AirCleanerCellArray = [[NSMutableArray alloc]init];
    device_instance = self;

    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
//    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.editing = NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataSource = [[NSMutableArray alloc]init];
    [self.btnTryDevice addTarget:self action:@selector(gotoTryDevice) forControlEvents:UIControlEventTouchUpInside];
//    self.btnTryDevice.hidden = YES;
    [self.btnAddDevice addTarget:self action:@selector(showAddView) forControlEvents:UIControlEventTouchUpInside];
//    [self getDeviceData];
//    [self loadDeviceView];
    //刷新设备连接状态
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RefreshStatus) name:@"RefreshStatus" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDeviceData) name:@"refreshDeviceTable" object:nil];

    Reachability* reach = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    
    
    [reach startNotifier];
//
    
    [self sound];
}


-(void)sound{
//    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"暧昧" ofType:@"mp3"]] error:nil];//使用本地URL创建
//    player.volume =0.8;//0.0-1.0之间
//    [player prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
//    [player play];//播放
    //    [player stop];//停止
    
}

-(void)createRightButton{
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 25, 21.96);
    [addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(showAddView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];

}

-(void)initQuickMock{
    self.airCleanerMock = [AirCleanerMock mock];
    self.airCleanerMock.delegate = self;
    self.airCleanerParam = [AirCleanerParam param];
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
        [self presentViewController:self.alert animated:YES completion:^{
            
            //            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        NSLog(@"no wifi");
    }
}


-(void)gotoTryDevice{
    
    TryDeviceListViewController* controller = [[TryDeviceListViewController alloc]initWithNibName:@"TryDeviceListViewController" bundle:nil];
    [WpCommonFunction hideTabBar];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 展示广告页
//展示广告页
- (void)showBasicIntroWithBg {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) nibNamed:@"TestPanel1"];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) nibNamed:@"TestPanel2"];
    
    
    //Create Panel From Nib
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) nibNamed:@"TestPanel3"];
    
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3];
    
    //Create the introduction view and set its delegate
    self.myView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.myView.delegate = self;
    //    self.myView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [self.myView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:self.myView];
    
}

-(void)introDidFinish{
        // 保存已经看完的标记
    [WpCommonFunction saveDeviceLookoverGuidePageToLocal];
    self.myView.hidden = YES;
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
    [WpCommonFunction saveDeviceLookoverGuidePageToLocal];
    self.myView.hidden = YES;
}

#pragma mark 加载view
-(void)loadDeviceView{
    self.hasCam = nil;
    self.hasAirCleaner = nil;
    if (self.deviceViewArray) {
        [self.deviceViewArray removeAllObjects];
    }else{
        self.deviceViewArray = [[NSMutableArray alloc]init];
    }
    
    for (NSObject* item in self.dataSource) {
        if ([item isKindOfClass:[CamObj class]]) {
            CamObj* cam = (CamObj*)item;
//            [self.deviceViewArray removeObject:examCam];
            self.hasCam = @"YES";
            [self.deviceViewArray addObject:cam];
        }
        if ([item isKindOfClass:[AirCleanerEntity class]]) {
            AirCleanerEntity* e = (AirCleanerEntity*)item;
//            [self.deviceViewArray removeObject:examAir];
            self.hasAirCleaner = @"YES";
            [self.deviceViewArray addObject:e];
        }
        if ([item isKindOfClass:[bleInfoEntity class]]) {
            self.hasBle = @"YES";
            [self.deviceViewArray addObject:item];
        }
    }
//    if (![self.hasCam isEqualToString:@"YES"]) {
//        CamObj* examCam = [[CamObj alloc]init];
//        examCam.nsDeviceId = @"example_kv";
//        examCam.nsCamName = @"扫地机器人";
//        [self.deviceViewArray addObject:examCam];
//    }
//    if (![self.hasAirCleaner isEqualToString:@"YES"]) {
//        AirCleanerEntity* examAir = [[AirCleanerEntity alloc]init];
//        examAir.deviceId = @"example_cleaner";
//        examAir.deviceName = @"空气净化器";
//        [self.deviceViewArray addObject:examAir];
//    }
    [self.myTableView reloadData];
}

-(void)addTryDevice{
    if (trydevice) {
        [trydevice removeFromSuperview];
    }
    trydevice = [UIButton buttonWithType:UIButtonTypeCustom];
    [trydevice setTitle:@"试用其他设备" forState:UIControlStateNormal];
//    [WpCommonFunction setView:trydevice cornerRadius:8];
    trydevice.frame = CGRectMake(0, self.deviceViewArray.count*140+10, SCREEN_WIDTH, 50);
    [trydevice setBackgroundColor:Color_Bg_Line];
    [trydevice addTarget:self action:@selector(gotoTryDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableView addSubview:trydevice];
    [self.myTableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.myTableView.frame.size.height+50)];
//    for (NSLayoutConstraint* item in self.view.constraints) {
//        if ([item.identifier isEqualToString:@"tableBottom"]) {
//            item.constant = 50;
//        }
//    }


}
//-(void)loadDeviceView{
//    [[ViewControllerManager sharedManager]showWaitView:self.view];
//    if (self.myWheelView) {
//        [self.myWheelView removeFromSuperview];
//        self.myWheelView = nil;
//    }
//    if (self.deviceViewArray) {
//        [self.deviceViewArray removeAllObjects];
//    }else{
//        self.deviceViewArray = [[NSMutableArray alloc]init];
//    }
//    MNWheelView *view=[[MNWheelView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 520)];
//    self.myWheelView = view;
//    deviceView *view1 = [QUNibHelper loadNibNamed:@"deviceView" ofClass:[deviceView class]];
//    view1.lblName.text = @"扫地机器人";
//    view1.deviceId = @"example_kv";
////    view1.picDevice.image = [UIImage imageNamed:@"device_Pic"];
//    deviceView *view2=[QUNibHelper loadNibNamed:@"deviceView" ofClass:[deviceView class]];
////    view2.picDevice.image = [UIImage imageNamed:@"device_Pic"];
//    view2.deviceId = @"example_cleaner";
//    view2.lblName.text = @"空气净化器";
//    [self.deviceViewArray addObject:view1];
//    [self.deviceViewArray addObject:view2];
//    for (NSObject* item in self.dataSource) {
//        if ([item isKindOfClass:[CamObj class]]) {
//            CamObj* obj = (CamObj*)item;
//            deviceView* kvView = [QUNibHelper loadNibNamed:@"deviceView" ofClass:[deviceView class]];
//            kvView.deviceId = obj.nsDeviceId;
//            kvView.lblName.text = obj.nsCamName;
//            kvView.lblTry.hidden = YES;
//            kvView.mCamState = obj.mCamState;
//            [self.deviceViewArray addObject:kvView];
//            [self.deviceViewArray removeObject:view1];
//        }
//        if ([item isKindOfClass:[AirCleanerEntity class]]) {
//            AirCleanerEntity* e = (AirCleanerEntity*)item;
//            deviceView* kvView = [QUNibHelper loadNibNamed:@"deviceView" ofClass:[deviceView class]];
//            kvView.deviceId = e.deviceId;
//            kvView.lblName.text = e.deviceName;
//            if ([e.runningStatus isEqualToString:@"online"]) {
//                kvView.lblState.text = @"已连接";
//            }else{
//                kvView.lblState.text = @"未连接";
//            }
//            kvView.lblTry.hidden = YES;
//            [self.deviceViewArray addObject:kvView];
//            [self.deviceViewArray removeObject:view2];
//        }
//    }
//
//    //        view.imageNames=[NSArray arrayWithObjects:@"a",@"b",@"c",@"d", nil];  view.imageNames 和view.images 二选一
//    view.images=self.deviceViewArray;
//    view.backgroundColor=[UIColor clearColor];
//    view.click=^(int i)
//    {
//        [self tryDevice:i];
//        //        NSLog(@"单击了%d",i);
//        
//    };
//    [self.view addSubview:view];
//    [[ViewControllerManager sharedManager]hideWaitView];
//
//}

-(void)showAddView{
    
    
    UserInfo* myUserInfo = [UserInfo restore];
    //判断用户是否已经登陆
    if (!myUserInfo) {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"请登录后添加设备，是否登录？" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* actionLogin = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
            LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [WpCommonFunction hideTabBar];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        [controller addAction:actionLogin];
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [controller addAction:actionCancel];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        
//        if (!self.myAddDevice) {
//            self.navigationBarTitle = @"设备";
//            [self setNavigationTitle];
//            self.myAddDevice = [QUNibHelper loadNibNamed:@"addDevice" ofClass:[addDevice class]];
//            [self.view addSubview:self.myAddDevice];
//            [UIView animateWithDuration:0.5 animations:^{
//                
//                [self.myAddDevice setFrame:CGRectMake(0, 0, self.myAddDevice.frame.size.width, self.myAddDevice.frame.size.height)];
//            }];
//            if (!tableViewTap) {
//                tableViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAddDevice)];
//            }
//            [self.myTableView addGestureRecognizer:tableViewTap];
//            [UIView commitAnimations];
//        }else{
//            self.navigationBarTitle = @"设备";
//            [self setNavigationTitle];
//            [UIView animateWithDuration:0.5 animations:^{
//                
//                [self.myAddDevice setFrame:CGRectMake(0, -200, self.myAddDevice.frame.size.width, self.myAddDevice.frame.size.height)];
//            } completion:^(BOOL finished) {
//                [self.myAddDevice removeFromSuperview];
//                self.myAddDevice  = nil;
//            }];
//            [self.myTableView removeGestureRecognizer:tableViewTap];
//            [UIView commitAnimations];
////            [self.myAddDevice removeFromSuperview];
////            self.myAddDevice  = nil;
//        }
        AddDeviceViewController* controller = [[AddDeviceViewController alloc]initWithNibName:@"AddDeviceViewController" bundle:nil];
        [WpCommonFunction hideTabBar];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    
    
}

//-(void)addAD{
//    NSMutableArray *viewsArray = [@[] mutableCopy];
//    UIImageView* imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 320)];
//    imageView1.image = [UIImage imageNamed:@"ad"];
//    [viewsArray addObject:imageView1];
//    UIImageView* imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 320)];
//    imageView2.image = [UIImage imageNamed:@"ad"];
//    [viewsArray addObject:imageView2];
//    UIImageView* imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 320)];
//    imageView3.image = [UIImage imageNamed:@"ad"];
//    [viewsArray addObject:imageView3];
//    self.adView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 320) animationDuration:2];
//    self.adView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
//        return viewsArray[pageIndex];
//    };
//    self.adView.totalPagesCount = ^NSInteger(void){
//        return 3;
//    };
//    self.adView.TapActionBlock = ^(NSInteger pageIndex){
//        //        [self.btnTryDevice addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
//    };
//    [self.view addSubview:self.adView];
//
//}
#pragma mark  获取设备列表
-(void)getDeviceData{
    self.myListMock = [deviceListMock mock];
    self.myListMock.delegate = self;
    deviceListParam* param = [deviceListParam param];
    param.sendMethod = @"GET";
    UserInfo* myUserInfo = [UserInfo restore];
    if (myUserInfo.tokenID) {
        self.myListMock.operationType = [NSString stringWithFormat:@"/devices/%@",myUserInfo.tokenID];
        [self.myListMock run:param];
        [[ViewControllerManager sharedManager]showWaitView:self.view];
    }else{
        [self cleanUserDeviceList];   //清除列表数据
        [self loadDeviceView];        //刷新页面
    }
}


-(void)viewWillAppear:(BOOL)animated{
    UserInfo *myUserInfo = [UserInfo restore];
    if (myUserInfo) {
        [self.loginTagView removeFromSuperview];
        self.loginTagView = nil;
    } else  if(self.loginTagView == nil){
        self.loginTagView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        self.loginTagView.textAlignment = NSTextAlignmentCenter;
        self.loginTagView.font = [UIFont systemFontOfSize:14];
        self.loginTagView.textColor = [UIColor whiteColor];
        self.loginTagView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:72.0f/255.0f blue:138.0f/255.0f alpha:1.0f];
        self.loginTagView.text = @"您还未登录，请登录后添加并使用设备";
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLogin:)];
        
        [self.loginTagView addGestureRecognizer:tapGesture];
        self.loginTagView.userInteractionEnabled = YES;
        [self.view addSubview:self.loginTagView];
        self.imgLogo.hidden = NO;
        self.btnAddDevice.hidden = NO;
        self.btnTryDevice.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;

    } else {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLogin:)];
        
        [self.loginTagView addGestureRecognizer:tapGesture];
        self.loginTagView.userInteractionEnabled = YES;
        [self.view addSubview:self.loginTagView];
    }
    if (self.myAddDevice == nil) {
        self.navigationBarTitle = @"我的设备";
        [self setNavigationTitle];
    }
    [super viewWillAppear:animated];
//    [WpCommonFunction showTabBar];
//    if (!_timer)
//    {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getConnected) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
//    }
//    if (!_refreshTableTimer) {
//        self.refreshTableTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(RefreshAirCleanStatus) userInfo:nil repeats:YES];
//    }
    
    [self getDeviceData];    //每次切换刷新列表

}

- (void)gotoLogin:(id)sender {
    LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [WpCommonFunction hideTabBar];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)tryDevice:(NSInteger)i {
    [WpCommonFunction hideTabBar];
        NSString* deviceId = @"";
    NSObject* selected = [self.deviceViewArray objectAtIndex:i];
    if ([selected isKindOfClass:[CamObj class]]) {
        CamObj* cam = (CamObj*)selected;
        deviceId = cam.nsDeviceId;
    }
    if ([selected isKindOfClass:[AirCleanerEntity class]]) {
        AirCleanerEntity* e = (AirCleanerEntity*)selected;
        deviceId = e.deviceId;
    }
    for (NSObject* item in self.deviceViewArray) {
        if ([item isKindOfClass:[CamObj class]]) {
            CamObj* obj = (CamObj*)item;
            if ([obj.nsDeviceId isEqual:deviceId]) {
                
                if ([deviceId isEqualToString:@"example_kv"]) {
                TryDeviceViewController* controller = [[TryDeviceViewController alloc]initWithNibName:@"TryDeviceViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [WpCommonFunction hideTabBar];
                [self.navigationController pushViewController:controller animated:YES];

                }else{
                    VideoController* controller = [[VideoController alloc]initWithNibName:@"VideoController" bundle:nil];
                    controller.cam = obj;
                    controller.hidesBottomBarWhenPushed = YES;
                    [WpCommonFunction hideTabBar];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }

        }
        if ([item isKindOfClass:[AirCleanerEntity class]]) {
            AirCleanerEntity* e = (AirCleanerEntity*)item;
            if ([e.deviceId isEqualToString:deviceId]) {
                
                if ([deviceId isEqualToString:@"example_cleaner"]) {
                AirCleanerViewController* controller = [[AirCleanerViewController alloc] initWithNibName:@"AirCleanerViewController" bundle:nil airCleaner:nil];
                controller.hidesBottomBarWhenPushed = YES;
                    controller.isReal = NO;
                [WpCommonFunction hideTabBar];
                [self.navigationController pushViewController:controller animated:YES];
   
                }else{
                    AirCleanerViewController* controller = [[AirCleanerViewController alloc] initWithNibName:@"AirCleanerViewController" bundle:nil airCleaner:e];
                    //                controller.cleaner = e;
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.isReal = YES;
                    [WpCommonFunction hideTabBar];
                    [self.navigationController pushViewController:controller animated:YES];
 
                }
            }
        }
        if ([item isKindOfClass:[bleInfoEntity class]]) {
            bleInfoEntity* e = (bleInfoEntity*)item;
            for (CBPeripheral* ble in self.blueDataSource) {
                if ([e.deviceName isEqualToString:ble.name]) {
                    self.peripheral = ble;
                }
            }
            if (self.peripheral) {
                [self.manager connectPeripheral:self.peripheral options:nil];
            }
        }
    }
//    controller.hidesBottomBarWhenPushed = YES;
//    [WpCommonFunction hideTabBar];
//    [self.navigationController pushViewController:controller animated:YES];
}

//清除用户数据列表
-(void)cleanUserDeviceList{
    [self.dataSource removeAllObjects];
    
}

-(void)searchBlueDevice{
    self.blueDataSource = [[NSMutableArray alloc]init];
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.manager scanForPeripheralsWithServices:nil options:dic];
}


#pragma mark blueToothDelegate
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
//    NSLog(@"self.nDataSource.count %lu", (unsigned long)self.blueDataSource.count);
//    NSLog(@"didDiscoverPeripheral %@", peripheral);
    BOOL isContained = NO;
    for (CBPeripheral *cbPeripheral in self.blueDataSource) {
        if (cbPeripheral == peripheral) {
            isContained = YES;
        }
    }
    if (!isContained) {
        if ([peripheral.name hasPrefix:@"FLYCO"]) {
            NSLog(@"didDiscoverPeripheral %@", peripheral);
            [self.blueDataSource addObject:peripheral];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected to peripheral %@", peripheral);
    [self.manager stopScan];
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];

}

- (void)peripheral:(CBPeripheral *)aPeripheral
didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"service count : %lu", (unsigned long)aPeripheral.services.count);
    for (CBService *service in aPeripheral.services) {
        // Discovers the characteristics for a given service
            NSLog(@"Service found with UUID: %@", service.UUID);
            [self.peripheral discoverCharacteristics:nil
                                          forService:service];
    }
    //    NSLog(@"%d",self.peripheral.isConnected?1:0);
    BTDeviceViewController *controller = [[BTDeviceViewController alloc] initWithPeripheral:self.peripheral];
    [self.navigationController pushViewController:controller animated:YES];
}



- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"Central Manager state CBCentralManagerStateUnknown");
            self.peripheral = nil;
            self.blueDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"Central Manager state CBCentralManagerStateUnsupported");
            self.peripheral = nil;
            self.blueDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"Central Manager state CBCentralManagerStateUnauthorized");
            self.peripheral = nil;
            self.blueDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"Central Manager state CBCentralManagerStateResetting");
            self.peripheral = nil;
            self.blueDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"Central Manager state CBCentralManagerStatePoweredOff");
            self.peripheral = nil;
            self.blueDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            break;
        default:
            NSLog(@"Central Manager default");
            break;
    }
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[deviceListMock class]]) {
        [self cleanUserDeviceList];    //清除用户已有的设备信息
        deviceListEntity* e = (deviceListEntity*)entity;
        if (e.OwnedDeviceList) {
            self.imgLogo.hidden = YES;
            self.btnAddDevice.hidden = YES;
            self.btnTryDevice.hidden = YES;
            [self createRightButton];
            [self.dataSource removeAllObjects];
//            [self.pAdaptor.pSources.pEntityList removeAllObjects];
            for (NSDictionary* item in e.OwnedDeviceList) {
                NSString* productCode = [item objectForKey:@"productCode"];
                if ([productCode hasPrefix:@"96"]) {
                    CamObj* e = [[CamObj alloc]init];
                    NSString* macID = [item objectForKey:@"macId"];
                    if (![macID hasPrefix:@"FKZN"]) {
                        e.nsDID = [NSString stringWithFormat:@"FKZN-%@",macID];
                    }else{
                        e.nsDID = [item objectForKey:@"macId"];
                        }
                    e.nsCamName = [item objectForKey:@"deviceName"];
                    e.nsViewPwd = [item objectForKey:@"devicePassword"];
                    e.nsDeviceId = [item objectForKey:@"deviceId"];
                    e.userType = [item objectForKey:@"userType"];
                    e.runningStatus = [item objectForKey:@"runningStatus"];
                    e.deviceType = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"productCategory"],[item objectForKey:@"productCode"]];
                    [self.dataSource addObject:e];
                    
                }
                if ([productCode hasPrefix:@"90"]) {
                    AirCleanerEntity* e = [AirCleanerEntity entity];
                    e.deviceId = [item objectForKey:@"deviceId"];
                    e.deviceName = [item objectForKey:@"deviceName"];
                    e.macId = [item objectForKey:@"macId"];
                    e.runningStatus = [item objectForKey:@"runningStatus"];
                    e.userType = [item objectForKey:@"userType"];
                    e.deviceType = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"productCategory"],[item objectForKey:@"productCode"]];
                    e.productModel = [item objectForKey:@"productModel"];
                    e.productCode = [item objectForKey:@"productCode"];
                    e.deviceVersion = [item objectForKey:@"deviceVersion"];
                    [self.dataSource addObject:e];
                }
                if ([productCode isEqualToString:@"7008"]) {
                    bleInfoEntity* e = [bleInfoEntity entity];
                    e.deviceId = [item objectForKey:@"deviceId"];
                    e.deviceName = [item objectForKey:@"deviceName"];
                    e.macId = [item objectForKey:@"macId"];
                    e.runningStatus = [item objectForKey:@"runningStatus"];
                    e.userType = [item objectForKey:@"userType"];
                    e.deviceType = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"productCategory"],[item objectForKey:@"productCode"]];
                    e.productModel = [item objectForKey:@"productModel"];
                    e.productCode = [item objectForKey:@"productCode"];
                    e.deviceVersion = [item objectForKey:@"deviceVersion"];
                    [self.dataSource addObject:e];
                    [self searchBlueDevice];
                }
            }
//            
//            NSMutableArray* temp = [NSArray arrayWithArray:self.dataSource];
//            self.dataSource = [[temp reverseObjectEnumerator] allObjects];

            
            //用户设备列表保存到全局以便后面判断
            [[WHGlobalHelper shareGlobalHelper]put:e.OwnedDeviceList key:USER_DEVICE_LIST];
            [[WHGlobalHelper shareGlobalHelper]put:self.dataSource key:USER_DEVICE_DATA];
//            UserInfo* myUserInfo = [UserInfo restore];
            
//            myUserInfo.deviceArray = self.dataSource;
//            [[WHGlobalHelper shareGlobalHelper]put:self.dataSource key:USER_DEVICE_DATA];
//            [myUserInfo store];
            [self loadDeviceView];    //重新加载设备页面
//            [self addTryDevice];      //增加试用设备按钮
        }else{
            self.imgLogo.hidden = NO;
            self.btnAddDevice.hidden = NO;
            self.btnTryDevice.hidden = NO;
            [self cleanUserDeviceList];
            [self loadDeviceView];
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    if ([mock isKindOfClass:[deleteDeviceMock class]]) {
        identifyEntity* e = (identifyEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            NSLog(@"删除成功");
        }
    }
    if ([mock isKindOfClass:[AirCleanerMock class]]) {
        AirCleanerEntity* e = (AirCleanerEntity*)entity;
        for (deviceListSection* s in self.AirCleanerCellArray) {
            if ([s.macId isEqualToString:e.mac_id]) {
                if ([e.onlineStatus isEqualToString:@"online"]) {
                    s.lblStatus.text = @"在线";
                }else{
                    s.lblStatus.text = @"不在线";
                }

            }
        }
    }
}




#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.deviceViewArray.count == 0) {
        tableView.editing = NO;
        return 0;
    }else
        return self.deviceViewArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    if (indexPath.row == self.deviceViewArray.count) {
        UITableViewCell* add = [[UITableViewCell alloc]init];
        trydevice = [UIButton buttonWithType:UIButtonTypeCustom];
        [trydevice setTitle:@"试用其他设备" forState:UIControlStateNormal];
        //    [WpCommonFunction setView:trydevice cornerRadius:8];
        trydevice.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [trydevice setBackgroundColor:Color_Bg_Line];
        [trydevice addTarget:self action:@selector(gotoTryDevice) forControlEvents:UIControlEventTouchUpInside];
        [add addSubview:trydevice];
        return add;
    }else{
    deviceListSection *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"deviceListSection" owner:self options:nil] lastObject];
        [self.myTableView registerNib:[UINib nibWithNibName:@"deviceListSection" bundle:nil] forCellReuseIdentifier:cellid];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
    if (indexPath.row != 0) {
        cell.imgLine.hidden = YES;
    }else{
        cell.imgLine.hidden = NO;
    }
    
    NSObject *item = [self.deviceViewArray objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[CamObj class]]) {
        CamObj* cam = (CamObj*)item;
        cell.lblProductName.text = @"智能扫地机器人";
        if ([cam.nsDeviceId isEqualToString:@"example_kv"]) {
            cell.imgIcon.image = [UIImage imageNamed:@"9605"];
            cell.lblTitle.text = cam.nsCamName;
            cell.lblStatus.text = @"点击试用";
        }else{
            [self.KVTableCellArray addObject:cell];
            cell.deviceId = cam.nsDeviceId;
            cell.nsName = cam.nsCamName;
            cell.mCamState = cam.mCamState;
            cell.lblTitle.text = cam.nsCamName;
            if ([cam.deviceType isEqualToString:@"FC9605"]) {
                cell.imgIcon.image = [UIImage imageNamed:@"9605"];
            }
            if ([cam.deviceType isEqualToString:@"FC9606"]) {
                cell.imgIcon.image = [UIImage imageNamed:@"9606"];
            }
            if ([cam.runningStatus isEqualToString:@"online"]) {
                cell.lblStatus.text = @"在线";
            }else{
                cell.lblStatus.text = @"不在线";
            }

            
        }
    }
    if ([item isKindOfClass:[AirCleanerEntity class]]) {
        AirCleanerEntity* e = (AirCleanerEntity*)item;
            cell.lblProductName.text = @"智能空气净化器";
        if ([e.deviceId isEqualToString:@"example_cleaner"]) {
            cell.imgIcon.image = [UIImage imageNamed:@"airCleaner"];
            cell.lblTitle.text = e.deviceName;
            cell.lblStatus.text = @"点击试用";
        }else{
            [self.AirCleanerCellArray addObject:cell];     //添加到空净数组
            cell.imgIcon.image = [UIImage imageNamed:@"airCleaner"];
            cell.lblTitle.text = e.deviceName;
            cell.macId = e.macId;
            if ([e.runningStatus isEqualToString:@"online"]) {
                cell.lblStatus.text = @"在线";
            }else{
                cell.lblStatus.text = @"不在线";
            }

        }
    }
        if ([item isKindOfClass:[bleInfoEntity class]]) {
            bleInfoEntity* e = (bleInfoEntity*)item;
            cell.lblProductName.text = @"蓝牙健康秤";
            cell.imgIcon.image = [UIImage imageNamed:@"cheng"];
            cell.lblTitle.text = e.deviceName;
            cell.macId = e.macId;
            if ([e.runningStatus isEqualToString:@"online"]) {
                cell.lblStatus.text = @"在线";
            }else{
                cell.lblStatus.text = @"不在线";
            }
            
        }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.deviceViewArray.count) {
        return 50;
    }else
        return 140;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CamObj *cam = [self.dataSource objectAtIndex:indexPath.row];
//    VideoController* controller = [[VideoController alloc]init];
//    controller.cam = cam;
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
    if (self.myAddDevice) {
        [self.myAddDevice removeFromSuperview];
        self.myAddDevice = nil;
    }else{
        [self tryDevice:indexPath.row];
    }

}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    deviceListSection *cell = (deviceListSection*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = BLUECOLOR;
//    cell.b.hidden = _isTableEdit;
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CamObj* cam = [self.deviceViewArray objectAtIndex:indexPath.row];
    [cam stopAll];
    self.myDeleteMock = [deleteDeviceMock mock];
    self.myDeleteMock.delegate = self;
    self.myDeleteMock.operationType = [NSString stringWithFormat:@"/devices/%@/delete",cam.nsDeviceId];
    deleteDeviceParam* param = [deleteDeviceParam param];
    UserInfo* myUserInfo = [UserInfo restore];
    param.TOKENID = myUserInfo.tokenID;
    [self.myDeleteMock run:param];
    [self.deviceViewArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
}





-(void)viewDidAppear:(BOOL)animated{
    [WpCommonFunction showTabBar];
    [super viewDidAppear:animated];
//    [self.myCollectionView reloadData];
}

- (void)getConnected
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        GSetting *gSetting=[GSetting instance];
//        NSArray *array = [NSArray arrayWithArray:gSetting.arrCam];
        for (NSObject   *item in self.dataSource)
        {
            if ([item isKindOfClass:[CamObj class]]) {
                CamObj* cam = (CamObj*)item;
                [cam getLastError];
                if ([cam getLastError] <0)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [cam startConnect:10];
                    });
                }

            }
            
        }
    });
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

- (void)myAdd
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.camDID = @"";
    UserInfo* myUserInfo = [UserInfo restore];
    //判断用户是否已经登陆
    if (!myUserInfo) {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"需要登录才能使用，是否登录？" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* actionLogin = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
            LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        [controller addAction:actionLogin];
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [controller addAction:actionCancel];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
    
    ifAdd = !ifAdd;
    NSArray *titleArray = [[NSArray alloc] initWithObjects:SAO_YI_SAO,ADD_DEVICE, nil];
        
        AddDeviceViewController* controller = [[AddDeviceViewController alloc]initWithNibName:@"AddDeviceViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
//    if(drop == nil)
//    {
////        CGFloat dropDownListHeight = 64; //Set height of drop down list
////        NSString *direction = @"down"; //Set drop down direction animation
////        CGFloat height = 60;
////        CGFloat width = 80;
////        drop = [[SKDropDown alloc]init];
////         [drop showDropDown:addButton withHeight:&dropDownListHeight withData:titleArray animationDirection:direction withFrameHeight:&height withFrameWidth:&width];
////        drop.delegate = self;
//    }
//    else
//    {
//        [drop hideDropDown:addButton];
//        drop = nil;
//    }
    }
}


- (void) skDropDownDelegateMethod: (SKDropDown *) sender
{
    [self closeDropDown];
}

-(void)closeDropDown{
    [drop hideDropDown:addButton];
    [drop removeFromSuperview];
    drop = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeAddDevice{
    if (self.myAddDevice) {
        [self.myAddDevice removeFromSuperview];
        self.myAddDevice = nil;
    }else{
        [self.myTableView removeGestureRecognizer:tableViewTap];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.myAddDevice) {
        [self.myAddDevice removeFromSuperview];
        self.myAddDevice = nil;
    }
}
#pragma mark -UICollectionView delegate
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;  {
//    GSetting* gset = [GSetting instance];
//    
//    return [gset.arrCam count];
//}
//-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    deviceCell *cell = (deviceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"deviceCell" forIndexPath:indexPath];
//    GSetting* gset = [GSetting instance];
//    CamObj* cam = [gset.arrCam objectAtIndex:indexPath.row];
//    cell.imgDevice.image = [self.imgArray objectAtIndex:0];
//    cell.lblName.text = cam.nsCamName;
//    
//    UILongPressGestureRecognizer* longPressRecongnizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
//    [cell addGestureRecognizer:longPressRecongnizer];
//    longPressRecongnizer.minimumPressDuration = 1.0;
//    longPressRecongnizer.delegate = self;
//    longPressRecongnizer.view.tag = (int)indexPath.row;
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(95, 116);
//}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
//    GSetting* get = [GSetting instance];
//    VideoController *video = [[VideoController alloc]init];
//    video.cam = [get.arrCam objectAtIndex:indexPath.row];
//    if(video.cam.mCamState == CONN_INFO_CONNECTED)
//    {
//        video.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:video animated:YES];
//    }
//    else
//    {
////        NSString *messtr = [NSString stringWithFormat:@"%@%@",LOCAL(@"devices"),LOCAL(@"operation")];
//        [WToast showWithText:@"连接失败"];
//    }
//
//}

#pragma mark 长按操作
//-(void)longPress:(UILongPressGestureRecognizer*) recognizer{
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        GSetting* gset = [GSetting instance];
//        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:recognizer.view.tag inSection:0];
//        NSArray* deleteItems = @[indexPath];
//    //    [self.myCollectionView deleteItemsAtIndexPaths:deleteItems];
//        CamObj *cam=[gset.arrCam objectAtIndex:(int)indexPath.row];
//        [gset.arrCam removeObjectAtIndex:[indexPath row]];
//        //Disconnect device
//        [self.myCollectionView deleteItemsAtIndexPaths:deleteItems];
//        for(int i =(int)[indexPath row]+1;i<[self.myCollectionView.subviews count];i++){
//           UICollectionViewCell* cell= (deviceCell*)[self.myCollectionView.subviews objectAtIndex:i];
//            if ([cell isKindOfClass:[deviceCell class]]) {
//                cell.tag = cell.tag -1;
//            }
//        }
//        [cam stopAll];
//        
//        //delete from DB
//        SQLSingle *sql = [SQLSingle shareSQLSingle];
//        [sql.dataBase executeUpdate:@"delete from camre_info where DEV_ID=?",cam.nsDID];
//        [self.myCollectionView reloadData];
//
//    }else if (recognizer.state == UIGestureRecognizerStateEnded){
//        NSLog(@"已删除");
//    }
//}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.myAddDevice) {
        [self.myAddDevice removeFromSuperview];
        self.myAddDevice = nil;
    }
    [_timer invalidate];
    _timer = nil;
    [_refreshTableTimer invalidate];
    _refreshTableTimer = nil;
    
}


- (void)RefreshStatus
{
    
    for (deviceListSection* item in self.KVTableCellArray) {
        if (item.deviceId) {
            for (NSObject* e in self.dataSource) {
                if ([e isKindOfClass:[CamObj class]]) {
                    CamObj* obj = (CamObj*)e;
                    if ([item.deviceId isEqualToString:obj.nsDeviceId]) {
                        item.mCamState = obj.mCamState;
                    }
   
                }
            }
        }
    }
//    [self loadDeviceView];
}

-(void)RefreshAirCleanStatus{
    _airCleanerMock = [AirCleanerMock mock];
    _airCleanerMock.delegate = self;
    UserInfo* u = [UserInfo restore];
    for (deviceListSection* cell in self.AirCleanerCellArray) {
        NSString* macId = cell.macId;
        _airCleanerMock.operationType = [NSString stringWithFormat:@"%@%@/allstatus?tokenId=%@",AC_BASE_URL,macId,u.tokenID];
        _airCleanerParam = [AirCleanerParam param];
        _airCleanerParam.sendMethod = @"GET";
        [self.airCleanerMock run:self.airCleanerParam];
    }

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
