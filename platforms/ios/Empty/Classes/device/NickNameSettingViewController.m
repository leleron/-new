//
//  NickNameSettingViewController.m
//  Empty
//
//  Created by 杜晔 on 15/7/7.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#define MAX_TEXT_LENGTH 12

#import "NickNameSettingViewController.h"
#import "updateUserInfoMock.h"
@interface NickNameSettingViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textNickName;
@property(strong,nonatomic)updateUserInfoMock* myMock;
@end

@implementation NickNameSettingViewController

@synthesize mac;

- (void)viewDidLoad {
    self.navigationBarTitle = @"修改昵称";
    [super viewDidLoad];
    [self showRightButtonTitle:@"确认" andSelector:@selector(confrim)];
//    self.textNickName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.oldNickName attributes:@{NSForegroundColorAttributeName: Color_PlaceHolder}];
    self.textNickName.text = self.oldNickName;
    self.textNickName.delegate = self;
    
    [self.textNickName becomeFirstResponder];
    [self.textNickName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)confrim{
    [self.textNickName resignFirstResponder];
    self.myMock = [updateUserInfoMock mock];
    self.myMock.delegate = self;
    updateUserInfoParam* param = [updateUserInfoParam param];
    param.sendMethod = @"PUT";
    param.REAL_NAME = self.textNickName.text;
    if (param.REAL_NAME) {
        [self.myMock run:param];
    }else{
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请输入昵称"];
    }
    [[ViewControllerManager sharedManager]showWaitView:self.view];
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"昵称更新成功"];
    UserInfo* myUserInfo = [UserInfo restore];
    myUserInfo.nickName = self.textNickName.text;
    [myUserInfo store];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateNickName" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.textNickName) {
        if (textField.text.length > MAX_TEXT_LENGTH) {
            textField.text = [textField.text substringToIndex:MAX_TEXT_LENGTH];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.textNickName) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > MAX_TEXT_LENGTH) {
            return NO;
        }
    }
    
    return YES;
//    if (textField.text.length>11 && ![string  isEqual: @""]) {
//        return NO;
//    }
//    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textNickName resignFirstResponder];
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
