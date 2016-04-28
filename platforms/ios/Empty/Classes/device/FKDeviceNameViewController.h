//
//  FKDeviceNameViewController.h
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "CamObj.h"
@interface FKDeviceNameViewController : MyViewController <UITextFieldDelegate>
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* deviceNick;
@property(strong,nonatomic)CamObj* cam;
@end
