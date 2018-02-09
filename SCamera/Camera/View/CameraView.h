//
//  CameraView.h
//  SCamera
//
//  Created by sunny on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraView : UIView

@property (nonatomic, strong) UIButton *backButton;         //返回按钮

@property (nonatomic, strong) UIButton *photoLibraryButton; //相册

@property (nonatomic, strong) UIButton *flashLightButton;   //闪光灯

@property (nonatomic, strong) UIButton *timerButton;        //定时器

@property (nonatomic, strong) UIButton *exchangeButton;     //相机翻转

@property (nonatomic, strong) UIButton *photoButton;        //拍照按钮

@property (nonatomic, strong) UIButton *bluetoothButton;    //蓝牙按钮

@property (nonatomic, strong) UIButton *valueButton;         //调节按钮

- (instancetype)initWithFrame:(CGRect)frame;

@end
