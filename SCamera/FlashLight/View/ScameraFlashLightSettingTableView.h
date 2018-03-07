//
//  ScameraFlashLightSettingTableView.h
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScameraFlashLightSettingTableViewDelegate <NSObject>

- (void)ScameraFlashLightSettingSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label;

- (void)ScameraFlashLightSettingClickDetilSettingCell;

- (void)ScameraFlashLightSettingClickStartBtn:(UIButton *)btn;

- (void)ScameraFlashLightSettingClickTestBtn:(UIButton *)btn;

- (void)ScameraFlashLightSettingClickAddGroup;

- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label;

@end

@interface ScameraFlashLightSettingTableView : UITableView

@property (nonatomic, weak) id<ScameraFlashLightSettingTableViewDelegate> flashLightSettingTableViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (void)enableView;

- (void)disableView;

- (void)updateViewWithArray:(NSArray *)array;

@end
