//
//  ListTableViewCell.h
//  Empty
//
//  Created by leron on 15/11/2.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property(strong,nonatomic)NSString* mark;
@property (weak, nonatomic) IBOutlet UILabel *lblAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@end
