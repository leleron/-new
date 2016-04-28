//
//  deviceListSection.m
//  Empty
//
//  Created by leron on 15/6/24.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "deviceListSection.h"

@implementation deviceListSection

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)setMCamState:(E_CAM_STATE)mCamState
{
    _mCamState = mCamState;
    switch (_mCamState)
    {
        case CONN_INFO_CONNECTING:
            self.lblStatus.text = @"正在连接";
            break;
        case CONN_INFO_CONNECTED:
        {
            NSString * label ;
            label = [NSString stringWithFormat:@"%@",@"已连接"];
            self.lblStatus.text = label;
        }
            break;
        case CONN_INFO__OVER_MAX:
            
            self.lblStatus.text = @"达到最大连接数";
            break;
        default:
            self.lblStatus.text = @"未连接";
            break;
    }
}

//-(void)drawRect:(CGRect)rect{
//    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


//@implementation deviceListKVSection : deviceListSection
//
//@end