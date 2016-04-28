//
//  errorMessageEntity.h
//  Empty
//
//  Created by leron on 15/9/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface errorMessageEntity : QUEntity
@property(strong,nonatomic)NSDictionary* Failure;
@end

@interface errorMessageListEntity : QUEntity
@property(strong,nonatomic)NSString* description;
@property(strong,nonatomic)NSString* failureFix;
@property(strong,nonatomic)NSString* failureName;
@property(strong,nonatomic)NSString* failurePhenomenon;
@property(strong,nonatomic)NSString* failureCode;
@end