//
//  boothDeviceListViewController.m
//  Empty
//
//  Created by leron on 15/12/29.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "boothDeviceListViewController.h"
#import "BTDeviceViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ListTableViewCell.h"
#import "addDeviceMock.h"
@interface boothDeviceListViewController ()<UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (nonatomic, strong) CBCentralManager *manager;//本地中央
@property (nonatomic, strong) CBPeripheral *peripheral;//标示当前连接的外围
@property (nonatomic, strong) CBService *service;//当前连接的外围需要的服务
//@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;//写数据的特征

@property (nonatomic, strong) NSMutableArray *nDataSource;//搜索到外围设备
@property (nonatomic, strong) NSArray *nServices;//外围的所有服务
@property (nonatomic, strong) NSArray *nCharacteristics;//选中服务的所有特征

@property (nonatomic, assign) BOOL bluetoothConnectStatus;//当前蓝牙连接的状态，YES为连接，NO为没有连接

@property(strong,nonatomic)addDeviceMock* myAddMock;
@property(strong,nonatomic)addDeviceParam* myAddParam;

@end

@implementation boothDeviceListViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"附近的蓝牙设备";
    [super viewDidLoad];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.nDataSource = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scanForBluetooth];

}

-(void)initQuickMock{
    self.myAddMock = [addDeviceMock mock];
    self.myAddMock.delegate = self;
    _myAddParam = [addDeviceParam param];
    UserInfo* myUserInfo = [UserInfo restore];
    _myAddParam.TOKENID = myUserInfo.tokenID;
//    addparam.NICKNAME = camObj.nsDID;
    _myAddParam.GROUP = @"1";
    _myAddParam.LATITUDE = @"121.406586";
    _myAddParam.LONGITUDE = @"31.204065";
//    addparam.MACADDRESS = self.macId;
//    addparam.SN = self.macId;
    
    _myAddParam.PRODUCTCODE = @"7008";

}
#pragma mark Bluetooth
- (void)scanForBluetooth {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.manager scanForPeripheralsWithServices:nil options:dic];
    
}

- (void)stopScanForBluetooth {
    [self.manager stopScan];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"Central Manager state CBCentralManagerStateUnknown");
            self.bluetoothConnectStatus = NO;
            self.peripheral = nil;
            self.nDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"Central Manager state CBCentralManagerStateUnsupported");
            self.bluetoothConnectStatus = NO;
            self.peripheral = nil;
            self.nDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"Central Manager state CBCentralManagerStateUnauthorized");
            self.bluetoothConnectStatus = NO;
            self.peripheral = nil;
            self.nDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"Central Manager state CBCentralManagerStateResetting");
            self.bluetoothConnectStatus = NO;
            self.peripheral = nil;
            self.nDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"Central Manager state CBCentralManagerStatePoweredOff");
            self.bluetoothConnectStatus = NO;
            self.peripheral = nil;
            self.nDataSource = nil;
            //            [self.devicesUpdateSignal sendNext:self.nDataSource];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            break;
        default:
            NSLog(@"Central Manager default");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
//    NSLog(@"self.nDataSource.count %lu", (unsigned long)self.nDataSource.count);
//    NSLog(@"didDiscoverPeripheral %@", peripheral);
    BOOL isContained = NO;
    for (CBPeripheral *cbPeripheral in self.nDataSource) {
        if (cbPeripheral == peripheral) {
            isContained = YES;
        }
    }
    
    if (!isContained && [peripheral.name hasPrefix:@"FLYCO"]) {
        [self.nDataSource addObject:peripheral];
        [self.myTableView reloadData];
    }
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected to peripheral %@", peripheral);
    self.bluetoothConnectStatus = YES;
    [self.manager stopScan];
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
}


- (void)peripheral:(CBPeripheral *)aPeripheral
didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"service count : %lu", (unsigned long)aPeripheral.services.count);
    self.nServices = aPeripheral.services;
    for (CBService *service in aPeripheral.services) {
        // Discovers the characteristics for a given service
            self.service = service;
            NSLog(@"Service found with UUID: %@", service.UUID);
            [self.peripheral discoverCharacteristics:nil
                                          forService:service];
    }
    //    NSLog(@"%d",self.peripheral.isConnected?1:0);
    BTDeviceViewController *deviceView = [[BTDeviceViewController alloc] initWithPeripheral:self.peripheral];
    [self.navigationController pushViewController:deviceView animated:true];
}


#pragma mark tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellid = @"cellid";
    ListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    CBPeripheral *device =[self.nDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    cell.backgroundColor = Color_Bg_cellldarkblue;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([device.name isEqualToString:@""]) {
        cell.textLabel.text = @"未知设备";
    }
//    if (indexPath.row == self.nDataSource.count-1) {
//        cell.mark = @"tt";
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *device =[self.nDataSource objectAtIndex:indexPath.row];
    self.peripheral = device;
    NSString* mac = [device.identifier.UUIDString substringFromIndex:24];
    _myAddParam.MACADDRESS = mac;
    _myAddParam.SN = mac;
    _myAddParam.NICKNAME = device.name;
    [self.myAddMock run:self.myAddParam];
//    [self.manager connectPeripheral:device options:nil];
}


-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[QUMock class]]) {
        DeviceAddEntity* e = (DeviceAddEntity*)entity;
        [self.navigationController popToRootViewControllerAnimated:YES];
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
