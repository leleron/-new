//
//  CheckUpdateStatusMock.m
//  Empty
//
//  Created by duye on 15/9/15.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "CheckUpdateStatusMock.h"
@implementation CheckUpdateStatusParam
@end
@implementation CheckUpdateStatusMock
-(Class)getEntityClass{
    return [deviceVersionCompareEntity class];
}
//-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
//    if (response.pReason == QU_SERVICE_BACK_OK) {
//        [self.delegate QUMock:self entity:response.pEntity];
//    }
//}
@end
