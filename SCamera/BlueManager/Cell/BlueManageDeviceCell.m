//
//  BlueManageDeviceCell.m
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/27.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import "BlueManageDeviceCell.h"
#import "BlueToothDeviceModel.h"

#define BlueManageDeviceCellBackGroundColor                                                        \
[UIColor colorWithRed:48 / 255.0 green:48 / 255.0 blue:48 / 255.0 alpha:1.0]

#define MYDEVICE_LINE_VIEW_COLOR                                       \
[UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:55 / 255.0 alpha:1.0];

#define SELECT_BUTTON_WIDTH                     32.f
#define SELECT_BUTTON_HEIGHT                    32.f

#define LINEVIEW_HEIGHT                          1.f
#define LINEVIEW_DISTANCE_LEFT                  17.f

#define DEVICELABEL_MARGE_SELECT_BUTTON          8.f

@implementation BlueManageDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BlueManageDeviceCellBackGroundColor;
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
        make.left.equalTo(self.selectButton.mas_right).offset(DEVICELABEL_MARGE_SELECT_BUTTON);
        make.centerY.equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LINEVIEW_DISTANCE_LEFT);
        make.right.bottom.equalTo(self);
        make.height.mas_offset(LINEVIEW_HEIGHT);
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
        _deviceNameLabel.textColor = [UIColor whiteColor];
        _deviceNameLabel.font = [UIFont ChinaDefaultFontNameOfSize:14];
        [self addSubview:_deviceNameLabel];
    }
    return _deviceNameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = MYDEVICE_LINE_VIEW_COLOR
        [self addSubview:_lineView];
    }
    return  _lineView;
}

@end
