//
//  CheckUpdateStatusMock.h
//  Empty
//
//  Created by duye on 15/9/15.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "deviceVersionCompareEntity.h"
@interface CheckUpdateStatusParam : QUMockParam
@property(strong,nonatomic)NSString* firmwareId;
@end
@interface CheckUpdateStatusMock : QUMock

@end
