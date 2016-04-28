//
//  ProgressView.h
// 
//
//  Created by 刘通超 on 15/1/7.
//  Copyright (c) 2015年 刘通超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressViewDelegate
-(void)turnOnOff:(UIButton*)button;
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender;
- (void)handleTap:(UITapGestureRecognizer *)sender;
@end

#define DEVICE_HEIGHT [UIScreen mainScreen].applicationFrame.size.height
#define DEVICE_WIDTH [UIScreen mainScreen].applicationFrame.size.width

#define BLUECOLOR [UIColor colorWithRed:1.0f/255 green:137.0f/255 blue:254.0f/255 alpha:1]
#define ORANGECOLOR [UIColor colorWithRed:255.0f/255 green:120.0f/255 blue:0.0f/255 alpha:1]
#define REDCOLOR [UIColor colorWithRed:255.0f/255 green:0.0f/255 blue:0.0f/255 alpha:1]
#define GREENCOLOR  [UIColor colorWithRed:198.0f/255 green:255.0f/255 blue:0.0f/255 alpha:1]

#define PURPOECOLOR  [UIColor colorWithRed:170.0f/255 green:96.0f/255 blue:255.0f/255 alpha:1]


#define CENTERCOLOR  [UIColor colorWithRed:41.0f/255 green:106.0f/255 blue:191.0f/255 alpha:1]

@interface ProgressView : UIView

//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;
//圆环色
@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;

@property (strong,nonatomic)UIPageControl* PageControl;
//百分比数值（0-1）
@property (assign, nonatomic)float percent;

//圆环宽度
@property (assign, nonatomic)float width;

@property(strong,nonatomic)UIImageView* image;   //中心圆背景图
//代理
@property (weak, nonatomic)id<ProgressViewDelegate> delegate;


//室内空气质量
@property (nonatomic)UILabel *inDoorAirInfoLabel;

//室内PM
@property (nonatomic)UILabel *inDoorAirInfoNumLabel;

//单位
@property (nonatomic)UILabel *unit;

//电源按钮
@property (nonatomic)UIButton *OnButton;

//内容flag
@property (nonatomic)int showStatus;

@property (assign,nonatomic)int flag;
@property (assign,nonatomic)BOOL isTryDevice;

@property(strong,nonatomic)UILabel *hint1;
@property(strong,nonatomic)UILabel *hint2;
- (id)initWithFrame:(CGRect)frame;

@end
