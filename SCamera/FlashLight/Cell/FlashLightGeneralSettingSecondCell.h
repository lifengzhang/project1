//
//  FlashLightGeneralSettingSecondCell.h
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashLightGeneralSettingSecondCell : UITableViewCell

@property (nonatomic, strong) UILabel *channelLabel;  //频道label

@property (nonatomic, strong) UILabel *modelLightLabel; //造型灯label

@property (nonatomic, strong) UILabel *voiceLabel;   //声音label

@property (nonatomic, strong) UILabel *frequenceLabel; //频率label

- (void)enableView;

- (void)disableView;

@end
