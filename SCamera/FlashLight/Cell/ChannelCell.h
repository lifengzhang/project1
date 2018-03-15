//
//  ChannelCell.h
//  SCamera
//
//  Created by sunny on 2018/3/15.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title;

- (void)updateCellTitle:(NSString *)title;

@end
