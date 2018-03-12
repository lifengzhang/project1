//
//  GroupSelectController.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "GroupSelectController.h"
#import "GroupSelectTableView.h"

@interface GroupSelectController () <GroupSelectTableViewDelegate>

@property (nonatomic, strong) GroupSelectTableView *groupSelectView;

@end

@implementation GroupSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigation];
    [self setUpConstaints];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)updateNavigation {
    
    self.title = @"分组选择";

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

- (void)setUpConstaints {
    
    [self.groupSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - mark GroupSelectTableViewDelegate
- (void)clickAGroup:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [FlashLightManager saveGroupArray:@"A"];
        [FlashLightManager saveIsSelectedA:YES];
    } else {
        [FlashLightManager removeGroupString:@"A"];
        [FlashLightManager saveIsSelectedA:NO];
    }
    [self.groupSelectView aButtonSelect:FlashLightManager.isSelectedA];
}

- (void)clickBGroup:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [FlashLightManager saveGroupArray:@"B"];
        [FlashLightManager saveIsSelectedB:YES];
    } else {
        [FlashLightManager removeGroupString:@"B"];
        [FlashLightManager saveIsSelectedB:NO];
    }
    [self.groupSelectView bButtonSelect:FlashLightManager.isSelectedB];
}

- (void)clickCGroup:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [FlashLightManager saveGroupArray:@"C"];
        [FlashLightManager saveIsSelectedC:YES];
    } else {
        [FlashLightManager removeGroupString:@"C"];
        [FlashLightManager saveIsSelectedC:NO];
    }
    [self.groupSelectView cButtonSelect:FlashLightManager.isSelectedC];
}

- (void)clickDGroup:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [FlashLightManager saveGroupArray:@"D"];
        [FlashLightManager saveIsSelectedD:YES];
    } else {
        [FlashLightManager removeGroupString:@"D"];
        [FlashLightManager saveIsSelectedD:NO];
    }
    [self.groupSelectView dButtonSelect:FlashLightManager.isSelectedD];
}

- (GroupSelectTableView *)groupSelectView {
    if (!_groupSelectView) {
        _groupSelectView = [[GroupSelectTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _groupSelectView.groupSelectTableViewDelegate = self;
        [self.view addSubview:_groupSelectView];
    }
    return _groupSelectView;
}

@end
