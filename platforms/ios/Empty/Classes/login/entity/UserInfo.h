//
//  UserInfo.h
//  Empty
//
//  Created by leron on 15/6/16.
//  Copyright (c) 2015年 李荣. All rights reserved.
//
//用户信息类
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface UserInfo : QUEntity
@property(nonatomic,strong)NSString* nickName;
@property(nonatomic,strong)NSString* headImg;
@property(nonatomic,strong)NSString* phoneNum;
@property(nonatomic,strong)NSString* password;
@property(nonatomic,strong)NSString* tokenID;
@property(nonatomic,strong)NSString* userid;
@property(nonatomic,strong)NSString* userName;
@property(nonatomic,assign)NSString* userLoginType;
@property(nonatomic,strong)NSString* qqUserID;
@property(nonatomic,strong)NSString* qqTokenID;
@property(nonatomic,strong)NSString* wxUserID;
@property(nonatomic,strong)NSString* wxTokenID;
@property(nonatomic,strong)NSString* wxRefreshTokenID;
@property(nonatomic,strong)NSString* wbUserID;
@property(nonatomic,strong)NSString* wbTokenID;
@property(nonatomic,strong)NSString* jdUserID;
@property(nonatomic,strong)NSString* jdTokenID;
@property(strong,nonatomic)NSString* isBindWX;
@property(strong,nonatomic)NSString* isBindWB;
@property(strong,nonatomic)NSString* isBindQQ;
@property(strong,nonatomic)NSString* isBindJD;
@property(strong,nonatomic)NSString* flycoNick;
@property(strong,nonatomic)NSString* flycoHead;
@property(nonatomic,strong)NSMutableArray* deviceArray;
-(void)store;
+(instancetype)restore;
+(void)deleteData;
@end
