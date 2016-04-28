//
//  WXUserInfoMock.m
//  Empty
//
//  Created by leron on 15/6/29.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "WXUserInfoMock.h"
@implementation WXUserInfoParam
@end
@implementation WXUserInfoMock
-(NSString*)getOperatorType{
    return @"WX_GET_USER_INFO";
}

-(Class)getEntityClass{
    return [WXUserInfoEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [[ViewControllerManager sharedManager]hideWaitView];
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
