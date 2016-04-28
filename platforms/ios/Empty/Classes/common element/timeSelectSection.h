//
//  timeSelectSection.h
//  Empty
//
//  Created by leron on 15/11/12.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CamObj.h"

@protocol timeSelectDelegate <NSObject>

-(void)clickCancel;
-(void)clickConfirm;
-(void)chooseDate;

@end

@interface timeSelectSection : UIView
@property(nonatomic,strong)NSMutableArray* dateArray;
@property(strong,nonatomic)CamObj* cam;
@property(assign,nonatomic)id<timeSelectDelegate>delegate;
-(void)showDate;
@end
