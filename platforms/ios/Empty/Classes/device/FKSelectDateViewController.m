//
//  FKSelectDateViewController.m
//  Empty
//
//  Created by leron on 15/8/21.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKSelectDateViewController.h"
#import "addProductSection.h"
#import "VideoController.h"
@interface FKSelectDateViewController ()

@end

@implementation FKSelectDateViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"设置预约时间";
    [super viewDidLoad];
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"addProductSection"] delegate:self backGroundClr:Color_Bg_cellldarkblue];
    for (int i = 0; i<7; i++) {
        QUFlatEntity* e1 = [QUFlatEntity entity];
        e1.tag = i;
        [self.pAdaptor.pSources addEntity:e1 withSection:[dateSelectSection class]];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    QUFlatEntity* e = (QUFlatEntity*)entity;
    dateSelectSection* s = (dateSelectSection*)section;
    switch (e.tag) {
        case 0:
            s.lblDate.text = @"星期一";
            
            for (NSString* date in self.dateArray) {
                if ([date isEqualToString:@"星期一"]) {
                    s.imgYes.hidden = NO;
                }
            }
            break;
        case 1:
            s.lblDate.text = @"星期二";
            for (NSString* date in self.dateArray) {
                if ([date isEqualToString:@"星期二"]) {
                    s.imgYes.hidden = NO;
                }
            }
            break;
        case 2:
            s.lblDate.text = @"星期三";
            for (NSString* date in self.dateArray) {
                if ([date isEqualToString:@"星期三"]) {
                    s.imgYes.hidden = NO;
                }
            }
            break;
        case 3:
            s.lblDate.text = @"星期四";
            for (NSString* date in self.dateArray) {
                if ([date isEqualToString:@"星期四"]) {
                    s.imgYes.hidden = NO;
                }
            }
            break;
        case 4:
            s.lblDate.text = @"星期五";
            for (NSString* date in self.dateArray) {
                if ([date isEqualToString:@"星期五"]) {
                    s.imgYes.hidden = NO;
                }
            }
            break;
        case 5:
            s.lblDate.text = @"星期六";
            for (NSString* date in self.dateArray) {
                if ([date isEqualToString:@"星期六"]) {
                    s.imgYes.hidden = NO;
                }
            }
            break;
        case 6:
            s.lblDate.text = @"星期日";
            for (NSString* date in self.dateArray) {
                if ([date isEqualToString:@"星期日"]) {
                    s.imgYes.hidden = NO;
                    s.imgLine.hidden = YES;
                }
            }
            break;
        default:
            break;
    }
//    if (e.tag % 2 == 0) {
//        s.backgroundColor = Color_Bg_Nav;
//    }
    
    
    
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    dateSelectSection* s = (dateSelectSection*)section;
    VideoController* controller;
    for (MyViewController* item in self.navigationController.childViewControllers) {
        if ([item isMemberOfClass:[VideoController class]]) {
             controller = (VideoController*)item;
        }
    }
    if (s.imgYes.isHidden) {
        s.imgYes.hidden = NO;
        [controller.dateArray addObject:s.lblDate.text];
        
    }else{
        s.imgYes.hidden = YES;
        [controller.dateArray removeObject:s.lblDate.text];
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
