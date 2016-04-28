//
//  FKDeviceStatusViewController.h
//  Empty
//
//  Created by leron on 15/8/28.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "CamObj.h"
#import "AirCleanerEntity.h"
@interface FKDeviceStatusViewController : MyViewController
@property(strong,nonatomic)CamObj* cam;
@property(strong,nonatomic)AirCleanerEntity* cleaner;
@property(strong,nonatomic)NSString* userType;
@end
