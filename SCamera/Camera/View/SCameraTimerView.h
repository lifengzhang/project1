//
//  SCameraTimerView.h
//  SCamera
//
//  Created by sunny on 2018/4/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCameraTimerView : UIView

@property (nonatomic, strong) UIImageView *timerImage;

@property (nonatomic, strong) UIButton *timerBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *threeSeconds;

@property (nonatomic, strong) UIButton *tenSeconds;

- (void)showView;

- (void)hiddenView;

@end
