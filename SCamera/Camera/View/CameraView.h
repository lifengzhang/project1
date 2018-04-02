//
//  CameraView.h
//  SCamera
//
//  Created by sunny on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraView : UIView

@property (nonatomic, strong) UIView *navigationView; //导航视图

@property (nonatomic, strong) UIButton *backButton;         //返回按钮

@property (nonatomic, strong) UIImageView *closeImage;  //关闭按钮图片

@property (nonatomic, strong) UIImageView *timerImage;  //定时器按钮照片

@property (nonatomic, strong) UIButton *photoLibraryButton; //相册

@property (nonatomic, strong) UIButton *flashLightButton;   //闪光灯

@property (nonatomic, strong) UIButton *timerButton;        //定时器

@property (nonatomic, strong) UIButton *exchangeButton;     //相机翻转

@property (nonatomic, strong) UIButton *photoButton;        //拍照按钮

@property (nonatomic, strong) UIButton *bluetoothButton;    //蓝牙按钮

@property (nonatomic, strong) UIButton *valueButton;        //调节按钮

@property (nonatomic, strong) UIView *topWhiteLine;         //调节器顶端白线

@property (nonatomic, strong) UIView *bottomWhiteLine;      //调节器底端白线

@property (nonatomic, strong) UILabel *showISOValue;        //显示ISO数据

@property (nonatomic, strong) UILabel *showShutterValue;    //显示shutter数据

@property (nonatomic, strong) UILabel *showAWBValue;        //显示AWB数据

@property (nonatomic, strong) UILabel *showExposureValue;   //显示曝光度

@property (nonatomic, strong) UIView *shutterView;          //shutter背景视图

@property (nonatomic, strong) UIView *isoBackgroundView;    //ios背景视图

@property (nonatomic, strong) UILabel *centerTimerLabel;    //中央倒计时

@property (nonatomic, strong) UILabel *timerLabel;          //button旁边计时

@property (nonatomic, strong) UIImageView *flashImage;  //闪光灯按钮图片

@property (nonatomic, strong) UIImageView *valueImage;   //调节按钮图片

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showView;

- (void)hiddenView;

@end
