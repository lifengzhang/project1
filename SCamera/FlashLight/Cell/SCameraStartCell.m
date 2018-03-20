//
//  SCameraStartCell.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraStartCell.h"

@interface SCameraStartCell ()

@end

@implementation SCameraStartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Scamera_Cell_Background;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpConstraints];
    }
    return self;
}

- (void)setUpConstraints {
    
    [self.startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:38.f]);
    }];
}

- (void)updateStartCellWithGroupName:(NSString *)str {
    if ([str isEqualToString:@"A"]) {
        self.startImage.selected = FlashLightManager.isLaunchA;
    } else if ([str isEqualToString:@"B"]) {
        self.startImage.selected = FlashLightManager.isLaunchB;
    } else if ([str isEqualToString:@"C"]) {
        self.startImage.selected = FlashLightManager.isLaunchC;
    } else {
        self.startImage.selected = FlashLightManager.isLaunchD;
    }
}

- (UIButton *)startImage {
    if (!_startImage) {
        _startImage = [[UIButton alloc] initWithFrame:CGRectZero];
        [_startImage setImage:[UIImage imageNamed:@"FlashLight_Start"] forState:UIControlStateSelected];
        [_startImage setImage:[UIImage imageNamed:@"FlashLight_Stop"] forState:UIControlStateNormal];
        _startImage.userInteractionEnabled = NO;
        [self addSubview:_startImage];
    }
    return _startImage;
}

@end
