//
//  ACrunningmodelMock.h
//  Empty
//
//  Created by duye on 15/9/7.
//
//

#import "QUMock.h"
#import "identifyEntity.h"

@interface ACrunningmodelParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* runningmodel;
@property(strong,nonatomic)NSString* source;
@end

@interface ACrunningmodelMock : QUMock

@end
