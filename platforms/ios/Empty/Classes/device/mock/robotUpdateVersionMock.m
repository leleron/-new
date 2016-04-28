//
//  robotUpdateVersionMock.m
//  Empty
//
//  Created by leron on 15/9/30.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "robotUpdateVersionMock.h"
@implementation robotUpdateVersionParam

@end

///devices/{deviceId}/robotFirmwareUpdateVersion
@implementation robotUpdateVersionMock
-(Class)getEntityClass{
    return [deviceVersionCompareEntity class];
}
@end
