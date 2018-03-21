//
//  DetailSettingViewController.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraDetailSettingViewController.h"
#import "SCameraDetailSettingTableView.h"
#import "SCameraChannelViewController.h"

@interface SCameraDetailSettingViewController () <SCameraDetailSettingTableViewDelegate>

@property (nonatomic, strong) SCameraDetailSettingTableView *detailView;

@property (nonatomic, strong) NSString *channelStr; //频道

@property (nonatomic, strong) NSString *frequenceValue; //闪频频率值

@property (nonatomic, strong) NSString *times; //次数

@end

@implementation SCameraDetailSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigation];
    [self setUpConstaints];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)updateNavigation {
    
    self.title = @"闪光灯设置";
    
    UIImage *leftBarButtonImage = [UIImage originImage:[UIImage imageNamed:@"navi_back"] scaleToSize:CGSizeMake(22, 22)];
    leftBarButtonImage = [leftBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)saveValue {
    
//        if (self.channelStr.length > 0) {
//            [FlashLightManager saveChannel:self.channelStr.integerValue];
//
//        }
        if (self.frequenceValue.length > 0) {
            [FlashLightManager saveFrequence:self.frequenceValue.integerValue];
        }
        if (self.times.length > 0) {
            [FlashLightManager saveTimes:self.times.integerValue];
        }
    
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
    [self saveValue];
    if (self.blockparameter) {
        self.blockparameter();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark DetailSettingTableViewDelegate
//点击频道Cell
- (void)DetailSettingTableViewDidSelectedChannelCellWithDetailText:(UILabel *)detail {
    
    SCameraChannelViewController *vc = [[SCameraChannelViewController alloc] initWithNibName:nil bundle:nil];
    vc.blockparameter = ^{
        [self.detailView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//点击导入设置Cell
- (void)DetailSettingTableViewDidSelectedImportSetting {
    
    
}

//点击导出设置Cell
- (void)DetailSettingTableViewDidSelectedExportSetting {
    
    
}

//滑动频闪频率Slider
- (void)DetailSettingTableViewDidSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label {
    
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    self.frequenceValue = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.frequenceValue;
    [FlashLightManager saveFrequence:[self.frequenceValue integerValue]];
}

//点击频闪频率减少按钮
- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    if (slider.value == 1) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    self.frequenceValue = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.frequenceValue;
    [FlashLightManager saveFrequence:[self.frequenceValue integerValue]];
}

//点击频闪频率增加按钮
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    
    if (slider.value == 199) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    self.frequenceValue = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.frequenceValue;
    [FlashLightManager saveFrequence:[self.frequenceValue integerValue]];
}

//滑动频闪次数Slider
- (void)DetailSettingTableViewDidTimesCellSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label {
    
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    self.times = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.times;
    [FlashLightManager saveTimes:[self.times integerValue]];
}

//点击次数Cell减少按钮
- (void)Slider:(UISlider *)slider TimesCellClickReduceBtnWithValue:(UILabel *)label {
    if (slider.value == 0) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    self.times = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.times;
    [FlashLightManager saveTimes:[self.times integerValue]];
}

//点击次数Cell增加按钮
- (void)Slider:(UISlider *)slider TimesCellClickIncreaseBtnWithValue:(UILabel *)label {
    if (slider.value == 0) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    self.times = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.times;
    [FlashLightManager saveTimes:[self.times integerValue]];
}

//声音
- (void)ClickVoiceButton:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [FlashLightManager saveIsSoundOpen:YES];
    } else {
        [FlashLightManager saveIsSoundOpen:NO];
    }
}

//造型灯
- (void)ClickModelLampButton:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [FlashLightManager saveIsPoseOpen:YES];
    } else {
        [FlashLightManager saveIsPoseOpen:NO];
    }
}

#pragma  - mark lazy load
- (SCameraDetailSettingTableView *)detailView {
    if (!_detailView) {
        _detailView = [[SCameraDetailSettingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailView.detailSettingTableViewDelegateDelegate = self;
        [self.view addSubview:_detailView];
    }
    return _detailView;
}

- (void)dealloc {
    
}

@end
