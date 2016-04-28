//
//  RegisterViewController.m
//  Empty
//
//  Created by leron on 15/6/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "RegisterViewController.h"
#import "forgetCodeMock.h"
#import "ASIHTTPRequest.h"
#import "identifyCodeMock.h"
#import "registerMock.h"
#import "WpCommonFunction.h"
#import "XieyiViewController.h"
#import "registerEntity.h"
#import "loginMock.h"
#import "loginEntity.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *vertifyCode;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;       //注册button
@property(strong,nonatomic)NSString* phone;

@property (weak, nonatomic) IBOutlet UIButton *btnXieyi;

//@property(strong,nonatomic)NSString* vertifyNum;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property(strong,nonatomic)NSString*psw;
@property(strong,nonatomic)forgetCodeMock* myCodeMock;
@property(strong,nonatomic)forgetCodeParam* myCodeParam;
@property(strong,nonatomic)identifyCodeMock* myIdentifyCodeMock;
@property(strong,nonatomic)identifyCodeParam* myIndentifyCodeParam;
@property(strong,nonatomic)registerMock* myRegisterMock;        //注册mock
@property(strong,nonatomic)loginMock* myLoginMock;
@property(assign,nonatomic)NSInteger counter;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"新用户注册";
    [self.passWord setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.vertifyCode setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.passWord.delegate = self;
    [super viewDidLoad];
    [WpCommonFunction setView:self.clickButton cornerRadius:10];
    [self.btnGetCode addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnXieyi addTarget:self action:@selector(gotoXieyi) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger countBack = [userDefaults integerForKey:@"countBack"];
    if (countBack > 0) {
        self.btnGetCode.enabled = NO;
        self.counter = countBack;
        self.btnGetCode.titleLabel.text = nil;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:YES];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.counter > 0) {
        [userDefaults setInteger:self.counter forKey:@"countBack"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initQuickUI{
    [self.clickButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
}
-(void)initQuickMock{
    self.myCodeMock = [forgetCodeMock mock];
    self.myCodeMock.delegate = self;
    self.myCodeParam = [forgetCodeParam param];
    self.myCodeParam.sendMethod = @"GET";
    self.myIdentifyCodeMock = [identifyCodeMock mock];
    self.myIdentifyCodeMock.delegate = self;
    self.myIndentifyCodeParam = [identifyCodeParam param];
    self.myRegisterMock = [registerMock mock];
    self.myRegisterMock.delegate = self;
}


-(void)gotoXieyi{
    XieyiViewController* controller = [[XieyiViewController alloc]initWithNibName:@"XieyiViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)getCode{
    
    [self hideKeyBoard];
    if (self.btnGetCode.isEnabled == NO) {
        return;
    }
    self.phone = self.phoneNum.text;
    BOOL isPhone = [WpCommonFunction checkTelNumber:self.phone];
    if (isPhone) {
        self.counter = 60;
        self.phone = self.phoneNum.text;
        self.myCodeMock.operationType = [NSString stringWithFormat:@"/user/verify/%@",self.phone];
        [self.myCodeMock run:self.myCodeParam];
        self.btnGetCode.enabled = NO;
        [self.btnGetCode setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
        [self.btnGetCode setTitleColor:[UIColor colorWithRed:148/255.f green:148/255.5 blue:148/255.f alpha:1.0] forState:UIControlStateNormal];
        [self.btnGetCode setTitle:@"发送中" forState:UIControlStateNormal];
    }else if(self.phoneNum.text.length == 0){
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入手机号"];
    }else{
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"手机号格式不正确"];
    }
}

-(void)showTime:(NSTimer*)time{
    if (self.counter == 0) {
        [time invalidate];
        [self.btnGetCode setTitle:@"重新获取" forState:UIControlStateNormal];
        //        [self.btnGetCode setBackgroundImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
        [self.btnGetCode setBackgroundColor:Color_Bg_celllightblue];
        self.btnGetCode.enabled = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"countBack"];
    }else{
        self.counter--;
        self.btnGetCode.titleLabel.text = [NSString stringWithFormat:@"%ld秒",(long)self.counter];
        [self.btnGetCode setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.counter] forState:UIControlStateDisabled];
        
    }
}




-(void)gotoRegister{
    self.phone = self.phoneNum.text;
    self.psw = self.passWord.text;
    [self.phoneNum resignFirstResponder];
    [self.vertifyCode resignFirstResponder];
    [self.passWord resignFirstResponder];
    self.phone = self.phoneNum.text;
    BOOL isPhone = [WpCommonFunction checkTelNumber:self.phone];
    BOOL isPsw = [WpCommonFunction verifyNewPaymentPassword:self.psw];
    if (isPhone && isPsw) {
        self.myIndentifyCodeParam.MOBILE = self.phone;
        self.myIndentifyCodeParam.IDENTIFY_CODE = self.vertifyCode.text;
        [self.myIdentifyCodeMock run:self.myIndentifyCodeParam];
    }else if(!isPhone){
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"手机号码不正确"];
    }else if(!isPsw){
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"密码应为6-20位数字或密码"];
    }
    
}


-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[forgetCodeMock class]]) {
        getCodeEntity* e = (getCodeEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:YES];
        }else{
            [self.btnGetCode setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.btnGetCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btnGetCode setEnabled:YES];
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:e.message];
        }
    }
    if ([mock isKindOfClass:[identifyCodeMock class]]) {
        identifyEntity* e = (identifyEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            //发送注册请求
            registerParam* param = [registerParam param];
            param.USER_NAME = self.phone;
            param.PASSWORD = self.psw;
            param.MOBILE = self.phone;
            param.REAL_NAME = self.phone;
            param.SOURCE_SYSTEM = @"app";
            param.USER_TYPE = @"feikeyonghu";
        
            BOOL isPsw = [WpCommonFunction verifyNewPaymentPassword:self.psw];
            if (isPsw) {
                [self.myRegisterMock run:param];
            } else {
                [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"密码格式不正确"];
            }

        }
    }
    if ([mock isKindOfClass:[registerMock class]]) {
        registerEntity *e = (registerEntity *)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (appDelegate != nil) {
                [WpCommonFunction showNotifyHUDAtViewBottom:appDelegate.window withErrorMessage:@"注册成功"];
            }
            UserInfo *myUserInfo = [UserInfo restore];
            if (myUserInfo == nil) {
                myUserInfo = [[UserInfo alloc] init];
                [myUserInfo store];
            }
            myUserInfo = [UserInfo restore];
            myUserInfo.phoneNum = e.userName;
            myUserInfo.tokenID = e.tokenId;
            myUserInfo.userLoginType = LOGIN_PHONE;
            [myUserInfo store];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RegisterSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if ([mock isKindOfClass:[loginMock class]]) {
        loginEntity* e = (loginEntity*)entity;
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.tokenID = e.tokenId;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}
- (void)setPhone:(NSString *)phone {
    _phone = phone;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNum resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.vertifyCode resignFirstResponder];
}


-(void)hideKeyBoard{
    [self.phoneNum resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.vertifyCode resignFirstResponder];
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
