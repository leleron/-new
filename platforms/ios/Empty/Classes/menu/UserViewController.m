//
//  UserViewController.m
//  Empty
//
//  Created by 李荣 on 15/5/12.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "UserViewController.h"
#import "ItemListSection.h"
#import "listEntity.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "UserInfo.h"
#import "UserInfoViewController.h"
#import "Constant.h"
#import "SystemSetViewController.h"
#import "AfterSaleViewController.h"
#import "EASYLINK.h"
#import "MessageCenterViewController.h"
#import "messageMock.h"
#import "ServiceViewController.h"
#import "getMessageCountMock.h"
@interface UserViewController ()
{
    EASYLINK *easylink_config;
    UIAlertView *alert;

}
//@property (strong, nonatomic)  UIButton *btnLogin;   //头像点击按钮
@property(strong,nonatomic)UIImageView* imgHead;
@property (strong, nonatomic)  UILabel *labName;
@property (strong,nonatomic)   UILabel *hadLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserHeadImg;
@property (strong, nonatomic) messageMock *myMessageMock;
@property(strong,nonatomic)getMessageCountMock* messageCountMock;
@property (strong, nonatomic) NSString *myImgURL;
//@property (assign, nonatomic) NSUInteger unreadCount;
@end

@implementation UserViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"个人中心";
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"ItemListSection"] delegate:self backGroundClr:Color_Bg_cellldarkblue];
    
    listEntity* e0 = [listEntity entity];
    e0.tag = 0;
    [self.pAdaptor.pSources addEntity:e0 withSection:[HeadSection class]];

    
    QUFlatEntity* e1 = [QUFlatEntity entity];
    e1.tag = 1;
    e1.lineBottomColor = Color_Bg_celllightblue;
    [self.pAdaptor.pSources addEntity:e1 withSection:[QUFlatEmptySection class]];
    listEntity* e2 = [listEntity entity];
    e2.image = [UIImage imageNamed:@""];
    e2.title = @"消息中心";
    e2.tag = 2;
    e2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    e2.lineBottomColor = Color_Bg_celllightblue;
    [self.pAdaptor.pSources addEntity:e2 withSection:[ItemListSection class]];

    listEntity* e3 = [listEntity entity];
    e3.image = [UIImage imageNamed:@""];
    e3.title = @"服务反馈";
    e3.tag = 3;
    e3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e3.lineBottomColor = Color_Bg_celllightblue;
    [self.pAdaptor.pSources addEntity:e3 withSection:[ItemListSection class]];
    
    listEntity* e5 = [listEntity entity];
    e5.image = [UIImage imageNamed:@""];
    e5.title = @"系统设置";
    e5.tag = 4;
    e5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    e5.lineBottomColor = Color_Bg_celllightblue;
    [self.pAdaptor.pSources addEntity:e5 withSection:[ItemListSection class]];

    [self.pAdaptor notifyChanged];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUserInfo) name:@"updateHeadImg" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUserInfo) name:@"exitAccount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageNum) name:@"updateMessageNum" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUserInfo) name:@"updateNickName" object:nil];
//    [self loadUserInfo];
    
//    if( easylink_config == nil){
//        easylink_config = [[EASYLINK alloc]initWithDelegate:self];
//    }

    
    // Do any additional setup after loading the view from its nib.
}

-(void)initQuickMock{
    self.messageCountMock = [getMessageCountMock mock];
    self.messageCountMock.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateMessageNum];
}

- (void)updateMessageNum {
    messageParam* param = [messageParam param];
    param.sendMethod = @"GET";
    UserInfo* info = [UserInfo restore];
    if (info) {
        NSLog(@"%@", info.tokenID);
//        [self.myMessageMock run:param];
        [self.messageCountMock run:param];
    } else {
        UITableViewCell *messageCell = [self.pAdaptor.pTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        for (UIView *subView in messageCell.subviews) {
            if (subView.tag == 111 || subView.tag == 222) {
                [subView removeFromSuperview];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [WpCommonFunction showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadUserInfo{
//    [[ViewControllerManager sharedManager]showWaitView:self.view];
//    [WpCommonFunction getImageByUrl:headUrl];

    UserInfo* myUserInfo = [UserInfo restore];
    if (myUserInfo) {
        self.hadLogin.hidden = NO;
        if (![myUserInfo.headImg isEqualToString:@""] && myUserInfo.headImg != nil) {
            UIImage* imgHead = [[WHGlobalHelper shareGlobalHelper]get:USER_TOUXIANG];
            if (!imgHead) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"Request at %@",[NSDate date]);
                    self.myImgURL = myUserInfo.headImg;
                    UIImage* img = [WpCommonFunction getImageByUrl:myUserInfo.headImg andSaveForKey:USER_TOUXIANG];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UserInfo* myUserInfo = [UserInfo restore];
                        if ([self.myImgURL isEqualToString:myUserInfo.headImg]) {
                            self.imgHead.image = img;
                        }
//                        self.imgHead.image = img;
                    });
                });
            }
            else{
                UIImage* imgHead = [[WHGlobalHelper shareGlobalHelper]get:USER_TOUXIANG];
                
//                [self.btnLogin setImage:imgHead forState:UIControlStateNormal];
                self.imgHead.image = imgHead;
            }
        }else{
//            [self.btnLogin setImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateNormal];
            self.imgHead.image = [UIImage imageNamed:@"headImage"];
        }
        if (myUserInfo.nickName) {
            self.labName.text = myUserInfo.nickName;
        }else
            self.labName.text = myUserInfo.phoneNum;
    }else{
//        [self.btnLogin setImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateNormal];
        self.imgHead.image = [UIImage imageNamed:@"headImage"];
        self.labName.text = @"登录/注册";
        self.hadLogin.hidden = YES;
    }
//    [self.btnLogin addTarget:self action:@selector(clickHead) forControlEvents:UIControlEventTouchUpInside];
    
//    [WpCommonFunction setView:self.btnLogin cornerRadius:self.btnLogin.frame.size.height/2];

//    [[ViewControllerManager sharedManager]hideWaitView];
}

//-(void)setHead:(UIImage*)image{
//    self.btnLogin setim
//}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    if ([section isKindOfClass:[QUFlatEmptySection class]]) {
        QUFlatEmptySection* s = (QUFlatEmptySection*)section;
        s.backgroundColor = Color_Bg_cellldarkblue;
//        s.frame = CGRectMake(s.frame.origin.x, s.frame.origin.y, s.frame.size.width, 50);
    }
    
    if ([section isMemberOfClass:[ItemListSection class]]) {
        listEntity* e = (listEntity*)entity;
        ItemListSection* s = (ItemListSection*)section;
        s.imgIcon.image = e.image;
        s.lblTitle.text = e.title;
        s.lblTitle.textColor = [UIColor whiteColor];
        if (e.tag == 2) {
            s.imgIcon.image = [UIImage imageNamed:@"xxzx"];
        }
        if (e.tag == 3) {
            s.imgIcon.image = [UIImage imageNamed:@"shfw"];
        }
        if (e.tag == 4) {
            s.imgIcon.image = [UIImage imageNamed:@"xtsz"];
            s.imgLine.hidden = YES;
        }
//        if (e.tag % 2 != 0 ) {
//            s.backgroundColor = Color_Bg_celllightblue;
//        } else {
//            s.backgroundColor = Color_Bg_cellldarkblue;
//        }
    }
    if ([section isMemberOfClass:[HeadSection class]]) {
        HeadSection* s = (HeadSection*)section;
//        s.backgroundColor = Color_Bg_celllightblue;
//        self.btnLogin = s.btnHead;
        self.imgHead = s.imgHead;
        
//        self.btnLogin = s.btnHead;
//        self.imgHead = s.imgHead;
        self.imgHead = s.imgHead;
        self.labName = s.lblNickName;
        self.hadLogin = s.lblHadLogin;
        [self loadUserInfo];
//        [WpCommonFunction setView:s.btnHead cornerRadius:s.btnHead.frame.size.height/2];
        [WpCommonFunction setView:s.imgHead cornerRadius:s.imgHead.frame.size.height/2];
//        CGFloat radius = self.btnLogin.imageView.frame.size.height/2;
//        [WpCommonFunction setView:self.btnLogin cornerRadius:radius];
        CGFloat radius = s.imgHead.frame.size.height/2;
        [WpCommonFunction setView:s.imgHead cornerRadius:radius];
//        [WpCommonFunction setView:s.imgHead cornerRadius:s.imgHead.frame.size.height/2];

//        s.btnHead.clipsToBounds = YES;
//        s.imgHead.clipsToBounds = YES;
    }
}

-(void)configUserInfo{
    
}

-(void)clickHead{
    
    UserInfo* myUserInfo = [UserInfo restore];
    if (myUserInfo) {
        [WpCommonFunction hideTabBar];
        UserInfoViewController* controller = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
//        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [WpCommonFunction hideTabBar];
    LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    UserInfo *myUserInfo = [UserInfo restore];
    listEntity* e = (listEntity*)entity;
    if (e.tag == 4) {
        SystemSetViewController* controller = [[SystemSetViewController alloc]initWithNibName:@"SystemSetViewController" bundle:nil];
        [WpCommonFunction hideTabBar];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (e.tag == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoShop" object:nil];
//        [self press];
        
    }
    if (e.tag == 0) {
        [self clickHead];
    }
    if (e.tag == 3) {
        ServiceViewController* controller = [[ServiceViewController alloc]initWithNibName:@"ServiceViewController" bundle:nil];
        [WpCommonFunction hideTabBar];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (e.tag == 2) {
        if (myUserInfo.tokenID == nil || [myUserInfo.tokenID isEqualToString:@""]) {
            [WpCommonFunction hideTabBar];
            LoginViewController* controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            MessageCenterViewController* controller = [[MessageCenterViewController alloc]initWithNibName:@"MessageCenterViewController" bundle:nil];
            [WpCommonFunction hideTabBar];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void) QUMock:(QUMock *)mock entity:(QUEntity *)entity {
    if ([mock isKindOfClass:[getMessageCountMock class]]) {
        messageEntity* e = (messageEntity*)entity;
        if ([e.status isEqualToString:@"SUCCESS"]) {
            NSUInteger unreadCount = 0;
//            for (NSDictionary *item in e.result) {
//                NSString *status = [item objectForKey:@"messageStatus"];
//                if ([status isEqualToString:@"0"]) {
//                    unreadCount ++;
//                }
//            }
            unreadCount = [e.count integerValue];
            UITableViewCell *messageCell = [self.pAdaptor.pTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            if (unreadCount > 0) {
                UIImage *imgRedDot = [UIImage imageNamed:@"redPoint"];
                UIImageView *redDot = [[UIImageView alloc] initWithImage:imgRedDot];
                
                redDot.frame = CGRectMake(messageCell.frame.origin.x + messageCell.frame.size.width - 60.0f - imgRedDot.size.width/2.0f, messageCell.frame.size.height/2.0f - imgRedDot.size.height*0.6/2.0, imgRedDot.size.width*0.6, imgRedDot.size.height*0.6);
                [messageCell addSubview:redDot];
                [redDot setTag:111];
                UILabel *unreadNum = [[UILabel alloc] initWithFrame:redDot.frame];
                unreadNum.textAlignment = NSTextAlignmentCenter;
                unreadNum.textColor = [UIColor whiteColor];
                unreadNum.text = [NSString stringWithFormat:@"%lu", (unsigned long)unreadCount];
                [messageCell addSubview:unreadNum];
                [unreadNum setTag:222];
            } else {
                for (UIView *subView in messageCell.subviews) {
                    if (subView.tag == 111 || subView.tag == 222) {
                        [subView removeFromSuperview];
                    }
                }
            }
        }
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
