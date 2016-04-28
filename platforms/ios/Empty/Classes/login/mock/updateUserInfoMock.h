//
//  updateUserInfoMock.h
//  Empty
//
//  Created by 李荣 on 15/7/9.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "updateUserInfoEntity.h"
@interface updateUserInfoParam : QUMockParam
@property(strong,nonatomic)NSString* USER_NAME;
@property(strong,nonatomic)NSString* IMAGE;
@property(strong,nonatomic)NSString* SEX;
@property(strong,nonatomic)NSString* REGION;
@property(strong,nonatomic)NSString* YEAR;
@property(strong,nonatomic)NSString* MONTH;
@property(strong,nonatomic)NSString* DAY;
@property(strong,nonatomic)NSString* HOME_ADDRESS;
@property(strong,nonatomic)NSString* REAL_NAME;
@end
@interface updateUserInfoMock : QUMock

@end
