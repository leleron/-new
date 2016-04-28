//
//  messageDeleteMock.m
//  Empty
//
//  Created by 信息部－研发 on 15/9/23.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "identifyEntity.h"
#import "messageDeleteMock.h"

@implementation messageDeleteParam

@end

@implementation messageDeleteMock
-(NSString *)getOperatorType{
    return @"/my/deletemessages";
}

-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
