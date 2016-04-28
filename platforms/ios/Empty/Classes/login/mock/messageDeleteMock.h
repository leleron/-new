//
//  messageDeleteMock.h
//  Empty
//
//  Created by 信息部－研发 on 15/9/23.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUMock.h"

@interface messageDeleteParam : QUMockParam
@property (strong, nonatomic) NSString *TOKENID;
@property (strong, nonatomic) NSString *MESSAGEID;
@end

@interface messageDeleteMock : QUMock

@end
