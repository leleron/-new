//
//  UserInfo.m
//  Empty
//
//  Created by leron on 15/6/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
-(void)store{
    NSString* jsonString =[[[QUJsonParse alloc] init] stringFromObjc:self];
    
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(instancetype)restore{
    NSString* jsonString=[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    
    return [[[QUJsonParse alloc] init] objFromString:jsonString withClass:[self class]];
}

+(void)deleteData{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)copy:(id)sender{
    UserInfo* oldInfo = (UserInfo*)sender;
    self.nickName = oldInfo.nickName;
    self.headImg = oldInfo.headImg;
    self.phoneNum = oldInfo.phoneNum;
    self.password  = oldInfo.password;
    self.tokenID = oldInfo.tokenID;
    self.userid = oldInfo.userid;
    self.userName = oldInfo.userName;
    self.userLoginType = oldInfo.userLoginType;
    self.qqTokenID = oldInfo.qqTokenID;
    self.qqUserID = oldInfo.qqUserID;
    self.wxUserID = oldInfo.wxUserID;
    self.wxTokenID = oldInfo.wxTokenID;
    self.wxRefreshTokenID = oldInfo.wxRefreshTokenID;
    self.wbUserID = oldInfo.wbUserID;
}


@end
