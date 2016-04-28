//
//  MessageSection.m
//  Empty
//
//  Created by 信息部－研发 on 15/9/23.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "MessageSection.h"

@implementation MessageSection

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [WpCommonFunction setView:self.imgRedDot cornerRadius:self.imgRedDot.bounds.size.width/2];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
//    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
}

- (void)awakeFromNib {
    // Initialization code
}
/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [(UIButton *)self.imgRedDot setHighlighted:NO];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [(UIButton *)self.imgRedDot setHighlighted:NO];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [(UIButton *)self.imgRedDot setHighlighted:NO];
}
*/
@end
