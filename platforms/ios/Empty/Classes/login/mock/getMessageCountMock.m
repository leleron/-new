//
//  getMessageCountMock.m
//  Empty
//
//  Created by leron on 15/11/4.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "getMessageCountMock.h"

@implementation getMessageCountMock
-(NSString*)getOperatorType{
    UserInfo* u = [UserInfo restore];
    return [NSString stringWithFormat:@"/user/getUnreadMessageCount/%@",u.tokenID];
}

-(Class)getEntityClass{
    return [messageEntity class];
}
@end
