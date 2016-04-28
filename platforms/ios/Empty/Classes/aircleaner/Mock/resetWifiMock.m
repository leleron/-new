//
//  resetWifiMock.m
//  Empty
//
//  Created by leron on 15/11/20.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "resetWifiMock.h"
#import "identifyEntity.h"

@implementation resetWifiParam



@end
@implementation resetWifiMock
-(NSString*)getOperatorType{
    return @"/devices/resetWifiSuccess";
}


-(Class)getEntityClass{
    return [identifyEntity class];
}


@end
