//
//  SCameraPictureView.m
//  SCamera
//
//  Created by sunny on 2018/2/13.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraPictureView.h"

@interface SCameraPictureView ()

@property (nonatomic, strong) UIView *bottomContentView;   //底部背景视图

@property (nonatomic, strong) UIView *whitePoint;

@property (nonatomic, strong) UILabel *saveLabel;

@property (nonatomic, strong) UIImageView *backImage;

@property (nonatomic, strong) UIImageView *showPictureView;

@property (nonatomic, strong) UIImage *displaypicture;

@end

@implementation SCameraPictureView

- (instancetype)initWithPicture:(UIImage *)image {
    if (self = [super init]) {
        self.displaypicture =image;
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(140);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomContentView).offset(19);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(60.f);
    }];
    
    [self.whitePoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(4);
        make.top.equalTo(self.saveButton.mas_bottom).offset(9);
    }];
    
    [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.whitePoint.mas_bottom).offset(10);
    }];
    
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(64);
        make.centerY.equalTo(self.saveButton);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(15);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.backImage);
        make.width.height.mas_equalTo(60);
    }];
    

    [self.showPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self).offset(-140);
    }];
}

- (UIView *)bottomContentView {
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomContentView.backgroundColor = [UIColor blackColor];
        [self addSubview:_bottomContentView];
    }
    return _bottomContentView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setImage:[UIImage imageNamed:@"Camera_save_image"] forState:UIControlStateNormal];
        [self.bottomContentView addSubview:_saveButton];
    }
    return _saveButton;
}

- (UIView *)whitePoint {
    if (!_whitePoint) {
        _whitePoint = [[UIView alloc] initWithFrame:CGRectZero];
        _whitePoint.backgroundColor = [UIColor whiteColor];
        _whitePoint.layer.cornerRadius = 2;
        [self.bottomContentView addSubview:_whitePoint];
    }
    return _whitePoint;
}

- (UILabel *)saveLabel {
    if (!_saveLabel) {
        _saveLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _saveLabel.font = [UIFont ChinaDefaultFontNameOfSize:12.f];
        _saveLabel.text = @"确认";
        _saveLabel.backgroundColor = [UIColor blackColor];
        _saveLabel.textColor = [UIColor whiteColor];
        [self.bottomContentView addSubview:_saveLabel];
    }
    return _saveLabel;
}

-  (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_back_image"]];
        [self.bottomContentView addSubview:_backImage];
    }
    return _backImage;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _backButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (UIImageView *)showPictureView {
    if (!_showPictureView) {
        _showPictureView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _showPictureView.image = self.displaypicture;
        [self addSubview:_showPictureView];
    }
    return _showPictureView;
}

@end
