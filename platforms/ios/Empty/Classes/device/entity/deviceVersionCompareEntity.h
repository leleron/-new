//
//  deviceVersionCompareEntity.h
//  Empty
//
//  Created by leron on 15/9/8.
//  Copyright (c) 2015年 leron. All rights reserved.
//

#import "QUEntity.h"

@interface deviceVersionCompareEntity : QUEntity
@property(strong,nonatomic)NSString* firmwareId;
@property(strong,nonatomic)NSString* firmwareVersion;
@property(strong,nonatomic)NSString* downloadUrl;
@property(strong,nonatomic)NSString* firmwareName;
@property(strong,nonatomic)NSString* md5;
@property(strong,nonatomic)NSString* message;
@property(strong,nonatomic)NSString* status;
@end
