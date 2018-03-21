//
//  GroupSettingController.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraGroupSettingController.h"
#import "SCameraGroupSettingTableView.h"
#import "SCameraViewController.h"

@interface SCameraGroupSettingController () <GroupSettingTableViewDelegate>

@property (nonatomic, strong) SCameraGroupSettingTableView *groupView;

@property (nonnull, strong) NSArray *values;

@property (nonatomic, strong) NSString *groupClass;

@end

@implementation SCameraGroupSettingController

- (instancetype)initWithGroupName:(NSString *)str {
    if (self = [super init]) {
        self.title = [NSString stringWithFormat:@"组别%@",str];
        self.groupClass = str;
        [self updateNavigation];
        [self setUpConstains];
        self.values = @[@{@"1/128":@(FlashLightPower1_128)},@{@"1/128+0.3":@(FlashLightPower1_128_1)},@{@"1/128+0.7":@(FlashLightPower1_128_2)},
                        @{@"1/64":@(FlashLightPower1_64)},@{@"1/64+0.3":@(FlashLightPower1_64_1)},@{@"1/64+0.7":@(FlashLightPower1_64_2)},
                        @{@"1/32":@(FlashLightPower1_32)},@{@"1/32+0.3":@(FlashLightPower1_32_1)},@{@"1/32+0.7":@(FlashLightPower1_32_2)},
                        @{@"1/16":@(FlashLightPower1_16)},@{@"1/16+0.3":@(FlashLightPower1_16_1)},@{@"1/16+0.7":@(FlashLightPower1_16_2)},
                        @{@"1/8":@(FlashLightPower1_8)},@{@"1/8+0.3":@(FlashLightPower1_8_1)},@{@"1/8+0.7":@(FlashLightPower1_8_2)},
                        @{@"1/4":@(FlashLightPower1_4)},@{@"1/4+0.3":@(FlashLightPower1_4_1)},@{@"1/4+0.7":@(FlashLightPower1_4_2)},
                        @{@"1/2":@(FlashLightPower1_2)},@{@"1/2+0.3":@(FlashLightPower1_2_1)},@{@"1/2+0.7":@(FlashLightPower1_2_2)},
                        @{@"1":@(FlashLightPower1)}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateNavigation {
    
    UIImage *leftBarButtonImage = [UIImage originImage:[UIImage imageNamed:@"navi_back"] scaleToSize:CGSizeMake(22, 22)];
    leftBarButtonImage = [leftBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIImage *rightBarButtonImage = [UIImage originImage:[UIImage imageNamed:@"navi_camera"] scaleToSize:CGSizeMake(22, 22)];
    rightBarButtonImage = [rightBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(camera)];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)back {
    if (self.groupSettingBlock) {
        self.groupSettingBlock(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)camera {
    
    SCameraViewController *vc = [[SCameraViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpConstains {
    
    [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma -mark GroupSettingTableViewDelegate
- (void)ScameraFlashLightSettingSliderValueChange:(UISlider *)slider andValueLabel:(UILabel *)label {

    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    label.text = value.allKeys.firstObject;
    NSNumber *power = value.allValues.firstObject;
    [self.groupView tableViewReloadCellDateWithPower:power.integerValue andPowerString:label.text];
}

//增加按钮
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    
    if (slider.value == self.values.count - 1) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    label.text = value.allKeys.firstObject;
    NSNumber *power = value.allValues.firstObject;
    [self.groupView tableViewReloadCellDateWithPower:power.integerValue andPowerString:label.text];
}

//减少按钮
-(void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    if ((NSUInteger)(slider.value) == 0) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    NSDictionary *value = self.values[index];
    label.text = value.allKeys.firstObject;
    NSNumber *power = value.allValues.firstObject;
    [self.groupView tableViewReloadCellDateWithPower:power.integerValue andPowerString:label.text];
}

//最小功率Cell
- (void)clickMinPowerCell {
    NSArray *btnName = @[@"1/512",@"1/256",@"1/128",@"1/64",@"1/32",@"1/16",@"1/8"];
    [self showAlertViewInDynamicWithTitle:nil message:nil btnNames:btnName clickedCallBack:^(NSInteger index) {
        if (index == 0) {
            [self.groupView updateMinPowerDetial:btnName[0]];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAMinPower:btnName[0]];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBMinPower:btnName[0]];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCMinPower:btnName[0]];
            } else {
                [FlashLightManager saveDMinPower:btnName[0]];
            }
        } else if (index == 1) {
            [self.groupView updateMinPowerDetial:btnName[1]];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAMinPower:btnName[1]];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBMinPower:btnName[1]];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCMinPower:btnName[1]];
            } else {
                [FlashLightManager saveDMinPower:btnName[1]];
            }
        } else if (index == 2) {
            [self.groupView updateMinPowerDetial:btnName[2]];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAMinPower:btnName[2]];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBMinPower:btnName[2]];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCMinPower:btnName[2]];
            } else {
                [FlashLightManager saveDMinPower:btnName[2]];
            }
        } else if (index == 3) {
            [self.groupView updateMinPowerDetial:btnName[3]];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAMinPower:btnName[3]];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBMinPower:btnName[3]];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCMinPower:btnName[3]];
            } else {
                [FlashLightManager saveDMinPower:btnName[3]];
            }
        } else if (index == 4) {
            [self.groupView updateMinPowerDetial:btnName[4]];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAMinPower:btnName[4]];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBMinPower:btnName[4]];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCMinPower:btnName[4]];
            } else {
                [FlashLightManager saveDMinPower:btnName[4]];
            }
        } else if (index == 5) {
            [self.groupView updateMinPowerDetial:btnName[5]];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAMinPower:btnName[5]];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBMinPower:btnName[5]];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCMinPower:btnName[5]];
            } else {
                [FlashLightManager saveDMinPower:btnName[5]];
            }
        } else if (index == 6) {
            [self.groupView updateMinPowerDetial:btnName[6]];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAMinPower:btnName[6]];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBMinPower:btnName[6]];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCMinPower:btnName[6]];
            } else {
                [FlashLightManager saveDMinPower:btnName[6]];
            }
        }
    }];
}

//模式cell
- (void)clickModelCell {
    
    [self showAlertViewInDynamicWithTitle:nil message:nil btnNames:@[@"自动",@"手动",@"闪光灯",@"LED"] clickedCallBack:^(NSInteger index) {
        if (index == 0) {
            [self.groupView updateModelCellDetail:@"自动"];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAModelStr:@"自动"];
                [FlashLightManager saveAModel:FlashLightModelAuto];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBModelStr:@"自动"];
                [FlashLightManager saveBModel:FlashLightModelAuto];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCModelStr:@"自动"];
                [FlashLightManager saveCModel:FlashLightModelAuto];
            } else {
                [FlashLightManager saveDModelStr:@"自动"];
                [FlashLightManager saveDModel:FlashLightModelAuto];
            }
        } else if (index == 1) {
            [self.groupView updateModelCellDetail:@"手动"];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAModelStr:@"手动"];
                [FlashLightManager saveAModel:FlashLightModelManual];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBModelStr:@"手动"];
                [FlashLightManager saveBModel:FlashLightModelManual];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCModelStr:@"手动"];
                [FlashLightManager saveCModel:FlashLightModelManual];
            } else {
                [FlashLightManager saveDModelStr:@"手动"];
                [FlashLightManager saveDModel:FlashLightModelManual];
            }
        } else if (index == 2) {
            [self.groupView updateModelCellDetail:@"闪光灯"];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAModelStr:@"闪光灯"];
                [FlashLightManager saveAModel:FlashLightModelFlash];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBModelStr:@"闪光灯"];
                [FlashLightManager saveBModel:FlashLightModelFlash];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCModelStr:@"闪光灯"];
                [FlashLightManager saveCModel:FlashLightModelFlash];
            } else {
                [FlashLightManager saveDModelStr:@"闪光灯"];
                [FlashLightManager saveDModel:FlashLightModelFlash];
            }
        } else {
            [self.groupView updateModelCellDetail:@"LED"];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveAModelStr:@"LED"];
                [FlashLightManager saveAModel:FlashLightModelLED];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBModelStr:@"LED"];
                [FlashLightManager saveBModel:FlashLightModelLED];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCModelStr:@"LED"];
                [FlashLightManager saveCModel:FlashLightModelLED];
            } else {
                [FlashLightManager saveDModelStr:@"LED"];
                [FlashLightManager saveDModel:FlashLightModelLED];
            }
        }
    }];
}

//造型灯Cell
- (void)clickLampCell {
    
    [self showAlertViewInDynamicWithTitle:nil message:nil btnNames:@[@"PROP",@"20%",@"100%"] clickedCallBack:^(NSInteger index) {
        if (index == 0) {
            [self.groupView updateLampCellDetail:@"PROP"];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveALightDegreeSre:@"PROP"];
                [FlashLightManager saveALightDegree:FlashLightDegreePROP];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBLightDegreeSre:@"PROP"];
                [FlashLightManager saveBLightDegree:FlashLightDegreePROP];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCLightDegreeSre:@"PROP"];
                [FlashLightManager saveCLightDegree:FlashLightDegreePROP];
            } else {
                [FlashLightManager saveDLightDegreeSre:@"PROP"];
                [FlashLightManager saveDLightDegree:FlashLightDegreePROP];
            }
        } else if (index == 1) {
            [self.groupView updateLampCellDetail:@"20%"];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveALightDegreeSre:@"20%"];
                [FlashLightManager saveALightDegree:FlashLightDegree20];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBLightDegreeSre:@"20%"];
                [FlashLightManager saveBLightDegree:FlashLightDegree20];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCLightDegreeSre:@"20%"];
                [FlashLightManager saveCLightDegree:FlashLightDegree20];
            } else {
                [FlashLightManager saveDLightDegreeSre:@"20%"];
                [FlashLightManager saveDLightDegree:FlashLightDegree20];
            }
        } else {
            [self.groupView updateLampCellDetail:@"100%"];
            if ([self.groupClass isEqualToString:@"A"]) {
                [FlashLightManager saveALightDegreeSre:@"100%"];
                [FlashLightManager saveALightDegree:FlashLightDegree100];
            } else if ([self.groupClass isEqualToString:@"B"]) {
                [FlashLightManager saveBLightDegreeSre:@"100%"];
                [FlashLightManager saveBLightDegree:FlashLightDegree100];
            } else if ([self.groupClass isEqualToString:@"C"]) {
                [FlashLightManager saveCLightDegreeSre:@"100%"];
                [FlashLightManager saveCLightDegree:FlashLightDegree100];
            } else {
                [FlashLightManager saveDLightDegreeSre:@"100%"];
                [FlashLightManager saveDLightDegree:FlashLightDegree100];
            }
        }
    }];
}

//开始Cell
- (void)clickStartCell:(SCameraStartCell *)cell {
    cell.startImage.selected = !cell.startImage.selected;
    if ([self.groupClass isEqualToString:@"A"]) {
        [FlashLightManager saveLaunchA:cell.startImage.selected];
    } else if ([self.groupClass isEqualToString:@"B"]) {
        [FlashLightManager saveLaunchB:cell.startImage.selected];
    } else if ([self.groupClass isEqualToString:@"C"]) {
        [FlashLightManager saveLaunchC:cell.startImage.selected];
    } else {
        [FlashLightManager saveLaunchD:cell.startImage.selected];
    }
    [self.groupView judgeLaunchButtonStatus];
}

//声音按钮
- (void)clickVoiceButton:(UIButton *)btn {
    btn.selected = !btn.selected;
    if ([self.groupClass isEqualToString:@"A"]) {
        [FlashLightManager saveIsVoiceOpenA:btn.selected];
    } else if ([self.groupClass isEqualToString:@"B"]) {
        [FlashLightManager saveIsVoiceOpenB:btn.selected];
    } else if ([self.groupClass isEqualToString:@"C"]) {
        [FlashLightManager saveIsVoiceOpenC:btn.selected];
    } else {
        [FlashLightManager saveIsVoiceOpenD:btn.selected];
    }
}

//闪频按钮
- (void)clickFlashFrequenceButton:(UIButton *)btn {
    btn.selected = !btn.selected;
    if ([self.groupClass isEqualToString:@"A"]) {
        [FlashLightManager saveIsFlashFrequenceOpneA:btn.selected];
    } else if ([self.groupClass isEqualToString:@"B"]) {
        [FlashLightManager saveIsFlashFrequenceOpneB:btn.selected];
    } else if ([self.groupClass isEqualToString:@"C"]) {
        [FlashLightManager saveIsFlashFrequenceOpneC:btn.selected];
    } else {
        [FlashLightManager saveIsFlashFrequenceOpneD:btn.selected];
    }
}

- (SCameraGroupSettingTableView *)groupView {
    if (!_groupView) {
        _groupView = [[SCameraGroupSettingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped WithGroupClass:self.groupClass];
        _groupView.groupSettingTableViewDelegate = self;
        [self.view addSubview:_groupView];
    }
    return _groupView;
}

@end
