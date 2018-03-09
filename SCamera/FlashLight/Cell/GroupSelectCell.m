//
//  GroupSelectCell.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "GroupSelectCell.h"

@interface GroupSelectCell ()

@property (nonatomic, strong) UILabel *aLabel;

@property (nonatomic, strong) UILabel *bLabel;

@property (nonatomic, strong) UILabel *cLabel;

@property (nonatomic, strong) UILabel *dLabel;

@property (nonatomic, strong) UIView *crossLine;

@property (nonatomic, strong) UIView *verticelLine;

@property (nonatomic, strong) UIView *verticalLine1;

@end

@implementation GroupSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Scamera_Cell_Background;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.crossLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16.f);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.verticelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([SCameraDevice screenAdaptiveSizeWithIp6Size:9.f]);
        make.bottom.equalTo(self.crossLine.mas_top).offset(-[SCameraDevice screenAdaptiveSizeWithIp6Size:9.f]);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(self);
    }];
    
    [self.verticalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.crossLine.mas_bottom).offset([SCameraDevice screenAdaptiveSizeWithIp6Size:9.f]);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-[SCameraDevice screenAdaptiveSizeWithIp6Size:9.f]);
    }];
    
    [self.aImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset([SCameraDevice screenAdaptiveSizeWithIp6Size:106.f]/4);
        make.right.equalTo(self.mas_left).offset(Width_Screen/4);
        make.width.height.mas_equalTo(20);

    }];
    
    [self.aLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aImage);
        make.left.equalTo(self.aImage.mas_right).offset(10.f);
    }];
    
    [self.bImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aImage);
        make.right.equalTo(self.mas_right).offset(-Width_Screen/4);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.bLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aImage);
        make.left.equalTo(self.bImage.mas_right).offset(10);
    }];
    
    [self.cImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_bottom).offset(-([SCameraDevice screenAdaptiveSizeWithIp6Size:106.f]/4 - 5));
        make.right.equalTo(self.aImage);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aLabel);
        make.centerY.equalTo(self.cImage);
    }];
    
    [self.dImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cImage);
        make.right.equalTo(self.bImage);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.dLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cImage);
        make.left.equalTo(self.dImage.mas_right).offset(10);
    }];
    
    [self.aButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.right.equalTo(self.verticelLine.mas_left);
        make.bottom.equalTo(self.crossLine.mas_top);
    }];
    
    [self.bButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.verticelLine.mas_right);
        make.bottom.equalTo(self.crossLine.mas_top);
    }];
    
    [self.cButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.equalTo(self.crossLine.mas_bottom);
        make.right.equalTo(self.verticalLine1.mas_left);
    }];
    
    [self.dButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self.verticalLine1.mas_right);
        make.top.equalTo(self.crossLine.mas_bottom);
    }];
    
}

- (UIView *)crossLine {
    if (!_crossLine) {
        _crossLine = [[UIView alloc] initWithFrame:CGRectZero];
        _crossLine.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_crossLine];
    }
    return _crossLine;
}

- (UIView *)verticelLine {
    if (!_verticelLine) {
        _verticelLine = [[UIView alloc] initWithFrame:CGRectZero];
        _verticelLine.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_verticelLine];
    }
    return _verticelLine;
}

- (UIView *)verticalLine1 {
    if (!_verticalLine1) {
        _verticalLine1 = [[UIView alloc] initWithFrame:CGRectZero];
        _verticalLine1.backgroundColor = Scamera_Line_Gray;
        [self addSubview:_verticalLine1];
    }
    return _verticalLine1;
}

- (UIImageView *)aImage {
    if (!_aImage) {
        _aImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _aImage.image = [UIImage imageNamed:@"button_select_no"];
        [self addSubview:_aImage];
    }
    return _aImage;
}

- (UIImageView *)bImage {
    if (!_bImage) {
        _bImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bImage.image = [UIImage imageNamed:@"button_select_no"];
        [self addSubview:_bImage];
    }
    return _bImage;
}

- (UIImageView *)cImage {
    if (!_cImage) {
        _cImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _cImage.image = [UIImage imageNamed:@"button_select_no"];
        [self addSubview:_cImage];
    }
    return _cImage;
}

- (UIImageView *)dImage {
    if (!_dImage) {
        _dImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _dImage.image = [UIImage imageNamed:@"button_select_no"];
        [self addSubview:_dImage];
    }
    return _dImage;
}

- (UILabel *)aLabel {
    if (!_aLabel) {
        _aLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _aLabel.textColor = [UIColor whiteColor];
        _aLabel.font = [UIFont ChinaDefaultFontNameOfSize:24.f];
        _aLabel.text = @"A";
        [self addSubview:_aLabel];
    }
    return _aLabel;
}

- (UILabel *)bLabel {
    if (!_bLabel) {
        _bLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bLabel.textColor = [UIColor whiteColor];
        _bLabel.font = [UIFont ChinaDefaultFontNameOfSize:24.f];
        _bLabel.text = @"B";
        [self addSubview:_bLabel];
    }
    return _bLabel;
}

- (UILabel *)cLabel {
    if (!_cLabel) {
        _cLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cLabel.textColor = [UIColor whiteColor];
        _cLabel.font = [UIFont ChinaDefaultFontNameOfSize:24.f];
        _cLabel.text = @"C";
        [self addSubview:_cLabel];
    }
    return _cLabel;
}

- (UILabel *)dLabel {
    if (!_dLabel) {
        _dLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dLabel.textColor = [UIColor whiteColor];
        _dLabel.font = [UIFont ChinaDefaultFontNameOfSize:24.f];
        _dLabel.text = @"D";
        [self addSubview:_dLabel];
    }
    return _dLabel;
}

- (UIButton *)aButton {
    if (!_aButton) {
        _aButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_aButton];
    }
    return _aButton;
}

- (UIButton *)bButton {
    if (!_bButton) {
        _bButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_bButton];
    }
    return _bButton;
}

- (UIButton *)cButton {
    if (!_cButton) {
        _cButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_cButton];
    }
    return _cButton;
}

- (UIButton *)dButton {
    if (!_dButton) {
        _dButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_dButton];
    }
    return _dButton;
}

@end
