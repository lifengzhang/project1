//
//  BlueManagerViewController.m
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/21.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import "BlueManagerViewController.h"
#import "BlueToothMe.h"
#import "BlueToothDeviceModel.h"
#import "Masonry.h"
#import "BlueManageDeviceTableView.h"

#define DEVICE_TABLE_TOP_MARGIN             130.f
#define DEVICE_TABLE_BOTTOM_MARGIN          124.f

@interface BlueManagerViewController () <BlueToothMeDelegate, BlueManageDeviceTableViewDelegate>

@property (nonatomic, strong) BlueToothMe *bluetoothManager;

@property (nonatomic, assign) CBManagerState currentState;

@property (nonatomic, strong) NSMutableArray<BlueToothDeviceModel *> *scanArray;

@property (nonatomic, strong) BlueManageDeviceTableView *deviceTable;

@property (nonatomic, strong) UIButton *testButton;

@end

@implementation BlueManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scanArray = [NSMutableArray array];
    [self setUpConstrain];
    [self.bluetoothManager startScan];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view Constrain

- (void)setUpConstrain {
    
    [self.deviceTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(DEVICE_TABLE_TOP_MARGIN);
        make.bottom.equalTo(self.view).offset(-DEVICE_TABLE_BOTTOM_MARGIN);
    }];
    
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.width.mas_equalTo(100);
        make.bottom.equalTo(self.deviceTable.mas_bottom).offset(60);
    }];
    
}

#pragma mark - lazy load

- (BlueToothMe *)bluetoothManager {
    if (! _bluetoothManager) {
        _bluetoothManager = [[BlueToothMe alloc] init];
        _bluetoothManager.blueToothMeDelegate = self;
        [_bluetoothManager hardwareResponse:^(CBPeripheral *peripheral, BlueToothMeState status, NSError *error) {
            
        }];
    }
    return _bluetoothManager;
}

- (BlueManageDeviceTableView *)deviceTable {
    if (! _deviceTable) {
        _deviceTable = [[BlueManageDeviceTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceTable.manageDeviceTableDelegate = self;
        [self.view addSubview:_deviceTable];
    }
    return _deviceTable;
}

- (UIButton *)testButton {
    
    if (! _testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [photoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
        //    [photoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
        _testButton.backgroundColor = [UIColor redColor];
        [_testButton addTarget:self action:@selector(testWrite) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testButton];
    }
    
    return _testButton;
    
}

- (void)blueManageDeviceTableView:(UITableView *)tableView selectButtonClickedAtIndexPath:(NSIndexPath *)indexPath {
    
//    self.selectedBluetoothIndex = indexPath.row;
//    if (self.scanArray && [self.scanArray count] > self.selectedBluetoothIndex) {
//        self.selectedBlueToothDevice = self.scanArray[self.selectedBluetoothIndex];
//
//
//        [self.deviceTable reloadWithBlueToothDeviceList:self.scanArray selectedIndex:self.selectedBluetoothIndex];
//    }
    
    BlueToothDeviceModel *blueToothDeviceModel = self.scanArray[indexPath.row];
    CBPeripheral *cbPeripheral = nil;
    for (NSUInteger i = 0; i < [self.bluetoothManager.dicoveredPeripherals count] ; i++)
    {
        CBPeripheral *cbPeripheralTemp = [self.bluetoothManager.dicoveredPeripherals objectAtIndex:i];
        
        if (cbPeripheralTemp.name == blueToothDeviceModel.name) {
            cbPeripheral = cbPeripheralTemp;
        }
    }
    

    if (cbPeripheral) {
        [self.bluetoothManager.manager connectPeripheral:cbPeripheral
                                                 options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
    
}

- (void)peripheralDidWriteChracteristic:(CBCharacteristic *)characteristic
                         withPeripheral:(CBPeripheral *)peripheral
                              withError:(NSError *)error {
    
    
}

- (void)peripheralDidReadChracteristic:(CBCharacteristic *)characteristic
                        withPeripheral:(CBPeripheral *)peripheral
                             withError:(NSError *)error {
    
}

-(void)discoveryPeripheral:(NSMutableArray *)resultArr {
    
    for (NSUInteger i = 0; i < [resultArr count] ; i++)
    {
        CBPeripheral *cbPeripheral = [resultArr objectAtIndex:i];
        BlueToothDeviceModel *blueToothDevice = [[BlueToothDeviceModel alloc] init];
        blueToothDevice.name = cbPeripheral.name;
        blueToothDevice.identifier = [cbPeripheral.identifier UUIDString];
        
        BOOL isInScaned = NO;
        for (NSUInteger j = 0;j < [self.scanArray count];j++) {
            BlueToothDeviceModel *scanedBlueToothDevice = [self.scanArray objectAtIndex:j];
            if ([scanedBlueToothDevice.identifier isEqualToString:blueToothDevice.identifier]) {
                isInScaned = YES;
                break;
            } else {
                continue;
            }
        }
        if (!isInScaned) {
            [self.scanArray addObject:blueToothDevice];
        }
    }
    [self.deviceTable reloadWithBlueToothDeviceList:self.scanArray selectedIndex:0];
//    [self refreshView];
//    
//    if (self.refreshTimer && [self.refreshTimer isValid]) {
//        [self.refreshTimer invalidate];
//        self.refreshTimer = nil;
//    } else {
//        self.refreshTimer = nil;
//    }
//    
//    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10
//                                                         target:self
//                                                       selector:@selector(refreshTimer:)
//                                                       userInfo:nil
//                                                        repeats:NO];
    
}

- (void)hardwareDidNotifyBehaviourOnCharacteristic:(CBCharacteristic *)characteristic
                                    withPeripheral:(CBPeripheral *)peripheral
                                             error:(NSError *)error {
    
}

- (void)bluetoothmeDidUpdateState:(CBCentralManager *)central
                            state:(CBManagerState)state {
    
    if (self.currentState == state) return;
    
    self.currentState = state;
    
    if (state == CBManagerStatePoweredOn) {
        [self startScan];
    } else {
//        [self stopScan];
        
//        if (self.isFirstRefreshState) {
//            self.isFirstRefreshState = NO;
//        } else {
            [self checkCentralManagerStateWithState:self.currentState];
//        }
    }
    
}

- (void)startScan {

    
    [self.bluetoothManager startScan];

}

- (BOOL)checkCentralManagerStateWithState:(CBManagerState)state {
    
    if(state == CBManagerStatePoweredOff) {
        
//        [self showAlertViewWithTitle:@"蓝牙未开启" message:Info_Bluetooth_PowerOff];
        return NO;
        
    } else if (state == CBManagerStateUnsupported) {
        
//        [self showAlertViewWithTitle:@"不支持蓝牙设备" message:Info_Bluetooth_UnSurpport];
        return NO;
        
    } else if (state == CBManagerStateUnauthorized) {
        
//        [self showAlertViewWithTitle:@"蓝牙权限未开启" message:Info_Bluetooth_Denied];
        return NO;
        
    } else {
        return YES;
    }
}

- (void)testWrite {
    
    //生成总包数data
//    NSData *d1 = [self setSplightValue];
//    NSLog(@"写%@",d1);
//    NSLog(@"%@",self.bluetoothManager.testPeripheral);
    
    [self.bluetoothManager.testPeripheral writeValue:[self setSplightValue] forCharacteristic:self.bluetoothManager.characteristic1 type:CBCharacteristicWriteWithResponse];
    
//    [self.bluetoothManager.testPeripheral writeValue:[self prelightValue] forCharacteristic:self.bluetoothManager.characteristic1 type:CBCharacteristicWriteWithResponse];
//    
//    [self.bluetoothManager.testPeripheral writeValue:[self fireValue] forCharacteristic:self.bluetoothManager.characteristic1 type:CBCharacteristicWriteWithResponse];
//    
//    [self.bluetoothManager.testPeripheral readValueForCharacteristic:self.bluetoothManager.characteristicReadInfo];
    
}

- (NSData *)setSplightValue {
    
//    UInt8 packet[8] = {0xce,0x00,0x00,0x00,0x00,0x00,0xff,0xef};
//
//    NSData *data = [[NSData alloc] initWithBytes:packet length:8];//将byte数组转化为data类型；
    
    Byte reg[14];
    reg[0]=0xbe;
    reg[1]=0x01;
    reg[2]=0x20;
    reg[3]=0x00;
    reg[4]=0x00;
    reg[5]=0x00;
    reg[6]=0x00;
    reg[7]=0x00;
    reg[8]=0x00;
    reg[9]=0x00;
    reg[10]=0x10;
    reg[11]=0x06;
    reg[12]=0xff;
    reg[13]=0xef;
//    reg[8]=(Byte)(reg[0]^reg[1]^reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]);
    NSData *data=[NSData dataWithBytes:reg length:14];

    return data;
    
}

- (NSData *)prelightValue
{
    
    //    UInt8 packet[8] = {0xce,0x00,0x00,0x00,0x00,0x00,0xff,0xef};
    //
    //    NSData *data = [[NSData alloc] initWithBytes:packet length:8];//将byte数组转化为data类型；
    
    Byte reg[14];
    reg[0]=0xce;
    reg[1]=0x00;
    reg[2]=0x00;
    reg[3]=0x00;
    reg[4]=0x00;
    reg[5]=0x00;
    reg[6]=0x00;
    reg[7]=0x00;
    reg[8]=0x00;
    reg[9]=0x00;
    reg[10]=0x00;
    reg[11]=0x00;
    reg[12]=0xff;
    reg[13]=0xef;
    //    reg[8]=(Byte)(reg[0]^reg[1]^reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]);
    NSData *data=[NSData dataWithBytes:reg length:14];
    
    return data;
    
}

- (NSData *)fireValue
{
    
    //    UInt8 packet[8] = {0xce,0x00,0x00,0x00,0x00,0x00,0xff,0xef};
    //
    //    NSData *data = [[NSData alloc] initWithBytes:packet length:8];//将byte数组转化为data类型；
    
    Byte reg[14];
    reg[0]=0xde;
    reg[1]=0x00;
    reg[2]=0x00;
    reg[3]=0x00;
    reg[4]=0x00;
    reg[5]=0x00;
    reg[6]=0x00;
    reg[7]=0x00;
    reg[8]=0x00;
    reg[9]=0x00;
    reg[10]=0x00;
    reg[11]=0x00;
    reg[12]=0xff;
    reg[13]=0xef;
    //    reg[8]=(Byte)(reg[0]^reg[1]^reg[2]^reg[3]^reg[4]^reg[5]^reg[6]^reg[7]);
    NSData *data=[NSData dataWithBytes:reg length:14];
    
    return data;
    
}

@end
