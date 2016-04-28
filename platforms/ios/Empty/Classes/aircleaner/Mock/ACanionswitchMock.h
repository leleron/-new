//
//  ACanionswitchMock.h
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "QUMock.h"
#import "identifyEntity.h"

@interface ACanionswitchParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* anionswitch;
@property(strong,nonatomic)NSString* source;
@end

@interface ACanionswitchMock : QUMock

@end
