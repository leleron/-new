//
//  getCodeMock.m
//  Empty
//
//  Created by leron on 15/6/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "getCodeMock.h"
@implementation getCodeParam
@end
@implementation getCodeMock


-(NSString*)getOperatorType{
//
//    UserInfo* myUserInfo = [UserInfo restore];
//    self.operationType = [NSString stringWithFormat:@"/user/check/%@",myUserInfo.phoneNum];
    return self.operationType;
}


-(Class)getEntityClass{
    return [getCodeEntity class];
}

@end
