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

@interface ViewController ()

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIButton *blueButton;

@property (nonatomic, strong) BlueManageDeviceTableView *deviceTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    [self initSubView];
}

- (void)initSubView {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100);
        make.left.equalTo(self.view).with.offset(20);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.blueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100);
        make.left.equalTo(self.cameraButton.mas_right).with.offset(20);
        make.width.height.mas_equalTo(50);
    }];
    
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

- (void)showCarmeraView {
    
    SCameraViewController *CameraViewController = [[SCameraViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:CameraViewController animated:YES];
    
}

- (void)showBlueView {
    
    BlueManagerViewController *blueManagerViewController = [[BlueManagerViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:blueManagerViewController animated:YES];
    
}

- (BlueManageDeviceTableView *)deviceTable {
    if (! _deviceTable) {
        _deviceTable = [[BlueManageDeviceTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _deviceTable.manageDeviceTableDelegate = self;
        [self.view addSubview:_deviceTable];
    }
    return _deviceTable;
}

@end
