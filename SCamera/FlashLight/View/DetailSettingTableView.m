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
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        DetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 1) {
        FlashLightGeneralSettingThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:flashLightGeneralSettingThirdCellID forIndexPath:indexPath];
        cell.bottomLine.hidden = NO;
        cell.valueLabel.hidden = YES;
        cell.title.text = @"频闪频率";
        cell.detail.text = @"24";
        cell.minLabel.text = @"1/128";
        cell.maxLabel.text = @"1/4";
        return cell;
    } else if (indexPath.row == 2) {
        VoiceAndModelLampCell *cell = [tableView dequeueReusableCellWithIdentifier:voiceAndeModelLampCellId forIndexPath:indexPath];
        return cell;
        
    } else if (indexPath.row == 3) {
        DetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
        cell.title.text = @"导入设置";
        cell.detail.hidden = YES;
        return cell;
    } else if (indexPath.row == 4) {
        DetailSettingCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSettingCustomCellID forIndexPath:indexPath];
        cell.title.text = @"导出设置";
        cell.detail.hidden = YES;
        return cell;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
    } else if (indexPath.row == 1) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
    } else if (indexPath.row == 2) {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:83.f];
    } else {
        return [SCameraDevice screenAdaptiveSizeWithIp6Size:53.f];
    }
    return 0;
}

@end
