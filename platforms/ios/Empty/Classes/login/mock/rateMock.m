//
//  rateMock.m
//  Empty
//
//  Created by 信息部－研发 on 15/10/8.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "rateMock.h"

@implementation rateParam
@end

@implementation rateMock
- (NSString *)getOperatorType {
    NSString *type = @"/devices/iosupdateurl";
    return type;
}
- (Class)getEntityClass {
    return [rateEntity class];
}
@end
