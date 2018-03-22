//
//  GroupSettingTableView.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraGroupSettingTableView.h"
#import "SCameraFlashLightGeneralSettingThirdCell.h"
#import "SCameraDetailSettingCustomCell.h"
#import "SCameraVoiceAndModelLampCell.h"
#import "BlueManagerTableViewSection.h"

static NSString *fashLightGeneralSettingThirdCellId = @"flashLight_general_cell_ID";
static NSString *detailSettingCustomCellId = @"detailSetting_custom_cell_ID";
static NSString *voiceAndModelLampCellId = @"voice_modelLamp_cell_ID";
static NSString *blueManagerTableViewSectionID = @"blueManager_TableView_Section_ID";
static NSString *startCellID = @"start_Cell_ID";

@interface SCameraGroupSettingTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SCameraFlashLightGeneralSettingThirdCell *flashCell;

@property (nonatomic, strong) SCameraDetailSettingCustomCell *detailCell;

@property (nonatomic, strong) SCameraDetailSettingCustomCell *detailCell1;

@property (nonatomic, strong) SCameraDetailSettingCustomCell *detailCell2;

@property (nonatomic ,strong) SCameraVoiceAndModelLampCell *voiceCell;

@property (nonatomic, strong) SCameraStartCell *startCell;

@property (nonatomic, strong) NSString *groupClass;

@end

@implementation SCameraGroupSettingTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style WithGroupClass:(NSString *)str{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.groupClass = str;
        [self registCell];
        self.backgroundColor = [UIColor blackColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)registCell {
    
    [self registerClass:[SCameraFlashLightGeneralSettingThirdCell class] forCellReuseIdentifier:fashLightGeneralSettingThirdCellId];
    [self registerClass:[SCameraDetailSettingCustomCell class] forCellReuseIdentifier:detailSettingCustomCellId];
    [self registerClass:[SCameraVoiceAndModelLampCell class] forCellReuseIdentifier:voiceAndModelLampCellId];
    [self registerClass:[BlueManagerTableViewSection class] forHeaderFooterViewReuseIdentifier:blueManagerTableViewSectionID];
    [self registerClass:[SCameraStartCell class] forCellReuseIdentifier:startCellID];
}

- (void)tableViewReloadCellDateWithPower:(NSInteger)integer andPowerString:(NSString *)str {
    
    if ([self.groupClass isEqualToString:@"A"]) {
        [FlashLightManager saveAPower:integer];
    } else if ([self.groupClass isEqualToString:@"B"]) {
        [FlashLightManager saveBPower:integer];
    } else if ([self.groupClass isEqualToString:@"C"]) {
        [FlashLightManager saveCPower:integer];
    } else {
        [FlashLightManager saveDPower:integer];
    }
}

- (void)enableView {
    [self.flashCell enableView];
    [self.detailCell enableCell];
    [self.detailCell1 enableCell];
    [self.detailCell2 enableCell];
    [self.voiceCell enableCell];
    self.detailCell.userInteractionEnabled = YES;
    self.detailCell1.userInteractionEnabled = YES;
    self.detailCell2.userInteractionEnabled = YES;
}

- (void)disableView {
    [self.flashCell disableView];
    [self.detailCell disableCell];
    [self.detailCell1 disableCell];
    [self.detailCell2 disableCell];
    [self.voiceCell disableCell];
    self.detailCell.userInteractionEnabled = NO;
    self.detailCell1.userInteractionEnabled = NO;
    self.detailCell2.userInteractionEnabled = NO;
}

- (void)updateMinPowerDetial:(NSString *)str {
    self.detailCell.detail.text = str;
}

- (void)updateModelCellDetail:(NSString *)str {
    self.detailCell1.detail.text = str;
}

- (void)updateLampCellDetail:(NSString *)str {
    self.detailCell2.detail.text = str;
}

- (void)judgeLaunchButtonStatus {
    if ([self.groupClass isEqualToString:@"A"]) {
        if (FlashLightManager.isSelectedStartA) {
            [self disableView];
        } else {
            [self enableView];
        }
    } else if ([self.groupClass isEqualToString:@"B"]) {
        if (FlashLightManager.isSelectedStartB) {
            [self disableView];
        } else {
            [self enableView];
        }
    } else if ([self.groupClass isEqualToString:@"C"]) {
        if (FlashLightManager.isSelectedStartC) {
            [self disableView];
        } else {
            [self enableView];
        }
    } else {
        if (FlashLightManager.isSelectedStartD) {
            [self disableView];
        } else {
            [self enableView];
        }
    }
}

#pragma  -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.flashCell = [tableView dequeueReusableCellWithIdentifier:fashLightGeneralSettingThirdCellId forIndexPath:indexPath];
            [self.flashCell.flashLightSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.flashCell.addButton addTarget:self action:@selector(increaseValue) forControlEvents:UIControlEventTouchUpInside];
            [self.flashCell.redeceButton addTarget:self action:@selector(reduceValue) forControlEvents:UIControlEventTouchUpInside];
            [self.flashCell updateGroupSettingSliderWithGroupClass:self.groupClass];
            return self.flashCell;
        } else {
            self.detailCell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellId forIndexPath:indexPath];
            [self.detailCell updateMinPowerWithGroupName:self.groupClass];
            return self.detailCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.detailCell1 = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellId forIndexPath:indexPath];
            [self.detailCell1 updateModeCellWithGroupName:self.groupClass];
            return self.detailCell1;
        } else {
            self.detailCell2 = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellId forIndexPath:indexPath];
            [self.detailCell2 updateLampCellWithGroupName:self.groupClass];
            self.detailCell2.bottomLine.hidden = YES;
            return self.detailCell2;
        }
    } else if (indexPath.section == 2) {
        self.voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceAndModelLampCellId forIndexPath:indexPath];
        [self.voiceCell updateGroupSettingCell];
        [self.voiceCell.voiceBtn addTarget:self action:@selector(isVoiceOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceCell.modelLampBtn addTarget:self action:@selector(isModelLampOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceCell updateWithGroupName:self.groupClass];
        return self.voiceCell;
    } else {
        self.startCell = [tableView dequeueReusableCellWithIdentifier:startCellID forIndexPath:indexPath];
        [self.startCell updateStartCellWithGroupName:self.groupClass];
        [self judgeLaunchButtonStatus];
        return self.startCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(clickMinPowerCell)]) {
                [self.groupSettingTableViewDelegate clickMinPowerCell];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(clickModelCell)]) {
                [self.groupSettingTableViewDelegate clickModelCell];
            }
        } else {
            if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(clickLampCell)]) {
                [self.groupSettingTableViewDelegate clickLampCell];
            }
        }
    } else if (indexPath.section == 3) {
        if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(clickStartCell:)]) {
            [self.groupSettingTableViewDelegate clickStartCell:self.startCell];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        BlueManagerTableViewSection *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:blueManagerTableViewSectionID];
        header.headerSectionTitleLabel.text = @"功率";
        return header;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
        } else {
            return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
        }
    } else if (indexPath.section == 1) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
    } else if (indexPath.section == 2) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
    } else {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    
    if (section == 0) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:40.f];
    } else {
        return 0.0001;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
  
}

- (void)valueChanged:(UISlider *)slider {
    if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(ScameraFlashLightSettingSliderValueChange:andValueLabel:)]) {
        [self.groupSettingTableViewDelegate ScameraFlashLightSettingSliderValueChange:slider andValueLabel:self.flashCell.valueLabel];
    }
}

- (void)increaseValue {
    if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(Slider:ClickIncreaseBtnWithValue:)]) {
        [self.groupSettingTableViewDelegate Slider:self.flashCell.flashLightSlider ClickIncreaseBtnWithValue:self.flashCell.valueLabel];
    }
}

- (void)reduceValue {
    
    if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(Slider:ClickReduceBtnWithValue:)]) {
        [self.groupSettingTableViewDelegate Slider:self.flashCell.flashLightSlider ClickReduceBtnWithValue:self.flashCell.valueLabel];
    }
}

- (void)isVoiceOpen:(UIButton *)btn {

    if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(clickVoiceButton:)]) {
        [self.groupSettingTableViewDelegate clickVoiceButton:btn];
    }
}

- (void)isModelLampOpen:(UIButton *)btn {
    
    if (self.groupSettingTableViewDelegate && [self.groupSettingTableViewDelegate respondsToSelector:@selector(clickFlashFrequenceButton:)]) {
        [self.groupSettingTableViewDelegate clickFlashFrequenceButton:btn];
    }
}

@end
