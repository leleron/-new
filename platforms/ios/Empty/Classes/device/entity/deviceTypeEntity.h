//
//  deviceTypeEntity.h
//  Empty
//
//  Created by leron on 15/7/1.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface deviceTypeEntity : QUEntity
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSString* message;
@property(strong,nonatomic)NSArray* result;
@end

@interface deviceListInfoEntity : QUEntity
@property(strong,nonatomic)NSString* productCode;   //产品编码
@property(strong,nonatomic)NSString* productModel;
@property(strong,nonatomic)NSString* productName;
@end