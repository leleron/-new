//
//  getModelMock.m
//  Empty
//
//  Created by leron on 15/11/5.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "getModelMock.h"

@implementation getModelMock
-(Class)getEntityClass{
    return [identifyEntity class];
}

-(NSString*)getOperatorType{
    return self.operationType;
}
@end
