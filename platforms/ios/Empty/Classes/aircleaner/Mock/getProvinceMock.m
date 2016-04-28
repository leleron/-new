//
//  getProvinceMock.m
//  Empty
//
//  Created by leron on 15/10/20.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "getProvinceMock.h"

@implementation getProvinceMock
-(NSString*)getOperatorType{
    return @"/devices/find/getAllProvice";
}
-(Class)getEntityClass{
    return [getProvinceEntity class];
}
@end
