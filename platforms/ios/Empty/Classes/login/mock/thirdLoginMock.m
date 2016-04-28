//
//  thirdLoginMock.m
//  Empty
//
//  Created by leron on 15/7/1.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "thirdLoginMock.h"
@implementation thirdLoginParam
@end
@implementation thirdLoginMock
-(NSString*)getOperatorType{
    return @"/thirdpartyuser/loginIn";
}

-(Class)getEntityClass{
    return [loginEntity class];
}


-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [[ViewControllerManager sharedManager]hideWaitView];
    [self.delegate QUMock:self entity:response.pEntity];
}

@end
