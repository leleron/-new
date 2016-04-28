//
//  addProductViewController.m
//  Empty
//  手动添加设备
//  Created by leron on 15/6/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "addProductViewController.h"
#import "addProductSection.h"
#import "ConfigNetViewController.h"
//#import "addController.h"
#import "deviceTypeMock.h"
#import "DeviceAddViewController.h"
#import "KVSearchController.h"
#import "AirSearchController.h"
#import "boothDeviceListViewController.h"
#import "Reachability.h"
@interface addProductViewController ()
@property(strong,nonatomic)deviceTypeMock* myMock;
@property(strong,nonatomic)UIAlertController* alert;
@end

@implementation addProductViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"选择设备";
    [super viewDidLoad];
    self.myMock = [deviceTypeMock mock];
    self.myMock.delegate = self;
    deviceTypeParam* param = [deviceTypeParam param];
    param.sendMethod = @"GET";
    [self.myMock run:param];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)initQuickUI{
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"addProductSection"] delegate:self backGroundClr:Color_Bg_cellldarkblue];
//    QUFlatEntity* e1 = [QUFlatEntity entity];
//    e1.lineBottomColor = QU_FLAT_COLOR_LINE;
//    e1.tag = 0;
//    [self.pAdaptor.pSources addEntity:e1 withSection:[addProductSection class]];
//    QUFlatEntity* e2 = [QUFlatEntity entity];
//    e2.lineBottomColor = QU_FLAT_COLOR_LINE;
//    e2.tag = 1;
//    [self.pAdaptor.pSources addEntity:e2 withSection:[addProductSection class]];
//    QUFlatEntity* e3 = [QUFlatEntity entity];
//    e3.lineBottomColor = QU_FLAT_COLOR_LINE;
//    e3.tag = 2;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
   BOOL result = [WpCommonFunction checkWIFI];
    if (result == NO) {
        self.alert = [UIAlertController alertControllerWithTitle:@"没有连接Wi-Fi" message:@"请先连接Wi-Fi" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            [self.alert dismissViewControllerAnimated:YES completion:nil];
        }];
        //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [self.alert addAction:cancelAction];
        //        [self.alert addAction:okAction];
        [self presentViewController:self.alert animated:YES completion:^{
            
            //            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        NSLog(@"no wifi");
    }

}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    
    deviceTypeEntity* e = (deviceTypeEntity*)entity;
    if ([e.status isEqualToString:RESULT_SUCCESS]) {
        int i = 0;
        for (NSDictionary* item in e.result) {
            deviceListInfoEntity* ee = [deviceListInfoEntity entity];
            ee.productCode = [item objectForKey:@"productCode"];
            ee.productModel = [item objectForKey:@"productModel"];
            ee.productName = [item objectForKey:@"productName"];
            
            ee.tag = i;
            i++;
            ee.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.pAdaptor.pSources addEntity:ee withSection:[addProductSection class]];
        }
    }
    [self.pAdaptor notifyChanged];
    
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    if ([entity isKindOfClass:[deviceListInfoEntity class]]) {
        deviceListInfoEntity* e = (deviceListInfoEntity*)entity;
        addProductSection* s = (addProductSection*)section;
        s.lblProductionName.text = e.productName;
        if ([e.productCode isEqualToString:@"9001"]) {
            s.imgIcon.image = [UIImage imageNamed:@"9001"];
        }
//        if ([e.productCode hasPrefix:@"96"]) {
//            s.imgIcon.image = [UIImage imageNamed:@"9605"];
//        }
//        if ([e.productCode isEqualToString:@"shaver"]) {
//            s.imgProduction.image = [UIImage imageNamed:@"tixudao"];
//        }
        if ([e.productCode isEqualToString:@"9605"]) {
            s.imgIcon.image = [UIImage imageNamed:@"9605"];
        }
        if ([e.productCode isEqualToString:@"9606"]) {
            s.imgIcon.image = [UIImage imageNamed:@"9606"];
        }
        if ([e.productCode isEqualToString:@"9002"]) {
            s.imgLine.hidden = YES;
            s.imgIcon.image = [UIImage imageNamed:@"9002"];
        }
            s.backgroundColor = Color_Bg_celllightblue;
//        if (e.tag%2 == 0) {
//            s.backgroundColor = Color_Bg_celllightblue;
//        }else
//            s.backgroundColor = Color_Bg_cellldarkblue;
        
        
        s.line_bottom.hidden = YES;
//        if (e.tag == 0) {
//            s.lblProductionName.text = @"扫地机器人";
//            s.imgProduction.image = [UIImage imageNamed:@"kv8"];
//        }
//        if (e.tag == 1) {
//            s.lblProductionName.text = @"空气净化器";
//            s.imgProduction.image = [UIImage imageNamed:@"tixudao"];
//        }
//        if (e.tag == 2) {
//            s.lblProductionName.text = @"蓝牙秤";
//            s.imgProduction.image = [UIImage imageNamed:@"chen"];
//        }
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    deviceListInfoEntity* e = (deviceListInfoEntity*)entity;
    if ([e.productCode isEqualToString:@"9605"]) {//扫地机器人的配网画面
        KVSearchController* controller = [[KVSearchController alloc]init];
        controller.productType = e.productCode;
        controller.productModel = e.productModel;
        [self.navigationController pushViewController:controller animated:YES];
    } else if([e.productCode isEqualToString:@"9001"] || [e.productCode isEqualToString:@"9002"]){//扫地机器人以外的设备的配网画面
        AirSearchController *deviceListsViewController = [[AirSearchController alloc] initWithNibName:@"AirSearchController" bundle:nil];
        deviceListsViewController.product = e;
        [self.navigationController pushViewController:deviceListsViewController animated:YES];
    }else if ([e.productCode isEqualToString:@"7008"]){
        boothDeviceListViewController* controller = [[boothDeviceListViewController alloc]initWithNibName:@"boothDeviceListViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
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
