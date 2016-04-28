//
//  TryDeviceViewController.m
//  Empty
//
//  Created by leron on 15/9/17.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "TryDeviceViewController.h"
#import "FKManageDeviceViewController.h"
#import "FKSetTimeViewController.h"
@interface TryDeviceViewController ()
{
    UIButton *optionButton;      //菜单键
    UIButton *redpot;
    NSTimer *timer; // 控制红点
    NSTimer *moveTimer; //自动移动定时
    NSTimer *chargeTimer;  //回充定时
    CGRect originFrame;   //原始位置
    CGRect changedFrame;  //改变后的位置

}
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnCamUp;
@property (weak, nonatomic) IBOutlet UIButton *btnCamDown;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnAuto;
@property (weak, nonatomic) IBOutlet UIButton *btnLocal;
@property (weak, nonatomic) IBOutlet UIButton *btnAppoint;
@property (weak, nonatomic) IBOutlet UIButton *btnRecharge;
@property (weak, nonatomic) IBOutlet UIButton *btnDef;


@property (assign,nonatomic) int upCount;
@property (assign,nonatomic) int downCount;
@property (assign,nonatomic) int leftCount;
@property (assign,nonatomic) int RightCount;
@property (assign,nonatomic) int camUpCount;
@property (assign,nonatomic) int camDownCount;


@property  (nonatomic,assign) BOOL isRecordOn;
@property  (nonatomic,assign) BOOL isAutoClean;
@property  (nonatomic,assign) BOOL isRecharge;
@property  (nonatomic,assign) BOOL isPowerON;
@property  (nonatomic,assign) int  count;
@property  (nonatomic,assign) int  upWidthDistance;
@property  (nonatomic,assign) int  upHeightDistance;
@property  (nonatomic,assign) int  xDistance;
@property  (nonatomic,assign) int  yDistance;
@end

@implementation TryDeviceViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"扫地机器人";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.upCount = 1;
    self.downCount = 0;
    self.leftCount = 1;
    self.RightCount = 1;
    self.camDownCount = 0;
    self.camUpCount = 1;
    self.isAutoClean = NO;
    self.isRecharge = NO;
    self.isPowerON = YES;
    self.count = 0;

    
    
    [self.btnUp addTarget:self action:@selector(Up) forControlEvents:UIControlEventTouchDown];
    [self.btnUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnDown addTarget:self action:@selector(Down) forControlEvents:UIControlEventTouchDown];
    [self.btnDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnLeft addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchDown];
    [self.btnLeft addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLeft addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.btnRight addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchDown];
    [self.btnRight addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.btnCamUp addTarget:self action:@selector(camUp) forControlEvents:UIControlEventTouchDown];
    [self.btnCamUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamUp addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnCamDown addTarget:self action:@selector(CamDown) forControlEvents:UIControlEventTouchDown];
    [self.btnCamDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamDown addTarget:self action:@selector(mystop) forControlEvents:UIControlEventTouchUpOutside];
    [self.btnPhoto addTarget:self action:@selector(take_pic) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCamera addTarget:self action:@selector(myRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAppoint addTarget:self action:@selector(yuyue) forControlEvents:UIControlEventTouchUpInside];

//        [self.imgVideo addConstraint:[NSLayoutConstraint
//                                      constraintWithItem:self.imgVideo
//                                      attribute:NSLayoutAttributeHeight
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:self.imgVideo
//                                      attribute:NSLayoutAttributeWidth
//                                      multiplier:0.5f
//                                      constant:0]];
    

    [self.btnAuto addTarget:self action:@selector(autoClean) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnDef addTarget:self action:@selector(ChangeResolution) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecharge addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLocal addTarget:self action:@selector(local) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnPhoto setImage:[UIImage imageNamed:@"photo_camera_selected"] forState:UIControlStateSelected];
    
    [self.btnPause addTarget:self action:@selector(power) forControlEvents:UIControlEventTouchUpInside];
    
    optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    optionButton.frame = CGRectMake(30, 0, 38, 37);
    [optionButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    [optionButton addTarget:self action:@selector(myEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:optionButton];
    
    redpot = [[UIButton alloc] initWithFrame:CGRectMake(40, 24, 15, 15)];
    redpot.hidden = YES;
    [redpot setBackgroundImage:IMAGE(@"red dot-rec") forState:UIControlStateNormal];
    [self.view addSubview:redpot];
    
    
//    if (iPhone4 || iPad12mini || iPad34Air) {
//        for (NSLayoutConstraint *aspectConstraint in self.imgVideo.constraints) {
//            if ([aspectConstraint.identifier isEqualToString:@"WidthHeight"]) {
//                [self.imgVideo removeConstraint:aspectConstraint];
//            }
//        }
//        [self.imgVideo addConstraint:[NSLayoutConstraint
//                                      constraintWithItem:self.imgVideo
//                                      attribute:NSLayoutAttributeHeight
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:self.imgVideo
//                                      attribute:NSLayoutAttributeWidth
//                                      multiplier:0.3f
//                                      constant:0]];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.imgVideo.hidden = NO;
    if (iPhone4 || iPad12mini || iPad34Air) {
        for (NSLayoutConstraint *aspectConstraint in self.imgVideo.constraints) {
            if ([aspectConstraint.identifier isEqualToString:@"WidthHeight"]) {
                NSLayoutConstraint* newOne = [NSLayoutConstraint constraintWithItem:self.imgVideo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imgVideo attribute:NSLayoutAttributeWidth multiplier:0.45 constant:0];
                [self.imgVideo removeConstraint:aspectConstraint];
                [self.imgVideo addConstraint:newOne];
                //                [self.imgVideo removeConstraint:aspectConstraint];
                
            }
        }
    }
    
}

-(void)autoClean{
    
    self.isAutoClean = !self.isAutoClean;
    if (chargeTimer.isValid) {
        [chargeTimer invalidate];
    }
    if (self.isAutoClean && self.isPowerON) {
        moveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(move) userInfo:nil repeats:YES];
        [self.btnPause setImage:[UIImage imageNamed:@"PLAY default"] forState:UIControlStateNormal];
    }else{
        [self.btnPause setImage:[UIImage imageNamed:@"deviceon"] forState:UIControlStateNormal];
        [moveTimer invalidate];
    }
    
}

-(void)local{
    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"试用设备暂不支持该功能演示"];
}

-(void)move{
    srand((unsigned)time(0));
    int mark = arc4random() %6;
    NSLog(@"%d",mark);
    switch (mark) {
        case 0:
            [self left];
            break;
        case 1:
            [self right];
            break;
        case 2:
            [self Up];
            break;
        case 3:
            [self Down];
            break;
        case 4:
            [self CamDown];
            break;
        case 5:
            [self camUp];
            break;
        default:
            break;
    }
    self.count++;
}


-(void)power{
    
    if (self.isAutoClean || self.isRecharge) {
        [self.btnPause setImage:[UIImage imageNamed:@"deviceon"] forState:UIControlStateNormal];
        [moveTimer invalidate];
        [chargeTimer invalidate];
        self.isAutoClean = NO;
        self.isRecharge = NO;
    }else{
    self.isPowerON = !self.isPowerON;
    if (self.isPowerON) {
        [self.btnPause setImage:[UIImage imageNamed:@"deviceon"] forState:UIControlStateNormal];
        self.btnAppoint.enabled = YES;
        self.btnAuto.enabled = YES;
        self.btnCamDown.enabled = YES;
        self.btnCamera.enabled = YES;
        self.btnCamUp.enabled = YES;
        self.btnDef.enabled = YES;
        self.btnDown.enabled = YES;
        self.btnLeft.enabled = YES;
        self.btnLocal.enabled = YES;
        self.btnPause.enabled = YES;
        self.btnPhoto.enabled = YES;
        self.btnRecharge.enabled = YES;
        self.btnRight.enabled = YES;
        self.btnUp.enabled = YES;
        [self.btnLocal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnAuto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnAppoint setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnRecharge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        [chargeTimer invalidate];
        [moveTimer invalidate];
        self.btnAppoint.enabled = NO;
        self.btnAuto.enabled = NO;
        self.btnCamDown.enabled = NO;
        self.btnCamera.enabled = NO;
        self.btnCamUp.enabled = NO;
        self.btnDef.enabled = NO;
        self.btnDown.enabled = NO;
        self.btnLeft.enabled = NO;
        self.btnLocal.enabled = NO;
        self.btnPhoto.enabled = NO;
        self.btnRecharge.enabled = NO;
        self.btnRight.enabled = NO;
        self.btnUp.enabled = NO;
        
        [self.btnLocal setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnAuto setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnAppoint setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnRecharge setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnPause setImage:[UIImage imageNamed:@"deviceoff"] forState:UIControlStateNormal];
        }
    }
}

-(void)ChangeResolution{
    if ([self.btnDef.titleLabel.text isEqualToString:@"高清"]) {
        [self.btnDef setTitle:@"标清" forState:UIControlStateNormal];
    }
    if ([self.btnDef.titleLabel.text isEqualToString:@"标清"]) {
        [self.btnDef setTitle:@"高清" forState:UIControlStateNormal];
    }
}

-(void)recharge{
    
    if (moveTimer.isValid) {
        [moveTimer invalidate];
    }
    self.isRecharge = !self.isRecharge;
    if (self.isRecharge && self.isPowerON) {
        chargeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(move) userInfo:nil repeats:YES];
        [self.btnPause setImage:[UIImage imageNamed:@"PLAY default"] forState:UIControlStateNormal];
    }else{
        [self.btnPause setImage:[UIImage imageNamed:@"deviceon"] forState:UIControlStateNormal];
        [chargeTimer invalidate];
    }
}

-(void)myEdit{
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.camDID = @"";
    FKManageDeviceViewController* controller = [[FKManageDeviceViewController alloc]initWithNibName:@"FKManageDeviceViewController" bundle:nil];
//    controller.userType = self.cam.userType;
//    controller.deviceId = self.cam.nsDeviceId;
    controller.cam = nil;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)take_pic
{
    UIImage* img = [self captureCurrentView:self.imgVideo];
    [self saveImageToPhotos:img];
    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"拍照成功"];
}


-(void)myRecord:(UIButton *)sender{
    
    self.isRecordOn = !self.isRecordOn;
    if (self.isRecordOn) {
        timer = [NSTimer  scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(shine) userInfo:nil repeats:YES];
        [self.btnCamera setImage:[UIImage imageNamed:@"video_camera_selected"] forState:UIControlStateNormal];
    }else{
        [timer invalidate];
        redpot.hidden = YES;
        [self.btnCamera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    }

}

-(void)shine
{
    redpot.hidden = !redpot.hidden;
}



-(UIImage *)captureCurrentView :(UIView *)view{
    
    
    CGRect frame = view.frame;
    
    UIGraphicsBeginImageContext(frame.size);
    
    CGContextRef contextRef =UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:contextRef];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *saveImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage,CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH/3*2))];
    
    return saveImage;
    
}

-(void)saveImageToPhotos:(UIImage *)image{
    
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg =@"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    originFrame = self.imgVideo.frame;
}

-(void)yuyue{
    FKSetTimeViewController* controller = [[FKSetTimeViewController alloc]initWithNibName:@"FKSetTimeViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}



-(void)camUp{
         CABasicAnimation *anima=[CABasicAnimation animation];
    
         //1.1告诉系统要执行什么样的动画
    const int movementDistance = 20; // tweak as needed
    
    const float movementDuration = 1.0f; // tweak as needed
//    int movement = (up ? -movementDistance : movementDistance);
    
    if (self.camUpCount>0) {
        [UIView beginAnimations: @"anima" context: nil];
        
        [UIView setAnimationBeginsFromCurrentState: YES];
        
        [UIView setAnimationDuration: movementDuration];
        
        self.imgVideo.frame = CGRectOffset(self.imgVideo.frame, 0, movementDistance);

        [UIView commitAnimations];
        self.camUpCount = self.camUpCount - 1;
        self.camDownCount = self.camDownCount + 1;
    }
    
    

}


-(void)CamDown{
    const int movementDistance = 20; // tweak as needed
    
    const float movementDuration = 1.0f; // tweak as needed
    //    int movement = (up ? -movementDistance : movementDistance);
    
    
    if (self.camDownCount>0) {
        [UIView beginAnimations: @"anima" context: nil];
        
        [UIView setAnimationBeginsFromCurrentState: YES];
        
        [UIView setAnimationDuration: movementDuration];
        
        self.imgVideo.frame = CGRectOffset(self.imgVideo.frame, 0, -movementDistance);
        [UIView commitAnimations];
        self.camDownCount = self.camDownCount - 1;
        self.camUpCount = self.camUpCount + 1;
    }


}

-(void)Up{
    
    const int movementDistance = 50; // tweak as needed
    
    const float movementDuration = 1.0f; // tweak as needed
    //    int movement = (up ? -movementDistance : movementDistance);

    if (self.upCount>0) {
        [UIView beginAnimations: @"anima" context: nil];
        
        [UIView setAnimationBeginsFromCurrentState: YES];
        
        [UIView setAnimationDuration: movementDuration];
        
        self.upWidthDistance = self.imgVideo.frame.size.width*0.2;
        self.upHeightDistance = self.imgVideo.frame.size.height*0.2;
        CGRect newFrame = CGRectMake(self.imgVideo.frame.origin.x, self.imgVideo.frame.origin.y, self.imgVideo.frame.size.width*1.2, self.imgVideo.frame.size.height*1.2);
        self.imgVideo.frame = CGRectOffset(newFrame, -0.1*newFrame.size.width, -0.1*newFrame.size.height);
        changedFrame = self.imgVideo.frame;
        self.xDistance = newFrame.size.width*0.1;
        self.yDistance = newFrame.size.height*0.1;
        [UIView commitAnimations];
        self.upCount = self.upCount - 1;
        self.downCount = self.downCount + 1;
    }


}

-(void)Down{
    const int movementDistance = 50; // tweak as needed
    
    const float movementDuration = 1.0f; // tweak as needed
    //    int movement = (up ? -movementDistance : movementDistance);
    
    if (self.downCount>0) {
        [UIView beginAnimations: @"anima" context: nil];
        
        [UIView setAnimationBeginsFromCurrentState: YES];
        
        [UIView setAnimationDuration: movementDuration];
        
//        CGRect newFrame = CGRectMake(self.imgVideo.frame.origin.x, self.imgVideo.frame.origin.y, self.imgVideo.frame.size.width-self.upWidthDistance, self.imgVideo.frame.size.height-self.upHeightDistance);
        
//        self.imgVideo.frame = CGRectOffset(newFrame, self.xDistance, self.yDistance);
        self.imgVideo.frame = originFrame;
        [UIView commitAnimations];
        self.upCount = 1;
        self.downCount = 0;
        self.leftCount = 1;
        self.RightCount = 1;
        self.camDownCount = 0;
        self.camUpCount = 1;
    }

}

-(void)mystop{
    
}

-(void)right{
    const int movementDistance = 50; // tweak as needed
    
    const float movementDuration = 1.0f; // tweak as needed
    //    int movement = (up ? -movementDistance : movementDistance);
    
    if (self.RightCount>0) {
        [UIView beginAnimations: @"anima" context: nil];
        
        [UIView setAnimationBeginsFromCurrentState: YES];
        
        [UIView setAnimationDuration: movementDuration];
        
        self.imgVideo.frame = CGRectOffset(self.imgVideo.frame, -movementDistance, 0);

        [UIView commitAnimations];
        self.RightCount = self.RightCount - 1;
        self.leftCount = self.leftCount + 1;
    }

}

-(void)left{
    const int movementDistance = 50; // tweak as needed
    
    const float movementDuration = 1.0f; // tweak as needed
    //    int movement = (up ? -movementDistance : movementDistance);
    
    if (self.leftCount>0) {
        [UIView beginAnimations: @"anima" context: nil];
        
        [UIView setAnimationBeginsFromCurrentState: YES];
        
        [UIView setAnimationDuration: movementDuration];
        
        self.imgVideo.frame = CGRectOffset(self.imgVideo.frame, movementDistance, 0);

        [UIView commitAnimations];
        self.leftCount = self.leftCount - 1;
        self.RightCount = self.RightCount + 1;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    self.imgVideo.hidden = YES;
    [moveTimer invalidate];
    [chargeTimer invalidate];
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
