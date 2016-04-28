//
//  DeviceErrorListCell.h
//  Empty
//
//  Created by duye on 15/9/25.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceErrorListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UIView *redPotView;
@property(strong,nonatomic)NSString* mark;
@end
