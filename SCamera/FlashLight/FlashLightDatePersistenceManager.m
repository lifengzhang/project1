//
//  FlashLightDatePersistenceManager.m
//  SCamera
//
//  Created by sunny on 2018/3/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "FlashLightDatePersistenceManager.h"

@implementation FlashLightDatePersistenceManager

static FlashLightDatePersistenceManager *sharedInstance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[FlashLightDatePersistenceManager alloc] init];
        
    });
    return sharedInstance;
}

- (NSString *)channel {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightChannel];
}

- (NSString *)times {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightTimes];
}

- (BOOL)isSoundOpen {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:FlashLightIsSoundOpen];
}

- (BOOL)isPoseOpen {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:FlashLightIsPoseOpen];

}

- (NSString *)frequence {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightFrequence];

}

- (NSString *)flashPower {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:FlashLightFlashPower];

}

- (void)saveChannel:(NSString *)channel {
    
    if (channel && channel.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:channel forKey:FlashLightChannel];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"频道 1" forKey:FlashLightChannel];
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

- (void)saveFrequence:(NSString *)frequence {
    
    if (frequence && frequence.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:frequence forKey:FlashLightFrequence];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FlashLightFrequence];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)saveTimes:(NSString *)times {
    
    if (times && times.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:times forKey:FlashLightTimes];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FlashLightTimes];
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

- (void)clearStatus {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FlashLightChannel];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FlashLightIsPoseOpen];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FlashLightIsSoundOpen];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FlashLightFrequence];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FlashLightTimes];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FlashLightFlashPower];

}

@end
