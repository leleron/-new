//
//  FKManageDeviceViewController.m
//  Empty
//
//  Created by leron on 15/8/26.
//  Copyright (c) 2015年 李荣. All rights reserved.
//

#import "FKManageDeviceViewController.h"
#import "addProductSection.h"
#import "ItemListSection.h"
#import "FKDeviceNameViewController.h"
#import "deleteDeviceMock.h"
#import "FKDevicePswViewController.h"
#import "FKDeviceStatusViewController.h"
#import "ConfigNetViewController.h"
#import "FKUpdateDeviceViewController.h"
#import "DeviceErrorListViewController.h"
@interface FKManageDeviceViewController ()
@property(strong,nonatomic)deleteDeviceMock* myMock;
@property(assign ,nonatomic)BOOL isPrimary;
@end

@implementation FKManageDeviceViewController

- (void)viewDidLoad {
    self.navigationBarTitle = @"设置";
    [super viewDidLoad];
    self.pAdaptor = [QUFlatAdaptor adaptorWithTableView:self.pTableView nibArray:@[@"ItemListSection"] delegate:self backGroundClr:Color_Bg_cellldarkblue];
    [self showLeftNormalButton:@"go_back" highLightImage:@"go_back" selector:@selector(back)];
//    if ([self.userType isEqualToString:@"primary"] || !self.cam) {
        for (int i = 0; i<6; i++) {
            QUFlatEntity* e1 = [QUFlatEntity entity];
            e1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            e1.tag = i;
            [self.pAdaptor.pSources addEntity:e1 withSection:[ItemListSection class]];
        }
//    }
    if ([self.userType isEqualToString:@"primary"]) {
        self.isPrimary = YES;
    }else
        self.isPrimary = NO;
//    }else{
//        QUFlatEntity* e1 = [QUFlatEntity entity];
//        e1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        e1.tag = 2;
//        [self.pAdaptor.pSources addEntity:e1 withSection:[addProductSection class]];
//        
//        QUFlatEntity* e2 = [QUFlatEntity entity];
//        e2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        e2.tag = 5;
//        [self.pAdaptor.pSources addEntity:e2 withSection:[addProductSection class]];
//        
//        QUFlatEntity* e3 = [QUFlatEntity entity];
//        e3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        e3.tag = 4;
//        [self.pAdaptor.pSources addEntity:e3 withSection:[addProductSection class]];
//
//        
//    }
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)QUAdaptor:(QUAdaptor *)adaptor forSection:(QUSection *)section forEntity:(QUEntity *)entity{
    QUFlatEntity* e = (QUFlatEntity*)entity;
    ItemListSection* s = (ItemListSection*)section;
    switch (e.tag) {
        case 0:
            s.lblTitle.text = @"修改设备昵称";
            s.imgIcon.image = [UIImage imageNamed:@"xgnc"];
            break;
        case 1:
            s.lblTitle.text = @"固件升级";
            s.imgIcon.image = [UIImage imageNamed:@"gjsj"];
            break;
        case 2:
            s.lblTitle.text = @"设备管理";
            s.imgIcon.image = [UIImage imageNamed:@"sbgl"];
            break;
        case 3:
            s.lblTitle.text = @"切换网络";
            s.imgIcon.image = [UIImage imageNamed:@"czwl"];
            break;
        case 5:
            s.lblTitle.text = @"查看相册";
            s.imgIcon.image = [UIImage imageNamed:@"ckxc"];
            s.imgLine.hidden = YES;
            break;
        case 4:
            s.lblTitle.text = @"设备故障";
            s.imgIcon.image = [UIImage imageNamed:@"gzxx"];
            break;
        default:
            break;
    }
//    if (e.tag % 2 == 0) {
//        s.backgroundColor = Color_Bg_Nav;
//    }

    
}


-(void)QUAdaptor:(QUAdaptor *)adaptor selectedSection:(QUSection *)section entity:(QUEntity *)entity{
    QUFlatEntity* e = (QUFlatEntity*)entity;
    switch (e.tag) {
        case 0:
        {
            if (self.cam && self.isPrimary) {
                FKDeviceNameViewController* controller = [[FKDeviceNameViewController alloc]initWithNibName:@"FKDeviceNameViewController" bundle:nil];
                controller.deviceId = self.deviceId;
                controller.cam = self.cam;
                [self.navigationController pushViewController:controller animated:YES];
            }
            if (self.cam && !self.isPrimary) {
                [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"副控没有权限修改设备昵称"];
            }
        }
            break;
        case 1:
        {
            if (self.cam && !self.isPrimary) {
                FKUpdateDeviceViewController* controller = [[FKUpdateDeviceViewController alloc]initWithNibName:@"FKUpdateDeviceViewController" bundle:nil];
                controller.cam = self.cam;
                [self.navigationController pushViewController:controller animated:YES];
            }
            if (self.cam && self.isPrimary) {
                [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"副控没有权限固件升级"];
            }

        }
            break;
        case 2:
        {
            if (self.cam) {
                FKDeviceStatusViewController* controller = [[FKDeviceStatusViewController alloc]initWithNibName:@"FKDeviceStatusViewController" bundle:nil];
                controller.cam = self.cam;
                controller.userType = self.userType;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
            
//         case 3:
//        {
//            if (self.cam && self.isPrimary) {
//                FKDevicePswViewController* controller = [[FKDevicePswViewController alloc]initWithNibName:@"FKDevicePswViewController" bundle:nil];
//                controller.obj = self.cam;
//                [self.navigationController pushViewController:controller animated:YES];
//
//            }
//            if (self.cam && !self.isPrimary) {
//                [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"副控没有权限修改设备密码"];
//            }
//
//        }
//            break;
            
        case 3:
        {
            if (self.cam) {
                if (![WpCommonFunction checkWIFI] ) {
                    [WpCommonFunction showNotifyHUDAtViewBottom:self.view withErrorMessage:@"请先打开Wi-Fi"];
                }else{
                
                ConfigNetViewController* controller = [[ConfigNetViewController alloc]initWithNibName:@"ConfigNetViewController" bundle:nil];
                controller.productModel = self.cam.deviceType;
                [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
            break;
        case 5:
        {
            if (self.cam) {
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                ipc.allowsEditing = YES;
                [self.navigationController presentViewController:ipc animated:YES completion:nil];
            }
            
        }
            break;
            
        case 4:
            if (self.cam) {
                DeviceErrorListViewController* controller = [[DeviceErrorListViewController alloc]initWithNibName:@"DeviceErrorListViewController" bundle:nil];
                controller.deviceId = self.cam.nsDeviceId;
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        default:
            break;
    }
}

-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDevice" object:nil];
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
