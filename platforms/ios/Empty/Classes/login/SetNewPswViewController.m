//
//  SetNewPswViewController.m
//  Empty
//
//  Created by leron on 15/8/3.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "SetNewPswViewController.h"
#import "resetPswMock.h"
#import "LoginViewController.h"
@interface SetNewPswViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textPsw;
@property (weak, nonatomic) IBOutlet UITextField *textPsw2;
@property (weak, nonatomic) IBOutlet UIButton *btnComfirm;
@property(strong,nonatomic)resetPswMock* myResetMock;
@end

@implementation SetNewPswViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"设置新密码";
    [super viewDidLoad];
    [self.btnComfirm addTarget:self action:@selector(comfirm) forControlEvents:UIControlEventTouchUpInside];
    self.textPsw.secureTextEntry = YES;
    self.textPsw2.secureTextEntry = YES;
    UIColor *color = [UIColor grayColor];
    [WpCommonFunction setView:self.btnComfirm cornerRadius:8];
    self.textPsw.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.textPsw2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:@{NSForegroundColorAttributeName: color}];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initQuickMock{
    self.myResetMock = [resetPswMock mock];
    self.myResetMock.delegate = self;
}
-(void)comfirm{
    [self.textPsw resignFirstResponder];
    [self.textPsw2 resignFirstResponder];
    
    BOOL old =   [WpCommonFunction verifyNewPaymentPassword:self.textPsw.text];
    BOOL new =   [WpCommonFunction verifyNewPaymentPassword:self.textPsw2.text];
    
    if (old && new) {
        if ([self.textPsw.text isEqualToString: self.textPsw2.text]) {
            resetPswParam* param = [resetPswParam param];
            param.USERNAME = self.phoneStr;
            param.PASSWORD = self.textPsw2.text;
            param.FLAG = @"reset";
            [self.myResetMock run:param];
        }else{
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"两次密码输入需一致"];
        }

    }else{
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"密码应为6-20位数字或字母"];
    }
    
}
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WpCommonFunction showNotifyHUDAtViewBottom:appDelegate.window withErrorMessage:@"密码重置成功"];
    for (UIViewController* item in self.navigationController.childViewControllers) {
        if ([item isMemberOfClass:[LoginViewController class]]) {
            LoginViewController* controller = (LoginViewController*)item;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textPsw resignFirstResponder];
    [self.textPsw2 resignFirstResponder];
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
