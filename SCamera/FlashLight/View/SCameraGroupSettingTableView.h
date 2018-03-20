//
//  GroupSettingTableView.h
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCameraStartCell.h"

@protocol GroupSettingTableViewDelegate <NSObject>

- (void)ScameraFlashLightSettingSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label;

- (void)clickVoiceButton:(UIButton *)btn;

- (void)clickFlashFrequenceButton:(UIButton *)btn;

- (void)clickMinPowerCell;

- (void)clickModelCell;

- (void)clickLampCell;

- (void)clickStartCell:(SCameraStartCell *)cell;

@end

@interface SCameraGroupSettingTableView : UITableView

@property (nonatomic, weak) id<GroupSettingTableViewDelegate> groupSettingTableViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style WithGroupClass:(NSString *)str;

- (void)tableViewReloadCellDateWithPower:(NSInteger)integer andPowerString:(NSString *)str;

- (void)enableView;

- (void)disableView;

- (void)judgeLaunchButtonStatus;

- (void)updateModelCellDetail:(NSString *)str;

- (void)updateLampCellDetail:(NSString *)str;

- (void)updateMinPowerDetial:(NSString *)str;

@end
