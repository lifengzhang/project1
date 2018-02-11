//
//  SCameraShutterPickerView.m
//  SCamera
//
//  Created by sunny on 2018/2/11.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraShutterPickerView.h"

@interface SCameraShutterPickerView ()

@property (nonatomic, strong) NSArray *timeArray;

@property (nonatomic, assign) NSInteger selectRow;

@end

@implementation SCameraShutterPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.transform = CGAffineTransformMakeRotation(M_PI*3/2);
        self.timeArray = @[@"1/60",@"1/35",@"1/30",@"1/20",@"1/10"];
        self.backgroundColor = [UIColor clearColor];
   }
    return self;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.timeArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 2)
        {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    UILabel *reasonLabel = [UILabel new];
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    reasonLabel.text = self.timeArray[row];
    reasonLabel.font = [UIFont ChinaDefaultFontNameOfSize:14.f];
    reasonLabel.textColor = [UIColor whiteColor];
    reasonLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    //改变选中行颜色（
    if (row == self.selectRow) {
        reasonLabel.textColor = [UIColor blackColor];
    }
    return reasonLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 35;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 80;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectRow = row;
    [pickerView reloadComponent:component];
    
    if (self.scameraShutterPickerViewDelegate && [self.scameraShutterPickerViewDelegate respondsToSelector:@selector(scameraShutterPickerViewDidSelectedRowWithValue:)]) {
        [self.scameraShutterPickerViewDelegate scameraShutterPickerViewDidSelectedRowWithValue:self.timeArray[row]];
    }
}

@end
