//
//  FKUpdateDeviceViewController.h
//  Empty
//
//  Created by leron on 15/8/28.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "CamObj.h"
#import "AirCleanerEntity.h"

#define DEVICE_UPDATE_WAIT_TIME 30.0f
@interface FKUpdateDeviceViewController : MyViewController
@property(strong,nonatomic)CamObj* cam;
@property(strong,nonatomic)AirCleanerEntity* air;
@end
