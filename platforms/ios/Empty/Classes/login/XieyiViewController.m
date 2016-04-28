//
//  XieyiViewController.m
//  Empty
//
//  Created by leron on 15/9/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "XieyiViewController.h"

@interface XieyiViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textContent;

@end

@implementation XieyiViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"飞科用户服务协议";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [super viewDidLoad];
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
