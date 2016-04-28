//
//  deviceListSection.h
//  Empty
//
//  Created by leron on 15/6/24.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "QUSection.h"
#import "CamObj.h"
@interface deviceListSection : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (nonatomic,strong)NSString *nsName;
@property (nonatomic,strong)NSString *deviceId;
@property(nonatomic,strong)NSString* macId;
@property (nonatomic,assign)E_CAM_STATE mCamState;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@end


//@interface deviceListKVSection : deviceListSection
//
//@end