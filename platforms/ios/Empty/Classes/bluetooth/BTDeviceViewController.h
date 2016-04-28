//
//  BTDeviceViewController.h
//  BluetoothApp
//
//  Created by 信息部－研发 on 15/8/17.
//  Copyright (c) 2015年 信息部－研发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BTDeviceViewController : UIViewController <CBPeripheralDelegate, /*UITableViewDelegate, UITableViewDataSource, */UITextFieldDelegate>

@property (nonatomic, strong) CBPeripheral *curPeripheral;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end
