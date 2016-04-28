//
//  ItemListSection.h
//  Empty
//
//  Created by leron on 15/6/11.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUSection.h"

@interface ItemListSection : QUSection

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@end

@interface HeadSection : ItemListSection
//@property (weak, nonatomic) IBOutlet UIButton *btnHead;
@property (weak, nonatomic) IBOutlet UILabel *lblNickName;
@property (weak, nonatomic) IBOutlet UILabel *lblHadLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;


@end