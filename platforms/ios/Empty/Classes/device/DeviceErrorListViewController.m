//
//  DeviceErrorListViewController.m
//  Empty
//
//  Created by duye on 15/9/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "DeviceErrorListViewController.h"
#import "DeviceErrorListMock.h"
#import "DeviceErrorDetailViewController.h"
#import "DeviceErrorListCell.h"
#import "deviceMessageReadMock.h"
#import "MessageObject.h"
#import "messageReadEntity.h"
#import "messageDeleteMock.h"
#import "messageDeleteEntity.h"
@interface DeviceErrorListViewController (){
    NSMutableArray *deviceErrorLists;
}
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblHint;
@property(strong,nonatomic)DeviceErrorListMock* deviceErrorListMock;
@property (strong, nonatomic) deviceMessageReadMock *myReadMock;
@property (strong, nonatomic) NSMutableArray* editDic;
@property (strong, nonatomic) messageDeleteMock *myDeleteMock;

@end

@implementation DeviceErrorListViewController
//标记为已读按钮事件
- (IBAction)mark2Readed:(id)sender {
    [self tagMsgRead];
}

//删除按钮事件
- (IBAction)delete:(id)sender {
    [self msgDelete];
}

-(void)initQuickMock{
    self.myReadMock = [deviceMessageReadMock mock];
    self.myReadMock.delegate = self;
    self.myDeleteMock = [messageDeleteMock mock];
    self.myDeleteMock.delegate = self;
    self.editDic = [[NSMutableArray alloc] init];
}


- (void)viewDidLoad {
    self.navigationBarTitle = @"设备故障";
    [super viewDidLoad];
    self.lblHint.hidden = YES;
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    //tableViewCell之间不带横线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_tableView setAllowsSelectionDuringEditing:YES];
    
    //右上角编辑按钮
}

-(void)viewWillAppear:(BOOL)animated{
    [self getErrorList];
}

-(void)getErrorList{
    //获取故障信息列表
    UserInfo* info = [UserInfo restore];
    _deviceErrorListMock = [DeviceErrorListMock mock];
    _deviceErrorListMock.operationType = [NSString stringWithFormat:@"/devices/%@/messages?tokenId=%@",_deviceId,info.tokenID];
    _deviceErrorListMock.delegate = self;
    DeviceErrorListParam *deviceErrorListParam = [DeviceErrorListParam param];
    deviceErrorListParam.sendMethod = @"GET";
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [_deviceErrorListMock run:deviceErrorListParam];

}

- (void)editNoteMode{
    
    
    if (!_tableView.isEditing) {
        [self.editDic removeAllObjects];
        for (NSIndexPath* indexPath in [_tableView indexPathsForVisibleRows])
        {
            DeviceErrorListCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
            [cell.redPotView setHidden:YES];
            [cell.redPotView removeFromSuperview];
        }
        [_tableView reloadData];
    }

    
    
    if (_tableView.isEditing) {
        [UIView animateWithDuration:0.3f animations:^{
//            _footerView.frame = CGRectMake(_footerView.frame.origin.x, _footerView.frame.origin.y + _footerView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
            _footerView.hidden = YES;
            _tableView.editing = NO;
            [_tableView reloadData];
        } completion:^(BOOL finished) {
//            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height + 50);
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
//            _footerView.frame = CGRectMake(_footerView.frame.origin.x, _footerView.frame.origin.y - _footerView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
            _footerView.hidden = NO;
            _tableView.editing = YES;
        } completion:^(BOOL finished) {
//            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height - 50);
        }];
    }

    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 3;
}

//- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"点击删除");
//}

#pragma http请求回调
//http请求成功后的回调
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[DeviceErrorListMock class]]) {
        DeviceErrorListEntity* e = (DeviceErrorListEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            deviceErrorLists = [e getDeviceErrorLists];
            if (deviceErrorLists.count == 0) {
                self.lblHint.hidden = NO;
                self.navigationItem.rightBarButtonItem = nil;
            }else{
                UIButton *btnEditNote = [UIButton buttonWithType:UIButtonTypeCustom];
                btnEditNote.frame = CGRectMake(0, 0, 50, 25);
                [btnEditNote setTitle:@"编辑" forState:UIControlStateNormal];
                [btnEditNote addTarget:self action:@selector(editNoteMode) forControlEvents:UIControlEventTouchUpInside];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnEditNote];

            }
            [_tableView reloadData];
        }
    }
    else if ([mock isKindOfClass:[deviceMessageReadMock class]]) {
        identifyEntity *e = (identifyEntity *)entity;
        self.tableView.editing = NO;
        [deviceErrorLists removeAllObjects];
        [self getErrorList];
        [self.editDic removeAllObjects];
    }
    
//    [_tableView reloadData];

}


#pragma 这里是tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return deviceErrorLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceErrorListCell *cell = (DeviceErrorListCell*)[[[NSBundle mainBundle] loadNibNamed:@"DeviceErrorListCell" owner:self options:nil]lastObject];
    
    if (indexPath.row == deviceErrorLists.count -1) {
        cell.mark = @"tt";
    }
//    static NSString *CMainCell = @"CMainCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier: CMainCell];
//    }
    
    DeviceErrorListInfoEntity* e = [deviceErrorLists objectAtIndex:indexPath.row];
    
    if (_tableView.isEditing) {
        cell.redPotView.hidden = YES;
    }else if([e.deviceMsgStatus isEqualToString:@"Y"]){
        cell.redPotView.hidden = YES;
    }else{
        cell.redPotView.hidden = NO;
    }
    cell.backgroundColor = Color_Bg_celllightblue;
    
    DeviceErrorListInfoEntity *ee = [deviceErrorLists objectAtIndex:indexPath.row];
    
    cell.titleView.text = ee.deviceMsgTitle;
    
    
    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateFormat:@"YYYY-MM-dd"];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];
    if ([date isEqualToString:ee.deviceMsgDetailTime]) {
        NSString *hour = [ee.deviceMsgTime substringToIndex:2];
        NSString *minit = [ee.deviceMsgTime substringFromIndex:3];
        
        if (hour.intValue >= 12) {
            cell.timeView.text = [NSString stringWithFormat:@"下午%i:%@",hour.intValue - 12,minit];
        } else {
            cell.timeView.text = [NSString stringWithFormat:@"上午%@:%@",hour,minit];
        }
    } else {
        cell.timeView.text = ee.deviceMsgTime;
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    if ([e.deviceMsgStatus isEqualToString:@"Y"]) {
        cell.redPotView.hidden = YES;
    }
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView cellForRowAtIndexPath:indexPath].isEditing) {
        [self.editDic addObject:indexPath];
    }
    if (![tableView cellForRowAtIndexPath:indexPath].isEditing) {
        DeviceErrorListInfoEntity *ee = [deviceErrorLists objectAtIndex:indexPath.row];
        
        UserInfo* info = [UserInfo restore];
        if (info) {
            deviceMessageReadParam *readParam = [deviceMessageReadParam param];
            readParam.sendMethod = @"GET";
            self.myReadMock.operationType = [NSString stringWithFormat:@"/devices/messages/read/%@?tokenId=%@",ee.deviceMsgId,info.tokenID];
            [self.myReadMock run:readParam];
        }
        DeviceErrorDetailViewController *controller = [[DeviceErrorDetailViewController alloc] initWithNibName:@"DeviceErrorDetailViewController" bundle:nil];
        controller.deviceErrorListInfoEntity = ee;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView cellForRowAtIndexPath:indexPath].isEditing) {
        [self.editDic removeObject:indexPath];
    }
}

- (void) tagMsgRead {
    BOOL needAlert = YES;
    for (NSIndexPath *index in self.editDic) {
//        MessageObject *item = [self.dataSource objectAtIndex:index.row];
        DeviceErrorListInfoEntity* item = [deviceErrorLists objectAtIndex:index.row];
        if ([item.deviceMsgStatus isEqualToString:@"Y"]) {
            needAlert = needAlert & YES;
        } else {
            needAlert = needAlert & NO;
            UserInfo* info = [UserInfo restore];
            if (info) {
                deviceMessageReadParam *readParam = [deviceMessageReadParam param];
                readParam.sendMethod = @"GET";
                self.myReadMock.operationType = [NSString stringWithFormat:@"/devices/messages/read/%@?tokenId=%@",item.deviceMsgId,info.tokenID];
                [[ViewControllerManager sharedManager]showWaitView:self.view];
                [self.myReadMock run:readParam];
            }
        }
    }
//    self.tableView.editing = NO;
//    [deviceErrorLists removeAllObjects];
//    [self getErrorList];
//    [self.editDic removeAllObjects];
    if (needAlert) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"未选中未读消息"];
    }

}

- (void) msgDelete {
    for (NSIndexPath *index in self.editDic) {
        DeviceErrorListInfoEntity* item = [deviceErrorLists objectAtIndex:index.row];
        //        [self.dataSource removeObjectAtIndex:index.row];
        UserInfo* info = [UserInfo restore];
        if (info) {
            deviceMessageReadParam *deleteParam = [deviceMessageReadParam param];
            deleteParam.sendMethod = @"GET";
            self.myReadMock.operationType = [NSString stringWithFormat:@"/devices/messages/delete/%@?tokenId=%@",item.deviceMsgId,info.tokenID];
            [[ViewControllerManager sharedManager]showWaitView:self.view];
            [self.myReadMock run:deleteParam];
        }
    }
//    [self.tableView reloadData];
    
}


@end
