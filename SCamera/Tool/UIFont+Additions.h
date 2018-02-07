//
//  UIFont+Additions.h
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChinaDefaultFontName      @"PingFangSC-Regular"
#define ChinaLightFontName        @"PingFangSC-Light"

@interface UIFont (Additions)

/**
 *  专门给中文用的字体
 */
+ (UIFont *)ChinaDefaultFontNameOfSize:(CGFloat)fontSize;

@end
