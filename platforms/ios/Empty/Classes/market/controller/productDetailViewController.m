//
//  productDetailViewController.m
//  Empty
//
//  Created by leron on 15/12/21.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "productDetailViewController.h"

@interface productDetailViewController ()
{
    NSArray* btntabBar;
}
@end

@implementation productDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTabBar{
    UIView* tabBarView = [[UIView alloc]init];
    tabBarView.backgroundColor = [UIColor redColor];
    UIButton* btnParameter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnParameter setTitle:@"参数" forState:UIControlStateNormal];
    [btnParameter setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnParameter setBackgroundColor:[UIColor clearColor]];
    UIButton* btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDetail setTitle:@"详情" forState:UIControlStateNormal];
    [btnDetail setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDetail setBackgroundColor:[UIColor clearColor]];
    UIButton* btnEvaluate = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEvaluate setTitle:@"评价" forState:UIControlStateNormal];
    [btnEvaluate setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnEvaluate setBackgroundColor:[UIColor clearColor]];
    btntabBar = [[NSArray alloc]initWithObjects:btnParameter,btnDetail,btnEvaluate, nil];
    [self.view addSubview:tabBarView];
    [tabBarView addSubview:btnParameter];
    [tabBarView addSubview:btnDetail];
    [tabBarView addSubview:btnEvaluate];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tabBarView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tabBarView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tabBarView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tabBarView)]];
    tabBarView.translatesAutoresizingMaskIntoConstraints = NO;
    btnEvaluate.translatesAutoresizingMaskIntoConstraints = NO;
    btnDetail.translatesAutoresizingMaskIntoConstraints = NO;
    btnParameter.translatesAutoresizingMaskIntoConstraints = NO;
    [tabBarView addConstraint:[NSLayoutConstraint constraintWithItem:btnDetail attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tabBarView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [tabBarView addConstraint:[NSLayoutConstraint constraintWithItem:btnDetail attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tabBarView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [tabBarView addConstraint:[NSLayoutConstraint constraintWithItem:btnParameter attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:btnDetail attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-20]];
    [tabBarView addConstraint:[NSLayoutConstraint constraintWithItem:btnParameter attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tabBarView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [tabBarView addConstraint:[NSLayoutConstraint constraintWithItem:btnEvaluate attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:btnDetail attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:20]];
    [tabBarView addConstraint:[NSLayoutConstraint constraintWithItem:btnEvaluate attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tabBarView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [tabBarView layoutIfNeeded];
    [self.view layoutIfNeeded];
}

//-(void)updateViewConstraints{
//    [super updateViewConstraints];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
