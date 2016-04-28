//
//  thirdLoginMock.h
//  Empty
//
//  Created by leron on 15/7/1.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "loginEntity.h"
@interface thirdLoginParam : QUMockParam
@property(strong,nonatomic)NSString* LOGINTYPE;
@property(strong,nonatomic)NSString* UID;
@property(strong,nonatomic)NSString* ACCESSTOKEN;
@property(strong,nonatomic)NSString* NICKNAME;
@end
@interface thirdLoginMock : QUMock

@end
