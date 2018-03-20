//
//  GroupSelectTableView.h
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupSelectTableViewDelegate <NSObject>

- (void)clickAGroup:(UIButton *)btn;

- (void)clickBGroup:(UIButton *)btn;

- (void)clickCGroup:(UIButton *)btn;

- (void)clickDGroup:(UIButton *)btn;

@end

@interface SCameraGroupSelectTableView : UITableView

@property (nonatomic, weak) id<GroupSelectTableViewDelegate> groupSelectTableViewDelegate;

- (void)aButtonSelect:(BOOL)selected;

- (void)bButtonSelect:(BOOL)selected;

- (void)cButtonSelect:(BOOL)selected;

- (void)dButtonSelect:(BOOL)selected;

@end
