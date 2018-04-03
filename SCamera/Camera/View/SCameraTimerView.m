//
//  SCameraTimerView.m
//  SCamera
//
//  Created by sunny on 2018/4/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraTimerView.h"

#define TextColorSelected                                                \
[UIColor colorWithRed:243.0/255.0 green:194.0/255. blue:0/255.0 alpha:1.0]

#define BACKBUTTON_DISTANCE_LEFT                                               16.f
#define BACKBUTTON_WIDTH_HEIGHT                                                18.f
#define BACKBUTTON_DISTANCE_TOP                                                (ISIphoneX ? 58 : 36)

@implementation SCameraTimerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.timerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(BACKBUTTON_DISTANCE_TOP);
        make.left.equalTo(self).offset(16);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.timerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.timerImage);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timerImage);
        make.left.equalTo(self.timerImage.mas_right).offset(40);
        make.height.mas_equalTo(18.f);
        make.width.mas_equalTo(40.f);
    }];
    
    [self.threeSeconds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timerImage);
        make.left.equalTo(self.closeBtn.mas_right).offset(40);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(18.f);
    }];
    
    [self.tenSeconds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timerImage);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(18.f);
        make.left.equalTo(self.threeSeconds.mas_right).offset(40);
    }];
    
}

- (void)showView {
    self.timerBtn.hidden = NO;
    self.timerImage.hidden = NO;
    self.closeBtn.hidden = NO;
    self.threeSeconds.hidden = NO;
    self.tenSeconds.hidden = NO;
}

- (void)hiddenView {
    self.timerBtn.hidden = YES;
    self.timerImage.hidden = YES;
    self.closeBtn.hidden = YES;
    self.threeSeconds.hidden = YES;
    self.tenSeconds.hidden = YES;
}

#pragma mark - lazy load
- (UIButton *)timerBtn {
    if (!_timerBtn) {
        _timerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_timerBtn];
    }
    return _timerBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _closeBtn.selected = YES;
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:TextColorSelected forState:UIControlStateSelected];
        [self addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UIButton *)threeSeconds {
    if (!_threeSeconds) {
        _threeSeconds = [[UIButton alloc] initWithFrame:CGRectZero];
        [_threeSeconds setTitle:@"3 秒" forState:UIControlStateNormal];
        _threeSeconds.titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [_threeSeconds setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_threeSeconds setTitleColor:TextColorSelected forState:UIControlStateSelected];
        [self addSubview:_threeSeconds];
    }
    return _threeSeconds;
}

- (UIButton *)tenSeconds {
    if (!_tenSeconds) {
        _tenSeconds = [[UIButton alloc] initWithFrame:CGRectZero];
        [_tenSeconds setTitle:@"10 秒" forState:UIControlStateNormal];
        _tenSeconds.titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [_tenSeconds setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tenSeconds setTitleColor:TextColorSelected forState:UIControlStateSelected];
        [self addSubview:_tenSeconds];
    }
    return _tenSeconds;
}

- (UIImageView *)timerImage {
    if (!_timerImage) {
        _timerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_timer_image"]];
        [self addSubview:_timerImage];
    }
    return _timerImage;
}

@end
