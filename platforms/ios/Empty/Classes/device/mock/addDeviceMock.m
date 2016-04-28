//
//  addDeviceMock.m
//  Empty
//
//  Created by leron on 15/6/24.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "addDeviceMock.h"
@implementation addDeviceParam
@end
@implementation addDeviceMock
-(NSString*)getOperatorType{
    return @"/devices/add";
}

-(Class)getEntityClass{
    return [DeviceAddEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [[ViewControllerManager sharedManager]hideWaitView];
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
