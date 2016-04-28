//
//  updateVersionMock.m
//  Empty
//
//  Created by leron on 15/9/8.
//
//

#import "updateDeviceVersionMock.h"
@implementation updateDeviceVersionParam

@end

@implementation updateDeviceVersionMock
-(Class)getEntityClass{
    return [identifyEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    if (response.pReason == QU_SERVICE_BACK_OK) {
        [self.delegate QUMock:self entity:response.pEntity];
    }
}
@end
