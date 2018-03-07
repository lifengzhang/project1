//
//  DetailSettingViewController.h
//  SCamera
//
//  Created by sunny on 2018/3/3.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DetailSettingViewBlockFixedParameter)(NSArray *fixedParameter);

@interface DetailSettingViewController : UIViewController

@property (nonatomic, copy) DetailSettingViewBlockFixedParameter blockparameter;

@end
