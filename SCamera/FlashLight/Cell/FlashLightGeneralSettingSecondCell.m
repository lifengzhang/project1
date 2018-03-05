//
//  FlashLightGeneralSettingSecondCell.m
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "FlashLightGeneralSettingSecondCell.h"

@interface FlashLightGeneralSettingSecondCell ()

@property (nonatomic, strong) UIButton *arrowImage;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation FlashLightGeneralSettingSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpConstraints];
        self.backgroundColor = Scamera_Cell_Background;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:20.f]);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:26.f]);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
    
    [self.channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset([SCameraDevice screenAdaptiveSizeWithIp6Size:16.f]);
    }];
    
    [self.modelLightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.channelLabel.mas_right).offset(45.f);
        make.top.equalTo(self.channelLabel);
    }];
    
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.modelLightLabel.mas_right).offset(45.f);
        make.top.equalTo(self.channelLabel);
    }];
    
    [self.frequenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.channelLabel);
        make.bottom.equalTo(self).offset(-[SCameraDevice screenAdaptiveSizeWithIp6Size:16.f]);
    }];
}

- (void)enableView {
    
    self.channelLabel.textColor = [UIColor whiteColor];
    self.modelLightLabel.textColor = [UIColor whiteColor];
    self.voiceLabel.textColor = [UIColor whiteColor];
    self.frequenceLabel.textColor = [UIColor whiteColor];
    self.arrowImage.enabled = YES;
}

- (void)disableView {
    
    self.channelLabel.textColor = [UIColor grayColor];
    self.modelLightLabel.textColor = [UIColor grayColor];
    self.voiceLabel.textColor = [UIColor grayColor];
    self.frequenceLabel.textColor = [UIColor grayColor];
    self.arrowImage.enabled = NO;
}

- (UIButton *)arrowImage {
    if (!_arrowImage) {
        _arrowImage = [[UIButton alloc] initWithFrame:CGRectZero];
        [_arrowImage setImage:[UIImage imageNamed:@"FlashLight_Arrow"] forState:UIControlStateNormal];
        [self addSubview:_arrowImage];
    }
    return _arrowImage;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UILabel *)channelLabel {
    if (!_channelLabel) {
        _channelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _channelLabel.text = @"频道 1";
        _channelLabel.textColor = [UIColor whiteColor];
        _channelLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_channelLabel];
    }
    return _channelLabel;
}

- (UILabel *)modelLightLabel {
    if (!_modelLightLabel) {
        _modelLightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _modelLightLabel.textColor = [UIColor whiteColor];
        _modelLightLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _modelLightLabel.text = @"造型灯 开";
        [self addSubview:_modelLightLabel];
    }
    return _modelLightLabel;
}

- (UILabel *)voiceLabel {
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _voiceLabel.textColor = [UIColor whiteColor];
        _voiceLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _voiceLabel.text = @"声音 开";
        [self addSubview:_voiceLabel];
    }
    return _voiceLabel;
}

- (UILabel *)frequenceLabel {
    if (!_frequenceLabel) {
        _frequenceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _frequenceLabel.textColor = [UIColor whiteColor];
        _frequenceLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _frequenceLabel.text = @"频闪 33Hz/2次";
        [self addSubview:_frequenceLabel];
    }
    return _frequenceLabel;
}

@end
