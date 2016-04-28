//
//  WXUserInfoEntity.h
//  Empty
//
//  Created by leron on 15/6/29.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface WXUserInfoEntity : QUEntity
@property(strong,nonatomic)NSString* openid;
@property(strong,nonatomic)NSString* nickname;
@property(strong,nonatomic)NSString* sex;
@property(strong,nonatomic)NSString* headimgurl;
@end
