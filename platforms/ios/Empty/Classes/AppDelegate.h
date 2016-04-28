//
//  AppDelegate.h
//  Empty
//
//  Created by 李荣 on 15/5/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMBottomTabBarController.h"
#import "iOSPlugins.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, NMBottomTabBarControllerDelegate>
//typedef enum {
//    LOGIN_WEIBO = 1,
//    LOGIN_QQ,
//    LOGIN_WECHAT,
//    LOGIN_ZFB,
//    LOGIN_JD,
//    LOGIN_PHONE,
//}loginType;

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)MyViewController* topController;
@property (nonatomic,strong)NSString *camDID;
@property (nonatomic,strong)NSString *WIFISSID;
@property (nonatomic,assign)NSInteger contrast;
@property (nonatomic,assign)NSInteger brightness;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger Auth_isok;
@property(nonatomic,assign)NSString* login_type;
@property(strong,nonatomic)NMBottomTabBarController* nmtabBarController;
@property(nonatomic,assign)iOSPlugins* plugins;
@property (strong, nonatomic) NSString *currentLatitude; //纬度
@property (strong, nonatomic) NSString *currentLongitude; //经度
- (id)fetchSSIDInfo;
@end

