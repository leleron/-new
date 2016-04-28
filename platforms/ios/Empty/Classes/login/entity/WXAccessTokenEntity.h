//
//  WXAccessTokenEntity.h
//  Empty
//
//  Created by leron on 15/6/29.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface WXAccessTokenEntity : QUEntity
@property(strong,nonatomic)NSString* access_token;
@property(strong,nonatomic)NSString* expires_in;
@property(strong,nonatomic)NSString* refresh_token;
@property(strong,nonatomic)NSString* openid;
@property(strong,nonatomic)NSString* scope;

@end
