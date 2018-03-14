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
