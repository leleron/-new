//
//  thridPartyDeleteMock.m
//  Empty
//
//  Created by leron on 15/9/14.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "thridPartyDeleteMock.h"
@implementation thridPartyDeleteParam

@end
@implementation thridPartyDeleteMock
-(NSString*)getOperatorType{
    UserInfo* u = [UserInfo restore];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString* loginType;
    if ([delegate.login_type isEqualToString:LOGIN_QQ]) {
        loginType = @"qq";
    }
    if ([delegate.login_type isEqualToString:LOGIN_WEIBO]) {
        loginType = @"weibo";
    }
    if ([delegate.login_type isEqualToString:LOGIN_WECHAT]) {
        loginType = @"wechat";
    }
    if ([delegate.login_type isEqualToString:LOGIN_JD]) {
        loginType = @"jd";
    }
    return [NSString stringWithFormat:@"/flycounbindthirduser/%@?unbindType=%@",u.tokenID,loginType];
}

-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
