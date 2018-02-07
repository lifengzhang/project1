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

@property (nonatomic, strong) UIButton *blueButton;

@property (nonatomic, strong) UILabel *myDeviceText;

@property (nonatomic, strong) UILabel *connectedDevice;

@property (nonatomic, strong) UIImageView *connectSignImage;

@property (nonatomic, strong) BlueManageDeviceTableView *deviceTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
        make.bottom.equalTo(self.view.mas_top).offset(64);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.lampImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(87);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.ledLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(177);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(228);
        make.left.equalTo(self.view).offset(28);
        make.right.equalTo(self.view).offset(-28);
        make.height.mas_equalTo(1);
    }];
    
    [self.flashLightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_bottom).offset(41);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.flashLightText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_bottom).offset(130);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    
    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLine.mas_bottom).offset(182);
        make.left.equalTo(self.view).offset(28);
        make.right.equalTo(self.view).offset(-28);
        make.height.mas_equalTo(1);
    }];
    
    [self.cameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLine.mas_bottom).offset(47);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLine.mas_bottom).offset(130);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    
    [self.myDeviceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-25);
        make.right.equalTo(self.view.mas_centerX);
        
    }];
    
    [self.connectedDevice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myDeviceText.mas_right);
        make.bottom.equalTo(self.myDeviceText.mas_bottom);
    }];
    
    [self.connectSignImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.connectedDevice.mas_right).offset(8);
        make.bottom.equalTo(self.connectedDevice.mas_bottom);
    }];
//    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(100);
//        make.left.equalTo(self.view).with.offset(20);
//        make.width.height.mas_equalTo(50);
//    }];
    
//    [self.blueButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(100);
//        make.left.equalTo(self.cameraButton.mas_right).with.offset(20);
//        make.width.height.mas_equalTo(50);
//    }];
    
}

- (void)showBlueView {
    
    BlueManagerViewController *blueManagerViewController = [[BlueManagerViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:blueManagerViewController animated:YES];
    
}

- (void)showSettingView {
    
    
}

- (void)showCarmeraView {
    
    SCameraViewController *CameraViewController = [[SCameraViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:CameraViewController animated:YES];
    
}

#pragma - mark 懒加载
- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_settingButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _settingButton.backgroundColor = [UIColor whiteColor];
        [_settingButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_settingButton];
    }
    return _settingButton;
}

- (UIImageView *)lampImage {
    if (!_lampImage) {
        _lampImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _lampImage.backgroundColor = [UIColor whiteColor]; //text:need delete
        [self.view addSubview:_lampImage];
    }
    return _lampImage;
}

- (UILabel *)ledLabel {
    if (!_ledLabel) {
        _ledLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _ledLabel.text = @"LED";
        _ledLabel.textAlignment = NSTextAlignmentCenter;
        _ledLabel.font = [UIFont boldSystemFontOfSize:15.f];
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
        _flashLightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _flashLightImage.backgroundColor = [UIColor whiteColor]; //text:need delete
        [self.view addSubview:_flashLightImage];
    }
    return _flashLightImage;
}

- (UILabel *)flashLightText {
    if (!_flashLightText) {
        _flashLightText = [[UILabel alloc] initWithFrame:CGRectZero];
        _flashLightText.text= @"闪光灯";
        _flashLightText.textAlignment = NSTextAlignmentCenter;
        _flashLightText.font = [UIFont boldSystemFontOfSize:15.f];
        _flashLightText.textColor = HOMEPAGE_TEXT_COLOR
        [self.view addSubview:_flashLightText];
    }
    return _flashLightText;
}

- (UIImageView *)cameraImage {
    if (!_cameraImage) {
        _cameraImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _cameraImage.backgroundColor = [UIColor whiteColor];//text:need delete
        [self.view addSubview:_cameraImage];
    }
    return _cameraImage;
}

- (UILabel *)cameraLabel {
    if (!_cameraLabel) {
        _cameraLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cameraLabel.text = @"拍照";
        _cameraLabel.textAlignment = NSTextAlignmentCenter;
        _cameraLabel.font = [UIFont boldSystemFontOfSize:15.f];
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

- (BlueManageDeviceTableView *)deviceTable {
    if (! _deviceTable) {
        _deviceTable = [[BlueManageDeviceTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _deviceTable.manageDeviceTableDelegate = self;
        [self.view addSubview:_deviceTable];
    }
    return _deviceTable;
}

- (UIButton *)cameraButton {
    if (! _cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _cameraButton.backgroundColor = [UIColor whiteColor];
        [_cameraButton setTitle:@"相机" forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(showCarmeraView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cameraButton];
    }
    return _cameraButton;
}

- (UIButton *)blueButton {
    if (! _blueButton) {
        _blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _cameraButton.backgroundColor = [UIColor whiteColor];
        [_blueButton setTitle:@"蓝牙" forState:UIControlStateNormal];
        [_blueButton addTarget:self action:@selector(showBlueView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_blueButton];
    }
    return _blueButton;
}

- (UILabel *)myDeviceText {
    if (!_myDeviceText) {
        _myDeviceText = [[UILabel alloc] initWithFrame:CGRectZero];
        _myDeviceText.text = @"我的设备：";
        _myDeviceText.textAlignment = NSTextAlignmentRight;
        _myDeviceText.textColor = HOMEPAGE_TEXT_COLOR
        _myDeviceText.font = [UIFont systemFontOfSize:14.f];
        [self.view addSubview:_myDeviceText];
    }
    return _myDeviceText;
}

- (UILabel *)connectedDevice {
    if (!_connectedDevice) {
        _connectedDevice = [[UILabel alloc] initWithFrame:CGRectZero];
        _connectedDevice.text = @"未连接";
        _connectedDevice.textAlignment = NSTextAlignmentLeft;
        _connectedDevice.textColor = HOMEPAGE_TEXT_COLOR
        _connectedDevice.font = [UIFont systemFontOfSize:14.f];
        [self.view addSubview:_connectedDevice];
    }
    return _connectedDevice;
}

- (UIImageView *)connectSignImage {
    if (!_connectSignImage) {
        _connectSignImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self.view addSubview:_connectSignImage];
    }
    return _connectSignImage;
}

@end
