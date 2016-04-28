//
//  bleInfoEntity.h
//  Empty
//
//  Created by leron on 15/12/30.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface bleInfoEntity : QUEntity
@property(nonatomic,strong)NSString *deviceId;
@property(nonatomic,strong)NSString *deviceSn;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *macId;
@property(nonatomic,strong)NSString* uuid;
@property(strong,nonatomic)NSString* mac_id;   //设备列表返回的mac
@property(nonatomic,strong)NSString *runningStatus;
@property(nonatomic,strong)NSString *onlineStatus;
@property(nonatomic,strong)NSArray*    message;
@property(strong,nonatomic)NSString* deviceVersion;

@property(nonatomic,strong)NSString *deviceName;
@property(nonatomic,strong)NSString *userType;              //用户主副控
@property(nonatomic,strong)NSString *productCode;
@property(nonatomic,strong)NSString *productCategory;
@property(nonatomic,strong)NSString *deviceType;
@property(nonatomic,strong)NSString* productModel;

@end
