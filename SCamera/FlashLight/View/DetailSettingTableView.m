//
//  DetailSettingTableView.m
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "DetailSettingTableView.h"
#import "DetailSettingCustomCell.h"
#import "FlashLightGeneralSettingThirdCell.h"
#import "VoiceAndModelLampCell.h"

static NSString *detailSettingCustomCellID = @"detailSetting_Custom_View_Cell_ID";
static NSString *flashLightGeneralSettingThirdCellID = @"flashLight_generalSetting_View_thirdCell_ID";
static NSString *voiceAndeModelLampCellId = @"voice_ModelLamp_Cell_ID";

@interface DetailSettingTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DetailSettingCustomCell *detailCell;

@property (nonatomic, strong) FlashLightGeneralSettingThirdCell *frenquenceCell;

@property (nonatomic, strong) FlashLightGeneralSettingThirdCell *timesCell;

@property (nonatomic, strong) VoiceAndModelLampCell *voiceCell;

@end

@implementation DetailSettingTableView

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
    
    [self registerClass:[DetailSettingCustomCell class] forCellReuseIdentifier:detailSettingCustomCellID];
    [self registerClass:[FlashLightGeneralSettingThirdCell class] forCellReuseIdentifier:flashLightGeneralSettingThirdCellID];
    [self registerClass:[VoiceAndModelLampCell class] forCellReuseIdentifier:voiceAndeModelLampCellId];
}

#pragma  -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        self.detailCell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
        return self.detailCell;
    } else if (indexPath.row == 1) {
        self.frenquenceCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
        [self.frenquenceCell.redeceButton addTarget:self action:@selector(frenquenceReduceValue) forControlEvents:UIControlEventTouchUpInside];
        [self.frenquenceCell.addButton addTarget:self action:@selector(frenquenceAddValue) forControlEvents:UIControlEventTouchUpInside];
        [self.frenquenceCell.flashLightSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.frenquenceCell updateSliderForFrequence];
        return self.frenquenceCell;
    } else if (indexPath.row == 2) {
        self.timesCell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
        [self.timesCell.redeceButton addTarget:self action:@selector(timesReduceValue) forControlEvents:UIControlEventTouchUpInside];
        [self.timesCell.addButton addTarget:self action:@selector(timesAddValue) forControlEvents:UIControlEventTouchUpInside];
        [self.timesCell.flashLightSlider addTarget:self action:@selector(timesCellSliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.timesCell updateSliderForTimes];
        return self.timesCell;
    } else if (indexPath.row == 3) {
        self.voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceAndeModelLampCellId forIndexPath:indexPath];
        [self.voiceCell.voiceBtn addTarget:self action:@selector(voiceStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceCell.modelLampBtn addTarget:self action:@selector(modelLampStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceCell updateVoiceCell];
        return self.voiceCell;
        
    } else if (indexPath.row == 4) {
        DetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
        cell.title.text = @"导入设置";
        cell.detail.hidden = YES;
        return cell;
    } else if (indexPath.row == 5) {
        DetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
        cell.title.text = @"导出设置";
        cell.detail.hidden = YES;
        cell.bottomLine.hidden = YES;
        return cell;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
    } else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
    } else {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSelectedChannelCellWithDetailText:)]) {
            [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSelectedChannelCellWithDetailText:self.detailCell.detail];
        }
    } else if (indexPath.row == 4) {
        if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSelectedImportSetting)]) {
            [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSelectedImportSetting];
        }
    } else if (indexPath.row == 5) {
        if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSelectedExportSetting)]) {
            [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSelectedExportSetting];
        }
        
    }
}

- (void)frenquenceReduceValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:ClickReduceBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.frenquenceCell.flashLightSlider ClickReduceBtnWithValue:self.frenquenceCell.detail];
    }
}

- (void)timesReduceValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:TimesCellClickReduceBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.timesCell.flashLightSlider TimesCellClickReduceBtnWithValue:self.timesCell.detail];
    }
}

- (void)frenquenceAddValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:ClickIncreaseBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.frenquenceCell.flashLightSlider ClickIncreaseBtnWithValue:self.frenquenceCell.detail];
    }
}

- (void)timesAddValue {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(Slider:TimesCellClickIncreaseBtnWithValue:)]) {
        [self.detailSettingTableViewDelegateDelegate Slider:self.timesCell.flashLightSlider TimesCellClickIncreaseBtnWithValue:self.timesCell.detail];
    }
}

- (void)valueChanged:(UISlider *)silder {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidSliderValueChange:andValueLabel:)]) {
        [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidSliderValueChange:self.frenquenceCell.flashLightSlider andValueLabel:self.frenquenceCell.detail];
    }
}

- (void)timesCellSliderValueChange:(UISlider *)slider {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(DetailSettingTableViewDidTimesCellSliderValueChange:andValueLabel:)]) {
        [self.detailSettingTableViewDelegateDelegate DetailSettingTableViewDidTimesCellSliderValueChange:self.timesCell.flashLightSlider andValueLabel:self.timesCell.detail];
    }
}

- (void)voiceStatus:(UIButton *)btn {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(ClickVoiceButton:)]) {
        [self.detailSettingTableViewDelegateDelegate ClickVoiceButton:btn];
    }
}

- (void)modelLampStatus:(UIButton *)btn {
    
    if (self.detailSettingTableViewDelegateDelegate && [self.detailSettingTableViewDelegateDelegate respondsToSelector:@selector(ClickModelLampButton:)]) {
        [self.detailSettingTableViewDelegateDelegate ClickModelLampButton:btn];
    }
}

@end
