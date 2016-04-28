//
//  VcodeViewController.m
//  KV8
//
//  Created by RJONE on 15/6/16.
//  Copyright (c) 2015年 MasKSJ. All rights reserved.
//

#import "VcodeViewController.h"
#import "VideoController.h"
#import "EditDeviceController.h"
#import "WToast.h"
@interface VcodeViewController ()

{
    UITextField *vCode;
}

@end
VcodeViewController *instance1 ;

@implementation VcodeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    instance1 = self;
    
    self.view.backgroundColor = BLUECOLOR;
    self.title = @"视频加密";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 26.43);
    [backButton setImage:[UIImage imageWithContentsOfFile:PATH(@"back_no")] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 25, 25.78);
    [saveButton setImage:[UIImage imageWithContentsOfFile:PATH(@"save_no")] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(mySave) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
    vCode= [[UITextField alloc] initWithFrame:CGRectMake(50, 40, 180, 40)];
    vCode.placeholder = @"test_encrpt";
    vCode.backgroundColor = [UIColor whiteColor];
    vCode.text = @"test_encrpt";
    vCode.layer.cornerRadius = 8;
    vCode.delegate = self;
    
    [self.view addSubview:vCode];
    
    if (iOSVERSION >= 7.0)
    {
        vCode.frame = CGRectMake(vCode.frame.origin.x, vCode.frame.origin.y +ADJSTHEIGHT, vCode.frame.size.width, vCode.frame.size.height);
    }

}


-(void)mySave
{
    if ([vCode.text isEqualToString:@"test_encrpt"])
    {
        _cam.isVcode = YES;
        [WToast showWithText:@"解密成功"];
        
    }
    else
    {
        [WToast showWithText:@"解密失败,请核对密码"];
       _cam.isVcode = NO;
    }
}
-(void)myBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+(VcodeViewController *)share
{
    return instance1;
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    if (textField == _passwordField && SCREEN_HEIGHT == 480)
    //    {
    //        [UIView beginAnimations:nil context:nil];
    //        [UIView setAnimationDuration:0.25];
    //        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-70);
    //        [UIView commitAnimations];
    //    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (SCREEN_HEIGHT == 480) {
    //        if (iOSVERSION <7.0) {
    //            self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-32);
    //            return;
    //        }
    //        [UIView beginAnimations:nil context:nil];
    //        [UIView setAnimationDuration:0.25];
    //        self.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    //        [UIView commitAnimations];
    //    }
    [textField resignFirstResponder];
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
