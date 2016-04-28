//
//  ResetPswViewController.m
//  Empty
//
//  Created by leron on 15/8/3.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "ResetPswViewController.h"
#import "MailVertifyViewController.h"
#import "MessageVertifyViewController.h"
#import "loginMock.h"
@interface ResetPswViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textNum;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property(assign,nonatomic)BOOL isPhone;
@property(assign,nonatomic)BOOL isMail;
@property (strong, nonatomic) loginMock *myLoginMock;

@end

@implementation ResetPswViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"重置密码";
    [super viewDidLoad];
    [self.btnNext addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    [WpCommonFunction setView:self.btnNext cornerRadius:8];
    UIColor *color = [UIColor grayColor];
    self.textNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号/邮箱" attributes:@{NSForegroundColorAttributeName: color}];
    self.myLoginMock = [loginMock mock];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidValid) name:@"userValid" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(void)gotoNext{
    [self.textNum resignFirstResponder];
    self.isPhone = [WpCommonFunction checkTelNumber:self.textNum.text];
    self.isMail = [WpCommonFunction validateEmail:self.textNum.text];
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
/*
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\\\d)\\\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\\\d{7}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
*/
    
    
    if ([self.textNum.text isEqualToString:@""] || self.textNum.text == nil) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入手机号或邮箱地址"];
    } else if ([self.textNum.text containsString:@"@"]) {
        if (![predicate evaluateWithObject:self.textNum.text]) {
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入正确的邮箱地址"];
        } else if (self.isMail) {
            loginParam *param = [loginParam param];
            param.LOGINID = self.textNum.text;
            param.PASSWORD = @"";
            [self.myLoginMock run:param];
//            MailVertifyViewController* controller = [[MailVertifyViewController alloc]initWithNibName:@"MailVertifyViewController" bundle:nil];
//            controller.mail = self.textNum.text;
//            [self.navigationController pushViewController:controller animated:YES];
//            return;
        }
    } else {
        if (self.isPhone) {
            loginParam *param = [loginParam param];
            param.LOGINID = self.textNum.text;
            param.PASSWORD = @"";
            [self.myLoginMock run:param];
//            MessageVertifyViewController* controller = [[MessageVertifyViewController alloc]initWithNibName:@"MessageVertifyViewController" bundle:nil];
//            controller.phoneStr = self.textNum.text;
//            [self.navigationController pushViewController:controller animated:YES];
//            return;
        } else {
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入正确的手机号码"];
        }
    }
//    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入手机号或邮箱地址"];
}

- (void)userDidValid {
    if (self.isMail) {
        MailVertifyViewController* controller = [[MailVertifyViewController alloc]initWithNibName:@"MailVertifyViewController" bundle:nil];
        controller.mail = self.textNum.text;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (self.isPhone) {

        MessageVertifyViewController* controller = [[MessageVertifyViewController alloc]initWithNibName:@"MessageVertifyViewController" bundle:nil];
            controller.phoneStr = self.textNum.text;
            [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textNum resignFirstResponder];
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
