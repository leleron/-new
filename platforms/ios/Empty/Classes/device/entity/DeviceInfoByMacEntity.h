//
//  DeviceInfoByMacEntity.h
//  Empty
//
//  Created by duye on 15/9/17.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface DeviceInfoByMacEntity : QUEntity
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* message;
@property(strong,nonatomic)NSArray* deviceDetailList;
@end

@interface DeviceInfoByMacListInfoEntity : QUEntity
@property(strong,nonatomic)NSString* productCode;   //产品编码
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* deviceName;
@property(strong,nonatomic)NSString* macId;
@end