//
//  ACfiltertwoswitchMock.h
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "QUMock.h"
#import "identifyEntity.h"

@interface ACfiltertwoswitchParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* filter_status;
@property(strong,nonatomic)NSString* source;
@end

@interface ACfiltertwoswitchMock : QUMock

@end
