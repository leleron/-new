//
//  versonUpdateMock.m
//  HelloCordova
//
//  Created by leron on 15/8/25.
//
//

#import "versonUpdateMock.h"
@implementation versonUpdateParam
@end
@implementation versonUpdateMock
-(NSString*)getOperatorType{
    return @"/find/currentVersion";
}

-(Class)getEntityClass{
    return [versonEntity class];
}

-(void)QUNetAdaptor:(QUNetAdaptor *)adaptor response:(QUNetResponse *)response{
    [self.delegate QUMock:self entity:response.pEntity];
}
@end
