//
//  serviceProvinceMock.m
//  Empty
//
//  Created by leron on 15/12/9.
//  Copyright © 2015年 李荣. All rights reserved.
//
#ifdef WP_REAL_SERVER
#define URL_PROVINCE @"http://app01.flyco.net.cn/appapi/index.service.area"
#define URL_AREA @"http://app01.flyco.net.cn/appapi/index.service.list"
#else
#define URL_PROVINCE @"http://139.196.57.5:30005/appapi/index.service.area"
#define URL_AREA @"http://139.196.57.5:30005/appapi/index.service.list"
#endif

#import "serviceProvinceMock.h"
@implementation servicePorovinceParam
-(instancetype)init{
    self = [super init];
    if (self) {
        self.api_name = @"APP";
        self.api_key = @"1439860175";
        self.api_token = @"a84d0a6e3937c5b532592b1eb4f8f6b7";
    }
    return self;
}
@end
@implementation serviceProvinceMock
-(NSString*)getOperatorType{
    
    return URL_PROVINCE;
}
-(Class)getEntityClass{
    return [serviceNetEntity class];
}

@end

@implementation serviceNetParam



@end

@implementation servicePointMock

-(NSString*)getOperatorType{
    return URL_AREA;
}
-(Class)getEntityClass{
    return [servicePointEntity class];
}
@end

@implementation cityInfoEntity

@end