//
//  FKDeviceNameMock.h
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
@interface FKDeviceNameParam : QUMockParam
@property(strong,nonatomic)NSString* TOKENID;
//@property(strong,nonatomic)NSString* image;
@property(strong,nonatomic)NSString* nickName;
@end
@interface FKDeviceNameMock : QUMock

@end
