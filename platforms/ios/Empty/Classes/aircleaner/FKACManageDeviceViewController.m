//
//  FKManageDeviceViewController.m
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKACManageDeviceViewController.h"
#import "addProductSection.h"
#import "FKDeviceNameViewController.h"
#import "deleteDeviceMock.h"
#import "FKDevicePswViewController.h"
#import "FKDeviceStatusViewController.h"
#import "DeviceErrorListViewController.h"
#import "ConfigNetViewController.h"
#import "AirCleanerTipViewController.h"
#import "lvwangViewController.h"
#import "ItemListSection.h"
#import "ACanionswitchMock.h"
#import "airSoundSetMock.h"
#import "getAirSoundStateMock.h"
#import "deviceVersionCompareMock.h"

@interface FKACManageDeviceViewController ()
{
    UISwitch* liziSwitch;
    UISwitch* soundSwitch;
    ACanionswitchParam* acanionswitchParam;
    ACanionswitchMock* acanionswitchMock;
    airSoundSetParam* soundSetParam;
    airSoundSetMock* soundSetMock;
    getAirSoundStateMock* getSoundStateMock;
    deviceVersionCompareMock* myDeviceVersionCompareMock;
    BOOL hasNewVersion;
}
@end

@implementation FKACManageDeviceViewController

//@synthesize airCleanerViewController;

- (void)viewDidLoad {
    self.navigationBarTitle = @"设置";
    [super viewDidLoad];
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"ItemListSection"] delegate:self backGroundClr:Color_Bg_Nav];
    for (int i = 0; i<9; i++) {
        QUFlatEntity* e1 = [QUFlatEntity entity];
        e1.tag = i;
        
        if (i != 0 && i!=1 && i!=2) {
            e1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [self.pAdaptor.pSources addEntity:e1 withSection:[ItemListSection class]];
    }

    _quietModeSwitch = [[UISwitch alloc]init];
    liziSwitch = [[UISwitch alloc]init];
    soundSwitch = [[UISwitch alloc]init];
//    [self showLeftNormalButton:@"go_back" highLightImage:nil selector:@selector(back)];
    
    if (self.cleaner) {
        hasNewVersion = NO;
        [self checkVersion];
        [self getSwitchState];
    }
    
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initQuickMock{
    acanionswitchMock = [ACanionswitchMock mock];
    acanionswitchMock.delegate = self;
    acanionswitchMock.operationType = [NSString stringWithFormat:@"%@%@/anionswitch",AC_BASE_URL,_cleaner.macId];
    acanionswitchParam = [ACanionswitchParam param];
    UserInfo* user = [UserInfo restore];
    acanionswitchParam.tokenid = user.tokenID;
    acanionswitchParam.sendMethod = @"POST";
    acanionswitchParam.source = @"app";
    
    soundSetMock = [airSoundSetMock mock];
    soundSetMock.delegate = self;
    soundSetMock.operationType = [NSString stringWithFormat:@"%@%@/voiceSwitch",AC_BASE_URL,_cleaner.macId];
    soundSetParam = [airSoundSetParam param];
    soundSetParam.tokenid = user.tokenID;
    
    getSoundStateMock = [getAirSoundStateMock mock];
    getSoundStateMock.delegate = self;
    getSoundStateMock.operationType = [NSString stringWithFormat:@"%@%@/voicestatus?tokenId=%@",AC_BASE_URL,_cleaner.macId,user.tokenID];
}

- (void)viewWillAppear:(BOOL)animated{
    [self initSwitch];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)initSwitch{
    if ([_cleaner.quietmode isEqualToString:@"quietmodeoff"]) {
        [_quietModeSwitch setOn:NO];
    }else{
        [_quietModeSwitch setOn:YES];
    }
    if (self.cleaner && [self.cleaner.powerSwitch isEqualToString:@"poweron"]) {
        [_quietModeSwitch addTarget:_mydelegate action:@selector(quietModeSwitchChange) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_quietModeSwitch addTarget:self action:@selector(changeQuietSwitch) forControlEvents:UIControlEventTouchUpInside];
    }

    [liziSwitch addTarget:self action:@selector(liziSwitchChange) forControlEvents:UIControlEventTouchUpInside];
    [soundSwitch addTarget:self action:@selector(soundSwitchChange) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)checkVersion{
    myDeviceVersionCompareMock = [deviceVersionCompareMock mock];
    myDeviceVersionCompareMock.delegate = self;
    deviceVersionCompareParam* param =[deviceVersionCompareParam param];
    param.sendMethod = @"GET";
    UserInfo* myUserInfo = [UserInfo restore];
    myDeviceVersionCompareMock.operationType = [NSString stringWithFormat:@"/devices/%@/firmwareUpdateVersion?tokenId=%@",self.cleaner.deviceId,myUserInfo.tokenID];

    [myDeviceVersionCompareMock run:param];
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    QUFlatEntity* e = (QUFlatEntity*)entity;
    ItemListSection* s = (ItemListSection*)section;
    switch (e.tag) {
        case 0:
             s.lblTitle.text = @"离子净化";
            s.imgIcon.image = [UIImage imageNamed:@"lzjh"];
            [liziSwitch setFrame:CGRectMake(SCREEN_WIDTH-70,(s.frame.size.height - _quietModeSwitch.frame.size.height)/2 , liziSwitch.frame.size.width, liziSwitch.frame.size.height)];
            [s addSubview:liziSwitch];
            break;
       case 2:
            s.lblTitle.text = @"净化器按键声音";
            s.imgIcon.image = [UIImage imageNamed:@"airVoice"];
            [soundSwitch setFrame:CGRectMake(SCREEN_WIDTH-70,(s.frame.size.height - soundSwitch.frame.size.height)/2 , soundSwitch.frame.size.width, soundSwitch.frame.size.height)];
            [s addSubview:soundSwitch];
            break;
        case 3:
            s.lblTitle.text = @"滤网设置";
            s.imgIcon.image = [UIImage imageNamed:@"lvwang"];
            break;
            
        case 4:
            s.lblTitle.text = @"修改设备昵称";
            s.imgIcon.image = [UIImage imageNamed:@"xgnc"];
            s.imgIcon.frame = CGRectMake(s.imgIcon.frame.origin.x, s.imgIcon.frame.origin.y, 40, 40);
            break;
        case 6:{
            s.lblTitle.text = @"固件升级";
            s.imgIcon.image = [UIImage imageNamed:@"gjsj"];
            s.imgIcon.frame = CGRectMake(s.imgIcon.frame.origin.x, s.imgIcon.frame.origin.y, 40, 40);
            UIImageView* imgNew = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newVersion"]];
            imgNew.frame = CGRectMake(s.lblTitle.frame.origin.x+s.lblTitle.frame.size.width+10, s.lblTitle.frame.origin.y, 35, 17);
            [s addSubview:imgNew];
            }
            break;
        case 5:
            s.lblTitle.text = @"设备管理";
            s.imgIcon.image = [UIImage imageNamed:@"sbgl"];
            s.imgIcon.frame = CGRectMake(s.imgIcon.frame.origin.x, s.imgIcon.frame.origin.y, 40, 40);
            break;
        case 1:
        {
            s.lblTitle.text = @"关机实时监测";
            s.imgIcon.image = [UIImage imageNamed:@"sbcgq"];
            s.imgIcon.frame = CGRectMake(s.imgIcon.frame.origin.x, s.imgIcon.frame.origin.y, 40, 40);
            [_quietModeSwitch setFrame:CGRectMake(SCREEN_WIDTH - 70, (s.frame.size.height - _quietModeSwitch.frame.size.height)/2, _quietModeSwitch.frame.size.width, _quietModeSwitch.frame.size.height)];
            [s addSubview:_quietModeSwitch];
            
        }
            break;
        case 8:
            s.lblTitle.text = @"设备故障消息";
            s.imgIcon.image = [UIImage imageNamed:@"gzxx"];
            s.imgLine.hidden = YES;
            break;
        case 7:
            s.lblTitle.text = @"更换Wi-Fi";
            s.imgIcon.image = [UIImage imageNamed:@"czwl"];
        default:
            break;
    }
//    if (e.tag % 2 == 0) {
//        s.backgroundColor = Color_Bg_Nav;
//    }

    
}


-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    QUFlatEntity* e = (QUFlatEntity*)entity;
    switch (e.tag) {
        case 3:
        {
            if (!self.cleaner) {
                [self showAlert:@"试用设备无法设置"];
            }
            else{
                if ([self.cleaner.powerSwitch isEqualToString:@"poweron"] && [self.cleaner.onlineStatus isEqualToString:@"online"]) {
                lvwangViewController* controller = [[lvwangViewController alloc]initWithNibName:@"lvwangViewController" bundle:nil];
                controller.cleaner = self.cleaner;
                [self.navigationController pushViewController:controller animated:YES];
                }else{
                    [self showAlert:@"关机状态下无法进行滤网设置"];
                }
            }
        }
            break;
            
            
        case 4:
        {
            if (  !self.cleaner) {   //不在线或者是试用设备无法点击
                [self showAlert:@"试用设备无法设置"];
                
            }else{
//            if ([_cleaner.userType isEqualToString:@"secondary"]) {
//                [WpCommonFunction messageBoxOneButtonWithMessage:@"您没有设置权限！" andTitle:@"" andButton:@"确定" andTag:0 andDelegate:self];
//            } else {
                FKDeviceNameViewController* controller = [[FKDeviceNameViewController alloc]initWithNibName:@"FKDeviceNameViewController" bundle:nil];
                controller.deviceId = _cleaner.deviceId;
                controller.deviceNick = _cleaner.deviceName;
                [self.navigationController pushViewController:controller animated:YES];
//            }
                
          }
        }
            break;
        case 6:
        {
            if ( !self.cleaner){
                [self showAlert:@"试用设备无法设置"];
                
            }else{
//            if ([_cleaner.userType isEqualToString:@"secondary"]) {
//                [WpCommonFunction messageBoxOneButtonWithMessage:@"您没有设置权限！" andTitle:@"" andButton:@"确定" andTag:0 andDelegate:self];
//            }
              if (!self.cleaner.deviceVersion || [self.cleaner.deviceVersion isEqualToString:@""]) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"请重新插拔设备的电源" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alert addAction:action1];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
//                [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请重新插拔设备的电源"];
            }else{
                
                if ([self.cleaner.powerSwitch isEqualToString:@"poweron"] && [self.cleaner.onlineStatus isEqualToString:@"online"]) {
                FKUpdateDeviceViewController* controller = [[FKUpdateDeviceViewController alloc] initWithNibName:@"FKUpdateDeviceViewController" bundle:nil];
                controller.air = _cleaner;
                [self.navigationController pushViewController:controller animated:YES];
                }else{
                    [self showAlert:@"关机状态下无法进行固件升级"];
                }
            }
            }
        }
            break;
        case 5:
        {
            if ( !self.cleaner){
                [self showAlert:@"试用设备无法设置"];
            }
            else{
            FKDeviceStatusViewController* controller = [[FKDeviceStatusViewController alloc]initWithNibName:@"FKDeviceStatusViewController" bundle:nil];
            controller.cleaner = _cleaner;
            controller.userType = _cleaner.userType;
            [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 8:
        {
            if ( !self.cleaner){
                [self showAlert:@"试用设备无法设置"];
            }else{
            DeviceErrorListViewController* controller = [[DeviceErrorListViewController alloc]initWithNibName:@"DeviceErrorListViewController" bundle:nil];
            controller.deviceId = _cleaner.deviceId;
            [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 7:
        {
            if ( !self.cleaner){
                [self showAlert:@"试用设备无法设置"];
            }else{
                
                if (![WpCommonFunction checkWIFI] ) {
                    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请先打开Wi-Fi"];
                }else{
            ConfigNetViewController* controller = [[ConfigNetViewController alloc]initWithNibName:@"ConfigNetViewController" bundle:nil];
            controller.productModel = self.cleaner.productModel;
                controller.productCode = self.cleaner.productCode;
                controller.isChongzhi = @"YES";
                
            [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
        default:
            break;
    }
}


-(void)liziSwitchChange{
    
    if (self.cleaner) {
        if ([self.cleaner.powerSwitch isEqualToString:@"poweron"] && [self.cleaner.onlineStatus isEqualToString:@"online"]) {
        if ([_cleaner.powerSwitch isEqualToString:@"poweroff"]) {
            [self showAlert:@"请打开设备"];
        }else{
            if (liziSwitch.isOn) {
                acanionswitchParam.anionswitch = @"anionon";
        //            [liziSwitch setOn:NO];
            } else {
                acanionswitchParam.anionswitch = @"anionoff";
        //            [liziSwitch setOn:YES];
            }
            [acanionswitchMock run:acanionswitchParam];
            [[ViewControllerManager sharedManager]showWaitView:self.view];
        }
        }else{
            [self showAlert:@"关机状态下无法开启或关闭离子净化"];
            [liziSwitch setOn:![liziSwitch isOn] animated:YES];
        }
    }else{
        [self showAlert:@"试用设备无法设置"];
        [liziSwitch setOn:![liziSwitch isOn] animated:YES];
    }
}

-(void)changeQuietSwitch{
    if ([self.cleaner.powerSwitch isEqualToString:@"poweroff"]) {
        [self showAlert:@"关机状态下无法设置关机实时监测"];
    }
    if (!self.cleaner) {
        [self showAlert:@"试用设备无法设置"];
    }
    [_quietModeSwitch setOn:![_quietModeSwitch isOn] animated:YES];
}
-(void)soundSwitchChange{
    
    if (self.cleaner) {
        if ([self.cleaner.powerSwitch isEqualToString:@"poweron"] && [self.cleaner.onlineStatus isEqualToString:@"online"]) {
            if (soundSwitch.isOn) {
                //        [soundSwitch setOn:NO];
                soundSetParam.voicestatus = @"voiceon";
            }else{
                //        [soundSwitch setOn:YES];
                soundSetParam.voicestatus = @"voiceoff";
            }
            [soundSetMock run:soundSetParam];
            [[ViewControllerManager sharedManager]showWaitView:self.view];
        }else{
            [self showAlert:@"关机状态下无法开启或关闭声音"];
            [soundSwitch setOn:![soundSwitch isOn] animated:YES];

        }
    }else{
        [self showAlert:@"试用设备无法设置"];
        [soundSwitch setOn:![soundSwitch isOn] animated:YES];
    }
}


-(void)getSwitchState{
    QUMockParam* param = [QUMockParam param];
    param.sendMethod = @"GET";
    [getSoundStateMock run:param];
    
    if ([_cleaner.anionSwitch isEqualToString:@"anionon"]) {
        [liziSwitch setOn:YES];
    }else{
        [liziSwitch setOn:NO];
    }
    
}
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getAirSoundStateMock class]]) {
        AirCleanerEntity* e = (AirCleanerEntity*)entity;
        if ([e.voicestatus isEqualToString:@"voiceon"]) {
            [soundSwitch setOn:YES];
        }else{
            [soundSwitch setOn:NO];
        }
    }
    if ([mock isKindOfClass:[deviceVersionCompareMock class]]) {
        
        deviceVersionCompareEntity* e = (deviceVersionCompareEntity*)entity;
        if ([e.status isEqualToString:@"NEWEST"]) {
            hasNewVersion = NO;
        }else{
            hasNewVersion = YES;
        }
        [self.pTableView.pAdaptor notifyChanged];

    }
}
    
-(void)showAlert:(NSString*)content{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alertaction){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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
