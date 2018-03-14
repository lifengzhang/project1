//
//  SCameraFlashLightManager.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/23.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraFlashLightManager.h"

@implementation SCameraFlashLightManager

static SCameraFlashLightManager *sharedInstance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[SCameraFlashLightManager alloc] init];
        
    });
    return sharedInstance;
}



- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.isSoundOpen = NO;
        self.isPoseOpen = NO;
        self.channel = 0x01;
        self.aModel = FlashLightModelManual;
        self.bModel = FlashLightModelStandby;
        self.cModel = FlashLightModelStandby;
        self.dModel = FlashLightModelStandby;
        self.aPower = FlashLightPowerStandby;
        self.bPower = FlashLightPowerStandby;
        self.cPower = FlashLightPowerStandby;
        self.dPower = FlashLightPowerStandby;
        self.flashNumber = 1;
        self.flashFrequency = 60;
        self.groupArray = [NSMutableArray array];
    }
    
    return self;
    
}

- (Byte)getByte1 {

    Byte reg = 0x00;
    if (self.isSoundOpen) {
        reg = reg | (0x1 << 7);
    }
    
    if (self.isPoseOpen) {
        reg = reg | (0x1 << 6);
    }
    
    if (self.channel) {
        reg = reg | self.channel;
    }
    
    return reg;
    
}

- (Byte)getByte2 {
    
    Byte reg = 0x00;
    if (self.aModel) {
        reg = reg | self.aModel;
    }
    
    if (self.aLightDegree) {
        reg = reg | self.aLightDegree;
    }
    return reg;
    
}

- (Byte)getByte3 {
    
    Byte reg = 0x00;
    if (self.bModel) {
        reg = reg | self.bModel;
    }
    
    if (self.bLightDegree) {
        reg = reg | self.bLightDegree;
    }
    
    return reg;
    
}


- (Byte)getByte4 {
    
    Byte reg = 0x00;
    if (self.cModel) {
        reg = reg | self.cModel;
    }
    
    if (self.cLightDegree) {
        reg = reg | self.cLightDegree;
    }
    
    return reg;
    
}


- (Byte)getByte5 {
    
    Byte reg = 0x00;
    if (self.dModel) {
        reg = reg | self.dModel;
    }
    
    if (self.dLightDegree) {
        reg = reg | self.dLightDegree;
    }
    
    return reg;
    
}

- (Byte)getByte10 {
    
    Byte reg = 0x00;
    if (self.flashNumber) {
        reg = reg | self.flashNumber;
    }
    
    return reg;
    
}

- (Byte)getByte11 {
    
    Byte reg = 0x00;
    if (self.flashFrequency) {
        reg = reg | self.flashFrequency;
    }
    
    return reg;
    
}


- (NSData *)getSettingBytes {
    
    Byte reg[14];
    reg[0]=0xbe;
    reg[1]=[self getByte1];
    reg[2]=[self getByte2];
    reg[3]=[self getByte3];
    reg[4]=[self getByte4];
    reg[5]=[self getByte5];
    reg[6]=self.aPower;
    reg[7]=self.bPower;
    reg[8]=self.cPower;
    reg[9]=self.dPower;
    reg[10]=[self getByte10];
    reg[11]=[self getByte11];
    reg[12]=0xff;
    reg[13]=0xef;
    //    reg[8]=(Byte)(reg[0]^reg[1]^reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]);
    return [NSData dataWithBytes:reg length:14];
    
}

#pragma - mark Property get method
- (BOOL)isPoseOpen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FlashLightIsPoseOpen];
}

- (BOOL)isSoundOpen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FlashLightIsSoundOpen];
}

- (BOOL)isSelectedA {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedA];
}

- (BOOL)isSelectedB {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedB];
}

- (BOOL)isSelectedC {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedC];
}

- (BOOL)isSelectedD {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedD];
}

- (BOOL)isSelectedStartA {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedStartA];
}

- (BOOL)isSelectedStartB {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedStartB];
}

- (BOOL)isSelectedStartC {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedStartC];
}

- (BOOL)isSelectedStartD {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsSelectedStartD];
}

- (BOOL)isMainStartSelected {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsMainStartSelected];
}

- (NSUInteger)flashNumber {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightTimes];
}

- (NSUInteger)flashFrequency {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightFrequence];
}

- (FlashLightPower)aPower {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightApower];
}

- (FlashLightPower)bPower {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightBpower];
}

- (FlashLightPower)cPower {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightCpower];
}

- (FlashLightPower)dPower {
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightDpower];
}

- (NSString *)aPowerStr {
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightApowerString];
}

- (NSString *)bPowerStr {
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightBpowerString];
}

- (NSString *)cPowerStr {
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightCpowerString];
}

- (NSString *)dPowerStr {
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightDpowerString];
}

- (NSMutableArray *)groupArray {
    return [[NSUserDefaults standardUserDefaults] objectForKey:GroupArray];

}

- (NSString *)mainValue {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MainValue];
}

#pragma -mark 组别Controller数据
- (BOOL)isVoiceOpenA {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsVoiceOpenA];
}

- (BOOL)isVoiceOpenB {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsVoiceOpenB];
}

- (BOOL)isVoiceOpenC {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsVoiceOpenC];
}

- (BOOL)isVoiceOpenD {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsVoiceOpenD];
}

- (BOOL)isFlashFrequenceOpenA {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsFlashFrequenceOpneA];
}

- (BOOL)isFlashFrequenceOpenB {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsFlashFrequenceOpneB];
}

- (BOOL)isFlashFrequenceOpenC {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsFlashFrequenceOpneC];
}

- (BOOL)isFlashFrequenceOpenD {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsFlashFrequenceOpneD];
}

- (BOOL)isLaunchA {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsLaunchA];
}

- (BOOL)isLaunchB {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsLaunchB];
}

- (BOOL)isLaunchC {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsLaunchC];
}

- (BOOL)isLaunchD {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsLaunchD];
}

- (void)saveIsVoiceOpenA:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsVoiceOpenA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsVoiceOpenB:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsVoiceOpenB];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsVoiceOpenC:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsVoiceOpenC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsVoiceOpenD:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsVoiceOpenD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsFlashFrequenceOpneA:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsFlashFrequenceOpneA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsFlashFrequenceOpneB:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsFlashFrequenceOpneB];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)saveIsFlashFrequenceOpneC:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsFlashFrequenceOpneC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)saveIsFlashFrequenceOpneD:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsFlashFrequenceOpneD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveLaunchA:(BOOL)isLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:isLaunch forKey:IsLaunchA];
}

- (void)saveLaunchB:(BOOL)isLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:isLaunch forKey:IsLaunchB];
}

- (void)saveLaunchC:(BOOL)isLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:isLaunch forKey:IsLaunchC];
}

- (void)saveLaunchD:(BOOL)isLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:isLaunch forKey:IsLaunchD];
}

#pragma - mark 属性持久化
- (void)saveAPower:(FlashLightPower)aPower {
    
    if (aPower > 0) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:aPower forKey:FlashLightApower];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:FlashLightPower1_128 forKey:FlashLightApower];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)saveBPower:(FlashLightPower)bPower {
    [[NSUserDefaults standardUserDefaults] setInteger:bPower forKey:FlashLightBpower];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveCPower:(FlashLightPower)cPower {
    [[NSUserDefaults standardUserDefaults] setInteger:cPower forKey:FlashLightCpower];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveDPower:(FlashLightPower)dPower {
    [[NSUserDefaults standardUserDefaults] setInteger:dPower forKey:FlashLightDpower];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveAPowerString:(NSString *)str {
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:FlashLightApowerString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveBPowerString:(NSString *)str {
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:FlashLightBpowerString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveCPowerString:(NSString *)str {
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:FlashLightCpowerString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveDPowerString:(NSString *)str {
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:FlashLightDpowerString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveChannel:(NSInteger)channel {
    
    if (channel > 0) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:channel forKey:FlashLightChannel];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger: 1 forKey:FlashLightChannel];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)saveIsPoseOpen:(BOOL)isPoseOpen {
    
    [[NSUserDefaults standardUserDefaults] setBool:isPoseOpen forKey:FlashLightIsPoseOpen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)saveIsSoundOpen:(BOOL)isSoundOpen {
    
    [[NSUserDefaults standardUserDefaults] setBool:isSoundOpen forKey:FlashLightIsSoundOpen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)saveIsSelectedA:(BOOL)isSelectedA {
    [[NSUserDefaults standardUserDefaults] setBool:isSelectedA forKey:IsSelectedA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsSelectedB:(BOOL)isSelectedB {
    [[NSUserDefaults standardUserDefaults] setBool:isSelectedB forKey:IsSelectedB];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsSelectedC:(BOOL)isSelectedC {
    [[NSUserDefaults standardUserDefaults] setBool:isSelectedC forKey:IsSelectedC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveIsSelectedD:(BOOL)isSelectedD {
    [[NSUserDefaults standardUserDefaults] setBool:isSelectedD forKey:IsSelectedD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveStartAIsSelected:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsSelectedStartA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveStartBIsSelected:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsSelectedStartB];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveStartCIsSelected:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsSelectedStartC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveStartDIsSelected:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsSelectedStartD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveMainStartSelected:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:IsMainStartSelected];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveFrequence:(NSInteger)frequence {
    
    if (frequence > 0) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:frequence forKey:FlashLightFrequence];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:FlashLightFrequence];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)saveTimes:(NSInteger)times {
    
    if (times > 0) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:times forKey:FlashLightTimes];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:FlashLightTimes];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)saveGroupArray:(NSString *)str {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.groupArray];
    [array addObject:str];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:GroupArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveMainValue:(NSString *)str {
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:MainValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeGroupString:(NSString *)str {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.groupArray];
    if (array.count == 0) {
        return;
    } else {
        for (int i = 0; i <array.count; i++) {
            if ([array[i] isEqualToString:str]) {
                [array removeObject:array[i]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:GroupArray];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
