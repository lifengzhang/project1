//
//  VoiceAndModelLampCell.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "VoiceAndModelLampCell.h"

@interface VoiceAndModelLampCell ()

@property (nonatomic, strong) UIView *centerLine;

@end

@implementation VoiceAndModelLampCell

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
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:51.f]);
    }];
    
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    
    [self.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerLine.mas_right).offset(8);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceLabel.mas_right).offset(8);
        make.right.equalTo(self.centerLine.mas_left).offset(-8);
        make.centerY.equalTo(self);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:36.f]);
    }];
    
    [self.modelLampBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.modelLabel.mas_right).offset(8);
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.height.equalTo(self.voiceBtn);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
}

- (void)updateVoiceCell {
    
    self.voiceLabel.text = @"声音";
    self.modelLabel.text = @"造型灯";
    [self.voiceBtn setImage:[UIImage imageNamed:@"FlashLight_Voice_Close"] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:@"FlashLight_Voice_Open"] forState:UIControlStateSelected];
    [self.modelLampBtn setImage:[UIImage imageNamed:@"FlashLight_ModelLamp_Close"] forState:UIControlStateNormal];
    [self.modelLampBtn setImage:[UIImage imageNamed:@"FlashLight_ModelLamp_Open"] forState:UIControlStateSelected];
    self.voiceBtn.selected = FlashLightManager.isSoundOpen;
    self.modelLampBtn.selected = FlashLightManager.isPoseOpen;
}

- (void)updateGroupSettingCell {
    self.voiceLabel.text = @"声音";
    self.modelLabel.text = @"闪频";
    self.bottomLine.hidden = YES;
    [self.voiceBtn setImage:[UIImage imageNamed:@"FlashLight_Voice_Close"] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:@"FlashLight_Voice_Open"] forState:UIControlStateSelected];
    [self.modelLampBtn setImage:[UIImage imageNamed:@"FlashLight_Close"] forState:UIControlStateNormal];
    [self.modelLampBtn setImage:[UIImage imageNamed:@"FlashLight_Open"] forState:UIControlStateSelected];
}

- (void)updateClass:(NSString *)str {
    if ([str isEqualToString:@"A"]) {
        self.voiceBtn.selected = FlashLightManager.isVoiceOpenA;
        self.modelLampBtn.selected = FlashLightManager.isFlashFrequenceOpenA;
    } else if ([str isEqualToString:@"B"]) {
        self.voiceBtn.selected = FlashLightManager.isVoiceOpenB;
        self.modelLampBtn.selected = FlashLightManager.isFlashFrequenceOpenB;
    } else if ([str isEqualToString:@"C"]) {
        self.voiceBtn.selected = FlashLightManager.isVoiceOpenC;
        self.modelLampBtn.selected = FlashLightManager.isFlashFrequenceOpenC;
    } else {
        self.voiceBtn.selected = FlashLightManager.isVoiceOpenD;
        self.modelLampBtn.selected = FlashLightManager.isFlashFrequenceOpenD;
    }
    
}

- (void)enableCell {
    self.voiceLabel.textColor = [UIColor whiteColor];
    self.modelLabel.textColor = [UIColor whiteColor];
    self.voiceBtn.enabled = YES;
    self.modelLampBtn.enabled = YES;
}

- (void)disableCell {
    self.voiceLabel.textColor = [UIColor grayColor];
    self.modelLabel.textColor = [UIColor grayColor];
    self.voiceBtn.enabled = NO;
    self.modelLampBtn.enabled = NO;
}

- (UIView *)centerLine {
    if (!_centerLine) {
        _centerLine = [[UIView alloc] initWithFrame:CGRectZero];
        _centerLine.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_centerLine];
    }
    return _centerLine;
}

- (UILabel *)voiceLabel {
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _voiceLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _voiceLabel.textColor = [UIColor whiteColor];
        _voiceLabel.text = @"声音";
        [self addSubview:_voiceLabel];
    }
    return _voiceLabel;
}

-(UILabel *)modelLabel {
    if (!_modelLabel) {
        _modelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _modelLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _modelLabel.textColor = [UIColor whiteColor];
        _modelLabel.text = @"造型灯";
        [self addSubview:_modelLabel];
    }
    return _modelLabel;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (UIButton *)modelLampBtn {
    if (!_modelLampBtn) {
        _modelLampBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_modelLampBtn];
    }
    return _modelLampBtn;
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
