//
//  FKDeviceStatusViewController.m
//  Empty
//
//  Created by leron on 15/8/28.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKDeviceStatusViewController.h"
#import "deleteDeviceMock.h"
#import "deviceOnlineMock.h"
#import "deleteSecondaryMock.h"
#import "ListTableViewCell.h"
#import "DeviceErrorListCell.h"
@interface FKDeviceStatusViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceType;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceUserNum;
@property (weak, nonatomic) IBOutlet UIImageView *deviceLogo;

@property (weak, nonatomic) IBOutlet UIButton *btnDeleteDevice;
@property(strong,nonatomic)deleteDeviceMock* myMock;
@property(strong,nonatomic)deviceOnlineMock* myOnlineMock;
@property(strong,nonatomic)deleteSecondaryMock* myDeleteMock;
@property(strong,nonatomic)NSMutableArray* myUserList;
@property (weak, nonatomic) IBOutlet UITableView *userListTable;
@property (assign,nonatomic)BOOL canEditTable;
@end

@implementation FKDeviceStatusViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"设备管理";
    [super viewDidLoad];
    [self.btnDeleteDevice addTarget:self action:@selector(deleteDevice) forControlEvents:UIControlEventTouchUpInside];
    self.userListTable.delegate = self;
    self.userListTable.dataSource = self;
//    self.userListTable.separatorColor = [UIColor clearColor];
    self.userListTable.separatorStyle = NO;
    
    if ([self.userType isEqualToString:@"secondary"]) {
        self.canEditTable = NO;
    }else{
        self.canEditTable = YES;
    }
    
    [self setExtraCellLineHidden:self.userListTable];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    deviceOnlineParam* param = [deviceOnlineParam param];
    param.sendMethod = @"GET";
    UserInfo* myUserInfo = [UserInfo restore];
    if (self.cam) {
        self.myOnlineMock.operationType = [NSString stringWithFormat:@"/devices/%@/owners?tokenId=%@",self.cam.nsDeviceId,myUserInfo.tokenID];
        self.lblDeviceName.text = self.cam.nsCamName;
        self.lblDeviceType.text = self.cam.deviceType;
    } else {
        self.myOnlineMock.operationType = [NSString stringWithFormat:@"/devices/%@/owners?tokenId=%@",self.cleaner.deviceId,myUserInfo.tokenID];
        self.lblDeviceName.text = self.cleaner.deviceName;
        self.lblDeviceType.text = self.cleaner.deviceType;
    }
    
    [self.myOnlineMock run:param];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initQuickMock{
    self.myUserList = [[NSMutableArray alloc]init];
    self.myOnlineMock = [deviceOnlineMock mock];
    self.myOnlineMock.delegate = self;
    self.myDeleteMock = [deleteSecondaryMock mock];
    self.myDeleteMock.delegate = self;
    
}
-(void)deleteDevice{
    self.myMock = [deleteDeviceMock mock];
    self.myMock.delegate = self;
    deleteDeviceParam* param = [deleteDeviceParam param];
    UserInfo* myUserInfo = [UserInfo restore];
    param.TOKENID = myUserInfo.tokenID;
    if (self.cam) {
        self.myMock.operationType = [NSString stringWithFormat:@"/devices/%@/delete",self.cam.nsDeviceId];

    } else {
        self.myMock.operationType = [NSString stringWithFormat:@"/devices/%@/delete",self.cleaner.deviceId];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除设备" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Delete device cancelled.");
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"Delete device confirmed.");
        [[ViewControllerManager sharedManager]showWaitView:self.view];
        [self.myMock run:param];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[deleteDeviceMock class]])
    {
        identifyEntity* e = (identifyEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            NSLog(@"删除成功");
            [self.cam Rjone_DevReset];   //恢复出厂设置
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if ([mock isKindOfClass:[deviceOnlineMock class]]) {
        userOnlineEntity* e = (userOnlineEntity*)entity;
        for (NSDictionary* item in e.deviceOwners) {
            userOnlineListEntity* ee = [userOnlineListEntity entity];
            ee.userType = [item objectForKey:@"userType"];
            ee.userName = [item objectForKey:@"userName"];
            ee.userId = [item objectForKey:@"userId"];
            ee.nickName = [item objectForKey:@"nickName"];
//            if ([ee.userType isEqualToString:@"secondary"]) {
                [self.myUserList addObject:ee];
//            }
        }
        NSMutableArray* temp = [NSMutableArray arrayWithArray:self.myUserList];
        for (userOnlineListEntity* item in temp) {
            if ([item.userType isEqualToString:@"primary"]) {
                [self.myUserList removeObject:item];
                [self.myUserList insertObject:item atIndex:0];
            }
        }
//       self.myUserList = [[self.myUserList reverseObjectEnumerator] allObjects];  //翻转顺序
        [self.userListTable reloadData];
        self.lblDeviceUserNum.text = [NSString stringWithFormat:@"有%lu人正在连接",(unsigned long)self.myUserList.count];
        if ([self.lblDeviceType.text hasPrefix:@"FP90"]) {
            self.deviceLogo.image = [UIImage imageNamed:@"airCleaner"];
        }
        if ([self.lblDeviceType.text isEqualToString:@"FC9605"]) {
            self.deviceLogo.image = [UIImage imageNamed:@"9605"];
        }
        if ([self.lblDeviceType.text isEqualToString:@"FC9606"]) {
            self.deviceLogo.image = [UIImage imageNamed:@"9606"];
        }
        
    }
    if ([mock isKindOfClass:[deleteSecondaryMock class]]) {
        self.lblDeviceUserNum.text = [NSString stringWithFormat:@"有%lu人正在连接",(unsigned long)(self.myUserList.count)];

    }
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myUserList.count == 0) {
        tableView.editing = NO;
    }
    return self.myUserList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid";
//    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    if (!cell) {
//        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellid];
    DeviceErrorListCell *cell = (DeviceErrorListCell*)[[[NSBundle mainBundle] loadNibNamed:@"DeviceErrorListCell" owner:self options:nil]lastObject];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = Color_Bg_celllightblue;
//    }
    if ([self.userType isEqualToString:@"primary"]){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == self.myUserList.count -1) {
        cell.mark = @"tt";
    }
    cell.redPotView.hidden = YES;
    userOnlineListEntity* e = [self.myUserList objectAtIndex:indexPath.row];
//    cell.textLabel.text = e.userName;
    cell.titleView.text = e.userName;
    cell.titleView.font = [UIFont fontWithName:@"Helvetica" size:17];
//    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView = backView;
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.canEditTable) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"主控不可删除"];
    }else{
        
    deleteSecondaryParam* param = [deleteSecondaryParam param];
    UserInfo* u = [UserInfo restore];
    param.TOKENID = u.tokenID;
    userOnlineListEntity* e = [self.myUserList objectAtIndex:indexPath.row];
    param.USER_ID = e.userId;
    if (self.cam) {
        self.myDeleteMock.operationType = [NSString stringWithFormat:@"/devices/%@/deleteSecondary",self.cam.nsDeviceId];
    } else {
        self.myDeleteMock.operationType = [NSString stringWithFormat:@"/devices/%@/deleteSecondary",self.cleaner.deviceId];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除该副控" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Delete secondary cancelled.");
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"Delete secondary confirmed.");
        [self.myDeleteMock run:param];
        [self.myUserList removeObjectAtIndex:indexPath.row];
        [self.userListTable reloadData];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
        
    
        
    }
}



- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor redColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
