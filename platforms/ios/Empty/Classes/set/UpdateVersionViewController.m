//
//  UpdateVersionViewController.m
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "UpdateVersionViewController.h"
#import "versonUpdateMock.h"

@interface UpdateVersionViewController ()
@property(strong,nonatomic)versonUpdateMock* myUpdateMock;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property(strong,nonatomic)NSString* url;
@property(strong,nonatomic)NSString* version;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblNewestVersion;

@end

@implementation UpdateVersionViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"检查新版本";
    [super viewDidLoad];
    self.btnUpdate.hidden = YES;
    [self.btnUpdate addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    _version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.lblVersion.text = [NSString stringWithFormat:@"当前版本:%@",_version];
    [WpCommonFunction setView:self.btnUpdate cornerRadius:8];
    // Do any additional setup after loading the view from its nib.
}

-(void)initQuickMock{
    self.myUpdateMock = [versonUpdateMock mock];
    self.myUpdateMock.delegate = self;
    versonUpdateParam* param = [versonUpdateParam param];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    param.CURRENTVERSION = app_Version;
    param.APPTYPE = @"jiadian_ios";
    [self.myUpdateMock run:param];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[versonUpdateMock class]]) {
        versonEntity* e = (versonEntity*)entity;
        if ([e.status isEqualToString:@"NEW"]) {
            self.btnUpdate.hidden = NO;
            NSString* url = [e.theVerson objectForKey:@"downloadUrl"];
            self.url = url;
            //            WpCommonFunction
            //            NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
            //         NSDictionary* dic = [WpCommonFunction toArrayOrNSDictionary:data];
            //            NSString* url = [dic objectForKey:@"downloadUrl"];
            UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"升级" message:@"发现新版本" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            }];
            [controller addAction:action1];
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            self.lblNewestVersion.hidden = NO;
        }
    }

}


-(void)updateVersion{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
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
