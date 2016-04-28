//
//  deviceTypeMock.m
//  Empty
//
//  Created by leron on 15/7/1.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "deviceTypeMock.h"
@implementation deviceTypeParam

@end
@implementation deviceTypeMock
-(NSString*)getOperatorType{
    UserInfo* myUserInfo = [UserInfo restore];
    self.operationType  = [NSString stringWithFormat:@"/find/addibleproductorList/?tokenId=%@",myUserInfo.tokenID];
    return self.operationType;
}

-(Class)getEntityClass{
    return [deviceTypeEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
