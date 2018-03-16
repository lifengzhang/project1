//
//  UIViewController+Additions.m
//  SCamera
//
//  Created by sunny on 2018/3/16.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (void)showAlertViewInDynamicWithTitle:(NSString *)title message:(NSString *)message btnNames:(NSArray *)btnNames clickedCallBack:(void (^)(NSInteger index))callback {
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertViewController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    for (NSString* name  in btnNames)
    {
        NSInteger index = [btnNames indexOfObject:name];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (callback) {
                callback(index);
            }
        }];
        
        [alertViewController addAction:action];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController: alertViewController animated: YES completion: nil];
    });
}
@end
