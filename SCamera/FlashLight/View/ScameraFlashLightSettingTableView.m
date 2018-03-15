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

@property (nonatomic, strong) FlashLightGroupSettingCell *aCell;

@property (nonatomic, strong) FlashLightGroupSettingCell *bCell;

@property (nonatomic, strong) FlashLightGroupSettingCell *cCell;

@property (nonatomic, strong) FlashLightGroupSettingCell *dCell;

@property (nonatomic, strong) NSArray *sortArray;

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
    [self.addCell enableView];
    [self.thirdCell enableView];
    [self.secondCell enableView];
    self.secondCell.userInteractionEnabled = YES;
    if (FlashLightManager.isSelectedStartA) {
        [self.aCell disableView];
        self.aCell.startBtn.enabled = YES;
    } else {
        [self.aCell enableView];
    }
    if (FlashLightManager.isSelectedStartB) {
        [self.bCell disableView];
        self.bCell.startBtn.enabled = YES;
    } else {
        [self.bCell enableView];
    }
    if (FlashLightManager.isSelectedStartC) {
        [self.cCell disableView];
        self.cCell.startBtn.enabled = YES;
    } else {
        [self.cCell enableView];
    }
    if (FlashLightManager.isSelectedStartD) {
        [self.dCell disableView];
        self.dCell.startBtn.enabled = YES;
    } else {
        [self.dCell enableView];
    }
}

- (void)disableView {
    
    [self.generalCell disableView];
    [self.addCell disableView];
    [self.thirdCell disableView];
    [self.secondCell disableView];
    self.secondCell.userInteractionEnabled = NO;
    [self.aCell disableView];
    [self.bCell disableView];
    [self.cCell disableView];
    [self.dCell disableView];
}

- (void)tableViewReloadGroupDate:(NSInteger)integer {
    if (FlashLightManager.mainValue != nil && !self.aCell.startBtn.selected) {
        self.aCell.value.text = FlashLightManager.mainValue;
        [FlashLightManager saveAPowerString:FlashLightManager.mainValue];
        [FlashLightManager saveAPower:integer];
    }
    if (FlashLightManager.mainValue != nil && !self.bCell.startBtn.selected) {
        self.bCell.value.text = FlashLightManager.mainValue;
        [FlashLightManager saveBPowerString:FlashLightManager.mainValue];
        [FlashLightManager saveBPower:integer];
    }
    if (FlashLightManager.mainValue != nil && !self.cCell.startBtn.selected) {
        self.cCell.value.text = FlashLightManager.mainValue;
        [FlashLightManager saveCPowerString:FlashLightManager.mainValue];
        [FlashLightManager saveCPower:integer];
    }
    if (FlashLightManager.mainValue != nil && !self.dCell.startBtn.selected) {
        self.dCell.value.text = FlashLightManager.mainValue;
        [FlashLightManager saveDPowerString:FlashLightManager.mainValue];
        [FlashLightManager saveDPower:integer];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else {
            NSLog(@"%lu",(unsigned long)FlashLightManager.groupArray.count);
            return FlashLightManager.groupArray.count;
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
            [self.thirdCell updateHomePageSlider];
            self.valueLabel = self.thirdCell.valueLabel;
            [self judgeStartButtonStatus];
            return self.thirdCell;
        }
    } else {
        if (FlashLightManager.groupArray.count == 0) {
            return 0;
        }
        NSSortDescriptor *sortDes1 = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
        self.sortArray = [FlashLightManager.groupArray sortedArrayUsingDescriptors:@[sortDes1]];
        if (indexPath.row == 0) {
            return [self updateGroupSettingViewWithstring:self.sortArray[0]];
        } else if (indexPath.row == 1) {
            return [self updateGroupSettingViewWithstring:self.sortArray[1]];
        } else if (indexPath.row == 2) {
            return [self updateGroupSettingViewWithstring:self.sortArray[2]];
        } else {
            return [self updateGroupSettingViewWithstring:self.sortArray[3]];
        }
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
        [self judgeStartButtonStatus];
        return self.addCell;
    } else {
        return 0;
    }
    
}

//分组选择Button改变  数组改变  cell要跟着self.sortArray顺序重新排序
- (UITableViewCell *)updateGroupSettingViewWithstring:(NSString *)str {
    if ([str isEqualToString:@"A"]) {
        self.aCell = [[FlashLightGroupSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flashLightGroupSettingCellID];
        [self loadAcell];
        [self.aCell updateDateWithClass:str];
        [self.aCell.aCell addTarget:self action:@selector(clickACell:) forControlEvents:UIControlEventTouchUpInside];
        [self.aCell.startBtn addTarget:self action:@selector(aStart:) forControlEvents:UIControlEventTouchUpInside];
        return self.aCell;
    } else if ([str isEqualToString:@"B"]) {
         self.bCell = [[FlashLightGroupSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flashLightGroupSettingCellID];
        [self.self.bCell.aCell addTarget:self action:@selector(clickBCell:) forControlEvents:UIControlEventTouchUpInside];
        [self.bCell.startBtn addTarget:self action:@selector(bStart:) forControlEvents:UIControlEventTouchUpInside];
        [self.bCell updateDateWithClass:str];
        [self loadBcell];
        return self.bCell;
    } else if ([str isEqualToString:@"C"]) {
        self.cCell = [[FlashLightGroupSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flashLightGroupSettingCellID];
        [self.cCell.aCell addTarget:self action:@selector(clickCCell:) forControlEvents:UIControlEventTouchUpInside];
        [self.cCell.startBtn addTarget:self action:@selector(cStart:) forControlEvents:UIControlEventTouchUpInside];
        [self loadCcell];
        [self.cCell updateDateWithClass:str];
        return self.cCell;
    } else {
        self.dCell = [[FlashLightGroupSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flashLightGroupSettingCellID];
        [self.dCell.aCell addTarget:self action:@selector(clickDCell:) forControlEvents:UIControlEventTouchUpInside];
        [self.dCell.startBtn addTarget:self action:@selector(dStart:) forControlEvents:UIControlEventTouchUpInside];
        [self loadDcell];
        [self.dCell updateDateWithClass:str];
        return self.dCell;
    }
}

- (void)update{
    
    self.secondCell.frequenceLabel.text = [NSString stringWithFormat:@"频闪 %luHz/%lu次",(unsigned long)(FlashLightManager.flashFrequency > 0 ? FlashLightManager.flashFrequency : 1),(unsigned long)(FlashLightManager.flashNumber > 0 ? FlashLightManager.flashNumber : 1)];
    self.secondCell.voiceLabel.text = FlashLightManager.isSoundOpen ? @"声音 开" : @"声音 关";
    self.secondCell.modelLightLabel.text = FlashLightManager.isPoseOpen ? @"造型灯 开" : @"造型灯 关";
    self.secondCell.channelLabel.text = [NSString stringWithFormat:@"频道 %@",FlashLightManager.channelStr.length > 0 ? FlashLightManager.channelStr : @"频道 1"];
    [self reloadData];
}

- (void)loadAcell {
    self.aCell.startBtn.selected = FlashLightManager.isSelectedStartA;
    [self clickStartA];
    [self judgeStartButtonStatus];
}

- (void)loadBcell {
    self.bCell.startBtn.selected = FlashLightManager.isSelectedStartB;
    [self clickStartB];
    [self judgeStartButtonStatus];
}

- (void)loadCcell {
    self.cCell.startBtn.selected = FlashLightManager.isSelectedStartC;
    [self clickStartC];
    [self judgeStartButtonStatus];
}

- (void)loadDcell {
    self.dCell.startBtn.selected = FlashLightManager.isSelectedStartD;
    [self clickStartD];
    [self judgeStartButtonStatus];
}

- (void)judgeStartButtonStatus {
    if (FlashLightManager.isMainStartSelected) {
        [self disableView];
    } else {
        [self enableView];
    }
}

- (void)clickStartA {
    if (FlashLightManager.isSelectedStartA) {
        [self.aCell disableView];
        self.aCell.startBtn.enabled = YES;
        [self.aCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Start"] forState:UIControlStateNormal];
    } else {
        [self.aCell enableView];
        [self.aCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Stop"] forState:UIControlStateNormal];
    }
}

- (void)clickStartB {
    if (FlashLightManager.isSelectedStartB) {
        [self.bCell disableView];
        self.bCell.startBtn.enabled = YES;
        [self.bCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Start"] forState:UIControlStateNormal];
    } else {
        [self.bCell enableView];
        [self.bCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Stop"] forState:UIControlStateNormal];
    }
}

- (void)clickStartC {
    if (FlashLightManager.isSelectedStartC) {
        [self.cCell disableView];
        self.cCell.startBtn.enabled = YES;
        [self.cCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Start"] forState:UIControlStateNormal];
    } else {
        [self.cCell enableView];
        [self.cCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Stop"] forState:UIControlStateNormal];
    }
}

- (void)clickStartD {
    if (FlashLightManager.isSelectedStartD) {
        [self.dCell disableView];
        self.dCell.startBtn.enabled = YES;
        [self.dCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Start"] forState:UIControlStateNormal];
    } else {
        [self.dCell enableView];
        [self.dCell.startBtn setImage:[UIImage imageNamed:@"FlashLight_Stop"] forState:UIControlStateNormal];
    }
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

- (void)clickACell:(NSString *)str {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(ScameraFlashLightSettingClickGroupSettingCellWithClass:)]) {
        [self.flashLightSettingTableViewDelegate ScameraFlashLightSettingClickGroupSettingCellWithClass:@"A"];
    }
}

- (void)clickBCell:(NSString *)str {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(clickBcellWithClass:)]) {
        [self.flashLightSettingTableViewDelegate clickBcellWithClass:@"B"];
    }
}

- (void)clickCCell:(NSString *)str {
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(clickCcellWithClass:)]) {
        [self.flashLightSettingTableViewDelegate clickCcellWithClass:@"C"];
    }
}

- (void)clickDCell:(NSString *)str {
    
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(clickDcellWithClass:)]) {
        [self.flashLightSettingTableViewDelegate clickDcellWithClass:@"D"];
    }
}

- (void)aStart:(UIButton *)btn {
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(clickStartA:)]) {
        [self.flashLightSettingTableViewDelegate clickStartA:btn];
    }
}

- (void)bStart:(UIButton *)btn {
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(clickStartB:)]) {
        [self.flashLightSettingTableViewDelegate clickStartB:btn];
    }
}

- (void)cStart:(UIButton *)btn {
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(clickStartC:)]) {
        [self.flashLightSettingTableViewDelegate clickStartC:btn];
    }
}

- (void)dStart:(UIButton *)btn {
    if (self.flashLightSettingTableViewDelegate && [self.flashLightSettingTableViewDelegate respondsToSelector:@selector(clickStartD:)]) {
        [self.flashLightSettingTableViewDelegate clickStartD:btn];
    }
}

@end
