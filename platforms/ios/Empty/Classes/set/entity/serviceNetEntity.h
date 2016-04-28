//
//  serviceNetEntity.h
//  Empty
//
//  Created by leron on 15/10/27.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface serviceNetEntity : QUEntity
@property(strong,nonatomic)NSArray* DATA;
@end

@interface servicePointEntity : QUEntity
@property(strong,nonatomic)NSDictionary* DATA;
@end