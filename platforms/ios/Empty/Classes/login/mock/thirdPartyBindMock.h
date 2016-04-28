//
//  thirdPartyBindMock.h
//  Empty
//
//  Created by leron on 15/9/14.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "identifyEntity.h"
@interface thirdPartyBindParam : QUMockParam
@property(strong,nonatomic)NSString* UID;
@property(strong,nonatomic)NSString* LOGINTYPE;
@property(strong,nonatomic)NSString* TOKENID;
@end
@interface thirdPartyBindMock : QUMock

@end
