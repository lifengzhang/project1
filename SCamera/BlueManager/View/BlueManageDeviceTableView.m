//
//  BlueManageDeviceTableView.m
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/27.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import "BlueManageDeviceTableView.h"
#import "BlueToothDeviceModel.h"
#import "BlueManageDeviceCell.h"
#import "BlueNoDeviceCell.h"
#import "BlueManagerTableViewSection.h"

static NSString *blueManagerTableViewSectionID = @"blue_Manager_Table_View_Section_Cell_ID";

static NSString *bluetoothDeviceTableCellID = @"bluetooth_Device_Table_Cell_ID";

static NSString *blueNoDeviceCellID = @"bluetooth_NO_Device_Table_Cell_ID";

@interface BlueManageDeviceTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<BlueToothDeviceModel *> *blueToothDeviceList;

@property (nonatomic, strong) BlueToothDeviceModel *connectBlueToothDevice;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation BlueManageDeviceTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor blackColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerClass:[BlueManagerTableViewSection class] forHeaderFooterViewReuseIdentifier:blueManagerTableViewSectionID];
        
        [self registerClass:[BlueManageDeviceCell class] forCellReuseIdentifier:bluetoothDeviceTableCellID];
        [self registerClass:[BlueNoDeviceCell class] forCellReuseIdentifier:blueNoDeviceCellID];
        
        
    }
    return self;
}

- (void)reloadWithBlueToothDeviceList:(NSArray<BlueToothDeviceModel *> *)blueToothDeviceList connectBlueToothDevice:(BlueToothDeviceModel *)connectBlueToothDevice {
    
    self.blueToothDeviceList = blueToothDeviceList;
    self.connectBlueToothDevice = connectBlueToothDevice;
    
    if ([[NSThread currentThread] isMainThread]) {
        [self reloadData];
    } else {
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.blueToothDeviceList.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    
    return 40.f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        BlueManagerTableViewSection *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:blueManagerTableViewSectionID];
        //        header.contentView.backgroundColor = [UIColor whiteColor];
        header.headerSectionTitleLabel.text = @"已连接设备";
        return header;
    } else {
        BlueManagerTableViewSection *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:blueManagerTableViewSectionID];
        //        header.contentView.backgroundColor = [UIColor whiteColor];
        header.headerSectionTitleLabel.text = @"可用设备";
        return header;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (self.connectBlueToothDevice == nil) {
            BlueNoDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:blueNoDeviceCellID forIndexPath:indexPath];
            return cell;
        } else {
            BlueManageDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:bluetoothDeviceTableCellID forIndexPath:indexPath];
            [cell updateCellContentWithDeviceModel:self.connectBlueToothDevice isSelected:indexPath.row == self.selectedIndex];
            return cell;
        }
        
    } else {
       
        BlueManageDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:bluetoothDeviceTableCellID forIndexPath:indexPath];
        [cell updateCellContentWithDeviceModel:self.blueToothDeviceList[indexPath.row] isSelected:indexPath.row == self.selectedIndex];
        [cell.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    
}

- (void)selectButtonClicked:(UIButton *)button {
    UITableViewCell *cell = (UITableViewCell *)[button superview];
    NSIndexPath *indexPath = [self indexPathForCell:cell];
//    if (self.manageDeviceTableDelegate && [self.manageDeviceTableDelegate respondsToSelector:@selector(easyPosManageDeviceTableView:selectButtonClickedAtIndexPath:)]) {
//        [self.manageDeviceTableDelegate easyPosManageDeviceTableView:self selectButtonClickedAtIndexPath:indexPath];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.manageDeviceTableDelegate && [self.manageDeviceTableDelegate respondsToSelector:@selector(blueManageDeviceTableView:selectButtonClickedAtIndexPath:)]) {
        [self.manageDeviceTableDelegate blueManageDeviceTableView:self selectButtonClickedAtIndexPath:indexPath];
    }
}


@end
