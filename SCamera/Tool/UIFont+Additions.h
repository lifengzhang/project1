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
#define ChinaBoldFontName         @"PingFangSC-Bold"
#define ChinaMediumFontName       @"PingFangSC-Medium"


@interface UIFont (Additions)

/**
 *  专门给中文用的字体
 */
+ (UIFont *)ChinaDefaultFontNameOfSize:(CGFloat)fontSize;

//加粗字体
+ (UIFont *)ChinaBoldFontNameOfSize:(CGFloat)fontSize;

//中等字体
+ (UIFont *)ChinaMediumFontNameOfSize:(CGFloat)fontSize;

@end
