//
//  GroupSettingTableView.h
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupSettingTableViewDelegate <NSObject>

- (void)ScameraFlashLightSettingSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label;

- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label;

@end

@interface GroupSettingTableView : UITableView

@property (nonatomic, weak) id<GroupSettingTableViewDelegate> groupSettingTableViewDelegate;

@end
