//
//  messageEntity.h
//  Empty
//
//  Created by 信息部－研发 on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface messageEntity : QUEntity
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* message;
@property(strong,nonatomic)NSArray* result;
@end
