//
//  DeviceErrorListViewController.h
//  Empty
//
//  Created by duye on 15/9/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceErrorListViewController : MyViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSString *deviceId;

@end
