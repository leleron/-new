//
//  DeviceInfoByMac.m
//  Empty
//
//  Created by duye on 15/9/17.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "DeviceInfoByMacMock.h"


@implementation DeviceInfoByMacMockParam
@end
@implementation DeviceInfoByMacMock
-(Class)getEntityClass{
    return [DeviceInfoByMacEntity class];
}
-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    if (response.pReason == QU_SERVICE_BACK_OK) {
        [self.delegate QUMock:self entity:response.pEntity];
    }
}
@end
