//
//  NSString+Additions.h
//  SCamera
//
//  Created by sunny on 2018/3/22.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

//FlashLightPower 转换成显示的UI
+ (NSString *)stringOfFlashLightPower:(NSUInteger)power;

//FlashLightModel 转换成显示的UI
+ (NSString *)sringWithFlashLightModel:(NSUInteger)model;

//FlashLightDegree 转换成显示的UI
+ (NSString *)stringWithFlashLightDegree:(NSUInteger)degree;

@end
