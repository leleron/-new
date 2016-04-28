//
//  FilterCell.h
//  Empty
//
//  Created by duye on 15/9/2.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *filterImage;
@property (weak, nonatomic) IBOutlet UILabel *filterType;
@property (weak, nonatomic) IBOutlet UILabel *suggest;
@property (weak, nonatomic) IBOutlet UILabel *remainDay;
@property (weak, nonatomic) IBOutlet UIButton *buyFilterButton;
@property (weak, nonatomic) IBOutlet UILabel *timeUnitLabel;
@property (strong,nonatomic)NSString* mark;
- (IBAction)buyFilter:(id)sender;

@end
