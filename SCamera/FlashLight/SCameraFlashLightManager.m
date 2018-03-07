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

@end
