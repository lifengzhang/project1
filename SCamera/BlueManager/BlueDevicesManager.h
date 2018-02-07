//
//  BlueDevicesManager.h
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueToothDeviceModel.h"

#define BDManager                       [BlueDevicesManager sharedInstance]

@interface BlueDevicesManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) BlueToothDeviceModel *connectedBlueToothDeviceModel;

@end
