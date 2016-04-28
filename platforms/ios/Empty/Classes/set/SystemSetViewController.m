//
//  SystemSetViewController.m
//  Empty
//
//  Created by leron on 15/7/30.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "SystemSetViewController.h"
#import "ItemListSection.h"
#import "listEntity.h"
#import "AboutViewController.h"
#import "AdviceFeedBackViewController.h"
#import "UpdateVersionViewController.h"
#import "rateEntity.h"
#import "rateMock.h"
@interface SystemSetViewController ()
@property (strong, nonatomic) rateMock *myRateMock;
@property (strong, nonatomic) UISwitch *messageSwitch;
@end

@implementation SystemSetViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"系统设置";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initQuickMock {
    self.myRateMock = [rateMock mock];
    self.myRateMock.delegate = self;
}
-(void)initQuickUI{
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"ItemListSection"] delegate:self backGroundClr:Color_Bg_cellldarkblue];
//    listEntity* e = [listEntity entity];
//    e.tag = 0;
//    e.title = @"消息提醒";
////    e.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    e.lineBottomColor = Color_Bg_cellldarkblue;
////    e.LineTopColor = Color_Bg_cellldarkblue;
//    [self.pAdaptor.pSources addEntity:e withSection:[ItemListSection class]];
//    listEntity* e1 = [listEntity entity];
//    e1.tag = 1;
//    e1.title = @"意见与反馈";
//    e1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    e1.lineBottomColor = Color_Bg_cellldarkblue;
////    e1.LineTopColor = Color_Bg_cellldarkblue;
//    [self.pAdaptor.pSources addEntity:e1 withSection:[ItemListSection class]];
    listEntity* e2 = [listEntity entity];
    e2.tag = 2;
    e2.title = @"检查新版本";
    e2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e2.lineBottomColor = Color_Bg_cellldarkblue;
//    e2.LineTopColor = Color_Bg_cellldarkblue;
    [self.pAdaptor.pSources addEntity:e2 withSection:[ItemListSection class]];
    listEntity* e3 = [listEntity entity];
    e3.tag = 3;
    e3.title = @"关于";
    e3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e3.lineBottomColor = Color_Bg_cellldarkblue;
//    e3.LineTopColor = Color_Bg_cellldarkblue;
    [self.pAdaptor.pSources addEntity:e3 withSection:[ItemListSection class]];
//    listEntity* e4 = [listEntity entity];
//    e4.tag = 4;
//    e4.title = @"给我们评分";
//    e4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    e4.lineBottomColor = Color_Bg_cellldarkblue;
////    e4.LineTopColor = Color_Bg_cellldarkblue;
//    [self.pAdaptor.pSources addEntity:e4 withSection:[ItemListSection class]];
    [self.pAdaptor notifyChanged];
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    listEntity* e = (listEntity*)entity;
    ItemListSection* s = (ItemListSection*)section;
    s.lblTitle.textColor = [UIColor whiteColor];
//    if (e.tag == 0 || e.tag == 3) {
//        s.backgroundColor = Color_Bg_celllightblue;
//    }else
//        s.backgroundColor = Color_Bg_cellldarkblue;
    s.lblTitle.text = e.title;
    switch (e.tag) {
        case 0:
//            s.imgIcon.image = [UIImage imageNamed:@"xxtx"];
            break;
        case 1:
//            s.imgIcon.image = [UIImage imageNamed:@"shfw"];
            break;
        case 2:
            s.imgIcon.image = [UIImage imageNamed:@"jcxbb"];
            break;
        case 3:
            s.imgIcon.image = [UIImage imageNamed:@"gy"];
            s.imgLine.hidden = YES;
            break;
        default:
            break;
    }
//    if (e.tag == 0) {
//        self.messageSwitch = [[UISwitch alloc]init];
//        [self.messageSwitch setFrame:CGRectMake(SCREEN_WIDTH - 70, 10, self.messageSwitch.frame.size.width, self.messageSwitch.frame.size.height)];
//        [s addSubview:self.messageSwitch];
//        [self.messageSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    }
}

- (void)switchAction:(id)sender {
    
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    listEntity* e = (listEntity*)entity;
    if (e.tag == 1) {
//        AdviceFeedBackViewController* controller = [[AdviceFeedBackViewController alloc]initWithNibName:@"AdviceFeedBackViewController" bundle:nil];
//        [self.navigationController pushViewController:controller animated:YES];
    }
    if (e.tag == 3) {
        AboutViewController* controller = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (e.tag == 2) {
        UpdateVersionViewController* controller = [[UpdateVersionViewController alloc]initWithNibName:@"UpdateVersionViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (e.tag == 4) {
        [self goToRateAPP];
    }
}

#pragma mark - Jump To App Store Rate
- (void)goToRateAPP {
    rateParam *param = [rateParam param];
    param.sendMethod = @"GET";
    [self.myRateMock run:param];
    [[ViewControllerManager sharedManager]showWaitView:self.view];
}

- (void)QUMock:(QUMock *)mock entity:(QUEntity *)entity {
    if ([mock isKindOfClass:[rateMock class]]) {
        rateEntity *e = (rateEntity *)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            NSURL *url = [NSURL URLWithString:e.iosUpdateUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
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
