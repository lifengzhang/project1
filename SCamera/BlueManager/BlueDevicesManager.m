//
//  BlueDevicesManager.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/7.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "BlueDevicesManager.h"

@implementation BlueDevicesManager

static BlueDevicesManager *sharedInstance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[BlueDevicesManager alloc] init];
        
    });
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
//        [self initData];
    }
    return self;
}

@end
