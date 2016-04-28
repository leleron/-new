//
//  resetDevicePswMock.m
//  Empty
//
//  Created by leron on 15/9/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "resetDevicePswMock.h"
@implementation resetDevicePswParam

@end

//service/devices/{deviceId}/resetDevicePassword

@implementation resetDevicePswMock
-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
