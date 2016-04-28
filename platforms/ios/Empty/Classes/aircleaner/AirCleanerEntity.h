//
//  AirCleanerEntity.h
//  Empty
//
//  Created by duye on 15/8/20.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUEntity.h"

@interface AirCleanerEntity : QUEntity

@property(nonatomic,strong)NSString *deviceId;
@property(nonatomic,strong)NSString *deviceSn;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *macId;
@property(strong,nonatomic)NSString* mac_id;   //设备列表返回的mac
@property(nonatomic,strong)NSString *runningStatus;
@property(nonatomic,strong)NSString *onlineStatus;
@property(nonatomic,strong)NSArray*    message;
@property(strong,nonatomic)NSString* deviceVersion;
//@property(nonatomic)int              showStatus;            //显示状态

@property(nonatomic,strong)NSString *FIRMWARE_ID;
@property(nonatomic,strong)NSString *ADDRESS;
@property(nonatomic,strong)NSString *CITY;
@property(nonatomic,strong)NSString *IMAGE;
@property(nonatomic,strong)NSString *IMAGE_PATH;
@property(nonatomic,strong)NSString *LONGITUDE;
@property(nonatomic,strong)NSString *LATITUDE;
@property(nonatomic,strong)NSString *IP;
@property(nonatomic,strong)NSString *OPERATION_TIME;
@property(nonatomic,strong)NSString *HUMIDITY_SWITCH;
@property(nonatomic,strong)NSString *IF_HAVING_WATER;
@property(nonatomic,strong)NSString *IF_LEAN;
@property(nonatomic,strong)NSString *SWITCHFORVOC;
@property(nonatomic,strong)NSString *PRODUCT_ID;
@property(nonatomic,strong)NSString *CHANNEL;
@property(nonatomic,strong)NSString *AFTER_SALE;
@property(nonatomic,strong)NSString *WIFI_MAKER;
@property(nonatomic,strong)NSString *FIRMWARE_UPDATE_TIME;
@property(nonatomic,strong)NSString *CREATE_DATE;
@property(nonatomic,strong)NSString *CREATE_USER_ID;

@property(nonatomic,strong)NSString *powerSwitch;           //电源开关
@property(nonatomic,strong)NSString *light_status;          //灯光效果
@property(nonatomic,strong)NSString *childLockSwitch;       //儿童锁开关
@property(nonatomic,strong)NSString *time_status;           //关机预约开关
@property(nonatomic,strong)NSString *quietmode;             //静默模式开关

//下面是用户绑定表里的内容
@property(nonatomic,strong)NSString *deviceName;
@property(nonatomic,strong)NSString *userType;              //用户主副控
@property(nonatomic,strong)NSString *productCode;
@property(nonatomic,strong)NSString *productCategory;
@property(nonatomic,strong)NSString *deviceType;
@property(nonatomic,strong)NSString* productModel;

//下面是空气净化属性相关。从内部接口获取
@property(nonatomic,strong)NSString *voc;                   //挥发物浓度
@property(nonatomic,strong)NSString *pmValue;               //颗粒浓度
@property(nonatomic,strong)NSString *humidity;              //湿度
@property(nonatomic,strong)NSString *temperature;           //温度
@property(nonatomic,strong)NSString *aqiStatus;             //空气质量
@property(nonatomic,strong)NSString *SMELL;                 //气味数值
@property(nonatomic,strong)NSString *anionSwitch;           //离子净化器开关状态
@property(nonatomic,strong)NSString *runningMode;           //风速
@property(nonatomic,strong)NSString *time_remaining;        //关机预约分钟数
@property(nonatomic,strong)NSString *filterOneSwitch;       //滤网1
@property(nonatomic,strong)NSString *filterTwoSwitch;       //滤网2
@property(nonatomic,strong)NSString *filterThreeSwitch;     //滤网3

//非内部接口获取数据
@property(nonatomic,strong)NSString *outdoor_pm;            //外部颗粒物
@property(nonatomic,strong)NSString *location;              //当前地点名称

@property(nonatomic,strong)NSString* voicestatus;         //声音状态
@end
