//
//  updateUserInfoMock.m
//  Empty
//
//  Created by 李荣 on 15/7/9.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "updateUserInfoMock.h"
@implementation updateUserInfoParam
@end
@implementation updateUserInfoMock

-(NSString*)getOperatorType{
    UserInfo* myUserInfo = [UserInfo restore];
    self.operationType = [NSString stringWithFormat:@"/user/%@",myUserInfo.tokenID];
    return self.operationType;
}

-(Class)getEntityClass{
    return [updateUserInfoEntity class];
}

@end
