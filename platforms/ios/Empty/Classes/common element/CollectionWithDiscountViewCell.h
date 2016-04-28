//
//  CollectionWithDiscountViewCell.h
//  Empty
//
//  Created by 信息部－研发 on 15/11/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionWithDiscountViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
@property (weak, nonatomic) IBOutlet UILabel *lblGoods;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceOriginal;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;

@end
