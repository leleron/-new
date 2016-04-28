//
//  NativeShopViewController.m
//  Empty
//
//  Created by 信息部－研发 on 15/11/16.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "NativeShopViewController.h"
#import "CycleScrollView.h"
#import "MessageSection.h"
#import "goodsMock.h"
#import "goodView.h"
#import "CollectionWithSalesViewCell.h"
#import "CollectionWithDiscountViewCell.h"
#import "UIView+ConstraintHelper.h"
#import "PureLayout.h"

#define LEFT_MARGIN_LENGTH 50
#define START_HEIGHT  200
#define START_WIDTH   (SCREEN_WIDTH-LEFT_MARGIN_LENGTH*2)/2
#define HEIGHT_OFFSET 10
#define colorSpace  CGColorSpaceCreateDeviceRGB()
#define borderColorRef  CGColorCreate(colorSpace,(CGFloat[]){0.5, 0.5, 0.5, 0.25})

@interface NativeShopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel* lblStar;
    NSMutableArray* arrayStar;
    UILabel* lblNew;
    NSMutableArray* arrayNew;
    UILabel* lblHot;
    NSMutableArray* arrayHot;
    UILabel* lblSpe;
    NSMutableArray* arraySpe;
    float scrollHeight;
}
@property (strong, nonatomic) UISearchBar *myTitleSearch;
@property (strong, nonatomic) CycleScrollView *myCycleView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionGoodsList;
//@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionGoodsListFlowLayout;
@property (weak, nonatomic) IBOutlet UIView *viewScrollAd;
@property (weak, nonatomic) IBOutlet UIButton *btnNewGoods;
@property (weak, nonatomic) IBOutlet UIButton *btnSecKill;
@property (weak, nonatomic) IBOutlet UIButton *btnPreference;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSMutableArray *mySections;
@property (strong, nonatomic) NSMutableArray *myData;
@property (strong, nonatomic) goodsMock *myGoodsMock;
@end

@implementation NativeShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAD];
    
    self.myTitleSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.myTitleSearch.backgroundColor = [UIColor clearColor];
    self.myTitleSearch.placeholder = @"剃须刀";
    self.myTitleSearch.delegate = self;
    self.myTitleSearch.tintColor = [UIColor blackColor];
    [self showLeftNormalButton:@"iconfont-fenlei" highLightImage:@"iconfont-fenlei" selector:@selector(showCategory)];
    self.navigationItem.titleView = self.myTitleSearch;
    UIBarButtonItem *rightMoreOption = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-gengduo"] style:UIBarButtonItemStylePlain target:self action:@selector(showMoreOption)];
    UIBarButtonItem *rightShoppingCart = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-gouwuche"] style:UIBarButtonItemStylePlain target:self action:@selector(showShoppingCart)];
    NSArray *rightButtons = [NSArray arrayWithObjects:rightMoreOption, rightShoppingCart, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;

//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){0.5, 0.5, 0.5, 0.25});
    
    [self.btnNewGoods addTarget:self action:@selector(newGoods) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgNewGoods = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-newzi"]];
    [imgNewGoods setFrame:CGRectMake(45, 10, imgNewGoods.image.size.width, imgNewGoods.image.size.height)];
    
    UILabel *lblNewGoods = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 50, 100)];
    lblNewGoods.text = @"新品";
    [self.btnNewGoods addSubview:imgNewGoods];
    [self.btnNewGoods addSubview:lblNewGoods];
    self.btnNewGoods.layer.borderWidth = 1.0f;
    self.btnNewGoods.layer.borderColor = borderColorRef;

    [self.btnSecKill addTarget:self action:@selector(secKill) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgSecKill = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-miaosha2x"]];
    [imgSecKill setFrame:CGRectMake(45, 10, imgSecKill.image.size.width, imgSecKill.image.size.height)];
    
    UILabel *lblSecKill = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 50, 100)];
    lblSecKill.text = @"秒杀";
    [self.btnSecKill addSubview:imgSecKill];
    [self.btnSecKill addSubview:lblSecKill];
    self.btnSecKill.layer.borderWidth = 1.0f;
    self.btnSecKill.layer.borderColor = borderColorRef;

    [self.btnPreference addTarget:self action:@selector(preference) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgPreference = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-huilvhui"]];
    [imgPreference setFrame:CGRectMake(45, 10, imgPreference.image.size.width, imgPreference.image.size.height)];
 
    UILabel *lblPreference = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 50, 100)];
    lblPreference.text = @"特惠";
    [self.btnPreference addSubview:imgPreference];
    [self.btnPreference addSubview:lblPreference];
    self.btnPreference.layer.borderWidth = 1.0f;
    self.btnPreference.layer.borderColor = borderColorRef;
    
    
    self.mySections = [[NSMutableArray alloc] initWithArray:@[@"明星产品", @"新品上市", @"热卖产品", @"特价产品"]];
    self.myData = [[NSMutableArray alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    for (UIView *subViewItem in self.view.subviews) {
        if ([subViewItem isKindOfClass:[UICollectionView class]]) {
            NSLog(@"width = %f, height = %f", subViewItem.frame.size.width, subViewItem.frame.size.height);
        }
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
//    });

}

-(void)updateViewConstraints{
    [self addConstraints:lblStar:arrayStar];
    [self addConstraints:lblNew:arrayNew];
    [self addConstraints:lblHot :arrayHot];
    [self addConstraints:lblSpe :arraySpe];
    [super updateViewConstraints];
    NSLog(@"scroll.height:%f",self.baseScrollView.contentSize.height);
    NSLog(@"content.height:%f",self.contentView.frame.size.height);
}

-(void)addConstraints:(UILabel*)lblHint:(NSMutableArray*)array{

    if (array.count == 3) {
        [array[0] constrainSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[0] constrainPosition:CGPointMake(LEFT_MARGIN_LENGTH, lblHint.frame.origin.y+lblHint.frame.size.height+3)];
        [array[1] constrainSize:CGSizeMake(START_WIDTH, START_HEIGHT/2)];
        [array[1] constrainPosition:CGPointMake(LEFT_MARGIN_LENGTH+START_WIDTH, lblHint.frame.origin.y+lblHint.frame.size.height+3)];
        [array[2] constrainSize:CGSizeMake(START_WIDTH, START_HEIGHT/2)];
        [array[2] constrainPosition:CGPointMake(LEFT_MARGIN_LENGTH+START_WIDTH, lblHint.frame.origin.y+lblHint.frame.size.height+3+START_HEIGHT/2)];
    }
    if (array.count == 4) {
        [array[0] constrainSize:CGSizeMake(START_WIDTH, START_HEIGHT/2)];
        [array[0] constrainPosition:CGPointMake(LEFT_MARGIN_LENGTH, lblHint.frame.origin.y+lblHint.frame.size.height+3)];
        [array[1] constrainSize:CGSizeMake(START_WIDTH, START_HEIGHT/2)];
        [array[1] constrainPosition:CGPointMake(LEFT_MARGIN_LENGTH+START_WIDTH, lblHint.frame.origin.y+lblHint.frame.size.height+3)];
        [array[2] constrainSize:CGSizeMake(START_WIDTH, START_HEIGHT/2)];
        [array[2] constrainPosition:CGPointMake(LEFT_MARGIN_LENGTH, lblHint.frame.origin.y+lblHint.frame.size.height+START_HEIGHT/2+3)];
        [array[3] constrainSize:CGSizeMake(START_WIDTH, START_HEIGHT/2)];
        [array[3] constrainPosition:CGPointMake(LEFT_MARGIN_LENGTH+START_WIDTH, lblHint.frame.origin.y+lblHint.frame.size.height+3+START_HEIGHT/2)];
    }
    if (array.count == 9) {
        [array[0] autoSetDimensionsToSize:CGSizeMake(START_WIDTH*2, START_HEIGHT)];
        [array[0] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lblHot withOffset:HEIGHT_OFFSET];
        [array[0] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LEFT_MARGIN_LENGTH];
        [array[1] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[1] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[0] withOffset:0];
        [array[1] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LEFT_MARGIN_LENGTH];
        [array[2] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[2] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:array[1] withOffset:0];
        [array[2] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[0] withOffset:0];
        [array[3] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[3] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LEFT_MARGIN_LENGTH];
        [array[3] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[1] withOffset:0];
        [array[4] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[4] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:array[3] withOffset:0];
        [array[4] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[2] withOffset:0];
        [array[5] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT*3)];
        [array[5] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[3] withOffset:0];
        [array[5] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:LEFT_MARGIN_LENGTH];
        [array[6] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[6] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:array[5] withOffset:0];
        [array[6] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[4] withOffset:0];
        [array[7] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[7] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:array[5] withOffset:0];
        [array[7] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[6] withOffset:0];
        [array[8] autoSetDimensionsToSize:CGSizeMake(START_WIDTH, START_HEIGHT)];
        [array[8] autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:array[5] withOffset:0];
        [array[8] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:array[7] withOffset:0];
    }
}

- (void)initQuickMock {
    self.myGoodsMock = [goodsMock mock];
    self.myGoodsMock.delegate = self;
    
    goodsParam *param = [goodsParam param];
    param.sendMethod = @"POST";
    self.myGoodsMock.operationType = [NSString stringWithFormat:@"%@%@", SHOP_BASE_URL, @"index.get.index.new"];

    [self.myGoodsMock run:param];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark QUMock Delegate
- (void)QUMock:(QUMock *)mock entity:(QUEntity *)entity {
    if ([mock isKindOfClass:[goodsMock class]]) {
        goodsEntity *e = (goodsEntity *)entity;
        [self.webView loadHTMLString:e.Data baseURL:nil];
//        [self.myData addObjectsFromArray:e.Data];
    }
}


-(void)createView{
    lblStar = [[UILabel alloc]initWithFrame:CGRectMake(50, self.btnNewGoods.frame.origin.y+self.btnNewGoods.frame.size.height, 200, 50)];
    lblStar.text = @"明星产品";
    lblStar.attributedText = [[NSAttributedString alloc]initWithString:@"明星产品" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [self.contentView addSubview:lblStar];
    arrayStar = [[NSMutableArray alloc]init];
    for (int i = 0; i<3; i++) {
        goodView* star = [QUNibHelper loadNibNamed:@"goodView" ofClass:[goodView class]];
        star.lblPrice.text = @"50";
        star.lblGoods.text = @"ss";
        star.layer.borderWidth = 1.0f;
        star.layer.borderColor = borderColorRef;
        star.translatesAutoresizingMaskIntoConstraints = NO;
        [arrayStar addObject:star];
        [self.contentView addSubview:star];
    }
    
    lblNew = [[UILabel alloc]initWithFrame:CGRectMake(50, lblStar.frame.origin.y+lblStar.frame.size.height+START_HEIGHT+HEIGHT_OFFSET, 200, 50)];
    lblNew.text = @"新品上市";
    [self.contentView addSubview:lblNew];
    arrayNew = [[NSMutableArray alloc]init];
    for (int i = 0; i<4; i++) {
        goodView* star = [QUNibHelper loadNibNamed:@"goodView" ofClass:[goodView class]];
        star.lblPrice.text = @"50";
        star.lblGoods.text = @"ss";
        star.layer.borderWidth = 1.0f;
        star.layer.borderColor = borderColorRef;
        star.translatesAutoresizingMaskIntoConstraints = NO;
        [arrayNew addObject:star];
        [self.contentView addSubview:star];
    }
    
    lblHot = [[UILabel alloc]initWithFrame:CGRectMake(50, lblNew.frame.origin.y+lblNew.frame.size.height+START_HEIGHT+HEIGHT_OFFSET, 200, 50)];
    lblHot.text = @"热卖产品";
    arrayHot = [[NSMutableArray alloc]init];
    for (int i = 0;i<9;i++) {
        goodView* hot = [QUNibHelper loadNibNamed:@"goodView" ofClass:[goodView class]];
        hot.lblPrice.text = @"50";
        hot.lblGoods.text = @"ss";
        hot.layer.borderWidth = 1.0f;
        hot.layer.borderColor = borderColorRef;
        hot.translatesAutoresizingMaskIntoConstraints = NO;
        [arrayHot addObject:hot];
        [self.contentView addSubview:hot];

    }
    [self.contentView addSubview:lblHot];
    
    lblSpe = [[UILabel alloc]initWithFrame:CGRectMake(50, lblHot.frame.origin.y+lblHot.frame.size.height+START_HEIGHT*6 + HEIGHT_OFFSET, 200, 50)];
    lblSpe.text = @"特价产品";
    [self.contentView addSubview:lblSpe];
    arraySpe = [[NSMutableArray alloc]init];
    for (int i = 0; i<4; i++) {
        goodView* star = [QUNibHelper loadNibNamed:@"goodView" ofClass:[goodView class]];
        star.lblPrice.text = @"50";
        star.lblGoods.text = @"ss";
        star.layer.borderWidth = 1.0f;
        star.layer.borderColor = borderColorRef;
        star.translatesAutoresizingMaskIntoConstraints = NO;
        [arraySpe addObject:star];
        [self.contentView addSubview:star];
    }

}


#pragma mark Navigation Button Selector
- (void)showCategory {
    
}

- (void)showShoppingCart {
    
}

- (void)showMoreOption {
    UITableView* option = [[UITableView alloc]init];
    option.backgroundColor = Color_Bg_cellldarkblue;
    option.delegate = self;
    option.dataSource = self;
    [self.contentView addSubview:option];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"我的订单";
            break;
        case 1:
            cell.textLabel.text = @"待付款订单";
            break;
        case 2:
            cell.textLabel.text = @"售后服务订单";
            break;
        case 3:
            cell.textLabel.text = @"地址管理";
            break;
        case 4:
            cell.textLabel.text = @"我的收藏";
            break;
        case 5:
            cell.textLabel.text = @"商品评价";
            break;
        case 6:
            cell.textLabel.text = @"我的签到";
            break;
        case 7:
            cell.textLabel.text = @"我的积分";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark Searchbar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"changed");
    if (self.myTitleSearch.text.length == 0) {
//        [self setSearchControllerHidden:YES]; //控制下拉列表的隐现
//        searchBar.text = searchBar.placeholder;
    }else{
//        [self setSearchControllerHidden:NO];
        
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"shuould begin");
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = @"";
//    searchBar.text = searchBar.placeholder;
    NSLog(@"did begin");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"did end");
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search clicked");
    [self.myTitleSearch resignFirstResponder];
}

#pragma mark Others
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
        [self.myTitleSearch resignFirstResponder];
}

-(void)addAD{
    NSMutableArray *viewsArray = [@[] mutableCopy];
    CGFloat adHeight = self.viewScrollAd.frame.size.height;
    UIImageView* imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adHeight)];
    imageView1.image = [UIImage imageNamed:@"welcome1.jpg"];
    [viewsArray addObject:imageView1];
    UIImageView* imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adHeight)];
    imageView2.image = [UIImage imageNamed:@"welcome22.jpg"];
    [viewsArray addObject:imageView2];
    UIImageView* imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adHeight)];
    imageView3.image = [UIImage imageNamed:@"welcome3.jpg"];
    [viewsArray addObject:imageView3];
    self.myCycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, adHeight) animationDuration:2];
    self.myCycleView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.myCycleView.totalPagesCount = ^NSInteger(void){
        return 3;
    };
    self.myCycleView.TapActionBlock = ^(NSInteger pageIndex){
        
    };
    [self.viewScrollAd addSubview:self.myCycleView];

}

- (void)newGoods {
    
}

- (void)secKill {
    
}

- (void)preference {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
