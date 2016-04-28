//
//  WpWaitView2.m
//  WeiboPay
//
//  Created by Mark on 13-11-12.
//  Copyright (c) 2013年 WeiboPay. All rights reserved.
//

#import "WpWaitView2.h"
#import "WpCommonFunction.h"


#define CENTER_VIEW_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW_V(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW(PARENT, VIEW) {CENTER_VIEW_H(PARENT, VIEW); CENTER_VIEW_V(PARENT, VIEW);}
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]


@interface WpWaitView2 ()
{
    CGFloat angle;
    BOOL bRotate;
    
    UIImageView* cBkImageView;
    UIImageView* cShieldImageView;
    UIImageView* cCircleImageView;
}

@end

@implementation WpWaitView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        
        CGFloat x1 = (screenWidth - 160.0) / 2.0;
        CGFloat y1 = (screenHeight - 120.0) / 2.0;
        cBkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x1, y1, 160, 120)];
        cBkImageView.image = [UIImage imageNamed:@"loading_bg"];
        cBkImageView.alpha = 1.0;
        [WpCommonFunction setView:cBkImageView cornerRadius:6.0];
        [self addSubview:cBkImageView];
        
        
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator startAnimating];
        CGFloat x2 = (screenWidth - indicator.frame.size.width) / 2.0;
        CGFloat y2 = (screenHeight - indicator.frame.size.height-10) / 2.0;
        indicator.frame = CGRectMake(x2, y2, indicator.frame.size.width, indicator.frame.size.height);
        [self addSubview:indicator];
//        PREPCONSTRAINTS(indicator);
//
//        CENTER_VIEW(self, indicator);
        
//        cShieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x2, y2, 40.0, 40.0)];
//        cShieldImageView.image = [UIImage imageNamed:@"loading_fk"];
//        [self addSubview:cShieldImageView];
        
        CGFloat x3 = (screenWidth - 120.0)/2.0;
        CGFloat y3 = y2+10;
        UILabel* text = [[UILabel alloc]initWithFrame:CGRectMake(x3, y3+50, 120, 7)];
        text.text = @"正在加载";
        [text setTextAlignment:NSTextAlignmentCenter];
        text.textColor = [UIColor whiteColor];
        [self addSubview:text];
        
//        [self startAnimation];
    }
    return self;
}

- (void)startAnimation
{
    bRotate = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.08];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    cCircleImageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    cShieldImageView.transform = CGAffineTransformMakeRotation(-angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

- (void)endAnimation
{
    angle += 30;
    
    if (bRotate)
    {
        [self startAnimation];
    }
}

- (void)closeView
{
    bRotate = NO;
}

@end
