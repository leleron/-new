//
//  getPicCodeMock.m
//  Empty
//
//  Created by leron on 15/8/3.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "getPicCodeMock.h"
@implementation getPicCodeParam
@end
@implementation getPicCodeMock
-(NSString*)getOperatorType{
    return @"/user/randomcode";
}

-(Class)getEntityClass{
    return [getPicCodeEntity class];
}
@end
