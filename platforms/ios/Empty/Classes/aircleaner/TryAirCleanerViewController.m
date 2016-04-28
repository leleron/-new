//
//  TryAirCleanerViewController.m
//  Empty
//
//  Created by duye on 15/9/25.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "TryAirCleanerViewController.h"
#import "FKACManageDeviceViewController.h"

@interface TryAirCleanerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ionCleanLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutDownOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSelectLabel;
@property (weak, nonatomic) IBOutlet UILabel *outdoor_airquality;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *outdoor_pm;
@property (weak, nonatomic) IBOutlet UIButton *lightEffect;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *liziButton;
@property (weak, nonatomic) IBOutlet UIButton *shijianButton;
@property (weak, nonatomic) IBOutlet UIButton *fengsuButton;
@property (weak, nonatomic) IBOutlet UIView *underBackView;
@property (weak, nonatomic) IBOutlet UIView *pickerButtonView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView2;

@property(strong,nonatomic)UIButton* CancelYuyueButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelYYButton;
@property (weak, nonatomic) IBOutlet UIButton *savaBUtton;

@end

@implementation TryAirCleanerViewController{
    ProgressView *progress;
    NSArray *hours;
    NSArray *minites;
    NSDictionary *pickerDictionary;
    UIPickerView *pickerViewTime;
    NSArray *Winds;
//    UIView *pickerButtonView;
    UIView *filterView;
    NSTimer *uiUpdateTimer;
    FKACManageDeviceViewController* fkacManageDeviceViewController;
    UIButton* filterResetButton;
    //滤网tableView
    UITableView *filterTableView;
    UIView* empty;
    //显示状态
    int showStatus;
    NSString* selectedHour;
}

@synthesize cleaner;
- (void)viewDidLoad {
    self.navigationBarTitle = self.cleaner.deviceName;
    [super viewDidLoad];
    [self updateUI];
    progress.hint1.hidden = YES;
    progress.hint2.hidden = YES;
    // Do any additional setup after loading the view.
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initUI];
    }
    
    return self;
}



-(void)myEdit{
    NSLog(@"myEdit");
    fkacManageDeviceViewController = [[FKACManageDeviceViewController alloc]initWithNibName:@"FKACManageDeviceViewController" bundle:nil];
    fkacManageDeviceViewController.cleaner = nil;
    
    [self.navigationController pushViewController:fkacManageDeviceViewController animated:YES];
    
}

-(void)addEmptyView{
    empty = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height/2-20)];
    empty.backgroundColor = [UIColor blackColor];
    empty.alpha = 0.5;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideYuyue)];
    [empty addGestureRecognizer:gesture];
    [self.view addSubview:empty];
    
}


-(void)hideShadow{
    
    progress.hidden = NO;
    if (!_pickerButtonView.isHidden) {
        _pickerButtonView.hidden = YES;
    }
    CGRect currentFrame = filterView.frame;
    if (currentFrame.origin.x==0) {
        filterView.frame = CGRectMake(DEVICE_WIDTH, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    }
    
    [empty removeFromSuperview];
    empty = nil;
}

//时间预约
- (IBAction)shutDownOrder:(id)sender {
    [self addEmptyView];
    self.CancelYuyueButton.hidden = NO;
    progress.hidden = !progress.hidden;
    //    if ([cleaner.time_status isEqualToString:@"timeno"]) {
    _pickerButtonView.hidden = NO;
    _pickerView2.hidden = YES;
    pickerViewTime.hidden = NO;

}

//风速调节
- (IBAction)windSelect:(id)sender {
    [self addEmptyView];
    //初始化风速的弹出菜单
//    NSArray *items = @[
//                       [[RNGridMenuItem alloc] initWithTitle:@"智能模式"],
//                       [[RNGridMenuItem alloc] initWithTitle:@"1档"],
//                       [[RNGridMenuItem alloc] initWithTitle:@"睡眠模式"],
//                       [[RNGridMenuItem alloc] initWithTitle:@"2档"],
//                       [[RNGridMenuItem alloc] initWithTitle:@"强劲模式"],
//                       [[RNGridMenuItem alloc] initWithTitle:@"3档"]
//                       ];
//    
//    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, items.count)]];
//    av.delegate = self;
//    float width = DEVICE_WIDTH/3;
//    float height = width/3;
//    float fontSize = height/2;
//    av.itemFont = [UIFont systemFontOfSize:fontSize];
//    av.itemSize = CGSizeMake(width, height);
//    av.menuStyle = RNGridMenuStyleGrid;
//    av.backgroundColor = FLYCO_DARK_BLUE;
//    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, fontSize*2)];
//    header.text = @"风速选择";
//    header.font = [UIFont systemFontOfSize:fontSize + 1];
//    header.textColor = [UIColor whiteColor];
//    header.textAlignment = NSTextAlignmentCenter;
//    av.headerView = header;
//    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    
    self.CancelYuyueButton.hidden = YES;
    progress.hidden = !progress.hidden;
    _pickerButtonView.hidden = NO;
    _pickerView2.hidden = NO;
    pickerViewTime.hidden = YES;

}
//灯效
- (IBAction)lightEffect:(id)sender {
    if ([cleaner.runningMode isEqualToString:@"sleep"]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"睡眠模式无法设置灯效"];
    }else{
        NSString *title = _ionCleanLabel.text;
        NSString *switchTemp = @"";
        if ([title isEqualToString:@"灯效全开"]) {
            cleaner.light_status = @"lighthalfon";
        } else if([title isEqualToString:@"灯效半开"]){
            cleaner.light_status = @"lightoff";
        } else if([title isEqualToString:@"灯效关闭"]){
            cleaner.light_status = @"lighton";
        } else {
            NSLog(@"不存在的灯效");
        }
    }
    [self updateUI];
}

//滤网
- (IBAction)filter:(id)sender {
    [self addEmptyView];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect currentFrame = filterView.frame;
        filterView.frame = CGRectMake(0, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    }];
}

//开关
- (void)turnOnOff:(UIButton*)button{
    if ([cleaner.powerSwitch isEqualToString:@"poweron"]) {
        cleaner.powerSwitch = @"poweroff";
    } else {
        cleaner.powerSwitch = @"poweron";
    }
    [self updateUI];
}

//离子净化
- (IBAction)ionClean:(id)sender {
    if ([cleaner.powerSwitch isEqualToString:@"poweroff"]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请打开设备"];
    }else{
        if ([cleaner.anionSwitch isEqualToString:@"anionon"]) {
            cleaner.anionSwitch = @"anionoff";
        } else {
            cleaner.anionSwitch = @"anionon";
        }
        [self updateUI];

    }
}

#pragma mark - RNGridMenuDelegate
//风速选择结束后的回调
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
    if ([item.title isEqualToString:@"智能模式"]) {
        cleaner.runningMode = @"auto";
    } else if ([item.title isEqualToString:@"睡眠模式"]) {
        cleaner.runningMode = @"sleep";
    } else if ([item.title isEqualToString:@"强劲模式"]) {
        cleaner.runningMode = @"strong";
    } else if ([item.title isEqualToString:@"1档"]) {
        cleaner.runningMode = @"one";
    } else if ([item.title isEqualToString:@"2档"]) {
        cleaner.runningMode = @"two";
    } else if ([item.title isEqualToString:@"3档"]) {
        cleaner.runningMode = @"three";
    } else {
        NSLog(@"不存在的模式");
    }
    [self updateUI];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView.tag == 0) {
        return 5;
    }
    if (pickerView.tag == 1) {
        return 5;
    }
}

-(CGFloat) pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        switch (component) {
            case 0:
                return hours.count*100;
                break;
            case 1:
                return minites.count*100;
                break;
            default:
                return 1;
                break;
        }
    }
    if (pickerView.tag == 1) {
        return 1200;
    }
}



-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        switch (component) {
            case 0:
                return [hours objectAtIndex:row%9];
                break;
            case 1:
                if ([selectedHour isEqualToString:@"00"]) {
                    return [minites objectAtIndex:row%59];
                }else{
                    return [minites objectAtIndex:row%60];
                }
                break;
            default:
                return @"";
                break;
        }
    }
    if (pickerView.tag == 1) {
        return [Winds objectAtIndex:row];
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        switch (component) {
            case 0:
                return DEVICE_WIDTH/3;
                break;
            case 1:
                return DEVICE_WIDTH/3;
                break;
            default:
                return 0;
                break;
        }
    }
    if (pickerView.tag == 1) {
        return DEVICE_WIDTH;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (pickerView.tag == 0) {
        UILabel *myView = [[UILabel alloc] init];
        myView.font = [UIFont systemFontOfSize:26];
        myView.textColor = [UIColor whiteColor];
        myView.backgroundColor = [UIColor clearColor];
        if (component == 0) {
            myView.text = [hours objectAtIndex:row%9];
            myView.textAlignment = NSTextAlignmentCenter;
        }else {
            if ([selectedHour isEqualToString:@"00"]) {
                myView.text = [minites objectAtIndex:row%59];
            }else if([selectedHour isEqualToString:@"08"]){
                myView.text = [minites objectAtIndex:0];
            }else{
                myView.text = [minites objectAtIndex:row%60];
            }
            myView.textAlignment = NSTextAlignmentCenter;
        }
        return myView;
    }
    if (pickerView.tag == 1) {
        UILabel *myView = [[UILabel alloc] init];
        myView.font = [UIFont systemFontOfSize:26];
        myView.textColor = [UIColor whiteColor];
        myView.backgroundColor = [UIColor clearColor];
        myView.text = [Winds objectAtIndex:row%[Winds count]];
        myView.textAlignment = NSTextAlignmentCenter;
        return myView;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        //    如果选取的是第一个选取器
        if (component == 0) {
            //        得到第一个选取器的当前行
            NSString *selectedState =[hours objectAtIndex:row%9];
            selectedHour = selectedState;
            //        根据从pickerDictionary字典中取出的值，选择对应第二个中的值
            NSArray *array = [pickerDictionary objectForKey:selectedState];
            minites=array;
            [pickerViewTime selectRow:0 inComponent:1 animated:YES];
            
            
            //        重新装载第二个滚轮中的值
//            [pickerViewTime reloadComponent:1];
        }
    }
    if (pickerView.tag == 1) {
        
    }
}

//点击取消
-(void)pikerCancle{
    progress.hidden = !progress.hidden;
    NSLog(@"pikerCancle");
    _pickerButtonView.hidden = YES;
    [self hideShadow];
}
//点击存储
-(void)pikerSave{
    progress.hidden = !progress.hidden;
    _pickerButtonView.hidden = YES;
    cleaner.time_status = @"timeyes";
    NSString *h = [hours objectAtIndex:[pickerViewTime selectedRowInComponent:0]%9];
    NSString* m = nil;
    if ([h isEqualToString:@"00"]) {
         m = [minites objectAtIndex:[pickerViewTime selectedRowInComponent:1]%59];
    }else if([h isEqualToString:@"08"]){
        m = [minites objectAtIndex:0];
    }else{
        m = [minites objectAtIndex:[pickerViewTime selectedRowInComponent:1]%60];
    }
    cleaner.time_remaining = [NSString stringWithFormat:@"%i",h.intValue * 60 + m.intValue];
    if ([cleaner.time_status isEqualToString:@"timeyes"]) {
        int time = cleaner.time_remaining.intValue;
        int hour = time / 60;
        int minite = time % 60;
        NSString *miniteString = [NSString stringWithFormat:@"%i",minite];
        if (minite < 10) {
            miniteString = [NSString stringWithFormat:@"0%i",minite];
        }
        
        _shutDownOrderLabel.text = [NSString stringWithFormat:@"倒计时%i:%@",hour,miniteString];
        
    } else {
        _shutDownOrderLabel.text = @"未设置";
        
    }
    _windSelectLabel.text = [Winds objectAtIndex:[_pickerView2 selectedRowInComponent:0]%[Winds count]];
    [self updateUI];
    [self hideShadow];
}

//中间的圆圈滑动时发生UI变化
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (showStatus < 3) {
        showStatus = showStatus + 1 * (sender.direction == UISwipeGestureRecognizerDirectionLeft ? 1 : -1);
    } else {
        showStatus = 0;
    }
    if (showStatus < 0) {
        showStatus = 3;
    }
    [self updateUI];
}
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (showStatus < 3) {
        showStatus = showStatus + 1;
    } else {
        showStatus = 0;
    }
    [self updateUI];
}

//滤网界面返回按钮按下之后
- (void)filterBackButtonClicked{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect currentFrame = filterView.frame;
        filterView.frame = CGRectMake(DEVICE_WIDTH, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    }];
    [self hideShadow];
}


- (void)filterResetButtonClicked:(UIButton*)resetButton{
    if (filterTableView.editing == NO) {
        [resetButton setTitle:@"完成" forState:UIControlStateNormal];
        filterTableView.editing = YES;
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确认需要重置滤网？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self hideShadow];
        if (filterTableView.editing == YES) {
            [resetButton setTitle:@"重置滤网" forState:UIControlStateNormal];
            filterTableView.editing = NO;
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okayAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

//滤网table的相关代理函数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterCell *cell = (FilterCell*)[[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil]lastObject];
    
    
    switch (indexPath.row) {
        case 0:
            cell.filterImage.image = [UIImage imageNamed:@"clean_net"];
            cell.suggest.text = @"请定期清洗滤网";
            cell.buyFilterButton.hidden = YES;
            if (cleaner.filterOneSwitch.intValue < 100 && cleaner.filterOneSwitch.intValue != 0) {
                cell.remainDay.text = cleaner.filterOneSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (cleaner.filterOneSwitch.intValue == 0){
                cell.remainDay.text = cleaner.filterOneSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = [NSString stringWithFormat:@"%i",cleaner.filterOneSwitch.intValue / 24];
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
                cell.timeUnitLabel.text = @"天";
            }
            cell.filterType.text = @"过滤网1：初效滤网";
            break;
        case 1:
            cell.filterImage.image = [UIImage imageNamed:@"dirty_net"];
            cell.suggest.text = @"请定期更换滤网";
            cell.buyFilterButton.hidden = NO;
            if (cleaner.filterTwoSwitch.intValue < 100 && cleaner.filterTwoSwitch.intValue != 0) {
                cell.remainDay.text = cleaner.filterTwoSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (cleaner.filterTwoSwitch.intValue == 0){
                cell.remainDay.text = cleaner.filterTwoSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = [NSString stringWithFormat:@"%i",cleaner.filterTwoSwitch.intValue / 24];
                cell.timeUnitLabel.text = @"天";
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
            }
            cell.filterType.text = @"过滤网2：夹碳海帕滤网";
            break;
        case 2:
            cell.filterImage.image = [UIImage imageNamed:@"dirty_net"];
            cell.suggest.text = @"请定期更换滤网";
            cell.buyFilterButton.hidden = NO;
            if (cleaner.filterThreeSwitch.intValue < 100 && cleaner.filterThreeSwitch.intValue != 0) {
                cell.remainDay.text = cleaner.filterThreeSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:119/255.0 blue:0/255.0 alpha:1.0];
            }
            else if (cleaner.filterThreeSwitch.intValue == 0){
                cell.remainDay.text = cleaner.filterThreeSwitch;
                cell.timeUnitLabel.text = @"小时";
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34/255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = [NSString stringWithFormat:@"%i",cleaner.filterThreeSwitch.intValue / 24];
                cell.timeUnitLabel.text = @"天";
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
                
            }
            cell.filterType.text = @"过滤网3：除甲醛滤网";
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
    return 75;
}

//更新UI数据
- (void)updateUI{
    
    
    _lightEffect.hidden = NO;
    _filterButton.hidden = NO;
    //灯效
//    if (cleaner.light_status) {
//        _lightEffect.titleLabel.text = cleaner.light_status;
//        [_lightEffect setImage:[UIImage imageNamed:_lightEffect.titleLabel.text] forState:UIControlStateNormal];
//    } else {
//        _lightEffect.titleLabel.text = @"lightoff";
//        [_lightEffect setImage:[UIImage imageNamed:_lightEffect.titleLabel.text] forState:UIControlStateNormal];
//    }
    
    NSString *value = @"";
    NSString *unit = @"";
    if (cleaner.pmValue) {
        progress.showStatus = showStatus;
        switch (showStatus) {
            case 0:
                value = cleaner.pmValue;
                progress.inDoorAirInfoLabel.text = @"颗粒物浓度";
                switch (cleaner.aqiStatus.intValue) {
                    case 1:
                        unit = @"优";
                        progress.percent = 1.0f;
                        break;
                    case 2:
                        unit = @"优";
                        progress.percent = 2.0f/3.0f;
                        break;
                    case 3:
                        unit = @"差";
                        progress.percent = 1.0f/3.0f;
                        break;
                    default:
                        break;
                }
                break;
            case 1:
                if (cleaner.humidity.intValue <= 100) {
                    value = cleaner.humidity;
                } else {
                    value = @"100";
                }
                progress.inDoorAirInfoLabel.text = @"室内湿度";
                progress.percent = value.floatValue / 100.0f;
                unit = @"%";
                break;
            case 2:
                value = [NSString stringWithFormat:@"%i",cleaner.temperature.intValue/10];
                progress.inDoorAirInfoLabel.text = @"室内温度";
                progress.percent = value.floatValue / 100.0f;
                unit = @"°C";
                break;
            case 3:
                progress.inDoorAirInfoLabel.text = @"空气异味";
                switch (cleaner.voc.intValue) {
                    case 1:
                        value = @"优";
                        progress.percent = 1.0f;
                        break;
                    case 2:
                        value = @"优";
                        progress.percent = 2.0f/3.0f;
                        break;
                    case 3:
                        value = @"差";
                        progress.percent = 1.0f/3.0f;
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",value,unit]];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:40.0] range:NSMakeRange(str.length - unit.length, unit.length)];
        if (str) {
            progress.inDoorAirInfoNumLabel.attributedText = str;
        }
    }
    
    [_filterButton setImage:[UIImage imageNamed:@"to_filter"] forState:UIControlStateNormal];
    //室外属性
    if (cleaner.outdoor_pm) {
        _outdoor_pm.text = cleaner.outdoor_pm;
        _location.text = cleaner.location;
        _outdoor_airquality.text = @"室外空气污染";
    }
    //离子净化
    if ([cleaner.light_status isEqualToString:@"lighton"]) {
        _ionCleanLabel.text = @"灯效全开";
    } else if ([cleaner.light_status isEqualToString:@"lighthalfon"]){
        _ionCleanLabel.text = @"灯效半开";
    } else {
        _ionCleanLabel.text = @"灯效关闭";
    }
    
    
    //风速调节
//    if ([cleaner.runningMode isEqualToString:@"auto"]) {
//        _windSelectLabel.text = @"智能模式";
//    } else if ([cleaner.runningMode isEqualToString:@"sleep"]){
//        _windSelectLabel.text = @"睡眠模式";
//    } else if ([cleaner.runningMode isEqualToString:@"strong"]){
//        _windSelectLabel.text = @"强劲模式";
//    } else if ([cleaner.runningMode isEqualToString:@"one"]){
//        _windSelectLabel.text = @"1档";
//    } else if ([cleaner.runningMode isEqualToString:@"two"]){
//        _windSelectLabel.text = @"2档";
//    } else if ([cleaner.runningMode isEqualToString:@"three"]){
//        _windSelectLabel.text = @"3档";
//    } else {
//        NSLog(@"不存在的模式");
//    }
    
    [filterTableView reloadData];
    
    
    //当静默模式关闭的时候
    if ([cleaner.quietmode isEqualToString:@"quietmodeoff"] && [cleaner.powerSwitch isEqualToString:@"poweroff"]) {
        _lightEffect.hidden = YES;
        _filterButton.hidden = YES;
        progress.inDoorAirInfoLabel.text = @"请打开传感器";
        progress.inDoorAirInfoNumLabel.text = @"0";
        progress.percent = 0;
    }
    
    //当关机的时候
    //开关
    if ([cleaner.powerSwitch isEqualToString:@"poweron"]) {
        [progress.OnButton setImage:[UIImage imageNamed:@"cleaner_on"] forState:UIControlStateNormal];
        _liziButton.titleLabel.textColor = [UIColor whiteColor];
        _shijianButton.titleLabel.textColor = [UIColor whiteColor];
        _fengsuButton.titleLabel.textColor = [UIColor whiteColor];
        
        _liziButton.userInteractionEnabled = YES;
        _shijianButton.userInteractionEnabled = YES;
        _fengsuButton.userInteractionEnabled = YES;
        
    } else {
        [progress.OnButton setImage:[UIImage imageNamed:@"cleaner_off"] forState:UIControlStateNormal];
        _ionCleanLabel.text = @"";
        _shutDownOrderLabel.text = @"";
        _windSelectLabel.text = @"";
        _lightEffect.hidden = YES;
        _filterButton.hidden = YES;
        
        _liziButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _shijianButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        _fengsuButton.titleLabel.textColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
        
        
        
        _liziButton.userInteractionEnabled = NO;
        _shijianButton.userInteractionEnabled = NO;
        _fengsuButton.userInteractionEnabled = NO;
    }
}

//初始化UI
- (void)initUI{
    cleaner = [AirCleanerEntity entity];
    cleaner.deviceName = @"空气净化器";
    cleaner.powerSwitch = @"poweron";
    cleaner.light_status = @"lighton";
    cleaner.outdoor_pm = @"88";
    cleaner.location = @"上海市";
    cleaner.pmValue = @"18";
    cleaner.aqiStatus = @"2";
    cleaner.humidity = @"87";
    cleaner.temperature = @"30";
    cleaner.voc = @"3";
    cleaner.runningMode = @"auto";
    cleaner.time_status = @"timeno";
    cleaner.filterOneSwitch = @"99";
    cleaner.filterTwoSwitch = @"100";
    cleaner.filterThreeSwitch = @"2000";
    
    
    self.liziButton.hidden = YES;
    self.ionCleanLabel.hidden = YES;
    //圆形进度条
    float progress_height = DEVICE_HEIGHT / 2 - 100;
    float progress_width = progress_height;
    
    
    progress = [[ProgressView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH / 2 - progress_width / 2, DEVICE_HEIGHT / 2-10, progress_width, progress_height)];
    progress.arcFinishColor = BLUECOLOR;
    progress.arcBackColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
    progress.centerColor = Color_Bg_cellldarkblue;
    progress.delegate = self;
    [self.view addSubview:progress];
    
    
    selectedHour = @"00";
    //时间预约的picker
    pickerViewTime = [[UIPickerView alloc] init];
    pickerViewTime.showsSelectionIndicator=YES;
    pickerViewTime.dataSource = self;
    pickerViewTime.delegate = self;
    pickerViewTime.tag = 0;
    NSArray *minites_normal = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",
                                @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                                @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                                @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
                                @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
                                @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    NSArray *minites_nozero = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",
                                @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                                @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                                @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
                                @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
                                @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    NSArray *minites_zero = @[@"00"];
    pickerDictionary = @{@"00":minites_nozero,
                         @"01":minites_normal,
                         @"02":minites_normal,
                         @"03":minites_normal,
                         @"04":minites_normal,
                         @"05":minites_normal,
                         @"06":minites_normal,
                         @"07":minites_normal,
                         @"08":minites_zero};
    hours = [[pickerDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    minites = minites_nozero;
    
    [pickerViewTime selectRow:450 inComponent:0 animated:NO];
    [pickerViewTime selectRow:2950 inComponent:1 animated:NO];  //默认居中
    
    pickerViewTime.backgroundColor = Color_Bg_cellldarkblue;
    pickerViewTime.frame = CGRectMake(0, 0, SCREEN_WIDTH,_pickerButtonView.frame.size.height-46);
    if (iPhone4) {
        //        pickerViewTime.frame = CGRectOffset(pickerViewTime.frame, 0, -10);
        pickerViewTime.frame = CGRectMake(0, 0, SCREEN_WIDTH,_pickerButtonView.frame.size.height-46-30);
    }
    float labelheight = 30;
    UILabel *zai = [[UILabel alloc] initWithFrame:CGRectMake(0, pickerViewTime.frame.size.height/2 - labelheight/2, pickerViewTime.frame.size.width/4, labelheight)];
    zai.text = @"   在";
    zai.textColor = [UIColor whiteColor];
    zai.textAlignment = NSTextAlignmentCenter;
    UILabel *xiaoshi = [[UILabel alloc] initWithFrame:CGRectMake(pickerViewTime.frame.size.width/4+20, pickerViewTime.frame.size.height/2 - labelheight/2, pickerViewTime.frame.size.width/4, labelheight)];
    xiaoshi.text = @"小时";
    xiaoshi.textColor = [UIColor whiteColor];
    xiaoshi.textAlignment = NSTextAlignmentCenter;
    UILabel *fenzhonghouguanbi = [[UILabel alloc] initWithFrame:CGRectMake(pickerViewTime.frame.size.width/2+33, pickerViewTime.frame.size.height/2 - labelheight/2, pickerViewTime.frame.size.width/2+10, labelheight)];
    fenzhonghouguanbi.text = @"分钟后关闭";
    fenzhonghouguanbi.textColor = [UIColor whiteColor];
    fenzhonghouguanbi.textAlignment = NSTextAlignmentCenter;
    [pickerViewTime addSubview:zai];
    [pickerViewTime addSubview:xiaoshi];
    [pickerViewTime addSubview:fenzhonghouguanbi];
    
    
    //底盘view
    //    _pickerButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT/2 + 15, DEVICE_WIDTH, DEVICE_HEIGHT/2 + 45)];
    [_pickerButtonView addSubview:pickerViewTime];
    _pickerButtonView.backgroundColor = Color_Bg_cellldarkblue;
    
    
    
    //取消按钮和存储按钮
    //    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancleButton.frame = CGRectMake(0, _pickerButtonView.frame.size.height-50, 100, 50);
    [_cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [_cancelButton addTarget:self action:@selector(pikerCancle) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIButton *savaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    savaButton.frame = CGRectMake(DEVICE_WIDTH - 100, _pickerButtonView.frame.size.height-50, 100, 50);
    [_savaBUtton setTitle:@"完成" forState:UIControlStateNormal];
    [_savaBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _savaBUtton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [_savaBUtton addTarget:self action:@selector(pikerSave) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIButton *cancelYYButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancelYYButton.frame = CGRectMake(_pickerButtonView.frame.size.width/2-50, _pickerButtonView.frame.size.height-50, 100, 50);
    [_cancelYYButton setTitle:@"取消设置" forState:UIControlStateNormal];
    [_cancelYYButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelYYButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [_cancelYYButton addTarget:self action:@selector(cancelYuyue) forControlEvents:UIControlEventTouchUpInside];
    
    self.CancelYuyueButton = _cancelYYButton;
    
    [_pickerButtonView addSubview:_cancelButton];
    [_pickerButtonView addSubview:_savaBUtton];
    [_pickerButtonView addSubview:_cancelYYButton];
    
    
    //    [self.view addSubview:_pickerButtonView];
    _pickerButtonView.hidden = YES;
    
    //调节风速
    _pickerView2.backgroundColor = Color_Bg_cellldarkblue;
    //    _pickerView2 = [[UIPickerView alloc]init];
    //    _pickerView2.frame = CGRectMake(0, _pickerView2.frame.origin.y, _pickerView2.frame.size.width, _pickerView2.frame.size.height);
    //    _pickerView2.frame = CGRectOffset(_pickerView2.frame, 50, 0);
    _pickerView2.showsSelectionIndicator = YES;
    _pickerView2.dataSource = self;
    _pickerView2.delegate = self;
    Winds = @[@"睡眠模式",@"风速1档",@"风速2档",@"风速3档",@"强风模式",@"智能模式"];
    _pickerView2.tag = 1;
    [_pickerView2 selectRow:1200/2 inComponent:0 animated:NO];
    
    //    [_pickerButtonView addSubview:_pickerView2];
    
    //    [_pickerView2 selectRow:[Winds count] inComponent:0 animated:YES];
    
    _windSelectLabel.text = @"智能模式";
    
    //滤网View
    filterView = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, (DEVICE_HEIGHT-64)/2, DEVICE_WIDTH, (DEVICE_HEIGHT-64)/2+20)];
    
    filterView.backgroundColor = FLYCO_DARK_BLUE;
    //            filterView.backgroundColor = [UIColor redColor];
    //滤网返回按钮
    UIButton *filterBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBackButton.frame = CGRectMake(0, filterView.frame.size.height - 30, 100, 30);
    [filterBackButton setTitle:@"返回" forState:UIControlStateNormal];
    [filterBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterBackButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [filterBackButton addTarget:self action:@selector(filterBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:filterBackButton];
    
    //重置滤网按钮
    filterResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterResetButton.frame = CGRectMake(filterView.frame.size.width - 100, filterView.frame.size.height - 30, 100, 30);
    [filterResetButton setTitle:@"重置滤网" forState:UIControlStateNormal];
    [filterResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterResetButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [filterResetButton addTarget:self action:@selector(filterResetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:filterResetButton];
    
    //滤网信息tableView
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -10, filterView.bounds.size.width, filterView.bounds.size.height - 30)];
    filterTableView.dataSource = self;
    filterTableView.delegate = self;
    filterTableView.backgroundColor = FLYCO_DARK_BLUE;
    filterTableView.allowsSelection = NO;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [filterTableView setTableFooterView:v];
    
    [filterView addSubview:filterTableView];
    
    
    [self.view addSubview:filterView];
    
    
    [self showRightButtonNormalImage:@"option" highLightImage:@"option" selector:@selector(myEdit)];
    
    //静默模式的view
    fkacManageDeviceViewController = [[FKACManageDeviceViewController alloc]initWithNibName:@"FKACManageDeviceViewController" bundle:nil];
    fkacManageDeviceViewController.mydelegate = self;
    //    if ([cleaner.powerSwitch isEqualToString:@"poweroff"]) {
    //        fkacManageDeviceViewController.quietModeSwitch.on = NO;
    //    }
    
    showStatus = 0;
    
    [self.view bringSubviewToFront:_pickerButtonView];
    
    //时间预约状态
    if ([cleaner.time_status isEqualToString:@"timeyes"]) {
        int time = cleaner.time_remaining.intValue;
        int hour = time / 60;
        int minite = time % 60;
        NSString *miniteString = [NSString stringWithFormat:@"%i",minite];
        if (minite < 10) {
            miniteString = [NSString stringWithFormat:@"0%i",minite];
        }
        
        _shutDownOrderLabel.text = [NSString stringWithFormat:@"倒计时%i:%@",hour,miniteString];
        
    } else {
        _shutDownOrderLabel.text = @"未设置";
        
    }

    
    //http请求的设置
    NSLog(@"初始化UI filterView坐标为%f,%f,%f,%f",filterView.frame.origin.x,filterView.frame.origin.y,filterView.frame.size.width,filterView.frame.size.height);
    
}


-(void)cancelYuyue{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消预约么？" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        progress.hidden = !progress.hidden;
        _pickerButtonView.hidden = YES;
        _shutDownOrderLabel.text = @"未设置";
        [self hideShadow];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
