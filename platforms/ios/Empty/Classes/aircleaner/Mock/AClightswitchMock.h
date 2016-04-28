//
//  AClightswitchMock.h
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "QUMock.h"
#import "identifyEntity.h"

@interface AClightswitchParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* lightswitch;
@property(strong,nonatomic)NSString* source;
@end

@interface AClightswitchMock : QUMock

@end
