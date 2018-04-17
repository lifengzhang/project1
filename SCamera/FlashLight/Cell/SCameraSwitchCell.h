//
//  SCameraSwitchCell.h
//  SCamera
//
//  Created by sunny on 2018/4/16.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCameraSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UISwitch *power;

- (void)updateVoiceCell;

- (void)updateLampCell;

@end
