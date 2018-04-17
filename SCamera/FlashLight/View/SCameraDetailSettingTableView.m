//
//  DetailSettingTableView.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraDetailSettingTableView.h"
#import "SCameraDetailSettingCustomCell.h"
#import "SCameraFlashLightGeneralSettingThirdCell.h"
#import "SCameraVoiceAndModelLampCell.h"
#import "SCameraFlashLightSection.h"
#import "SCameraSwitchCell.h"

static NSString *detailSettingCustomCellID = @"detailSetting_Custom_View_Cell_ID";
static NSString *flashLightGeneralSettingThirdCellID = @"flashLight_generalSetting_View_thirdCell_ID";
static NSString *voiceAndeModelLampCellId = @"voice_ModelLamp_Cell_ID";
static NSString *flashlightFrequenceSectionID = @"flashlight_frequence_Table_View_Section_Cell_ID";
static NSString *switchCellID = @"switch_Cell_ID";

@interface SCameraDetailSettingTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SCameraDetailSettingCustomCell *detailCell;

@property (nonatomic, strong) SCameraFlashLightGeneralSettingThirdCell *frenquenceCell;

@property (nonatomic, strong) SCameraFlashLightGeneralSettingThirdCell *timesCell;

@property (nonatomic, strong) SCameraVoiceAndModelLampCell *voiceCell;

@property (nonatomic, strong) SCameraFlashLightSection *frequenceSection;

@property (nonatomic, strong) SCameraFlashLightSection *timesSection;

@end

@implementation SCameraDetailSettingTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self registCell];
        self.backgroundColor = Scamera_TableView_BackgroundColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)registCell {
    
    [self registerClass:[SCameraDetailSettingCustomCell class] forCellReuseIdentifier:detailSettingCustomCellID];
    [self registerClass:[SCameraFlashLightGeneralSettingThirdCell class] forCellReuseIdentifier:flashLightGeneralSettingThirdCellID];
    [self registerClass:[SCameraVoiceAndModelLampCell class] forCellReuseIdentifier:voiceAndeModelLampCellId];
    [self registerClass:[SCameraFlashLightSection class] forHeaderFooterViewReuseIdentifier:flashlightFrequenceSectionID];
    [self registerClass:[SCameraSwitchCell class] forCellReuseIdentifier:switchCellID];
}

#pragma  -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 3) {
        return 4;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.detailCell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
        [self.detailCell updateChannelCell];
        self.detailCell.backgroundColor = [UIColor whiteColor];
        self.detailCell.bottomLine.backgroundColor = Scamera_Line_white;
        return self.detailCell;
    } else if (indexPath.section == 1) {
        self.frenquenceCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
        [self.frenquenceCell.redeceButton addTarget:self action:@selector(frenquenceReduceValue) forControlEvents:UIControlEventTouchUpInside];
        [self.frenquenceCell.addButton addTarget:self action:@selector(frenquenceAddValue) forControlEvents:UIControlEventTouchUpInside];
        [self.frenquenceCell.flashLightSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.frenquenceCell updateSliderForFrequence];
        return self.frenquenceCell;
    } else if (indexPath.section == 2) {
        self.timesCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
        [self.timesCell.redeceButton addTarget:self action:@selector(timesReduceValue) forControlEvents:UIControlEventTouchUpInside];
        [self.timesCell.addButton addTarget:self action:@selector(timesAddValue) forControlEvents:UIControlEventTouchUpInside];
        [self.timesCell.flashLightSlider addTarget:self action:@selector(timesCellSliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.timesCell updateSliderForTimes];
        return self.timesCell;
    } else {
        if (indexPath.row == 0) {
            SCameraSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellID forIndexPath:indexPath];
            cell.title.text = @"声音";
            [cell.power addTarget:self action:@selector(voiceStatus:) forControlEvents:UIControlEventValueChanged];
            [cell updateVoiceCell];
            return cell;
        } else if (indexPath.row == 1) {
            SCameraSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellID forIndexPath:indexPath];
            cell.title.text = @"造型灯";
            [cell.power addTarget:self action:@selector(modelLampStatus:) forControlEvents:UIControlEventValueChanged];
            [cell updateLampCell];
            return cell;
        } else if (indexPath.row == 2) {
            SCameraDetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
            cell.title.text = @"导入设置";
            cell.detail.hidden = YES;
            [cell updateImportCell];
            return cell;
        } else {
            SCameraDetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
            cell.title.text = @"导出设置";
            cell.detail.hidden = YES;
            cell.bottomLine.hidden = NO;
            [cell updateExportCell];
            return cell;
        }
    }
    return 0;
//    if (indexPath.row == 0) {
//        self.detailCell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
//        [self.detailCell updateChannelCell];
//        return self.detailCell;
//    } else if (indexPath.row == 1) {
//        self.frenquenceCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
//        [self.frenquenceCell.redeceButton addTarget:self action:@selector(frenquenceReduceValue) forControlEvents:UIControlEventTouchUpInside];
//        [self.frenquenceCell.addButton addTarget:self action:@selector(frenquenceAddValue) forControlEvents:UIControlEventTouchUpInside];
//        [self.frenquenceCell.flashLightSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
//        [self.frenquenceCell updateSliderForFrequence];
//        return self.frenquenceCell;
//    } else if (indexPath.row == 2) {
//        self.timesCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
//        [self.timesCell.redeceButton addTarget:self action:@selector(timesReduceValue) forControlEvents:UIControlEventTouchUpInside];
//        [self.timesCell.addButton addTarget:self action:@selector(timesAddValue) forControlEvents:UIControlEventTouchUpInside];
//        [self.timesCell.flashLightSlider addTarget:self action:@selector(timesCellSliderValueChange:) forControlEvents:UIControlEventValueChanged];
//        [self.timesCell updateSliderForTimes];
//        return self.timesCell;
//    } else if (indexPath.row == 3) {
//        self.voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceAndeModelLampCellId forIndexPath:indexPath];
//        [self.voiceCell.voiceBtn addTarget:self action:@selector(voiceStatus:) forControlEvents:UIControlEventTouchUpInside];
//        [self.voiceCell.modelLampBtn addTarget:self action:@selector(modelLampStatus:) forControlEvents:UIControlEventTouchUpInside];
//        [self.voiceCell updateVoiceCell];
//        return self.voiceCell;
//
//    } else if (indexPath.row == 4) {
//        SCameraDetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
//        cell.title.text = @"导入设置";
//        cell.detail.hidden = YES;
//        return cell;
//    } else if (indexPath.row == 5) {
//        SCameraDetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
//        cell.title.text = @"导出设置";
//        cell.detail.hidden = YES;
//        cell.bottomLine.hidden = YES;
//        return cell;
//    }
//    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
//    } else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
//        return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
//    } else {
//        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
//    }
//    return 0;
    return [SCameraDevice screenAdaptiveSizeWithIp6Size:44.f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    
    if (section == 0) {
        return 0.00001;
    } else {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:32.f];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        self.frequenceSection = [tableView dequeueReusableHeaderFooterViewWithIdentifier:flashlightFrequenceSectionID];
        self.frequenceSection.title.text = @"频闪频率";
        self.frequenceSection.detail.text = @"1";
        if (FlashLightManager.flashFrequency && FlashLightManager.flashFrequency > 0) {
            self.frequenceSection.detail.text = [NSString stringWithFormat:@"%lu",(unsigned long)FlashLightManager.flashFrequency];
        }
        return self.frequenceSection;
    } else if (section == 2) {
        self.timesSection = [tableView dequeueReusableHeaderFooterViewWithIdentifier:flashlightFrequenceSectionID];
        self.timesSection.title.text = @"频闪次数";
        self.timesSection.detail.text = @"1";
        if (FlashLightManager.flashNumber && FlashLightManager.flashNumber > 0) {
            self.timesSection.detail.text = [NSString stringWithFormat:@"%lu",(unsigned long)FlashLightManager.flashNumber];
        }
        return self.timesSection;
    } else {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = Scamera_TableView_BackgroundColor;
        return header;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSelectedChannelCellWithDetailText:)]) {
            [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSelectedChannelCellWithDetailText:self.detailCell.detail];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 2) {
            if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSelectedImportSetting)]) {
                [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSelectedImportSetting];
            }
        } else if (indexPath.row == 3) {
            if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSelectedExportSetting)]) {
                [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSelectedExportSetting];
            }
        }
    }
}

- (void)frenquenceReduceValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:ClickReduceBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.frenquenceCell.flashLightSlider ClickReduceBtnWithValue:self.frequenceSection.detail];
    }
}

- (void)timesReduceValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:TimesCellClickReduceBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.timesCell.flashLightSlider TimesCellClickReduceBtnWithValue:self.timesSection.detail];
    }
}

- (void)frenquenceAddValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:ClickIncreaseBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.frenquenceCell.flashLightSlider ClickIncreaseBtnWithValue:self.frequenceSection.detail];
    }
}

- (void)timesAddValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:TimesCellClickIncreaseBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.timesCell.flashLightSlider TimesCellClickIncreaseBtnWithValue:self.timesSection.detail];
    }
}

- (void)valueChanged:(UISlider *)silder {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSliderValueChange:andValueLabel:)]) {
        [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSliderValueChange:self.frenquenceCell.flashLightSlider andValueLabel:self.frequenceSection.detail];
    }
}

- (void)timesCellSliderValueChange:(UISlider *)slider {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidTimesCellSliderValueChange:andValueLabel:)]) {
        [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidTimesCellSliderValueChange:self.timesCell.flashLightSlider andValueLabel:self.timesSection.detail];
    }
}

- (void)voiceStatus:(id)sender {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(ClickVoiceButton:)]) {
        [self.detailSettingTableViewDelegateDelegate ClickVoiceButton:sender];
    }
}

- (void)modelLampStatus:(id)sender {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(ClickModelLampButton:)]) {
        [self.detailSettingTableViewDelegateDelegate ClickModelLampButton:sender];
    }
}

@end
