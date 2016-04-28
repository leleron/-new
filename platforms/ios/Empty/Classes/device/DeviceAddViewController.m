//
//  DeviceAddViewController.m
//  扫地机器人以外的设备添加页面
//
//  Created by 杜晔 on 15/7/6.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "DeviceAddViewController.h"
#import "ESPUDPSocketClient.h"
#import "ESPUDPSocketServer.h"

//@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>
//
//@end
//
//@implementation EspTouchDelegateImpl
//
//-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
//{
//    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
//
//}
//
//@end

@interface DeviceAddViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wifilabel;
@property (weak, nonatomic) IBOutlet UITextField *pswTextView;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;





// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;

// without the condition, if the user tap confirm/cancel quickly enough,
// the bug will arise. the reason is follows:
// 0. task is starting created, but not finished
// 1. the task is cancel for the task hasn't been created, it do nothing
// 2. task is created
// 3. Oops, the task should be cancelled, but it is running
@property (nonatomic, strong) NSCondition *_condition;

@property (nonatomic, strong) UIButton *_doneButton;
//@property (nonatomic, strong) EspTouchDelegateImpl *_esptouchDelegate;

@end

@implementation DeviceAddViewController

@synthesize productModel;

- (id)initWithProductModel:(NSString*)proModel NibName:(NSString*)nibname{
    if ( self = [super initWithNibName:nibname bundle:nil] ){
        productModel = proModel;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self cancel];
}

- (void)viewDidLoad {
    self.navigationBarTitle = @"网络配置";
    [super viewDidLoad];
    NSDictionary *ifs =  [(AppDelegate *)[[UIApplication sharedApplication] delegate] fetchSSIDInfo];
    _wifilabel.text = [[ifs objectForKey:@"SSID"] lowercaseString];
    self.bssid = [[ifs objectForKey:@"BSSID"] lowercaseString];
    _pswTextView.keyboardType = UIKeyboardTypeASCIICapable;
    self._condition = [[NSCondition alloc]init];
    
    [WpCommonFunction setView:self.btnNext cornerRadius:8];

//    self._esptouchDelegate = [[EspTouchDelegateImpl alloc]init];
//    asyncUdpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
//    NSError *err = nil;
//    [asyncUdpSocket enableBroadcast:YES error:&err];
//    [asyncUdpSocket bindToPort:1025 error:&err];
//    [asyncUdpSocket receiveWithTimeout:-1 tag:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonClicked:(id)sender {
//    NSLog(@"nextButtonClicked");
    if ([productModel isEqualToString:@"31"]) {//乐鑫配网
//        [[ViewControllerManager sharedManager]showWaitView:self.view];
        
//        NSLog(@"ESPViewController do confirm action...");
//        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(queue, ^{
//            NSLog(@"ESPViewController do the execute work...");
//            // execute the task
//            NSArray *esptouchResultArray = [self executeForResults];
//            // show the result to the user in UI Main Thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
//                // check whether the task is cancelled and no results received
//                if (!firstResult.isCancelled)
//                {
//                    NSMutableString *mutableStr = [[NSMutableString alloc]init];
//                    NSUInteger count = 0;
//                    // max results to be displayed, if it is more than maxDisplayCount,
//                    // just show the count of redundant ones
//                    const int maxDisplayCount = 5;
//                    if ([firstResult isSuc])
//                    {
//                        
//                        for (int i = 0; i < [esptouchResultArray count]; ++i)
//                        {
//                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
//                            [mutableStr appendString:[resultInArray description]];
//                            [mutableStr appendString:@"\n"];
//                            count++;
//                            if (count >= maxDisplayCount)
//                            {
//                                break;
//                            }
//                        }
//                        
//                        if (count < [esptouchResultArray count])
//                        {
//                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
//                        }
//                        [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:mutableStr delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
//                    }
//                    
//                    else
//                    {
//                        [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:@"Esptouch fail" delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
//                    }
//                }
////                [[ViewControllerManager sharedManager] hideWaitView];
//                //这里进去昵称设置页面
//                NickNameSettingViewController *nickNameSettingViewController = [[NickNameSettingViewController alloc] initWithNibName:@"NickNameSettingViewController" bundle:nil];
//                nickNameSettingViewController.mac = firstResult.bssid;
//                nickNameSettingViewController.isNewDevice = YES;
//                [self.navigationController pushViewController:nickNameSettingViewController animated:YES];
//            });
//        });
//        ESPUDPSocketClient *socketClient = [[ESPUDPSocketClient alloc] init];
//        [socketClient sendDataWithBytesArray2:@[@"Are You Flyco IOT Smart Device?"] ToTargetHostName:@"255.255.255.255" WithPort:1025 andInterval:0.5f];
//        NSString *str = @"Are You Flyco IOT Smart Device?";
//        NSString *host = @"255.255.255.255";
//        int port = 1025;
//        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
//        [asyncUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
//        [asyncUdpSocket receiveWithTimeout:-1 tag:0];
        
//        [asyncUdpSocket sendData:data withTimeout:-1 tag:1];
//        ESPUDPSocketClient *client = [[ESPUDPSocketClient alloc] init];
//        ESPUDPSocketServer *server = [[ESPUDPSocketServer alloc] initWithPort:port AndSocketTimeout:600000];
//        [server receiveOneByte];
//        
//        [client sendDataWithBytesArray2:@[data] ToTargetHostName:host WithPort:port andInterval:200];
        
        
        
    } else {//其他配网
        
        
    }

}

#pragma mark - the example of how to cancel the executing task

- (void) cancel
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}

#pragma mark - the example of how to use executeForResults
- (NSArray *) executeForResults
{
    [self._condition lock];
    NSString *apSsid = _wifilabel.text;
    NSString *apPwd = _pswTextView.text;
    NSString *apBssid = self.bssid;
    BOOL isSsidHidden = NO;
    int taskCount = 1;
    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
    // set delegate
//    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    [self._condition unlock];
    NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}

#pragma mark - the example of how to use executeForResult

- (ESPTouchResult *) executeForResult
{
    [self._condition lock];
    NSString *apSsid = _wifilabel.text;
    NSString *apPwd = _pswTextView.text;
    NSString *apBssid = self.bssid;
    BOOL isSsidHidden = NO;
    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
    // set delegate
//    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    [self._condition unlock];
    ESPTouchResult * esptouchResult = [self._esptouchTask executeForResult];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResult);
    return esptouchResult;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_pswTextView resignFirstResponder];
}

// when user tap Enter or Return, disappear the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//#pragma mark - socket回调
//- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
//    NSLog(@"发送成功");
//}
//- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
//    NSLog(@"没发送成功");
//}
//- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
//    NSLog(@"收到数据");
//    NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
//    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    [asyncUdpSocket receiveWithTimeout:-1 tag:0];
//    return YES;
//}
//- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
//    NSLog(@"没收到数据");
//}
//- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
//    NSLog(@"断开连接");
//}

//- (NSString *)fetchSsid
//{
//    NSDictionary *ssidInfo = [self fetchNetInfo];
//    
//    return [ssidInfo objectForKey:@"SSID"];
//}
//
//- (NSString *)fetchBssid
//{
//    NSDictionary *bssidInfo = [self fetchNetInfo];
//    
//    return [bssidInfo objectForKey:@"BSSID"];
//}
//
//// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
//- (NSDictionary *)fetchNetInfo
//{
//    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
//    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
//    
//    NSDictionary *SSIDInfo;
//    for (NSString *interfaceName in interfaceNames) {
//        SSIDInfo = CFBridgingRelease(
//                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
//        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
//        
//        BOOL isNotEmpty = (SSIDInfo.count > 0);
//        if (isNotEmpty) {
//            break;
//        }
//    }
//    return SSIDInfo;
//}

@end
