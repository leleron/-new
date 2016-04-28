//
//  checkBindedEntity.h
//  Empty
//
//  Created by leron on 15/7/7.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface checkBindedEntity : QUEntity
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* message;
@property(strong,nonatomic)NSString* shareSwitch;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSDictionary* DATA;
@end

@interface snCodeEntity : QUEntity
@property(strong,nonatomic)NSString* spare;
@property(strong,nonatomic)NSString* type;
@property(strong,nonatomic)NSString* vendor;
@property(strong,nonatomic)NSString* model;
@property(strong,nonatomic)NSString* idCode;
@end