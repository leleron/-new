//
//  ViewController.m
//  NMBottomTabBarExample
//
//  Created by Prianka Liz Kariat on 04/12/14.
//  Copyright (c) 2014 Prianka Liz. All rights reserved.
//

#import "NMBottomTabBarController.h"
#import "MYBlurIntroductionView.h"
#import "MYIntroductionPanel.h"

@interface NMBottomTabBarController ()<MYIntroductionDelegate>
@property(strong,nonatomic)MYBlurIntroductionView* myView;

@end

@implementation NMBottomTabBarController
@synthesize controllers = _controllers;

-(id)init{
    
    self = [super init];
    if(self){
        
        containerView = [UIView new];
        [self.view addSubview:containerView];

        
        self.tabBar = [NMBottomTabBar new];
        selectedIndex = -1;
        self.controllers = [NSArray new];
        [self.view addSubview:self.tabBar];
        
        
        [self setUpConstraintsForContainerView];
        [self setUpConstraintsForTabBar];
        
        [self.tabBar setDelegate:self];
        
    }
    return self;
}
-(void)awakeFromNib{

    self.tabBar = [NMBottomTabBar new];
    selectedIndex = -1;
    self.controllers = [NSArray new];
    [self.view addSubview:self.tabBar];
    
    containerView = [UIView new];
    [self.view addSubview:containerView];
    
    [self setUpConstraintsForContainerView];
    [self setUpConstraintsForTabBar];
    
    [self.tabBar setDelegate:self];
    

  
}

-(void)setControllers:(NSArray *)controllers{
    
    _controllers = controllers;
     [self.tabBar layoutTabWihNumberOfButtons:self.controllers.count];

}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    


    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)showBasicIntroWithBg {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) nibNamed:@"TestPanel1"];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) nibNamed:@"TestPanel2"];
    
    
    //Create Panel From Nib
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) nibNamed:@"TestPanel3"];
    
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3];
    
    //Create the introduction view and set its delegate
    self.myView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.myView.delegate = self;
    //    self.myView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [self.myView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:self.myView];
    
}

-(void)introDidFinish{
    // 保存已经看完的标记
    [WpCommonFunction saveDeviceLookoverGuidePageToLocal];
    self.myView.hidden = YES;
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
    [WpCommonFunction saveDeviceLookoverGuidePageToLocal];
    self.myView.hidden = YES;
}



-(void)setUpConstraintsForTabBar{
    
    NMBottomTabBar *tempTabBar = self.tabBar;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tempTabBar(==50)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tempTabBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar)]];
    [tempTabBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view setNeedsLayout];

    
}
-(void)setUpConstraintsForContainerView {
    
    NMBottomTabBar *tempTabBar = self.tabBar;

//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[containerView]-0-[tempTabBar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar,containerView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(containerView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(containerView)]];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view setNeedsLayout];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectTabAtIndex:(NSInteger)index{
   
    
    BOOL isFirst = [WpCommonFunction getDeviceDoesLookoverGuidePageFromLocal];
    if (!isFirst) {
        [self showBasicIntroWithBg];
    }
    
   [self.tabBar setTabSelectedWithIndex:index];
}
-(void)didSelectTabAtIndex:(NSInteger)index{

    
    
    
    
     if(selectedIndex == -1){
        
        UIViewController *destinationController = [self.controllers objectAtIndex:index];
        [self addChildViewController:destinationController];
        [destinationController didMoveToParentViewController:self];
        [containerView addSubview:destinationController.view];
        [self setUpContsraintsForDestinationCOntrollerView:destinationController.view];
        selectedIndex = index;
        
    }
    else if(selectedIndex != index){
        
        UIViewController *sourceController = [self.controllers objectAtIndex:selectedIndex];
        UIViewController *destinationController = [self.controllers objectAtIndex:index];
        [self addChildViewController:destinationController];
        [destinationController didMoveToParentViewController:self];
        [self transitionFromViewController:sourceController toViewController:destinationController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            
        
        } completion:^(BOOL finished) {
            
            [sourceController willMoveToParentViewController:nil];
            [sourceController removeFromParentViewController];
            selectedIndex = index;
            [self setUpContsraintsForDestinationCOntrollerView:destinationController.view];
            if([self.delegate respondsToSelector:@selector(didSelectTabAtIndex:)]){
                
                [self.delegate didSelectTabAtIndex:selectedIndex];
            
            }
        }];
        
    }

   
}
-(BOOL)shouldSelectTabAtIndex:(NSInteger)index{
    
    if([self.delegate respondsToSelector:@selector(shouldSelectTabAtIndex:)]){
    
    return [self.delegate shouldSelectTabAtIndex:index];
    }
    return YES;
    
}
-(void)setUpContsraintsForDestinationCOntrollerView : (UIView *)view {
    
    
    if (selectedIndex == 1) {
        NSArray *arrayConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
        NSLayoutConstraint* fisrt = [arrayConstraint lastObject];
        fisrt.identifier= @"containtBottom";
        [containerView addConstraints:arrayConstraint];
    }else{
        NSArray *arrayConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
        NSLayoutConstraint* fisrt = [arrayConstraint lastObject];
        fisrt.identifier= @"containtBottom";
        [containerView addConstraints:arrayConstraint];
    }
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView setNeedsLayout];

}

-(void)hideTabBar{
    self.tabBar.hidden = YES;
    NMBottomTabBar *tempTabBar = self.tabBar;
    [self.view removeConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[containerView]-0-[tempTabBar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar,containerView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar,containerView)]];
    for (NSLayoutConstraint* item in containerView.constraints) {
        if ([item.identifier isEqualToString:@"containtBottom"] && selectedIndex == 1) {
            item.constant = 0;
            
        }
    }
}

-(void)showTarBar{
    self.tabBar.hidden = NO;
    NMBottomTabBar *tempTabBar = self.tabBar;
    [self.view removeConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar,containerView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[containerView]-0-[tempTabBar]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tempTabBar,containerView)]];
    for (NSLayoutConstraint* item in containerView.constraints) {
        if ([item.identifier isEqualToString:@"containtBottom"] && selectedIndex == 1) {
            item.constant = 50;
        }
    }
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
