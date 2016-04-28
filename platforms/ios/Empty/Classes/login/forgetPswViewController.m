//
//  forgetPswViewController.m
//  Empty
//
//  Created by leron on 15/6/15.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "forgetPswViewController.h"
#import "fogetPswMock.h"
#import "getCodeMock.h"
@interface forgetPswViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textVertifyCode;
@property (weak, nonatomic) IBOutlet UITextField *textPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong,nonatomic)getCodeMock* myGetCodeMock;
@property(assign,nonatomic)NSInteger counter;
@end

@implementation forgetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnGetCode addTarget:self action:@selector(gotoGetCode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSubmit addTarget:self action:@selector(gotoSubmit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoGetCode{
    self.counter = 60;
    self.myGetCodeMock = [getCodeMock mock];
    self.myGetCodeMock.delegate = self;
    self.myGetCodeMock.operationType = [NSString stringWithFormat:@"/user/check/{%@}",self.textPhoneNum.text];
    getCodeParam* param = [getCodeParam param];
//    param.sendMethod = @"GET";
    [self.myGetCodeMock run:param];
    self.btnGetCode.enabled = NO;
    [self.btnGetCode setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [self.btnGetCode setTitleColor:[UIColor colorWithRed:148/255.f green:148/255.5 blue:148/255.f alpha:1.0] forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:YES];

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

-(void)gotoSubmit{
    
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getCodeMock class]]) {
        getCodeEntity* e = (getCodeEntity*)entity;
    }
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
