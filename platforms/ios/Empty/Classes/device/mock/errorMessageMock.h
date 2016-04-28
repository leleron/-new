//
//  errorMessageMock.h
//  Empty
//
//  Created by leron on 15/9/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "errorMessageEntity.h"
@interface errorMessageParam : QUMockParam
@property(strong,nonatomic)NSString* TOKENID;
@property(strong,nonatomic)NSString* FAILURECODE;
@end

@interface errorMessageMock : QUMock

@end
