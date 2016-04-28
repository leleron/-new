//
//  ACtimerMock.h
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "QUMock.h"
#import "identifyEntity.h"

@interface ACtimerParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* time_status;
@property(strong,nonatomic)NSString* time_remind;
@property(strong,nonatomic)NSString* source;
@end

@interface ACtimerMock : QUMock

@end
