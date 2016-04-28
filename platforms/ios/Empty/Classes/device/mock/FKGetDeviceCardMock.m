//
//  FKGetDeviceCardMock.m
//  Empty
//
//  Created by leron on 15/8/19.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKGetDeviceCardMock.h"

@implementation FKGetDeviceCardParam



@end

@implementation FKGetDeviceCardMock

-(NSString*)getOperatorType{
    return self.operationType;
}

-(Class)getEntityClass{
    return [FKdeviceCardEntity class];
}
@end
