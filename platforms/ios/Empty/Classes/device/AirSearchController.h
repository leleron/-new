//
//  DeviceListsViewController.h
//  Empty
//
//  Created by duye on 15/9/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "AsyncUdpSocket.h"
#import "deviceTypeEntity.h"

@interface AirSearchController : MyViewController<AsyncUdpSocketDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)deviceListInfoEntity *product;
@end
