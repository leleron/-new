//
//  DeviceErrorListCell.m
//  Empty
//
//  Created by duye on 15/9/25.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "DeviceErrorListCell.h"

@implementation DeviceErrorListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
