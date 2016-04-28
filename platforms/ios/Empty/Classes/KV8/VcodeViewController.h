//
//  VcodeViewController.h
//  KV8
//
//  Created by RJONE on 15/6/16.
//  Copyright (c) 2015年 MasKSJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "miscClasses/CamObj.h"
#import "MBProgressHUD.h"
#import "CamObj.h"

@interface VcodeViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong)CamObj *cam;

@end
