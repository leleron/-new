//
//  bindThirdLoginMock.h
//  Empty
//
//  Created by leron on 15/7/31.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "bindThirdLoginEntity.h"
@interface bindThirdLoginParam : QUMockParam
@property(strong,nonatomic)NSString* USERNAME;
@property(strong,nonatomic)NSString* PASSWORD;
@property(strong,nonatomic)NSString* TOKENID;
@property(strong,nonatomic)NSString* LOGINTYPE;
@end
@interface bindThirdLoginMock : QUMock

@end
