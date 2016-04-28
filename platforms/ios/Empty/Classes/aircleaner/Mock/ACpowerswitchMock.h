//
//  ACpowerswitchMock.h
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "QUMock.h"
#import "identifyEntity.h"

@interface ACpowerswitchParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* powerswitch;
@property(strong,nonatomic)NSString* source;
@end

@interface ACpowerswitchMock : QUMock
@end
