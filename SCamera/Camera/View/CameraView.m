//
//  CameraView.m
//  SCamera
//
//  Created by sunny on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "CameraView.h"

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#

#define BACKBUTTON_DISTANCE_TOP                                                (ISIphoneX ? 58 : 36)
#define BACKBUTTON_DISTANCE_LEFT                                               16.f
#define BACKBUTTON_WIDTH_HEIGHT                                                18.f

#define PHOTOLIBRARYBUTTON_DISTANCE_TOP                                        kScreenHeight - 100
#define PHOTOLIBRARYBUTTON_DISTANCE_LEFT                                       30.f
#define PHOTOLIBRARYBUTTON_WIDTH_HEIGHT                                        60.f

#define PHOTOBUTTON_DISTANCE_TOP                                               kScreenHeight - 100
#define PHOTOBUTTON_DISTANCE_LEFT                                              kScreenWidth*1/2.0 - 30
#define PHOTOBUTTON_WIDTH_HEIGHT                                               60.f

#define NAVIGATIONHEIGHT                                                      (ISIphoneX ? 88 : 64)

@interface CameraView ()

@property (nonatomic, strong) UIView *navigationView; //导航视图

@property (nonatomic, strong) UIView *whitePoint;

@property (nonatomic, strong) UILabel *shutterLabel;

@end

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpConstraints];
    }
    
    return self;
}

- (void)setUpConstraints {
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(NAVIGATIONHEIGHT);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView).offset(BACKBUTTON_DISTANCE_TOP);
        make.left.equalTo(self.navigationView).offset(BACKBUTTON_DISTANCE_LEFT);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.photoLibraryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_top);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
        make.centerX.equalTo(self.backButton.mas_right).offset((kScreenWidth/2 - 43)/2);
    }];
    
    [self.flashLightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_top);
        make.centerX.equalTo(self.navigationView);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.timerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_top);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
        make.centerX.equalTo(self.navigationView.mas_right).offset(-((kScreenWidth/2 - 43)/2 + 34));
    }];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationView.mas_right).offset(-16);
        make.top.equalTo(self.backButton.mas_top);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kScreenHeight - 140 + 19);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(PHOTOBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.valueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(64);
        make.centerY.equalTo(self.photoButton);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(15);
    }];
    
    [self.bluetoothButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-64);
        make.centerY.equalTo(self.photoButton);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(15);
    }];
    
    [self.whitePoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(4);
        make.top.equalTo(self.photoButton.mas_bottom).offset(9);
    }];
    
    [self.shutterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.whitePoint.mas_bottom).offset(10);
    }];
    
    [self.topWhiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomWhiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-140);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.showISOValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ISIphoneX ? 121 + [SCameraDevice screenAdaptiveSizeWithIp6Size:40] : 99 + [SCameraDevice screenAdaptiveSizeWithIp6Size:40]);
        make.width.mas_equalTo(120);
        make.right.equalTo(self);
    }];
    
    [self.showShutterValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showISOValue.mas_bottom);
        make.width.mas_equalTo(120);
        make.right.equalTo(self.showISOValue);
    }];
    
    [self.showAWBValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showShutterValue.mas_bottom);
        make.width.mas_equalTo(120);
        make.right.equalTo(self.showISOValue);
    }];
    
    [self.showExposureValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showAWBValue.mas_bottom);
        make.width.mas_equalTo(120);
        make.right.equalTo(self.showISOValue);
    }];
}

- (void)showView {
    self.showISOValue.hidden = NO;
    self.showExposureValue.hidden = NO;
    self.showAWBValue.hidden = NO;
    self.showShutterValue.hidden = NO;
    self.showExposureValue.hidden = NO;
    self.topWhiteLine.hidden = NO;
    self.bottomWhiteLine.hidden = NO;
}

- (void)hiddenView {
    self.showISOValue.hidden = YES;
    self.showExposureValue.hidden = YES;
    self.showAWBValue.hidden = YES;
    self.showExposureValue.hidden = YES;
    self.showShutterValue.hidden = YES;
    self.topWhiteLine.hidden = YES;
    self.bottomWhiteLine.hidden = YES;
}

#pragma  -mark 懒加载
- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectZero];
        _navigationView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24];
        [self addSubview:_navigationView];
    }
    return _navigationView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"Camera_close_image"] forState:UIControlStateNormal];
        [self.navigationView addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)photoLibraryButton {
    if (!_photoLibraryButton) {
        _photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoLibraryButton setImage:[UIImage imageNamed:@"Camera_photoAlbum_image"] forState:UIControlStateNormal];
        [self.navigationView addSubview:_photoLibraryButton];
    }
    return _photoLibraryButton;
}

- (UIButton *)flashLightButton {
    if (!_flashLightButton) {
        _flashLightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_flashLightButton setImage:[UIImage imageNamed:@"Camera_flashLight_image"] forState:UIControlStateNormal];
        [self.navigationView addSubview:_flashLightButton];
    }
    return _flashLightButton;
}

- (UIButton *)timerButton {
    if (!_timerButton) {
        _timerButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timerButton setImage:[UIImage imageNamed:@"Camera_timer_image"] forState:UIControlStateNormal];
        [self.navigationView addSubview:_timerButton];
    }
    return _timerButton;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_exchangeButton setImage:[UIImage imageNamed:@"Camera_exchange_image"] forState:UIControlStateNormal];
        [self.navigationView addSubview:_exchangeButton];
    }
    return _exchangeButton;
}

- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setImage:[UIImage imageNamed:@"Camera_photo_Image"] forState:UIControlStateNormal];
        [self addSubview:_photoButton];
    }
    return _photoButton;
}

- (UIButton *)valueButton {
    if (!_valueButton) {
        _valueButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_valueButton setImage:[UIImage imageNamed:@"Camera_value_image"] forState:(UIControlState)UIControlStateNormal];
        [self addSubview:_valueButton];
    }
    return _valueButton;
}

- (UIButton *)bluetoothButton {
    if (!_bluetoothButton) {
        _bluetoothButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_bluetoothButton setImage:[UIImage imageNamed:@"Camera_bluetooth_image"] forState:UIControlStateNormal];
        [self addSubview:_bluetoothButton];
    }
    return _bluetoothButton;
}

- (UIView *)whitePoint {
    if (!_whitePoint) {
        _whitePoint = [[UIView alloc] initWithFrame:CGRectZero];
        _whitePoint.backgroundColor = [UIColor whiteColor];
        _whitePoint.layer.cornerRadius = 2;
        [self addSubview:_whitePoint];
    }
    return _whitePoint;
}

- (UILabel *)shutterLabel {
    if (!_shutterLabel) {
        _shutterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shutterLabel.font = [UIFont ChinaDefaultFontNameOfSize:12.f];
        _shutterLabel.text = @"快门";
        _shutterLabel.backgroundColor = [UIColor blackColor];
        _shutterLabel.textColor = [UIColor whiteColor];
        [self addSubview:_shutterLabel];
    }
    return _shutterLabel;
}

- (UIView *)topWhiteLine {
    if (!_topWhiteLine) {
        _topWhiteLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topWhiteLine.backgroundColor = [UIColor whiteColor];
        _topWhiteLine.hidden = YES;
        [self addSubview:_topWhiteLine];
    }
    return _topWhiteLine;
}

- (UIView *)bottomWhiteLine {
    if (!_bottomWhiteLine) {
        _bottomWhiteLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomWhiteLine.backgroundColor = [UIColor whiteColor];
        _bottomWhiteLine.hidden = YES;
        [self addSubview:_bottomWhiteLine];
    }
    return _bottomWhiteLine;
}

- (UILabel *)showISOValue {
    if (!_showISOValue) {
        _showISOValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _showISOValue.text = @"IOS: 100";
        _showISOValue.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _showISOValue.textColor = [UIColor whiteColor];
        _showISOValue.hidden = YES;
        [self addSubview:_showISOValue];
    }
    return _showISOValue;
}

- (UILabel *)showShutterValue {
    if (!_showShutterValue) {
        _showShutterValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _showShutterValue.text = @"Shutter: 1/15";
        _showShutterValue.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _showShutterValue.textColor = [UIColor whiteColor];
        _showShutterValue.hidden = YES;
        [self addSubview:_showShutterValue];
    }
    return _showShutterValue;
}

- (UILabel *)showAWBValue {
    if (!_showAWBValue) {
        _showAWBValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _showAWBValue.text = @"AWB: LIGHT";
        _showAWBValue.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _showAWBValue.textColor = [UIColor whiteColor];
        _showAWBValue.hidden = YES;
        [self addSubview:_showAWBValue];
    }
    return _showAWBValue;
}

- (UILabel *)showExposureValue {
    if (!_showExposureValue) {
        _showExposureValue = [[UILabel alloc] initWithFrame:CGRectZero];
        _showExposureValue.text = @"曝光度: +1";
        _showExposureValue.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _showExposureValue.textColor = [UIColor whiteColor];
        _showExposureValue.hidden = YES;
        [self addSubview:_showExposureValue];
    }
    return _showExposureValue;
}

@end
