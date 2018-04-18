//
//  SCameraFlashLightSection.m
//  SCamera
//
//  Created by sunny on 2018/4/16.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraFlashLightSection.h"

@implementation SCameraFlashLightSection

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier  {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUpConstrains];
        self.contentView.backgroundColor = Scamera_TableView_BackgroundColor;
    }
    return self;
}

- (void)setUpConstrains {
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.centerY.equalTo(self);
    }];
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:26.f]);
    }];
    
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont ChinaDefaultFontNameOfSize:11.f];
        _title.textColor = Scamera_TextColor_Gray;
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)detail {
    if (!_detail) {
        _detail = [[UILabel alloc] initWithFrame:CGRectZero];
        _detail.font = [UIFont ChinaDefaultFontNameOfSize:11.f];
        _detail.textColor = Scamera_TextColor_Gray;
        _detail.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_detail];
    }
    return _detail;
}

@end
