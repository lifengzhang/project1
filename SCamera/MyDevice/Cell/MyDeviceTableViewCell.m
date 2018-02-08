//
//  MyDeviceTableViewCell.m
//  SCamera
//
//  Created by sunny on 2018/2/8.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "MyDeviceTableViewCell.h"

#define MYDEVICE_BACKGROUND_COLOR                                         \
[UIColor colorWithRed:48 / 255.0 green:48 / 255.0 blue:48 / 255.0 alpha:1.0];
#define MYDEVICE_TITLE_TEXT_COLOR                                         \
[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:255 / 255.0];
#define MYDEVICE_LINE_VIEW_COLOR                                          \
[UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:55 / 255.0 alpha:1.0];

#define TITLE_MARGE                              17.f
#define LINEVIEW_HEIGHT                           1.f

@interface MyDeviceTableViewCell ()

@end

@implementation MyDeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MYDEVICE_BACKGROUND_COLOR;
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(TITLE_MARGE);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(TITLE_MARGE);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(LINEVIEW_HEIGHT);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = MYDEVICE_TITLE_TEXT_COLOR
        _titleLabel.backgroundColor = MYDEVICE_BACKGROUND_COLOR
        _titleLabel.font = [UIFont ChinaDefaultFontNameOfSize:14];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = MYDEVICE_LINE_VIEW_COLOR
        [self.contentView addSubview:_lineView];
    }
    return  _lineView;
}

@end
