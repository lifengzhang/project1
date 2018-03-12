//
//  GroupSettingController.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "GroupSettingController.h"
#import "GroupSettingTableView.h"
#import "SCameraViewController.h"

@interface GroupSettingController () <GroupSettingTableViewDelegate>

@property (nonatomic, strong) GroupSettingTableView *groupView;

@property (nonatomic, strong) NSString *sliderValue;   //滚轮的值

@property (nonnull, strong) NSArray *values;

@end

@implementation GroupSettingController

- (instancetype)initWithClass:(NSString *)str {
    if (self = [super init]) {
        self.title = [NSString stringWithFormat:@"组别%@",str];
        [self updateNavigation];
        [self setUpConstains];
        self.values = @[@"1/64",@"1/32",@"1/16",@"1/8",@"1/4",@"1/2",@"1"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateNavigation {
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)back {
    if (self.groupSettingBlock) {
        self.groupSettingBlock(self.sliderValue);
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
    self.sliderValue = self.values[index];
    label.text = self.values[index];
}

//增加按钮
- (void)Slider:(UISlider *)slider ClickIncreaseBtnWithValue:(UILabel *)label {
    if ([self.sliderValue isEqualToString:@"1"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value + 1);
    [slider setValue:index animated:NO];
    self.sliderValue = self.values[index];
    label.text = self.values[index];
    
}

//减少按钮
-(void)Slider:(UISlider *)slider ClickReduceBtnWithValue:(UILabel *)label {
    
    if ([self.sliderValue isEqualToString:@"1/64"]) {
        return;
    }
    NSUInteger index = (NSUInteger)(slider.value - 1);
    [slider setValue:index animated:NO];
    self.sliderValue = self.values[index];
    label.text = self.values[index];
}

- (GroupSettingTableView *)groupView {
    if (!_groupView) {
        _groupView = [[GroupSettingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _groupView.groupSettingTableViewDelegate = self;
        [self.view addSubview:_groupView];
    }
    return _groupView;
}

@end
