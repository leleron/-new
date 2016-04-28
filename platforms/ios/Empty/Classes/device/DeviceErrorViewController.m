//
//  DeviceErrorViewController.m
//  Empty
//
//  Created by leron on 15/9/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "DeviceErrorViewController.h"
#import "errorMessageMock.h"
@interface DeviceErrorViewController ()
@property(strong,nonatomic)errorMessageMock* myErrorMock;    //错误mock

@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextView *lblReason;

@end

@implementation DeviceErrorViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"常见故障";
    [super viewDidLoad];
    
    if (self.errorCode) {
        self.lblCode.text = self.errorCode;
        self.lblName.text = self.errorName;
        self.lblReason.text = self.errorDescription;
    }else{
        self.myErrorMock = [errorMessageMock mock];
        self.myErrorMock.delegate = self;
        errorMessageParam* param = [errorMessageParam param];
        UserInfo* u = [UserInfo restore];
        param.TOKENID = u.tokenID;
        param.FAILURECODE = [NSString stringWithFormat:@"%ld",(long)self.error];
        self.myErrorMock.operationType = [NSString stringWithFormat:@"/devices/%@/returnRobotFailure",self.deviceId];
        [[ViewControllerManager sharedManager]showWaitView:self.view];
        [self.myErrorMock run:param];
    }
    
    // Do any additional setup after loading the view from its nib.
}


-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    
    if ([mock isKindOfClass:[errorMessageMock class]]) {
        errorMessageEntity* e = (errorMessageEntity*)entity;
        errorMessageListEntity* ee = [errorMessageListEntity entity];
//        ee.description = [e.Failure objectForKey:@"description"];
        ee.failureName = [e.Failure objectForKey:@"failureName"];
        ee.failurePhenomenon = [e.Failure objectForKey:@"failurePhenomenon"];
        ee.failureFix = [e.Failure objectForKey:@"failureFix"];
        ee.failureCode = [e.Failure objectForKey:@"failureCode"];
        self.lblCode.text = ee.failureCode;
        self.lblName.text = ee.failureName;
        self.lblReason.text = ee.failurePhenomenon;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
