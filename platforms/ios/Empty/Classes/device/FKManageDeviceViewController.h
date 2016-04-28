//
//  FKManageDeviceViewController.h
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "CamObj.h"
@interface FKManageDeviceViewController : MyViewController
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)CamObj* cam;
@property(strong,nonatomic)NSString* userType;
@end
