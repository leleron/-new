//
//  ProgressView.m
//  
//
//  Created by 刘通超 on 15/1/7.
//  Copyright (c) 2015年 刘通超. All rights reserved.
//

#import "ProgressView.h"
#import "PureLayout.h"
static const CGFloat kPageControlWidth = 148;
#define CLEANER_COLOR [UIColor clearColor].CGColor
@implementation ProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        _inDoorAirQuality = airQuality;
//        _inDoorAirPm = airPm;
        
        self.backgroundColor = [UIColor clearColor];
        _percent = 0;
        _width = 4;
        _flag = 0;

        //ON按钮
    }
    
    return self;
}

//- (void)turnOnOff:(UIButton*)button{
//    if (button.tag == 0) {
//        [button setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
//        button.tag = 1;
//    } else {
//        [button setImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
//        button.tag = 0;
//    }
//    if ([delegate respondsToSelector:@selector(switchChange)]) {// 如果协议响应了switchChange方法
//        
//    }
//}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
//    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
//        NSLog(@"尼玛的, 你在往左边跑啊....");
//    }
//    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
//        NSLog(@"尼玛的, 你在往右边跑啊....");
//    }
    [_delegate handleSwipes:sender];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [_delegate handleTap:sender];
}

- (void)setPercent:(float)percent{
    _percent = percent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if (!_image) {
        [self showCircle];
    }
    [self addArcBackColor];
//    [self addCenterBack];
    [self drawArc];
//    [self addCenterLabel];
    [WpCommonFunction setView:_image cornerRadius:(_image.frame.size.width)/2];
//    [self addText];
}


- (void)addArcBackColor{
    CGColorRef color = (_arcBackColor == nil) ? Color_Bg_celllightblue.CGColor : _arcBackColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
//    if (!self.isTryDevice) {
//        self.image.frame = CGRectMake(_width/2, _width/2, viewSize.width-_width, viewSize.height-_width);
//        [WpCommonFunction setView:_image cornerRadius:(viewSize.width-_width)/2];
//    }

    
    
//    _inDoorAirInfoLabel.frame = CGRectMake(0, viewSize.height/8, viewSize.width, viewSize.height/8);
//    _inDoorAirInfoNumLabel.frame  = CGRectMake(0, viewSize.height/4, viewSize.width, viewSize.height/2 - viewSize.height/15);
    self.PageControl.frame =CGRectMake((self.frame.size.width - kPageControlWidth)/2, self.frame.size.height - 48, kPageControlWidth, 37);
    self.hint1.frame = CGRectMake(0, viewSize.height/4+5, viewSize.width, viewSize.height/2 - viewSize.height/15);
    // Draw the slices.
    CGFloat radius = viewSize.width / 2;
    CGContextSetLineWidth(contextRef, 20);
    CGContextSetRGBStrokeColor(contextRef,0.5,0.5,0.5,1.0);
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, 0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

- (void)drawArc{
//    _percent = 1;
    if (_percent == 0 || _percent > 1) {
        return;
    }
    if (_showStatus == 1 || _showStatus == 0) {
      if(_percent <= 1.0f/3.0f) {
        
        float endAngle = [self getEndAngle:1]*M_PI;
        
        CGColorRef color = (_arcUnfinishColor == nil) ? REDCOLOR.CGColor : _arcUnfinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextSetLineWidth(contextRef, 0.5);
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius, 1.5*M_PI,endAngle, 1);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }else if(_percent <= 2.0f/3.0f){
        float endAngle = [self getEndAngle:1]*M_PI;
        
        CGColorRef color = (_arcUnfinishColor == nil) ? PURPOECOLOR.CGColor : _arcUnfinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextSetLineWidth(contextRef, 0.5);
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius, 1.5*M_PI,endAngle, 1);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    } else {
        float endAngle = [self getEndAngle:_percent]*M_PI;
        
        CGColorRef color = (_arcUnfinishColor == nil) ? BLUECOLOR.CGColor : _arcUnfinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextSetLineWidth(contextRef, 0.5);
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius, 1.5*M_PI,endAngle, 1);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }
}
    if (_showStatus == 3) {
        if (_percent<=0.3) {
            _arcFinishColor = REDCOLOR;
        }else if(_percent>0.3 && _percent<=0.4){
            float xishu = (_percent - 0.3)/0.1;
            _arcFinishColor = [UIColor colorWithRed:(255-xishu*57)/255.0 green:(255*xishu) blue:0 alpha:1];
        }else if (_percent>0.4 && _percent<=0.60999){
            _arcFinishColor = GREENCOLOR;
        }else if (_percent>0.6 && _percent<=0.7){
            float xishu = (_percent - 0.6)/0.1;
            _arcFinishColor = [UIColor colorWithRed:(198 - xishu*197)/255.0 green:(255-118*xishu)/255.0 blue:(254*xishu)/255.0 alpha:1];
        }else{
            _arcFinishColor = BLUECOLOR;
        }
        
        float endAngle = [self getEndAngle:1]*M_PI;
        
        CGColorRef color = _arcFinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextSetLineWidth(contextRef, 0.5);
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius, 1.5*M_PI,endAngle, 1);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }
    
    if (_showStatus == 2) {
        if (_percent>=0.32) {
            _arcFinishColor = REDCOLOR;
        }else if(_percent>0.26 && _percent<=0.32){
            float xishu = 6-(_percent - 0.26)/0.01;
            _arcFinishColor = [UIColor colorWithRed:(255-xishu*57)/255.0 green:(255*xishu) blue:0 alpha:1];
        }else if (_percent>0.18 && _percent<=0.26){
            _arcFinishColor = GREENCOLOR;
        }else if (_percent>0.1 && _percent<=0.18){
            float xishu = 8-(_percent - 0.1)/0.01;
            _arcFinishColor = [UIColor colorWithRed:(198 - xishu*197)/255.0 green:(255-118*xishu)/255.0 blue:(254*xishu)/255.0 alpha:1];
        }else{
            _arcFinishColor = BLUECOLOR;
        }
        
        float endAngle = [self getEndAngle:1]*M_PI;
        
        CGColorRef color = _arcFinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextSetLineWidth(contextRef, 0.5);
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius, 1.5*M_PI,endAngle, 1);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }
    self.PageControl.currentPage = _showStatus;
    
    [WpCommonFunction setView:_image cornerRadius:(_image.frame.size.width)/2];
    
    _flag++;
    
    //室内空气Label
    if (_flag == 2) {
        //        _image.hidden = NO;
        [self addText];
    }

}

-(void)addCenterBack{
    float width = (_width == 0) ? 2 : _width;
    
//    CGColorRef color = (_centerColor == nil) ? [UIColor whiteColor].CGColor : _centerColor.CGColor;
    CGColorRef color = CENTERCOLOR.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    // Draw the slices.
    CGFloat radius = viewSize.width / 2 - width;
    CGContextSetLineWidth(contextRef, 0.5);
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, 0,2*M_PI, 0);
    
//    CGContextAddArc(contextRef, center.x, center.y, radius, 1.5*M_PI,endAngle, 1);
    
//    CGGradientRef myGradient;
//    CGColorSpaceRef myColorspace;
//    size_t num_locations = 2;
//    CGFloat locations[2] = { 0.0, 1.0 };
//    CGFloat components[8] = { 1.0, 0.5, 0.4, 1.0,  // Start color
//        0.8, 0.8, 0.3, 1.0 }; // End color
//    
//    myColorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
//    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
//                                                      locations, num_locations);
//    CGContextDrawRadialGradient(contextRef, myGradient, CGPointMake(0, 0), 0, CGPointMake(viewSize.width/2,viewSize.height), 100, 0);

    
    
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

-(void)showCircle{
    
//    _image = [[UIImageView alloc]initWithFrame:CGRectMake(_width,_width, self.bounds.size.width-_width, self.bounds.size.height-_width)];
    _image = [[UIImageView alloc]init];
    [self addSubview:_image];

    CENTER_VIEW(self, _image);
    [_image autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:2];
    [_image autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:2];
    [_image autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
    [_image autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2];

    _image.image = [UIImage imageNamed:@"controlPage"];
    [WpCommonFunction setView:_image cornerRadius:(_image.frame.size.width)/2];
//    _image.hidden = YES;
    [_image setAutoresizesSubviews:YES];
    
    
//    [self addText];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:leftSwipeGestureRecognizer];
    [self addGestureRecognizer:rightSwipeGestureRecognizer];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    _arcFinishColor = BLUECOLOR;
    
    
    
    
    
}


- (float) getEndAngle:(float)value{
    float engAngle = 0.0f;
    engAngle = (1-value) *2 - 0.5;
    if (engAngle < 0) {
        engAngle = engAngle + 2;
    }
    return engAngle;
}


-(void)addText{
    float hvf = 1.1;
    float height = _image.bounds.size.height;
    float width = _image.bounds.size.width;
    _inDoorAirInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height/7, width, height/8)];
    //    _inDoorAirInfoLabel = [[UILabel alloc] init];
    [_image addSubview:_inDoorAirInfoLabel];
    //        CENTER_VIEW_V(_image, _inDoorAirInfoLabel);
    _inDoorAirInfoLabel.textColor = [UIColor whiteColor];
    //        _inDoorAirInfoLabel.text = _inDoorAirQuality;
    _inDoorAirInfoLabel.textAlignment = NSTextAlignmentCenter;
    //        inDoorAirInfoLabel.backgroundColor = [UIColor grayColor];
    _inDoorAirInfoLabel.font = [UIFont systemFontOfSize:_inDoorAirInfoLabel.frame.size.height*hvf/1.5];
    //让label根据宽度自适应
    _inDoorAirInfoLabel.adjustsFontSizeToFitWidth = YES;
    _inDoorAirInfoLabel.text = @"";
    //室内空气数值Label
    _inDoorAirInfoNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height/5+10, width, height/2 - height/15)];
    _inDoorAirInfoNumLabel.textColor = [UIColor whiteColor];
    //        _inDoorAirInfoNumLabel.text = _inDoorAirPm;
    _inDoorAirInfoNumLabel.textAlignment = NSTextAlignmentCenter;
    _inDoorAirInfoNumLabel.font = [UIFont systemFontOfSize:_inDoorAirInfoNumLabel.frame.size.height*hvf/1.25];
    //        inDoorAirInfoNumLabel.backgrou ndColor = [UIColor greenColor];
    //让label根据宽度自适应
    _inDoorAirInfoNumLabel.adjustsFontSizeToFitWidth = YES;
    [_image addSubview:_inDoorAirInfoNumLabel];
    
    self.hint1 = [[UILabel alloc] initWithFrame:CGRectMake(0, height/4+5, width, height/2 - height/15)];
    self.hint1.text = @"设备不在线";
    self.hint1.textColor = [UIColor whiteColor];
    //        _inDoorAirInfoLabel.text = _inDoorAirQuality;
    self.hint1.textAlignment = NSTextAlignmentCenter;
    //        inDoorAirInfoLabel.backgroundColor = [UIColor grayColor];
    self.hint1.font = [UIFont systemFontOfSize:17];
    //让label根据宽度自适应
    self.hint1.adjustsFontSizeToFitWidth = YES;
    self.hint1.hidden = YES;
    [_image addSubview:self.hint1];
    
    self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - kPageControlWidth)/2, self.frame.size.height - 48, kPageControlWidth, 37)];
    self.PageControl.currentPage = 0;
    self.PageControl.numberOfPages = 4;
    [_image addSubview:self.PageControl];

    _inDoorAirInfoNumLabel.text = @"";
    [_image addSubview:_inDoorAirInfoNumLabel];

}
//- (void)addCenterLabel{
//    NSString *percent = @"";
//
//    float fontSize = 14;
//    UIColor *arcColor = [UIColor blueColor];
//    if (_percent == 1) {
//        percent = @"100%";
//        fontSize = 14;
//        arcColor = (_arcFinishColor == nil) ? [UIColor greenColor] : _arcFinishColor;
//        
//    }else if(_percent < 1 && _percent >= 0){
//        
//        fontSize = 13;
//        arcColor = (_arcUnfinishColor == nil) ? [UIColor blueColor] : _arcUnfinishColor;
//        percent = [NSString stringWithFormat:@"%0.2f%%",_percent*100];
//    }
//    
//    CGSize viewSize = self.bounds.size;
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize],NSFontAttributeName ,arcColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
//
//    [percent drawInRect:CGRectMake(5, (viewSize.height-fontSize)/2, viewSize.width-10, fontSize) withAttributes:attributes];
//}


@end
