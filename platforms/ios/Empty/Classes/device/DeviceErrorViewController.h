//
//  DeviceErrorViewController.h
//  Empty
//
//  Created by leron on 15/9/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"

@interface DeviceErrorViewController : MyViewController
@property(assign,nonatomic)NSInteger error;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* errorCode;
@property(strong,nonatomic)NSString* errorName;
@property(strong,nonatomic)NSString* errorDescription;
@end
