//
//  AirErrorMessageEntity.h
//  Empty
//
//  Created by leron on 15/10/14.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface AirErrorMessageEntity : QUEntity
@property(strong,nonatomic)NSString* code;
@property(strong,nonatomic)NSString* status;
@property(strong,nonatomic)NSDictionary* result;
@end
