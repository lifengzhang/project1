//
//  SCameraFlashLightStatusView.m
//  SCamera
//
//  Created by sunny on 2018/4/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraFlashLightStatusView.h"

#define TextColorSelected                                                \
[UIColor colorWithRed:243.0/255.0 green:194.0/255. blue:0/255.0 alpha:1.0]
#define BackGroundColor                                                  \
[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24]

#define BACKBUTTON_DISTANCE_LEFT                                               16.f
#define BACKBUTTON_WIDTH_HEIGHT                                                18.f
#define BACKBUTTON_DISTANCE_TOP                                                (ISIphoneX ? 58 : 36)

@interface SCameraFlashLightStatusView ()

@end

@implementation SCameraFlashLightStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = BackGroundColor;
        [self setUpContrains];
    }
    return self;
}

- (void)setUpContrains {
    
    [self.flashlightLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(BACKBUTTON_DISTANCE_TOP);
        make.left.equalTo(self).offset(16);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.flashlightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.flashlightBtn);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.selectAuto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flashlightLogo);
        make.left.equalTo(self.flashlightLogo.mas_right).offset(40);
        make.height.mas_equalTo(18.f);
        make.width.mas_equalTo(40.f);
    }];
    
    [self.selectOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flashlightLogo);
        make.left.equalTo(self.selectAuto.mas_right).offset(40);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(18.f);
    }];
    
    [self.selectClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flashlightLogo);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(18.f);
        make.left.equalTo(self.selectOpen.mas_right).offset(40);
    }];
    
}

- (UIImageView *)flashlightLogo {
    if (!_flashlightLogo) {
        _flashlightLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_flashLight_image"]];
        [self addSubview:_flashlightLogo];
    }
    return _flashlightLogo;
}

- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        _flashlightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_flashlightBtn];
    }
    return _flashlightBtn;
}

- (UIButton *)selectAuto {
    if (!_selectAuto) {
        _selectAuto = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectAuto setTitle:@"自动" forState:UIControlStateNormal];
        [_selectAuto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectAuto setTitleColor:TextColorSelected forState:UIControlStateSelected];
        _selectAuto.titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_selectAuto];
    }
    return _selectAuto;
}

- (UIButton *)selectOpen {
    if (!_selectOpen) {
        _selectOpen = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectOpen setTitle:@"打开" forState:UIControlStateNormal];
        [_selectOpen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectOpen setTitleColor:TextColorSelected forState:UIControlStateSelected];
        _selectOpen.titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self addSubview:_selectOpen];
    }
    return _selectOpen;
}

- (UIButton *)selectClose {
    if (!_selectClose) {
        _selectClose = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectClose setTitle:@"关闭" forState:UIControlStateNormal];
        [_selectClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectClose setTitleColor:TextColorSelected forState:UIControlStateSelected];
        _selectClose.titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _selectClose.selected = YES;
        [self addSubview:_selectClose];
    }
    return _selectClose;
}

@end
