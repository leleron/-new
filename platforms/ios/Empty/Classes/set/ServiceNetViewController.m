//
//  ServiceNetViewController.m
//  Empty
//
//  Created by leron on 15/10/27.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "ServiceNetViewController.h"
#import "serviceNetMock.h"
#import "ServiceNetTableViewCell.h"
#import "cityEntity.h"
#import "serviceProvinceMock.h"
@interface ServiceNetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)servicePointMock* myMock;
@property(strong,nonatomic)NSArray* dataSource;
@property(assign,nonatomic)int count;
//@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ServiceNetViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"服务网点";
    [super viewDidLoad];
    self.pTableView.separatorStyle = NO;
    self.pAdaptor = [QUAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"ServiceNetTableViewCell"] delegate:self];
//    self.myTableView.dataSource = self;
//    self.myTableView.delegate = self;
//    self.myTableView.separatorStyle = NO;
    self.dataSource = [[NSArray alloc]init];
    self.myMock = [servicePointMock mock];
    self.myMock.delegate = self;
    serviceNetParam* param = [serviceNetParam param];
    param.service_code = self.provinceCode;
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [self.myMock run:param];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    servicePointEntity* e = (servicePointEntity*)entity;
    self.dataSource = [e.DATA objectForKey:@"service_detail"];
    self.count = self.dataSource.count;
    int i = 0;
    for (NSDictionary* item in self.dataSource) {
        cityEntity* e = [cityEntity entity];
        e.dict = item;
        e.tag = i;
        i++;
//        e.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.pAdaptor.pSources addEntity:e withSection:[ServiceNetTableViewCell class]];
    }
    [self.pAdaptor notifyChanged];
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    ServiceNetTableViewCell* cell = (ServiceNetTableViewCell*)section;
    cityEntity* e = (cityEntity*)entity;
    NSDictionary* dict = e.dict;
    cell.lblName.text = [dict objectForKey:@"service_name"];
    cell.lblAddress.text = [NSString stringWithFormat:@"地址:%@",[dict objectForKey:@"service_address"]];
    cell.lblPhone.text = [NSString stringWithFormat:@"服务电话:%@",[dict objectForKey:@"service_telephone"]];
    if (e.tag == self.count-1) {
        cell.imgLine.hidden = YES;
    }else{
        cell.imgLine.hidden = NO;
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
        cityEntity* e = (cityEntity*)entity;
        NSDictionary* dict = e.dict;
       [WpCommonFunction CallPhone:[dict objectForKey:@"service_telephone"]];
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//        return self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString* cellid = @"cellid";
//    ServiceNetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    if (!cell) {
//        //        cell = [[[NSBundle mainBundle] loadNibNamed:@"deviceListSection" owner:self options:nil] lastObject];
////        cell = [[ServiceNetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellid];
//        cell = [QUNibHelper loadNibNamed:@"ServiceNetTableViewCell" ofClass:[ServiceNetTableViewCell class]];
////        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = Color_Bg_celllightblue;
////        if (indexPath.row%2 == 0) {
////            cell.backgroundColor = Color_Bg_celllightblue;
////        }else{
////            cell.backgroundColor = Color_Bg_cellldarkblue;
////            //            cell.backgroundColor = [UIColor greenColor];
////        }
//    }
//    NSDictionary* dict = [self.dataSource objectAtIndex:indexPath.row];
//    cell.lblName.text = [dict objectForKey:@"branchName"];
//    cell.lblAddress.text = [dict objectForKey:@"branchLocation"];
//    cell.lblPhone.text = [dict objectForKey:@"contactNumber"];
//    return cell;
//    
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 90.0f;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary* dict = [self.dataSource objectAtIndex:indexPath.row];
//    [WpCommonFunction CallPhone:[dict objectForKey:@"contactNumber"]];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
