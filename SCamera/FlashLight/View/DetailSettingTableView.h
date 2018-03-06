//
//  DetailSettingTableView.h
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailSettingTableViewDelegate <NSObject>

- (void)DetailSettingTableViewDidSelectedChannelCellWithDetailText:(UILabel *)detail;

- (void)DetailSettingTableViewDidSelectedImportSetting;

- (void)DetailSettingTableViewDidSelectedExportSetting;

- (void)DetailSettingTableViewDidSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider TimesCellClickIncreaseBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider TimesCellClickReduceBtnWithValue:(UILabel *)label;

@end

@interface DetailSettingTableView : UITableView

@property (nonatomic, weak) id<DetailSettingTableViewDelegate> detailSettingTableViewDelegateDelegate;

@end
