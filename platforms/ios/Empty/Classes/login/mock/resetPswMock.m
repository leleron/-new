//
//  resetPswMock.m
//  Empty
//
//  Created by leron on 15/8/3.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "resetPswMock.h"
#import "identifyEntity.h"
@implementation resetPswParam

@end
@implementation resetPswMock
-(NSString*)getOperatorType{
    return @"/user/reset";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
