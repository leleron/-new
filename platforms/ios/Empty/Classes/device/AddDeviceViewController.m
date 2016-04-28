//
//  AddDeviceViewController.m
//  Empty
//
//  Created by leron on 15/12/2.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "SYQRCodeViewController.h"
#import "addProductViewController.h"
@interface AddDeviceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UIButton *btnHand;
@property(strong,nonatomic)UILabel *loginTagView;

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"添加设备";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnCode addTarget:self action:@selector(gotoScan) forControlEvents:UIControlEventTouchUpInside];
    [self.btnHand addTarget:self action:@selector(gotoHand) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginTagView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    self.loginTagView.textAlignment = NSTextAlignmentCenter;
    self.loginTagView.font = [UIFont systemFontOfSize:14];
    self.loginTagView.textColor = [UIColor whiteColor];
    self.loginTagView.backgroundColor = [UIColor colorWithRed:18.0f/255.0f green:72.0f/255.0f blue:138.0f/255.0f alpha:1.0f];
    self.loginTagView.text = @"请打开设备电源并开始添加设备";
    
    self.loginTagView.userInteractionEnabled = YES;
    [self.view addSubview:self.loginTagView];

    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    if (iPhone4) {
        for (NSLayoutConstraint* item in self.view.constraints) {
            if ([item.identifier isEqualToString:@"handTop"]) {
                item.constant = 10;
            }
        }
        for (NSLayoutConstraint* iiem in self.btnCode.constraints) {
            if ([iiem.identifier isEqualToString:@"btnHeight"]) {
                iiem.constant = 100;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoScan{
    SYQRCodeViewController* controller = [[SYQRCodeViewController alloc]init];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [WpCommonFunction hideTabBar];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)gotoHand{
    addProductViewController* controller = [[addProductViewController alloc]initWithNibName:@"addProductViewController" bundle:nil];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [WpCommonFunction hideTabBar];
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
