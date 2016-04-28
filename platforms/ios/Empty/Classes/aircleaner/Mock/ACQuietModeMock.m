//
//  ACQuietModeMock.m
//  Empty
//
//  Created by duye on 15/9/11.
//
//

#import "ACQuietModeMock.h"

@implementation ACQuietModeParam

@end

@implementation ACQuietModeMock

-(Class)getEntityClass{
    return [AirCleanerEntity class];
}
-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    if (response.pReason == QU_SERVICE_BACK_OK) {
        [self.delegate QUMock:self entity:response.pEntity];
    }
}

@end
