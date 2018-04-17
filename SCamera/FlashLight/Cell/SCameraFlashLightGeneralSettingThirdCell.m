//
//  SCameraFlashLightGeneralSettingThirdCell.m
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraFlashLightGeneralSettingThirdCell.h"

@interface SCameraFlashLightGeneralSettingThirdCell ()


@end

@implementation SCameraFlashLightGeneralSettingThirdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpConstraints];
        self.backgroundColor = Scamera_Cell_Background;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self).offset(-[SCameraDevice screenAdaptiveSizeWithIp6Size:17.f]);
        make.width.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:26.f]);
    }];
    
    [self.redeceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self.addButton);
        make.height.width.equalTo(self.addButton);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([SCameraDevice screenAdaptiveSizeWithIp6Size:16.f]);
        make.centerX.equalTo(self);
    }];
    
    [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redeceButton.mas_right);
        make.centerY.equalTo(self.redeceButton);
        make.right.equalTo(self.flashLightSlider.mas_left);
    }];
    
    [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton.mas_left).offset(-7);
        make.centerY.equalTo(self.minLabel);
    }];

    [self.flashLightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redeceButton.mas_right).offset(36);
        make.centerY.equalTo(self.minLabel);
        make.right.equalTo(self.addButton.mas_left).offset(-36);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset([SCameraDevice screenAdaptiveSizeWithIp6Size:16.f]);
    }];
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title);
        make.right.equalTo(self).offset(-16);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
}

- (void)enableView {
    self.addButton.enabled = YES;
    self.redeceButton.enabled = YES;
    self.valueLabel.textColor = [UIColor whiteColor];
    self.minLabel.textColor = [UIColor whiteColor];
    self.maxLabel.textColor = [UIColor whiteColor];
    self.flashLightSlider.enabled = YES;
}

- (void)disableView {
    self.addButton.enabled = NO;
    self.redeceButton.enabled = NO;
    self.valueLabel.textColor = [UIColor grayColor];
    self.minLabel.textColor = [UIColor grayColor];
    self.maxLabel.textColor = [UIColor grayColor];
    self.flashLightSlider.enabled = NO;
}

- (void)updateSliderForFrequence {
//    self.title.text = @"频闪频率";
    self.title.hidden = YES;
    self.bottomLine.hidden = NO;
    self.valueLabel.hidden = YES;
    NSInteger numberOfSteps = 199;
    self.flashLightSlider.maximumValue = numberOfSteps;
    self.flashLightSlider.minimumValue = 1;
    self.minLabel.text = @"1";
    self.maxLabel.text = @"199";
//    self.detail.text = @"1";
    self.detail.hidden = YES;
    [self.flashLightSlider setValue:1 animated:NO];
    if (FlashLightManager.flashFrequency && FlashLightManager.flashFrequency > 0) {
        [self.flashLightSlider setValue:FlashLightManager.flashFrequency animated:NO];
//        self.detail.text = [NSString stringWithFormat:@"%lu",(unsigned long)FlashLightManager.flashFrequency];
    }
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    self.bottomLine.backgroundColor = Scamera_Line_white;
    self.minLabel.textColor = Scamera_TextColor_Gray;
    self.maxLabel.textColor = Scamera_TextColor_Gray;
    self.backgroundColor = [UIColor whiteColor];
    self.flashLightSlider.backgroundColor = [UIColor whiteColor];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(26.f);
    }];
    
    [self.redeceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(26.f);
    }];
    
}

- (void)updateSliderForTimes {
    
    NSInteger numberOfSteps = 40;
    self.flashLightSlider.maximumValue = numberOfSteps;
    self.flashLightSlider.minimumValue = 1;
    self.bottomLine.hidden = NO;
    self.valueLabel.hidden = YES;
//    self.title.text = @"频闪次数";
    self.title.hidden = YES;
    self.minLabel.text = @"1";
    self.maxLabel.text = @"40";
//    self.detail.text = @"1";
    self.detail.hidden = YES;
    [self.flashLightSlider setValue:1 animated:NO];
    if (FlashLightManager.flashNumber && FlashLightManager.flashNumber > 0) {
        [self.flashLightSlider setValue:FlashLightManager.flashNumber animated:NO];
//        self.detail.text = [NSString stringWithFormat:@"%lu",(unsigned long)FlashLightManager.flashNumber];
    }
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    self.bottomLine.backgroundColor = Scamera_Line_white;
    self.minLabel.textColor = Scamera_TextColor_Gray;
    self.maxLabel.textColor = Scamera_TextColor_Gray;
    self.backgroundColor = [UIColor whiteColor];
    self.flashLightSlider.backgroundColor = [UIColor whiteColor];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(26.f);
    }];
    
    [self.redeceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(26.f);
    }];
}

- (void)updateHomePageSlider {
    NSArray *numbers = @[@"1/128",@"1/128+0.3",@"1/128+0.7",@"1/64",@"1/64+0.3",@"1/64+0.7", @"1/32",@"1/32+0.3",@"1/32+0.7", @"1/16",@"1/16+0.3",@"1/16+0.7", @"1/8",@"1/8+0.3",@"1/8+0.7",@"1/4",@"1/4+0.3",@"1/4+0.7",@"1/2",@"1/2+0.3",@"1/2+0/7", @"1"];
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    self.flashLightSlider.maximumValue = numberOfSteps;
    self.flashLightSlider.minimumValue = 0;
    [self.flashLightSlider setValue:0 animated:NO];
    if (FlashLightManager.mainValue && FlashLightManager.mainValue.length > 0) {
        for (int i = 0; i < numberOfSteps + 1; i++) {
            if ([numbers[i] isEqualToString:FlashLightManager.mainValue]) {
                [self.flashLightSlider setValue:i animated:NO];
                self.valueLabel.text = FlashLightManager.mainValue;
            }
        }
    }
}

- (void)updateGroupSettingSliderWithGroupClass:(NSString *)str {
    NSArray *numbers = @[@"1/128",@"1/128+0.3",@"1/128+0.7",@"1/64",@"1/64+0.3",@"1/64+0.7", @"1/32",@"1/32+0.3",@"1/32+0.7", @"1/16",@"1/16+0.3",@"1/16+0.7", @"1/8",@"1/8+0.3",@"1/8+0.7",@"1/4",@"1/4+0.3",@"1/4+0.7",@"1/2",@"1/2+0.3",@"1/2+0/7", @"1"];
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    self.flashLightSlider.maximumValue = numberOfSteps;
    self.flashLightSlider.minimumValue = 0;
    [self.flashLightSlider setValue:0 animated:NO];
    self.valueLabel.text = @"1/128";
    self.bottomLine.hidden = NO;
    if ([str isEqualToString:@"A"]) {
        if (FlashLightManager.aPower && FlashLightManager.aPower > 0) {
            for (int i = 0; i < numberOfSteps + 1; i++) {
                if ([numbers[i] isEqualToString:[NSString stringOfFlashLightPower:FlashLightManager.aPower]]) {
                    [self.flashLightSlider setValue:i animated:NO];
                    self.valueLabel.text = [NSString stringOfFlashLightPower:FlashLightManager.aPower];
                }
            }
        }
    } else if ([str isEqualToString:@"B"]) {
        if (FlashLightManager.bPower && FlashLightManager.bPower > 0) {
            for (int i = 0; i < numberOfSteps + 1; i++) {
                if ([numbers[i] isEqualToString:[NSString stringOfFlashLightPower:FlashLightManager.bPower]]) {
                    [self.flashLightSlider setValue:i animated:NO];
                    self.valueLabel.text = [NSString stringOfFlashLightPower:FlashLightManager.bPower];
                }
            }
        }
    } else if ([str isEqualToString:@"C"]) {
        if (FlashLightManager.cPower && FlashLightManager.cPower > 0) {
            for (int i = 0; i < numberOfSteps + 1; i++) {
                if ([numbers[i] isEqualToString:[NSString stringOfFlashLightPower:FlashLightManager.cPower]]) {
                    [self.flashLightSlider setValue:i animated:NO];
                    self.valueLabel.text = [NSString stringOfFlashLightPower:FlashLightManager.cPower];
                }
            }
        }
    } else {
        if (FlashLightManager.dPower && FlashLightManager.dPower > 0) {
            for (int i = 0; i < numberOfSteps + 1; i++) {
                if ([numbers[i] isEqualToString:[NSString stringOfFlashLightPower:FlashLightManager.dPower]]) {
                    [self.flashLightSlider setValue:i animated:NO];
                    self.valueLabel.text = [NSString stringOfFlashLightPower:FlashLightManager.dPower];
                }
            }
        }
    }
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_addButton setImage:[UIImage imageNamed:@"FlashLight_Add"] forState:UIControlStateNormal];
        [self addSubview:_addButton];
    }
    return _addButton;
}

- (UIButton *)redeceButton {
    if (!_redeceButton) {
        _redeceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_redeceButton setImage:[UIImage imageNamed:@"FlashLight_Reduce"] forState:UIControlStateNormal];
        [self addSubview:_redeceButton];
    }
    return _redeceButton;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.font = [UIFont ChinaDefaultFontNameOfSize:19.f];
        _valueLabel.text = FlashLightManager.mainValue.length > 0 ? FlashLightManager.mainValue : @"1/128";
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}

- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _minLabel.textColor = [UIColor whiteColor];
        _minLabel.font = [UIFont ChinaDefaultFontNameOfSize:12.f];
        _minLabel.text = @"1/128";
        _minLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_minLabel];
    }
    return _minLabel;
}

- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _maxLabel.textColor = [UIColor whiteColor];
        _maxLabel.font = [UIFont ChinaDefaultFontNameOfSize:12.f];
        _maxLabel.text = @"1/1";
        [self addSubview:_maxLabel];
    }
    return _maxLabel;
}

-(UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)detail {
    if (!_detail) {
        _detail = [[UILabel alloc] initWithFrame:CGRectZero];
        _detail.textColor = [UIColor whiteColor];
        _detail.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_detail];
    }
    return _detail;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = Scamera_Line_Gray;
        _bottomLine.hidden = YES;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = Scamera_Line_white;
        [self addSubview:_topLine];
    }
    return _topLine;
}

- (UISlider *)flashLightSlider {
    if (!_flashLightSlider) {
        _flashLightSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        UIImage *imagea = [UIImage originImage:[UIImage imageNamed:@"FlashLight_Slider"] scaleToSize:CGSizeMake([SCameraDevice screenAdaptiveSizeWithIp6Size:18.f], [SCameraDevice screenAdaptiveSizeWithIp6Size:18.f])];
        [_flashLightSlider setThumbImage:imagea forState:UIControlStateNormal];
        _flashLightSlider.backgroundColor = Scamera_Cell_Background;
        _flashLightSlider.maximumTrackTintColor = Scamera_UISlider_MaxColor;
        _flashLightSlider.minimumTrackTintColor = Scamera_UISlider_MinColor;
        [self addSubview:_flashLightSlider];
    }
    return _flashLightSlider;
}

@end
