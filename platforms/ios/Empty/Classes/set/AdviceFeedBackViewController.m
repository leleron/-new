//
//  AdviceFeedBackViewController.m
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "AdviceFeedBackViewController.h"
#import "adviceMock.h"
@interface AdviceFeedBackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textAdvice;
@property (weak, nonatomic) IBOutlet UITextField *textMail;

@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property(strong,nonatomic)adviceMock* myAdviceMock;
@end

@implementation AdviceFeedBackViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"意见反馈";
    [super viewDidLoad];
    UIColor *color = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textAdvice.attributedText = [[NSAttributedString alloc]initWithString:@"您的意见是我们不断前进的动力" attributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.textMail.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号码/邮箱(选填)以便我们回复你" attributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self.btnCommit addTarget:self action:@selector(commitAdvice) forControlEvents:UIControlEventTouchUpInside];
    self.textAdvice.delegate = self;
    [WpCommonFunction setView:self.btnCommit cornerRadius:8];
    // Do any additional setup after loading the view from its nib.
}
-(void)initQuickMock{
    self.myAdviceMock = [adviceMock mock];
    self.myAdviceMock.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)commitAdvice{
    
    [self.textAdvice resignFirstResponder];
    [self.textMail resignFirstResponder];
    
    if (![self.textMail.text isEqualToString:@""]) {
        if ([self.textAdvice.text isEqualToString:@"您的意见是我们不断前进的动力"] || self.textAdvice.text == nil || [self.textAdvice.text isEqualToString:@""]) {
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入意见内容"];
        }else{
            adviceParam* param = [adviceParam param];
            UserInfo* myUserInfo = [UserInfo restore];
            param.TOKENID = myUserInfo.tokenID;
            param.opinionContent = self.textAdvice.text;
            param.contactMethod = self.textMail.text;
            [self.myAdviceMock run:param];
        }

    }else{
        if ([self.textAdvice.text isEqualToString:@"您的意见是我们不断前进的动力"] || self.textAdvice.text == nil || [self.textAdvice.text isEqualToString:@""]) {
            [WpCommonFunction showNotifyHUDAtViewCenter:self.view withErrorMessage:@"请输入意见内容" withTextFiled:nil];
        } else {
            adviceParam* param = [adviceParam param];
            UserInfo* myUserInfo = [UserInfo restore];
            param.TOKENID = myUserInfo.tokenID;
            param.opinionContent = self.textAdvice.text;
            param.contactMethod = self.textMail.text;
            [self.myAdviceMock run:param];
        }
    }

}
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate != nil) {
        [WpCommonFunction showNotifyHUDAtViewBottom:appDelegate.window withErrorMessage:@"提交反馈成功"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textAdvice resignFirstResponder];
    [self.textMail resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.textAdvice.text isEqualToString:@"您的意见是我们不断前进的动力"]) {
        self.textAdvice.text = nil;
        self.textAdvice.textColor = [UIColor whiteColor];
    }
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.textAdvice.text.length < 1) {
        self.textAdvice.attributedText = [[NSAttributedString alloc]initWithString:@"您的意见是我们不断前进的动力" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length>199) {
        return NO;
    }
    return YES;
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
