//
//  MyDeviceTableView.m
//  SCamera
//
//  Created by sunny on 2018/2/8.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "MyDeviceTableView.h"
#import "MyDeviceTableViewCell.h"

#define MyDeviceTableCell   @"myDeviceTableCell"

#define HEADER_TITLE_COLOR                                                   \
[UIColor colorWithRed:196 / 255.0 green:196 / 255.0 blue:196 / 255.0 alpha:1.0];

@implementation MyDeviceTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor blackColor];
        [self registerClass:[MyDeviceTableViewCell class] forCellReuseIdentifier:MyDeviceTableCell];

    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyDeviceTableCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"等待连接...";
        cell.lineView.hidden = YES;
    } else {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"捷宝蓝牙设备1";
            cell.lineView.hidden = NO;
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"捷宝蓝牙设备2";
            cell.lineView.hidden = NO;
        } else {
            cell.titleLabel.text = @"捷宝蓝牙设备3";
            cell.lineView.hidden = YES;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(17, 0, tableView.bounds.size.width, 40);
    label.backgroundColor = [UIColor blackColor];
    label.textColor = HEADER_TITLE_COLOR
    label.font = [UIFont ChinaDefaultFontNameOfSize:12.f];
    [headerView addSubview:label];
    
    if (section == 0) {
        label.text = @"已连接设备";
    } else {
        label.text = @"可用设备";
    }
    return headerView;
}

@end
