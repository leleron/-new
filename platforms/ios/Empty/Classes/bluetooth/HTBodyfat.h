//
//  HTBodyfat.h
//  HTBodyfat
//
//  Created by Holtek on 15/10/30.
//  Copyright © 2015年 Holtek. All rights reserved.

//  @version    1.0


#import <UIKit/UIKit.h>

///性别类型
typedef NS_ENUM(NSInteger, HTSexType){
    HTSexTypeFemale,        //!< 女性，默认
    HTSexTypeMale           //!< 男性
};

///people类型
typedef NS_ENUM(NSInteger, HTPeopleType){
    HTPeopleTypeManual,     //!< 体力劳动者
    HTPeopleTypeMental,     //!< 脑力劳动者
    HTPeopleTypeAthlete     //!< 运动员
};

///错误类型(针对输入的参数)
typedef NS_ENUM(NSInteger, HTErrorType){
    HTErrorImpedance = 1,   //!< 阻抗系数有误
    HTErrorAge,             //!< 年龄参数有误，需在0 ~ 120
    HTErrorWeight,          //!< 体重参数有误，需 > 0
    HTErrorHeight,          //!< 身高参数有误，需在 0 ~ 2.3
    HTErrorNilObject        //!< 参数people model为nil
};


@class HTBodyfat,HTPeopleModel,HTBodyfatModel,HTError;


#pragma mark - HTBodyfat

/// HTBodyfat代理协议
@protocol HTBodyfatDelegate <NSObject>

/*! @brief 代理方法。
 *
 * 在输入参数有误的时候，回调。
 * @param bodyfat 当前HTBodyfat对象
 * @param peopleModel 调用 获取体脂参数model方法 时传入的people model
 * @param error 错误对象，@see HTError类
 */
- (void)bodyfat:(HTBodyfat * __nonnull)bodyfat people:(HTPeopleModel * __nonnull)peopleModel catchError:(HTError * __nonnull)error;

@end

/// HTBodyfat，计算体脂参数类
@interface HTBodyfat : NSObject

//// HTBodyfat代理
@property (nonatomic,weak)id<HTBodyfatDelegate> delegate;


/*! @brief HTBodyfat的成员函数，用代理初始化，也可用alloc init初始化，再设置delegate成员变量。
 *
 * 在需要获知错误信息时，注册代理。
 * @param delegate 代理
 */
- (instancetype __nullable)initWithDelegate:(id<HTBodyfatDelegate> __nonnull)delegate;


/*! @brief 获取体脂参数model。
 *
 * 以HTPeopleModel作为参数。
 * @param  peopleModel 传入的数据参数model
 * @return 返回体脂参数model，若传入的数据有误，返回nil。
 */
- (HTBodyfatModel * __nullable)getBodyfatForPeople:(HTPeopleModel * __nonnull)peopleModel;


/*! @brief 获取体脂参数model。
 *
 * 以具体的数据作为参数，不需要再建model
 * @param  weight...impedanceCoefficient 传入的数据参数
 * @return 返回体脂参数model，若传入的数据有误，返回nil。
 */
- (HTBodyfatModel * __nullable)getBodyfatWithWeight:(CGFloat)weight Height:(CGFloat)height Sex:(HTSexType)sex Age:(NSInteger)age PeopleTye:(HTPeopleType)peopleType ImpedanceCoefficient:(NSInteger)impedanceCoefficient;


@end



#pragma mark - HTError


@interface HTError : NSObject

@property (nonatomic,assign) HTErrorType type;          //!< 输入参数有误的类型

@property (nonatomic,copy) NSString * __nonnull detail; //!< 错误描述

@end


#pragma mark - HTPeopleModel

/// 计算体脂参数所需数据model
@interface HTPeopleModel : NSObject


@property (nonatomic,assign) CGFloat weight;            //!< 体重(kg)，需 >0

@property (nonatomic,assign) CGFloat height;            //!< 身高(m)，需在 0 ~ 2.3

@property (nonatomic,assign) HTSexType sex;             //!< 性别

@property (nonatomic,assign) NSInteger age;             //!< 年龄，需在0 ~ 120

@property (nonatomic,assign) HTPeopleType peopleType;   //!< 类型

@property (nonatomic,assign) NSInteger impedanceCoefficient;  //!< 阻抗系数，3bytes，用来计算阻抗


@end


#pragma mark - HTBodyfatModel

/// 体脂参数model
@interface HTBodyfatModel : NSObject


@property (nonatomic,assign) CGFloat bmiValue;          //!< 人体健康指数, 分辨率0.1, 范围10.0 ~ 90.0

@property (nonatomic,assign) NSInteger bmrValue;        //!< 基础代谢, 分辨率1, 范围500 ~ 10000

@property (nonatomic,assign) NSInteger visceralValue;   //!< 内脏脂肪, 分辨率1, 范围1 ~ 50

@property (nonatomic,assign) CGFloat boneValue;         //!< 骨量(kg), 分辨率0.1, 范围0.5 ~ 8.0

@property (nonatomic,assign) CGFloat bodyfatPercentage; //!< 脂肪率(%), 分辨率0.1, 范围5.0% ~ 60.0%

@property (nonatomic,assign) CGFloat waterPercentage;   //!< 水分率(%), 分辨率0.1, 范围35.0% ~ 75.0%

@property (nonatomic,assign) CGFloat musclePercentage;  //!< 肌肉率(%), 分辨率0.1, 范围5.0% ~ 90.0%

@property (nonatomic,assign) CGFloat impedance;         //!< 阻抗(Ω), 范围200.0 ~ 1200.0


@end














