//
//  MessageSection.h
//  Empty
//
//  Created by 信息部－研发 on 15/9/23.
//  Copyright © 2015年 李荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSection : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgRedDot;
@property (weak, nonatomic) IBOutlet UILabel *lblBriefContent;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgTime;

@end
