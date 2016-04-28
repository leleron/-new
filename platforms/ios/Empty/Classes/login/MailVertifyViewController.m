//
//  MailVertifyViewController.m
//  Empty
//
//  Created by leron on 15/8/3.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MailVertifyViewController.h"
#import "getPicCodeMock.h"
#import "identifyEntity.h"
#import "LoginViewController.h"

@implementation malParam



@end

@interface MailVertifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet UIImageView *viewImg;
@property (strong,nonatomic)getPicCodeMock* myCodeMock;
@property (strong,nonatomic)QUMock*  myMailMock;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property(strong,nonatomic)NSString* randomCode;
@property (weak, nonatomic) IBOutlet UIButton *btnComfirm;


@end

@implementation MailVertifyViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"验证邮箱";
    [super viewDidLoad];
    self.myCodeMock = [getPicCodeMock mock];
    self.myCodeMock.delegate = self;
    getPicCodeParam* param = [getPicCodeParam param];
    param.sendMethod = @"GET";
    [self.myCodeMock run:param];
    UIColor *color = [UIColor whiteColor];
    self.textCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证图片" attributes:@{NSForegroundColorAttributeName: color}];
    [self.btnRefresh addTarget:self action:@selector(refreshPic) forControlEvents:UIControlEventTouchUpInside];
    [self.btnComfirm addTarget:self action:@selector(comfrim) forControlEvents:UIControlEventTouchUpInside];
    [WpCommonFunction setView:self.btnComfirm cornerRadius:8];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getPicCodeMock class]]) {
        getPicCodeEntity* e = (getPicCodeEntity*)entity;
//        UIImage* img = [UIImage imageWithData:e.picture];
        NSData* imgData = [WpCommonFunction transformBase64StringToImageData:e.picture];
        UIImage* img = [UIImage imageWithData:imgData];
        self.randomCode = e.randomCode;
        self.viewImg.image = img;
    }
    if ([mock isMemberOfClass:[QUMock class]]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [WpCommonFunction showNotifyHUDAtViewBottom:appDelegate.window withErrorMessage:@"重置密码链接已发送至邮箱"];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LoginViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

-(void)refreshPic{
    getPicCodeParam* param = [getPicCodeParam param];
    param.sendMethod = @"GET";
    [self.myCodeMock run:param];
}

-(void)comfrim{
    [self.textCode resignFirstResponder];
    self.randomCode = [self.randomCode lowercaseString];
    NSString* input = [self.textCode.text lowercaseString];
    if ([self.randomCode isEqualToString:input]) {
        self.myMailMock = [QUMock mock];
        self.myMailMock.delegate = self;
        self.myMailMock.operationType = @"/user/email";
        self.myMailMock.entityClass = [identifyEntity class];
        malParam* param = [malParam param];
        param.EMAIL = self.mail;
        [self.myMailMock run:param];
    }else{
        if ([self.textCode.text isEqualToString:@""]) {
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入验证码"];
        }else
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"验证码不正确"];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textCode resignFirstResponder];
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
