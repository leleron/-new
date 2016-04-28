//
//  AfterSaleViewController.m
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "AfterSaleViewController.h"
#import "MyWebViewController.h"
@interface AfterSaleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnFlyco;

@end

@implementation AfterSaleViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"售后服务";
    [super viewDidLoad];
    [self.btnFlyco addTarget:self action:@selector(gotoFlyco) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoFlyco{
    MyWebViewController* controller = [MyWebViewController controllerWithUrl:@"http://m.flyco.com"];
    controller.title = @"飞科官网";
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
