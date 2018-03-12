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

- (void)ScameraFlashLightSettingClickGroupSettingCellWithClass:(NSString *)str;

- (void)clickBcellWithClass:(NSString *)str;

- (void)clickCcellWithClass:(NSString *)str;

- (void)clickDcellWithClass:(NSString *)str;

- (void)clickStartA:(UIButton *)btn;

- (void)clickStartB:(UIButton *)btn;

- (void)clickStartC:(UIButton *)btn;

- (void)clickStartD:(UIButton *)btn;

@end

@interface ScameraFlashLightSettingTableView : UITableView

@property (nonatomic, weak) id<ScameraFlashLightSettingTableViewDelegate> flashLightSettingTableViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (void)enableView;

- (void)disableView;

- (void)update;

- (void)clickStartA;

- (void)clickStartB;

- (void)clickStartC;

- (void)clickStartD;

- (void)tableViewReloadGroupDate;

- (void)updateACellValue:(NSString *)str;

- (void)updateBCellValue:(NSString *)str;

- (void)updateCCellValue:(NSString *)str;

- (void)updateDCellValue:(NSString *)str;


@end
