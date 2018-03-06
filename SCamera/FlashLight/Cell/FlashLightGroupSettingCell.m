//
//  FlashLightGroupSettingCell.m
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "FlashLightGroupSettingCell.h"

@interface FlashLightGroupSettingCell ()

@end

@implementation FlashLightGroupSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpConstraints];
        self.backgroundColor = Scamera_Cell_Background;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:34.f]);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
    
    [self.grouplType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startBtn.mas_right).offset(7);
        make.centerY.equalTo(self);
    }];
    
    [self.modelTypr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(85);
        make.top.equalTo(self).offset([SCameraDevice screenAdaptiveSizeWithIp6Size:16.f]);
    }];
    
    [self.voiceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-[SCameraDevice screenAdaptiveSizeWithIp6Size:16.f]);
        make.left.equalTo(self.modelTypr);
    }];

    [self.frequenceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceType.mas_right).offset(45.f);
        make.bottom.equalTo(self.voiceType);
    }];
    
    [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
    }];
}

- (void)enableView {
    
    self.grouplType.textColor = [UIColor whiteColor];
    self.modelTypr.textColor = [UIColor whiteColor];
    self.voiceType.textColor = [UIColor whiteColor];
    self.frequenceType.textColor = [UIColor whiteColor];
    self.value.textColor = [UIColor whiteColor];
    self.startBtn.enabled = YES;
}

- (void)disableView {
    
    self.grouplType.textColor = [UIColor grayColor];
    self.modelTypr.textColor = [UIColor grayColor];
    self.voiceType.textColor = [UIColor grayColor];
    self.frequenceType.textColor = [UIColor grayColor];
    self.value.textColor = [UIColor grayColor];
    self.startBtn.enabled = NO;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_startBtn setImage:[UIImage imageNamed:@"FlashLight_Stop"] forState:UIControlStateNormal];
        [self addSubview:_startBtn];
    }
    return _startBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UILabel *)grouplType {
    if (!_grouplType) {
        _grouplType = [[UILabel alloc] initWithFrame:CGRectZero];
        _grouplType.textColor = [UIColor whiteColor];
        _grouplType.text = @"A";
        _grouplType.font = [UIFont ChinaDefaultFontNameOfSize:19.f];
        [self addSubview:_grouplType];
    }
    return _grouplType;
}

- (UILabel *)modelTypr {
    if (!_modelTypr) {
        _modelTypr = [[UILabel alloc] initWithFrame:CGRectZero];
        _modelTypr.textColor = [UIColor whiteColor];
        _modelTypr.text = @"模式 手动";
        _modelTypr.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_modelTypr];
    }
    return _modelTypr;
}

- (UILabel *)voiceType {
    if (!_voiceType) {
        _voiceType = [[UILabel alloc] initWithFrame:CGRectZero];
        _voiceType.textColor = [UIColor whiteColor];
        _voiceType.text = @"声音 开";
        _voiceType.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_voiceType];
    }
    return _voiceType;
}

- (UILabel *)frequenceType {
    if (!_frequenceType) {
        _frequenceType = [[UILabel alloc] initWithFrame:CGRectZero];
        _frequenceType.textColor = [UIColor whiteColor];
        _frequenceType.text = @"频闪 开";
        _frequenceType.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_frequenceType];
    }
    return _frequenceType;
}

- (UILabel *)value {
    if (!_value) {
        _value = [[UILabel alloc] initWithFrame:CGRectZero];
        _value.textColor = [UIColor whiteColor];
        _value.text = @"1/8+0.2";
        _value.font = [UIFont ChinaDefaultFontNameOfSize:19.f];
        [self addSubview:_value];
    }
    return _value;
}

@end