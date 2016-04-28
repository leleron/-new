//
//  serviceProvinceMock.h
//  Empty
//
//  Created by leron on 15/12/9.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "serviceNetEntity.h"
@interface servicePorovinceParam : QUMockParam
@property(strong,nonatomic)NSString* api_name;
@property(strong,nonatomic)NSString* api_key;
@property(strong,nonatomic)NSString* api_token;
@end

@interface serviceProvinceMock : QUMock

@end

@interface serviceNetParam : servicePorovinceParam
@property(strong,nonatomic)NSString* service_code;
@end


@interface servicePointMock : QUMock

@end

@interface cityInfoEntity : QUEntity
@property(strong,nonatomic)NSString* service_area;
@property(strong,nonatomic)NSString* service_code;
@end