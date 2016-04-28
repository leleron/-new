//
//  MessageVertifyViewController.m
//  Empty
//
//  Created by leron on 15/8/3.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MessageVertifyViewController.h"
#import "getCodeMock.h"
#import "identifyCodeMock.h"
#import "SetNewPswViewController.h"
@interface MessageVertifyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property(assign,nonatomic)NSInteger counter;
@property(strong,nonatomic)NSString* phone;
@property(strong,nonatomic)getCodeMock* myCodeMock;
@property(strong,nonatomic)getCodeParam* myCodeParam;
@property(strong,nonatomic)identifyCodeMock* myIdentifyCodeMock;
@property(strong,nonatomic)identifyCodeParam* myIndentifyCodeParam;

@end

@implementation MessageVertifyViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"验证手机号";
    [super viewDidLoad];
    [self.btnGetCode addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNext addTarget:self action:@selector(gotoNext) forControlEvents:UIControlEventTouchUpInside];
    [WpCommonFunction setView:self.btnNext cornerRadius:8];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initQuickMock{
    self.myCodeMock = [getCodeMock mock];
    self.myCodeMock.delegate = self;
    self.myCodeParam = [getCodeParam param];
    self.myCodeParam.sendMethod = @"GET";
    self.myIdentifyCodeMock = [identifyCodeMock mock];
    self.myIdentifyCodeMock.delegate = self;
    self.myIndentifyCodeParam = [identifyCodeParam param];
}


-(void)getCode{
    self.counter = 60;
    self.phone = self.phoneStr;
    self.myCodeMock.operationType = [NSString stringWithFormat:@"/user/check/%@",self.phone];
    [self.myCodeMock run:self.myCodeParam];
    self.btnGetCode.enabled = NO;
    [self.btnGetCode setBackgroundImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [self.btnGetCode setTitleColor:[UIColor colorWithRed:148/255.f green:148/255.5 blue:148/255.f alpha:1.0] forState:UIControlStateNormal];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:YES];
    [self.btnGetCode setTitle:@"发送中" forState:UIControlStateNormal];
    
}

-(void)showTime:(NSTimer*)time{
    if (self.counter == 0) {
        [time invalidate];
        [self.btnGetCode setTitle:@"重新获取" forState:UIControlStateNormal];
        //        [self.btnGetCode setBackgroundImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
        [self.btnGetCode setBackgroundColor:Color_Bg_celllightblue];
        self.btnGetCode.enabled = YES;
    }else{
        self.counter--;
        self.btnGetCode.titleLabel.text = [NSString stringWithFormat:@"%ld秒",(long)self.counter];
        [self.btnGetCode setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.counter] forState:UIControlStateDisabled];
        
    }
}


-(void)gotoNext{
    [self.phoneNum resignFirstResponder];
    self.myIndentifyCodeParam.MOBILE = self.phoneStr;
    self.myIndentifyCodeParam.IDENTIFY_CODE = self.phoneNum.text;
    [self.myIdentifyCodeMock run:self.myIndentifyCodeParam];
}
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getCodeMock class]]) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:YES];
    }
    
    if ([mock isKindOfClass:[identifyCodeMock class]]) {
        identifyEntity* e = (identifyEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            SetNewPswViewController* controller = [[SetNewPswViewController alloc]initWithNibName:@"SetNewPswViewController" bundle:nil];
            controller.phoneStr = self.phoneStr;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:e.message];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneNum resignFirstResponder];
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
