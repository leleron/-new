//
//  CityViewController.m
//  Empty
//
//  Created by leron on 15/10/20.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "CityViewController.h"
#import "getCityMock.h"
#import "getCityPmMock.h"
#import "AirCleanerViewController.h"
#import "ListTableViewCell.h"
#import "addProductSection.h"
#import "cityEntity.h"
@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(strong,nonatomic)NSArray* CityArray;
@property(strong,nonatomic)NSString* selectedCity;
@property(strong,nonatomic)NSString* selectedCityCode;
@property(strong,nonatomic)getCityMock* cityMock;
@property(strong,nonatomic)getCityPmMock* pmMock;
@property(assign,nonatomic)int count;
@end

@implementation CityViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"选择城市";
    [super viewDidLoad];
//    self.myTableView.delegate = self;
//    self.myTableView.dataSource = self;
//    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.pTableView.separatorStyle = NO;
    self.pAdaptor = [QUAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"addProductSection"] delegate:self];
    // Do any additional setup after loading the view from its nib.
}
-(void)initQuickMock{
    self.cityMock = [getCityMock mock];
    self.cityMock.delegate = self;
    QUMockParam* param = [QUMockParam param];
    param.sendMethod = @"GET";
    self.cityMock.operationType = [NSString stringWithFormat:@"/devices/find/getCities?provinceCode=%@",self.code];
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [self.cityMock run:param];
    self.pmMock = [getCityPmMock mock];
    self.pmMock.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getCityMock class]]) {
    cityEntity* city = (cityEntity*)entity;
    self.CityArray = city.cities;
//    [self.myTableView reloadData];
         self.count = 0;
        for (NSDictionary* item in self.CityArray) {
//            c* e = [cityEntity entity];
            cityObject* object = [[cityObject alloc]init];
//            e.cities = item;
            object.cityName = [item objectForKey:@"cityName"];
            object.cityCode = [item objectForKey:@"cityCode"];
            object.tag = _count;
            _count++;
            object.accessoryType = UITableViewCellAccessoryNone;
            [self.pAdaptor.pSources addEntity:object withSection:[dateSelectSection class]];
        }
        [self.pAdaptor notifyChanged];
    }
    if ([mock isKindOfClass:[getCityPmMock class]]) {
        getCityPMEntity* e = (getCityPMEntity*)entity;
        for (MyViewController* child in self.navigationController.childViewControllers) {
            if ([child isKindOfClass:[AirCleanerViewController class]]) {
                AirCleanerViewController* controller = (AirCleanerViewController*)child;
                controller.PM = e.PM25;
                controller.City = self.selectedCity;
                controller.cityCode = self.selectedCityCode;
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    dateSelectSection* s = (dateSelectSection*)section;
    cityObject* e = (cityObject*)entity;
    s.lblDate.text = e.cityName;
    if (e.tag == self.count-1) {
        s.imgLine.hidden = YES;
    }else{
        s.imgLine.hidden = NO;
    }
//    if ([e.cities isEqualToString:@"辽宁省"]) {
//        s.imgLine.hidden = YES;
//    }else{
//        s.imgLine.hidden = NO;
//    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    cityObject* e = (cityObject*)entity;
        NSString* cityName = e.cityName;
        self.selectedCity = cityName;
    self.selectedCityCode = e.cityCode;
        self.pmMock.operationType = [NSString stringWithFormat:@"/devices/find/getCityPm25?cityCode=%@&deviceId=%@",e.cityCode,self.deviceId];
        QUMockParam* param = [QUMockParam param];
        param.sendMethod = @"GET";
        [self.pmMock run:param];

    
}



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.CityArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *cellid = @"cellid";
//    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    if (!cell) {
//        //        cell = [[[NSBundle mainBundle] loadNibNamed:@"deviceListSection" owner:self options:nil] lastObject];
//        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellid];
//        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
////        if (indexPath.row%2 == 0) {
//            cell.backgroundColor = Color_Bg_celllightblue;
////        }else{
////            cell.backgroundColor = Color_Bg_cellldarkblue;
////            //            cell.backgroundColor = [UIColor greenColor];
////        }
//    }
//    NSString* item = [self.CityArray objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = item;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50.0f;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString* cityName = [self.CityArray objectAtIndex:indexPath.row];
//    self.selectedCity = cityName;
//    self.pmMock.operationType = [NSString stringWithFormat:@"/devices/find/getCityPm25?cityName=%@&deviceId=%@",cityName,self.deviceId];
//    QUMockParam* param = [QUMockParam param];
//    param.sendMethod = @"GET";
//    [self.pmMock run:param];
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
