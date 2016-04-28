//
//  AirCleanerTipViewController.m
//  Empty
//
//  Created by leron on 15/10/19.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "AirCleanerTipViewController.h"
#import <ImageIO/ImageIO.h>
#import "ConfigNetViewController.h"
#import "FKConnectNetViewController.h"
@interface AirCleanerTipViewController ()
{
}
@property (weak, nonatomic) IBOutlet UIImageView *gifTip;
@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIImageView *imgHint;

@end

@implementation AirCleanerTipViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"连接设备";
    [super viewDidLoad];
    self.btnNo.hidden = YES;
    self.btnYes.hidden = YES;
    [self.btnNo addTarget:self action:@selector(lightNo) forControlEvents:UIControlEventTouchUpInside];
    [self.btnYes addTarget:self action:@selector(lightYes) forControlEvents:UIControlEventTouchUpInside];
    [self showGif:@"anigif"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)lightNo{
    [self showGif:@"anigif"];
    self.imgHint.image = [UIImage imageNamed:@"hint1"];
//    NSLayoutConstraint* layOutHeight = [NSLayoutConstraint con];
    for (NSLayoutConstraint* item in self.imgHint.constraints) {
        if (item.firstAttribute == NSLayoutAttributeHeight) {
            item.constant = 100;
        }
    }
    if (iPhone4) {
        for (NSLayoutConstraint* item in self.imgHint.constraints) {
            if ([item.identifier isEqualToString:@"hintHeight"]) {
                item.constant = 70;
            }
        }
    }
    self.btnNo.hidden = YES;
    self.btnYes.hidden = YES;
    self.btnFinish.hidden = NO;
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    if (iPhone4) {
        for (NSLayoutConstraint* item in self.imgHint.constraints) {
            if ([item.identifier isEqualToString:@"hintHeight"]) {
                item.constant = 70;
            }
        }
    }
}
-(void)lightYes{
    FKConnectNetViewController* controller = [[FKConnectNetViewController alloc]initWithNibName:@"FKConnectNetViewController" bundle:nil];
    controller.wifiName = self.wifiName;
    controller.psw = self.psw;
    controller.sn = self.sn;
    controller.macId = self.macId;
    controller.model = self.model;
    controller.vendor = self.vendor;
    controller.productCode = self.productCode;
    controller.productModel = self.productModel;    //产品型号
    controller.isChongzhi = self.isChongzhi;
    [self.navigationController pushViewController:controller animated:YES];

}
-(void)showGif:(NSString*)name{
    NSString *imagePath =[[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    CGImageSourceRef  cImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:imagePath], NULL);
    
    
    size_t imageCount = CGImageSourceGetCount(cImageSource);
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:imageCount];
    
    float totalTime = 0;
    for (size_t i = 0; i < imageCount; i++) {
        CGImageRef cgimage= CGImageSourceCreateImageAtIndex(cImageSource, i, NULL);
        [images addObject:(__bridge id)cgimage];
        CGImageRelease(cgimage);
        
        NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(cImageSource, i, NULL);
        NSDictionary *gifProperties = [properties valueForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        NSString *gifDelayTime = [gifProperties valueForKey:(__bridge NSString* )kCGImagePropertyGIFDelayTime];
        [times addObject:gifDelayTime];
        totalTime += [gifDelayTime floatValue];
        
        //        _size.width = [[properties valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        //        _size.height = [[properties valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
    }
    
    float currentTime = 0;
    for (size_t i = 0; i < times.count; i++) {
        float keyTime = currentTime / totalTime;
        [keyTimes addObject:[NSNumber numberWithFloat:keyTime]];
        currentTime += [[times objectAtIndex:i] floatValue];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setValues:images];
    [animation setKeyTimes:keyTimes];
    animation.duration = totalTime;
    animation.repeatCount = HUGE_VALF;
    [self.gifTip.layer addAnimation:animation forKey:@"gifAnimation"];

}
- (IBAction)Pressed:(id)sender {
    [self showGif:@"configNet_gif@2x"];
    self.imgHint.image = [UIImage imageNamed:@"hint2"];
    for (NSLayoutConstraint* item in self.imgHint.constraints) {
        if (item.firstAttribute == NSLayoutAttributeHeight) {
            item.constant = 70;
        }
    }
    self.btnYes.hidden = NO;
    self.btnNo.hidden = NO;
    self.btnFinish.hidden = YES;
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
