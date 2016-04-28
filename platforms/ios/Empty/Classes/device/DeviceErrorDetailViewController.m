//
//  DeviceErrorDetailViewController.m
//  Empty
//
//  Created by duye on 15/9/25.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "DeviceErrorDetailViewController.h"


@interface DeviceErrorDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *failureCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceMsgTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceMsgContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *failureTimeLabel;

@end

@implementation DeviceErrorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _failureCodeLabel.text = _deviceErrorListInfoEntity.failureCode;
    _deviceMsgTitleLabel.text = _deviceErrorListInfoEntity.deviceMsgTitle;
    _deviceMsgContentLabel.text = _deviceErrorListInfoEntity.deviceMsgContent;
    _failureTimeLabel.text = _deviceErrorListInfoEntity.failureTime;
    // Do any additional setup after loading the view from its nib.
}

@end
