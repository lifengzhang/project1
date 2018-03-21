//
//  UIImage+Additions.h
//  SCamera
//
//  Created by sunny on 2018/3/21.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

/*
 *  缩放指定大小的图片
 */
+ (UIImage*)originImage:(UIImage*)image scaleToSize:(CGSize)size;

@end
