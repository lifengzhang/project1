//
//  SCameraFlashLightGeneralSettingCell.h
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCameraFlashLightGeneralSettingCell : UITableViewCell

@property (nonatomic, strong) UIButton *testButton;

@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIImageView *startImage;

- (void)enableView;

- (void)disableView;

@end
