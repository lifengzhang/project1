//
//  SCameraFlashLightGeneralSettingCell.m
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraFlashLightGeneralSettingCell.h"

@interface SCameraFlashLightGeneralSettingCell ()

@property (nonatomic, strong) UIView *centerLine;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation SCameraFlashLightGeneralSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpConstraints];
        self.backgroundColor = Scamera_Cell_Background;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)setUpConstraints {
    
    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:34]);
    }];
    
    [self.startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(Width_Screen/4);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(self.centerLine.mas_height);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomLine.mas_left);
        make.right.equalTo(self.centerLine.mas_left);
        make.top.bottom.equalTo(self);
    }];
    
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(self.centerLine.mas_height);
        make.width.mas_equalTo(132.f);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
}

- (void)enableView {

    self.startImage.image = [UIImage imageNamed:@"FlashLight_Stop"];
    [self.testButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.testButton.enabled = YES;
    
}

- (void)disableView {
    
    self.startImage.image = [UIImage imageNamed:@"FlashLight_Start"];
    [self.testButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.testButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.testButton.enabled = NO;
}

- (UIImageView *)startImage {
    if (!_startImage) {
        _startImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (FlashLightManager.isMainStartSelected) {
            _startImage.image = [UIImage imageNamed:@"FlashLight_Start"];
        } else {
            _startImage.image = [UIImage imageNamed:@"FlashLight_Stop"];
        }
        [self addSubview:_startImage];
    }
    return _startImage;
}

- (UIButton *)testButton {
    if (!_testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton setTitle:@"测试" forState:UIControlStateNormal];
        _testButton.titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:17.f];
        [_testButton.layer setCornerRadius:4.f];
        [_testButton.layer setBorderWidth:2.f];
        [_testButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_testButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_testButton];
    }
    return _testButton;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _startButton.selected = FlashLightManager.isMainStartSelected;
        [self addSubview:_startButton];
    }
    return _startButton;
}

- (UIView *)centerLine {
    if (!_centerLine) {
        _centerLine = [[UIView alloc] initWithFrame:CGRectZero];
        _centerLine.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_centerLine];
    }
    return _centerLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

@end
