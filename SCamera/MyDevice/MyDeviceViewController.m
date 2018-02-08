//
//  MyDeviceViewController.m
//  SCamera
//
//  Created by sunny on 2018/2/8.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "MyDeviceTableView.h"

@interface MyDeviceViewController ()

@property (nonatomic, strong) MyDeviceTableView *myDevieceTableView;

@end

@implementation MyDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConstraints];
    self.title = @"我的设备";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupConstraints {
    
    [self.myDevieceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (MyDeviceTableView *)myDevieceTableView {
    if (!_myDevieceTableView) {
        _myDevieceTableView = [[MyDeviceTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_myDevieceTableView];
    }
    return _myDevieceTableView;
}

@end
