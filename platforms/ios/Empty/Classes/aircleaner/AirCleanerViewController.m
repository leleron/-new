//
//  AirCleanerViewController.m
//  Empty
//
//  Created by duye on 15/8/19.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "AirCleanerViewController.h"
#import "ACErrorMessageMock.h"
#import "DeviceErrorViewController.h"
#import "ProvinceViewController.h"
#import "getCityPmMock.h"
#import "deviceMessageReadMock.h"
#import "Constant.h"
@interface AirCleanerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ionCleanLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutDownOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSelectLabel;
@property (weak, nonatomic) IBOutlet UILabel *outdoor_airquality;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *outdoor_pm;
@property (weak, nonatomic) IBOutlet UIButton *lightEffect;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *liziButton;
@property (weak, nonatomic) IBOutlet UIButton *btnPower;
@property (weak, nonatomic) IBOutlet UIButton *shijianButton;
@property (weak, nonatomic) IBOutlet UIButton *fengsuButton;
@property (weak, nonatomic) IBOutlet UIView *underBackView;
@property (weak, nonatomic) IBOutlet UIView *upBackView;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblHint1;
@property (weak, nonatomic) IBOutlet UILabel *lblHint2;
@property (weak, nonatomic) IBOutlet UIImageView *imgLight;

@property (weak, nonatomic) IBOutlet UIView *pickerButtonView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView2;

@property(strong,nonatomic)UIButton* CancelYuyueButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelYYButton;
@property (weak, nonatomic) IBOutlet UIButton *savaBUtton;
//@property (weak, nonatomic) IBOutlet UIImageView *imgPower;
//@property (weak, nonatomic) IBOutlet UIImageView *imgYuyue;
//@property (weak, nonatomic) IBOutlet UIImageView *imgLightEffect;
//@property (weak, nonatomic) IBOutlet UIImageView *imgFengsu;

@property(strong,nonatomic)AirCleanerMock* airCleanerMock;
@property(strong,nonatomic)ACanionswitchMock *acanionswitchMock;
@property(strong,nonatomic)ACfilteroneswitchMock *acfilteroneswitchMock;
@property(strong,nonatomic)ACfiltertwoswitchMock *acfiltertwoswitchMock;
@property(strong,nonatomic)ACfilterthreeswitchMock *acfilterthreeswitchMock;
@property(strong,nonatomic)AClightswitchMock *aclightswitchMock;
@property(strong,nonatomic)ACpowerswitchMock *acpowerswitchMock;
@property(strong,nonatomic)ACrunningmodelMock *acrunningmodeMock;
@property(strong,nonatomic)ACtimerMock *actimerMock;
@property(strong,nonatomic)WeatherdataMock *weatherdataMock;
@property(strong,nonatomic)ACQuietModeMock *acQuietModeMock;
@property(strong,nonatomic)ACinitializeDeviceDataMock *acinitializeDeviceDataMock;
@property(strong,nonatomic)ACErrorMessageMock* errorMessageMock;
@property(strong,nonatomic)getCityPmMock* cityPMmock;
@property(strong,nonatomic)deviceMessageReadMock* messageReadMock;
@end

@implementation AirCleanerViewController{
    ProgressView *progress;
    NSArray *hours;
    NSArray *minites;
    NSDictionary *pickerDictionary;
    UIPickerView *pickerViewTime;
//    UIPickerView *pickerView2;     //风速调节
    NSArray *Winds;
//    UIView *pickerButtonView;
    UIView *filterView;
    NSTimer *uiUpdateTimer;
    NSTimer *dataUpdateTimer;
    NSTimer *ErrorTimer;
    //滤网tableView
    UITableView *filterTableView;
    UIView* empty;
    //下个view
    UIButton *filterResetButton;
    FKACManageDeviceViewController* fkacManageDeviceViewController;
    NSString* selectedHour;   //选择的小时
    
    //http请求的参数
    //全属性
    AirCleanerParam* airCleanerParam;
    //灯效参数
    AClightswitchParam* acLightswitchParam;
    //离子净化开关
    ACanionswitchParam* acanionswitchParam;
    //时间预约
    ACtimerParam* actimerparam;
    //风速
    ACrunningmodelParam* acrunningmodelParam;
    //开关
    ACpowerswitchParam* acpowerswitchParam;
    //室外空气
    WeatherdataParam* weatherdataParam;
    //静默模式开关
    ACQuietModeParam* acQuietModeParam;
    
    //滤网1
    ACfilteroneswitchParam* acfilteroneswitchParam;
    //滤网2
    ACfiltertwoswitchParam* acfiltertwoswitchParam;
    //滤网3
    ACfilterthreeswitchParam* acfilterthreeswitchParam;
    
    ACinitializeDeviceDataParam* acinitializeDeviceDataParam;
    
    UIAlertController* lvwangAlert;
    //显示状态
    int showStatus;
    // 重置滤网标识
    int lvwang;
    BOOL isFirst;
    BOOL hasRead;    //有没有读过滤网消息
}

@synthesize cleaner;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil airCleaner:(AirCleanerEntity*)airCleaner{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initUIWithAirCleaner:airCleaner];
    }
    
    return self;
}
#pragma mark view周期
- (void)viewDidLoad {
    self.navigationBarTitle = cleaner.deviceName;
    [super viewDidLoad];
    [self showLeftNormalButton:@"go_back" highLightImage:@"go_back" selector:@selector(Back)];
    if (self.isReal) {
        [_acinitializeDeviceDataMock run:acinitializeDeviceDataParam];
    }
    _filterButton.hidden = YES;
    [self.btnLocation addTarget:self action:@selector(gotoChooseCity) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPower addTarget:self action:@selector(turnOnOff) forControlEvents:UIControlEventTouchUpInside];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitAccount) name:@"exitAccount" object:nil];
    _outdoor_airquality.text = @"室外空气质量";
    _outdoor_airquality.hidden = YES;
    if (self.isReal) {
        [self checkErrorMessage];
    }
    isFirst = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    self.navigationBarTitle = cleaner.deviceName;
    if (!self.isReal) {
        self.navigationBarTitle = @"试用空气净化器";
    }
    [self setNavigationTitle];
    [self filterBackButtonClicked];
    [WpCommonFunction hideTabBar];
    [super viewWillAppear:animated];
//    [[ViewControllerManager sharedManager]showWaitView:self.view];
    if (!uiUpdateTimer && self.isReal)
    {
        uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getAllStatus) userInfo:nil repeats:YES];
        dataUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        //        [self httpRequestPreFunc];
        [uiUpdateTimer fire];
        
    }
    if (!self.isReal) {
        uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        //        [self httpRequestPreFunc];
        [uiUpdateTimer fire];
    }
    if (self.PM) {
        self.outdoor_pm.text = self.PM;
        cleaner.outdoor_pm = self.PM;
        self.outdoor_pm.text = self.PM;
        self.location.text = self.City;
    }
    
    if (!self.PM) {
        //        self.btnLocation.hidden = NO;
        [self.btnLocation setTitle:@"未能识别当前所在地，请手动选择" forState:UIControlStateNormal];
        _outdoor_airquality.hidden = NO;
        UserInfo* userInfo = [UserInfo restore];
        _weatherdataMock.operationType = [NSString stringWithFormat:@"/devices/getweatherdata/%@?deviceId=%@",userInfo.tokenID,cleaner.deviceId];
        if (self.isReal) {
            [_weatherdataMock run:weatherdataParam];     //没手动选择
        }
    }else{                                         //手动选择
        //        self.btnLocation.hidden = YES;
        self.location.text = self.City;
        cleaner.location = self.City;
        [self.btnLocation setTitle:@"" forState:UIControlStateNormal];
        _outdoor_airquality.hidden = NO;
        self.cityPMmock.operationType = [NSString stringWithFormat:@"/devices/find/getCityPm25?cityCode=%@&deviceId=%@",self.cityCode,self.cleaner.deviceId];
        QUMockParam* param = [QUMockParam param];
        param.sendMethod = @"GET";
        if (self.isReal) {
            [self.cityPMmock run:param];
        }
    }
    if (!self.isReal) {
        self.btnLocation.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (uiUpdateTimer) {
        [uiUpdateTimer invalidate];
        uiUpdateTimer = nil;
    }
    if (ErrorTimer) {
        [ErrorTimer invalidate];
        ErrorTimer = nil;
    }
}





-(void)Back{
    if (empty) {
        [self hideShadow];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)exitAccount{
    [uiUpdateTimer invalidate];
    uiUpdateTimer = nil;
    [ErrorTimer invalidate];
    ErrorTimer = nil;
}


//http请求前先做得
- (void)httpRequestPreFunc{
    //打开菊花
    [[ViewControllerManager sharedManager]showWaitView:self.navigationController.view];
}

#pragma mark 右上角菜单键
-(void)myEdit{
    NSLog(@"myEdit");
    if (empty) {
        [self hideShadow];
    }else{
        if (self.isReal){
            fkacManageDeviceViewController.cleaner = cleaner;
        }
    [self.navigationController pushViewController:fkacManageDeviceViewController animated:YES];
    }
    
}

-(void)checkErrorMessage{
    if (!self.errorMessageMock) {
        self.errorMessageMock = [ACErrorMessageMock mock];
        self.errorMessageMock.delegate = self;
    }
    UserInfo* u = [UserInfo restore];
    NSLog(@"%@",u.tokenID);
    self.errorMessageMock.operationType = [NSString stringWithFormat:@"/devices/%@/messages?tokenId=%@",self.cleaner.deviceId,u.tokenID];
    ACErrorMessageParam* param = [ACErrorMessageParam param];
    param.sendMethod = @"GET";
    [self.errorMessageMock run:param];
}


-(void)gotoChooseCity{
    ProvinceViewController* controller = [[ProvinceViewController alloc]initWithNibName:@"ProvinceViewController" bundle:nil];
    controller.deviceId = self.cleaner.deviceId;
    [self.navigationController pushViewController:controller animated:YES];
}

//获取全部信息
- (void)getAllStatus{
    UserInfo* userInfo = [UserInfo restore];
    _airCleanerMock.operationType = [NSString stringWithFormat:@"%@%@/allstatus?tokenId=%@",AC_BASE_URL,cleaner.macId,userInfo.tokenID];
    airCleanerParam = [AirCleanerParam param];
    airCleanerParam.sendMethod = @"GET";
    [_airCleanerMock run:airCleanerParam];
}

//调节灯效
- (IBAction)ionClean:(id)sender {

    
    
}

-(void)addEmptyView{
    empty = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height/2-20)];
    empty.backgroundColor = [UIColor blackColor];
    empty.alpha = 0.5;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShadow)];
    [empty addGestureRecognizer:gesture];
    [self.view addSubview:empty];

}

//时间预约
- (IBAction)shutDownOrder:(id)sender {
    [self addEmptyView];
    self.CancelYuyueButton.hidden = NO;
    progress.hidden = !progress.hidden;
//    if ([cleaner.time_status isEqualToString:@"timeno"]) {
        _pickerButtonView.hidden = NO;
        _pickerView2.hidden = YES;
        pickerViewTime.hidden = NO;
    [self hiddenFunction];
}


-(void)hideShadow{
    
    progress.hidden = NO;
    if (!_pickerButtonView.isHidden) {
        _pickerButtonView.hidden = YES;
    }
    
//    if (pickerViewTime) {
//        pickerViewTime.hidden = YES ;
//    }
//    if (self.pickerView2) {
//        self.pickerView2.hidden = YES ;
//    }
    CGRect currentFrame = filterView.frame;
    if (currentFrame.origin.x==0) {
        filterView.frame = CGRectMake(DEVICE_WIDTH, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    }

    [empty removeFromSuperview];
    empty = nil;
    [self showFunction];
}


//风速调节
- (IBAction)windSelect:(id)sender {
    [self addEmptyView];
    self.CancelYuyueButton.hidden = YES;
    progress.hidden = !progress.hidden;
    _pickerButtonView.hidden = NO;
    _pickerView2.hidden = NO;
    pickerViewTime.hidden = YES;
    
//    Winds = @[@"睡眠模式",@"风速1档",@"风速2档",@"风速3档",@"强风模式",@"智能模式"];

    if ([cleaner.runningMode isEqualToString:@"auto"]) {
        [_pickerView2 selectRow:5+60 inComponent:0 animated:NO];
    } else if ([cleaner.runningMode isEqualToString:@"sleep"]){
        [_pickerView2 selectRow:60 inComponent:0 animated:NO];
    } else if ([cleaner.runningMode isEqualToString:@"strong"]){
        [_pickerView2 selectRow:64 inComponent:0 animated:NO];
    } else if ([cleaner.runningMode isEqualToString:@"one"]){
        [_pickerView2 selectRow:61 inComponent:0 animated:NO];
    } else if ([cleaner.runningMode isEqualToString:@"two"]){
        [_pickerView2 selectRow:62 inComponent:0 animated:NO];
    } else if ([cleaner.runningMode isEqualToString:@"three"]){
        [_pickerView2 selectRow:63 inComponent:0 animated:NO];
    } else {
        NSLog(@"不存在的模式");
    }

    
    
    [self hiddenFunction];
}
//灯效
- (IBAction)lightEffect:(id)sender {
    
    if (self.isReal) {
        if ([cleaner.runningMode isEqualToString:@"sleep"]) {
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"睡眠模式无法设置灯效"];
        }else{
            NSString *switchTemp = @"";
            if ([cleaner.light_status isEqualToString:@"lighton"]) {
                switchTemp = @"lighthalfon";
            } else if([cleaner.light_status isEqualToString:@"lighthalfon"]){
                switchTemp = @"lightoff";
            } else if([cleaner.light_status isEqualToString:@"lightoff"]){
                switchTemp = @"lighton";
            } else {
                NSLog(@"不存在的灯效");
            }
            acLightswitchParam.lightswitch = switchTemp;
            [self.aclightswitchMock run:acLightswitchParam];
            [self httpRequestPreFunc];
        }
    }else{
        if ([cleaner.light_status isEqualToString:@"lighton"]) {
            cleaner.light_status = @"lighthalfon";
        } else if([cleaner.light_status isEqualToString:@"lighthalfon"]){
            cleaner.light_status = @"lightoff";
        } else if([cleaner.light_status isEqualToString:@"lightoff"]){
            cleaner.light_status = @"lighton";
        } else {
            NSLog(@"不存在的灯效");
        }
        [self updateUI];
    }
    
    
}

//滤网
- (IBAction)filter:(id)sender {
    [self addEmptyView];
//    [UIView animateWithDuration:0.3 animations:^{
        CGRect currentFrame = filterView.frame;
        filterView.frame = CGRectMake(0, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
        [filterTableView setSeparatorStyle:NO];
        [filterTableView setEditing:NO];
        [filterResetButton setTitle:@"重置滤网" forState:UIControlStateNormal];
        [filterTableView reloadData];

//    }];
}

//开关
- (void)turnOnOff{
    if (self.isReal) {
        if ([cleaner.powerSwitch isEqualToString:@"poweron"]) {
            acpowerswitchParam.powerswitch = @"poweroff";
        } else {
            acpowerswitchParam.powerswitch = @"poweron";
        }
        [self.acpowerswitchMock run:acpowerswitchParam];
        [self httpRequestPreFunc];
    }else{
        if ([cleaner.powerSwitch isEqualToString:@"poweron"]) {
            cleaner.powerSwitch = @"poweroff";
        }else{
            cleaner.powerSwitch = @"poweron";
        }
    }
    [self updateUI];
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 0) {
        return 5;
    }
    if (pickerView.tag == 1) {
        return 5;
    }
}

//静默模式
- (void)quietModeSwitchChange{
    
    if (self.isReal) {
        
    
    if ([cleaner.powerSwitch isEqualToString:@"poweroff"]) {
//        [WpCommonFunction showNotifyHUDAtViewBottom:delegate.topController.view withErrorMessage:@"关机状态无法进行设置"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"关机状态无法进行设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [fkacManageDeviceViewController.quietModeSwitch setOn:![fkacManageDeviceViewController.quietModeSwitch isOn] animated:YES];
    } else {
        if (fkacManageDeviceViewController.quietModeSwitch.on) {
            //开启静默模式
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"关机实时检测，开启后可以在关机状态下实时监测室内空气质量，但是需要增加2W的功率，大约每天需要0.05度的电能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
                [fkacManageDeviceViewController.quietModeSwitch setOn:![fkacManageDeviceViewController.quietModeSwitch isOn] animated:YES];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                acQuietModeParam.quietmode = @"quietmodeon";
                [_acQuietModeMock run:acQuietModeParam];
                [self httpRequestPreFunc];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            //                [WpCommonFunction showNotifyHUDAtViewBottom:delegate.topController.view withErrorMessage:@"传感器开启需要增加2W的功率，大约每天需要0.05度的电能"];
        } else {
            //关闭静默模式
            acQuietModeParam.quietmode = @"quietmodeoff";
            [_acQuietModeMock run:acQuietModeParam];
            [self httpRequestPreFunc];
        }
    }
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"试用设备无法设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alertaction){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    //    }
}

#pragma mark pickerView Delegate
-(CGFloat) pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        switch (component) {
            case 0:
                return hours.count*100;
                break;
            case 1:
                return minites.count*100;
                break;
            default:
                return 1;
                break;
        }
    }
    if (pickerView.tag == 1) {
//        return Winds.count;
        return 1200;
    }
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        switch (component) {
            case 0:
                return [hours objectAtIndex:row%9];
                break;
            case 1:
                if ([selectedHour isEqualToString:@"00"]) {
                    return [minites objectAtIndex:row%59];
                }else
                    return [minites objectAtIndex:row%60];
                break;
            default:
                return @"";
                break;
        }
    }
    if (pickerView.tag == 1) {
        return [Winds objectAtIndex:row];
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        switch (component) {
            case 0:
                return DEVICE_WIDTH/3;
                break;
            case 1:
                return DEVICE_WIDTH/3;
                break;
            default:
                return 0;
                break;
        }
    }
    if (pickerView.tag == 1) {
        return DEVICE_WIDTH;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (pickerView.tag == 0) {
        UILabel *myView = [[UILabel alloc] init];
        myView.font = [UIFont systemFontOfSize:26];
        if (iPhone4) {
            myView.font = [UIFont systemFontOfSize:20];
        }
        myView.textColor = [UIColor whiteColor];
        myView.backgroundColor = [UIColor clearColor];
        if (component == 0) {
//            myView.text = [hours objectAtIndex:row];
            myView.text = [NSString stringWithFormat:@"%@",[hours objectAtIndex:row%9]];
            myView.textAlignment = NSTextAlignmentCenter;
        }else {
            if ([selectedHour isEqualToString:@"00"]) {
                myView.text = [minites objectAtIndex:row%59];
            }else if([selectedHour isEqualToString:@"08"]){
                myView.text = [minites objectAtIndex:0];
            }else{
                myView.text = [minites objectAtIndex:row%60];
            }
            myView.textAlignment = NSTextAlignmentCenter;
        }
        return myView;
    }
    if (pickerView.tag == 1) {
        UILabel *myView = [[UILabel alloc] init];
        myView.font = [UIFont systemFontOfSize:26];
        myView.textColor = [UIColor whiteColor];
        myView.backgroundColor = [UIColor clearColor];
        myView.text = [Winds objectAtIndex:row%[Winds count]];
        myView.textAlignment = NSTextAlignmentCenter;
        return myView;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
    //    如果选取的是第一个选取器
    if (component == 0) {
        //        得到第一个选取器的当前行
        NSString *selectedState =[hours objectAtIndex:row%9];
        selectedHour = selectedState;
        //        根据从pickerDictionary字典中取出的值，选择对应第二个中的值
        NSArray *array = [pickerDictionary objectForKey:selectedState];
        minites=array;
        [pickerViewTime selectRow:0 inComponent:1 animated:YES];
        
        
        //        重新装载第二个滚轮中的值
        [pickerViewTime reloadComponent:1];
      }
    }
    if (pickerView.tag == 1) {
        
    }
}

#pragma mark   取消确定功能
//点击取消
-(void)pikerCancle{
    progress.hidden = !progress.hidden;
    NSLog(@"pikerCancle");
    _pickerButtonView.hidden = YES;
    [self hideShadow];
    [self showFunction];
}
//点击存储
-(void)pikerSave{
    progress.hidden = !progress.hidden;
    if (pickerViewTime.isHidden == NO && self.isReal) {
        actimerparam.time_status = @"timeyes";
        NSString *h = [hours objectAtIndex:[pickerViewTime selectedRowInComponent:0]%9];
        NSString *m = nil;
        if ([h isEqualToString:@"00"]) {
            m = [minites objectAtIndex:[pickerViewTime selectedRowInComponent:1]%59];
        }else if([h isEqualToString:@"08"]){
            m = [minites objectAtIndex:0];
        }else{
            m = [minites objectAtIndex:[pickerViewTime selectedRowInComponent:1]%60];
        }
        actimerparam.time_remind = [NSString stringWithFormat:@"%i",h.intValue * 60 + m.intValue];
        [_actimerMock run:actimerparam];
        [self httpRequestPreFunc];
    }
    if (pickerViewTime.isHidden == NO && !self.isReal) {
        actimerparam.time_status = @"timeyes";
        NSString *h = [hours objectAtIndex:[pickerViewTime selectedRowInComponent:0]%9];
        NSString *m = nil;
        if ([h isEqualToString:@"00"]) {
            m = [minites objectAtIndex:[pickerViewTime selectedRowInComponent:1]%59];
        }else if([h isEqualToString:@"08"]){
            m = [minites objectAtIndex:0];
        }else{
            m = [minites objectAtIndex:[pickerViewTime selectedRowInComponent:1]%60];
        }
        cleaner.time_status = @"timeyes";
        cleaner.time_remaining = [NSString stringWithFormat:@"%d",h.intValue*60+m.intValue];
        [self updateUI];
    }
    
    if (_pickerView2.isHidden == NO && self.isReal) {
        NSString *mode = [Winds objectAtIndex:[_pickerView2 selectedRowInComponent:0]%[Winds count]];
        if ([mode isEqualToString:@"智能模式"]) {
            acrunningmodelParam.runningmodel = @"runmodelauto";
        } else if ([mode isEqualToString:@"睡眠模式"]) {
            acrunningmodelParam.runningmodel = @"runmodelsleep";
        } else if ([mode isEqualToString:@"强风模式"]) {
            acrunningmodelParam.runningmodel = @"runmodelstrong";
        } else if ([mode isEqualToString:@"风速1档"]) {
            acrunningmodelParam.runningmodel = @"runmodelhandone";
        } else if ([mode isEqualToString:@"风速2档"]) {
            acrunningmodelParam.runningmodel = @"runmodelhandtwo";
        } else if ([mode isEqualToString:@"风速3档"]) {
            acrunningmodelParam.runningmodel = @"runmodelhandthree";
        } else {
            NSLog(@"不存在的模式");
        }
        [self.acrunningmodeMock run:acrunningmodelParam];
        [self httpRequestPreFunc];
    }
    if (_pickerView2.isHidden == NO && !self.isReal) {
        NSString *mode = [Winds objectAtIndex:[_pickerView2 selectedRowInComponent:0]%[Winds count]];
        if ([mode isEqualToString:@"智能模式"]) {
            cleaner.runningMode = @"auto";
        } else if ([mode isEqualToString:@"睡眠模式"]) {
            cleaner.runningMode = @"sleep";
        } else if ([mode isEqualToString:@"强风模式"]) {
            cleaner.runningMode = @"strong";
        } else if ([mode isEqualToString:@"风速1档"]) {
            cleaner.runningMode = @"one";
        } else if ([mode isEqualToString:@"风速2档"]) {
            cleaner.runningMode = @"two";
        } else if ([mode isEqualToString:@"风速3档"]) {
            cleaner.runningMode = @"three";
        } else {
            NSLog(@"不存在的模式");
        }
        [self updateUI];
    }
    [filterTableView reloadData];
    _pickerButtonView.hidden = YES;
    self.btnPower.hidden = NO;
    [self hideShadow];
}

-(void)cancelYuyue{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消预约么？" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (self.isReal) {
            actimerparam.time_remind = @"0";
            actimerparam.time_status = @"timeno";
            [_actimerMock run:actimerparam];
            [self httpRequestPreFunc];
            progress.hidden = !progress.hidden;
            _pickerButtonView.hidden = YES;
            self.btnPower.hidden = NO;
            [self hideShadow];
        }else{
            cleaner.time_status = @"timeno";
            [self.shijianButton setImage:[UIImage imageNamed:@"yuyueoff"] forState:UIControlStateNormal];
            [self hideShadow];
            [self updateUI];
        }
        [pickerViewTime selectRow:450 inComponent:0 animated:NO];
        [pickerViewTime selectRow:0 inComponent:1 animated:NO];  //默认居中
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


//中间的圆圈滑动时发生UI变化
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (showStatus <= 3) {
        showStatus = showStatus + 1 * (sender.direction == UISwipeGestureRecognizerDirectionLeft ? 1 : -1);
    } else {
        showStatus = 0;
    }
    if (showStatus == 4) {
        showStatus = 0;
    }
    if (showStatus < 0) {
        showStatus = 3;
    }
    NSLog(@"%d",showStatus);
    progress.PageControl.currentPage = showStatus;
    [self updateUI];
}
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (showStatus < 3) {
        showStatus = showStatus + 1;
    } else {
        showStatus = 0;
    }
    [self updateUI];
}

-(void)checkOnlineStatus:(NSString*)runningStatus{
    if ([runningStatus isEqualToString:@"offline"]) {
        progress.inDoorAirInfoLabel.hidden = YES;
        progress.inDoorAirInfoNumLabel.hidden = YES;
        progress.OnButton.hidden = YES;
        progress.hint1.hidden = NO;
        progress.hint2.hidden = NO;
        [self.view bringSubviewToFront:self.lblHint1];
        [self.view bringSubviewToFront:self.lblHint2];
        progress.PageControl.hidden = YES;
        self.btnPower.hidden = YES;
        _ionCleanLabel.text = @"";
        _shutDownOrderLabel.text = @"";
        _windSelectLabel.text = @"";
        self.imgLight.hidden = YES;
//        _lightEffect.hidden = YES;
//        _filterButton.hidden = YES;
        
        _filterButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _lightEffect.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _liziButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _shijianButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _fengsuButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
//        fkacManageDeviceViewController.quietModeSwitch.userInteractionEnabled = NO;
        _filterButton.userInteractionEnabled = NO;
        _lightEffect.userInteractionEnabled = NO;
        _liziButton.userInteractionEnabled = NO;
        _shijianButton.userInteractionEnabled = NO;
        _fengsuButton.userInteractionEnabled = NO;
        
        float progress_height = DEVICE_HEIGHT / 2 - SCREEN_WIDTH/4*1.5-10;
        float progress_width = progress_height;
      CGRect old =  CGRectMake(DEVICE_WIDTH / 2 - progress_width / 2, DEVICE_HEIGHT / 2-5, progress_width, progress_height);
//        CENTER_VIEW(_underBackView, progress);
        progress.frame =  CGRectOffset(old, 0, 50);

        
    }else{
        progress.inDoorAirInfoLabel.hidden = NO;
        progress.inDoorAirInfoNumLabel.hidden = NO;
        progress.OnButton.hidden = NO;
        progress.hint1.hidden = YES;
        progress.hint2.hidden = YES;
        progress.PageControl.hidden = NO;
        self.btnPower.hidden = NO;
        self.imgLight.hidden = NO;
        _liziButton.titleLabel.textColor = [UIColor whiteColor];
        _shijianButton.titleLabel.textColor = [UIColor whiteColor];
        _fengsuButton.titleLabel.textColor = [UIColor whiteColor];
        _lightEffect.titleLabel.textColor = [UIColor whiteColor];
        _filterButton.titleLabel.textColor = [UIColor whiteColor];
        
//        fkacManageDeviceViewController.quietModeSwitch.userInteractionEnabled = YES;
        
        _liziButton.userInteractionEnabled = YES;
        _shijianButton.userInteractionEnabled = YES;
        _fengsuButton.userInteractionEnabled = YES;
        _lightEffect.userInteractionEnabled = YES;
        _filterButton.userInteractionEnabled = YES;
        
        float progress_height = DEVICE_HEIGHT / 2 - SCREEN_WIDTH/4*1.5-10;
        float progress_width = progress_height;
      progress.frame =  CGRectMake(DEVICE_WIDTH / 2 - progress_width / 2, DEVICE_HEIGHT / 2-5, progress_width, progress_height);
    }
//    progress.percent;
    

}

#pragma mark quMock回调
//http请求成功后的回调
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    //更新全局UI的回调
    if ([mock isKindOfClass:[ACpowerswitchMock class]]) {
        [NSThread sleepForTimeInterval:0.5f];
        [self getAllStatus];
    }
    
    
    
    if (![mock isKindOfClass:[ACinitializeDeviceDataMock class]]) {
        if ([mock isKindOfClass:[AirCleanerMock class]]) {
            AirCleanerEntity* e = (AirCleanerEntity*)entity;
            if ([e.status isEqualToString:RESULT_SUCCESS]) {
                
                NSString *deviceId = cleaner.deviceId;
                NSString *deviceName = cleaner.deviceName;
                NSString *macId = cleaner.macId;
                NSString *runningStatus = cleaner.runningStatus;
                NSString *userType = cleaner.userType;
                NSString *deviceType = cleaner.deviceType;
//                cleaner = e;
                cleaner.deviceId = deviceId;
                cleaner.deviceName = deviceName;
                cleaner.macId = macId;
                cleaner.runningStatus = runningStatus;
                cleaner.userType = userType;
                cleaner.deviceType = deviceType;
                cleaner.powerSwitch = e.powerSwitch;
                NSLog(@"%@",e.powerSwitch);
                cleaner.light_status = e.light_status;
                cleaner.temperature = [NSString stringWithFormat:@"%.f",round([e.temperature floatValue]/10)];
                cleaner.anionSwitch = e.anionSwitch;
                cleaner.humidity = [NSString stringWithFormat:@"%.f",round([e.humidity floatValue]/10)];
                cleaner.aqiStatus = e.aqiStatus;
                cleaner.voc = e.voc;
                cleaner.runningMode = e.runningMode;
                cleaner.pmValue = e.pmValue;
                cleaner.time_status = e.time_status;
                cleaner.time_remaining = e.time_remaining;
                cleaner.filterOneSwitch = e.filterOneSwitch;
                cleaner.filterTwoSwitch = e.filterTwoSwitch;
                cleaner.filterThreeSwitch = e.filterThreeSwitch;
                cleaner.quietmode = e.quietmode;
                cleaner.onlineStatus = e.onlineStatus;
                [self checkOnlineStatus:e.onlineStatus];
                if (e.message.count != 0) {
                    if (!ErrorTimer) {
                        ErrorTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkErrorMessage) userInfo:nil repeats:YES];
                    }
                }
            }
            NSArray *messageArray = (NSArray*)e.message;
            if (messageArray.count != 0) {
                [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:[messageArray objectAtIndex:0]];
            }
//            [self updateUI];
        } else if ([mock isKindOfClass:[WeatherdataMock class]]) {//室外空气
            AirCleanerEntity* e = (AirCleanerEntity*)entity;
            if ([e.status isEqualToString:RESULT_SUCCESS]) {
                cleaner.location = e.location;
                cleaner.outdoor_pm = e.outdoor_pm;
                _outdoor_airquality.hidden = NO;
                self.location.text = cleaner.location;
                self.outdoor_pm.text = cleaner.outdoor_pm;
//                self.btnLocation.hidden = YES;
                [self.btnLocation setTitle:@"" forState:UIControlStateNormal];
            }
//            [self updateUI];
        }
        else if([mock isKindOfClass:[ACErrorMessageMock class]]) {
            DeviceErrorListEntity* e = (DeviceErrorListEntity*)entity;
            DeviceErrorViewController* controller = [[DeviceErrorViewController alloc]initWithNibName:@"DeviceErrorViewController" bundle:nil];
            if ([e.deviceMessageList count] != 0) {
                NSDictionary* dict = [e.deviceMessageList objectAtIndex:0];
                if ([[dict objectForKey:@"deviceMsgStatus"] isEqualToString:@"N"]) {
                controller.errorCode = [dict objectForKey:@"failureCode"];
                controller.errorName = [dict objectForKey:@"deviceMsgTitle"];
                controller.errorDescription = [dict objectForKey:@"deviceMsgContent"];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:controller.errorCode message:controller.errorName preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                    self.messageReadMock = [deviceMessageReadMock mock];
                    self.messageReadMock.delegate = self;
                    deviceMessageReadParam *readParam = [deviceMessageReadParam param];
                    readParam.sendMethod = @"GET";
                    UserInfo* info = [UserInfo restore];
                    self.messageReadMock.operationType = [NSString stringWithFormat:@"/devices/messages/read/%@?tokenId=%@",[dict objectForKey:@"deviceMsgId"],info.tokenID];
                    [self.messageReadMock run:readParam];

                    
                    [self.navigationController pushViewController:controller animated:YES];
                }];
                [alert addAction:action1];
                [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }
        else if([mock isKindOfClass:[getCityPmMock class]]){
            getCityPMEntity* e = (getCityPMEntity*)entity;
            self.outdoor_pm.text = e.PM25;
        }
        else {
            //开一个线程等一段时间后执行getAllStatus刷新UI
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // long-running task
                [NSThread sleepForTimeInterval:WAIT_TIME];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // update UI
                    [self getAllStatus];
                });
            });
            [self updateUI];
        }
//        [self updateUI];
    }
}




#pragma mark - RNGridMenuDelegate
//风速选择结束后的回调
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
        if ([item.title isEqualToString:@"智能模式"]) {
            acrunningmodelParam.runningmodel = @"runmodelauto";
        } else if ([item.title isEqualToString:@"睡眠模式"]) {
            acrunningmodelParam.runningmodel = @"runmodelsleep";
        } else if ([item.title isEqualToString:@"强风模式"]) {
            acrunningmodelParam.runningmodel = @"runmodelstrong";
        } else if ([item.title isEqualToString:@"风速1档"]) {
            acrunningmodelParam.runningmodel = @"runmodelhandone";
        } else if ([item.title isEqualToString:@"风速2档"]) {
            acrunningmodelParam.runningmodel = @"runmodelhandtwo";
        } else if ([item.title isEqualToString:@"风速3档"]) {
            acrunningmodelParam.runningmodel = @"runmodelhandthree";
        } else {
            NSLog(@"不存在的模式");
        }
        [self.acrunningmodeMock run:acrunningmodelParam];
        [self httpRequestPreFunc];
}

//滤网界面返回按钮按下之后
- (void)filterBackButtonClicked{
//    [UIView animateWithDuration:0.3 animations:^{
        CGRect currentFrame = filterView.frame;
        filterView.frame = CGRectMake(DEVICE_WIDTH, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
        [self hideShadow];
//    }];
}

- (void)filterResetButtonClicked:(UIButton*)resetButton{
    if (filterTableView.editing == NO){
        [resetButton setTitle:@"完成" forState:UIControlStateNormal];
        filterTableView.editing = YES;
        return;
    }
    NSArray *selectedRows = [filterTableView indexPathsForSelectedRows];
    if (selectedRows.count == 0) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请选择滤网"];
    }else{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确认需要重置滤网？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self hideShadow];
        if (filterTableView.editing) {
            lvwang = 3;
            for (NSIndexPath *path in selectedRows) {
                switch (path.row) {
                    case 0:
                        [_acfilteroneswitchMock run:acfilteroneswitchParam];
                        [self httpRequestPreFunc];
                        break;
                    case 1:
                        [_acfiltertwoswitchMock run:acfiltertwoswitchParam];
                        [self httpRequestPreFunc];
                        break;
                    case 2:
                        [_acfilterthreeswitchMock run:acfilterthreeswitchParam];
                        [self httpRequestPreFunc];
                        break;
                        
                    default:
                        break;
                }
            [resetButton setTitle:@"重置滤网" forState:UIControlStateNormal];
            filterTableView.editing = NO;
            
            }
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okayAction];
    [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark tableView Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

//滤网table的相关代理函数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterCell *cell = (FilterCell*)[[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil]lastObject];
    
    
    switch (indexPath.row) {
        case 0:
            cell.filterImage.image = [UIImage imageNamed:@"clean_net"];
            cell.suggest.text = @"请定期清洗滤网";
            cell.buyFilterButton.hidden = YES;
            if (cleaner.filterOneSwitch.intValue < 100 && cleaner.filterOneSwitch.intValue != 0) {
                cell.remainDay.text = cleaner.filterOneSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (cleaner.filterOneSwitch.intValue == 0){
                cell.remainDay.text = cleaner.filterOneSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = [NSString stringWithFormat:@"%i",cleaner.filterOneSwitch.intValue / 24];
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
                cell.timeUnitLabel.text = @"天";
            }
            cell.filterType.text = @"过滤网1：初效滤网";
            break;
        case 1:
            cell.filterImage.image = [UIImage imageNamed:@"dirty_net"];
            cell.suggest.text = @"请定期更换滤网";
            cell.buyFilterButton.hidden = NO;
            if (cleaner.filterTwoSwitch.intValue < 100 && cleaner.filterTwoSwitch.intValue != 0) {
                cell.remainDay.text = cleaner.filterTwoSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (cleaner.filterTwoSwitch.intValue == 0){
                cell.remainDay.text = cleaner.filterTwoSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = [NSString stringWithFormat:@"%i",cleaner.filterTwoSwitch.intValue / 24];
                cell.timeUnitLabel.text = @"天";
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
            }
            cell.filterType.text = @"过滤网2：夹碳海帕滤网";
            break;
        case 2:
            cell.filterImage.image = [UIImage imageNamed:@"dirty_net"];
            cell.suggest.text = @"请定期更换滤网";
            cell.buyFilterButton.hidden = NO;
            if (cleaner.filterThreeSwitch.intValue < 100 && cleaner.filterThreeSwitch.intValue != 0) {
                cell.remainDay.text = cleaner.filterThreeSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (cleaner.filterThreeSwitch.intValue == 0){
                cell.remainDay.text = cleaner.filterThreeSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = [NSString stringWithFormat:@"%i",cleaner.filterThreeSwitch.intValue / 24];
                cell.timeUnitLabel.text = @"天";
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
            }
            cell.filterType.text = @"过滤网3：除甲醛滤网";
            cell.mark = @"tt";
            break;
        default:
            break;
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"tag = %i",alertView.tag);
//    NSLog(@"buttonIndex = %i",buttonIndex);
//    NSLog(@"clicked");
}



#pragma mark 初始化UI
//初始化UI
- (void)initUIWithAirCleaner:(AirCleanerEntity*)airCleaner{
    if (airCleaner) {
        cleaner = airCleaner;
    }else{
        cleaner = [AirCleanerEntity entity];
        cleaner.deviceName = @"空气净化器";
        cleaner.powerSwitch = @"poweron";
        cleaner.light_status = @"lighton";
        cleaner.outdoor_pm = @"88";
        cleaner.location = @"上海市";
        cleaner.pmValue = @"18";
        cleaner.aqiStatus = @"2";
        cleaner.humidity = @"60";
        cleaner.temperature = @"26";
        cleaner.voc = @"3";
        cleaner.runningMode = @"auto";
        cleaner.time_status = @"timeno";
        cleaner.filterOneSwitch = @"99";
        cleaner.filterTwoSwitch = @"100";
        cleaner.filterThreeSwitch = @"2000";
        cleaner.aqiStatus = @"1";
        cleaner.voc = @"1";
        cleaner.onlineStatus = @"online";
    }
    self.filterButton.hidden = YES;
    self.liziButton.hidden = YES;
    hasRead = NO;
    
    
    //圆形进度条
    float progress_height = DEVICE_HEIGHT / 2 - SCREEN_WIDTH/4*1.5;
    float progress_width = progress_height;

    
    progress = [[ProgressView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH / 2 - progress_width / 2, DEVICE_HEIGHT / 2-5, progress_width, progress_height)];
    progress.arcFinishColor = BLUECOLOR;
    progress.arcBackColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
    progress.width = 2;
    progress.centerColor = Color_Bg_celllightblue;
    progress.delegate = self;
    progress.isTryDevice = !self.isReal;
    [self.view addSubview:progress];
    
    if (!self.isReal) {
        progress.hint1.hidden = YES;
        progress.hint2.hidden = YES;
    }
    
    [self.view bringSubviewToFront:self.lblHint1];
    [self.view bringSubviewToFront:self.lblHint2];

    
    //时间预约的picker
    pickerViewTime = [[UIPickerView alloc] init];
    pickerViewTime.showsSelectionIndicator=YES;
    pickerViewTime.dataSource = self;
    pickerViewTime.delegate = self;
    pickerViewTime.tag = 0;
    selectedHour = @"00";
    NSArray *minites_normal = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",
               @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
               @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
               @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
               @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
               @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    NSArray *minites_nozero = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",
               @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
               @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
               @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
               @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
               @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    NSArray *minites_zero = @[@"00"];
    pickerDictionary = @{@"00":minites_nozero,
                         @"01":minites_normal,
                         @"02":minites_normal,
                         @"03":minites_normal,
                         @"04":minites_normal,
                         @"05":minites_normal,
                         @"06":minites_normal,
                         @"07":minites_normal,
                         @"08":minites_zero};
    hours = [[pickerDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    minites = minites_nozero;
    
    [pickerViewTime selectRow:450 inComponent:0 animated:NO];
    [pickerViewTime selectRow:2950 inComponent:1 animated:NO];  //默认居中

    pickerViewTime.backgroundColor = Color_Bg_cellldarkblue;
    pickerViewTime.frame = CGRectMake(0, 0, SCREEN_WIDTH,_pickerButtonView.frame.size.height-46);
    if (iPhone4) {
//        pickerViewTime.frame = CGRectOffset(pickerViewTime.frame, 0, -10);
        pickerViewTime.frame = CGRectMake(0, 0, SCREEN_WIDTH,_pickerButtonView.frame.size.height-46-30);
    }
    float labelheight = 30;
    UILabel *zai = [[UILabel alloc] initWithFrame:CGRectMake(0, pickerViewTime.frame.size.height/2 - labelheight/2, pickerViewTime.frame.size.width/4, labelheight)];
    zai.text = @"   在";
    zai.textColor = [UIColor whiteColor];
    zai.textAlignment = NSTextAlignmentCenter;
    UILabel *xiaoshi = [[UILabel alloc] initWithFrame:CGRectMake(pickerViewTime.frame.size.width/4+20, pickerViewTime.frame.size.height/2 - labelheight/2, pickerViewTime.frame.size.width/4, labelheight)];
    xiaoshi.text = @"小时";
    xiaoshi.textColor = [UIColor whiteColor];
    xiaoshi.textAlignment = NSTextAlignmentCenter;
    UILabel *fenzhonghouguanbi = [[UILabel alloc] initWithFrame:CGRectMake(pickerViewTime.frame.size.width/2+33, pickerViewTime.frame.size.height/2 - labelheight/2, pickerViewTime.frame.size.width/2+10, labelheight)];
    fenzhonghouguanbi.text = @"分钟后关闭";
    fenzhonghouguanbi.textColor = [UIColor whiteColor];
    fenzhonghouguanbi.textAlignment = NSTextAlignmentCenter;
    [pickerViewTime addSubview:zai];
    [pickerViewTime addSubview:xiaoshi];
    [pickerViewTime addSubview:fenzhonghouguanbi];
    
    
    [_pickerButtonView addSubview:pickerViewTime];
    _pickerButtonView.backgroundColor = Color_Bg_cellldarkblue;
    
    
    [_cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [_cancelButton addTarget:self action:@selector(pikerCancle) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *savaButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    savaButton.frame = CGRectMake(DEVICE_WIDTH - 100, _pickerButtonView.frame.size.height-50, 100, 50);
    [_savaBUtton setTitle:@"完成" forState:UIControlStateNormal];
    [_savaBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _savaBUtton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [_savaBUtton addTarget:self action:@selector(pikerSave) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *cancelYYButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelYYButton.frame = CGRectMake(_pickerButtonView.frame.size.width/2-50, _pickerButtonView.frame.size.height-50, 100, 50);
    [_cancelYYButton setTitle:@"取消设置" forState:UIControlStateNormal];
    [_cancelYYButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelYYButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [_cancelYYButton addTarget:self action:@selector(cancelYuyue) forControlEvents:UIControlEventTouchUpInside];

    self.CancelYuyueButton = _cancelYYButton;
    
    [_pickerButtonView addSubview:_cancelButton];
    [_pickerButtonView addSubview:_savaBUtton];
    [_pickerButtonView addSubview:_cancelYYButton];

    
//    [self.view addSubview:_pickerButtonView];
    _pickerButtonView.hidden = YES;
    
    //调节风速
    _pickerView2.backgroundColor = Color_Bg_cellldarkblue;
    _pickerView2.showsSelectionIndicator = YES;
    _pickerView2.dataSource = self;
    _pickerView2.delegate = self;
    Winds = @[@"睡眠模式",@"风速1档",@"风速2档",@"风速3档",@"强风模式",@"智能模式"];
    _pickerView2.tag = 1;
    [_pickerView2 selectRow:1200/2 inComponent:0 animated:NO];

    //滤网View
    filterView = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, (DEVICE_HEIGHT-64)/2, DEVICE_WIDTH, (DEVICE_HEIGHT-64)/2+20)];
    
    filterView.backgroundColor = FLYCO_DARK_BLUE;
//            filterView.backgroundColor = [UIColor redColor];
    //滤网返回按钮
    UIButton *filterBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBackButton.frame = CGRectMake(0, filterView.frame.size.height - 30, 100, 30);
    [filterBackButton setTitle:@"返回" forState:UIControlStateNormal];
    [filterBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterBackButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [filterBackButton addTarget:self action:@selector(filterBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:filterBackButton];
    
    //重置滤网按钮
    filterResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterResetButton.frame = CGRectMake(filterView.frame.size.width - 100, filterView.frame.size.height - 30, 100, 30);
    [filterResetButton setTitle:@"重置滤网" forState:UIControlStateNormal];
    [filterResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterResetButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [filterResetButton addTarget:self action:@selector(filterResetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:filterResetButton];
    
    //滤网信息tableView
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -10, filterView.bounds.size.width, filterView.bounds.size.height - 30)];
    filterTableView.dataSource = self;
    filterTableView.delegate = self;
    filterTableView.backgroundColor = FLYCO_DARK_BLUE;
    filterTableView.allowsSelection = NO;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [filterTableView setTableFooterView:v];
    
    [filterView addSubview:filterTableView];
    
    
    [self.view addSubview:filterView];
    
    
    [self showRightButtonNormalImage:@"option" highLightImage:@"option" selector:@selector(myEdit)];
    
    //静默模式的view
    fkacManageDeviceViewController = [[FKACManageDeviceViewController alloc]initWithNibName:@"FKACManageDeviceViewController" bundle:nil];
    fkacManageDeviceViewController.mydelegate = self;
    
    showStatus = 0;

    [self.view bringSubviewToFront:_pickerButtonView];
    //http请求的设置
//    [self initHttpInfo];
    NSLog(@"初始化UI filterView坐标为%f,%f,%f,%f",filterView.frame.origin.x,filterView.frame.origin.y,filterView.frame.size.width,filterView.frame.size.height);
    if (!self.isReal) {
        [self showFunction];
        [self updateUI];
    }
    
        for (NSLayoutConstraint* item in _underBackView.constraints) {
            if ([item.identifier isEqualToString:@"shut"]) {
                if (iPhone6Plus) {
                    item.constant = 55;
                }else{
                    item.constant = 55;
                }
                if (iPhone5 || iPhone6) {
                    item.constant = 45;
                }
            }
        }
//        _shutDownOrderLabel.frame = CGRectOffset(_shutDownOrderLabel.frame, 0, -3);

//    if (!self.isReal) {
//        uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
//    }

}

- (void) initQuickMock{
    NSString* tokenId = [UserInfo restore].tokenID;
    
    //全属性
    _airCleanerMock = [AirCleanerMock mock];
    _airCleanerMock.delegate = self;
    _airCleanerMock.operationType = [NSString stringWithFormat:@"%@%@/allstatus?tokenId=%@",AC_BASE_URL,cleaner.macId,tokenId];
    airCleanerParam = [AirCleanerParam param];
    airCleanerParam.sendMethod = @"GET";
    
    
    //灯效参数
    _aclightswitchMock = [AClightswitchMock mock];
    _aclightswitchMock.delegate = self;
    _aclightswitchMock.operationType = [NSString stringWithFormat:@"%@%@/lightswitch",AC_BASE_URL,cleaner.macId];
    acLightswitchParam = [AClightswitchParam param];
    acLightswitchParam.tokenid = tokenId;
    acLightswitchParam.sendMethod = @"POST";
    acLightswitchParam.source = @"app";
    
    //离子净化开关
    _acanionswitchMock = [ACanionswitchMock mock];
    _acanionswitchMock.delegate = self;
    _acanionswitchMock.operationType = [NSString stringWithFormat:@"%@%@/anionswitch",AC_BASE_URL,cleaner.macId];
    acanionswitchParam = [ACanionswitchParam param];
    acanionswitchParam.tokenid = tokenId;
    acanionswitchParam.sendMethod = @"POST";
    acanionswitchParam.source = @"app";
    
    
    //时间预约开关
    _actimerMock = [ACtimerMock mock];
    _actimerMock.operationType = [NSString stringWithFormat:@"%@%@/timer",AC_BASE_URL,cleaner.macId];
    _actimerMock.delegate = self;
    actimerparam = [ACtimerParam param];
    actimerparam.sendMethod = @"POST";
    actimerparam.tokenid = tokenId;
    actimerparam.source = @"app";

    //风速调节
    _acrunningmodeMock = [ACrunningmodelMock mock];
    _acrunningmodeMock.operationType = [NSString stringWithFormat:@"%@%@/runningmodel",AC_BASE_URL,cleaner.macId];
    _acrunningmodeMock.delegate = self;
    acrunningmodelParam = [ACrunningmodelParam param];
    acrunningmodelParam.sendMethod = @"POST";
    acrunningmodelParam.tokenid = tokenId;
    acrunningmodelParam.source = @"app";
    
    //开关
    _acpowerswitchMock = [ACpowerswitchMock mock];
    _acpowerswitchMock.operationType = [NSString stringWithFormat:@"%@%@/powerswitch",AC_BASE_URL,cleaner.macId];
    _acpowerswitchMock.delegate = self;
    acpowerswitchParam = [ACpowerswitchParam param];
    acpowerswitchParam.sendMethod = @"POST";
    acpowerswitchParam.tokenid = tokenId;
    acpowerswitchParam.source = @"app";
    
    //室外空气属性
    _weatherdataMock = [WeatherdataMock mock];
    _weatherdataMock.operationType = [NSString stringWithFormat:@"/devices/getweatherdata/%@?deviceId=%@",tokenId,cleaner.deviceId];
    _weatherdataMock.delegate = self;
    weatherdataParam = [WeatherdataParam param];
    weatherdataParam.sendMethod = @"GET";
    
    //城市PM
    self.cityPMmock = [getCityPmMock mock];
    self.cityPMmock.delegate = self;
    
    
    //静默模式开关
    _acQuietModeMock = [ACQuietModeMock mock];
    _acQuietModeMock.operationType = [NSString stringWithFormat:@"%@%@/quietmode",AC_BASE_URL,cleaner.macId];
    _acQuietModeMock.delegate = self;
    acQuietModeParam = [ACQuietModeParam param];
    acQuietModeParam.sendMethod = @"POST";
    acQuietModeParam.tokenid = tokenId;
    acQuietModeParam.source = @"app";
    
    
    //滤网1
    _acfilteroneswitchMock = [ACfilteroneswitchMock mock];
    _acfilteroneswitchMock.operationType = [NSString stringWithFormat:@"%@%@/filteroneswitch",AC_BASE_URL,cleaner.macId];
    _acfilteroneswitchMock.delegate = self;
    acfilteroneswitchParam = [ACfilteroneswitchParam param];
    acfilteroneswitchParam.sendMethod = @"POST";
    acfilteroneswitchParam.filter_status = @"filter";
    acfilteroneswitchParam.tokenid = tokenId;
    acfilteroneswitchParam.source = @"app";
    //滤网2
    _acfiltertwoswitchMock = [ACfiltertwoswitchMock mock];
    _acfiltertwoswitchMock.operationType = [NSString stringWithFormat:@"%@%@/filtertwoswitch",AC_BASE_URL,cleaner.macId];
    _acfiltertwoswitchMock.delegate = self;
    acfiltertwoswitchParam = [ACfiltertwoswitchParam param];
    acfiltertwoswitchParam.sendMethod = @"POST";
    acfiltertwoswitchParam.filter_status = @"filter";
    acfiltertwoswitchParam.tokenid = tokenId;
    acfiltertwoswitchParam.source = @"app";
    //滤网3
    _acfilterthreeswitchMock = [ACfilterthreeswitchMock mock];
    _acfilterthreeswitchMock.operationType = [NSString stringWithFormat:@"%@%@/filterthreeswitch",AC_BASE_URL,cleaner.macId];
    _acfilterthreeswitchMock.delegate = self;
    acfilterthreeswitchParam = [ACfilterthreeswitchParam param];
    acfilterthreeswitchParam.sendMethod = @"POST";
    acfilterthreeswitchParam.filter_status = @"filter";
    acfilterthreeswitchParam.tokenid = tokenId;
    acfilterthreeswitchParam.source = @"app";
    
    
    _acinitializeDeviceDataMock = [ACinitializeDeviceDataMock mock];
    _acinitializeDeviceDataMock.operationType = [NSString stringWithFormat:@"%@%@/initializeDeviceData?tokenId=%@",AC_BASE_URL,cleaner.macId,tokenId];
    _acinitializeDeviceDataMock.delegate = self;
    acinitializeDeviceDataParam = [ACinitializeDeviceDataParam param];
    acinitializeDeviceDataParam.sendMethod = @"GET";
}

#pragma mark 更新UI
- (void)updateUI{
    
    
    [self checkOnlineStatus:cleaner.onlineStatus];
//    _lightEffect.hidden = NO;
    self.liziButton.hidden = YES;
    if ([cleaner.powerSwitch isEqualToString:@"poweroff"]) {
        self.imgLight.hidden = YES;
    }else{
        self.imgLight.hidden = NO;
    }
    
    NSString *value = @"";
    NSString *unit = @"";
    if (cleaner.pmValue) {
        progress.showStatus = showStatus;
        switch (showStatus) {
            case 0:
                value = cleaner.pmValue;
                progress.inDoorAirInfoLabel.text = @"颗粒物浓度";
                switch (cleaner.aqiStatus.intValue) {
                    case 1:
                        unit = @"优";
                        progress.percent = 1.0f;
                        break;
                    case 2:
                        unit = @"良";
                        progress.percent = 2.0f/3.0f;
                        break;
                    case 3:
                        unit = @"差";
                        progress.percent = 1.0f/3.0f;
                        break;
                    default:
                        break;
                }
                break;
            case 3:
                if (cleaner.humidity.intValue <= 100) {
                    value = cleaner.humidity;
                } else {
                    value = @"100";
                }
                progress.inDoorAirInfoLabel.text = @"室内湿度";
                progress.percent = value.floatValue / 100.0f;
                
                unit = @"%";
                break;
            case 2:
                value = [NSString stringWithFormat:@"%i",cleaner.temperature.intValue];
                progress.inDoorAirInfoLabel.text = @"室内温度";
                progress.percent = value.floatValue / 100.0f;
                unit = @"°C";
                break;
            case 1:
                progress.inDoorAirInfoLabel.text = @"空气异味";
                switch (cleaner.voc.intValue) {
                    case 1:
                        value = @"优";
                        progress.percent = 1.0f;
                        break;
                    case 2:
                        value = @"良";
                        progress.percent = 2.0f/3.0f;
                        break;
                    case 3:
                        value = @"差";
                        progress.percent = 1.0f/3.0f;
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        if ([cleaner.onlineStatus isEqualToString:@"offline"]) {
            progress.percent = 1.0f;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",value,unit]];
        NSInteger size = 40;
        if (iPhone4) {
            size = 30;
        }
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:size] range:NSMakeRange(str.length - unit.length, unit.length)];
        if (str) {
            progress.inDoorAirInfoNumLabel.attributedText = str;
        }
    }
    
    [_filterButton setImage:[UIImage imageNamed:@"to_filter"] forState:UIControlStateNormal];
    //室外属性
    if (cleaner.outdoor_pm) {
        _outdoor_pm.text = cleaner.outdoor_pm;
        _location.text = cleaner.location;
        //        self.btnLocation.enabled = NO;
    }
    //离子净化
    if ([cleaner.light_status isEqualToString:@"lighton"]) {
        [self.lightEffect setImage:[UIImage imageNamed:@"lightall"] forState:UIControlStateNormal];
    } else if ([cleaner.light_status isEqualToString:@"lighthalfon"]){
        [self.lightEffect setImage:[UIImage imageNamed:@"lighthalf"] forState:UIControlStateNormal];
    } else {
        [self.lightEffect setImage:[UIImage imageNamed:@"lightoff"] forState:UIControlStateNormal];
    }
    
    //时间预约状态
    if ([cleaner.time_status isEqualToString:@"timeyes"]) {
        int time = cleaner.time_remaining.intValue;
        int hour = time / 60;
        int minite = time % 60;
        NSString *miniteString = [NSString stringWithFormat:@"%i",minite];
        if (minite < 10) {
            miniteString = [NSString stringWithFormat:@"0%i",minite];
        }
        [self.shijianButton setImage:[UIImage imageNamed:@"yuyueon"] forState:UIControlStateNormal];
        if (!progress.isHidden || !self.isReal) {
            _shutDownOrderLabel.hidden = NO;
            _shutDownOrderLabel.text = [NSString stringWithFormat:@"%i:%@",hour,miniteString];
            
        }else{
            _shutDownOrderLabel.hidden = YES;
        }
        
    } else {
//        _shutDownOrderLabel.text = @"未设置";
        _shutDownOrderLabel.hidden = YES;
        [self.shijianButton setImage:[UIImage imageNamed:@"yuyueoff"] forState:UIControlStateNormal];
        
    }
    
    //风速调节
    if ([cleaner.runningMode isEqualToString:@"auto"]) {
        [self.fengsuButton setImage:[UIImage imageNamed:@"windauto"] forState:UIControlStateNormal];
    } else if ([cleaner.runningMode isEqualToString:@"sleep"]){
        [self.fengsuButton setImage:[UIImage imageNamed:@"windsleep"] forState:UIControlStateNormal];
    } else if ([cleaner.runningMode isEqualToString:@"strong"]){
        [self.fengsuButton setImage:[UIImage imageNamed:@"windstrong"] forState:UIControlStateNormal];
    } else if ([cleaner.runningMode isEqualToString:@"one"]){
        [self.fengsuButton setImage:[UIImage imageNamed:@"windone"] forState:UIControlStateNormal];
    } else if ([cleaner.runningMode isEqualToString:@"two"]){
        [self.fengsuButton setImage:[UIImage imageNamed:@"windtwo"] forState:UIControlStateNormal];
    } else if ([cleaner.runningMode isEqualToString:@"three"]){
        [self.fengsuButton setImage:[UIImage imageNamed:@"windthree"] forState:UIControlStateNormal];
    } else {
        NSLog(@"不存在的模式");
    }
    
    if (lvwang>0) {
        [filterTableView reloadData];
        lvwang-- ;
    }
    
    //当静默模式关闭的时候
    if ([cleaner.quietmode isEqualToString:@"quietmodeoff"] && [cleaner.powerSwitch isEqualToString:@"poweroff"]) {
        //        _lightEffect.hidden = YES;
        _filterButton.hidden = YES;
        progress.inDoorAirInfoLabel.text = @"请打开关机实时检测";
        progress.inDoorAirInfoNumLabel.text = nil;
        progress.percent = 0;
    }
    
    //当关机的时候
    //开关
    if ([cleaner.powerSwitch isEqualToString:@"poweron"] && [cleaner.onlineStatus isEqualToString:@"online"]) {
//        [progress.OnButton setImage:[UIImage imageNamed:@"cleaner_on"] forState:UIControlStateNormal];
        [self.btnPower setImage:[UIImage imageNamed:@"poweron"] forState:UIControlStateNormal];
        _lightEffect.titleLabel.textColor = [UIColor whiteColor];
        _shijianButton.titleLabel.textColor = [UIColor whiteColor];
        _fengsuButton.titleLabel.textColor = [UIColor whiteColor];
        _liziButton.userInteractionEnabled = YES;
        _shijianButton.userInteractionEnabled = YES;
        _fengsuButton.userInteractionEnabled = YES;
        _shijianButton.hidden = NO;
        _fengsuButton.hidden = NO;
        self.lightEffect.hidden = NO;
//        _shutDownOrderLabel.hidden = NO;
        if (isFirst) {
            [self.btnPower setFrame:CGRectMake(8,self.btnPower.frame.origin.y, self.btnPower.frame.size.width, self.btnPower.frame.size.height)];
            self.lightEffect.alpha = 1;
            self.shijianButton.alpha = 1;
            self.fengsuButton.alpha = 1;
            isFirst = NO;
        }else{
        [UIView animateWithDuration:0.5 animations:^(void){
            [self.btnPower setFrame:CGRectMake(8,self.btnPower.frame.origin.y, self.btnPower.frame.size.width, self.btnPower.frame.size.height)];
//            for (NSLayoutConstraint* item in _underBackView.constraints) {
//                if ([item.identifier isEqualToString:@"left"]) {
//                    item.priority = UILayoutPriorityDefaultHigh;
//                }
//                if ([item.identifier isEqualToString:@"center"]) {
//                    item.priority = UILayoutPriorityDefaultLow;
//                }
//            }

            self.lightEffect.alpha = 1;
            self.shijianButton.alpha = 1;
            self.fengsuButton.alpha = 1;
        } completion:^(BOOL completed){
//            [self showFunction];
        }];
        }
        
    } else {
        [UIView animateWithDuration:0 animations:^(void){
//            for (NSLayoutConstraint* item in _underBackView.constraints) {
//                if ([item.identifier isEqualToString:@"left"]) {
//                    item.priority = UILayoutPriorityDefaultLow;
//                }
//                if ([item.identifier isEqualToString:@"center"]) {
//                    item.priority = UILayoutPriorityDefaultHigh;
//                }
//            }
            [self.btnPower setFrame:CGRectMake((SCREEN_WIDTH-self.btnPower.frame.size.width)/2+1, self.btnPower.frame.origin.y, self.btnPower.frame.size.width, self.btnPower.frame.size.height)];
            
                    self.lightEffect.alpha = 0;
                    self.shijianButton.alpha = 0;
                    self.fengsuButton.alpha = 0;

        } completion:^(BOOL completed){
//            [self hiddenFunction];
        }];
        [self.btnPower setImage:[UIImage imageNamed:@"poweroff"] forState:UIControlStateNormal];
        _filterButton.hidden = YES;
        
        _lightEffect.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _shijianButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _fengsuButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        
        
        //        fkacManageDeviceViewController.quietModeSwitch.userInteractionEnabled = NO;
        self.shijianButton.hidden = YES;
        self.lightEffect.hidden = YES;
        self.fengsuButton.hidden = YES;
        _liziButton.hidden = YES;
        _shijianButton.hidden = YES;
        _fengsuButton.hidden = YES;
        _shutDownOrderLabel.hidden = YES;
    }
    if (!hasRead) {
        [self checkLvwang];
    }
//    [cleaner.filterTwoSwitch addObserver:self forKeyPath:@"twoChange" options:0 context:nil];
//    [cleaner.filterOneSwitch addObserver:self forKeyPath:@"oneChange" options:0 context:nil];
    
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
////    if (!_pickerButtonView.isHidden) {
//        progress.hidden = !progress.hidden;
//        _pickerButtonView.hidden = YES;
//
//    }
//}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
}


-(void)checkLvwang{
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [lvwangAlert dismissViewControllerAnimated:YES completion:nil];
        lvwangAlert = nil;
        hasRead = YES;
    }];
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"立即购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoShop" object:nil];
        [lvwangAlert dismissViewControllerAnimated:YES completion:nil];
        lvwangAlert = nil;
        [WpCommonFunction showTabBar];
    }];
    if (cleaner.filterOneSwitch && cleaner.filterTwoSwitch && [cleaner.filterTwoSwitch intValue]<360 && [cleaner.filterOneSwitch intValue]<72 && !lvwangAlert) {
        lvwangAlert = [UIAlertController alertControllerWithTitle:@"滤网警告" message:@"滤网1,滤网2剩余时间已不足10%,将无法正常工作,请尽快更换滤网" preferredStyle:UIAlertControllerStyleAlert];
        [lvwangAlert addAction:action1];
        [lvwangAlert addAction:action2];
        [self presentViewController:lvwangAlert animated:YES completion:nil];
        
    }
    if ([cleaner.filterOneSwitch intValue]<72 && !lvwangAlert && cleaner.filterOneSwitch) {
        lvwangAlert = [UIAlertController alertControllerWithTitle:@"滤网警告" message:@"滤网1剩余时间已不足10%,将无法正常工作,请尽快更换滤网" preferredStyle:UIAlertControllerStyleAlert];
        [lvwangAlert addAction:action1];
        [lvwangAlert addAction:action2];
        [self presentViewController:lvwangAlert animated:YES completion:nil];
        
    }
    if ([cleaner.filterTwoSwitch intValue]<360 && !lvwangAlert && cleaner.filterTwoSwitch) {
        lvwangAlert = [UIAlertController alertControllerWithTitle:@"滤网警告" message:@"滤网2剩余时间已不足10%,将无法正常工作,请尽快更换滤网" preferredStyle:UIAlertControllerStyleAlert];
        [lvwangAlert addAction:action1];
        [lvwangAlert addAction:action2];
        [self presentViewController:lvwangAlert animated:YES completion:nil];
    }
}

-(void)hiddenFunction{
//    [UIView animateWithDuration:0.5 animations:^(void){
//        self.btnPower.alpha = 0;
//        self.lightEffect.alpha = 0;
//        self.shijianButton.alpha = 0;
//        self.fengsuButton.alpha = 0;
//    }];
    self.btnPower.hidden = YES;
    self.lightEffect.hidden = YES;
    self.shijianButton.hidden = YES;
    self.fengsuButton.hidden = YES;
    _shutDownOrderLabel.hidden = YES;


}

-(void)showFunction{
//    [UIView animateWithDuration:0.5 animations:^(void){
//    self.btnPower.alpha = 1;
//    self.lightEffect.alpha = 1;
//    self.shijianButton.alpha = 1;
//    self.fengsuButton.alpha = 1;
//    }];
    self.btnPower.hidden = NO;
    self.lightEffect.hidden = NO;
    self.shijianButton.hidden = NO;
    self.fengsuButton.hidden = NO;
    _shutDownOrderLabel.hidden = NO;

}
@end
