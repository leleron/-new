//
//  resetPswMock.h
//  Empty
//
//  Created by leron on 15/8/3.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
@interface resetPswParam : QUMockParam
@property(strong,nonatomic)NSString* USERNAME;
@property(strong,nonatomic)NSString* PASSWORD;
@property(strong,nonatomic)NSString* FLAG;
@end
@interface resetPswMock : QUMock

@end
