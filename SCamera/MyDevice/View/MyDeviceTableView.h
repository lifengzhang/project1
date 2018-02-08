//
//  MyDeviceTableView.h
//  SCamera
//
//  Created by sunny on 2018/2/8.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDeviceTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
