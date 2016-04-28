//
//  FKManageDeviceViewController.h
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "AirCleanerEntity.h"
#import "FKUpdateDeviceViewController.h"

@protocol FKACManageDeviceViewControllerDelegate
-(void)quietModeSwitchChange;
@end

@interface FKACManageDeviceViewController : MyViewController
@property (nonatomic)UISwitch* quietModeSwitch;
@property (nonatomic)AirCleanerEntity *cleaner;
@property (strong,nonatomic)NSString* devicePower;
@property (weak, nonatomic)id<FKACManageDeviceViewControllerDelegate> mydelegate;

@end
