//
//  updateVersionMock.h
//  Empty
//
//  Created by leron on 15/9/8.
//
//

#import "QUMock.h"
#import "identifyEntity.h"
@interface updateDeviceVersionParam : QUMockParam
@property(strong,nonatomic)NSString* action;
@property(strong,nonatomic)NSString* source;
@property(strong,nonatomic)NSString* tokenid;
@end

@interface updateDeviceVersionMock : QUMock

@end
