//
//  BlueNoDeviceCell.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "BlueNoDeviceCell.h"

#define BlueNoDeviceCellBackGroundColor                                                        \
[UIColor colorWithRed:48 / 255.0 green:48 / 255.0 blue:48 / 255.0 alpha:1.0]

@implementation BlueNoDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BlueNoDeviceCellBackGroundColor;
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17.f);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)deviceNameLabel {
    if (! _deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceNameLabel.textColor = [UIColor whiteColor];
        _deviceNameLabel.font = [UIFont ChinaDefaultFontNameOfSize:14];
        _deviceNameLabel.text = @"等待连接...";
        [self addSubview:_deviceNameLabel];
    }
    return _deviceNameLabel;
}

@end
