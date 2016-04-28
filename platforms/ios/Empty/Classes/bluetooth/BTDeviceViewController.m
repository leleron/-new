//
//  BTDeviceViewController.m
//  BluetoothApp
//
//  Created by 信息部－研发 on 15/8/17.
//  Copyright (c) 2015年 信息部－研发. All rights reserved.
//

#import "BTDeviceViewController.h"
#import "AppDelegate.h"
#import "HTBodyfat.h"
#define WriteUUID @"FF01"
#define ReadUUID @"FF02"
#define ORDERTYPE @"6974637a"
#define RESPONSETYPE @"6974617a"
@interface BTDeviceViewController ()<HTBodyfatDelegate,CBPeripheralDelegate>
{
    float fWeight;
    float fHeight;
    NSInteger age;
    NSInteger impedanceCoefficient;
    HTSexType sex;
    HTPeopleType peopleType;
    BOOL isProvate;
}
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lblUUIDContent;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectStatus;
//@property (weak, nonatomic) IBOutlet UITableView *tableCharaceristics;
@property (weak, nonatomic) IBOutlet UILabel *lblWeightValue;
@property (weak, nonatomic) IBOutlet UIButton *btnGetWeight;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtAge;
@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblFatPctValue;
@property (weak, nonatomic) IBOutlet UILabel *lblFatUnderSkinValue;
@property (weak, nonatomic) IBOutlet UILabel *lblFatGutValue;
@property (weak, nonatomic) IBOutlet UILabel *lblWaterPctValue;
@property (weak, nonatomic) IBOutlet UILabel *lblMusclePctValue;
@property (weak, nonatomic) IBOutlet UILabel *lblBonePctValue;
@property (weak, nonatomic) IBOutlet UILabel *lblBaseMetabolismRateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyAgeValue;
@property (weak, nonatomic) IBOutlet UILabel *lblBMIValue;
//@property (weak, nonatomic) IBOutlet UILabel *lblHeartRateValue;
//@property (weak, nonatomic) IBOutlet UILabel *lblHeartOuputValue;
//@property (weak, nonatomic) IBOutlet UILabel *lblHeartIndexValue;
//@property (weak, nonatomic) IBOutlet UILabel *lblPeripheralResistValue;
//@property (weak, nonatomic) IBOutlet UILabel *lblComplianceValue;
@property (weak, nonatomic) IBOutlet UILabel *lblProteinValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPhysicalScoreValue;
@property (weak, nonatomic) IBOutlet UIButton *btnGetLast;

@property (weak, nonatomic) IBOutlet UITextView *textResult;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *lblXishu;
@property (weak, nonatomic) IBOutlet UILabel *lblRawData;

@property (strong, nonatomic) NSMutableArray *nCharaceristics;
@property (strong, nonatomic) NSString *strWeightValue;
@property (strong, nonatomic) NSString *strFatPctValue;
@property (strong, nonatomic) NSString *strFatUnderSkinValue;
@property (strong, nonatomic) NSString *strFatGutValue;
@property (strong, nonatomic) NSString *strWaterPctValue;
@property (strong, nonatomic) NSString *strMusclePctValue;
@property (strong, nonatomic) NSString *strBonePctValue;
@property (strong, nonatomic) NSString *strBaseMetabolismRateValue;
@property (strong, nonatomic) NSString *strBodyAgeValue;
@property (strong, nonatomic) NSString *strBMIValue;
//@property (strong, nonatomic) NSString *strHeartRateValue;
//@property (strong, nonatomic) NSString *strHeartOuputValue;
//@property (strong, nonatomic) NSString *strHeartIndexValue;
//@property (strong, nonatomic) NSString *strPeripheralResistValue;
//@property (strong, nonatomic) NSString *strComplianceValue;
@property (strong, nonatomic) IBOutlet UIButton *btnPrivate;
@property (strong, nonatomic) NSString *strProteinValue;
@property (strong, nonatomic) NSString *strPhysicalScoreValue;
@end

@implementation BTDeviceViewController

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self != nil) {
        self.curPeripheral = peripheral;
        self.curPeripheral.delegate = self;
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updatePeripheralState) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)viewDidLoad {
    self.navigationItem.title = self.curPeripheral.name;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblDeviceName.text = self.curPeripheral.name;
    self.lblUUIDContent.text = self.curPeripheral.identifier.UUIDString;
    NSString *strState = [[NSString alloc] init];
    switch (self.curPeripheral.state) {
        case CBPeripheralStateDisconnected:
            strState = @"Disconnected";
            break;
        case CBPeripheralStateConnecting:
            strState = @"Connecting";
            break;
        case CBPeripheralStateConnected:
            strState = @"Connected";
            break;
        default:
//            
            break;
    }
    self.lblConnectStatus.text = strState;
    isProvate = NO;
    self.nCharaceristics = [[NSMutableArray alloc] init];
    for (CBService *service in self.curPeripheral.services) {
        [self.curPeripheral discoverCharacteristics:nil forService:service];
    }
    [self.btnGetWeight addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    self.txtGender.delegate = self;
    self.txtAge.delegate = self;
    self.txtHeight.delegate = self;
    [self.btnGetLast addTarget:self action:@selector(getLastData) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPrivate addTarget:self action:@selector(getMacAddress) forControlEvents:UIControlEventTouchUpInside];
    
    for (CBService *service in self.curPeripheral.services) {
        [self.curPeripheral discoverCharacteristics:nil forService:service];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updatePeripheralState {
    if (self.curPeripheral.state != CBPeripheralStateConnected) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)saveData{
    fHeight = [self.txtHeight.text floatValue]/100;
    age = [self.txtAge.text integerValue];
}

- (void)sendDataToPeripheral {
    NSString *string = @"5ad2";//@"a501ffb3aa0000";
    NSMutableData *rawmeat = [NSMutableData data];
    [rawmeat appendData:[WpCommonFunction stringToData:string]];  //BYTE0 BYTE1
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    NSString* strTimeNow = [NSString stringWithFormat:@"%x",timeNow];
    strTimeNow = @"00000000";
    [rawmeat appendData:[WpCommonFunction stringToData:strTimeNow]];   //BYTE2-5
    NSString* strRetain = @"0000000000000000";
    [rawmeat appendData:[WpCommonFunction stringToData:strRetain]];   //BYTE6-13
    NSMutableArray* byteArray  = [[NSMutableArray alloc]init];
    Byte out = 0x00;
    for (int i = 1; i<14; i++) {
        NSData *temp = [rawmeat subdataWithRange:NSMakeRange(i, 1)];
//        NSLog(@"%x",temp);
        Byte *aa = (Byte*)[temp bytes];
        out ^=*aa;
    }
    [rawmeat appendBytes:&out length:1];                //BYTE14奇偶校验位
    [rawmeat appendData:[WpCommonFunction stringToData:@"aa"]];   //BYTE15帧尾
    
//    NSData *data = [AppDelegate appendCheckSum:rawmeat];
    for (CBCharacteristic *charateristic in self.nCharaceristics) {
        if ([charateristic.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]]) {
            [self.curPeripheral writeValue:rawmeat forCharacteristic:charateristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"Send %@",rawmeat);
        }
    }
    
}
#pragma mark 发送隐私模式指令
-(void)sendPrivateCode{
    
    NSString *string = @"5ac2";//@"a501ffb3aa0000";
    NSMutableData *rawmeat = [NSMutableData data];
    [rawmeat appendData:[WpCommonFunction stringToData:string]];  //BYTE0 BYTE1
    NSString* strTimeNow;
    if (isProvate == NO) {
        strTimeNow = @"01000000";
        isProvate = YES;
        [self.btnPrivate setTitle:@"正常模式" forState:UIControlStateNormal];
    }else{
        strTimeNow = @"02000000";
        isProvate = NO;
        [self.btnPrivate setTitle:@"隐私模式" forState:UIControlStateNormal];
    }
    [rawmeat appendData:[WpCommonFunction stringToData:strTimeNow]];   //BYTE2-5
    NSString* strRetain = @"0000000000000000";
    [rawmeat appendData:[WpCommonFunction stringToData:strRetain]];   //BYTE6-13
    NSMutableArray* byteArray  = [[NSMutableArray alloc]init];
    Byte out = 0x00;
    for (int i = 1; i<14; i++) {
        NSData *temp = [rawmeat subdataWithRange:NSMakeRange(i, 1)];
        //        NSLog(@"%x",temp);
        Byte *aa = (Byte*)[temp bytes];
        out ^=*aa;
    }
    [rawmeat appendBytes:&out length:1];                //BYTE14奇偶校验位
    [rawmeat appendData:[WpCommonFunction stringToData:@"aa"]];   //BYTE15帧尾
    
//    NSData *data = [AppDelegate appendCheckSum:rawmeat];
    for (CBCharacteristic *charateristic in self.nCharaceristics) {
        if ([charateristic.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]]) {
            [self.curPeripheral writeValue:rawmeat forCharacteristic:charateristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"Send %@",rawmeat);
        }
    }

}

-(void)getMacAddress{
    NSMutableData* sendData = [NSMutableData data];
    [sendData appendData:[WpCommonFunction stringToData:ORDERTYPE]];
    NSString* tCommand = @"0010";
    NSString* packetLength = @"00";
    NSString* checkSum = @"0000";
    [sendData appendData:[WpCommonFunction stringToData:tCommand]];
    [sendData appendData:[WpCommonFunction stringToData:packetLength]];
    [sendData appendData:[WpCommonFunction stringToData:checkSum]];
    for (CBCharacteristic *charateristic in self.nCharaceristics) {
        if ([charateristic.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]]) {
            [self.curPeripheral writeValue:sendData forCharacteristic:charateristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"Send %@",sendData);
            break;
        }
    }
}

- (void)queryForAllIndex {
    NSString *string = @"a5010000000000";
    NSData *data = [WpCommonFunction stringToData:string];
    for (CBCharacteristic *charateristic in self.nCharaceristics) {
        if ([charateristic.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]]) {
            [self.curPeripheral writeValue:data forCharacteristic:charateristic type:CBCharacteristicWriteWithResponse];
        }
    }
}
- (void) getLastData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.lblWeightValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"weight"]];
    self.lblFatPctValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"fatPct"]];
    self.lblFatUnderSkinValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"fatUnderSkin"]];
    self.lblFatGutValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"fatGut"]];
    self.lblWaterPctValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"waterPct"]];
    self.lblMusclePctValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"musclePct"]];
    self.lblBonePctValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"bonePct"]];
    self.lblBaseMetabolismRateValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"baseMetabolismRate"]];
    self.lblBodyAgeValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"bodyAge"]];
    self.lblBMIValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"BMI"]];
    self.lblProteinValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"protein"]];
    self.lblPhysicalScoreValue.text = [NSString stringWithFormat:@"%.1f", [userDefault floatForKey:@"physicalScore"]];
}

#pragma mark PeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"服务：%@",service.UUID);
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        //发现特征
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF01"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF02"]]) {
            NSLog(@"监听：%@",characteristic);//监听特征
            BOOL isContitan = NO;
            for (CBCharacteristic* item in self.nCharaceristics) {
                if ([item.UUID isEqual:characteristic.UUID]) {
                    isContitan = YES;
                }
            }
            if (!isContitan) {
                [self.nCharaceristics addObject:characteristic];
                [self.curPeripheral readValueForCharacteristic:characteristic];
                [self.curPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        
    }
//    [self.tableCharaceristics reloadData];
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"收到的数据：%@",characteristic.value);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (userDefault == nil) {
        return;
    }
    NSString* mark = [WpCommonFunction getIndexFromData:characteristic.value ByIndex:1];
    NSString* mark2 = [WpCommonFunction getIndexFromData:characteristic.value ByIndex:15];
    if ([mark isEqualToString:@"d2"] && [mark2 isEqualToString:@"aa"]) {     //稳定的体重数据
        self.lblRawData.text = [NSString stringWithFormat:@"%@",characteristic.value];
        NSString* weight1 = [WpCommonFunction getIndexFromData:characteristic.value ByIndex:7];
        NSString* unit = [weight1 substringToIndex:1];
        NSString* weightHigh = [weight1 substringFromIndex:1];
        NSString* weightLow = [WpCommonFunction getIndexFromData:characteristic.value ByIndex:8];
        NSString* weight = [NSString stringWithFormat:@"%@%@",weightHigh,weightLow];
        float mac1 =  strtoul([weight UTF8String], 0, 16);
        if (!mac1 == 0) {                       //记录体重不为0的数据
            [self sendDataToPeripheral];
            if ([unit isEqualToString:@"0"]) {
                fWeight = mac1/10;
            }
            if ([unit isEqualToString:@"4"]) {
                fWeight = mac1/20;
            }
        }
        if (!fWeight == 0) {
            NSLog(@"稳定的体重数据的数据：%@",characteristic.value);
            NSString* zukang1 = [WpCommonFunction getIndexFromData:characteristic.value ByIndex:9];
            NSString* zukang2 = [WpCommonFunction getIndexFromData:characteristic.value ByIndex:10];
            NSString* zukang3 = [WpCommonFunction getIndexFromData:characteristic.value ByIndex:11];
            NSString* zukang = [NSString stringWithFormat:@"%@%@%@",zukang1,zukang2,zukang3];
            float mac2 =  strtoul([zukang UTF8String], 0, 16);
            impedanceCoefficient = mac2;
            NSLog(@"%ld",(long)impedanceCoefficient);
            [self getBodyData];
        }
    }
//    NSString *str = [AppDelegate getWeirghtFromWeight:characteristic.value];
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    NSLog(@"Receive %@", characteristic.value);
//    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(queryForAllIndex) userInfo:nil repeats:NO];
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)getBodyData{
    HTBodyfat *bodyfat = [[HTBodyfat alloc]initWithDelegate:self];
    
    HTPeopleModel *peopleModel = [HTPeopleModel new];
    peopleModel.weight = fWeight;
    peopleModel.height = fHeight;
    peopleModel.age = age;
    peopleModel.impedanceCoefficient = impedanceCoefficient;
    peopleModel.sex = HTSexTypeMale;
    peopleModel.peopleType = HTPeopleTypeMental;
//    peopleModel.weight = 60;
//    peopleModel.height = 1.7;
//    peopleModel.age = 25;
//    peopleModel.sex = HTSexTypeMale;
//    peopleModel.impedanceCoefficient = 2755;
//    peopleModel.peopleType = HTPeopleTypeMental;
    HTBodyfatModel *bodyModel = [bodyfat getBodyfatForPeople:peopleModel];
    if (bodyModel) {
        self.lblWeight.text = [NSString stringWithFormat:@"%.2f",fWeight];
        self.lblXishu.text = [NSString stringWithFormat:@"%ld",(long)impedanceCoefficient];
        NSString* result = [NSString stringWithFormat:@"阻抗=%.1fΩ, BMI=%.1f, BMR=%ld, 内脏脂肪=%ld, 骨量=%.1fkg, 脂肪率=%.1f%%, 水分=%.1f%%, 肌肉=%.1f%%\r",bodyModel.impedance, bodyModel.bmiValue,(long)bodyModel.bmrValue,(long)bodyModel.visceralValue,bodyModel.boneValue,bodyModel.bodyfatPercentage,bodyModel.waterPercentage,bodyModel.musclePercentage];
        self.textResult.text = result;
        NSLog(@"测试结果为：%@",result);
    }
}

#pragma mark - HTBodyfatDelegate代理

//输入数据有误时触发
- (void)bodyfat:(HTBodyfat *)bodyfat people:(HTPeopleModel *)peopleModel catchError:(HTError *)error{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.txtAge resignFirstResponder];
    [self.txtGender resignFirstResponder];
    [self.txtHeight resignFirstResponder];
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
