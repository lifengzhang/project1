//
//  DetailSettingTableView.h
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCameraDetailSettingTableViewDelegate <NSObject>

- (void)DetailSettingTableViewDidSelectedChannelCellWithDetailText:(UILabel *)detail;

- (void)DetailSettingTableViewDidSelectedImportSetting;

- (void)DetailSettingTableViewDidSelectedExportSetting;

- (void)DetailSettingTableViewDidSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label;

- (void)DetailSettingTableViewDidTimesCellSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider TimesCellClickIncreaseBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider TimesCellClickReduceBtnWithValue:(UILabel *)label;

- (void)ClickVoiceButton:(id)sender;

- (void)ClickModelLampButton:(id)sender;

@end

@interface SCameraDetailSettingTableView : UITableView

@property (nonatomic, weak) id<SCameraDetailSettingTableViewDelegate> detailSettingTableViewDelegateDelegate;

@end
