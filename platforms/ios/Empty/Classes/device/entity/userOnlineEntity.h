//
//  userOnlineEntity.h
//  Empty
//
//  Created by leron on 15/9/10.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"
@interface  userOnlineEntity : QUEntity
@property(strong,nonatomic)NSArray* deviceOwners;
@end

@interface userOnlineListEntity : QUEntity
@property(strong,nonatomic)NSString* userType;
@property(strong,nonatomic)NSString* userName;
@property(strong,nonatomic)NSString* userId;
@property(strong,nonatomic)NSString* nickName;
@end
