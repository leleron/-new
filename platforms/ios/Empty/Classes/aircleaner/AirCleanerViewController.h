//
//  AirCleanerViewController.h
//  Empty
//
//  Created by duye on 15/8/19.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirCleanerEntity.h"
#import "progressView.h"
#import "RNGridMenu.h"
#import "FilterCell.h"
#import "AirCleanerMock.h"
#import "ACanionswitchMock.h"
#import "ACfilteroneswitchMock.h"
#import "ACfilterthreeswitchMock.h"
#import "ACfiltertwoswitchMock.h"
#import "AClightswitchMock.h"
#import "ACpowerswitchMock.h"
#import "ACrunningmodelMock.h"
#import "ACtimerMock.h"
#import "FKACManageDeviceViewController.h"
#import "WeatherdataMock.h"
#import "ACQuietModeMock.h"
#import "ACfilteroneswitchMock.h"
#import "ACfiltertwoswitchMock.h"
#import "ACfilterthreeswitchMock.h"
#import "ACinitializeDeviceDataMock.h"

#define FLYCO_DARK_BLUE     [UIColor colorWithRed:0.0f/255 green:29.0f/255 blue:73.0f/255 alpha:1]
#if defined(WP_REAL_SERVER) // 生产环境
#define AC_BASE_URL         @"http://app02.flyco.net.cn/Inbound/devices/"
#else
#define AC_BASE_URL         @"http://121.40.104.203:8080/Inbound/devices/"
#endif
#define WAIT_TIME           0.5f


@interface AirCleanerViewController : MyViewController<ProgressViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,RNGridMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,FKACManageDeviceViewControllerDelegate>

@property(nonatomic)AirCleanerEntity *cleaner;
@property(strong,nonatomic)NSString* PM;     //手动选择的城市pm
@property(strong,nonatomic)NSString* City;    //手动选择的城市
@property(strong,nonatomic)NSString* cityCode;
@property(assign,nonatomic)BOOL isReal;      //是否是试用设备
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil airCleaner:(AirCleanerEntity*)airCleaner;
- (void)turnOnOff:(UIButton*)button;//开或关

- (void)updateUI;

-(void)pikerCancle;

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender;

@end
