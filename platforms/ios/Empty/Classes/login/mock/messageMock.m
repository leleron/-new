//
//  messageMock.m
//  Empty
//
//  Created by 信息部－研发 on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "messageMock.h"
@implementation messageParam
@end
@implementation messageMock


-(NSString*)getOperatorType{
    
    UserInfo* info = [UserInfo restore];
    NSString* type = [NSString stringWithFormat:@"/my/messages?tokenId=%@",info.tokenID];
    return type;
}


-(Class)getEntityClass{
    return [messageEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [[ViewControllerManager sharedManager]hideWaitView];
        [self.delegate QUMock:self entity:response.pEntity];
}


@end
