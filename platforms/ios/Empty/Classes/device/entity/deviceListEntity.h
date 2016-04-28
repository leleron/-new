//
//  deviceListEntity.h
//  Empty
//
//  Created by leron on 15/6/24.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface deviceListEntity : QUEntity
@property(strong,nonatomic)NSString* OwnedStatus;
@property(strong,nonatomic)NSDictionary* OwnedDeviceList;
@property(strong,nonatomic)NSString* OwnedMessage;
@property(strong,nonatomic)NSString* AttentionedStatus;
@property(strong,nonatomic)NSString* AttentionedMessage;
@property(strong,nonatomic)NSString* status;
@end
