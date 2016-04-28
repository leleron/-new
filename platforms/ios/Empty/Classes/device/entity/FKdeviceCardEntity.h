//
//  FKdeviceCardEntity.h
//  Empty
//
//  Created by leron on 15/8/19.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface FKdeviceCardEntity : QUEntity
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* productCode;
@property(strong,nonatomic)NSString* onlineStatus;
@property(strong,nonatomic)NSString* message;
@end
