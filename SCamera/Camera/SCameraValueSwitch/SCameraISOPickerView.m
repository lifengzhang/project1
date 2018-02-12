//
//  SCameraISOPickerView.m
//  SCamera
//
//  Created by sunny on 2018/2/12.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraISOPickerView.h"

@interface SCameraISOPickerView ()

@property (nonatomic, strong) NSArray *isoArray;

@property (nonatomic, assign) NSInteger selectRow;

@end

@implementation SCameraISOPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.transform = CGAffineTransformMakeRotation(M_PI*3/2);
        self.isoArray = @[@"25",@"32",@"40",@"64",@"80",@"100",@"125",@"160",@"200",@"250",@"320",@"400",@"500",@"640",@"800"];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.isoArray.count;
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
    reasonLabel.text = self.isoArray[row];
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
    
    if (self.scameraISOPickerViewDelegate && [self.scameraISOPickerViewDelegate respondsToSelector:@selector(scameraISOPickerViewDidSelectedRowWithValue:)]) {
        [self.scameraISOPickerViewDelegate scameraISOPickerViewDidSelectedRowWithValue:self.isoArray[row]];
    }
}


@end
