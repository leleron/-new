//
//  FilterCell.m
//  Empty
//
//  Created by duye on 15/9/2.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    // Initialization code
    self.buyFilterButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buyFilter:(id)sender {
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoShop" object:nil];
//    [WpCommonFunction showTabBar];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    
    if ([self.mark isEqualToString:@"tt"]) {
        
    }else{
    CGContextSetStrokeColorWithColor(context, Color_Bg_Line.CGColor);
    CGContextStrokeRect(context, CGRectMake(15, rect.size.height, rect.size.width - 35, 2));
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = YES;
        }
    }
}


@end
