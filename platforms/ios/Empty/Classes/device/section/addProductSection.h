//
//  addProductSection.h
//  Empty
//
//  Created by leron on 15/6/18.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addProductSection : QUSection

@property (weak, nonatomic) IBOutlet UILabel *lblProductionName;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@end


@interface dateSelectSection : addProductSection
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgYes;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@end