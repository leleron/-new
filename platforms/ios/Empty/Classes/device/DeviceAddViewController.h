//
//  DeviceAddViewController.h
//  扫地机器人以外的设备添加页面
//
//  Created by 杜晔 on 15/7/6.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"
#import "NickNameSettingViewController.h"
//#import "AsyncUdpSocket.h"

@interface DeviceAddViewController : MyViewController<UITextFieldDelegate>

@property (nonatomic) NSString *productModel;
@property (strong, nonatomic) NSString *bssid;

- (id)initWithProductModel:(NSString*)proModel NibName:(NSString*)nibname;

@end
