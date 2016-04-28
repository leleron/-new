//
//  ACfilterthreeswitchMock.m
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "ACfilterthreeswitchMock.h"

@implementation ACfilterthreeswitchParam
@end

@implementation ACfilterthreeswitchMock

-(Class)getEntityClass{
    return [identifyEntity class];
}
-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    if (response.pReason == QU_SERVICE_BACK_OK) {
        [self.delegate QUMock:self entity:response.pEntity];
    }
}

@end
