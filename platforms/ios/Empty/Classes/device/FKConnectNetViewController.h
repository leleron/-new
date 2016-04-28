//
//  FKConnectNetViewController.h
//  Empty
//
//  Created by leron on 15/8/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "ConnectionManager.h"
#import "AsyncUdpSocket.h"
@interface FKConnectNetViewController : MyViewController<ConnectionManagerDelegate,AsyncUdpSocketDelegate>
@property(strong,nonatomic)NSString* wifiName;
@property(strong,nonatomic)NSString* sn;
@property(strong,nonatomic)NSString* psw;
@property(strong,nonatomic)NSString* macId;
@property(strong,nonatomic)NSString* model;
@property(strong,nonatomic)NSString* vendor;
@property(strong,nonatomic)NSString* productCode;
@property(strong,nonatomic)NSString* productModel;
@property(strong,nonatomic)NSString* isChongzhi;
@end
