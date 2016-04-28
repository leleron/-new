//
//  WeatherdataMock.m
//  Empty
//
//  Created by duye on 15/9/10.
//
//

#import "WeatherdataMock.h"

@implementation WeatherdataParam

@end
@implementation WeatherdataMock

-(Class)getEntityClass{
    return [AirCleanerEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    if (response.pReason == QU_SERVICE_BACK_OK) {
        [self.delegate QUMock:self entity:response.pEntity];
    }
}
@end
