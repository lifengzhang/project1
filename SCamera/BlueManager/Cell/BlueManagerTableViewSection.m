//
//  BlueManagerTableViewSection.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "BlueManagerTableViewSection.h"

#define HeaderSectionTitleLabelColor                                                        \
[UIColor colorWithRed:196 / 255.0 green:196 / 255.0 blue:196 / 255.0 alpha:1.0]

@implementation BlueManagerTableViewSection

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor blackColor];
        
        [self setUpConstrain];
    }
    return self;
}

- (void)setUpConstrain {
    
    [self.headerSectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(17);
        make.centerY.equalTo(self);
    }];
    
}

- (UILabel *)headerSectionTitleLabel {
    if (! _headerSectionTitleLabel) {
        
        _headerSectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _headerSectionTitleLabel.font = [UIFont ChinaDefaultFontNameOfSize:12];
        _headerSectionTitleLabel.textColor = HeaderSectionTitleLabelColor;
        _headerSectionTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_headerSectionTitleLabel];
        
    }
    return _headerSectionTitleLabel;
}

@end
