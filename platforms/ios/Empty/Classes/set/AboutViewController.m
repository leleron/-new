//
//  AboutViewController.m
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "AboutViewController.h"
#import "XieyiViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnXieyi;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"关于";
    [super viewDidLoad];
    [self.btnXieyi addTarget:self action:@selector(gotoXieyi) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoXieyi {
    XieyiViewController* controller = [[XieyiViewController alloc]initWithNibName:@"XieyiViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
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
