//
//  ACQuietModeMock.h
//  Empty
//
//  Created by duye on 15/9/11.
//
//

#import "QUMock.h"
#import "AirCleanerEntity.h"

@interface ACQuietModeParam : QUMockParam
@property(strong,nonatomic)NSString* tokenid;
@property(strong,nonatomic)NSString* quietmode;
@property(strong,nonatomic)NSString* source;
@end
@interface ACQuietModeMock : QUMock

@end
