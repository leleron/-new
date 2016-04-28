//
//  ESPManager.h
//  EspTouchDemo
//
//  Created by duye on 15/9/23.
//  Copyright © 2015年 白 桦. All rights reserved.
//
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "AppDelegate.h"

@protocol ConnectionManagerDelegate
-(void)ESPCallBack:(BOOL)status result:(NSString*)mac;
@end

@interface ConnectionManager : NSObject

@property (nonatomic, strong) NSString *apPwd;

@property (weak, nonatomic)id<ConnectionManagerDelegate> delegate;
@property(nonatomic,strong)NSString* ip;
+ (ConnectionManager*) sharedConnectionManager;

- (void) ESPConnectStart;
- (void) ESPConnectClose;

@end
