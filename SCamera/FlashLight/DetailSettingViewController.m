//
//  DetailSettingViewController.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "DetailSettingViewController.h"
#import "DetailSettingTableView.h"

@interface DetailSettingViewController () <DetailSettingTableViewDelegate>

@property (nonatomic, strong) DetailSettingTableView *detailView;

@property (nonatomic, strong) NSString *channelStr; //频道

@property (nonatomic, strong) NSString *frequenceValue; //闪频频率值

@property (nonatomic, strong) NSString *times; //次数

@property (nonatomic, strong) NSString *voiceStatus; //声音状态

@property (nonatomic, strong) NSString *modelLampStatus; //造型灯状态

@end

@implementation DetailSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigation];
    [self setUpConstaints];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)updateNavigation {
    
    self.title = @"闪光灯设置";
    
    UIImage *leftBarButtonImage = [self OriginImage:[UIImage imageNamed:@"navi_back"] scaleToSize:CGSizeMake(22, 22)];
    leftBarButtonImage = [leftBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (UIImage*)OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setUpConstaints {
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)back {
    
//    if (self.blockparameter) {
//        self.blockparameter = ^(NSArray *fixedParameter) {
//            fixedParameter = @[self.channelStr,self.frequenceValue,self.times,self.voiceStatus,self.modelLampStatus];
//        };
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark DetailSettingTableViewDelegate
//点击频道Cell
- (void)DetailSettingTableViewDidSelectedChannelCellWithDetailText:(UILabel *)detail {
    
    
}

//点击导入设置Cell
- (void)DetailSettingTableViewDidSelectedImportSetting {
    
    
}

//点击导出设置Cell
- (void)DetailSettingTableViewDidSelectedExportSetting {
    
    
}

//点击频率Cell Slider
- (void)DetailSettingTableViewDidSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label {
    
    
}

//点击频闪频率减少按钮
- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    
}

//点击频闪频率增加按钮
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    
    
}

//点击次数Cell减少按钮
- (void)Slider:(UISlider *)slider TimesCellClickReduceBtnWithValue:(UILabel *)label {
    
    
}

//点击次数Cell增加按钮
- (void)Slider:(UISlider *)slider TimesCellClickIncreaseBtnWithValue:(UILabel *)label {
    
    
}

#pragma  - mark lazy load
- (DetailSettingTableView *)detailView {
    if (!_detailView) {
        _detailView = [[DetailSettingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailView.detailSettingTableViewDelegateDelegate = self;
        [self.view addSubview:_detailView];
    }
    return _detailView;
}

@end
