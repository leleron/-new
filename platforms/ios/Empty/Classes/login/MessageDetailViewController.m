//
//  MessageDetailViewController.m
//  Empty
//
//  Created by 信息部－研发 on 15/9/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblMsgTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgSender;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgTime;
@property (weak, nonatomic) IBOutlet UITextView *txtViewMsgContent;
@end

@implementation MessageDetailViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMessage:(MessageObject *)message {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.myMessageDetail = message;
    }
    return self;
}

- (void)viewDidLoad {
    self.navigationBarTitle = @"消息详情";
    [super viewDidLoad];
    self.lblMsgSender.text = self.myMessageDetail.messageSender;
    self.lblMsgTime.text = [[self.myMessageDetail.messageRecieveTime substringToIndex:16] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.lblMsgTitle.text = self.myMessageDetail.messageTitle;
    self.txtViewMsgContent.text = self.myMessageDetail.messageContent;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
