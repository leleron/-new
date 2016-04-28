//
//  FKSetTimeViewController.m
//  Empty
//
//  Created by leron on 15/8/19.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKSetTimeViewController.h"
#import "FKSelectDateViewController.h"
#import "setAppointMock.h"
#import "getAppointmentTimeMock.h"
@interface FKSetTimeViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
{
    NSArray *hours;
    NSArray *minites;
    NSDictionary *pickerDictionary;

}
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectTime;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (strong,nonatomic) NSString* strShowDate;
@property (weak, nonatomic) IBOutlet UILabel *lblShow;
@property (strong,nonatomic) setAppointMock* myAppointMock;
@property(strong,nonatomic)getAppointmentTimeMock* myGetMock;
@end

@implementation FKSetTimeViewController



//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
////        [self.view setFrame:CGRectMake(0, 300, SCREEN_WIDTH, SCREEN_HEIGHT-300)];
//    }
//    
//}


- (void)viewDidLoad {
    self.navigationBarTitle = @"预约时间";
    [super viewDidLoad];
//    [self.datePicker setBackgroundColor:[UIColor clearColor]];
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    self.dateArray = [[NSMutableArray alloc]init];
    self.strShowDate = [NSString stringWithFormat:@""];
    [self.btnSelectTime addTarget:self action:@selector(gotoDate) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave addTarget:self action:@selector(saveDate) forControlEvents:UIControlEventTouchUpInside];
//    self.datePicker
    // Do any additional setup after loading the view from its nib.
    
    NSArray *minites_normal = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",
                                @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                                @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                                @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
                                @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
                                @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    pickerDictionary = @{@"00":minites_normal,
                         @"01":minites_normal,
                         @"02":minites_normal,
                         @"03":minites_normal,
                         @"04":minites_normal,
                         @"05":minites_normal,
                         @"06":minites_normal,
                         @"07":minites_normal,
                         @"08":minites_normal,
                         @"09":minites_normal,
                         @"10":minites_normal,
                         @"11":minites_normal,
                         @"12":minites_normal,
                         @"13":minites_normal,
                         @"14":minites_normal,
                         @"15":minites_normal,
                         @"16":minites_normal,
                         @"17":minites_normal,
                         @"18":minites_normal,
                         @"19":minites_normal,
                         @"20":minites_normal,
                         @"21":minites_normal,
                         @"22":minites_normal,
                         @"23":minites_normal,
};
    hours = [[pickerDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    minites = minites_normal;
    
    [self getAppointmentTime];
    
    
//    UILabel *fenzhonghouguanbi = [[UILabel alloc] initWithFrame:CGRectMake(_datePicker.frame.size.width/2+33, _datePicker.frame.size.height/2 - 30/2, _datePicker.frame.size.width/2+10, 30)];
//    fenzhonghouguanbi.text = @"开始打扫";
//    fenzhonghouguanbi.textColor = [UIColor whiteColor];
//    fenzhonghouguanbi.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:fenzhonghouguanbi];
}

-(void)getAppointmentTime{
    
    self.myGetMock = [getAppointmentTimeMock mock];
    self.myGetMock.delegate = self;
    getAppointmentTimeParam* param = [getAppointmentTimeParam param];
    param.sendMethod = @"GET";
    UserInfo* u = [UserInfo restore];
    self.myGetMock.operationType = [NSString stringWithFormat:@"/devices/%@/getAppointmentTime?tokenId=%@",self.cam.nsDeviceId,u.tokenID];
    [self.myGetMock run:param];
    
}
//- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        UILabel *fenzhonghouguanbi = [[UILabel alloc] initWithFrame:CGRectMake(self.datePicker.frame.size.width/2 + 40, self.datePicker.frame.size.height/2 - 30/2, self.datePicker.frame.size.width/2, 30)];
//        fenzhonghouguanbi.text = @"开始打扫";
//        fenzhonghouguanbi.textColor = [UIColor whiteColor];
//        fenzhonghouguanbi.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:fenzhonghouguanbi];
//
//    }
//    
//    return self;
//}



-(void)viewDidAppear:(BOOL)animated{
    self.strShowDate = [NSString stringWithFormat:@""];
    for (NSString* item in self.dateArray) {
        self.lblShow.hidden = YES;
        NSString* temp = [NSString stringWithFormat:@"%@ ",item];
        self.strShowDate = [self.strShowDate stringByAppendingString:temp];
    }
    self.lblTime.text = self.strShowDate;
    if (!self.strShowDate) {
        self.lblShow.hidden = NO;
    }
    [self.btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoDate{
    FKSelectDateViewController* controller = [[FKSelectDateViewController alloc]initWithNibName:@"FKSelectDateViewController" bundle:nil];
    controller.dateArray = self.dateArray;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)cancel{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveDate{
//    NSDate* date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    NSString *setHourStr = [NSString stringWithFormat:@"%@",[hours objectAtIndex:[self.datePicker selectedRowInComponent:0]]];
    NSString* setMinStr = [NSString stringWithFormat:@"%@",[minites objectAtIndex:[self.datePicker selectedRowInComponent:1]]];
//

    
        NSDate *now1 = [NSDate date];
        NSCalendar *calendar1 = [NSCalendar currentCalendar];
        NSUInteger unitFlags1 = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar1 components:unitFlags1 fromDate:now1];
    
        int year1 = [dateComponent year];
        int month = [dateComponent month];
        int day1 = [dateComponent day];
        int hour = [dateComponent hour];
        int minute = [dateComponent minute];
        int second = [dateComponent second];
    
    NSString* currentyearString = [NSString stringWithFormat:@"%d",year1];
    NSString* currentMonthString = [NSString stringWithFormat:@"%d",month];
    NSString *currentDateString = [NSString stringWithFormat:@"%d",day1];
    NSString *currentHourString = [NSString stringWithFormat:@"%d",hour];
    NSString *currentMinutesString = [NSString stringWithFormat:@"%d",minute];

    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger weak = [comps weekday];
    if (weak == 1) {
        weak = weak +6;
    }else{
        weak = weak -1;
    }

    
    
    setAppointParam* param = [setAppointParam param];
    param.monday = @"N";
    param.tuesday = @"N";
    param.thursday = @"N";
    param.friday = @"N";
    param.wednesday = @"N";
    param.saturday = @"N";
    param.sunday = @"N";
//    unsigned char day = 0x00;
    int day = 0;
    for (NSString* item in self.dateArray) {
        if ([item isEqualToString:@"星期一"] ) {
            day = day+2;
            param.monday = @"Y";
        }
        if([item isEqualToString:@"星期二"] ){
            day = day+4;
            param.tuesday = @"Y";
        }
        if([item isEqualToString:@"星期三"] ){
            day = day+8;
            param.wednesday = @"Y";
        }
        if([item isEqualToString:@"星期四"]){
            day = day+16;
            param.thursday = @"Y";
        }
        if([item isEqualToString:@"星期五"] ){
            day = day+32;
            param.friday = @"Y";
        }
        if([item isEqualToString:@"星期六"]){
            day = day+64;
            param.saturday = @"Y";
        }
        if([item isEqualToString:@"星期日"]){
            day = day+1;
            param.sunday = @"Y";
        }
    }
    if (day == 0) {
        day = pow(2, weak);
    }
    NSLog(@"%c",day);
    
    short year = [currentyearString integerValue];
    int setHourInt = [setHourStr intValue];
    int setMinInt = [setMinStr intValue];
    int curHourInt = [currentHourString intValue];
    int curMinInt = [currentMinutesString intValue];
    int curMonthInt = [currentMonthString intValue];
    int curDayInt = [currentDateString intValue];
    
    if (self.cam) {
        [self.cam setCleanTimeday:day hour:setHourInt minute:setMinInt curweek:weak curhour:curHourInt curminute:curMinInt cursecond:0 curYear:year curMonth:curMonthInt curDay:curDayInt];
        
//        [self.cam setCleanTimeday:8 hour0:0 hour1:0 hour2:0 hour3:9 hour4:0 hour5:0 hour6:0 minute0:0 minute1:0 minute2:0 minute3:55 minute4:0 minute5:0 minute6:0 curweek:3 curhour:9 curminute:53 cursecond:0 curyear:2015 curMonth:10 cunday:20];
//        [self.cam setCleanTimeday:16 hour:11 minute:47 curweek:4 curhour:11 curminute:46 cursecond:50 curYear:2015 curMonth:10 curDay:30];

        
    }
    
    
    self.myAppointMock = [setAppointMock mock];
    self.myAppointMock.delegate = self;
    UserInfo* u = [UserInfo restore];
    self.myAppointMock.operationType = [NSString stringWithFormat:@"/devices/%@/setAppointmentTime?tokenId=%@",self.cam.nsDeviceId,u.tokenID];
    param.isRepeated = @"Y";
    param.executeTime = [NSString stringWithFormat:@"%@:%@:00",setHourStr,setMinStr];
    [self.myAppointMock run:param];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[getAppointmentTimeMock class]]) {
        getAppointmentTimeEntity* e = (getAppointmentTimeEntity*)entity;
        if (!self.dateArray) {
            self.dateArray = [[NSMutableArray alloc]init];
        }
            if ([e.monday isEqualToString:@"Y"]) {
                [self.dateArray addObject:@"星期一"];
            }
            if ([e.tuesday isEqualToString:@"Y"]) {
                [self.dateArray addObject:@"星期二"];
            }
            if ([e.wednesday isEqualToString:@"Y"]) {
                [self.dateArray addObject:@"星期一"];
            }
            if ([e.thursday isEqualToString:@"Y"]) {
                [self.dateArray addObject:@"星期四"];
            }
            if ([e.friday isEqualToString:@"Y"]) {
                [self.dateArray addObject:@"星期五"];
            }
            if ([e.saturday isEqualToString:@"Y"]) {
                [self.dateArray addObject:@"星期六"];
            }
            if ([e.sunday isEqualToString:@"Y"]) {
                [self.dateArray addObject:@"星期日"];
            }
        if (self.dateArray.count != 0) {
            for (NSString* item in self.dateArray) {
                self.lblShow.hidden = YES;
                NSString* temp = [NSString stringWithFormat:@"%@ ",item];
                self.strShowDate = [self.strShowDate stringByAppendingString:temp];
            }
        }

    }
}

#pragma mark UIPickerViewDelegate

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
            return SCREEN_WIDTH/2;
            break;
        case 1:
            return SCREEN_WIDTH/2;
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
        [self.datePicker selectRow:0 inComponent:1 animated:YES];
        
        
        //        重新装载第二个滚轮中的值
        [self.datePicker reloadComponent:1];
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
