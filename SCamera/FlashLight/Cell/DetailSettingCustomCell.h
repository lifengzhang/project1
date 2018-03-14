//
//  DetailSettingCustomCell.h
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSettingCustomCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *detail;

- (void)enableCell;

- (void)disableCell;

@end
