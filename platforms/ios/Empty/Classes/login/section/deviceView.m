//
//  deviceView.m
//  Empty
//
//  Created by leron on 15/8/4.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "deviceView.h"

@implementation deviceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, Height);
}

- (void)setMCamState:(E_CAM_STATE)mCamState
{
    _mCamState = mCamState;
    switch (_mCamState)
    {
        case CONN_INFO_CONNECTING:
            self.lblState.text = @"正在连接";
            break;
        case CONN_INFO_CONNECTED:
        {
            NSString * label ;
            label = [NSString stringWithFormat:@"%@",@"已连接"];
            self.lblState.text = label;
        }
            break;
        case CONN_INFO__OVER_MAX:
            
            self.lblState.text = @"达到最大连接数";
            break;
        default:
            self.lblState.text = @"失去连接";
            break;
    }
}


@end
