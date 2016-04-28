//
//  addDeviceMock.h
//  Empty
//
//  Created by leron on 15/6/24.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "DeviceAddEntity.h"
@interface addDeviceParam : QUMockParam
@property(strong,nonatomic)NSString* TOKENID;
@property(strong,nonatomic)NSString* NICKNAME;
@property(strong,nonatomic)NSString* GROUP;
@property(strong,nonatomic)NSString* LATITUDE;
@property(strong,nonatomic)NSString* LONGITUDE;
@property(strong,nonatomic)NSString* SN;
@property(strong,nonatomic)NSString* MACADDRESS;
@property(strong,nonatomic)NSString* PRODUCTCODE;
@property(strong,nonatomic)NSString* PASSWORD;
@property(strong,nonatomic)NSString* PRODUCTMODEL;
@end
@interface addDeviceMock : QUMock

@end
