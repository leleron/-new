//
//  deviceListMock.m
//  Empty
//
//  Created by leron on 15/6/24.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "deviceListMock.h"
@implementation deviceListParam

@end
@implementation deviceListMock
-(NSString*)getOperatorType{
    return self.operationType;
}

-(Class)getEntityClass{
    return [deviceListEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [[ViewControllerManager sharedManager]hideWaitView];
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
