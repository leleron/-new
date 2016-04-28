//
//  deviceView.h
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamObj.h"
@interface deviceView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UIImageView *picDevice;
@property (weak, nonatomic) IBOutlet UILabel *lblTry;
@property (strong,nonatomic)NSString* deviceId;
@property (nonatomic,assign)E_CAM_STATE mCamState;
@end
