//
//  deviceVersionCompareMock.h
//  Empty
//
//  Created by leron on 15/9/8.
//  Copyright (c) 2015年 leron. All rights reserved.
//

#import "QUMock.h"
#import "deviceVersionCompareEntity.h"
@interface deviceVersionCompareParam : QUMockParam
@property(strong,nonatomic)NSString* firmwareId;
@end

@interface deviceVersionCompareMock : QUMock

@end
