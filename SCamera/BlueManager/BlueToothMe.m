//
//  BlueToothMe.m
//  SCamera
//
//  Created by macj on 16/9/6.
//  Copyright © 2016年 SCamera. All rights reserved.
//

#import "BlueToothMe.h"

#define kWriteCharacteristicUUID @"0003CDD2-0000-1000-8000-00805F9B0131" //特征的UUID
#define kNotifyCharacteristicUUID @"0003CDD1-0000-1000-8000-00805F9B0131" //特征的UUID

@interface BlueToothMe ()

@property (nonatomic, copy) EventHardwareBlock privateBlock;

@end

@implementation BlueToothMe

- (instancetype)init {
    if ((self = [super init])) {
        self.characteristicsCBUUID = [NSMutableDictionary new];
        self.dicoveredPeripherals = [NSMutableArray new];
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)startScan {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],
                             CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.manager scanForPeripheralsWithServices:nil options:options];
    
}

- (void)stopScan {
    self.dicoveredPeripherals = [[NSMutableArray alloc] init];
    [self.manager stopScan];
}

- (BOOL)supportLEHardware {
    NSString * state = nil;
    
    switch ([self.manager state]) {
        case CBManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBManagerStatePoweredOn:
            return TRUE;
        case CBManagerStateUnknown:
        default:
            return false;
    }
    return false;
}

- (void)setCharacteristics:(NSArray *)characteristics forServiceCBUUID:(NSString *)serviceCBUUID {
    [self.characteristicsCBUUID setValue:characteristics forKey:serviceCBUUID];
}

- (void)setServicesUID:(NSArray *)cbuuid {
    self.servicesCBUUID = cbuuid;
}

- (void)setValuesToNotify:(NSArray *)notifiers {
    [notifiers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CBCharacteristic *localChar = (CBCharacteristic *)obj;
        [self.testPeripheral setNotifyValue:YES forCharacteristic:localChar];
    }];
}

- (void)hardwareResponse:(EventHardwareBlock)block {
    self.privateBlock = [block copy];
}

#pragma mark - CBManagerDelegate methods

/*
 Invoked whenever the central manager's state is updated.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (self.blueToothMeDelegate && [self.blueToothMeDelegate respondsToSelector:@selector(bluetoothmeDidUpdateState:state:)]) {
        [self.blueToothMeDelegate bluetoothmeDidUpdateState:central state:[self.manager state]];
    }
}

- (void)gatherBluetoothDescFromState:(CBManagerState)state {
    switch (state) {
        case CBManagerStateUnknown:
            _stateDesc = @"未知状态";
            break;
        case CBManagerStateResetting:
            _stateDesc = @"重置状态";
            break;
        case CBManagerStateUnsupported:
            _stateDesc = @"设备不支持状态";
            break;
        case CBManagerStateUnauthorized:
            _stateDesc = @"设备未授权状态";
            break;
        case CBManagerStatePoweredOff:
            _stateDesc = @"设备没电不可用状态";
            break;
        case CBManagerStatePoweredOn:
            _stateDesc = @"设备通电可用状态";
            break;
        default:
            break;
    }
}

- (NSString *)stateDesc {
    [self gatherBluetoothDescFromState:[self.manager state]];
    return _stateDesc;
}

/*
 Invoked when the central discovers peripheral while scanning.
 */
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    //    DDLogInfo(@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData);
    
    if (!peripheral.name || peripheral.name.length == 0) {
        return;
    }
    
    if(![self.dicoveredPeripherals containsObject:peripheral])
        [self.dicoveredPeripherals addObject:peripheral];
    
    [self.blueToothMeDelegate discoveryPeripheral:self.dicoveredPeripherals];
    
    //    [manager retrievePeripherals:[NSArray arrayWithObject:(id)peripheral.UUID]];
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 Automatically connect to first known peripheral
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    [self stopScan];
    
    /* If there are any known devices, automatically connect to it.*/
    if([peripherals count] >= 1)
    {
        self.testPeripheral = [peripherals objectAtIndex:0];
        
        [self.manager connectPeripheral:self.testPeripheral
                           options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}

/*
 Invoked whenever a connection is succesfully created with the peripheral.
 Discover available services on the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (self.privateBlock) {
        self.privateBlock(peripheral, BlueToothMeStateConnnected, nil);
        self.testPeripheral = peripheral;
    }
    
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
}

/*
 Invoked whenever an existing connection with the peripheral is torn down.
 Reset local variables
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (self.privateBlock) {
        self.privateBlock(peripheral, BlueToothMeStateDisconnected, error);
    }
    
    if (self.testPeripheral) {
        [self.testPeripheral setDelegate:nil];
        self.testPeripheral = nil;
    }
}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    self.privateBlock(peripheral, BlueToothMeStateFailToConnnected, error);
    
    if (self.testPeripheral) {
        [self.testPeripheral setDelegate:nil];
        self.testPeripheral = nil;
    }
}

#pragma mark - CBPeripheralDelegate methods

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    
    if(error){
        NSLog(@"发现服务错误：%@",error);
        return;
    }
    printf("发现周边设备的服务:\n");
    printf("==== didDiscoverServices ==== \n");
    int i=0;
    //发现服务中的特性
    for (CBService *service in peripheral.services) {
        i++;
        NSLog(@"%@",[NSString stringWithFormat:@"%d :服务 UUID: %@(%@)",i,service.UUID.data,service.UUID]);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    NSLog(@"%@",[NSString stringWithFormat:@"发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID]);
    
    if (error) {
        NSLog(@"There is a error in peripheral:didDiscoverCharacteristicsForService:error: which called:%@",error);
        return;
    }

    for (CBCharacteristic *characteristic in service.characteristics) {
        
        switch (characteristic.properties) {
            case CBCharacteristicPropertyRead:
                NSLog(@"%@-------读",characteristic);
                break;
            case CBCharacteristicPropertyWrite:
                NSLog(@"%@-------写",characteristic);
                break;
            case CBCharacteristicPropertyNotify:
                NSLog(@"%@-------订阅",characteristic);
                break;
            default:
                break;
        }
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
            [peripheral readValueForCharacteristic:characteristic];
        } else if ([service.UUID isEqual:[CBUUID UUIDWithString:@"fff0"]]) {
            NSLog(@"%@",[NSString stringWithFormat:@"特征 UUID: %@ (%@)",characteristic.UUID.data,characteristic.UUID]);
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"fff3"]]) {
                self.characteristic1 = characteristic;
//                [peripheral readValueForCharacteristic:characteristic];
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"fff2"]]) {
                self.characteristicReadInfo = characteristic;
//                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FA10"]]) {
//            self.characteristic1 = characteristic;
//        }
//
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FA11"]]) {
//            [peripheral readValueForCharacteristic:characteristic];
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
//
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FA12"]]) {
//            [peripheral readValueForCharacteristic:characteristic];
//        }
//
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FF05"]]) {
//            [peripheral readValueForCharacteristic:characteristic];
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
//
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
//            [peripheral readRSSI];
//        }
        
//        if (characteristic.properties & CBCharacteristicPropertyNotify) {
//            [peripheral readValueForCharacteristic:characteristic];
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kWriteCharacteristicUUID]])
//        {
//            NSLog(@"监听：%@",characteristic);//监听特征
            //保存characteristic特征值对象
            //以后发信息也是用这个uuid
            
//            _characteristic1 = characteristic;
            
//            [_discoveredPeripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }

    }
}

/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        return;
    }
    if ([characteristic.service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        NSLog(@"(%@) = %@", characteristic.UUID,[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
    } else {
        
        NSLog(@"characteristic data is:%@ ",characteristic.value);
        NSLog(@"characteristic str is:%@ ",[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
        NSLog(@"characteristic data length is %ld",characteristic.value.length);
        
    }
    
    if ([self.blueToothMeDelegate respondsToSelector:@selector(peripheralDidReadChracteristic:withPeripheral:withError:)])
        [self.blueToothMeDelegate peripheralDidReadChracteristic:characteristic withPeripheral:peripheral withError:error];
}

/*
 Invoked upon completion of a -[writeValue:forCharacteristic:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if (error) {
        return;
    } else{
        NSLog(@"发送数据成功");
//        [self updateLog:@"发送数据成功"];
    }
    
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    [peripheral readValueForCharacteristic:characteristic];

    if ([self.blueToothMeDelegate respondsToSelector:@selector(peripheralDidWriteChracteristic:withPeripheral:withError:)])
        [self.blueToothMeDelegate peripheralDidWriteChracteristic:characteristic withPeripheral:peripheral withError:error];
}

/*
 Invoked upon completion of a -[setNotifyValue:forCharacteristic:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    if (error)
    {
        return;
    }
    printf(" update notification success !!");
    NSLog(@"接收到的数据：%@",characteristic.value);
    
    if ([self.blueToothMeDelegate respondsToSelector:@selector(hardwareDidNotifyBehaviourOnCharacteristic:withPeripheral:error:)])
        [self.blueToothMeDelegate hardwareDidNotifyBehaviourOnCharacteristic:characteristic withPeripheral:peripheral error:error];
}

@end
