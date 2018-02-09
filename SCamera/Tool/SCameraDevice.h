//
//  SCameraDevice.h
//  SCamera
//
//  Created by sunny on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ISIOS10         Device.isIOS10
#define ISIOS9          Device.isIOS9
#define ISIOS8          Device.isIOS8
#define ISIPad          Device.isIPad
#define ISIPhone6Plus   Device.isIPhone6Plus
#define ISIPhone6       Device.isIPhone6
#define ISIPhone5       Device.isIPhone5
#define ISIPhone4       Device.isIPhone4
#define ISIphoneX       Device.isIPhoneX
#define ISSimulator     Device.isSimulator

#define Device          [SCameraDevice sharedSCameraDevice]
@interface SCameraDevice : UIDevice

@property (nonatomic, assign, readonly) BOOL isIOS10;
@property (nonatomic, assign, readonly) BOOL isIOS9;
@property (nonatomic, assign, readonly) BOOL isIOS8;
@property (nonatomic, assign, readonly) BOOL isIPad;
@property (nonatomic, assign, readonly) BOOL isIPhone6Plus;
@property (nonatomic, assign, readonly) BOOL isIPhone6;
@property (nonatomic, assign, readonly) BOOL isIPhone5;
@property (nonatomic, assign, readonly) BOOL isIPhone4;
@property (nonatomic, assign, readonly) BOOL isSimulator;
@property (nonatomic, assign, readonly) BOOL isIPhoneX;

+ (instancetype)sharedSCameraDevice;

+ (CGFloat)screenAdaptiveSizeWithIp6Size:(CGFloat)ip6Size;

@end
