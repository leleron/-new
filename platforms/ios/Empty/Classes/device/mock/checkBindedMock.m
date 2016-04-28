//
//  checkBindedMock.m
//  Empty
//
//  Created by leron on 15/6/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "checkBindedMock.h"
@implementation checkBindedParam
@end
@implementation checkBindedMock
-(NSString*)getOperatorType{
    return self.operationType;
}
-(Class)getEntityClass{
    return [checkBindedEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [[ViewControllerManager sharedManager]hideWaitView];
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
