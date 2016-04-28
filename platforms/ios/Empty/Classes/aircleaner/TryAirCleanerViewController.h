//
//  TryAirCleanerViewController.h
//  Empty
//
//  Created by duye on 15/9/25.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "MyViewController.h"
#import "RNGridMenu.h"
#import "ProgressView.h"
#import "AirCleanerEntity.h"
#import "FilterCell.h"


#define FLYCO_DARK_BLUE     [UIColor colorWithRed:3.0f/255 green:15.0f/255 blue:36.0f/255 alpha:1]


@interface TryAirCleanerViewController : MyViewController<RNGridMenuDelegate,ProgressViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)AirCleanerEntity *cleaner;
@end
