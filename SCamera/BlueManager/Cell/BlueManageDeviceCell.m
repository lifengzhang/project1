//
//  BlueManageDeviceCell.m
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/27.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import "BlueManageDeviceCell.h"
#import "BlueToothDeviceModel.h"

#define SELECT_BUTTON_WIDTH                     32.f
#define SELECT_BUTTON_HEIGHT                    32.f

@implementation BlueManageDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupConstraints];
    }
    return self;
}

- (void)updateCellContentWithDeviceModel:(BlueToothDeviceModel *)deviceModel isSelected:(BOOL)isSelected {
    self.deviceNameLabel.text = deviceModel.name;
    self.selectButton.selected = isSelected;
}

- (void)setupConstraints {
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(SELECT_BUTTON_WIDTH);
        make.height.mas_equalTo(SELECT_BUTTON_HEIGHT);
    }];
    
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(8.f);
        make.centerY.equalTo(self);
    }];
}

- (UIButton *)selectButton {
    if (! _selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"login_checkbox_selected_no"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"login_checkbox_selected_yes"] forState:UIControlStateSelected];
        _selectButton.selected = NO;
        [self addSubview:_selectButton];
    }
    return _selectButton;
}

- (UILabel *)deviceNameLabel {
    if (! _deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceNameLabel.textColor = [UIColor blackColor];
//        _deviceNameLabel.font = [UIFont DefaultFontOfSize:14];
        [self addSubview:_deviceNameLabel];
    }
    return _deviceNameLabel;
}

@end
