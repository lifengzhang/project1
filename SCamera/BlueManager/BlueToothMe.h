//
//  BlueToothMe.h
//  SCamera
//
//  Created by macj on 16/9/6.
//  Copyright © 2016年 SCamera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define BTMe                       [BlueToothMe sharedInstance]

typedef NS_ENUM(NSUInteger, BlueToothMeState) {
    BlueToothMeStateDisconnected = 0,
    BlueToothMeStateFailToConnnected,
    BlueToothMeStateConnnected
};

typedef void (^EventHardwareBlock)(CBPeripheral *peripheral, BlueToothMeState status, NSError *error);

@protocol BlueToothMeDelegate <NSObject>

- (void)peripheralDidWriteChracteristic:(CBCharacteristic *)characteristic
                         withPeripheral:(CBPeripheral *)peripheral
                              withError:(NSError *)error;

- (void)peripheralDidReadChracteristic:(CBCharacteristic *)characteristic
                        withPeripheral:(CBPeripheral *)peripheral
                             withError:(NSError *)error;

- (void)discoveryPeripheral:(NSMutableArray *)resultArr;

- (void)didConnectPeripheral:(CBPeripheral *)peripheral;

- (void)hardwareDidNotifyBehaviourOnCharacteristic:(CBCharacteristic *)characteristic
                                    withPeripheral:(CBPeripheral *)peripheral
                                             error:(NSError *)error;

- (void)bluetoothmeDidUpdateState:(CBCentralManager *)central
                            state:(CBManagerState)state;

@end

@interface BlueToothMe : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) NSMutableArray *dicoveredPeripherals;

@property (nonatomic, strong) NSArray *letWriteDataCBUUID;

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) NSArray *servicesCBUUID;
@property (nonatomic, strong) CBPeripheral *connectedPeripheral;
@property (nonatomic, strong) NSDictionary *characteristicsCBUUID;

@property (strong , nonatomic) CBCharacteristic *characteristic1;
@property (strong , nonatomic) CBCharacteristic *characteristicReadInfo;

@property (nonatomic, weak)  id<BlueToothMeDelegate> blueToothMeDelegate;

// add by shasha ;2014-3-16;蓝牙状态描述
@property (nonatomic, copy) NSString *stateDesc;

+ (instancetype)sharedInstance;
- (void)startScan;
- (void)stopScan;
- (void)setServicesUID:(NSArray *)cbuuid;
- (void)setCharacteristics:(NSArray *)characteristics forServiceCBUUID:(NSString *)serviceCBUUID;
- (void)setValuesToNotify:(NSArray *)notifiers;
- (void)hardwareResponse:(EventHardwareBlock)block;

- (void)SplightFire;

@end
