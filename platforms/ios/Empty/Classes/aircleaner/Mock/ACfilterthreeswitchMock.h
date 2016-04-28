//
//  ACfilterthreeswitchMock.h
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "QUMock.h"
#import "identifyEntity.h"

@interface ACfilterthreeswitchParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* filter_status;
@property(strong,nonatomic)NSString* source;
@end

@interface ACfilterthreeswitchMock : QUMock

@end
