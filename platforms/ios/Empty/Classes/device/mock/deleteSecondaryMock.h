//
//  deleteSecondaryMock.h
//  Empty
//
//  Created by leron on 15/9/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "identifyEntity.h"
@interface deleteSecondaryParam : QUMockParam
@property(strong,nonatomic)NSString* TOKENID;
@property(strong,nonatomic)NSString* USER_ID;
@end

@interface deleteSecondaryMock : QUMock

@end
