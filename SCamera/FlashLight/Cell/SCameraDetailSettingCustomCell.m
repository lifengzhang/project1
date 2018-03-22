//
//  SCameraDetailSettingCustomCell.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraDetailSettingCustomCell.h"

@interface SCameraDetailSettingCustomCell ()

@property (nonatomic, strong) UIButton *arrow;

@end

@implementation SCameraDetailSettingCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpConstraints];
        self.backgroundColor = Scamera_Cell_Background;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:18.f]);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:20.f]);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
    }];
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.arrow.mas_left).offset(-10);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
}

- (void)enableCell {
    self.title.textColor = [UIColor whiteColor];
    self.detail.textColor = [UIColor whiteColor];
    self.arrow.enabled = YES;
}

- (void)disableCell {
    self.title.textColor = [UIColor grayColor];
    self.detail.textColor = [UIColor grayColor];
    self.arrow.enabled = NO;
}

- (void)updateChannelCell {
    self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.channelStr.length > 0 ? FlashLightManager.channelStr : @"1"];
}

- (void)updateMinPowerWithGroupName:(NSString *)str {
    self.title.text = @"最小功率";
    self.bottomLine.hidden = YES;
    if ([str isEqualToString:@"A"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.aMinPower.length > 0 ? FlashLightManager.aMinPower : @"1/512"];
    } else if ([str isEqualToString:@"B"]) {
         self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.bMinPower.length > 0 ? FlashLightManager.bMinPower : @"1/512"];
    } else if ([str isEqualToString:@"C"]) {
         self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.cMinPower.length > 0 ? FlashLightManager.cMinPower : @"1/512"];
    } else {
         self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.dMinPower.length > 0 ? FlashLightManager.dMinPower : @"1/512"];
    }
}

- (void)updateModeCellWithGroupName:(NSString *)str {
    self.title.text = @"模式";
    if ([str isEqualToString:@"A"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.aModel > 0 ? [NSString sringWithFlashLightModel:FlashLightManager.aModel] : @"自动"];
    } else if ([str isEqualToString:@"B"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.bModel > 0 ? [NSString sringWithFlashLightModel:FlashLightManager.bModel] : @"自动"];
    } else if ([str isEqualToString:@"C"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.cModel > 0 ? [NSString sringWithFlashLightModel:FlashLightManager.cModel] : @"自动"];
    } else {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.dModel > 0 ? [NSString sringWithFlashLightModel:FlashLightManager.dModel] : @"自动"];
    }
}

- (void)updateLampCellWithGroupName:(NSString *)str {
    self.title.text = @"造型灯";
    if ([str isEqualToString:@"A"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.aLightDegree > 0 ? [NSString stringWithFlashLightDegree:FlashLightManager.aLightDegree] : @"关闭"];
    } else if ([str isEqualToString:@"B"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.bLightDegree > 0 ? [NSString stringWithFlashLightDegree:FlashLightManager.bLightDegree] : @"关闭"];
    } else if ([str isEqualToString:@"C"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.cLightDegree > 0 ? [NSString stringWithFlashLightDegree:FlashLightManager.cLightDegree] : @"关闭"];
    } else {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.dLightDegree > 0 ? [NSString stringWithFlashLightDegree:FlashLightManager.dLightDegree] : @"关闭"];
    }
}

- (UIButton *)arrow {
    if (!_arrow) {
        _arrow = [[UIButton alloc] initWithFrame:CGRectZero];
        [_arrow setImage:[UIImage imageNamed:@"FlashLight_Arrow"] forState:UIControlStateNormal];
        [self addSubview:_arrow];
    }
    return _arrow;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _title.text =@"频道";
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)detail {
    if (!_detail) {
        _detail = [[UILabel alloc] initWithFrame:CGRectZero];
        _detail.textColor = [UIColor whiteColor];
        _detail.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _detail.text = @"1";
        [self addSubview:_detail];
    }
    return _detail;
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
