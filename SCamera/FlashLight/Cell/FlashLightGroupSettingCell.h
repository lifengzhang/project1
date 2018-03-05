//
//  FlashLightGroupSettingCell.h
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashLightGroupSettingCell : UITableViewCell

@property (nonatomic, strong) UIButton *startBtn; //启动按钮

@property (nonatomic, strong) UILabel *grouplType; //分组类型

@property (nonatomic, strong) UILabel *modelTypr; //模式类型

@property (nonatomic, strong) UILabel *voiceType; //声音类型

@property (nonatomic, strong) UILabel *frequenceType; //频闪类型

@property (nonatomic, strong) UILabel *value;   //显示数值

@property (nonatomic, strong) UIView *bottomLine;

- (void)enableView;

- (void)disableView;

@end
