//
//  DeviceErrorListEntity.h
//  Empty
//
//  Created by duye on 15/9/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface DeviceErrorListInfoEntity : QUEntity
@property(strong,nonatomic)NSString* deviceMsgContent;
@property(strong,nonatomic)NSString* deviceMsgDetailTime;
@property(strong,nonatomic)NSString* deviceMsgId;
@property(strong,nonatomic)NSString* deviceMsgStatus;
@property(strong,nonatomic)NSString* deviceMsgTime;
@property(strong,nonatomic)NSString* deviceMsgTitle;
@property(strong,nonatomic)NSString* failureCode;
@property(strong,nonatomic)NSString* failureLevel;
@property(strong,nonatomic)NSString* failureTime;
@end

@interface DeviceErrorListEntity : QUEntity
@property(strong,nonatomic)NSArray* deviceMessageList;
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* message;
- (NSArray *)getDeviceErrorLists;
@end
