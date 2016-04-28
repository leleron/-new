//
//  resetDevicePswMock.h
//  Empty
//
//  Created by leron on 15/9/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "identifyEntity.h"
@interface resetDevicePswParam : QUMockParam
@property(strong,nonatomic)NSString* TOKENID;
@property(strong,nonatomic)NSString* NEW_PASSWORD;
@end
@interface resetDevicePswMock : QUMock

@end
