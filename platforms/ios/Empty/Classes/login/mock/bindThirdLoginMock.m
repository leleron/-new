//
//  bindThirdLoginMock.m
//  Empty
//
//  Created by leron on 15/7/31.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "bindThirdLoginMock.h"
#import "identifyEntity.h"
@implementation bindThirdLoginParam
@end
@implementation bindThirdLoginMock
-(NSString*)getOperatorType{
    return @"/thirduserbindflyco";
}

-(Class)getEntityClass{
    return [bindThirdLoginEntity class];
}
@end
