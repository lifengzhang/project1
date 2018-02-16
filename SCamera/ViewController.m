//
//  ViewController.m
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/19.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import "ViewController.h"
#import "SCameraViewController.h"
#import "BlueManagerViewController.h"
#import "BlueManageDeviceTableView.h"
#import <AVFoundation/AVFoundation.h>

#define HOMEPAGE_LINE_COLOR                                         \
[UIColor colorWithRed:60 / 255.0 green:60 / 255.0 blue:60 / 255.0 alpha:1.0];
#define HOMEPAGE_TEXT_COLOR                                         \
[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0];

@interface ViewController ()

@property (nonatomic, strong) UIButton *settingButton;

@property (nonatomic, strong) UIImageView *lampImage;

@property (nonatomic, strong) UILabel *ledLabel;

@property (nonatomic, strong) UIView *firstLine;

@property (nonatomic, strong) UIImageView *flashLightImage;

@property (nonatomic, strong) UILabel *flashLightText;

@property (nonatomic, strong) UIView *secondLine;

@property (nonatomic, strong) UIImageView *cameraImage;

@property (nonatomic, strong) UILabel *cameraLabel;

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UILabel *myDeviceText;

@property (nonatomic, strong) UIImageView *connectSignImage;

@property (nonatomic, strong) UIView *lastLine;

@property (nonatomic, strong) UIButton *ledButton;

@property (nonatomic, strong) UIButton *flashButton;

@property (nonatomic, strong) UIButton *myDeviceButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self updateView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initSubView {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.bottom.equalTo(self.view.mas_top).offset(ISIphoneX ? 88 : 64);
    }];
    
    [self.lampImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:107.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:87.f]);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:70.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:50.f]);
    }];
    
    [self.ledLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:199.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:177.f]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:60.f]);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:15.f]);
    }];
    
    [self.ledButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.lampImage);
        make.bottom.equalTo(self.ledLabel);
    }];
    
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:250.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:228.f]);
        make.left.equalTo(self.view).offset(28);
        make.right.equalTo(self.view).offset(-28);
        make.height.mas_equalTo(1);
    }];
    
    [self.flashLightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_bottom).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:63.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:41.f]);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:50.f]);
    }];
    
    [self.flashLightText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_bottom).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:150.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:130.f]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:15.f]);
    }];
    
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.flashLightImage);
        make.bottom.equalTo(self.flashLightText);
    }];
    
    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_bottom).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:202.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:182.f]);
        make.left.equalTo(self.view).offset(28);
        make.right.equalTo(self.view).offset(-28);
        make.height.mas_equalTo(1);
    }];
    
    [self.cameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLine.mas_bottom).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:67.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:47.f]);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:50.f]);
    }];
    
    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLine.mas_bottom).offset(ISIphoneX ? [SCameraDevice screenAdaptiveSizeWithIp6Size:150.f] : [SCameraDevice screenAdaptiveSizeWithIp6Size:130.f]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:15.f]);
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.cameraImage);
        make.bottom.equalTo(self.cameraLabel);
    }];
    
    [self.myDeviceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-[SCameraDevice screenAdaptiveSizeWithIp6Size:25.f]);
        make.centerX.equalTo(self.view).offset(-16.f);
        
    }];
    
    [self.myDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.myDeviceText);
        make.bottom.equalTo(self.lastLine);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:20.f]);
    }];
    
    [self.connectSignImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myDeviceText.mas_right).offset(8);
        make.bottom.equalTo(self.myDeviceText.mas_bottom).offset(3);
        make.width.mas_offset(25);
        make.height.mas_equalTo([SCameraDevice screenAdaptiveSizeWithIp6Size:20.f]);
    }];
    
    [self.lastLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-[SCameraDevice screenAdaptiveSizeWithIp6Size:24.f]);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.myDeviceText.mas_left);
        make.right.equalTo(self.myDeviceText.mas_right);
    }];
    
}

- (void)updateView {
    
    if (BTMe.connectedPeripheral.name.length > 0) {
        self.myDeviceText.text = [NSString stringWithFormat:@"我的设备：%@",BTMe.connectedPeripheral.name];
        [self.connectSignImage setImage:[UIImage imageNamed:@"HomePage_connected"]];
    } else {
        self.myDeviceText.text = @"我的设备：未连接";
        [self.connectSignImage setImage:[UIImage imageNamed:@"HomePage_unconnect"]];
    }
}

- (void)showSettingView {
    
    
}

- (void)showCarmeraView {
    
    SCameraViewController *CameraViewController = [[SCameraViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:CameraViewController animated:YES];
    
}

- (void)tapLEDButton {
    self.ledButton.selected = !self.ledButton.selected;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            if (self.ledButton.selected) {
                [device setTorchMode:AVCaptureTorchModeOn];
            }else{
                [device setTorchMode:AVCaptureTorchModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

- (void)tapFlashLightButton {
    
    
    
}

- (void)showMyDevice {
    
    BlueManagerViewController *blueManagerViewController = [[BlueManagerViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:blueManagerViewController animated:YES];
    
}

#pragma - mark 懒加载
- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_settingButton setImage:[UIImage imageNamed:@"HomePage_setting"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_settingButton];
    }
    return _settingButton;
}

- (UIImageView *)lampImage {
    if (!_lampImage) {
        _lampImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomePage_LED"]];
        [self.view addSubview:_lampImage];
    }
    return _lampImage;
}

- (UILabel *)ledLabel {
    if (!_ledLabel) {
        _ledLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _ledLabel.text = @"LED";
        _ledLabel.textAlignment = NSTextAlignmentCenter;
        _ledLabel.font = [UIFont ChinaBoldFontNameOfSize:15.f];
        _ledLabel.textColor = HOMEPAGE_TEXT_COLOR
        [self.view addSubview:_ledLabel];
    }
    return _ledLabel;
}

- (UIView *)firstLine {
    if (!_firstLine) {
        _firstLine = [[UIView alloc] initWithFrame:CGRectZero];
        _firstLine.backgroundColor = HOMEPAGE_LINE_COLOR
        [self.view addSubview:_firstLine];
    }
    return _firstLine;
}

- (UIImageView *)flashLightImage {
    if (!_flashLightImage) {
        _flashLightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomePage_flashLight"]];
        [self.view addSubview:_flashLightImage];
    }
    return _flashLightImage;
}

- (UILabel *)flashLightText {
    if (!_flashLightText) {
        _flashLightText = [[UILabel alloc] initWithFrame:CGRectZero];
        _flashLightText.text= @"闪光灯";
        _flashLightText.textAlignment = NSTextAlignmentCenter;
        _flashLightText.font = [UIFont ChinaBoldFontNameOfSize:15.f];
        _flashLightText.textColor = HOMEPAGE_TEXT_COLOR
        [self.view addSubview:_flashLightText];
    }
    return _flashLightText;
}

- (UIImageView *)cameraImage {
    if (!_cameraImage) {
        _cameraImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomePage_camera"]];
        [self.view addSubview:_cameraImage];
    }
    return _cameraImage;
}

- (UILabel *)cameraLabel {
    if (!_cameraLabel) {
        _cameraLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cameraLabel.text = @"拍照";
        _cameraLabel.textAlignment = NSTextAlignmentCenter;
        _cameraLabel.font = [UIFont ChinaBoldFontNameOfSize:15.f];
        _cameraLabel.textColor = HOMEPAGE_TEXT_COLOR
        [self.view addSubview:_cameraLabel];
    }
    return _cameraLabel;
}

- (UIView *)secondLine {
    if (!_secondLine) {
        _secondLine = [[UIView alloc] initWithFrame:CGRectZero];
        _secondLine.backgroundColor = HOMEPAGE_LINE_COLOR;
        [self.view addSubview:_secondLine];
    }
    return _secondLine;
}

- (UILabel *)myDeviceText {
    if (!_myDeviceText) {
        _myDeviceText = [[UILabel alloc] initWithFrame:CGRectZero];
        _myDeviceText.text = @"我的设备：未连接";
        _myDeviceText.textAlignment = NSTextAlignmentRight;
        _myDeviceText.textColor = HOMEPAGE_TEXT_COLOR
        _myDeviceText.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
        [self.view addSubview:_myDeviceText];
    }
    return _myDeviceText;
}

- (UIImageView *)connectSignImage {
    if (!_connectSignImage) {
        _connectSignImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomePage_unconnect"]];
        [self.view addSubview:_connectSignImage];
    }
    return _connectSignImage;
}

- (UIView *)lastLine {
    if (!_lastLine) {
        _lastLine = [[UIView alloc] initWithFrame:CGRectZero];
        _lastLine.backgroundColor = HOMEPAGE_TEXT_COLOR
        [self.view addSubview:_lastLine];
    }
    return _lastLine;
}

- (UIButton *)ledButton {
    if (!_ledButton) {
        _ledButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_ledButton addTarget:self action:@selector(tapLEDButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_ledButton];
    }
    return _ledButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_flashButton addTarget:self action:@selector(tapFlashLightButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_flashButton];
    }
    return _flashButton;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cameraButton addTarget:self action:@selector(showCarmeraView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cameraButton];
    }
    return _cameraButton;
}

- (UIButton *)myDeviceButton {
    if (!_myDeviceButton) {
        _myDeviceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_myDeviceButton addTarget:self action:@selector(showMyDevice) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_myDeviceButton];
    }
    return _myDeviceButton;
}

@end
