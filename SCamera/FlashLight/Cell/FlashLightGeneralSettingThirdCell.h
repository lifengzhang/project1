//
//  FlashLightGeneralSettingThirdCell.h
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashLightGeneralSettingThirdCell : UITableViewCell

@property (nonatomic, strong) UIButton *addButton; //＋按钮

@property (nonatomic, strong) UIButton *redeceButton; //-按钮

@property (nonatomic, strong) UILabel *valueLabel;  //显示变化的值

@property (nonatomic, strong) UILabel *minLabel;  //最小值

@property (nonatomic, strong) UILabel *maxLabel; //最大值

@property (nonatomic, strong) UISlider *flashLightSlider; //滑轮

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *detail;

@property (nonatomic, strong) UIView *bottomLine;

- (void)enableView;

- (void)disableView;

@end
