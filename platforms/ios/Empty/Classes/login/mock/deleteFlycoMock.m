//
//  deleteFlycoMock.m
//  Empty
//
//  Created by leron on 15/9/18.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "deleteFlycoMock.h"
@implementation deleteFlycoParam

@end

@implementation deleteFlycoMock
-(NSString*)getOperatorType{
    UserInfo* u = [UserInfo restore];
    return [NSString stringWithFormat:@"/thirduserunbindflyco/%@",u.tokenID];
}

-(Class)getEntityClass{
    return [identifyEntity class];
}
@end
