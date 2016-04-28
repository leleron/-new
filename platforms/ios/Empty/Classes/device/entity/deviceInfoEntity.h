//
//  deviceInfoEntity.h
//  Empty
//
//  Created by leron on 15/6/24.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface deviceInfoEntity : QUEntity
@property(strong,nonatomic)NSString* barCode;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* deviceName;
@property(strong,nonatomic)NSString* deviceOwner;
@property(strong,nonatomic)NSString* deviceSn;
@property(strong,nonatomic)NSString* deviceType;
@property(strong,nonatomic)NSString* deviceVersion;
@property(strong,nonatomic)NSString* macId;
@property(strong,nonatomic)NSString* productCode;
@property(strong,nonatomic)NSString* productModel;
@property(strong,nonatomic)NSString* userType;
@property(strong,nonatomic)NSString* password;
@end
