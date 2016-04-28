//
//  TryAirCleanerViewController.m
//  Empty
//
//  Created by duye on 15/9/25.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "TryAirCleanerViewController.h"


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

@end

@implementation TryAirCleanerViewController{
    ProgressView *progress;
    NSArray *hours;
    NSArray *minites;
    NSDictionary *pickerDictionary;
    UIPickerView *pickerView;
    UIView *pickerButtonView;
    UIView *filterView;
    NSTimer *uiUpdateTimer;
    
    //滤网tableView
    UITableView *filterTableView;
    
    //显示状态
    int showStatus;
}

@synthesize cleaner;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    // Do any additional setup after loading the view.
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initUI];
    }
    
    return self;
}


//时间预约
- (IBAction)shutDownOrder:(id)sender {
    
    if ([cleaner.time_status isEqualToString:@"timeno"]) {
        pickerButtonView.hidden = NO;
    } else {
        //alertView
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消预约么？" preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            cleaner.time_status = @"timeno";
            [self updateUI];
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    [self updateUI];
}

//风速调节
- (IBAction)windSelect:(id)sender {
    //初始化风速的弹出菜单
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithTitle:@"智能模式"],
                       [[RNGridMenuItem alloc] initWithTitle:@"1档"],
                       [[RNGridMenuItem alloc] initWithTitle:@"睡眠模式"],
                       [[RNGridMenuItem alloc] initWithTitle:@"2档"],
                       [[RNGridMenuItem alloc] initWithTitle:@"强劲模式"],
                       [[RNGridMenuItem alloc] initWithTitle:@"3档"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, items.count)]];
    av.delegate = self;
    float width = DEVICE_WIDTH/3;
    float height = width/3;
    float fontSize = height/2;
    av.itemFont = [UIFont systemFontOfSize:fontSize];
    av.itemSize = CGSizeMake(width, height);
    av.menuStyle = RNGridMenuStyleGrid;
    av.backgroundColor = FLYCO_DARK_BLUE;
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, fontSize*2)];
    header.text = @"风速选择";
    header.font = [UIFont systemFontOfSize:fontSize + 1];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    av.headerView = header;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
//灯效
- (IBAction)lightEffect:(id)sender {
    NSString *title = _lightEffect.titleLabel.text;
    if ([title isEqualToString:@"lighton"]) {
        cleaner.light_status = @"lighthalfon";
    } else if([title isEqualToString:@"lighthalfon"]){
        cleaner.light_status = @"lightoff";
    } else if([title isEqualToString:@"lightoff"]){
        cleaner.light_status = @"lighton";
    } else {
        NSLog(@"不存在的灯效");
    }
    [self updateUI];
}

//滤网
- (IBAction)filter:(id)sender {
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
    if ([cleaner.anionSwitch isEqualToString:@"anionon"]) {
        cleaner.anionSwitch = @"anionoff";
    } else {
        cleaner.anionSwitch = @"anionon";
    }
    [self updateUI];
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
    return 5;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return hours.count;
            break;
        case 1:
            return minites.count;
            break;
        default:
            return 1;
            break;
    }
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [hours objectAtIndex:row];
            break;
        case 1:
            return [minites objectAtIndex:row];
            break;
        default:
            return @"";
            break;
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return DEVICE_WIDTH/2;
            break;
        case 1:
            return DEVICE_WIDTH/2;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = [[UILabel alloc] init];
    myView.font = [UIFont systemFontOfSize:26];
    myView.textColor = [UIColor whiteColor];
    myView.backgroundColor = [UIColor clearColor];
    if (component == 0) {
        myView.text = [hours objectAtIndex:row];
        myView.textAlignment = NSTextAlignmentCenter;
    }else {
        myView.text = [minites objectAtIndex:row];
        myView.textAlignment = NSTextAlignmentLeft;
    }
    return myView;
}

-(void)pickerView:(UIPickerView *)pickerViewt didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    如果选取的是第一个选取器
    if (component == 0) {
        //        得到第一个选取器的当前行
        NSString *selectedState =[hours objectAtIndex:row];
        
        //        根据从pickerDictionary字典中取出的值，选择对应第二个中的值
        NSArray *array = [pickerDictionary objectForKey:selectedState];
        minites=array;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        
        //        重新装载第二个滚轮中的值
        [pickerView reloadComponent:1];
    }
}

//点击取消
-(void)pikerCancle{
    pickerButtonView.hidden = YES;
}
//点击存储
-(void)pikerSave{
    pickerButtonView.hidden = YES;
    cleaner.time_status = @"timeyes";
    NSString *h = [hours objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *m = [minites objectAtIndex:[pickerView selectedRowInComponent:1]];
    cleaner.time_remaining = [NSString stringWithFormat:@"%i",h.intValue * 60 + m.intValue];
    [self updateUI];
}

//中间的圆圈滑动时发生UI变化
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
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
}


- (void)filterResetButtonClicked:(UIButton*)resetButton{
    if (filterTableView.editing) {
        [resetButton setTitle:@"重置" forState:UIControlStateNormal];
        filterTableView.editing = NO;
    } else {
        [resetButton setTitle:@"完成" forState:UIControlStateNormal];
        filterTableView.editing = YES;
    }
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
                cell.remainDay.textColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:34  /255.0 alpha:1.0];
            }
            else {
                cell.remainDay.text = [NSString stringWithFormat:@"%i",cleaner.filterThreeSwitch.intValue / 24];
                cell.timeUnitLabel.text = @"天";
                cell.remainDay.textColor = [UIColor colorWithRed:0/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
                
            }
            cell.filterType.text = @"过滤网3：除甲醛滤网";
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
    if (cleaner.light_status) {
        _lightEffect.titleLabel.text = cleaner.light_status;
        [_lightEffect setImage:[UIImage imageNamed:_lightEffect.titleLabel.text] forState:UIControlStateNormal];
    } else {
        _lightEffect.titleLabel.text = @"lightoff";
        [_lightEffect setImage:[UIImage imageNamed:_lightEffect.titleLabel.text] forState:UIControlStateNormal];
    }
    
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
                        unit = @"良";
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
                        value = @"良";
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
    if ([cleaner.anionSwitch isEqualToString:@"anionon"]) {
        _ionCleanLabel.text = @"已开启";
    } else if ([cleaner.anionSwitch isEqualToString:@"anionoff"]){
        _ionCleanLabel.text = @"未开启";
    } else {
        _ionCleanLabel.text = @"状态不明";
    }
    
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
    
    //风速调节
    if ([cleaner.runningMode isEqualToString:@"auto"]) {
        _windSelectLabel.text = @"智能模式";
    } else if ([cleaner.runningMode isEqualToString:@"sleep"]){
        _windSelectLabel.text = @"睡眠模式";
    } else if ([cleaner.runningMode isEqualToString:@"strong"]){
        _windSelectLabel.text = @"强劲模式";
    } else if ([cleaner.runningMode isEqualToString:@"one"]){
        _windSelectLabel.text = @"1档";
    } else if ([cleaner.runningMode isEqualToString:@"two"]){
        _windSelectLabel.text = @"2档";
    } else if ([cleaner.runningMode isEqualToString:@"three"]){
        _windSelectLabel.text = @"3档";
    } else {
        NSLog(@"不存在的模式");
    }
    
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
    cleaner.powerSwitch = @"poweron";
    cleaner.light_status = @"lighton";
    cleaner.outdoor_pm = @"88";
    cleaner.location = @"上海市杨浦区";
    cleaner.pmValue = @"177";
    cleaner.aqiStatus = @"2";
    cleaner.humidity = @"87";
    cleaner.temperature = @"30";
    cleaner.voc = @"3";
    cleaner.runningMode = @"auto";
    cleaner.time_status = @"timeno";
    cleaner.filterOneSwitch = @"99";
    cleaner.filterTwoSwitch = @"100";
    cleaner.filterThreeSwitch = @"0";
    
    //圆形进度条
    float progress_height = DEVICE_HEIGHT / 2 - 70;
    float progress_width = progress_height;
    
    
    progress = [[ProgressView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH / 2 - progress_width / 2, DEVICE_HEIGHT / 2 + 30, progress_width, progress_height)];
    progress.arcFinishColor = GOODCOLOR;
    progress.arcBackColor = [UIColor colorWithRed:111.0f/255 green:111.0f/255 blue:111.0f/255 alpha:1];
    progress.centerColor = FLYCO_DARK_BLUE;
    progress.delegate = self;
    [self.view addSubview:progress];
    
    
    //时间预约的picker
    pickerView = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
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
    
    
    pickerView.backgroundColor = FLYCO_DARK_BLUE;;
    float labelheight = 30;
    UILabel *zai = [[UILabel alloc] initWithFrame:CGRectMake(0, pickerView.frame.size.height/2 - labelheight/2, pickerView.frame.size.width/4, labelheight)];
    zai.text = @"   在";
    zai.textColor = [UIColor whiteColor];
    zai.textAlignment = NSTextAlignmentCenter;
    UILabel *xiaoshi = [[UILabel alloc] initWithFrame:CGRectMake(pickerView.frame.size.width/3, pickerView.frame.size.height/2 - labelheight/2, pickerView.frame.size.width/4, labelheight)];
    xiaoshi.text = @"小时";
    xiaoshi.textColor = [UIColor whiteColor];
    xiaoshi.textAlignment = NSTextAlignmentCenter;
    UILabel *fenzhonghouguanbi = [[UILabel alloc] initWithFrame:CGRectMake(pickerView.frame.size.width/2 + 40, pickerView.frame.size.height/2 - labelheight/2, pickerView.frame.size.width/2, labelheight)];
    fenzhonghouguanbi.text = @"分钟后关闭";
    fenzhonghouguanbi.textColor = [UIColor whiteColor];
    fenzhonghouguanbi.textAlignment = NSTextAlignmentCenter;
    [pickerView addSubview:zai];
    [pickerView addSubview:xiaoshi];
    [pickerView addSubview:fenzhonghouguanbi];
    
    
    //底盘view
    pickerButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT/2 + 10, DEVICE_WIDTH, DEVICE_HEIGHT/2 + 40)];
    [pickerButtonView addSubview:pickerView];
    pickerButtonView.backgroundColor = FLYCO_DARK_BLUE;
    
    
    
    //取消按钮和存储按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, pickerView.frame.size.height + 30, 100, pickerButtonView.frame.size.height - pickerView.frame.size.height);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [cancleButton addTarget:self action:@selector(pikerCancle) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *savaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    savaButton.frame = CGRectMake(DEVICE_WIDTH - 100, pickerView.frame.size.height + 30, 100, pickerButtonView.frame.size.height - pickerView.frame.size.height);
    [savaButton setTitle:@"存储" forState:UIControlStateNormal];
    [savaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    savaButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [savaButton addTarget:self action:@selector(pikerSave) forControlEvents:UIControlEventTouchUpInside];
    
    [pickerButtonView addSubview:cancleButton];
    [pickerButtonView addSubview:savaButton];
    
    
    [self.view addSubview:pickerButtonView];
    pickerButtonView.hidden = YES;
    
    //滤网View
    filterView = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, DEVICE_HEIGHT/2 + 10, DEVICE_WIDTH, DEVICE_HEIGHT/2 + 10)];
    filterView.backgroundColor = FLYCO_DARK_BLUE;
    //            filterView.backgroundColor = [UIColor redColor];
    //滤网返回按钮
    UIButton *filterBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBackButton.frame = CGRectMake(0, filterView.frame.size.height - 50, 100, 50);
    [filterBackButton setTitle:@"返回" forState:UIControlStateNormal];
    [filterBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterBackButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [filterBackButton addTarget:self action:@selector(filterBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:filterBackButton];
    
    //重置滤网按钮
    UIButton *filterResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterResetButton.frame = CGRectMake(filterView.frame.size.width - 100, filterView.frame.size.height - 50, 100, 50);
    [filterResetButton setTitle:@"重置" forState:UIControlStateNormal];
    [filterResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterResetButton.titleLabel.font = [UIFont systemFontOfSize: 20];
    [filterResetButton addTarget:self action:@selector(filterResetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:filterResetButton];
    
    //滤网信息tableView
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, filterView.bounds.size.width, filterView.bounds.size.height - 50)];
    filterTableView.dataSource = self;
    filterTableView.delegate = self;
    filterTableView.backgroundColor = FLYCO_DARK_BLUE;
    filterTableView.allowsSelection = NO;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [filterTableView setTableFooterView:v];
    
    [filterView addSubview:filterTableView];
    
    
    [self.view addSubview:filterView];
    
    
    UIButton *optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    optionButton.frame = CGRectMake(0, 0, 38, 37);
    [optionButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:optionButton];
    
    showStatus = 0;
    
    
  
}
@end
