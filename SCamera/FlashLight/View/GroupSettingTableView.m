//
//  GroupSettingTableView.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "GroupSettingTableView.h"
#import "FlashLightGeneralSettingThirdCell.h"
#import "DetailSettingCustomCell.h"
#import "VoiceAndModelLampCell.h"
#import "BlueManagerTableViewSection.h"

static NSString *fashLightGeneralSettingThirdCellId = @"flashLight_general_cell_ID";
static NSString *detailSettingCustomCellId = @"detailSetting_custom_cell_ID";
static NSString *voiceAndModelLampCellId = @"voice_modelLamp_cell_ID";
static NSString *blueManagerTableViewSectionID = @"blueManager_TableView_Section_ID";
static NSString *startCellID = @"start_Cell_ID";


@interface GroupSettingTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FlashLightGeneralSettingThirdCell *flashCell;

@property (nonatomic, strong) DetailSettingCustomCell *detailCell;

@property (nonatomic, strong) DetailSettingCustomCell *detailCell1;

@property (nonatomic, strong) DetailSettingCustomCell *detailCell2;

@property (nonatomic ,strong) VoiceAndModelLampCell *voiceCell;

@property (nonatomic, strong) StartCell *startCell;

@property (nonatomic, strong) NSString *groupClass;

@end

@implementation GroupSettingTableView

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
    
    [self registerClass:[FlashLightGeneralSettingThirdCell class] forCellReuseIdentifier:fashLightGeneralSettingThirdCellId];
    [self registerClass:[DetailSettingCustomCell class] forCellReuseIdentifier:detailSettingCustomCellId];
    [self registerClass:[VoiceAndModelLampCell class] forCellReuseIdentifier:voiceAndModelLampCellId];
    [self registerClass:[BlueManagerTableViewSection class] forHeaderFooterViewReuseIdentifier:blueManagerTableViewSectionID];
    [self registerClass:[StartCell class] forCellReuseIdentifier:startCellID];
}

- (void)tableViewReloadCellDateWithPower:(NSInteger)integer andPowerString:(NSString *)str {
    
    if ([self.groupClass isEqualToString:@"A"]) {
        [FlashLightManager saveAPower:integer];
        [FlashLightManager saveAPowerString:str];
    } else if ([self.groupClass isEqualToString:@"B"]) {
        [FlashLightManager saveBPower:integer];
        [FlashLightManager saveBPowerString:str];
    } else if ([self.groupClass isEqualToString:@"C"]) {
        [FlashLightManager saveCPower:integer];
        [FlashLightManager saveCPowerString:str];
    } else {
        [FlashLightManager saveDPower:integer];
        [FlashLightManager saveDPowerString:str];
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

- (void)judgeLaunchButtonStatus {
    if ([self.groupClass isEqualToString:@"A"]) {
        if (FlashLightManager.isLaunchA) {
            [self disableView];
        } else {
            [self enableView];
        }
    } else if ([self.groupClass isEqualToString:@"B"]) {
        if (FlashLightManager.isLaunchB) {
            [self disableView];
        } else {
            [self enableView];
        }
    } else if ([self.groupClass isEqualToString:@"C"]) {
        if (FlashLightManager.isLaunchC) {
            [self disableView];
        } else {
            [self enableView];
        }
    } else {
        if (FlashLightManager.isLaunchD) {
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
            self.detailCell.title.text = @"最小功率";
            self.detailCell.detail.text = @"1/64";
            self.detailCell.bottomLine.hidden = YES;
            return self.detailCell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.detailCell1 = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellId forIndexPath:indexPath];
            self.detailCell1.title.text = @"模式";
            self.detailCell1.detail.text = @"自动";
            return self.detailCell1;
        } else {
            self.detailCell2 = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellId forIndexPath:indexPath];
            self.detailCell2.title.text = @"造型灯";
            self.detailCell2.detail.text = @"PROP";
            self.detailCell2.bottomLine.hidden = YES;
            return self.detailCell2;
        }
    } else if (indexPath.section == 2) {
        self.voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceAndModelLampCellId forIndexPath:indexPath];
        [self.voiceCell updateGroupSettingCell];
        [self.voiceCell.voiceBtn addTarget:self action:@selector(isVoiceOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceCell.modelLampBtn addTarget:self action:@selector(isModelLampOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceCell updateClass:self.groupClass];
        return self.voiceCell;
    } else {
        self.startCell = [tableView dequeueReusableCellWithIdentifier:startCellID forIndexPath:indexPath];
        [self.startCell updateStartCellWithClass:self.groupClass];
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
