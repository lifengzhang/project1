//
//  GroupSelectTableView.m
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "GroupSelectTableView.h"
#import "GroupSelectCell.h"

static NSString *groupSelectCellId = @"group_select_Cell_ID";

@interface GroupSelectTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GroupSelectCell *groupSelectCell;

@end

@implementation GroupSelectTableView

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
    
    [self registerClass:[GroupSelectCell class] forCellReuseIdentifier:groupSelectCellId];
}

- (void)aButtonSelect:(BOOL)selected {
    if (selected) {
        self.groupSelectCell.aImage.image = [UIImage imageNamed:@"button_select_yes"];
    } else {
        self.groupSelectCell.aImage.image = [UIImage imageNamed:@"button_select_no"];
    }
}

- (void)bButtonSelect:(BOOL)selected {
    if (selected) {
        self.groupSelectCell.bImage.image = [UIImage imageNamed:@"button_select_yes"];
    } else {
        self.groupSelectCell.bImage.image = [UIImage imageNamed:@"button_select_no"];
    }
}

- (void)cButtonSelect:(BOOL)selected {
    if (selected) {
        self.groupSelectCell.cImage.image = [UIImage imageNamed:@"button_select_yes"];
    } else {
        self.groupSelectCell.cImage.image = [UIImage imageNamed:@"button_select_no"];
    }
}

- (void)dButtonSelect:(BOOL)selected {
    if (selected) {
        self.groupSelectCell.dImage.image = [UIImage imageNamed:@"button_select_yes"];
    } else {
        self.groupSelectCell.dImage.image = [UIImage imageNamed:@"button_select_no"];
    }
}

#pragma  -mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.groupSelectCell = [tableView dequeueReusableCellWithIdentifier:groupSelectCellId forIndexPath:indexPath];
    [self.groupSelectCell.aButton addTarget:self action:@selector(aButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.groupSelectCell.bButton addTarget:self action:@selector(bButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.groupSelectCell.cButton addTarget:self action:@selector(cButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.groupSelectCell.dButton addTarget:self action:@selector(dButton:) forControlEvents:UIControlEventTouchUpInside];
    return self.groupSelectCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [SCameraDevice screenAdaptiveSizeWithIp6Size:106.f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 12.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)aButton:(UIButton *)btn {
    if (self.groupSelectTableViewDelegate && [self.groupSelectTableViewDelegate respondsToSelector:@selector(clickAGroup:)]) {
        [self.groupSelectTableViewDelegate clickAGroup:btn];
    }
    
}

- (void)bButton:(UIButton *)btn {
    
    if (self.groupSelectTableViewDelegate && [self.groupSelectTableViewDelegate respondsToSelector:@selector(clickBGroup:)]) {
        [self.groupSelectTableViewDelegate clickBGroup:btn];
    }
}

- (void)cButton:(UIButton *)btn {
    
    if (self.groupSelectTableViewDelegate && [self.groupSelectTableViewDelegate respondsToSelector:@selector(clickCGroup:)]) {
        [self.groupSelectTableViewDelegate clickCGroup:btn];
    }
}

- (void)dButton:(UIButton *)btn {
    
    if (self.groupSelectTableViewDelegate && [self.groupSelectTableViewDelegate respondsToSelector:@selector(clickDGroup:)]) {
        [self.groupSelectTableViewDelegate clickDGroup:btn];
    }
}

@end
