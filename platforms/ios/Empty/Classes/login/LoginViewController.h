//
//  LoginViewController.h
//  飞科智能
//
//  Created by leron on 15/6/8.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"

@interface LoginViewController : MyViewController<UITextFieldDelegate>
@property(strong,nonatomic)NSString* mark;         //是否是插件调用
@end
