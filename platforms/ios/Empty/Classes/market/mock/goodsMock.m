//
//  goodsMock.m
//  Empty
//
//  Created by 信息部－研发 on 15/11/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "goodsMock.h"
@implementation goodsParam
- (instancetype) init {
    if (self = [super init]) {
        self.api_name = @"APP";
        self.api_key = @"1439860175";
        self.api_token = @"a84d0a6e3937c5b532592b1eb4f8f6b7";

        return  self;
    }
    return nil;
}
@end

@implementation goodsMock
- (Class)getEntityClass {
    return [goodsEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
