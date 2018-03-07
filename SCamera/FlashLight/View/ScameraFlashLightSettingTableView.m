//
//  ScameraFlashLightSettingTableView.m
//  SCamera
//
//  Created by sunny on 2018/3/2.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "ScameraFlashLightSettingTableView.h"
#import "FlashLightGeneralSettingCell.h"
#import "BlueManagerTableViewSection.h"
#import "FlashLightGeneralSettingSecondCell.h"
#import "FlashLightGeneralSettingThirdCell.h"
#import "FlashLightGroupAddCell.h"
#import "FlashLightGroupSettingCell.h"

static NSString *blueManagerTableViewSectionID = @"blue_Manager_Table_View_Section_Cell_ID";
static NSString *flashLightGeneralSettingCellID = @"flashLight_generalSetting_View_Cell_ID";
static NSString *flashLightGeneralSettingSecondCellID = @"flashLight_generalSetting_View_SecondCell_ID";
static NSString *flashLightGeneralSettingThirdCellID = @"flashLight_generalSetting_View_thirdCell_ID";
static NSString *flashLightGroupSettingCellID = @"flashLight_groupSetting_view_Cell_ID";

@interface ScameraFlashLightSettingTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *valueLabel;  //显示变化的值

@property (nonatomic, strong) FlashLightGeneralSettingCell *generalCell;

@property (nonatomic, strong) FlashLightGroupSettingCell *groupCell;

@property (nonatomic, strong) FlashLightGroupAddCell  *addCell;

@property (nonatomic, strong) FlashLightGeneralSettingThirdCell *thirdCell;

@property (nonatomic, strong) FlashLightGeneralSettingSecondCell *secondCell;

@end

@implementation ScameraFlashLightSettingTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self registCell];
        self.backgroundColor = [UIColor blackColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

- (void)registCell {
    
    [self registerClass:[BlueManagerTableViewSection class] forHeaderFooterViewReuseIdentifier:blueManagerTableViewSectionID];
    [self registerClass:[FlashLightGeneralSettingCell class] forCellReuseIdentifier:flashLightGeneralSettingCellID];
    [self registerClass:[FlashLightGeneralSettingSecondCell class] forCellReuseIdentifier:flashLightGeneralSettingSecondCellID];
    [self registerClass:[FlashLightGeneralSettingThirdCell class] forCellReuseIdentifier:flashLightGeneralSettingThirdCellID];
    [self registerClass:[FlashLightGroupSettingCell class] forCellReuseIdentifier:flashLightGroupSettingCellID];
}

- (void)enableView {
    
    [self.generalCell enableView];
    [self.groupCell enableView];
    [self.addCell enableView];
    [self.thirdCell enableView];
    [self.secondCell enableView];
    self.secondCell.userInteractionEnabled = YES;
}

- (void)disableView {
    
    [self.generalCell disableView];
    [self.groupCell disableView];
    [self.addCell disableView];
    [self.thirdCell disableView];
    [self.secondCell disableView];
    self.secondCell.userInteractionEnabled = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.generalCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingCellID forIndexPath:indexPath];
            [self.generalCell.startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
            [self.generalCell.testButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
            return self.generalCell;
        } else if (indexPath.row == 1) {
            self.secondCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingSecondCellID forIndexPath:indexPath];
            return self.secondCell;
        } else {
            self.thirdCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
            [self.thirdCell.flashLightSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.thirdCell.addButton addTarget:self action:@selector(increaseValue) forControlEvents:UIControlEventTouchUpInside];
            [self.thirdCell.redeceButton addTarget:self action:@selector(reduceValue) forControlEvents:UIControlEventTouchUpInside];
            self.valueLabel = self.thirdCell.valueLabel;
            return self.thirdCell;
        }
    } else {
        
        self.groupCell = [tableView dequeueReusableCellWithIdentifier:flashLightGroupSettingCellID forIndexPath:indexPath];
        return self.groupCell;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(ScameraFlashLightSettingClickDetilSettingCell)]) {
                [self.flashLightSettingTableViewDelegate ScameraFlashLightSettingClickDetilSettingCell];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    
    return [SCameraDevice screenAdaptiveSizeWithIp6Size:40.f];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
    } else {
        return 0.0001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
        } else if (indexPath.row == 1 || indexPath.row == 2) {
            return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
        }
    } else {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        BlueManagerTableViewSection *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:blueManagerTableViewSectionID];
        header.headerSectionTitleLabel.text = @"通用设置";
        return header;
    } else {
        BlueManagerTableViewSection *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:blueManagerTableViewSectionID];
        header.headerSectionTitleLabel.text = @"分组设置";
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        self.addCell = [[FlashLightGroupAddCell alloc] init];
        [self.addCell.addButton addTarget:self action:@selector(addGroupSetting) forControlEvents:UIControlEventTouchUpInside];
        return self.addCell;
    } else {
        return 0;
    }
    
}

//fixedParameter = @[self.channelStr,self.frequenceValue,self.times,self.voiceStatus,self.modelLampStatus];
- (void)updateViewWithArray:(NSArray *)array {
    
    self.secondCell.channelLabel.text = array[0];
    self.secondCell.frequenceLabel.text = [NSString stringWithFormat:@"频闪 %@Hz/%@次",array[1],array[2]];
    self.secondCell.voiceLabel.text = array[3];
    self.secondCell.modelLightLabel.text = array[4];
    [self reloadData];
}

- (void)addGroupSetting {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(ScameraFlashLightSettingClickAddGroup)]) {
        [self.flashLightSettingTableViewDelegate ScameraFlashLightSettingClickAddGroup];
    }
}

- (void)start:(UIButton *)btn {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(ScameraFlashLightSettingClickStartBtn:)]) {
        [self.flashLightSettingTableViewDelegate ScameraFlashLightSettingClickStartBtn:btn];
    }
}

- (void)test:(UIButton *)btn {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(ScameraFlashLightSettingClickStartBtn:)]) {
        [self.flashLightSettingTableViewDelegate ScameraFlashLightSettingClickTestBtn:btn];
    }
}

- (void)valueChanged:(UISlider *)slider {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(ScameraFlashLightSettingSliderValueChange:andValueLabel:)]) {
        [self.flashLightSettingTableViewDelegate ScameraFlashLightSettingSliderValueChange:slider andValueLabel:self.valueLabel];
    }
}

- (void)increaseValue {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(Slider:ClickIncreaseBtnWithValue:)]) {
        [self.flashLightSettingTableViewDelegate Slider:self.thirdCell.flashLightSlider ClickIncreaseBtnWithValue:self.thirdCell.valueLabel];
    }
}
    
- (void)reduceValue {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(Slider:ClickReduceBtnWithValue:)]) {
        [self.flashLightSettingTableViewDelegate Slider:self.thirdCell.flashLightSlider ClickReduceBtnWithValue:self.thirdCell.valueLabel];
    }
}

@end
