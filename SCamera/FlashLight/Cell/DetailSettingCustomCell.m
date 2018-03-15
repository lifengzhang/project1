//
//  DetailSettingCustomCell.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "DetailSettingCustomCell.h"

@interface DetailSettingCustomCell ()

@property (nonatomic, strong) UIButton *arrow;

@end

@implementation DetailSettingCustomCell

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

- (void)updateModeCellWithClass:(NSString *)str {
    self.title.text = @"模式";
    if ([str isEqualToString:@"A"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.aModelStr.length > 0 ? FlashLightManager.aModelStr : @"自动"];
    } else if ([str isEqualToString:@"B"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.bModelStr.length > 0 ? FlashLightManager.bModelStr : @"自动"];
    } else if ([str isEqualToString:@"C"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.cModelStr.length > 0 ? FlashLightManager.cModelStr : @"自动"];
    } else {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.dModelStr.length > 0 ? FlashLightManager.dModelStr : @"自动"];
    }
}

- (void)updateLampCellWithClass:(NSString *)str {
    self.title.text = @"造型灯";
    if ([str isEqualToString:@"A"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.aLightDegreeStr.length > 0 ? FlashLightManager.aLightDegreeStr : @"PROP"];
    } else if ([str isEqualToString:@"B"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.bLightDegreeStr.length > 0 ? FlashLightManager.bLightDegreeStr : @"PROP"];
    } else if ([str isEqualToString:@"C"]) {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.cLightDegreeStr.length > 0 ? FlashLightManager.cLightDegreeStr : @"PROP"];
    } else {
        self.detail.text = [NSString stringWithFormat:@"%@",FlashLightManager.dLightDegreeStr.length > 0 ? FlashLightManager.dLightDegreeStr : @"PROP"];
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
