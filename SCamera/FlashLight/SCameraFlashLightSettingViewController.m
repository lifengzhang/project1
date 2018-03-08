//
//  SCameraFlashLightSettingViewController.m
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraFlashLightSettingViewController.h"
#import "ScameraFlashLightSettingTableView.h"
#import "DetailSettingViewController.h"
#import "SCameraViewController.h"

@interface SCameraFlashLightSettingViewController () <ScameraFlashLightSettingTableViewDelegate>

@property (nonatomic, strong) ScameraFlashLightSettingTableView *flashLightSettingView;

@property (nonatomic, strong) NSString *sliderValue;   //滚轮的值

@property (nonnull, strong) NSArray *values;

@end

@implementation SCameraFlashLightSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigation];
    [self setUpConstrains];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.values = @[@{@"1/128":@(FlashLightPower1_128)},@{@"1/128+0.3":@(FlashLightPower1_128_1)},@{@"1/128+0.7":@(FlashLightPower1_128_2)},
                    @{@"1/64":@(FlashLightPower1_64)},@{@"1/64+0.3":@(FlashLightPower1_64_1)},@{@"1/64+0.7":@(FlashLightPower1_64_2)},
                    @{@"1/32":@(FlashLightPower1_32)},@{@"1/32+0.3":@(FlashLightPower1_32_1)},@{@"1/32+0.7":@(FlashLightPower1_32_2)},
                    @{@"1/16":@(FlashLightPower1_16)},@{@"1/16+0.3":@(FlashLightPower1_16_1)},@{@"1/16+0.7":@(FlashLightPower1_16_2)},
                    @{@"1/8":@(FlashLightPower1_8)},@{@"1/8+0.3":@(FlashLightPower1_8_1)},@{@"1/8+0.7":@(FlashLightPower1_8_2)},
                    @{@"1/4":@(FlashLightPower1_4)},@{@"1/4+0.3":@(FlashLightPower1_4_1)},@{@"1/4+0.7":@(FlashLightPower1_4_2)},
                    @{@"1/2":@(FlashLightPower1_2)},@{@"1/2+0.3":@(FlashLightPower1_2_1)},@{@"1/2+0.7":@(FlashLightPower1_2_2)},
                    @{@"1":@(FlashLightPower1)}];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.sliderValue.length > 0) {
        [FlashLightManager saveFlashPower:self.sliderValue];

    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)updateNavigation {
    
    self.title = @"蓝牙闪光灯";
    
    UIImage *leftBarButtonImage = [self OriginImage:[UIImage imageNamed:@"navi_back"] scaleToSize:CGSizeMake(22, 22)];
    leftBarButtonImage = [leftBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIImage *rightBarButtonImage = [self OriginImage:[UIImage imageNamed:@"navi_camera"] scaleToSize:CGSizeMake(22, 22)];
    rightBarButtonImage = [rightBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(camera)];
}

- (UIImage*)OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (void)setUpConstrains {
    
    [self.flashLightSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)camera {
    
    SCameraViewController *vc = [[SCameraViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma - mark ScameraFlashLightSettingTableViewDelegate
- (void)ScameraFlashLightSettingSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label {

    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    self.sliderValue = value.allKeys.firstObject;
    label.text = value.allKeys.firstObject;
    NSNumber *power = value.allValues.firstObject;
//    FlashLightManager.aPower = power.integerValue;
    [FlashLightManager saveAPower:power.integerValue];
}

//增加安妞
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    
    if ([self.sliderValue isEqualToString:@"1"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    self.sliderValue = value.allKeys.firstObject;
    label.text = value.allKeys.firstObject;
    NSNumber *power = value.allValues.firstObject;
//    FlashLightManager.aPower = power.integerValue;
    [FlashLightManager saveAPower:power.integerValue];

}

//减少按钮
- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    if ([self.sliderValue isEqualToString:@"1/128"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    self.sliderValue = value.allKeys.firstObject;
    label.text = value.allKeys.firstObject;
    NSNumber *power = value.allValues.firstObject;
//    FlashLightManager.aPower = power.integerValue;
    [FlashLightManager saveAPower:power.integerValue];
}

//通用->详细设置
- (void)ScameraFlashLightSettingClickDetilSettingCell {
    
    DetailSettingViewController *vc = [[DetailSettingViewController alloc] initWithNibName:nil bundle:nil];
    vc.blockparameter = ^{
        [self.flashLightSettingView update];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

//通用->启动按钮
- (void)ScameraFlashLightSettingClickStartBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.flashLightSettingView disableView];
    } else {
        [self.flashLightSettingView enableView];
    }
}

//测试按钮
- (void)ScameraFlashLightSettingClickTestBtn:(UIButton *)btn {
    
//    NSData *data = [FlashLightManager getSettingBytes];
    
    [BTMe SplightFire];
    
}

//增加分组设置
- (void)ScameraFlashLightSettingClickAddGroup {
    
    
}

#pragma - mark lazy load
- (ScameraFlashLightSettingTableView *)flashLightSettingView {
    if (!_flashLightSettingView) {
        _flashLightSettingView = [[ScameraFlashLightSettingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _flashLightSettingView.flashLightSettingTableViewDelegate = self;
        [self.view addSubview:_flashLightSettingView];
    }
    return _flashLightSettingView;
}

- (void)dealloc {
    
}

@end
