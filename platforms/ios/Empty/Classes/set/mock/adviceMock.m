//
//  adviceMock.m
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "adviceMock.h"

@implementation adviceParam

@end
@implementation adviceMock
-(NSString*)getOperatorType{
    return @"/my/opinion";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
