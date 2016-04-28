//
//  ServiceNetTableViewCell.m
//  Empty
//
//  Created by leron on 15/10/27.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "ServiceNetTableViewCell.h"
@interface ServiceNetTableViewCell()

@end


@implementation ServiceNetTableViewCell


-(void)drawRect:(CGRect)rect{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 110);
}
- (void)awakeFromNib {
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    //上分割线，
//    //    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
//    
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, Color_Bg_Line.CGColor);
//    CGContextStrokeRect(context, CGRectMake(15, rect.size.height, rect.size.width - 15, 2));
//}
//
@end
