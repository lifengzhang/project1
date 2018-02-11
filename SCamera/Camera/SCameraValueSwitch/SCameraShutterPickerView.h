//
//  SCameraShutterPickerView.h
//  SCamera
//
//  Created by sunny on 2018/2/11.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCameraShutterPickerViewDelegate <NSObject>

- (void)scameraShutterPickerViewDidSelectedRowWithValue:(NSString *)value;

@end

@interface SCameraShutterPickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <SCameraShutterPickerViewDelegate> scameraShutterPickerViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
