//
//  goodsMock.h
//  Empty
//
//  Created by 信息部－研发 on 15/11/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUMock.h"
#import "goodsEntity.h"
@interface goodsParam : QUMockParam
@property (strong, nonatomic) NSString *api_name;
@property (strong, nonatomic) NSString *api_key;
@property (strong, nonatomic) NSString *api_token;
@end

@interface goodsMock : QUMock

@end
