//
//  adviceMock.h
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "identifyEntity.h"
@interface adviceParam : QUMockParam
@property(strong,nonatomic)NSString* TOKENID;
@property(strong,nonatomic)NSString* opinionContent;
@property(strong,nonatomic)NSString* contactMethod;
@end
@interface adviceMock : QUMock

@end
