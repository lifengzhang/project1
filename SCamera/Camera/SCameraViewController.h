//
//  SCameraViewController.h
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/20.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScameraTimer)
{
    selectedTimerLogo = 0,
    selectedCloseBtn,
    selectedThree,
    selectedTen
};

typedef NS_ENUM(NSInteger, SCameraFlashLightStatus)
{
    flashlightLogo = 0,
    flashligtAuto,
    flashlighOpen,
    flashligtClose
};

@interface SCameraViewController : UIViewController

@end
