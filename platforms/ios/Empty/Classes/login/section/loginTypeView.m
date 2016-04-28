//
//  loginTypeView.m
//  Empty
//
//  Created by leron on 15/6/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "loginTypeView.h"
#import "TencentOAuth.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "loginMock.h"
#import "JD_JOS_SDK.h"
#import "bindThirdLoginMock.h"
#import "thirdLoginMock.h"
#import "WXAccessTokenMock.h"
#import "thirdPartyBindMock.h"
#import "thridPartyDeleteMock.h"
#import "updateUserInfoMock.h"
#import "BindFlycoViewController.h"
#import "UserInfoViewController.h"
#import "deleteFlycoMock.h"
@implementation loginTypeView
@end
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@interface viewThirdLogin()<TencentSessionDelegate,WBHttpRequestDelegate,WXApiDelegate,QUMockDelegate>
@property (strong,nonatomic)TencentOAuth* tencentOAuth;
@property(strong,nonatomic)bindThirdLoginMock* myBindLoginMock;   //第三方登陆
@property(strong,nonatomic)thirdLoginMock* myThirdLoginMock;   //第三方登陆获取token
@property(strong,nonatomic)thirdPartyBindMock* thirdPartyMock;   //第三方绑定mock
@property(strong,nonatomic)thridPartyDeleteMock* myDeleteMock;
@property(strong,nonatomic)updateUserInfoMock* myUpdateMock;    //第三方登陆成功后更新用户信息

@end

@interface viewBindFlycoCount()<QUMockDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnBind;
@property (strong,nonatomic)loginMock* myLoginMock;
@property (assign,nonatomic)BOOL bindSuccess;

@end

@interface ViewBindFlycoNew()
@property(strong,nonatomic)deleteFlycoMock* myDeleteFlycoMock;
@property(strong,nonatomic)updateUserInfoMock* myUpdateMock;
@end
@implementation ViewBindFlycoNew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [WpCommonFunction setView:self.imgFlyco cornerRadius:self.imgFlyco.frame.size.width/2];

        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
//    self.frame = CGRectMake(0, 241, SCREEN_WIDTH, self.frame.size.height);
//    [WpCommonFunction setView:self.imgFlyco cornerRadius:self.imgFlyco.image.size.width/2];
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.btnBind addTarget:self action:@selector(gotoBindView) forControlEvents:UIControlEventTouchUpInside];
    [WpCommonFunction setView:self.imgFlyco cornerRadius:self.imgFlyco.frame.size.width/2];
    
    self.myUpdateMock = [updateUserInfoMock mock];
    self.myUpdateMock.delegate = self;
}

- (void)gotoBindView {
    if ([self.btnBind.titleLabel.text isEqualToString:@"绑定"]) {
        BindFlycoViewController *controller = [[BindFlycoViewController alloc] initWithNibName:@"BindFlycoViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.topController.navigationController pushViewController:controller animated:YES];
    } else if ([self.btnBind.titleLabel.text isEqualToString:@"解绑"]) {
        [self deleteFlycoBind];
    }
    
}



- (void)deleteFlycoBind {
    self.myDeleteFlycoMock = [deleteFlycoMock mock];
    self.myDeleteFlycoMock.delegate = self;
    deleteFlycoParam* param = [deleteFlycoParam param];
    param.sendMethod = @"GET";
    [[ViewControllerManager sharedManager]showWaitView:self.superview];
    [self.myDeleteFlycoMock run:param];
}

#pragma  mark QUMockDelegate
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[deleteFlycoMock class]]) {
        [WpCommonFunction showNotifyHUDAtViewBottom:self.superview withErrorMessage:@"解绑成功"];
        [self.btnBind setTitle:@"绑定" forState:UIControlStateNormal];
        [self.lblFlyco setText:@"飞科智能账号"];
        [self.imgFlyco setImage:[UIImage imageNamed:@"headImage"]];
        UserInfo *myUserInfo = [UserInfo restore];
        myUserInfo.flycoHead = nil;
        myUserInfo.flycoNick = nil;
        [myUserInfo store];
    }
}

@end

@implementation viewBindFlycoCount

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
//    self.frame = CGRectMake(0, 241, SCREEN_WIDTH, self.frame.size.height);
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.myLoginMock = [loginMock mock];
    self.myLoginMock.delegate = self;
    self.bindSuccess = false;
    UserInfo *userInfo = [UserInfo restore];
    if (![userInfo.userLoginType isEqualToString:LOGIN_PHONE] && !([userInfo.phoneNum isEqualToString:@""] || userInfo.phoneNum == nil) && !([userInfo.password isEqualToString:@""] || userInfo.password == nil)) {
        self.textPhoneNum.text = userInfo.phoneNum;
        self.textPhoneNum.enabled = NO;
        self.textPsw.text = userInfo.password;
        self.textPsw.enabled = NO;
//        [self bindFlycoCount];
    } else {
        [self.btnBind addTarget:self action:@selector(bindFlycoCount) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)bindFlycoCount{
    if(self.textPhoneNum.text && self.textPsw.text){
        loginParam* param = [loginParam param];
        param.LOGINID = self.textPhoneNum.text;
        param.PASSWORD = self.textPsw.text;
        [self.myLoginMock run:param];
        [[ViewControllerManager sharedManager]showWaitView:self];
    }
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[loginMock class]]) {
        loginEntity* e = (loginEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            UserInfo* myUserInfo =[UserInfo restore];
            myUserInfo.phoneNum = self.textPhoneNum.text;
            myUserInfo.password = self.textPsw.text;
            [myUserInfo store];
            self.bindSuccess = true;
            [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_PHONE_SUCCESS object:nil];
        }
    }
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textPhoneNum resignFirstResponder];
    [self.textPsw resignFirstResponder];
}
@end

@implementation viewThirdLogin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UserInfo* myUserInfo = [UserInfo restore];
        if ([myUserInfo.isBindQQ isEqualToString:@"YES"]) {
            self.btnAddQQ.titleLabel.text = @"解绑";
        }
        if([myUserInfo.isBindWB isEqualToString:@"YES"]){
            self.btnAddWeibo.titleLabel.text = @"解绑";
        }
        if ([myUserInfo.isBindWX isEqualToString:@"YES"]) {
            self.btnAddWechat.titleLabel.text = @"解绑";
        }
        if ([myUserInfo.isBindJD isEqualToString:@"YES"]) {
            self.btnAddJD.titleLabel.text = @"解绑";
        }


    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self.btnAddQQ addTarget:self action:@selector(gotoAddQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAddWechat addTarget:self action:@selector(gotoAddWeChat) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAddWeibo addTarget:self action:@selector(gotoAddWeibo) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAddJD addTarget:self action:@selector(gotoAddJD) forControlEvents:UIControlEventTouchUpInside];
    UserInfo* myUserInfo = [UserInfo restore];
    if ([myUserInfo.isBindQQ isEqualToString:@"YES"]) {
//        self.btnAddQQ.titleLabel.text = @"删除";
        [self.btnAddQQ setTitle:@"解绑" forState:UIControlStateNormal];
    }
    if([myUserInfo.isBindWB isEqualToString:@"YES"]){
        [self.btnAddWeibo setTitle:@"解绑" forState:UIControlStateNormal];
    }
    if ([myUserInfo.isBindWX isEqualToString:@"YES"]) {
        [self.btnAddWechat setTitle:@"解绑" forState:UIControlStateNormal];
    }
    if ([myUserInfo.isBindJD isEqualToString:@"YES"]) {
        [self.btnAddJD setTitle:@"解绑" forState:UIControlStateNormal];
    }

}

//-(void)accessLoginToken{
//    self.myThirdLoginMock = [thirdLoginMock mock];
//    self.myThirdLoginMock.delegate = self;
//    UserInfo* myUserInfo = [UserInfo restore];
//    thirdLoginParam* param = [thirdLoginParam param];
//    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if ([delegate.login_type isEqualToString:LOGIN_QQ]) {
//        param.LOGINTYPE = @"QQ";
//        param.UID = myUserInfo.qqUserID;
//        param.ACCESSTOKEN = myUserInfo.qqTokenID;
//    }
//    if ([delegate.login_type isEqualToString:LOGIN_WECHAT]) {
//        param.LOGINTYPE = @"WEIXIN";
//        param.UID = myUserInfo.wxUserID;
//        param.ACCESSTOKEN = myUserInfo.wxTokenID;
//    }
//    if ([delegate.login_type isEqualToString:LOGIN_JD]) {
//        param.LOGINTYPE = @"JD";
//        param.UID = myUserInfo.jdUserID;
//        param.ACCESSTOKEN = myUserInfo.jdTokenID;
//    }
//    if ([delegate.login_type isEqualToString:LOGIN_WEIBO]) {
//        param.LOGINTYPE = @"WB";
//        param.UID = myUserInfo.wbUserID;
//        param.ACCESSTOKEN = myUserInfo.tokenID;
//    }
//    [self.myThirdLoginMock run:param];
//}


-(void)gotoAddJD{
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_JD;

    if ([self.btnAddJD.titleLabel.text isEqualToString:@"解绑"]) {
        
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.jdTokenID = nil;
        myUserInfo.jdUserID = nil;
        [myUserInfo store];
        [self deleteThirdParty];
    }
    
    
        id<JD_JOS_SDK> jos = [JD_JOS_SDK manager];
        NSDictionary *dict = @{JDOptionAppKey:JDAPPKey,
                               JDOptionAppSecret:JDAPPSecret,
                               JDOptionNavbarColor:[UIColor redColor],
                               JDOptionAppRedirectUri:@"http://www.flyco.com/theme/feike_pc/images/logo.png"};
        [jos SetOption:dict];
        [jos Login:delegate.topController  Block:^(JDUserInfo *userInfo) {
            //京东用户信息获取接口
            //            NSLog(@"%@" ,[NSString stringWithFormat:@"user:%@,uid:%@",userInfo.user_nick,userInfo.uid]);
            UserInfo* myUserInfo = [[UserInfo alloc]init];
            myUserInfo.jdUserID = userInfo.uid;
            myUserInfo.nickName = userInfo.user_nick;
            myUserInfo.jdTokenID = userInfo.access_token;
            myUserInfo.userLoginType = LOGIN_JD;
//            [self thirdLogin:userInfo.access_token];
            [self thirdLogin:@"jd"];
        }];
        

}

-(void)gotoAddQQ{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_QQ;

    if ([self.btnAddQQ.titleLabel.text isEqualToString:@"解绑"]) {
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.qqTokenID = nil;
        myUserInfo.qqUserID = nil;
        [myUserInfo store];
        [self deleteThirdParty];
    }else{
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppKey andDelegate:self];
        NSArray* permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
        [_tencentOAuth authorize:permissions inSafari:NO];
//        UserInfo *myUserinfo = [UserInfo restore];
//        NSLog(@"qqTokenID = %@, qqUserID = %@", myUserinfo.qqTokenID, myUserinfo.qqUserID);
    }
    
}

-(void)deleteQQ{
    [self.btnAddQQ setTitle:@"绑定" forState:UIControlStateNormal];
    [self.btnAddQQ addTarget:self action:@selector(gotoAddQQ) forControlEvents:UIControlEventTouchUpInside];
}

-(void)deleteWX{
    [self.btnAddWechat setTitle:@"绑定" forState:UIControlStateNormal];
    [self.btnAddWechat addTarget:self action:@selector(gotoAddWeChat) forControlEvents:UIControlEventTouchUpInside];
}
-(void)gotoAddWeChat{
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_WECHAT;

    
    if ([self.btnAddWechat.titleLabel.text isEqualToString:@"解绑"]) {
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.wxTokenID = nil;
        myUserInfo.wxUserID = nil;
        [myUserInfo store];
        [self deleteThirdParty];
    }else{
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    }
}

-(void)gotoAddWeibo{
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_WEIBO;

    if ([self.btnAddWeibo.titleLabel.text isEqualToString:@"解绑"]) {
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.wbUserID = nil;
        myUserInfo.wbTokenID = nil;
        [myUserInfo store];
        [self deleteThirdParty];
    }else{
        WBAuthorizeRequest* request = [[WBAuthorizeRequest alloc]init];
        request.redirectURI = SinaRedirectURI;
        request.scope = @"all";
        //    request.userInfo = @{@"SSO_From":@"SendMessageToWeiboViewController",}
        [WeiboSDK sendRequest:request];

    }
    
}

-(void)deleteThirdParty{
    self.myDeleteMock = [thridPartyDeleteMock mock];
    self.myDeleteMock.delegate = self;
    thirdLoginParam* param = [thirdLoginParam param];
    param.sendMethod = @"GET";
    [self.myDeleteMock run:param];
    
}


#pragma mark QQ登陆delelgate
- (void)tencentDidLogin
{
    //    _labelTitle.text = @"登录完成";
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        
        [self.btnAddQQ setTitle:@"解绑" forState:UIControlStateNormal];
        [self.btnAddQQ addTarget:self action:@selector(deleteQQ) forControlEvents:UIControlEventTouchUpInside];

        //  记录登录用户的OpenID、Token以及过期时间
        //        _labelAccessToken.text = _tencentOAuth.accessToken;
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.qqTokenID = _tencentOAuth.accessToken;
        myUserInfo.qqUserID = _tencentOAuth.openId;
        [myUserInfo store];
//        [self accessLoginToken];
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [self thirdLogin:@"qq"];

        NSLog(@"%@",_tencentOAuth.accessToken);
        
    }
    else
    {
        //        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}


-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        //        _labelTitle.text = @"用户取消登录";
        NSLog(@"用户取消登陆");
    }
    else
    {
        //        _labelTitle.text = @"登录失败";
        NSLog(@"登陆失败");
    }
}

-(void)tencentDidNotNetWork
{
    //    _labelTitle.text=@"无网络连接，请设置网络";
    NSLog(@"无网络连接 请设置网络");
}


//-(void) onResp:(BaseResp*)resp{
//    if ([resp isKindOfClass:[SendAuthResp class]]) {
//        SendAuthResp* request = (SendAuthResp*)resp;
//        NSString* code = request.code;
//        [[NSUserDefaults standardUserDefaults]setObject:code forKey:WXCode];
////        [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_WX_SUCCESS object:nil];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"login_wx_success" object:nil];
//
////        ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:nil];
//
//
//    }
//}




-(void)loginWX{
    [self.btnAddWechat setTitle:@"解绑" forState:UIControlStateNormal];
    [self.btnAddWechat addTarget:self action:@selector(deleteWX) forControlEvents:UIControlEventTouchUpInside];
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

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
        if ([mock isKindOfClass:[thirdLoginMock class]]) {
            loginEntity* e = (loginEntity*)entity;
            if ([e.status isEqualToString:RESULT_SUCCESS]) {
                UserInfo* myUserInfo = [UserInfo restore];
                myUserInfo.tokenID = e.tokenId;
                [myUserInfo store];
                [self thirdLogin:myUserInfo.tokenID];
            }
        }
    if ([mock isKindOfClass:[thirdPartyBindMock class]]) {
        
        [self updateUserInfo];  //更新用户信息

        
    }
    if ([mock isKindOfClass:[updateUserInfoMock class]]) {
        updateUserInfoEntity* e = (updateUserInfoEntity*)entity;
        UserInfo* myUserInfo = [UserInfo restore];
        myUserInfo.nickName = [e.result objectForKey:@"REAL_NAME"];
        NSString* headUrl = [e.result valueForKey:@"IMAGE"];
        myUserInfo.headImg = headUrl;
        myUserInfo.userName = [e.result valueForKey:@"USER_NAME"];
        NSArray* thridBind = [e.result objectForKey:@"OTHRE_USER_TO_THIS"];
        for (NSString* e in thridBind) {
            if ([e isEqualToString:@"qq"]) {
                myUserInfo.isBindQQ = @"YES";
            }
            if ([e isEqualToString:@"wechat"]) {
                myUserInfo.isBindWX = @"YES";
            }
            if ([e isEqualToString:@"weibo"]) {
                myUserInfo.isBindWB = @"YES";
            }
            if ([e isEqualToString:@"jd"]) {
                myUserInfo.isBindJD = @"YES";
            }
        }
        [myUserInfo store];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHeadImg" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
        
    }
    if ([mock isKindOfClass:[thridPartyDeleteMock class]]) {
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([delegate.login_type isEqualToString:LOGIN_QQ]) {
            [self.btnAddQQ setTitle:@"绑定" forState:UIControlStateNormal];
            UserInfo* myUser = [UserInfo restore];
            myUser.isBindQQ = @"NO";
            [myUser store];
            [WpCommonFunction showNotifyHUDAtViewBottom:self withErrorMessage:@"解绑qq成功"];
        }
        if ([delegate.login_type isEqualToString:LOGIN_WEIBO]) {
            [self.btnAddWeibo setTitle:@"绑定" forState:UIControlStateNormal];
            UserInfo* myUser = [UserInfo restore];
            myUser.isBindWB = @"NO";
            [myUser store];
            [WpCommonFunction showNotifyHUDAtViewBottom:self withErrorMessage:@"解绑微博成功"];
        }
        if ([delegate.login_type isEqualToString:LOGIN_WECHAT]) {
            [self.btnAddWechat setTitle:@"绑定" forState:UIControlStateNormal];
            UserInfo* myUser = [UserInfo restore];
            myUser.isBindWX = @"NO";
            [myUser store];
            [WpCommonFunction showNotifyHUDAtViewBottom:self withErrorMessage:@"解绑微信成功"];
        }
        if ([delegate.login_type isEqualToString:LOGIN_JD]) {
            [self.btnAddJD setTitle:@"绑定" forState:UIControlStateNormal];
            UserInfo* myUser = [UserInfo restore];
            myUser.isBindJD = @"NO";
            [myUser store];
            [WpCommonFunction showNotifyHUDAtViewBottom:self withErrorMessage:@"解绑京东成功"];
        }

    }
    

}


-(void)updateUserInfo{      //更新用户信息
    
    self.myUpdateMock = [updateUserInfoMock mock];
    self.myUpdateMock.delegate = self;
    updateUserInfoParam* param = [updateUserInfoParam param];
    param.sendMethod = @"GET";
    [self.myUpdateMock run:param];
    
}


@end



