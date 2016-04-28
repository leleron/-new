//
//  CollectionWithSalesViewCell.h
//  Empty
//
//  Created by 信息部－研发 on 15/11/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionWithSalesViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
@property (weak, nonatomic) IBOutlet UILabel *lblGoods;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSalesNum;

@end
