//
//  messageReadMock.m
//  Empty
//
//  Created by 信息部－研发 on 15/9/23.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "identifyEntity.h"
#import "messageReadMock.h"

@implementation messageReadParam

@end

@implementation messageReadMock
-(NSString *)getOperatorType{
    return @"/my/readmessages";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}

@end
