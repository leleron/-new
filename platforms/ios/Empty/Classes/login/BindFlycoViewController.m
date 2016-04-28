//
//  BindFlycoViewController.m
//  Empty
//
//  Created by 信息部－研发 on 15/10/22.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "BindFlycoViewController.h"
//#import "loginMock.h"
#import "bindThirdLoginMock.h"
#import "getFlycoMock.h"

@interface BindFlycoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnBind;
@property (strong, nonatomic) bindThirdLoginMock *myBindFlycoMock;
@property(strong,nonatomic)getFlycoMock* myGetFlycoMock;

@end

@implementation BindFlycoViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"飞科账户授权";
    [super viewDidLoad];
    [self.txtPhone setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPsw setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [WpCommonFunction setView:self.btnBind cornerRadius:8];
    [self.btnBind addTarget:self action:@selector(bindFlycoAccount) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)initQuickMock {
    self.myBindFlycoMock = [bindThirdLoginMock mock];
    self.myBindFlycoMock.delegate = self;
    self.myGetFlycoMock = [getFlycoMock mock];
    self.myGetFlycoMock.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindFlycoAccount {
    [self.txtPhone resignFirstResponder];
    [self.txtPsw resignFirstResponder];
    if (self.txtPhone.text == nil || [self.txtPhone.text isEqualToString:@""]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入手机号码"];
        return;
    }
    if (![WpCommonFunction checkTelNumber:self.txtPhone.text]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"手机号码错误"];
        return;
    }
    if (self.txtPsw.text == nil || [self.txtPsw.text isEqualToString:@""]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入密码"];
        return;
    }
    if(self.txtPhone.text && ![self.txtPhone.text isEqualToString:@""] && self.txtPsw.text && ![self.txtPsw.text isEqualToString:@""]){
        UserInfo *myUserInfo = [UserInfo restore];
        if (myUserInfo == nil) {
            return;
        }
        bindThirdLoginParam* param = [bindThirdLoginParam param];
        param.USERNAME = self.txtPhone.text;
        param.PASSWORD = self.txtPsw.text;
        param.TOKENID = myUserInfo.tokenID;
        param.LOGINTYPE = myUserInfo.userLoginType;
        [self.myBindFlycoMock run:param];
        [[ViewControllerManager sharedManager]showWaitView:self.view];
    }
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[bindThirdLoginMock class]]) {
        bindThirdLoginEntity* e = (bindThirdLoginEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            NSLog(@"%@",e.flycoUserId);
            UserInfo* myUserInfo =[UserInfo restore];
            myUserInfo.phoneNum = self.txtPhone.text;
            myUserInfo.password = self.txtPsw.text;
            [myUserInfo store];
            getFlycoParam *param = [getFlycoParam param];
            param.sendMethod = @"GET";
            self.myGetFlycoMock.operationType = [NSString stringWithFormat:@"/getuser/%@", e.flycoUserId];
            [self.myGetFlycoMock run:param];
        }
    }
    if ([mock isKindOfClass:[getFlycoMock class]]) {
        getFlycoEntity *e = (getFlycoEntity *)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            UserInfo *myUserInfo = [UserInfo restore];
            myUserInfo.flycoNick = [e.result objectForKey:@"REAL_NAME"];
            myUserInfo.flycoHead = [e.result objectForKey:@"IMAGE"];
            [myUserInfo store];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.txtPhone resignFirstResponder];
    [self.txtPsw resignFirstResponder];
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
