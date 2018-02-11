//
//  SCameraShutterTableViewCell.m
//  SCamera
//
//  Created by sunny on 2018/2/11.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraShutterTableViewCell.h"

@implementation SCameraShutterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.76];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
