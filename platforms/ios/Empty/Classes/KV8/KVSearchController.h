//
//  SearchController.h
//  KV8
//
//  Created by MasKSJ on 14-8-13.
//  Copyright (c) 2014年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface KVSearchController : MyViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSString* productType;   //产品Code
@property(strong,nonatomic)NSString* productModel;   //产品型号
- (void)myAllSave;
- (void)mySearch;
@end
