//
//  DeviceListsViewController.m
//  Empty
//
//  Created by duye on 15/9/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "AirSearchController.h"
#import "addProductSection.h"
#import "DeviceInfoByMacMock.h"
#import "UserInfo.h"
#import "AirCleanerViewController.h"
#import "FKDeviceCardViewController.h"
#import "ConfigNetViewController.h"
#import "AirCleanerTipViewController.h"
#import "addProductSection.h"
#import "ListTableViewCell.h"
@interface AirSearchController (){
    NSTimer *deviceFindTimer;
    NSTimer *deviceReciveTimer;
    
    AsyncUdpSocket *asyncUdpSocket;
    
    DeviceInfoByMacMock *deviceInfoByMacMock;
    DeviceInfoByMacMockParam *deviceInfoByMacMockParam;
    
    NSMutableArray *tableData;
    
    NSTimer *findDeviceTimer;
    NSTimer *reciveTimer;
    int count;      //计数
    BOOL hasDevice;    //判断有无设备
    UIButton* configNet;
}


@property (weak, nonatomic) IBOutlet QUTableView *tableView;

@end

@implementation AirSearchController

- (void)viewDidLoad {
    self.navigationBarTitle = @"已搜到设备";
    [super viewDidLoad];
    
    count = 0;
    hasDevice = NO;
    asyncUdpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSError *err = nil;
    [asyncUdpSocket enableBroadcast:YES error:&err];
    [asyncUdpSocket bindToPort:1025 error:&err];
    
    
    deviceInfoByMacMock = [DeviceInfoByMacMock mock];
    deviceInfoByMacMock.delegate = self;
    deviceInfoByMacMockParam = [DeviceInfoByMacMockParam param];
    deviceInfoByMacMockParam.sendMethod = @"GET";
    
    tableData = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    if (!findDeviceTimer)
    {
        findDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(findDeviceNearBy) userInfo:nil repeats:YES];
        [findDeviceTimer fire];
    }
    if (!reciveTimer)
    {
        reciveTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(reciveDeviceNearBy) userInfo:nil repeats:YES];
        [reciveTimer fire];
    }
    
//    [self findDeviceNearBy];
//    [self reciveDeviceNearBy];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closeUdpSocket];
}

- (void)closeUdpSocket{
    [[ViewControllerManager sharedManager] hideWaitView];
    if (findDeviceTimer) {
        [findDeviceTimer invalidate];
        findDeviceTimer = nil;
    }
    if (reciveTimer) {
        [reciveTimer invalidate];
        reciveTimer = nil;
    }
    [asyncUdpSocket close];
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[DeviceInfoByMacMock class]]) {
        DeviceInfoByMacEntity *e = (DeviceInfoByMacEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            if (e.deviceDetailList.count != 0) {
                for (NSDictionary* item in e.deviceDetailList) {
                    DeviceInfoByMacListInfoEntity *ee = [DeviceInfoByMacListInfoEntity entity];
                    ee.productCode = [item objectForKey:@"productCode"];
                    ee.deviceId = [item objectForKey:@"deviceId"];
                    ee.deviceName = [item objectForKey:@"deviceName"];
                    ee.macId = [item objectForKey:@"macId"];
                    //判断当前设备是否为正确的型号
                    if ([ee.productCode isEqualToString:_product.productCode]) {
                        if (![self isContainingSameElement:ee]) {
                            [tableData addObject:ee];
                            hasDevice = YES;
                            [[ViewControllerManager sharedManager] hideWaitView];
                            [self.tableView reloadData];
                        }
                    }
                }
                if (configNet) {
                    [configNet removeFromSuperview];
                    configNet = [UIButton buttonWithType:UIButtonTypeCustom];
                    [configNet setTitle:@"添加其他设备" forState:UIControlStateNormal];
                    [WpCommonFunction setView:configNet cornerRadius:8];
                    configNet.frame = CGRectMake((SCREEN_WIDTH - 200)/2, tableData.count*70+100, 200, 50);
                    [configNet setBackgroundColor:Color_Bg_Line];
                    [configNet addTarget:self action:@selector(gotoConfigNet) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:configNet];

                }else{
                    configNet = [UIButton buttonWithType:UIButtonTypeCustom];
                    [configNet setTitle:@"添加其他设备" forState:UIControlStateNormal];
                    [WpCommonFunction setView:configNet cornerRadius:8];
                    configNet.frame = CGRectMake((SCREEN_WIDTH - 200)/2, tableData.count*70+100, 200, 50);
                    [configNet setBackgroundColor:Color_Bg_Line];
                    [configNet addTarget:self action:@selector(gotoConfigNet) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:configNet];
                    
                }
                
            }
        }
    }
    
}

-(void)gotoConfigNet{
    ConfigNetViewController* controller = [[ConfigNetViewController alloc]initWithNibName:@"ConfigNetViewController" bundle:nil];
    controller.productModel = self.product.productModel;
    controller.productCode =  self.product.productCode;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) findDeviceNearBy{
    NSString *str = @"Are You Flyco IOT Smart Device?";
    NSString *host = @"255.255.255.255";
    int port = 1025;
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    [asyncUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
    
}

- (void) reciveDeviceNearBy{
    [asyncUdpSocket receiveWithTimeout:-1 tag:0];
}

//判断数组中是否包含某个元素
- (BOOL) isContainingSameElement:(DeviceInfoByMacListInfoEntity*)entity{
    BOOL returnValue = NO;
    for (DeviceInfoByMacListInfoEntity * ee in tableData) {
        if ([ee.deviceId isEqualToString:entity.deviceId]) {
            returnValue = YES;
        }
    }
    return returnValue;
}


#pragma mark - socket回调
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"发送成功");
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"没发送成功");
    [[ViewControllerManager sharedManager]hideWaitView];
//    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请打开WIFI连接"];
}
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSLog(@"收到数据");
    count++;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"NSDictionary---------%@",jsonDict);
    NSLog(@"NSString--------%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    if (jsonDict) {
        if ([[jsonDict objectForKey:@"machine_type"] isEqualToString:self.product.productCode]) {
            deviceInfoByMacMock.operationType = [NSString stringWithFormat:@"/devices/%@/deviceDetail?tokenId=%@&productCode=%@",[jsonDict objectForKey:@"mac_id"],[UserInfo restore].tokenID,self.product.productCode];
            [deviceInfoByMacMock run:deviceInfoByMacMockParam];
        }
    }
    if (count>50 && !hasDevice ) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"未搜索到设备"];
        [[ViewControllerManager sharedManager]hideWaitView];
        ConfigNetViewController* controller = [[ConfigNetViewController alloc]initWithNibName:@"ConfigNetViewController" bundle:nil];
        controller.productModel = self.product.productModel;
        controller.productCode = self.product.productCode;
        [self.navigationController pushViewController:controller animated:YES];
    }
    return YES;
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"没收到数据");
}
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"断开连接");
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *deviceListsViewcell = @"deviceListsViewcell";
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceListsViewcell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:self options:nil] lastObject];
        [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:deviceListsViewcell];
//        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0/255.f green:46.f/255.f blue:111/255.f alpha:1];
        cell.lblAdd.hidden = NO;
//        if (indexPath.row%2 == 0) {
//            cell.backgroundColor = Color_Bg_celllightblue;
//        }else{
//            cell.backgroundColor = Color_Bg_cellldarkblue;
//            cell.backgroundColor = [UIColor greenColor];
//        }
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.f green:46/255.f blue:111/255.f alpha:1];
    cell.backgroundColor = [UIColor colorWithRed:0/255.f green:46/255.f blue:111/255.f alpha:1];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 25, 50, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"添加";
    label.font = [UIFont systemFontOfSize:14];
    [cell addSubview:label];
    UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightArrow"]];
    imgView.frame = CGRectMake(SCREEN_WIDTH-25, 25, 20, 20);
    [cell addSubview:imgView];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    // Config your cell
    DeviceInfoByMacListInfoEntity *ee = (DeviceInfoByMacListInfoEntity*)[tableData objectAtIndex:indexPath.row];
    cell.imgIcon.image = [UIImage imageNamed:@"airCleaner"];
    cell.lblName.text = ee.deviceName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceInfoByMacListInfoEntity* e = (DeviceInfoByMacListInfoEntity*)[tableData objectAtIndex:indexPath.row];
    
    AirCleanerEntity *ee = [AirCleanerEntity entity];
    ee.deviceId = e.deviceId;
    ee.deviceName = e.deviceName;
    ee.macId = e.macId;
    FKDeviceCardViewController *controller = [[FKDeviceCardViewController alloc] initWithNibName:@"FKDeviceCardViewController" bundle:nil];
    controller.snCode = ee.macId;
    controller.deviceId = ee.deviceId;
//    AirCleanerViewController* controller = [[AirCleanerViewController alloc] initWithNibName:@"AirCleanerViewController" bundle:nil airCleaner:ee];
    
//    controller.hidesBottomBarWhenPushed = YES;
    [WpCommonFunction hideTabBar];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
