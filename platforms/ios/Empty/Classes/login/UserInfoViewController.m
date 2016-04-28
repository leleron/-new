//
//  UserInfoViewController.m
//  Empty
//
//  Created by leron on 15/6/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "loginTypeView.h"
#import "UserExitMock.h"
#import "updateUserInfoMock.h"
#import "NickNameSettingViewController.h"
#import "thirdPartyBindMock.h"
#import "WXAccessTokenMock.h"
#import "deleteFlycoMock.h"
#import "getFlycoMock.h"
@interface UserInfoViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblName;
//@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNum;
//@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
//@property (weak, nonatomic) IBOutlet UIView *viewFlycoAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnName;
@property (weak, nonatomic) IBOutlet UIButton *btnHead;
@property (weak, nonatomic) IBOutlet UIButton *btnExit;
//@property (strong,nonatomic) viewBindFlycoCount* bindFlycoCount;
@property (strong, nonatomic) ViewBindFlycoNew *bindFlycoNew;
@property(strong,nonatomic)viewThirdLogin* thirdLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong,nonatomic)UserExitMock* myExitMock;
@property (strong,nonatomic)updateUserInfoMock* myUpdateMock;
@property (strong,nonatomic)updateUserInfoParam* myUpdateparam;
@property(strong,nonatomic)thirdPartyBindMock* thirdPartyMock;   //第三方绑定飞科mock
@property(strong,nonatomic)WXAccessTokenMock* myWXTokenMock;    //获取微信token
//@property(strong,nonatomic)deleteFlycoMock* myDeleteFlycoMock;   //删除飞科账号
@property(strong,nonatomic)getFlycoMock* myGetFlycoMock;

@end



@implementation UserInfoViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"个人信息";
    self.navigationController.navigationBar.hidden = NO;
    [super viewDidLoad];
//    [self updateUserInfo];

    // Do any additional setup after loading the view from its nib.
//    self.bindFlycoCount =[QUNibHelper loadNibNamed:@"loginTypeView" ofClass:[viewBindFlycoCount class]];
    self.bindFlycoNew = [QUNibHelper loadNibNamed:@"loginTypeView" ofClass:[ViewBindFlycoNew class]];
    self.bindFlycoNew.frame = CGRectMake(0, self.lblTitle.frame.origin.y + 31, SCREEN_WIDTH, self.bindFlycoNew.bounds.size.height);

    [self.view addSubview:self.bindFlycoNew];
//    self.bindFlycoNew.hidden = YES;
    [self.btnExit addTarget:self action:@selector(exitCount) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnName addTarget:self action:@selector(updateName) forControlEvents:UIControlEventTouchUpInside];
    
    //设置圆形头像
    [WpCommonFunction setView:self.btnHead cornerRadius:self.btnHead.frame.size.height/2];
    
    //接受手机绑定成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bindFlycoAccount) name:LOGIN_PHONE_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWBUserInfo) name:LOGIN_WB_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWXUserInfo) name:LOGIN_WX_SUCCESS object:nil];

    
    //根据用户信息，显示不同的绑定信息
    UserInfo* myUserInfo = [UserInfo restore];
    if (myUserInfo) {
        if (![myUserInfo.headImg isEqualToString:@""] && myUserInfo.headImg != nil) {
//            NSData* userData = [NSData dataWithContentsOfURL:[NSURL URLWithString:myUserInfo.headImg]];
//            UIImage* headImg = [UIImage imageWithData:userData];
            UIImage* headImg = [[WHGlobalHelper shareGlobalHelper]get:USER_TOUXIANG];
            if (!headImg) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    UIImage* img = [WpCommonFunction getImageByUrl:myUserInfo.headImg andSaveForKey:USER_TOUXIANG];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.btnHead setImage:img forState:UIControlStateNormal];
                    });
                });
            }else{
                 [self.btnHead setImage:headImg forState:UIControlStateNormal];
            }
            [self.btnName setTitle:myUserInfo.phoneNum forState:UIControlStateNormal];
        } else {
            [self.btnHead setImage:[UIImage imageNamed:@"headImage"] forState:UIControlStateNormal];
        }
        
        if (myUserInfo.nickName) {
            [self.btnName setTitle:myUserInfo.nickName forState:UIControlStateNormal];
        }else{
            [self.btnName setTitle:myUserInfo.phoneNum forState:UIControlStateNormal];
        }
        
    if ([myUserInfo.userLoginType isEqualToString: LOGIN_PHONE]) {
        
        UIImage* headImg = [[WHGlobalHelper shareGlobalHelper]get:USER_TOUXIANG];
        if (headImg) {
            [self.btnHead setImage:headImg forState:UIControlStateNormal];
        }
        self.bindFlycoNew.hidden = YES;
//        self.viewFlycoAccount.hidden = YES;
        self.lblTitle.text = @"绑定第三方账户";
        self.thirdLogin = [QUNibHelper loadNibNamed:@"loginTypeView" ofClass:[viewThirdLogin class]];
        
//        if (iPhone4) {
//            self.thirdLogin.frame = CGRectMake(0, self.viewFlycoAccount.frame.origin.y-30, SCREEN_WIDTH, 202);
//        }else
            self.thirdLogin.frame = CGRectMake(0, self.lblTitle.frame.origin.y + 31, SCREEN_WIDTH, 150);
        [self.view addSubview:self.thirdLogin];
    }else{
        if (!myUserInfo.phoneNum) {
//            self.viewFlycoAccount.hidden = YES;
//            self.bindFlycoCount.hidden = NO;
//            self.bindFlycoNew.hidden = NO;
//            self.thirdLogin.hidden = YES;
        }else{
//            [self.btnDelete addTarget:self action:@selector(deleteFlycoCount) forControlEvents:UIControlEventTouchUpInside];
//            self.lblPhoneNum.text = myUserInfo.phoneNum;
        }
    }
        //只有在用手机登陆的时候才能修改头像
        if ([myUserInfo.userLoginType isEqualToString:LOGIN_PHONE]) {
            [self.btnHead addTarget:self action:@selector(pickHeadImg) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reLoadUserNickName) name:@"updateNickName" object:nil];
//    [self reLoadUserNickName];
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    delegate.topController = self;
    
//    if (self.btnName.bounds.size.width > self.btnHead.bounds.size.width) {
//        NSLayoutConstraint *oldConstraint = [NSLayoutConstraint constraintWithItem:self.btnName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.btnHead attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
//        for (NSLayoutConstraint *item in self.view.constraints) {
//            if ([WpCommonFunction compareConstaint:item toConstraint:oldConstraint]) {
//                [self.view removeConstraint:item];
//                [self.view.superview removeConstraint:item];
//            }
//        }
//    
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.btnHead attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
//    }
    
    NSLog(@"width = %f, height = %f",self.btnName.frame.size.width,self.btnName.frame.size.height);
    UserInfo *myUserInfo = [UserInfo restore];
    if (![myUserInfo.userLoginType isEqualToString:LOGIN_PHONE]) {
        if (myUserInfo.flycoNick != nil && ![myUserInfo.flycoNick isEqualToString:@""]) {
            self.bindFlycoNew.lblFlyco.text = myUserInfo.flycoNick;
            if (myUserInfo.flycoHead != nil && ![myUserInfo.flycoHead isEqualToString:@""]) {
                UIImage *img = [[WHGlobalHelper shareGlobalHelper]get:FLYCO_TOUXIANG];
                if (!img) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage* img = [WpCommonFunction getImageByUrl:myUserInfo.flycoHead andSaveForKey:FLYCO_TOUXIANG];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.bindFlycoNew.imgFlyco.image = img;
                        });
                    });
                } else {
                    self.bindFlycoNew.imgFlyco.image = img;
                }
            } else {
                self.bindFlycoNew.imgFlyco.image = [UIImage imageNamed:@"headImage"];
            }
            
            [self.bindFlycoNew.btnBind setTitle:@"解绑" forState:UIControlStateNormal];
        } else {
            [self updateUserInfo];
        }
    }
}

- (void)reLoadUserNickName {
    UserInfo *myUserInfo = [UserInfo restore];
    NSString *newNick = myUserInfo.nickName;
    [self.btnName setTitle:newNick forState:UIControlStateNormal];
/*    float temp1 = [newNick sizeWithFont:self.btnName.titleLabel.font].width;
    float temp2 = self.btnHead.frame.size.width;
    if (temp1 < temp2) {
        NSLayoutConstraint *oldConstraint = [NSLayoutConstraint constraintWithItem:self.btnName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.btnHead attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
        for (NSLayoutConstraint *item in self.view.constraints) {
            if ([WpCommonFunction compareConstaint:item toConstraint:oldConstraint]) {
                [self.view removeConstraint:item];
                [self.view.superview removeConstraint:item];
            }
        }
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.btnHead attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    } else {
        NSLayoutConstraint *oldConstraint = [NSLayoutConstraint constraintWithItem:self.btnName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.btnHead attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        for (NSLayoutConstraint *item in self.view.constraints) {
            if ([WpCommonFunction compareConstaint:item toConstraint:oldConstraint]) {
                [self.view removeConstraint:item];
                [self.view.superview removeConstraint:item];
            }
        }
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.btnName attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.btnHead attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
    }*/
}

-(void)initQuickMock{
    self.myUpdateMock = [updateUserInfoMock mock];
    self.myUpdateMock.delegate = self;
    self.myUpdateparam = [updateUserInfoParam param];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark 更新用户昵称
-(void)updateName{
    
    UserInfo* myUserInfo = [UserInfo restore];
    if ([myUserInfo.userLoginType isEqualToString:LOGIN_PHONE]) {
        NickNameSettingViewController* controller = [[NickNameSettingViewController alloc]initWithNibName:@"NickNameSettingViewController" bundle:nil];
        controller.oldNickName = self.btnName.titleLabel.text;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}



//绑定手机成功
-(void)bindFlycoAccount{
    [self updateUserInfo];
    UserInfo *info = [UserInfo restore];
    if (info) {
        self.bindFlycoNew.lblFlyco.text = info.phoneNum;
        [self.bindFlycoNew.btnBind setTitle:@"解绑" forState:UIControlStateNormal];
    }
}

-(void)bindWX{
    if (self.thirdLogin) {
        self.thirdLogin.btnAddWechat.titleLabel.text = @"解绑";
        [self.thirdLogin.btnAddWechat addTarget:self.thirdLogin action:@selector(delegateWX) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//删除飞科账号绑定
-(void)deleteFlycoCount{
    UserInfo* myUserInfo = [[WHGlobalHelper shareGlobalHelper]get:USER_INFO];
    myUserInfo.phoneNum = nil;
    myUserInfo.tokenID = nil;
    deleteFlycoParam* param = [deleteFlycoParam param];
    param.sendMethod = @"GET";
    [[ViewControllerManager sharedManager]showWaitView:self.view];
//    [self.myDeleteFlycoMock run:param];
}


-(void)pickHeadImg{
    
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"上传头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.mediaTypes = temp_MediaTypes;
            picker.delegate = self;
//            picker.allowsImageEditing = YES;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [controller addAction:action1];
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"从手机相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        UIImagePickerController* imgController = [[UIImagePickerController alloc]init];
            imgController.delegate = self;
        imgController.allowsEditing = YES;
        [self.navigationController presentViewController:imgController animated:YES completion:nil];
    }];
    [controller addAction:action2];
    
    UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
       
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [controller addAction:action3];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}


-(void)exitCount{
    self.myExitMock = [UserExitMock mock];
    self.myExitMock.delegate = self;
    UserExitParam* param = [UserExitParam param];
    UserInfo* myUserInfo = [UserInfo restore];
    param.TOKENID = myUserInfo.tokenID;
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [self.myExitMock run:param];
    [[WHGlobalHelper shareGlobalHelper]removeByKey:USER_TOUXIANG];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_INFO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHeadImg" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
}


-(void)updateUserHead:(UIImage*)img{
//    updateUserInfoParam* param = [updateUserInfoParam param];
    NSData* imgData = UIImageJPEGRepresentation(img,0.1);
    self.myUpdateparam.IMAGE = [WpCommonFunction transformImageDataToBase64String:imgData];
    self.myUpdateparam.sendMethod = @"PUT";
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [self.myUpdateMock run:self.myUpdateparam];
}

#pragma  mark QUMockDelegate
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[UserExitMock class]]) {
//        identifyEntity* e = (identifyEntity*)entity;
        [UserInfo deleteData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMessageNum" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
//    if ([mock isKindOfClass:[updateUserInfoMock class]]) {
////        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHeadImg" object:nil];
//    }
//    if ([mock isKindOfClass:[updateUserInfoMock class]]) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHeadImg" object:nil];
//    }
    
    if ([mock isKindOfClass:[WXAccessTokenMock class]]) {
        WXAccessTokenEntity* e = (WXAccessTokenEntity*)entity;
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.wxTokenID = e.access_token;
        myUserInfo.wxUserID = e.openid;
        myUserInfo.wxRefreshTokenID = e.refresh_token;
        [myUserInfo store];
        //        [self accessLoginToken];
//        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [self thirdLogin:@"wechat"];
        
    }

    
    if ([mock isKindOfClass:[thirdPartyBindMock class]]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"绑定成功"];
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([delegate.login_type isEqualToString:LOGIN_WEIBO]) {
            [self.thirdLogin.btnAddWeibo setTitle:@"解绑" forState:UIControlStateNormal];
        }
        if ([delegate.login_type isEqualToString:LOGIN_WECHAT]) {
            [self.thirdLogin.btnAddWechat setTitle:@"解绑" forState:UIControlStateNormal];
        }
        
        [self updateUserInfo];  //更新用户信息
        
    }
    
    if ([mock isKindOfClass:[deleteFlycoMock class]]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"解绑成功"];
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([delegate.login_type isEqualToString:LOGIN_WEIBO]) {
            UserInfo* myUserInfo = [UserInfo restore];
            myUserInfo.isBindWB = @"NO";
            [self.thirdLogin.btnAddWeibo setTitle:@"绑定" forState:UIControlStateNormal];
            [myUserInfo store];
        }
        if ([delegate.login_type isEqualToString:LOGIN_WECHAT]) {
            UserInfo* myUserInfo = [UserInfo restore];
            myUserInfo.isBindWX = @"NO";
            [self.thirdLogin.btnAddWechat setTitle:@"绑定" forState:UIControlStateNormal];
            [myUserInfo store];
        }

    }
    
    
    if ([mock isKindOfClass:[updateUserInfoMock class]]) {
        if (entity == nil) {
            [self updateUserInfo];
            return;
        }
        updateUserInfoEntity* e = (updateUserInfoEntity*)entity;
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.nickName = [e.result objectForKey:@"REAL_NAME"];
        NSString* headUrl = [e.result valueForKey:@"IMAGE"];
        if (![headUrl isEqualToString:@""] && headUrl != nil) {
            myUserInfo.headImg = headUrl;
        }
        myUserInfo.userName = [e.result valueForKey:@"USER_NAME"];
        NSArray* thridBind = [e.result objectForKey:@"OTHRE_USER_TO_THIS"];
        for (NSString* e in thridBind) {
            if ([e isEqualToString:@"qq"]) {
                myUserInfo.isBindQQ = @"YES";
            }
            if ([e isEqualToString:@"wechat"]) {
                myUserInfo.isBindWX = @"YES";
            }
            if ([e isEqualToString:@"weibo"] || [e isEqualToString:@"wb"]) {
                myUserInfo.isBindWB = @"YES";
            }
            if ([e isEqualToString:@"jd"]) {
                myUserInfo.isBindJD = @"YES";
            }
        }
        [myUserInfo store];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHeadImg" object:nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
        
//        UserInfo* myUserInfo = [UserInfo restore];
        [self.btnName setTitle:myUserInfo.nickName forState:UIControlStateNormal];
        
        if (![myUserInfo.userLoginType isEqualToString:LOGIN_PHONE] && myUserInfo.phoneNum != nil && ![myUserInfo.phoneNum isEqualToString:@""]) {
//            self.bindFlycoNew.lblFlyco.text = myUserInfo.phoneNum;
            [self.bindFlycoNew.btnBind setTitle:@"解绑" forState:UIControlStateNormal];
        }

     
        NSString *bindedFlycoKey = [e.result objectForKey:@"BINDED_FLYCO_ACCOUNT"];
        NSLog(@"Binded Flyco Key = %@", bindedFlycoKey);
        if (bindedFlycoKey) {
            self.myGetFlycoMock =[getFlycoMock mock];
            getFlycoParam *param = [getFlycoParam param];
            param.sendMethod = @"GET";
            self.myGetFlycoMock.delegate = self;
            self.myGetFlycoMock.operationType = [NSString stringWithFormat:@"/getuser/%@", bindedFlycoKey];
            [self.myGetFlycoMock run:param];
        }

    }
    
    if ([mock isKindOfClass:[getFlycoMock class]]) {
        getFlycoEntity *e = (getFlycoEntity *)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            UserInfo *myUserInfo = [UserInfo restore];
            myUserInfo.flycoNick = [e.result objectForKey:@"REAL_NAME"];
            myUserInfo.flycoHead = [e.result objectForKey:@"IMAGE"];
            [myUserInfo store];
            
            if (![myUserInfo.userLoginType isEqualToString:LOGIN_PHONE]) {
                if (myUserInfo.flycoNick != nil && ![myUserInfo.flycoNick isEqualToString:@""]) {
                    self.bindFlycoNew.lblFlyco.text = myUserInfo.flycoNick;
                    if (myUserInfo.flycoHead != nil && ![myUserInfo.flycoHead isEqualToString:@""]) {
                        UIImage *img = [[WHGlobalHelper shareGlobalHelper]get:FLYCO_TOUXIANG];
                        if (!img) {
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                UIImage* img = [WpCommonFunction getImageByUrl:myUserInfo.flycoHead andSaveForKey:FLYCO_TOUXIANG];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.bindFlycoNew.imgFlyco.image = img;
                                });
                            });
                        } else {
                            self.bindFlycoNew.imgFlyco.image = img;
                        }
                    } else {
                        self.bindFlycoNew.imgFlyco.image = [UIImage imageNamed:@"headImage"];
                    }
                    
                    [self.bindFlycoNew.btnBind setTitle:@"解绑" forState:UIControlStateNormal];
                }
            }
        }
    }
}

-(void)updateUserInfo{      //更新用户信息
    
    QUMockParam* param = [QUMockParam param];
    param.sendMethod = @"GET";
    [self.myUpdateMock run:param];

}


#pragma mark UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self.btnHead setImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
    [[WHGlobalHelper shareGlobalHelper]put:[info objectForKey:@"UIImagePickerControllerEditedImage"] key:USER_TOUXIANG];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHeadImg" object:nil];
    [self updateUserHead:self.btnHead.imageView.image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField:textField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField:textField up:NO];
}

//屏幕上下移动
- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    
    const int movementDistance = 80; // tweak as needed
    
    const float movementDuration = 0.3f; // tweak as needed
    
    
    
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
    
}



//绑定第三方账号
-(void)getWBUserInfo{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_WEIBO;
    NSString* type = @"weibo";
    [self thirdLogin:type];
}


-(void)getWXUserInfo{
    self.myWXTokenMock = [WXAccessTokenMock mock];
    self.myWXTokenMock.delegate = self;
    WXAccessTokenParam* param = [WXAccessTokenParam param];
    param.sendMethod = @"GET";
    [self.myWXTokenMock run:param];
}


-(void)thirdLogin:(NSString*)loginType{
    
    thirdPartyBindParam* param = [thirdPartyBindParam param];
    UserInfo* myUserInfo = [UserInfo restore];
    self.thirdPartyMock = [thirdPartyBindMock mock];
    AppDelegate* appdelelgate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.thirdPartyMock.delegate = self;
    param.TOKENID = myUserInfo.tokenID;
    if ([loginType isEqualToString:LOGIN_JD]) {
        param.UID = myUserInfo.jdUserID;
    }
    if ([loginType isEqualToString:LOGIN_QQ]) {
        param.UID = myUserInfo.qqUserID;
    }
    if ([loginType isEqualToString:LOGIN_WECHAT]) {
        param.UID = myUserInfo.wxUserID;
    }
    if ([loginType isEqualToString:LOGIN_WEIBO]) {
        param.UID = myUserInfo.wbUserID;
    }
    param.LOGINTYPE = loginType;
    [self.thirdPartyMock run:param];
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
