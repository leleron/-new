//
//  UserExitMock.m
//  Empty
//
//  Created by leron on 15/7/1.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "UserExitMock.h"
@implementation UserExitParam

@end
@implementation UserExitMock
-(NSString*)getOperatorType{
    return @"/user/loginOut";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
