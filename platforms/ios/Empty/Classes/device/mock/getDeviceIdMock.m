//
//  getDeviceIdMock.m
//  Empty
//
//  Created by leron on 15/9/15.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "getDeviceIdMock.h"
@implementation getDeviceIdParam

@end



//http://121.40.104.203:8080/UserCore/service/devices/18fe34a2e9b0,18fe34a30abb/deviceDetail?tokenId=04008827850167839082

@implementation getDeviceIdMock
-(Class)getEntityClass{
    return [getDeviceIdEntity class];
}
@end
