//
//  NoteCenterViewController.m
//  Empty
//
//  Created by 信息部－研发 on 15/7/31.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "ItemListSection.h"
#import "listEntity.h"
#import "messageMock.h"
#import "messageReadMock.h"
#import "messageDeleteMock.h"
#import "MessageSection.h"
#import "messageEntity.h"
#import "messageReadEntity.h"
#import "messageDeleteEntity.h"
#import "MessageObject.h"
#import "MessageDetailViewController.h"
#import "DeviceErrorListCell.h"
@interface MessageCenterViewController ()
@property (weak, nonatomic) IBOutlet UIView *tabFooterView;
@property (weak, nonatomic) IBOutlet UITableView *tableNotes;
@property (weak, nonatomic) IBOutlet UIButton *btnTagRead;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblNoMessage;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) UIButton* btnEditNote;
@property (strong, nonatomic) NSMutableArray* editDic;
@property (strong, nonatomic) messageMock* myMessageMock;
@property (strong, nonatomic) messageReadMock *myReadMock;
@property (strong, nonatomic) messageDeleteMock *myDeleteMock;
@property (strong, nonatomic) NSArray* messageResult;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"消息中心";
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.btnEditNote = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnEditNote.frame = CGRectMake(0, 0, 40, 25);
    [self.btnEditNote setTitle:@"编辑" forState:UIControlStateNormal];
    [self.btnEditNote addTarget:self action:@selector(editNoteMode) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTagRead addTarget:self action:@selector(tagMsgRead) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTagRead setEnabled:NO];
//    [self.btnTagRead setHidden:YES];
    [self.btnDelete addTarget:self action:@selector(msgDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.btnDelete setEnabled:NO];
//    [self.btnDelete setHidden:YES];
    [self.tabFooterView setHidden:YES];
    [self.view bringSubviewToFront:self.tabFooterView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.btnEditNote];
    self.tableNotes.delegate = self;
    self.tableNotes.dataSource = self;
    self.tableNotes.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableNotes.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = [[NSMutableArray alloc]init];
    self.editDic = [[NSMutableArray alloc] init];
     [self.tableNotes setSeparatorColor:[UIColor clearColor]];
//    [[ViewControllerManager sharedManager]showWaitView:self.view];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMessageNum" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)initQuickUI{
//    
//}
- (void)initQuickMock{
    self.myMessageMock = [messageMock mock];
    self.myMessageMock.delegate = self;
    self.myReadMock = [messageReadMock mock];
    self.myReadMock.delegate = self;
    self.myDeleteMock = [messageDeleteMock mock];
    self.myDeleteMock.delegate = self;
    
    [self getMessage];
}
- (void) getMessage {
    messageParam* param = [messageParam param];
    param.sendMethod = @"GET";
    UserInfo* info = [UserInfo restore];
    if (info) {
        [self.myMessageMock run:param];
        [[ViewControllerManager sharedManager]showWaitView:self.view];
    }
}
- (NSString *) getTimeStringFromDateString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[string substringToIndex:19]];
    NSDate *nowDate = [NSDate date];
    NSCalendar *canlendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponent = [canlendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    NSDateComponents *nowDateComponent = [canlendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    if (dateComponent.day == nowDateComponent.day && dateComponent.month == nowDateComponent.month && dateComponent.year == nowDateComponent.year) {
//        return [string substringWithRange:NSMakeRange(11, 5)];
        NSString *noon = [[NSString alloc] init];
        if (dateComponent.hour > 12) {
            noon = @"下午";
        } else {
            noon = @"上午";
        }
        NSInteger modHour = dateComponent.hour > 12 ? dateComponent.hour - 12 : dateComponent.hour;
        NSString *strHour = [[NSString alloc] init];
        if (modHour >= 10) {
            strHour = [NSString stringWithFormat:@"%lu", modHour];
        } else {
            strHour = [NSString stringWithFormat:@"0%lu", modHour];
        }
        NSInteger modMinute = dateComponent.minute;
        NSString *strMinute = [[NSString alloc] init];
        if (modMinute >= 10) {
            strMinute = [NSString stringWithFormat:@"%lu", modMinute];
        } else {
            strMinute = [NSString stringWithFormat:@"0%lu", modMinute];
        }
        return [NSString stringWithFormat:@"%@%@:%@", noon, strHour, strMinute];
    } else {
        return [[string substringWithRange:NSMakeRange(5, 5)] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    return nil;
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0) {
        
        self.tabFooterView.hidden = YES;
       self.btnEditNote.hidden = true;
    } else {
        self.btnEditNote.hidden = false;
    }
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
//    [self.tableNotes registerNib:[UINib nibWithNibName:@"MessageSection" bundle:nil] forCellReuseIdentifier:cellid];
    DeviceErrorListCell *cell = (DeviceErrorListCell*)[[[NSBundle mainBundle] loadNibNamed:@"DeviceErrorListCell" owner:self options:nil]lastObject];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceErrorListCell" owner:self options:nil] lastObject];
//        [self.tableNotes registerNib:[UINib nibWithNibName:@"DeviceErrorListCell" bundle:nil] forCellReuseIdentifier:cellid];
//    }
//    if (indexPath.row % 2 == 0) {
//        cell.backgroundColor = Color_Bg_celllightblue;
//    } else {
//        cell.backgroundColor = Color_Bg_cellldarkblue;
//    }
    if (indexPath.row == self.dataSource.count -1) {
        cell.mark = @"tt";
    }

    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = cell.backgroundColor;
    MessageObject *item = [self.dataSource objectAtIndex:indexPath.row];
    if ([self.tableNotes isEditing]) {
        cell.redPotView.hidden = YES;
    }else if([item.messageStatus isEqualToString:@"0"]){
        cell.redPotView.hidden = NO;
    }else{
        cell.redPotView.hidden = YES;
    }
    cell.titleView.text = item.messageTitle;
    cell.titleView.textColor = [UIColor whiteColor];
    cell.titleView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSString *dateString = [self getTimeStringFromDateString:item.messageRecieveTime];
    cell.timeView.text = dateString;
    cell.timeView.textColor = [UIColor whiteColor];
    cell.timeView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
//    NSLog(@"cell left = %f, top = %f", [cell bounds].origin.x, [cell bounds].origin.y);
     cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableNotes.isEditing == YES) {
//        DeviceErrorListCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.redPotView.hidden = YES;
        [self.editDic addObject:indexPath];
    } else {
        MessageObject *item = [self.dataSource objectAtIndex:indexPath.row];
        UserInfo* info = [UserInfo restore];
        if (info) {
            messageReadParam *readParam = [messageReadParam param];
            readParam.sendMethod = @"POST";
            readParam.TOKENID = info.tokenID;
            readParam.MESSAGEID = item.messageId;
            [self.myReadMock run:readParam];
        }
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        MessageDetailViewController * detail = [[MessageDetailViewController alloc] initWithNibName:@"MessageDetailViewController" bundle:nil andMessage:item];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableNotes.isEditing == YES) {
        [self.editDic removeObject:indexPath];
    }
}


- (void) editNoteMode {
    
    [self.tableNotes setEditing:!(self.tableNotes.isEditing) animated:YES];
    if ((self.tableNotes.isEditing)) {
        [self.editDic removeAllObjects];
        for (NSIndexPath* indexPath in [self.tableNotes indexPathsForVisibleRows])
        {
            DeviceErrorListCell* cell = [self.tableNotes cellForRowAtIndexPath:indexPath];
            [cell.redPotView setHidden:YES];
            [cell.redPotView removeFromSuperview];
        }
        [self.tableNotes reloadData];
    }
    if ([self.tableNotes isEditing]) {
        NSLayoutConstraint *oldConstraint = (NSLayoutConstraint *)[[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableNotes]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableNotes)] firstObject];
        for (NSLayoutConstraint *item in self.view.constraints) {
            NSLog(@"%@", item);
            if ([WpCommonFunction compareConstaint:item toConstraint:oldConstraint]) {
                [self.view removeConstraint:item];
                oldConstraint.constant = self.tabFooterView.bounds.size.height;
                [self.view addConstraint:oldConstraint];
            }
        }
    } else {
        NSLayoutConstraint *oldConstraint = (NSLayoutConstraint *)[[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_tableNotes]-(%f)-|", self.tabFooterView.bounds.size.height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableNotes)] firstObject];
        for (NSLayoutConstraint *item in self.view.constraints) {
            if ([WpCommonFunction compareConstaint:item toConstraint:oldConstraint]) {
                [self.view removeConstraint:item];
                oldConstraint.constant = 0;
                [self.view addConstraint:oldConstraint];
            }
        }
    }
    [self.tabFooterView setHidden:![self.tableNotes isEditing]];
//    self.btnTagRead.hidden = ![self.tableNotes isEditing];
    [self.btnTagRead setEnabled:[self.tableNotes isEditing]];
//    self.btnDelete.hidden = ![self.tableNotes isEditing];
    [self.btnDelete setEnabled:[self.tableNotes isEditing]];
    [self.tableNotes reloadData];
}
- (void) tagMsgRead {
    BOOL needAlert = YES;
    for (NSIndexPath *index in self.editDic) {
        MessageObject *item = [self.dataSource objectAtIndex:index.row];
        if (![item.messageStatus isEqualToString:@"0"]) {
            needAlert = needAlert & YES;
        } else {
            needAlert = needAlert & NO;
            UserInfo* info = [UserInfo restore];
            if (info) {
                messageReadParam *readParam = [messageReadParam param];
                readParam.sendMethod = @"POST";
                readParam.TOKENID = info.tokenID;
                readParam.MESSAGEID = item.messageId;
                [self.myReadMock run:readParam];
            }
        }
        item.messageStatus = @"1";
    }
    [self.editDic removeAllObjects];
    [self.tableNotes reloadData];
    if (needAlert) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"未选中未读消息"];
    }
    
}
- (void) msgDelete {
    
    
    
    for (int i = self.editDic.count -1;i>=0;i--) {
        NSIndexPath* index = [self.editDic objectAtIndex:i];
        MessageObject *item = [self.dataSource objectAtIndex:index.row];
        [self.dataSource removeObjectAtIndex:index.row];
        UserInfo* info = [UserInfo restore];
        if (info) {
            messageDeleteParam *deleteParam = [messageDeleteParam param];
            deleteParam.sendMethod = @"POST";
            deleteParam.TOKENID = info.tokenID;
            deleteParam.MESSAGEID = item.messageId;
            [self.myDeleteMock run:deleteParam];
        }
    }
    [self.editDic removeAllObjects];
//    [self.tableNotes reloadData];
}

- (void) QUMock:(QUMock *)mock entity:(QUEntity *)entity {
    if ([mock isKindOfClass:[messageMock class]]) {
        messageEntity* e = (messageEntity*)entity;
//        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            [self.dataSource removeAllObjects];
            self.messageResult = e.result;
            for (NSDictionary *item in self.messageResult) {
                MessageObject* message = [[MessageObject alloc] init];
                message.messageId = [item objectForKey:@"messageId"];
                message.messageTitle = [item objectForKey:@"messageTitle"];
                message.messageContent = [item objectForKey:@"messageContent"];
                message.messageRecieveTime = [item objectForKey:@"messageReceiveTime"];
                message.messageStatus = [item objectForKey:@"messageStatus"];
                message.messageSender = [item objectForKey:@"messageSender"];
                [self.dataSource addObject:message];
            }
            [self.tableNotes reloadData];
            NSLog(@"Message count = %lu", self.dataSource.count);
            if (self.dataSource.count > 0) {
                if (self.lblNoMessage != nil) {
                    [self.lblNoMessage setHidden:YES];
                }else{
                    self.navigationItem.rightBarButtonItem = nil;
                }
            }
//        }
    } else if ([mock isKindOfClass:[messageReadMock class]]) {
        messageReadEntity *e = (messageReadEntity *)entity;
        if ([e.message isEqualToString:@"消息已读"]) {
            NSLog(@"This message is already Read.");
        }
        [self.dataSource removeAllObjects];
        [self getMessage];
    } else if ([mock isKindOfClass:[messageDeleteMock class]]) {
        messageDeleteEntity *e = (messageDeleteEntity *)entity;
        if ([e.message isEqualToString:@"消息已删除"]) {
            NSLog(@"This message is already deleted.");
        }
        [self.dataSource removeAllObjects];
        [self getMessage];
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
