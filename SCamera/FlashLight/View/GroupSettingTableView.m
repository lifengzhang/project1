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
#import "StartCell.h"

static NSString *fashLightGeneralSettingThirdCellId = @"flashLight_general_cell_ID";
static NSString *detailSettingCustomCellId = @"detailSetting_custom_cell_ID";
static NSString *voiceAndModelLampCellId = @"voice_modelLamp_cell_ID";
static NSString *blueManagerTableViewSectionID = @"blueManager_TableView_Section_ID";
static NSString *startCellID = @"start_Cell_ID";


@interface GroupSettingTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FlashLightGeneralSettingThirdCell *flashCell;

@property (nonatomic, strong) DetailSettingCustomCell *detailCell;

@property (nonatomic ,strong) VoiceAndModelLampCell *voiceCell;

@property (nonatomic, strong) StartCell *startCell;

@end

@implementation GroupSettingTableView

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
    
    [self registerClass:[FlashLightGeneralSettingThirdCell class] forCellReuseIdentifier:fashLightGeneralSettingThirdCellId];
    [self registerClass:[DetailSettingCustomCell class] forCellReuseIdentifier:detailSettingCustomCellId];
    [self registerClass:[VoiceAndModelLampCell class] forCellReuseIdentifier:voiceAndModelLampCellId];
    [self registerClass:[BlueManagerTableViewSection class] forHeaderFooterViewReuseIdentifier:blueManagerTableViewSectionID];
    [self registerClass:[StartCell class] forCellReuseIdentifier:startCellID];
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
            [self.flashCell updateGroupSettingSlider];
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
            self.detailCell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellId forIndexPath:indexPath];
            self.detailCell.title.text = @"模式";
            self.detailCell.detail.text = @"自动";
            return self.detailCell;
        } else {
            self.detailCell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellId forIndexPath:indexPath];
            self.detailCell.title.text = @"造型灯";
            self.detailCell.detail.text = @"PROP";
            self.detailCell.bottomLine.hidden = YES;
            return self.detailCell;
        }
        
    } else if (indexPath.section == 2) {
        
        self.voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceAndModelLampCellId forIndexPath:indexPath];
        self.voiceCell.voiceLabel.text = @"声音";
        self.voiceCell.modelLabel.text = @"闪频";
        self.voiceCell.bottomLine.hidden = YES;
        [self.voiceCell.voiceBtn setImage:[UIImage imageNamed:@"FlashLight_Voice_Close"] forState:UIControlStateNormal];
        [self.voiceCell.voiceBtn setImage:[UIImage imageNamed:@"FlashLight_Voice_Open"] forState:UIControlStateSelected];
        [self.voiceCell.modelLampBtn setImage:[UIImage imageNamed:@"FlashLight_Close"] forState:UIControlStateNormal];
        [self.voiceCell.modelLampBtn setImage:[UIImage imageNamed:@"FlashLight_Open"] forState:UIControlStateSelected];
        return self.voiceCell;
    } else {
        self.startCell = [tableView dequeueReusableCellWithIdentifier:startCellID forIndexPath:indexPath];
        return self.startCell;
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

@end
