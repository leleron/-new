//
//  ItemListSection.m
//  Empty
//
//  Created by leron on 15/6/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "ItemListSection.h"

@implementation ItemListSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
}

@end

@implementation HeadSection

-(void)drawRect:(CGRect)rect{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
//    [WpCommonFunction setView:self.btnHead cornerRadius:self.btnHead.frame.size.height/2];
//    self.btnHead.clipsToBounds = YES;

}

-(void)awakeFromNib{

}

@end