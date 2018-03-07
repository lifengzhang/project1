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

- (NSUInteger)flashNumber {
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightTimes];

}

- (NSUInteger)flashFrequency {
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightFrequence];

}

- (NSString *)flashPower {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightFlashPower];
    
}

- (FlashLightPower)aPower {
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:FlashLightApower];
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

- (void)saveFlashPower:(NSString *)flashPower {
    
    if (flashPower && flashPower.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:flashPower forKey:FlashLightFlashPower];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"1/128" forKey:FlashLightFlashPower];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
