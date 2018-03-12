//
//  SCameraFlashLightManager.h
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/23.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FlashLightManager                       [SCameraFlashLightManager sharedInstance]

#define FlashLightChannel                                  @"flashLight_channel"
#define FlashLightIsPoseOpen                               @"flashLight_isPoseOpen"
#define FlashLightIsSoundOpen                              @"flashLight_isSoundOpen"
#define FlashLightFrequence                                @"flashLight_frequence"
#define FlashLightTimes                                    @"flashLight_times"
#define FlashLightFlashPower                               @"flashLight_flashPower"
#define FlashLightApower                                   @"flashLight_aPower"

#define IsSelectedA                                        @"isSelected_A"
#define IsSelectedB                                        @"isSelected_B"
#define IsSelectedC                                        @"isSelected_C"
#define IsSelectedD                                        @"isSelected_D"

#define IsSelectedStartA                                   @"isSelected_start_A"
#define IsSelectedStartB                                   @"isSelected_start_B"
#define IsSelectedStartC                                   @"isSelected_start_C"
#define IsSelectedStartD                                   @"isSelected_start_D"


#define GroupArray                                         @"group_array"
#define MainValue                                          @"main_value"

typedef enum : Byte {
    
    FlashLightModelStandby = 0x00,
    FlashLightModelAuto = 0x10,
    FlashLightModelManual = 0x20,
    FlashLightModelFlash = 0x60,
    FlashLightModelLED = 0x80,
    
} FlashLightModel;

typedef enum : Byte {
    
    FlashLightDegreeOFF = 0x00,
    FlashLightDegreePROP = 0x01,
    FlashLightDegree20 = 0x02,
    FlashLightDegree100 = 0x06,
    
} FlashLightDegree;

typedef enum : Byte {
    FlashLightPowerStandby = 0x00,
    FlashLightPower1 = 0x16,
    FlashLightPower1_2_2 = 0x15,
    FlashLightPower1_2_1 = 0x14,
    FlashLightPower1_2 = 0x13,
    FlashLightPower1_4_2 = 0x12,
    FlashLightPower1_4_1 = 0x11,
    FlashLightPower1_4 = 0x10,
    FlashLightPower1_8_2 = 0x0f,
    FlashLightPower1_8_1 = 0x0d,
    FlashLightPower1_8 = 0x0d,
    FlashLightPower1_16_2 = 0x0c,
    FlashLightPower1_16_1 = 0x0b,
    FlashLightPower1_16 = 0x0a,
    FlashLightPower1_32_2 = 0x09,
    FlashLightPower1_32_1 = 0x08,
    FlashLightPower1_32 = 0x07,
    FlashLightPower1_64_2 = 0x06,
    FlashLightPower1_64_1 = 0x05,
    FlashLightPower1_64 = 0x04,
    FlashLightPower1_128_2 = 0x03,
    FlashLightPower1_128_1 = 0x02,
    FlashLightPower1_128 = 0x01,
    
} FlashLightPower;

@interface SCameraFlashLightManager : NSObject

//第一组
@property (nonatomic, assign) BOOL isSoundOpen;

@property (nonatomic, assign) BOOL isPoseOpen;

@property (nonatomic, assign) Byte channel;

//第二组
@property (nonatomic, assign) FlashLightModel aModel;

@property (nonatomic, assign) FlashLightDegree aLightDegree;

//第三组
@property (nonatomic, assign) FlashLightModel bModel;

@property (nonatomic, assign) FlashLightDegree bLightDegree;

//第四组
@property (nonatomic, assign) FlashLightModel cModel;

@property (nonatomic, assign) FlashLightDegree cLightDegree;

//第五组
@property (nonatomic, assign) FlashLightModel dModel;

@property (nonatomic, assign) FlashLightDegree dLightDegree;

//第六组
@property (nonatomic, assign) FlashLightPower aPower;

//第七组
@property (nonatomic, assign) FlashLightPower bPower;

//第八组
@property (nonatomic, assign) FlashLightPower cPower;

//第九组
@property (nonatomic, assign) FlashLightPower dPower;

//第十组
@property (nonatomic, assign) NSUInteger flashNumber;

//第十一组
@property (nonatomic, assign) NSUInteger flashFrequency;

@property (nonatomic, strong) NSString *flashPower;

@property (nonatomic, strong) NSString *mainValue;               //Slider主要的值

@property (nonatomic, assign) BOOL isSelectedA;                  //选择分组A
@property (nonatomic, assign) BOOL isSelectedB;
@property (nonatomic, assign) BOOL isSelectedC;
@property (nonatomic, assign) BOOL isSelectedD;

@property (nonatomic, assign) BOOL isSelectedStartA;               //A组启动按钮
@property (nonatomic, assign) BOOL isSelectedStartB;               //B组启动按钮
@property (nonatomic, assign) BOOL isSelectedStartC;               //C组启动按钮
@property (nonatomic, assign) BOOL isSelectedStartD;               //D组启动按钮


@property (nonatomic, strong) NSMutableArray *groupArray;               //存储分组


+ (instancetype)sharedInstance;

- (NSData *)getSettingBytes;

- (void)saveChannel:(NSInteger)channel;

- (void)saveIsPoseOpen:(BOOL)isPoseOpen;

- (void)saveIsSoundOpen:(BOOL)isSoundOpen;

- (void)saveIsSelectedA:(BOOL)isSelectedA;

- (void)saveIsSelectedB:(BOOL)isSelectedB;

- (void)saveIsSelectedC:(BOOL)isSelectedC;

- (void)saveIsSelectedD:(BOOL)isSelectedD;

- (void)saveFrequence:(NSInteger)frequence;

- (void)saveTimes:(NSInteger)times;

- (void)saveFlashPower:(NSString *)flashPower;

- (void)saveAPower:(FlashLightPower)aPower;

- (void)saveGroupArray:(NSString *)str;

- (void)removeGroupString:(NSString *)str;

- (void)saveMainValue:(NSString *)str;

- (void)saveStartAIsSelected:(BOOL)selected;

- (void)saveStartBIsSelected:(BOOL)selected;

- (void)saveStartCIsSelected:(BOOL)selected;

- (void)saveStartDIsSelected:(BOOL)selected;


@end
