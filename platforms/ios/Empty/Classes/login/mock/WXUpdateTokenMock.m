//
//  WXUpdateTokenMock.m
//  Empty
//
//  Created by leron on 15/6/29.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "WXUpdateTokenMock.h"
@implementation WXUpdateTokenParma
@end
@implementation WXUpdateTokenMock
-(NSString*)getOperatorType{
    return @"Update_WX_Token";
}
-(Class)getEntityClass{
    return [WXAccessTokenEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
