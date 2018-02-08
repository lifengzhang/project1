//
//  UIFont+Additions.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)ChinaDefaultFontNameOfSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:ChinaDefaultFontName size:fontSize];
    
}

+ (UIFont *)ChinaBoldFontNameOfSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:ChinaBoldFontName size:fontSize];
}

@end
