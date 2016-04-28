//
//  ESPManager.m
//  EspTouchDemo
//
//  Created by duye on 15/9/23.
//  Copyright © 2015年 白 桦. All rights reserved.
//

#import "ConnectionManager.h"
#import "ESP_NetUtil.h"

@implementation ConnectionManager{
    ESPTouchTask *esptouchTask;
}

+ (ConnectionManager*) sharedConnectionManager{
    static ConnectionManager *sharedConnectionManagerInstance = nil;
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        sharedConnectionManagerInstance = [[self alloc] init];
    });
    return sharedConnectionManagerInstance;
}

- (void) ESPConnectStart{
    if (_apPwd) {
        NSLog(@"ESPViewController do confirm action...");
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"ESPViewController do the execute work...");
            // execute the task
            NSArray *esptouchResultArray = [self executeForResults];
            // show the result to the user in UI Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                // check whether the task is cancelled and no results received
                if (!firstResult.isCancelled)
                {
                    NSMutableString *mutableStr = [[NSMutableString alloc]init];
                    NSUInteger count = 0;
                    // max results to be displayed, if it is more than maxDisplayCount,
                    // just show the count of redundant ones
                    const int maxDisplayCount = 5;
                    if ([firstResult isSuc])
                    {
                        
                        for (int i = 0; i < [esptouchResultArray count]; ++i)
                        {
                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
//                            [mutableStr appendString:[resultInArray description]];
                            [mutableStr appendString:@"\n"];
                            count++;
                            if (count >= maxDisplayCount)
                            {
                                break;
                            }
                        }
                        
                        if (count < [esptouchResultArray count])
                        {
                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                        }
                        NSLog(@"Execute Result:%@",firstResult.bssid);
                        [_delegate ESPCallBack:YES result:firstResult.bssid];
                    }
                    else
                    {
                        NSLog(@"Esptouch fail");
                        [_delegate ESPCallBack:NO result:@""];
                    }
                }
                
            });
        });
    } else {
        NSLog(@"ssid或password没设定");
    }
}


- (void) ESPConnectClose{
    if (esptouchTask != nil)
    {
        [esptouchTask interrupt];
    }
}


- (NSArray *) executeForResults
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSDictionary *netInfo = [appdelegate fetchSSIDInfo];
    NSString *apBssid = [netInfo objectForKey:@"BSSID"];
    NSString *apSsid = [netInfo objectForKey:@"SSID"];
    BOOL isSsidHidden = NO;
    int taskCount = 1;
    esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:_apPwd andIsSsidHiden:isSsidHidden];
    NSArray * esptouchResults = [esptouchTask executeForResults:taskCount];
        NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    ESPTouchResult *esp = [esptouchResults objectAtIndex:0];
    self.ip = [ESP_NetUtil descriptionInetAddrByData:esp.ipAddrData];
    
    return esptouchResults;
}

@end