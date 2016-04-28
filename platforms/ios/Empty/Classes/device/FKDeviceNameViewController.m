//
//  FKDeviceNameViewController.m
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKDeviceNameViewController.h"
#import "FKDeviceNameMock.h"
#import "identifyEntity.h"
#import "VideoController.h"
#import "AirCleanerViewController.h"

#define MAX_TEXT_LENGTH 15

@interface FKDeviceNameViewController ()
@property(strong,nonatomic)FKDeviceNameMock* myMock;
@property (weak, nonatomic) IBOutlet UITextField *textNickName;

@end

@implementation FKDeviceNameViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"修改设备昵称";
    [super viewDidLoad];
    [self showRightButtonTitle:@"确认" andSelector:@selector(confrim)];
//    UIColor *color = [UIColor whiteColor];
//    self.textNickName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.deviceNick attributes:@{NSForegroundColorAttributeName: color}];
    self.textNickName.delegate = self;
    self.textNickName.text = self.deviceNick;
    if (self.deviceNick == nil || [self.deviceNick isEqualToString:@""]) {
        self.textNickName.text = self.cam.nsCamName;
    }
    [self.textNickName becomeFirstResponder];
    [self.textNickName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)confrim{
    [self.textNickName resignFirstResponder];
    self.myMock = [FKDeviceNameMock mock];
    self.myMock.delegate = self;
    FKDeviceNameParam* param = [FKDeviceNameParam param];
    param.sendMethod = @"PUT";
    UserInfo* myUserInfo = [UserInfo restore];
    param.TOKENID = myUserInfo.tokenID;
    param.nickName = self.textNickName.text;
    self.myMock.operationType = [NSString stringWithFormat:@"/devices/%@/updateDevice",self.deviceId];
    [self.myMock run:param];
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    identifyEntity* e = (identifyEntity*)entity;
    [WpCommonFunction showNotifyHUDAtViewBottom:[[ViewControllerManager sharedManager] currentController1].view withErrorMessage:e.message];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateDeviceName" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
    for (MyViewController* lastViewController in self.navigationController.childViewControllers) {
        if ([lastViewController isMemberOfClass:[VideoController class]]) {
            VideoController* controller = (VideoController*)lastViewController;
            controller.deviceName = self.textNickName.text;
        }
        if ([lastViewController isMemberOfClass:[AirCleanerViewController class]]) {
            AirCleanerViewController* controller = (AirCleanerViewController*)lastViewController;
            controller.cleaner.deviceName = self.textNickName.text;
        }
    }
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
