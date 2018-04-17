//
//  SCameraStartCell.h
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCameraStartCell : UITableViewCell

@property (nonatomic, strong) UIButton *startImage;

- (void)updateStartCellWithGroupName:(NSString *)str;

@end