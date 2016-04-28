//
//  MessageObject.h
//  Empty
//
//  Created by 信息部－研发 on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject
@property (strong, nonatomic) NSString* messageId;
@property (strong, nonatomic) NSString* messageTitle;
@property (strong, nonatomic) NSString* messageContent;
@property (strong, nonatomic) NSString* messageRecieveTime;
@property (strong, nonatomic) NSString* messageStatus;
@property (strong, nonatomic) NSString* messageSender;
@end
