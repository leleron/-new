//
//  setAppointMock.h
//  Empty
//
//  Created by leron on 15/9/30.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "identifyEntity.h"
@interface setAppointParam : QUMockParam
@property(strong,nonatomic)NSString* isRepeated;
@property(strong,nonatomic)NSString* executeTime;
@property(strong,nonatomic)NSString* monday;
@property(strong,nonatomic)NSString* tuesday;
@property(strong,nonatomic)NSString* wednesday;
@property(strong,nonatomic)NSString* thursday;
@property(strong,nonatomic)NSString* friday;
@property(strong,nonatomic)NSString* saturday;
@property(strong,nonatomic)NSString* sunday;

@end
@interface setAppointMock : QUMock

@end
