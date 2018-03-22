//
//  NSString+Additions.m
//  SCamera
//
//  Created by sunny on 2018/3/22.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+ (NSString *)stringOfFlashLightPower:(NSUInteger)power {
    NSDictionary *dict = @{@(FlashLightPower1_128):@"1/128",@(FlashLightPower1_128_1):@"1/128+0.3",@(FlashLightPower1_128_2):@"1/128+0.7",@(FlashLightPower1_64):@"1/64",@(FlashLightPower1_64_1):@"1/64+0.3",@(FlashLightPower1_64_2):@"1/64+0.7",@(FlashLightPower1_32):@"1/32",@(FlashLightPower1_32_1):@"1/32+0.3",@(FlashLightPower1_32_2):@"1/32+0.7",@(FlashLightPower1_16):@"1/16",@(FlashLightPower1_16_1):@"1/16+0.3",@(FlashLightPower1_16_2):@"1/16+0.7",@(FlashLightPower1_8):@"1/8",@(FlashLightPower1_8_1):@"1/8+0.3",@(FlashLightPower1_8_2):@"1/8+0.7",@(FlashLightPower1_4):@"1/4",@(FlashLightPower1_4_1):@"1/4+0.3",@(FlashLightPower1_4_2):@"1/4+0.7",@(FlashLightPower1_2):@"1/2",@(FlashLightPower1_2_1):@"1/2+0.3",@(FlashLightPower1_2_2):@"1/2+0.7",@(FlashLightPower1):@"1"};
    NSString *str = [dict objectForKey:@(power)];
    return str;
}

+ (NSString *)sringWithFlashLightModel:(NSUInteger)model {
    NSDictionary *dic = @{@(FlashLightModelStandby):@"关闭",@(FlashLightModelAuto):@"自动",@(FlashLightModelManual):@"手动",@(FlashLightModelFlash):@"闪光灯",@(FlashLightModelLED):@"LED"};
    NSString *str = [dic objectForKey:@(model)];
    return str;
}

+ (NSString *)stringWithFlashLightDegree:(NSUInteger)degree {
    NSDictionary *dic = @{@(FlashLightDegreeOFF):@"关闭",@(FlashLightDegreePROP):@"PROP",@(FlashLightDegree20):@"20%",@(FlashLightDegree100):@"100%"};
    NSString *str = [dic objectForKey:@(degree)];
    return str;
}

@end
