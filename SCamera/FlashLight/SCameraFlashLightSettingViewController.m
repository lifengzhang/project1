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
    self.values = @[@"1/128",@"1/128+0.3",@"1/128+0.7",@"1/64",@"1/64+0.3",@"1/64+0.7", @"1/32",@"1/32+0.3",@"1/32 +0.7", @"1/16",@"1/16+0.3",@"1/16+0.7", @"1/8",@"1/8+0.3",@"1/8+0.7",@"1/4",@"1/4+0.3",@"1/4+0.7",@"1/2",@"1/2+0.3",@"1/2+0/7", @"1"];
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
    NSString *value = self.values[index];
    self.sliderValue = value;
    label.text = value;
    NSLog(@"sliderIndex: %i", (int)index);
    NSLog(@"value: %@", value);
}

//增加安妞
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    
    if ([self.sliderValue isEqualToString:@"1"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    NSString *value = self.values[index];
    self.sliderValue = value;
    label.text = value;
}

//减少按钮
- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    if ([self.sliderValue isEqualToString:@"1/128"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    NSString *value = self.values[index];
    self.sliderValue = value;
    label.text = value;
}

//通用->详细设置
- (void)ScameraFlashLightSettingClickDetilSettingCell {
    
    DetailSettingViewController *vc = [[DetailSettingViewController alloc] initWithNibName:nil bundle:nil];
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

@end
