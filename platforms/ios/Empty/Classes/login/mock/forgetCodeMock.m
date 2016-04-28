//
//  forgetCodeMock.m
//  Empty
//
//  Created by leron on 15/6/23.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "forgetCodeMock.h"
@implementation forgetCodeParam
@end
@implementation forgetCodeMock

-(NSString*)getOperatorType{
    return  self.operationType;
}

-(Class)getEntityClass{
    return [getCodeEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
