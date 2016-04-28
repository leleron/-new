//
//  addDevice.m
//  Empty
//
//  Created by leron on 15/7/30.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "addDevice.h"
#import "SYQRCodeViewController.h"
#import "addProductViewController.h"
@interface addDevice(){
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnHand;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;

@end
@implementation addDevice

-(void)awakeFromNib{
    self.frame = CGRectMake(0, -200, SCREEN_WIDTH, 160);
    if (iPhone5) {
        self.frame = CGRectMake(0, -200, SCREEN_WIDTH, 160);
    }
    [self.btnHand addTarget:self action:@selector(gotoHand) forControlEvents:UIControlEventTouchUpInside];
    [self.btnScan addTarget:self action:@selector(gotoScan) forControlEvents:UIControlEventTouchUpInside];
}
-(void)gotoScan{
    SYQRCodeViewController* controller = [[SYQRCodeViewController alloc]init];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [WpCommonFunction hideTabBar];
    [delegate.topController.navigationController pushViewController:controller animated:YES];
}
-(void)gotoHand{
    addProductViewController* controller = [[addProductViewController alloc]initWithNibName:@"addProductViewController" bundle:nil];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [WpCommonFunction hideTabBar];
    [delegate.topController.navigationController pushViewController:controller animated:YES];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
