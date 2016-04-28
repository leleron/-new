//
//  deviceCardAttentionMock.m
//  Empty
//
//  Created by leron on 15/9/10.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "deviceCardAttentionMock.h"
#import "identifyEntity.h"
@implementation deviceCardAttentionParam

@end

@implementation deviceCardAttentionMock
-(NSString*)getOperatorType{
    return @"/devices/devicecardcontrol";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}


@end
