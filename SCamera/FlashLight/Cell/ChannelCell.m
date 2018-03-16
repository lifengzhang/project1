//
//  ChannelCell.m
//  SCamera
//
//  Created by sunny on 2018/3/15.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "ChannelCell.h"

@interface ChannelCell ()

@property (nonatomic, strong) UIView *selectedView;

@end

@implementation ChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpConstrains];
    }
    return self;
}


- (void)setUpConstrains {
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.mas_equalTo(50);
    }];
    
}

- (void)updateCellTitle:(NSString *)title {

    self.title.text = title;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.backgroundColor = [UIColor whiteColor];
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.layer.cornerRadius = 25.f;
        _title.layer.masksToBounds = 25.f;
        _title.font = [UIFont boldSystemFontOfSize:20.f];
        [self addSubview:_title];
    }
    return _title;
}

@end
