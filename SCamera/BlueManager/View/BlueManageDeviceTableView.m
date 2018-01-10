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

static NSString *bluetoothDeviceTableCellID = @"bluetooth_Device_Table_Cell_ID";

@interface BlueManageDeviceTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<BlueToothDeviceModel *> *blueToothDeviceList;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation BlueManageDeviceTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerClass:[BlueManageDeviceCell class] forCellReuseIdentifier:bluetoothDeviceTableCellID];
    }
    return self;
}

- (void)reloadWithBlueToothDeviceList:(NSArray<BlueToothDeviceModel *> *)blueToothDeviceList selectedIndex:(NSUInteger)selectedIndex {
    
    self.blueToothDeviceList = blueToothDeviceList;
    self.selectedIndex = selectedIndex;
    
    if ([[NSThread currentThread] isMainThread]) {
        [self reloadData];
    } else {
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blueToothDeviceList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BlueManageDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:bluetoothDeviceTableCellID forIndexPath:indexPath];
    [cell updateCellContentWithDeviceModel:self.blueToothDeviceList[indexPath.row] isSelected:indexPath.row == self.selectedIndex];
    [cell.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
