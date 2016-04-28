//
//  cityEntity.h
//  Empty
//
//  Created by leron on 15/10/20.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface cityEntity : QUEntity
@property(strong,nonatomic)NSArray* cities;
@property(strong,nonatomic)NSDictionary* dict;
@end


@interface cityObject : QUEntity
@property(strong,nonatomic)NSString* cityName;
@property(strong,nonatomic)NSString* cityCode;
@end