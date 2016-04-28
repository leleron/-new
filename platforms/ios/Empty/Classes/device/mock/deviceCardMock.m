//
//  deviceCardMock.m
//  Empty
//
//  Created by leron on 15/7/7.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "deviceCardMock.h"
@implementation deviceCardParam

@end

@implementation deviceCardMock
-(NSString*)getOperatorType{
    return self.operationType;
}

-(Class)getEntityClass{
    return [deviceCardEntity class];
}


@end
