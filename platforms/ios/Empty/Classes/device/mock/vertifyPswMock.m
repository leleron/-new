//
//  vertifyPswMock.m
//  Empty
//
//  Created by leron on 15/9/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "vertifyPswMock.h"
@implementation vertifyPswParam

@end
//devices/{deviceid}/checkDevicePassword

@implementation vertifyPswMock
-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
