//
//  CollectionWithDiscountViewCell.m
//  Empty
//
//  Created by 信息部－研发 on 15/11/24.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import "CollectionWithDiscountViewCell.h"

@implementation CollectionWithDiscountViewCell

- (void)awakeFromNib {
    // Initialization code
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.lblPriceOriginal.attributedText];
    [attrStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.lblPriceOriginal.attributedText.length)];
    self.lblPriceOriginal.attributedText = attrStr;

}

@end
