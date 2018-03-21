//
//  SCameraFlashLightSettingViewController.m
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraFlashLightSettingViewController.h"
#import "ScameraFlashLightSettingTableView.h"
#import "SCameraDetailSettingViewController.h"
#import "SCameraViewController.h"
#import "SCameraGroupSelectController.h"
#import "SCameraGroupSettingController.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.flashLightSettingView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)updateNavigation {
    
    self.title = @"蓝牙闪光灯";
    
    UIImage *leftBarButtonImage = [UIImage originImage:[UIImage imageNamed:@"navi_back"] scaleToSize:CGSizeMake(22, 22)];
    leftBarButtonImage = [leftBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIImage *rightBarButtonImage = [UIImage originImage:[UIImage imageNamed:@"navi_camera"] scaleToSize:CGSizeMake(22, 22)];
    rightBarButtonImage = [rightBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(camera)];
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
    [FlashLightManager saveMainValue:label.text];
    NSNumber *power = value.allValues.firstObject;
    [self.flashLightSettingView tableViewReloadGroupDate:power.integerValue];
}

//增加安妞
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    
    if (slider.value == 21) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    self.sliderValue = value.allKeys.firstObject;
    label.text = value.allKeys.firstObject;
    [FlashLightManager saveMainValue:label.text];
    NSNumber *power = value.allValues.firstObject;
    [self.flashLightSettingView tableViewReloadGroupDate:power.integerValue];
}

//减少按钮
- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    if ((NSUInteger)(slider.value) == 0) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    self.sliderValue = value.allKeys.firstObject;
    label.text = value.allKeys.firstObject;
    [FlashLightManager saveMainValue:label.text];
    NSNumber *power = value.allValues.firstObject;
    [self.flashLightSettingView tableViewReloadGroupDate:power.integerValue];
}

//通用->详细设置
- (void)ScameraFlashLightSettingClickDetilSettingCell {
    
    SCameraDetailSettingViewController *vc = [[SCameraDetailSettingViewController alloc] initWithNibName:nil bundle:nil];
    vc.blockparameter = ^{
        [self.flashLightSettingView update];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

//通用->启动按钮
- (void)ScameraFlashLightSettingClickStartBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [FlashLightManager saveMainStartSelected:YES];
        [self.flashLightSettingView disableView];
    } else {
        [FlashLightManager saveMainStartSelected:NO];
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
    
    SCameraGroupSelectController *vc = [[SCameraGroupSelectController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击分组设置Cell
- (void)ScameraFlashLightSettingClickGroupSettingCellWithGroupName:(NSString *)str {
    
    SCameraGroupSettingController *vc = [[SCameraGroupSettingController alloc] initWithGroupName:str];
    vc.groupSettingBlock = ^(NSString *str) {
        [self.flashLightSettingView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//点击B Cell
- (void)clickBcellWithGroupName:(NSString *)str {
    SCameraGroupSettingController *vc = [[SCameraGroupSettingController alloc] initWithGroupName:str];

    vc.groupSettingBlock = ^(NSString *str) {
        [self.flashLightSettingView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//点击C Cell
- (void)clickCcellWithGroupName:(NSString *)str {
    SCameraGroupSettingController *vc = [[SCameraGroupSettingController alloc] initWithGroupName:str];
    vc.groupSettingBlock = ^(NSString *str) {
        [self.flashLightSettingView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//点击D Cell
- (void)clickDcellWithGroupName:(NSString *)str {
    SCameraGroupSettingController *vc = [[SCameraGroupSettingController alloc] initWithGroupName:str];
    vc.groupSettingBlock = ^(NSString *str) {
        [self.flashLightSettingView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//点击A Cell 启动按钮
- (void)clickStartA:(UIButton *)btn {
    btn.selected = !btn.selected;
    [FlashLightManager saveStartAIsSelected:btn.selected];
    [self.flashLightSettingView clickStartA];
}

//点击B Cell 启动按钮
- (void)clickStartB:(UIButton *)btn {
    btn.selected = !btn.selected;
    [FlashLightManager saveStartBIsSelected:btn.selected];
    [self.flashLightSettingView clickStartB];
}

//点击C Cell 启动按钮
- (void)clickStartC:(UIButton *)btn {
    btn.selected = !btn.selected;
    [FlashLightManager saveStartCIsSelected:btn.selected];
    [self.flashLightSettingView clickStartC];
}

//点击D Cell 启动按钮
- (void)clickStartD:(UIButton *)btn {
    btn.selected = !btn.selected;
    [FlashLightManager saveStartDIsSelected:btn.selected];
    [self.flashLightSettingView clickStartD];
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
