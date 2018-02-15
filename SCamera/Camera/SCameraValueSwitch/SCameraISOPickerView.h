//
//  SCameraISOPickerView.h
//  SCamera
//
//  Created by sunny on 2018/2/12.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCameraISOPickerViewDelegate <NSObject>

- (void)scameraISOPickerViewDidSelectedRowWithValue:(NSString *)value;

@end

@interface SCameraISOPickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <SCameraISOPickerViewDelegate> scameraISOPickerViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame;


@end
