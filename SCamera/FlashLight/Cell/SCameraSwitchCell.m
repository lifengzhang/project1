//
//  SCameraSwitchCell.m
//  SCamera
//
//  Created by sunny on 2018/4/16.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraSwitchCell.h"

@interface SCameraSwitchCell ()

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation SCameraSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpConstrains];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUpConstrains {
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16.f);
        make.centerY.equalTo(self);
    }];
    
    [self.power mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
    }];
}

- (void)updateVoiceCell {
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.power setOn:FlashLightManager.isSoundOpen];
}

- (void)updateLampCell {
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.power setOn:FlashLightManager.isPoseOpen];
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectZero];
        _topLine.backgroundColor = Scamera_Line_white;
        [self addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = Scamera_Line_white;
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        _title.textColor = Scamera_TextColor_Gray;
        [self addSubview:_title];
    }
    return _title;
}

- (UISwitch *)power {
    if (!_power) {
        _power = [[UISwitch alloc] initWithFrame:CGRectZero];
        _power.tintColor = Scamera_UISlider_MaxColor;
        _power.backgroundColor = Scamera_UISlider_MaxColor;
        _power.onTintColor = Scamera_UISlider_MinColor;
        _power.thumbTintColor = [UIColor whiteColor];
        //缩小或者放大switch的size
        _power.transform = CGAffineTransformMakeScale(0.9, 0.7);
        _power.layer.cornerRadius = 15.f;
        _power.layer.masksToBounds = YES;
//        _power.layer.anchorPoint = CGPointMake(0, 0.3);

        [self addSubview:_power];
    }
    
    return _power;
}

@end
