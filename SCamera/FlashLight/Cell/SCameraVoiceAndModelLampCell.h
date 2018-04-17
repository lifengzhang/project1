//
//  SCameraVoiceAndModelLampCell.h
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCameraVoiceAndModelLampCell : UITableViewCell

@property (nonatomic, strong) UIButton *voiceBtn;

@property (nonatomic, strong) UIButton *modelLampBtn;

@property (nonatomic, strong) UILabel *voiceLabel;

@property (nonatomic, strong) UILabel *modelLabel;

@property (nonatomic, strong) UIView *bottomLine;

- (void)updateVoiceCell;

- (void)updateGroupSettingCell;

- (void)updateWithGroupName:(NSString *)str;

- (void)enableCell;

- (void)disableCell;

@end