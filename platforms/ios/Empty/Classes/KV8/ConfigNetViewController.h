//
//  SetViewController.h
//  KV8
//
//  Created by RJONE on 15/4/27.
//  Copyright (c) 2015年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "checkBindedEntity.h"
#import "AirCleanerEntity.h"
@interface ConfigNetViewController : MyViewController<UITextFieldDelegate,MBProgressHUDDelegate>
@property(strong,nonatomic)NSString* sn;
@property(strong,nonatomic)snCodeEntity* snInfoEntity;
@property(strong,nonatomic)NSString* macId;
@property(strong,nonatomic)NSString* productModel;  //产品型号
//@property(strong,nonatomic)AirCleanerEntity* airCleanerEntity;
@property(strong,nonatomic)NSString* productCode;
//@property(strong,nonatomic)NSString* vendor;
@property(strong,nonatomic)NSString* isChongzhi;
@end
