//
//  ProvinceViewController.m
//  Empty
//
//  Created by leron on 15/10/20.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "ProvinceViewController.h"
#import "getProvinceMock.h"
#import "CityViewController.h"
#import "ServiceNetViewController.h"
#import "ListTableViewCell.h"
#import "addProductSection.h"
#import "cityEntity.h"
#import "serviceProvinceMock.h"
@interface ProvinceViewController ()<UITableViewDataSource,UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(strong,nonatomic)getProvinceMock* provinceWeatherMock;
@property(strong,nonatomic)NSArray* ProvinceArray;
@property(strong,nonatomic)serviceProvinceMock* provinceMock;
@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"选择省份";
    [super viewDidLoad];
    self.pTableView.separatorStyle = NO;
    self.pAdaptor = [QUAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"addProductSection"] delegate:self];
    if ([self.mark isEqualToString:@"netPoint"]) {
        servicePorovinceParam* param = [servicePorovinceParam param];
        [[ViewControllerManager sharedManager]showWaitView:self.view];
        [self.provinceMock run:param];
    }else{
        QUMockParam* param = [QUMockParam param];
        param.sendMethod = @"GET";
        [self.provinceWeatherMock run:param];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)initQuickMock{
    self.provinceWeatherMock = [getProvinceMock mock];
    self.provinceWeatherMock.delegate = self;
    self.provinceMock = [serviceProvinceMock mock];
    self.provinceMock.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getProvinceMock class]]) {
        getProvinceEntity* e = (getProvinceEntity*)entity;
        self.ProvinceArray = e.allProvices;
        for (NSDictionary* item in self.ProvinceArray) {
            cityEntity* e = [cityEntity entity];
            e.dict = item;
            e.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.pAdaptor.pSources addEntity:e withSection:[dateSelectSection class]];
        }
    }
    if ([mock isKindOfClass:[serviceProvinceMock class]]) {
        serviceNetEntity* e = (serviceNetEntity*)entity;
        for (NSDictionary* item in e.DATA) {
            cityInfoEntity* city = [cityInfoEntity entity];
            city.service_area = [item objectForKey:@"service_area"];
            city.service_code = [item objectForKey:@"service_code"];
            city.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.pAdaptor.pSources addEntity:city withSection:[dateSelectSection class]];
        }
    }
    [self.pAdaptor notifyChanged];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.ProvinceArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *cellid = @"cellid";
//    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    if (!cell) {
////        cell = [[[NSBundle mainBundle] loadNibNamed:@"deviceListSection" owner:self options:nil] lastObject];
//        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellid];
//        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = Color_Bg_celllightblue;
//    }
//    NSDictionary* item = [self.ProvinceArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [item objectForKey:@"provice"];
//    return cell;
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50.0f;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary* dict = [self.ProvinceArray objectAtIndex:indexPath.row];
//    if ([self.mark isEqualToString:@"netPoint"]) {
//        ServiceNetViewController* controller = [[ServiceNetViewController alloc]initWithNibName:@"ServiceNetViewController" bundle:nil];
//        controller.provinceCode = [dict objectForKey:@"code"];
//        [self.navigationController pushViewController:controller animated:YES];
//    }else{
//    CityViewController* controller = [[CityViewController alloc]initWithNibName:@"CityViewController" bundle:nil];
//    controller.code = [dict objectForKey:@"code"];
//    controller.deviceId = self.deviceId;
//    [self.navigationController pushViewController:controller animated:YES];
//    }
//}
-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    if ([entity isKindOfClass:[cityInfoEntity class]]) {
        dateSelectSection* s = (dateSelectSection*)section;
        cityInfoEntity* e = (cityInfoEntity*)entity;
        s.lblDate.text = e.service_area;
    }else{
    dateSelectSection* s = (dateSelectSection*)section;
    cityEntity* e = (cityEntity*)entity;
    s.lblDate.text = [e.dict objectForKey:@"provice"];
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
        if ([self.mark isEqualToString:@"netPoint"]) {
            cityInfoEntity* e = (cityInfoEntity*)entity;
            ServiceNetViewController* controller = [[ServiceNetViewController alloc]initWithNibName:@"ServiceNetViewController" bundle:nil];
            controller.provinceCode = e.service_code;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            cityEntity* e = (cityEntity*)entity;
            NSDictionary* dict = e.dict;
        CityViewController* controller = [[CityViewController alloc]initWithNibName:@"CityViewController" bundle:nil];
        controller.code = [dict objectForKey:@"code"];
        controller.deviceId = self.deviceId;
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
