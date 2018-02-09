//
//  SCameraDevice.m
//  SCamera
//
//  Created by sunny on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraDevice.h"

@implementation SCameraDevice

static SCameraDevice *_sharedDevice = nil;

+ (instancetype)sharedSCameraDevice {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDevice = [[SCameraDevice alloc] init];
        [_sharedDevice initialDeviceParameters];
    });
    return _sharedDevice;
    
}

- (void)initialDeviceParameters {
    
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]
        || [[[UIDevice currentDevice] model] isEqualToString:@"iPad Simulator"]) {
        _isIPad = YES;
    } else {
        _isIPad = NO;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8.0) {
        _isIOS8 = YES;
    } else {
        _isIOS8 = NO;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 9.0) {
        _isIOS9 = YES;
    } else {
        _isIOS9 = NO;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 10.0) {
        _isIOS10 = YES;
    } else {
        _isIOS10 = NO;
    }
    
    if (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM()) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        NSInteger screenHeight = 0;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            screenHeight = screenBounds.size.width;
        }else {
            screenHeight = screenBounds.size.height;
        }
        if (screenHeight == 812) {
            _isIPhoneX = YES;
        } else if(screenHeight == 736) {
            _isIPhone6Plus = YES;
        }else if (screenHeight == 667) {
            _isIPhone6 = YES;
        }else if(screenHeight == 568) {
            _isIPhone5 = YES;
        }else if(screenHeight == 480) {
            _isIPhone4 = YES;
        }else {
            _isIPhone6Plus = NO;
            _isIPhone6 = NO;
            _isIPhone5 = NO;
            _isIPhone4 = NO;
        }
    }else {
        _isIPhone6Plus = NO;
        _isIPhone6 = NO;
        _isIPhone5 = NO;
        _isIPhone4 = NO;
        _isIPhoneX = NO;
    }
    _isSimulator = TARGET_OS_SIMULATOR;
    
}

+ (CGFloat)screenAdaptiveSizeWithIp6Size:(CGFloat)ip6Size {
    if (ISIPhone5) {
        return 0.851 * ip6Size;
    } else if (ISIPhone6) {
        return ip6Size;
    } else if (ISIphoneX) {
        return 1.18 * ip6Size;
    } else {
        return 1.093 * ip6Size;
    }
}

@end
