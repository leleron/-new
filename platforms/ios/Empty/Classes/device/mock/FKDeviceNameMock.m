//
//  FKDeviceNameMock.m
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKDeviceNameMock.h"
#import "identifyEntity.h"
@implementation FKDeviceNameParam
@end

@implementation FKDeviceNameMock
-(NSString*)getOperatorType{
    return self.operationType;
}
-(Class)getEntityClass{
    return [identifyEntity class];
}


@end
