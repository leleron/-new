//
//  ServiceViewController.m
//  Empty
//
//  Created by leron on 15/10/21.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "ServiceViewController.h"
#import "listEntity.h"
#import "ItemListSection.h"
#import "AdviceFeedBackViewController.h"
#import "LoginViewController.h"
#import "MyWebViewController.h"
#import "ProvinceViewController.h"
@interface ServiceViewController ()

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    self.navigationBarTitle =  @"服务反馈";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initQuickUI{
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"ItemListSection"] delegate:self backGroundClr:Color_Bg_cellldarkblue];
    listEntity* e = [listEntity entity];
    e.tag = 0;
    e.title = @"在线客服";
        e.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e.lineBottomColor = Color_Bg_cellldarkblue;
    //    e.LineTopColor = Color_Bg_cellldarkblue;
    [self.pAdaptor.pSources addEntity:e withSection:[ItemListSection class]];
    listEntity* e1 = [listEntity entity];
    e1.tag = 1;
    e1.title = @"服务网点";
    e1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e1.lineBottomColor = Color_Bg_cellldarkblue;
    //    e1.LineTopColor = Color_Bg_cellldarkblue;
    [self.pAdaptor.pSources addEntity:e1 withSection:[ItemListSection class]];
    listEntity* e2 = [listEntity entity];
    e2.tag = 2;
    e2.title = @"意见反馈";
    e2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e2.lineBottomColor = Color_Bg_cellldarkblue;
    //    e2.LineTopColor = Color_Bg_cellldarkblue;
    [self.pAdaptor.pSources addEntity:e2 withSection:[ItemListSection class]];
    [self.pAdaptor notifyChanged];
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    listEntity* e = (listEntity*)entity;
    ItemListSection* s = (ItemListSection*)section;
    s.lblTitle.textColor = [UIColor whiteColor];
//    if (e.tag == 0 || e.tag == 2 || e.tag == 4) {
//        s.backgroundColor = Color_Bg_celllightblue;
//    }else
//        s.backgroundColor = Color_Bg_cellldarkblue;
    s.lblTitle.text = e.title;
    switch (e.tag) {
        case 0:
            s.imgIcon.image = [UIImage imageNamed:@"zxkf"];
            break;
        case 1:
            s.imgIcon.image = [UIImage imageNamed:@"fwwd"];
            break;
        case 2:
            s.imgIcon.image = [UIImage imageNamed:@"shfw"];
            s.imgLine.hidden = YES;
            break;
        default:
            break;
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    UserInfo *myUserInfo = [UserInfo restore];
    listEntity* e = (listEntity*)entity;
    switch (e.tag) {
        case 0:
            if (myUserInfo.tokenID == nil || [myUserInfo.tokenID isEqualToString:@""]) {
                LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                UserInfo* u = [UserInfo restore];
                MyWebViewController* controller = [MyWebViewController controllerWithUrl:[NSString stringWithFormat:@"http://kf2.flyco.net.cn/new/client.php?m=Mobile&arg=admin&tokenId=%@",u.tokenID]];
                controller.navigationBarTitle = @"在线客服";
//                UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//                btnCancel.frame = CGRectMake(0, 0, 100, 30);
//                UIBarButtonItem* item = [UIBarButtonItem init];
//                self.navigationItem setLeftBarButtonItem:[UIBarButtonItem alloc]
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        case 1:
        {
//            MyWebViewController* controller = [MyWebViewController controllerWithUrl:@"http://m.flyco.com/mem_center/index/service"];
//            controller.navigationBarTitle = @"服务网点";
            ProvinceViewController* controller = [[ProvinceViewController alloc]initWithNibName:@"ProvinceViewController" bundle:nil];
            controller.navigationBarTitle = @"服务网点";
            controller.mark = @"netPoint";
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            AdviceFeedBackViewController* controller = [[AdviceFeedBackViewController alloc]initWithNibName:@"AdviceFeedBackViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
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
