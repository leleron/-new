//
//  TryDeviceListViewController.m
//  Empty
//
//  Created by leron on 15/12/2.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "TryDeviceListViewController.h"
#import "deviceListSection.h"
#import "TryDeviceViewController.h"
#import "TryAirCleanerViewController.h"
#import "AddDeviceViewController.h"
#import "AirCleanerViewController.h"
@interface TryDeviceListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton* trydevice;

}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end

@implementation TryDeviceListViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"试用设备";
    [super viewDidLoad];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self addTryDevice];
}
-(void)addDevice{
    AddDeviceViewController* controller = [[AddDeviceViewController alloc]initWithNibName:@"AddDeviceViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    
    deviceListSection *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"deviceListSection" owner:self options:nil] lastObject];
        [self.myTableView registerNib:[UINib nibWithNibName:@"deviceListSection" bundle:nil] forCellReuseIdentifier:cellid];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    //    cell.contentView.backgroundColor = [UIColor clearColor];
    if (indexPath.row != 0) {
        cell.imgLine.hidden = YES;
    }else{
        cell.imgLine.hidden = NO;
    }
    if (indexPath.row == 0) {
        cell.lblTitle.text = @"智能扫地机器人";
        for (NSLayoutConstraint* item in cell.constraints) {
            if ([item.identifier isEqualToString:@"titleY"]) {
                item.constant = 0;
            }
        }
//        cell.lblProductName.text = @"智能扫地机器人";
        cell.imgIcon.image = [UIImage imageNamed:@"9605"];
        //            cell.lblTitle.text = ;
        cell.lblStatus.text = @"试用";
    }
    
    if (indexPath.row == 1) {
        cell.lblTitle.text = @"智能空气净化器";
        for (NSLayoutConstraint* item in cell.constraints) {
            if ([item.identifier isEqualToString:@"titleY"]) {
                item.constant = 0;
            }
        }
//        cell.lblProductName.text = @"智能空气净化器";
        cell.imgIcon.image = [UIImage imageNamed:@"airCleaner"];
        cell.lblStatus.text = @"试用";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TryDeviceViewController* controller = [[TryDeviceViewController alloc]initWithNibName:@"TryDeviceViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [WpCommonFunction hideTabBar];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (indexPath.row == 1) {
        AirCleanerViewController* controller = [[AirCleanerViewController alloc] initWithNibName:@"AirCleanerViewController" bundle:nil airCleaner:nil];
        controller.hidesBottomBarWhenPushed = YES;
        controller.isReal = NO;
        [WpCommonFunction hideTabBar];
        [self.navigationController pushViewController:controller animated:YES];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    deviceListSection *cell = (deviceListSection*)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = BLUECOLOR;
    //    cell.b.hidden = _isTableEdit;
    return NO;
}

-(void)addTryDevice{
    if (trydevice) {
        [trydevice removeFromSuperview];
    }
    trydevice = [UIButton buttonWithType:UIButtonTypeCustom];
    [trydevice setTitle:@"添加设备" forState:UIControlStateNormal];
    //    [WpCommonFunction setView:trydevice cornerRadius:8];
    trydevice.frame = CGRectMake(0, 2*140, SCREEN_WIDTH, 50);
    [trydevice setBackgroundColor:Color_Bg_Line];
    [trydevice addTarget:self action:@selector(addDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableView addSubview:trydevice];
    [self.myTableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.myTableView.frame.size.height+50)];
    //    for (NSLayoutConstraint* item in self.view.constraints) {
    //        if ([item.identifier isEqualToString:@"tableBottom"]) {
    //            item.constant = 50;
    //        }
    //    }
    
    
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
