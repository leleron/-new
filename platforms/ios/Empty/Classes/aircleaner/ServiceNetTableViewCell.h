//
//  ServiceNetTableViewCell.h
//  Empty
//
//  Created by leron on 15/10/27.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceNetTableViewCell : QUSection
@property(weak,nonatomic)IBOutlet UILabel* lblName;
@property(weak,nonatomic)IBOutlet UILabel* lblAddress;
@property(weak,nonatomic)IBOutlet UILabel* lblPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@end

