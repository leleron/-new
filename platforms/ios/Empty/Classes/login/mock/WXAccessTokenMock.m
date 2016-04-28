//
//  WXAccessTokenMock.m
//  Empty
//
//  Created by leron on 15/6/29.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "WXAccessTokenMock.h"
@implementation WXAccessTokenParam

@end
@implementation WXAccessTokenMock
-(NSString*)getOperatorType{
    return @"WX_ACCESS_TOKEN";
}
-(Class)getEntityClass{
    return [WXAccessTokenEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
