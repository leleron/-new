//
//  MNWheelView.m
//  Tab学习
//
//  Created by qsit on 15-1-6.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MNWheelView.h"
#import "deviceView.h"

//快速生成颜色
#define MNRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

@interface MNWheelView()
{
//    UIView *_baseView;
    BOOL anibool;
    int _index;
}

@end
@implementation MNWheelView

-(instancetype)init
{
    
    if (self=[super init]) {
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.height>0) {
        if( _baseView==nil){
            [self viewDidLoad];
        }
    }
    
}
- (void)viewDidLoad
{
    _click=^(int i)
    {
        NSLog(@"单击了第%d项",i);
    };
    _baseView=[[UIView alloc]init];
    _baseView.frame=self.bounds;
    NSLog(@"_%f",_baseView.frame.size.height);
    [self addSubview:_baseView];
  //  [self createView];

    anibool=YES;
//    UISwipeGestureRecognizer *rec=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
//    rec.direction=UISwipeGestureRecognizerDirectionUp;
//    [self addGestureRecognizer:rec];
//    UISwipeGestureRecognizer *recdown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    UIPanGestureRecognizer* drop = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(drop:)];
    [self addGestureRecognizer:drop];
//    UIPanGestureRecognizer* dropDown = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dropDown:)];
//    [self addGestureRecognizer:dropDown];
//    recdown.direction=UISwipeGestureRecognizerDirectionDown;
//    [self addGestureRecognizer:recdown];
    
}
-(void)setImages:(NSArray *)images
{
    _images=images;

    int count=(int)images.count;
//    int mid=count/2;
//    CGFloat Height=300;
//    CGFloat smallH=30;
//    if (count>6) {
//        smallH=20;
//    }
//    CGFloat myH=_baseView.frame.size.height-smallH*mid*2;
    
    for (int i=0; i<count; i++) {
        deviceView *view1 = [images objectAtIndex:i];
        self.lastDeviceId = view1.deviceId;
        CGRect rect = [[UIScreen mainScreen] bounds];
        view1.frame = CGRectMake(0, i*(SCREEN_HEIGHT - SCREEN_WIDTH - 114)/(count-1)-15 , rect.size.width, SCREEN_WIDTH);
//        view1.image=images[i];
        view1.backgroundColor=[UIColor clearColor];
        view1.tag=i+1;
        //view1.clipsToBounds  = YES;
        //添加四个边阴影
        view1.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        view1.layer.shadowOffset = CGSizeMake(4,4);//偏移距离
        view1.layer.shadowOpacity = 0.8;//不透明度
        view1.layer.shadowRadius = 2.0;//半径
        // view1.contentMode=UIViewContentModeScaleAspectFill;
        // view1.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        
        
        UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame=view1.frame;
        btn3.backgroundColor=[UIColor clearColor];
        btn3.tag=view1.tag;
        [btn3 addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn3];
        
        [_baseView addSubview:view1];
        
        // }
        
        
    }
    
//    CGFloat btnX=_baseView.frame.origin.x;
//    CGFloat btnY=_baseView.frame.origin.y;
//    CGFloat btnW=_baseView.frame.size.width;
//    CGFloat btnH=smallH*mid;
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
//    btn.tag=1;
//    btn.backgroundColor=[UIColor clearColor];
//    [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn];
//    
//    
//    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame=CGRectMake(btnX, btnY+myH+smallH*mid, btnW, btnH);
//    btn2.backgroundColor=[UIColor clearColor];
//    btn2.tag=2;
//    [btn2 addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn2];
    
//    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn3.frame=CGRectMake(2, smallH*mid, _baseView.frame.size.width-4, myH);
//    btn3.backgroundColor=[UIColor clearColor];
//    btn3.tag=3;
//    [btn3 addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn3];

}
-(void)setImageNames:(NSArray *)imageNames
{
    _imageNames=imageNames;
    int count=(int)imageNames.count;
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<count; i++) {
        UIImage *image=[UIImage imageNamed:imageNames[i]];
        [array addObject:image];
    }
    [self setImages:array];
    
}


-(void)drop:(UIPanGestureRecognizer*)gesture{

    CGPoint translation = [gesture translationInView:self];
    unsigned long count=_baseView.subviews.count;

    UIView* item =[[_baseView subviews]lastObject];

//    if (gesture.state != UIGestureRecognizerStateEnded && gesture.state != UIGestureRecognizerStateFailed){
//        //通过使用 locationInView 这个方法,来获取到手势的坐标
//        CGPoint location = [gesture locationInView:gesture.view.superview];
////        item.center = location;
//        item setFrame:CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
//    }

//    if (gesture.state == UIGestureRecognizerStateChanged) {
//        [UIView animateWithDuration:0.2 animations:^{
//            UIView* item =[[_baseView subviews]lastObject];
//            [item setFrame:CGRectOffset(item.frame, 0, translation.y)];
//            [gesture setTranslation:CGPointZero inView:item];
//        }];
//    }
//    
    
    [UIView animateWithDuration:0.2 animations:^{
                UIView* item =[[_baseView subviews]lastObject];
                [item setFrame:CGRectOffset(item.frame, 0, translation.y)];
                [gesture setTranslation:CGPointZero inView:item];
//            }
    }completion:^(BOOL finished) {
        
        if (gesture.state == UIGestureRecognizerStatePossible) {
        
        
        anibool=YES;
        UIView* last =[_baseView.subviews lastObject];
        if (translation.y>0) {     //向下划
            
        if (translation.y>20) {
            [self transDown];
        }else{
            
            [UIView animateWithDuration:0.2 animations:^{
                //        CGRect rect=[[_baseView viewWithTag:1] frame];
                int i = 0;
                CGRect rect = [[UIScreen mainScreen] bounds];
                for (UIView* item in [_baseView subviews]) {
                    [item setFrame:CGRectMake(0, i*(SCREEN_HEIGHT - SCREEN_WIDTH - 114)/(count-1)-15 , rect.size.width, SCREEN_WIDTH)];
                    i++;
                }
            }];
            
        }
            
        }
        else{
            
            if (translation.y<-20) {
                [self transUp];
            }else{
                
                [UIView animateWithDuration:0.2 animations:^{
                    //        CGRect rect=[[_baseView viewWithTag:1] frame];
                    int i = 0;
                    CGRect rect = [[UIScreen mainScreen] bounds];
                    for (UIView* item in [_baseView subviews]) {
                        [item setFrame:CGRectMake(0,i*(SCREEN_HEIGHT - SCREEN_WIDTH - 114)/(count-1)-15 , rect.size.width, SCREEN_WIDTH)];
                        i++;
                    }
                }];

                
            }
            
        }
//                    [self bigtop];
    }
     
     }];
    
    
//    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x,
//                                         gesture.view.center.y + translation.y);

}


-(void)transDown{
//    CGFloat minH=0;
    UIView *minHiew;
    minHiew = [_baseView.subviews lastObject];
    [_baseView sendSubviewToBack:minHiew];
    deviceView* last = [_baseView.subviews lastObject];
    self.lastDeviceId = last.deviceId;     //获取最后一个设备的deviceid
    [UIView animateWithDuration:0.2 animations:^{
        int i = 0;
        unsigned long count=_baseView.subviews.count;
        CGRect rect = [[UIScreen mainScreen] bounds];
        for (UIView* item in [_baseView subviews]) {
            [item setFrame:CGRectMake(0,  i*(SCREEN_HEIGHT - SCREEN_WIDTH - 114)/(count-1)-15 , rect.size.width, SCREEN_WIDTH)];
            i++;
        }
        
    } completion:^(BOOL finished) {
        anibool=YES;
//                    [self bigtop];
    }];
    
}


-(void)transUp{
 
//    CGFloat minH=10000;
    UIView *minHiew;
    minHiew = [_baseView.subviews objectAtIndex:0];
    [minHiew removeFromSuperview];
    [_baseView addSubview:minHiew];
    
    deviceView* last = [_baseView.subviews lastObject];
    self.lastDeviceId = last.deviceId;     //获取最后一个设备的deviceid
    
    [UIView animateWithDuration:0.2 animations:^{
        
        int i = 0;
        unsigned long count=_baseView.subviews.count;
        CGRect rect = [[UIScreen mainScreen] bounds];
        for (UIView* item in [_baseView subviews]) {
            [item setFrame:CGRectMake(0,  i*(SCREEN_HEIGHT - SCREEN_WIDTH - 114)/(count-1)-10 , rect.size.width, SCREEN_WIDTH)];
            i++;
        }
        
    } completion:^(BOOL finished) {
        anibool=YES;
//                    [self bigtop];
    }];


}

-(void)swipeUp:(UISwipeGestureRecognizer *)zer
{
    if (zer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        [self setAllFramge:0];
    }else if(zer.direction==UISwipeGestureRecognizerDirectionDown)
    {
        [self setAllFramge:1];
    }
}

-(void)chick:(UIButton *)btn
{
//    if (btn.tag==3) {
        
        _click(btn.tag);
//        NSLog(@"单击了");
//    }else
//    {
//        [self setAllFramge:(int)btn.tag];
//    }
    
}
-(void)setAllFramge:(int)tag
{
    
    if (anibool==NO) {
        return;
    }
    
    anibool=NO;
    unsigned long count=_baseView.subviews.count;
    if (tag==1) {
        CGFloat minH=0;
        UIView *minHiew;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            CGFloat min=CGRectGetMaxY(view1.frame);
            if (min>minH) {
                minH=min;
                minHiew=[_baseView viewWithTag:i];
            }
            
        }
        if (minH>0) {
            for (int j=0; j<count; j++)[_baseView sendSubviewToBack:minHiew];

        }
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect=[[_baseView viewWithTag:1] frame];
            for (int i=1; i<count+1; i++)
            {
                
                if (i==count) {
                    [[_baseView viewWithTag:i] setFrame:rect];
                }
                else
                {
                    [[_baseView viewWithTag:i] setFrame:[[_baseView viewWithTag:i+1] frame]];
                }
            }
            
            
        } completion:^(BOOL finished) {
            anibool=YES;
//            [self bigtop];
        }];
        
    }else
    {
        
        CGFloat minH=10000;
        UIView *minHiew;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            CGFloat min=CGRectGetMinY(view1.frame);
            if (min<minH) {
                minH=min;
                minHiew=[_baseView viewWithTag:i];
            }
        }
        if (minH<10000) {
            for (int j=0; j<count; j++)[_baseView sendSubviewToBack:minHiew];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect=[[_baseView viewWithTag:count] frame];
            for (int i=1; i<count+1; i++)
            {
                
                if (i==count) {
                    [[_baseView viewWithTag:1] setFrame:rect];
                }
                else
                {
                    
                    [[_baseView viewWithTag:count-i+1] setFrame:[[_baseView viewWithTag:count-i] frame]];
                }
            }
            
            
        } completion:^(BOOL finished) {
            anibool=YES;
//            [self bigtop];
            
        }];
        
        
        
    }
    
    
}

//-(void)bigtop
//{
//    unsigned long count=_baseView.subviews.count;
//    CGFloat maxW=0;
//    UIView *maxHiew;
//    for (int i=1; i<count+1; i++)
//    {
//        UIView *view1=[_baseView viewWithTag:i];
//        if (view1.frame.size.width>maxW) {
//                maxW=view1.frame.size.width;
//                maxHiew=[_baseView viewWithTag:i];
//                _index=i;
//            }
//            
//        }
//        if (maxW>0) {
//            for (int j=0; j<count; j++)[_baseView bringSubviewToFront:maxHiew];
//         
//        }
//
//}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
