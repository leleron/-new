//
//  checkRobotUpdateMock.h
//  Empty
//
//  Created by leron on 15/10/10.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "identifyEntity.h"
@interface checkRobotUpdateParam : QUMockParam
@property(strong,nonatomic)NSString* firmwareVersion;
@end

@interface checkRobotUpdateMock : QUMock

@end
