//
//  deleteDeviceMock.m
//  Empty
//
//  Created by leron on 15/6/25.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "deleteDeviceMock.h"
@implementation deleteDeviceParam
@end
@implementation deleteDeviceMock
-(NSString*)getOperatorType{
    return self.operationType;
}

-(Class)getEntityClass{
    return [identifyEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
   
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
