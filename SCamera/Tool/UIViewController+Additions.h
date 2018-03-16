//
//  UIViewController+Additions.h
//  SCamera
//
//  Created by sunny on 2018/3/16.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

- (void)showAlertViewInDynamicWithTitle:(NSString *)title message:(NSString *)message btnNames:(NSArray *)btnNames clickedCallBack:(void (^)(NSInteger index))callback;

@end
