//
//  SCameraShutterTableView.m
//  SCamera
//
//  Created by sunny on 2018/2/11.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraShutterTableView.h"
#import "SCameraShutterTableViewCell.h"

#define SCameraShutterTableCell           @"SCameraShutterTableCell"

@interface SCameraShutterTableView ()

@property (nonatomic, strong) NSArray *timeArray;

@end

@implementation SCameraShutterTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24];
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[SCameraShutterTableViewCell class] forCellReuseIdentifier:SCameraShutterTableCell];
        self.timeArray = @[@"1/60",@"1/35",@"1/30",@"1/20",@"1/10"];

    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.timeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCameraShutterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SCameraShutterTableCell forIndexPath:indexPath];
    cell.titleLabel.text = self.timeArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    double value;
    if (indexPath.row == 0) {
        value = 1.0/60.0;
    } else if (indexPath.row == 1) {
        value = 1.0/35.0;
    } else if (indexPath.row == 2) {
        value = 1.0/30.0;
    } else if (indexPath.row == 3) {
        value = 1.0/20.0;
    } else {
        value = 1.0/10.0;
    }
    if (self.scameraShutterTableViewDelegate && [self.scameraShutterTableViewDelegate respondsToSelector:@selector(scameraShutterTableViewDidSelectRowAndSelectedValue:withString:)]) {
        [self.scameraShutterTableViewDelegate scameraShutterTableViewDidSelectRowAndSelectedValue:value withString:self.timeArray[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

@end
