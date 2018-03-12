//
//  GroupSettingController.h
//  SCamera
//
//  Created by sunny on 2018/3/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GroupSettingBlock)(NSString *str);

@interface GroupSettingController : UIViewController

- (instancetype)initWithClass:(NSString *)str;

@property (nonatomic, copy) GroupSettingBlock groupSettingBlock;

@end
