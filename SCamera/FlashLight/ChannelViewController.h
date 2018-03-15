//
//  ChannelViewController.h
//  SCamera
//
//  Created by sunny on 2018/3/15.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChannelViewControllerBlock)(void);

@interface ChannelViewController : UIViewController

@property (nonatomic, copy) ChannelViewControllerBlock blockparameter;

- (instancetype)initWithClass:(NSString *)str;

@end
