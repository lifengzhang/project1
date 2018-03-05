//
//  FlashLightGroupAddCell.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "FlashLightGroupAddCell.h"

@interface FlashLightGroupAddCell ()

@property (nonatomic, strong) UIButton *addImage;

@end

@implementation FlashLightGroupAddCell

- (instancetype)init {
    if (self = [super init]) {
        [self setUpConstraints];
        self.backgroundColor = Scamera_Cell_Background;
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:30.f]);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)enableView {
    self.addButton.enabled = YES;
    self.addImage.enabled = YES;
}

- (void)disableView {
    self.addButton.enabled = NO;
    self.addImage.enabled = NO;
}

- (UIButton *)addImage {
    if (!_addImage) {
        _addImage = [[UIButton alloc] initWithFrame:CGRectZero];
        [_addImage setImage:[UIImage imageNamed:@"FlashLight_addSetting"] forState:UIControlStateNormal];
        [self addSubview:_addImage];
    }
    return _addImage;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_addButton];
    }
    return _addButton;
}

@end
