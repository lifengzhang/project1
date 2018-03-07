//
//  FlashLightDatePersistenceManager.h
//  SCamera
//
//  Created by sunny on 2018/3/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FlashLightDataManager                       [FlashLightDatePersistenceManager sharedInstance]

#define FlashLightChannel                                  @"flashLight_channel"
#define FlashLightIsPoseOpen                               @"flashLight_isPoseOpen"
#define FlashLightIsSoundOpen                              @"flashLight_isSoundOpen"
#define FlashLightFrequence                                @"flashLight_frequence"
#define FlashLightTimes                                    @"flashLight_times"
#define FlashLightFlashPower                               @"flashLight_flashPower"

@interface FlashLightDatePersistenceManager : NSObject

@property (nonatomic, strong) NSString *channel;

@property (nonatomic, assign) BOOL isPoseOpen;

@property (nonatomic, assign) BOOL isSoundOpen;

@property (nonatomic, strong) NSString *frequence;

@property (nonatomic, strong) NSString *times;

@property (nonatomic, strong) NSString *flashPower;

+ (instancetype)sharedInstance;

- (void)saveChannel:(NSString *)channel;

- (void)saveIsPoseOpen:(BOOL )isPoseOpen;

- (void)saveIsSoundOpen:(BOOL )isSoundOpen;

- (void)saveFrequence:(NSString *)frequence;

- (void)saveTimes:(NSString *)times;

- (void)saveFlashPower:(NSString *)flashPower;

- (void)clearStatus;

@end
