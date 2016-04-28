//
//  GetVerifyViewController.m
//  Empty
//
//  Created by leron on 15/6/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "GetVerifyViewController.h"
#import "RegisterViewController.h"
#import "forgetCodeMock.h"
//#import "AFNetworking.h"
#import "ASIHTTPRequest.h"
#import "identifyCodeMock.h"
#import "registerMock.h"
@interface GetVerifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode;
//@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;       //注册button
@property(strong,nonatomic)NSString* phone;
@property(strong,nonatomic)NSString* vertifyNum;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property(strong,nonatomic)NSString*psw;
@property(strong,nonatomic)forgetCodeMock* myCodeMock;
@property(strong,nonatomic)forgetCodeParam* myCodeParam;
@property(strong,nonatomic)identifyCodeMock* myIdentifyCodeMock;
@property(strong,nonatomic)identifyCodeParam* myIndentifyCodeParam;
@property(strong,nonatomic)registerMock* myRegisterMock;        //注册mock
@property(assign,nonatomic)NSInteger counter;
@end

@implementation GetVerifyViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"新用户注册";
    [self.phoneNum setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.verifyCode setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneNum.keyboardType = UIKeyboardTypePhonePad;
    self.verifyCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [WpCommonFunction setView:self.clickButton cornerRadius:10];
    [WpCommonFunction hideTabBar];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initQuickUI{
    [self.clickButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.btnGetCode addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
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

-(void)getCode{
    
    BOOL isPhone = [WpCommonFunction checkTelNumber:self.phoneNum.text];
    if (isPhone) {
        self.counter = 60;
        self.phone = self.phoneNum.text;
        self.myCodeMock.operationType = [NSString stringWithFormat:@"/user/verify/%@",self.phone];
        [self.myCodeMock run:self.myCodeParam];
        self.btnGetCode.enabled = NO;
        [self.btnGetCode setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
        [self.btnGetCode setTitleColor:[UIColor colorWithRed:148/255.f green:148/255.5 blue:148/255.f alpha:1.0] forState:UIControlStateNormal];
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:YES];
        [self.btnGetCode setTitle:@"发送中" forState:UIControlStateNormal];

    }

}

-(void)showTime:(NSTimer*)time{
    if (self.counter == 0) {
        [time invalidate];
        [self.btnGetCode setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.btnGetCode setBackgroundImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
        self.btnGetCode.enabled = YES;
    }else{
        self.counter--;
        [self.btnGetCode setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.counter] forState:UIControlStateNormal];
    }
}




-(void)gotoRegister{
    self.phone = self.phoneNum.text;
    self.vertifyNum = self.verifyCode.text;
//    self.psw = self.passWord.text;
    if ([WpCommonFunction checkTelNumber:self.phone] && self.vertifyNum) {
        self.myIndentifyCodeParam.MOBILE = self.phone;
        self.myIndentifyCodeParam.IDENTIFY_CODE = self.vertifyNum;
        [self.myIdentifyCodeMock run:self.myIndentifyCodeParam];
    }
    
}


-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[forgetCodeMock class]]) {
        getCodeEntity* e = (getCodeEntity*)entity;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:YES];

    }
    if ([mock isKindOfClass:[identifyCodeMock class]]) {
        identifyEntity* e = (identifyEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            //跳转输入密码注册界面
            RegisterViewController* controller = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [controller setPhone:self.phone];
//            registerParam* param = [registerParam param];
//            param.USER_NAME = self.phone;
//            param.PASSWORD = self.psw;
//            param.MOBILE = self.phone;
//            param.IDENTIFY_CODE = self.vertifyNum;
//            param.SECURITYCODE = self.vertifyNum;
//            [self.myRegisterMock run:param];
        }
        RegisterViewController* controller = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller setPhone:self.phone];
//            registerParam* param = [registerParam param];
//        registerParam* param = [registerParam param];
//        param.USER_NAME = self.phone;
//        param.PASSWORD = self.psw;
//        param.MOBILE = self.phone;
//        param.IDENTIFY_CODE = self.vertifyNum;
//        param.SECURITYCODE = self.vertifyNum;
//        [self.myRegisterMock run:param];

    }
    if ([mock isKindOfClass:[registerMock class]]) {
        
    }
    
}
@synthesize phone;
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
