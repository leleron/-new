//
//  lvwangViewController.m
//  Empty
//
//  Created by leron on 15/12/2.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "lvwangViewController.h"
#import "FilterCell.h"
#import "ACfilteroneswitchMock.h"
#import "ACfiltertwoswitchMock.h"
#import "AirCleanerMock.h"
@interface lvwangViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //滤网1
    ACfilteroneswitchParam* acfilteroneswitchParam;
    //滤网2
    ACfiltertwoswitchParam* acfiltertwoswitchParam;

    AirCleanerParam* airCleanerParam;
}
@property(strong,nonatomic)ACfilteroneswitchMock *acfilteroneswitchMock;
@property(strong,nonatomic)ACfiltertwoswitchMock *acfiltertwoswitchMock;
@property(strong,nonatomic)AirCleanerMock* airCleanerMock;


@property (weak, nonatomic) IBOutlet UITableView *lvwangTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@end

@implementation lvwangViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"滤网设置";
    [super viewDidLoad];
    self.lvwangTableView.dataSource = self;
    self.lvwangTableView.delegate = self;
    self.lvwangTableView.allowsSelection = NO;
    [self.lvwangTableView setSeparatorStyle:NO];
    [self.lvwangTableView setEditing:NO];
    [self.btnReset addTarget:self action:@selector(filterResetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self showLeftNormalButton:@"go_back" highLightImage:@"go_back" selector:@selector(toBack)];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [WpCommonFunction hideTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toBack{
    if ([self.lvwangTableView isEditing]) {
        self.lvwangTableView.editing = NO;
        [self.btnReset setTitle:@"重置滤网" forState:UIControlStateNormal];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)initQuickMock{
    UserInfo* user = [UserInfo restore];
    _acfilteroneswitchMock = [ACfilteroneswitchMock mock];
    _acfilteroneswitchMock.operationType = [NSString stringWithFormat:@"%@%@/filteroneswitch",AC_BASE_URL,_cleaner.macId];
    _acfilteroneswitchMock.delegate = self;
    acfilteroneswitchParam = [ACfilteroneswitchParam param];
    acfilteroneswitchParam.sendMethod = @"POST";
    acfilteroneswitchParam.filter_status = @"filter";
    acfilteroneswitchParam.tokenid = user.tokenID;
    acfilteroneswitchParam.source = @"app";
    //滤网2
    _acfiltertwoswitchMock = [ACfiltertwoswitchMock mock];
    _acfiltertwoswitchMock.operationType = [NSString stringWithFormat:@"%@%@/filtertwoswitch",AC_BASE_URL,_cleaner.macId];
    _acfiltertwoswitchMock.delegate = self;
    acfiltertwoswitchParam = [ACfiltertwoswitchParam param];
    acfiltertwoswitchParam.sendMethod = @"POST";
    acfiltertwoswitchParam.filter_status = @"filter";
    acfiltertwoswitchParam.tokenid = user.tokenID;
    acfiltertwoswitchParam.source = @"app";
    self.airCleanerMock = [AirCleanerMock mock];
    self.airCleanerMock.delegate = self;
    _airCleanerMock.operationType = [NSString stringWithFormat:@"%@%@/allstatus?tokenId=%@",AC_BASE_URL,_cleaner.macId,user.tokenID];
    airCleanerParam = [AirCleanerParam param];
    airCleanerParam.sendMethod = @"GET";

}



-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[ACfilteroneswitchMock class]] || [mock isKindOfClass:[ACfiltertwoswitchMock class]]) {
        [self.airCleanerMock run:airCleanerParam];
    }
    if ([mock isKindOfClass:[AirCleanerMock class]]) {
        AirCleanerEntity* e = (AirCleanerEntity*)entity;
        _cleaner.filterOneSwitch = e.filterOneSwitch;
        _cleaner.filterTwoSwitch = e.filterTwoSwitch;
        [NSThread sleepForTimeInterval:0.5f];  //等待机器刷新状态
        [self.lvwangTableView reloadData];
    }
    
}


#pragma mark tableView代理
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterCell *cell = (FilterCell*)[[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil]lastObject];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.filterImage.image = [UIImage imageNamed:@"clean_net"];
            cell.suggest.text = @"请定期清洗滤网";
            cell.buyFilterButton.hidden = YES;
            if (_cleaner.filterOneSwitch.intValue < 100 && _cleaner.filterOneSwitch.intValue != 0) {
                cell.remainDay.text = self.cleaner.filterOneSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (_cleaner.filterOneSwitch.intValue == 0){
                cell.remainDay.text = _cleaner.filterOneSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = self.cleaner.filterOneSwitch;
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
                cell.timeUnitLabel.text = @"小时";
            }
            cell.filterType.text = @"过滤网1：初效滤网";
            break;
        case 1:
            cell.filterImage.image = [UIImage imageNamed:@"dirty_net"];
            cell.suggest.text = @"请定期更换滤网";
            cell.buyFilterButton.hidden = NO;
            if (_cleaner.filterTwoSwitch.intValue < 100 && _cleaner.filterTwoSwitch.intValue != 0) {
                cell.remainDay.text = _cleaner.filterTwoSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (_cleaner.filterTwoSwitch.intValue == 0){
                cell.remainDay.text = _cleaner.filterTwoSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = _cleaner.filterTwoSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
            }
            cell.filterType.text = @"过滤网2：夹碳海帕滤网";
            cell.mark = @"tt";
            break;
        default:
            break;
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}



- (void)filterResetButtonClicked:(UIButton*)resetButton{
    if (_lvwangTableView.editing == NO){
        [resetButton setTitle:@"完成" forState:UIControlStateNormal];
        _lvwangTableView.editing = YES;
        return;
    }
    NSArray *selectedRows = [_lvwangTableView indexPathsForSelectedRows];
    if (selectedRows.count == 0) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请选择滤网"];
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确认需要重置滤网？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }];
        UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if (_lvwangTableView.editing) {
//                lvwang = 3;
                for (NSIndexPath *path in selectedRows) {
                    switch (path.row) {
                        case 0:
                            [_acfilteroneswitchMock run:acfilteroneswitchParam];
                            [self httpRequestPreFunc];
                            break;
                        case 1:
                            [_acfiltertwoswitchMock run:acfiltertwoswitchParam];
                            [self httpRequestPreFunc];
                            break;
                            
                        default:
                            break;
                    }
                    [self.btnReset setTitle:@"重置滤网" forState:UIControlStateNormal];
                    _lvwangTableView.editing = NO;
                    
                }
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okayAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)httpRequestPreFunc{
    //打开菊花
    [[ViewControllerManager sharedManager]showWaitView:self.navigationController.view];
}
- (IBAction)buyFilter:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoShop" object:nil];
    [WpCommonFunction showTabBar];

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
