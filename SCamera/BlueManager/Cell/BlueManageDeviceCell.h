//
//  BlueManageDeviceCell.h
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/27.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueToothDeviceModel;

@interface BlueManageDeviceCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UILabel *deviceNameLabel;

@property (nonatomic, strong) UIView *lineView;

- (void)updateCellContentWithDeviceModel:(CBPeripheral *)deviceModel isSelected:(BOOL)isSelected;

@end
