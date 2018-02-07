//
//  BlueManageDeviceTableView.h
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/27.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueToothDeviceModel;

@protocol BlueManageDeviceTableViewDelegate <NSObject>

- (void)blueManageDeviceTableView:(UITableView *)tableView selectButtonClickedAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BlueManageDeviceTableView : UITableView

@property (nonatomic, weak) id<BlueManageDeviceTableViewDelegate> manageDeviceTableDelegate;

- (void)reloadWithBlueToothDeviceList:(NSArray<BlueToothDeviceModel *> *)blueToothDeviceList connectBlueToothDevice:(BlueToothDeviceModel *)connectBlueToothDevice;

@end
