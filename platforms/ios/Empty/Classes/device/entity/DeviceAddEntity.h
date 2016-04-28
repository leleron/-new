//
//  DeviceAddEntity.h
//  Empty
//
//  Created by duye on 15/9/22.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface DeviceAddEntity : QUEntity
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* message;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* userType;
@end
