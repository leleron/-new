//
//  thirdPartyBindMock.m
//  Empty
//
//  Created by leron on 15/9/14.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "thirdPartyBindMock.h"
@implementation thirdPartyBindParam
@end
@implementation thirdPartyBindMock
-(NSString*)getOperatorType{
    return @"/flycobindthirdparty";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
