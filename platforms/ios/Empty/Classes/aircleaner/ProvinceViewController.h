//
//  ProvinceViewController.h
//  Empty
//
//  Created by leron on 15/10/20.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"

@interface ProvinceViewController : MyViewController
@property(nonatomic,strong)NSString* mark;      //判断是查询天气还是服务网点
@property(strong,nonatomic)NSString* deviceId;   //设备id
@end
