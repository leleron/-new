//
//  MessageDetailViewController.h
//  Empty
//
//  Created by 信息部－研发 on 15/9/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "MessageObject.h"
#import "MyViewController.h"

@interface MessageDetailViewController : MyViewController
@property (strong, nonatomic) MessageObject *myMessageDetail;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMessage:(MessageObject *)message;
@end
