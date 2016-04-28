//
//  LoginViewController.m
//  飞科智能
//
//  Created by leron on 15/6/8.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "TencentOAuth.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "RegisterViewController.h"
#import "loginMock.h"
#import "UserInfo.h"
//#import "forgetPswViewController.h"
#import "WXAccessTokenMock.h"
#import "WXUserInfoMock.h"
#import "WXUpdateTokenMock.h"
#import "thirdLoginMock.h"
#import "JD_JOS_SDK.h"
#import "updateUserInfoMock.h"
#import "ResetPswViewController.h"


@interface LoginViewController ()<TencentSessionDelegate,WBHttpRequestDelegate,WXApiDelegate,WeiboSDKDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnJD;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginQQ;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginWeChat;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginWeibo;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UITextField *textPhoneNum;
@property (weak, nonatomic) IBOutlet UIView *viewPhoneNum;

@property (weak, nonatomic) IBOutlet UITextField *textPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnFogetPsw;

//@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;


@property(strong,nonatomic)TencentOAuth* tencentOAuth;
@property(strong,nonatomic)NSArray* permissions;
@property(strong,nonatomic)WBAuthorizeRequest* request;
@property(strong,nonatomic)loginMock* myLoginMock;
@property(strong,nonatomic)WXAccessTokenMock* myWXTokenMock;    //获取微信token
@property(strong,nonatomic)WXUserInfoMock* myWXUserInfoMock;   //获取微信用户信息
@property(strong,nonatomic)WXUpdateTokenMock* myWXupdateMock;  //刷新微信token
@property(strong,nonatomic)thirdLoginMock* myThirdLoginMock;   //第三方登陆
@property(strong,nonatomic)updateUserInfoMock* myUpdateMock;    //获取用户信息
@property(strong,nonatomic)NSString* phoneNum;      //保存的手机号

@end

@implementation LoginViewController


- (void)viewDidLoad {
    self.navigationBarTitle = @"用户登录";
    [super viewDidLoad];
//    [self showLeftButtonNormalImage:@"back" highLightImage:@"back" selector:@selector(back)];
    [self showLeftNormalButton:@"go_back" highLightImage:@"go_back" selector:@selector(back)];
    self.navigationController.navigationBar.hidden = NO;
    [self.btnLoginQQ addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLoginWeChat addTarget:self action:@selector(loginWithWX) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLoginWeibo addTarget:self action:@selector(loginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnJD addTarget:self action:@selector(loginWithJD) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnRegister addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFogetPsw addTarget:self action:@selector(gotoForgetPsw) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postWeiboUserInfo) name:LOGIN_WB_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWXUserInfo) name:LOGIN_WX_SUCCESS object:nil];
    // Do any additional setup after loading the view.
    self.textPsw.secureTextEntry = YES;
    UIColor *color = [UIColor grayColor];
    self.textPhoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码/邮箱" attributes:@{NSForegroundColorAttributeName: color}];
    self.textPsw.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: color}];
    [WpCommonFunction setView:self.btnLogin cornerRadius:10];
    
    
    if ([self.mark isEqualToString:@"chajian"]) {
//        self.lblTitle.hidden = NO;
        NSLayoutConstraint *oldConstraint = (NSLayoutConstraint *)[[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[_viewPhoneNum]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_viewPhoneNum)] firstObject];
        for (NSLayoutConstraint *item in self.view.constraints) {
            NSLog(@"%@", item);
            if ([WpCommonFunction compareConstaint:item toConstraint:oldConstraint]) {
                item.constant += 64;                
            }
        }
        self.btnCancel.hidden = NO;
        [self.btnCancel addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfo) name:@"RegisterSuccess" object:nil];
}

-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initQuickUI{
    self.textPsw.delegate = self;
    self.textPhoneNum.delegate = self;
}
-(void)initQuickMock{
    self.myLoginMock = [loginMock mock];
    self.myLoginMock.delegate = self;
    self.myThirdLoginMock = [thirdLoginMock mock];
    self.myThirdLoginMock.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoRegister{
    RegisterViewController* controller = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
//    [WpCommonFunction hideTabBar];
//    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)gotoLogin{
    [self.textPhoneNum resignFirstResponder];
    [self.textPsw resignFirstResponder];
    if (self.textPhoneNum.text != nil && self.textPsw.text!= nil) {
        loginParam* param = [loginParam param];
        param.sendMethod = @"POST";
        param.LOGINID = self.textPhoneNum.text;
        param.PASSWORD = self.textPsw.text;
        param.LAST_PHONE_SYSTEM = @"ios";
        self.phoneNum = param.LOGINID;
//        param.LOGINID = @"15021631445";
//        param.PASSWORD = @"85314248";
        [self.myLoginMock run:param];
        [[ViewControllerManager sharedManager]showWaitView:self.view];
    }
}

-(void)gotoForgetPsw{
    ResetPswViewController* controller = [[ResetPswViewController alloc]initWithNibName:@"ResetPswViewController" bundle:nil];
//    controller.hidesBottomBarWhenPushed = YES;
//    [WpCommonFunction hideTabBar];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)loginWithJD{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_JD;
    
    id<JD_JOS_SDK> jos = [JD_JOS_SDK manager];
    NSDictionary *dict = @{JDOptionAppKey:JDAPPKey,
                           JDOptionAppSecret:JDAPPSecret,
                           JDOptionNavbarColor:[UIColor redColor],
                           JDOptionAppRedirectUri:@"http://www.flyco.com/theme/feike_pc/images/logo.png"};
    [jos SetOption:dict];
    [jos Login:self  Block:^(JDUserInfo *userInfo) {
        //京东用户信息获取接口
        //            NSLog(@"%@" ,[NSString stringWithFormat:@"user:%@,uid:%@",userInfo.user_nick,userInfo.uid]);
        if (userInfo) {
            UserInfo* myUserInfo = [[UserInfo alloc]init];
            myUserInfo.jdUserID = userInfo.uid;
            myUserInfo.nickName = userInfo.user_nick;
            myUserInfo.jdTokenID = userInfo.access_token;
            myUserInfo.userLoginType = LOGIN_JD;
            [myUserInfo store];
            NSLog(@"jd:%@",userInfo.user_nick);
            [self thirdLogin];
        }
        
    }];
    
    
    
}



-(void)loginWithQQ{
    AppDelegate* delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_QQ;
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppKey andDelegate:self];
    _permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

-(void)loginWithWX{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_WECHAT;
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

-(void)loginWithWeibo{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.login_type = LOGIN_WEIBO;
    self.request = [[WBAuthorizeRequest alloc]init];
    self.request.redirectURI = SinaRedirectURI;
    self.request.scope = @"all";
//    request.userInfo = @{@"SSO_From":@"SendMessageToWeiboViewController",}
    [WeiboSDK sendRequest:self.request];
}

-(void)postWeiboUserInfo{
    UserInfo* myUserInfo = [UserInfo restore];
    NSNumber *userID = [NSNumber numberWithInteger:[myUserInfo.wbUserID integerValue]];
    NSString* user = [NSString stringWithFormat:@"%@",userID];
    NSDictionary* param = @{@"access_token":myUserInfo.wbTokenID,@"uid":user};
    NSString* url = @"https://api.weibo.com/2/users/show.json";
//   [WBHttpRequest requestWithAccessToken:myUserInfo.wbTokenID url:url httpMethod:@"GET" params:param delegate:self withTag:nil];
    NSString* sendMethod = @"GET";
    [WBHttpRequest requestWithURL:url httpMethod:sendMethod params:param delegate:self withTag:nil];
}



-(void)getWXUserInfo{
    self.myWXTokenMock = [WXAccessTokenMock mock];
    self.myWXTokenMock.delegate = self;
    WXAccessTokenParam* param = [WXAccessTokenParam param];
    param.sendMethod = @"GET";
    [self.myWXTokenMock run:param];
}

-(void)thirdLogin{
    thirdLoginParam* param = [thirdLoginParam param];
    UserInfo* myUserInfo = [UserInfo restore];
    param.NICKNAME = myUserInfo.nickName;
    if ([myUserInfo.userLoginType isEqualToString:LOGIN_QQ]) {
        param.LOGINTYPE = @"qq";
        param.UID = myUserInfo.qqUserID;
        param.ACCESSTOKEN = myUserInfo.qqTokenID;
    }
    if ([myUserInfo.userLoginType isEqualToString:LOGIN_WECHAT]) {
        param.LOGINTYPE = @"wechat";
        param.UID = myUserInfo.wxUserID;
        param.ACCESSTOKEN = myUserInfo.wxTokenID;
    }
    if ([myUserInfo.userLoginType isEqualToString:LOGIN_JD]) {
        param.LOGINTYPE = @"jd";
        param.UID = myUserInfo.jdUserID;
        param.ACCESSTOKEN = myUserInfo.jdTokenID;
    }
    if ([myUserInfo.userLoginType isEqualToString:LOGIN_WEIBO]) {
        param.LOGINTYPE = @"weibo";
        param.UID = myUserInfo.wbUserID;
        param.ACCESSTOKEN = myUserInfo.wbTokenID;
    }
    [[ViewControllerManager sharedManager]showWaitView:self.view];
    [self.myThirdLoginMock run:param];
}


#pragma mark QQ登陆delelgate
- (void)tencentDidLogin
{
//    _labelTitle.text = @"登录完成";
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
//        _labelAccessToken.text = _tencentOAuth.accessToken;
        NSLog(@"%@",_tencentOAuth.accessToken);
        UserInfo* myUserInfo = [[UserInfo alloc]init];
        myUserInfo.qqTokenID = _tencentOAuth.accessToken;
        myUserInfo.qqUserID = _tencentOAuth.openId;
        [myUserInfo store];
        [[ViewControllerManager sharedManager]showWaitView:self.view];
        [_tencentOAuth getUserInfo];
    }
    else
    {
//        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}
- (void)getUserInfoResponse:(APIResponse*) response{
    
    [[ViewControllerManager sharedManager]hideWaitView];
    UserInfo *myUserInfo = [UserInfo restore];
    myUserInfo.nickName = [response.jsonResponse objectForKey:@"nickname"];
    myUserInfo.headImg = [response.jsonResponse objectForKey:@"figureurl_qq_2"];
    myUserInfo.userLoginType = LOGIN_QQ;
    [myUserInfo store];
    [self thirdLogin];   
//    self.myUserInfo.headImg = [UIIm]
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

#pragma mark 微博delegate


-(void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{

//    NSDictionary* dict = [[request responseData] objectFromJSONData];
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
//    NSString* title = nil;
//    UIAlertView* alert = nil;
//    title = @"收到网络回调";
//    NSLog(@"lirong:%@",request);
//    alert = [[UIAlertView alloc]initWithTitle:title message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
    
    UserInfo* myUserInfo = [UserInfo restore];
    NSDictionary* dict = [WpCommonFunction dictionaryWithJsonString:result];
    myUserInfo.nickName = [dict objectForKey:@"name"];
    myUserInfo.userLoginType = LOGIN_WEIBO;
    NSString *weiboId = [dict objectForKey:@"idstr"];
    myUserInfo.headImg = [NSString stringWithFormat:@"http://tp3.sinaimg.cn/%@/180/5731937145/1", weiboId];

    [myUserInfo store];
    
    [self thirdLogin];

}


-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    NSString* title = @"请求异常";
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//从后台读取用户信息
-(void)getUserInfo{
    self.myUpdateMock = [updateUserInfoMock mock];
    self.myUpdateMock.delegate = self;
    updateUserInfoParam* param = [updateUserInfoParam param];
    param.sendMethod = @"GET";
    [self.myUpdateMock run:param];
}



#pragma mark QUMockDelegate
-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    if ([mock isKindOfClass:[loginMock class]]) {
        loginEntity* e = (loginEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            UserInfo* myUserInfo = [[UserInfo alloc]init];
            myUserInfo.phoneNum = self.phoneNum;
            myUserInfo.password = self.textPsw.text;
            myUserInfo.tokenID = e.tokenId;
            myUserInfo.userid = e.userid;
            NSLog(@"tokenId:%@",e.tokenId);
            myUserInfo.userLoginType = LOGIN_PHONE;
            [myUserInfo store];
            [self getUserInfo];

        }
    }
    if ([mock isKindOfClass:[updateUserInfoMock class]]) {
        if (entity != nil) {
            updateUserInfoEntity* e = (updateUserInfoEntity*)entity;
            UserInfo* myUserInfo = [UserInfo restore];
            myUserInfo.nickName = [e.result objectForKey:@"REAL_NAME"];
            NSString* headUrl = [e.result valueForKey:@"IMAGE"];
            if (headUrl != nil && ![headUrl isEqualToString:@""]) {
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
                if ([e isEqualToString:@"weibo"]) {
                    myUserInfo.isBindWB = @"YES";
                }
                if ([e isEqualToString:@"jd"]) {
                    myUserInfo.isBindJD = @"YES";
                }
            }
            [myUserInfo store];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHeadImg" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
        if ([self.mark isEqualToString:@"chajian"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"chajianLoginSuccess" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    if ([mock isKindOfClass:[WXAccessTokenMock class]]) {
        WXAccessTokenEntity* e = (WXAccessTokenEntity*)entity;
        UserInfo* myUserInfo = [[UserInfo alloc]init];
        myUserInfo.wxTokenID = e.access_token;
        myUserInfo.wxUserID = e.openid;
        myUserInfo.wxRefreshTokenID = e.refresh_token;
        [myUserInfo store];
        //重新刷新token时间
        self.myWXupdateMock = [WXUpdateTokenMock mock];
        self.myWXupdateMock.delegate = self;
        WXUpdateTokenParma* param = [WXUpdateTokenParma param];
        param.sendMethod = @"GET";
        [self.myWXupdateMock run:param];
    }
    
    if ([mock isKindOfClass:[WXUpdateTokenMock class]]) {
        WXAccessTokenEntity* e = (WXAccessTokenEntity*)entity;
        UserInfo* myUserInfo = [[UserInfo alloc]init];
        myUserInfo.wxTokenID = e.access_token;
        myUserInfo.wxUserID = e.openid;
        myUserInfo.wxRefreshTokenID = e.refresh_token;
        [myUserInfo store];
        self.myWXUserInfoMock = [WXUserInfoMock mock];
        self.myWXUserInfoMock.delegate = self;
        WXUserInfoParam* param = [WXUserInfoParam param];
        param.sendMethod = @"GET";
        [[ViewControllerManager sharedManager]showWaitView:self.view];
        [self.myWXUserInfoMock run:param];


    }
    if ([mock isKindOfClass:[WXUserInfoMock class]]) {
        WXUserInfoEntity* e = (WXUserInfoEntity*)entity;
//        NSData* userHeadData = [NSData dataWithContentsOfURL:[NSURL URLWithString:e.headimgurl]];
        UserInfo* myUserInfo = [[UserInfo alloc]init];
        UserInfo* oldUserInfo = [UserInfo restore];
        [myUserInfo copy:oldUserInfo];
        myUserInfo.headImg = e.headimgurl;
        myUserInfo.userLoginType = LOGIN_WECHAT;
        myUserInfo.nickName = e.nickname;
        [myUserInfo store];
        [self thirdLogin];
    }
    
    if ([mock isKindOfClass:[thirdLoginMock class]]) {
        loginEntity* e = (loginEntity*)entity;
        if ([e.status isEqualToString:RESULT_SUCCESS]) {
            UserInfo* myUserInfo = [UserInfo restore];
            myUserInfo.tokenID = e.tokenId;
            myUserInfo.userName = e.userName;
            myUserInfo.userid = e.userid;
            [myUserInfo store];
//            [self getUserInfo];
//            }else{
////                [self.navigationController popViewControllerAnimated:YES];
//            }
          //  {
                updateUserInfoParam* param = [updateUserInfoParam param];
                param.REAL_NAME = myUserInfo.nickName;
            param.IMAGE = [WpCommonFunction transformImageDataToBase64String:UIImageJPEGRepresentation([WpCommonFunction getImageByUrl:myUserInfo.headImg andSaveForKey:USER_TOUXIANG],0.1)];
                param.sendMethod = @"PUT";
            [[ViewControllerManager sharedManager]showWaitView:self.view];
            self.myUpdateMock = [updateUserInfoMock mock];
            self.myUpdateMock.delegate = self;
                [self.myUpdateMock run:param];
        //    }

        }
    }    
}

-(void)viewDidDisappear:(BOOL)animated{
//    [WpCommonFunction showTabBar];
    [super viewDidDisappear:animated];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textPhoneNum resignFirstResponder];
    [self.textPsw resignFirstResponder];
}

-(void)updateUserInfo{
//    updateUserInfoParam* param = [updateUserInfoParam param];
//    UserInfo* myUserInfo = [UserInfo restore];
//    param.USER_NAME = myUserInfo.nickName;
//    UIImage* headImg = [WpCommonFunction getImageByUrl:myUserInfo.headImg];
//    NSData* imgData = UIImageJPEGRepresentation(headImg,1.0);
//    param.IMAGE = [WpCommonFunction transformImageDataToBase64String:imgData];
//    param.sendMethod = @"PUT";
//    [self.myUpdateMock run:param];
//    myUserInfo = [UserInfo restore];

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
