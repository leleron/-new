//
//  DeviceErrorListEntity.m
//  Empty
//
//  Created by duye on 15/9/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "DeviceErrorListEntity.h"

@implementation DeviceErrorListInfoEntity

@end

@implementation DeviceErrorListEntity

- (NSArray *)getDeviceErrorLists{
    NSMutableArray *returnValue = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.deviceMessageList) {
        DeviceErrorListInfoEntity *entity = [DeviceErrorListInfoEntity entity];
        entity.deviceMsgContent = [dic objectForKey:@"deviceMsgContent"];
        entity.deviceMsgDetailTime = [dic objectForKey:@"deviceMsgDetailTime"];
        entity.deviceMsgId = [dic objectForKey:@"deviceMsgId"];
        entity.deviceMsgStatus = [dic objectForKey:@"deviceMsgStatus"];
        entity.deviceMsgTime = [dic objectForKey:@"deviceMsgTime"];
        entity.deviceMsgTitle = [dic objectForKey:@"deviceMsgTitle"];
        entity.failureCode = [dic objectForKey:@"failureCode"];
        entity.failureLevel = [dic objectForKey:@"failureLevel"];
        entity.failureTime = [dic objectForKey:@"failureTime"];
        [returnValue addObject:entity];
    }
    return returnValue;
}

@end

