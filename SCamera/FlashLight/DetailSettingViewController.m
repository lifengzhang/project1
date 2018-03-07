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
    if (self.channelStr.length == 0) {
        self.channelStr = @"频道 1";
    }
    if (self.frequenceValue.length == 0) {
        self.frequenceValue = @"1";
    }
    if (self.times.length == 0) {
        self.times = @"1";
    }
    if (self.voiceStatus.length == 0) {
        self.voiceStatus = @"声音 关";
    }
    if (self.modelLampStatus.length == 0) {
        self.modelLampStatus = @"造型灯 关";
    }
    NSArray *fixedParameter = @[self.channelStr,self.frequenceValue,self.times,self.voiceStatus,self.modelLampStatus];
    if (self.blockparameter) {
        self.blockparameter(fixedParameter);
    }
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

//滑动频闪频率Slider
- (void)DetailSettingTableViewDidSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label {
    
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    self.frequenceValue = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.frequenceValue;
    FlashLightManager.flashFrequency = [self.frequenceValue integerValue];
}

//点击频闪频率减少按钮
- (void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    if ([self.frequenceValue isEqualToString:@"1"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    self.frequenceValue = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.frequenceValue;
    FlashLightManager.flashFrequency = [self.frequenceValue integerValue];
}

//点击频闪频率增加按钮
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    
    if ([self.frequenceValue isEqualToString:@"199"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    self.frequenceValue = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.frequenceValue;
    FlashLightManager.flashFrequency = [self.frequenceValue integerValue];
}

//滑动频闪次数Slider
- (void)DetailSettingTableViewDidTimesCellSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label {
    
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    self.times = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.times;
    FlashLightManager.flashNumber = [self.times integerValue];
}

//点击次数Cell减少按钮
- (void)Slider:(UISlider *)slider TimesCellClickReduceBtnWithValue:(UILabel *)label {
    
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    self.times = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.times;
    FlashLightManager.flashNumber = [self.times integerValue];
}

//点击次数Cell增加按钮
- (void)Slider:(UISlider *)slider TimesCellClickIncreaseBtnWithValue:(UILabel *)label {
    
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    self.times = [NSString stringWithFormat:@"%.f",slider.value];
    label.text = self.times;
    FlashLightManager.flashNumber = [self.times integerValue];
}

//声音
- (void)ClickVoiceButton:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        FlashLightManager.isSoundOpen = YES;
        self.voiceStatus = @"声音 开";
    } else {
        FlashLightManager.isSoundOpen = NO;
        self.voiceStatus = @"声音 关";
    }
}

//造型灯
- (void)ClickModelLampButton:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        FlashLightManager.isPoseOpen = YES;
        self.modelLampStatus = @"造型灯 开";
    } else {
        FlashLightManager.isPoseOpen = NO;
        self.modelLampStatus = @"造型灯 关";
    }
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
