//
//  loginTypeView.h
//  Empty
//
//  Created by leron on 15/6/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewThirdLogin:UIView
@property (strong, nonatomic) IBOutlet UIButton *btnAddWechat;
@property (strong, nonatomic) IBOutlet UIButton *btnAddQQ;
@property (strong, nonatomic) IBOutlet UIButton *btnAddWeibo;
@property (weak, nonatomic) IBOutlet UIButton *btnAddJD;



@end
@interface viewBindFlycoCount : UIView
@property (strong, nonatomic) IBOutlet UITextField *textPhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *textPsw;

@end


@interface loginTypeView : UIView

@end
