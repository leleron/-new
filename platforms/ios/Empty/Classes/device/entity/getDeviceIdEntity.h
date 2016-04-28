//
//  getDeviceIdEntity.h
//  Empty
//
//  Created by leron on 15/9/10.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface getDeviceIdEntity : QUEntity
@property(strong,nonatomic)NSArray* deviceDetailList;
@end


@interface getDeviceListEntity : QUEntity
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* deviceName;
@end