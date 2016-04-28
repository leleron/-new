//
//  RegardingDeviceEntity.h
//  Empty
//
//  Created by duye on 15/9/22.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface RegardingDeviceEntity : QUEntity
@property(strong,nonatomic)NSString* OwnedStatus;
@property(strong,nonatomic)NSString* OwnedMessage;
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSDictionary* DeviceInfo;
@end

@interface RegardingDeviceInfoEntity : QUEntity
@property(strong,nonatomic)NSString* barCode;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* deviceName;
@property(strong,nonatomic)NSString* deviceOwner;
@property(strong,nonatomic)NSString* devicePassword;
@property(strong,nonatomic)NSString* deviceSn;
@property(strong,nonatomic)NSString* deviceType;
@property(strong,nonatomic)NSString* deviceVersion;
@property(strong,nonatomic)NSString* functionIntroduction;
@property(strong,nonatomic)NSString* functional;
@property(strong,nonatomic)NSString* image;
@property(strong,nonatomic)NSString* information;
@property(strong,nonatomic)NSString* isTop;
@property(strong,nonatomic)NSString* macId;
@property(strong,nonatomic)NSString* productCategory;
@property(strong,nonatomic)NSString* productCode;
@property(strong,nonatomic)NSString* productModel;
@property(strong,nonatomic)NSString* runningStatus;
@property(strong,nonatomic)NSString* specifications;
@property(strong,nonatomic)NSString* userType;
@end