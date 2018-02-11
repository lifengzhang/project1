//
//  SCameraShutterTableView.h
//  SCamera
//
//  Created by sunny on 2018/2/11.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCameraShutterTableViewDelegage <NSObject>

- (void)scameraShutterTableViewDidSelectRowAndSelectedValue:(double)value withString:(NSString *)timeStr;

@end

@interface SCameraShutterTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <SCameraShutterTableViewDelegage> scameraShutterTableViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
