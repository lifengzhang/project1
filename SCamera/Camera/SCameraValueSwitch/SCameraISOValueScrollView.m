//
//  SCameraISOValueScrollView.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraISOValueScrollView.h"

@interface SCameraISOValueScrollView()

@property (nonatomic, strong) NSArray *iSOValuesArray;

@end

@implementation SCameraISOValueScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iSOValuesArray = @[@(25),@(32),@(40),@(64),@(80),@(100),@(125),@(160),@(200),@(250),@(320),@(400),@(500),@(640),@(800)];
        self.contentSize = CGSizeMake(1000, 50);
        [self initValuesLabel];
    }
    
    return self;
    
}

- (void)initValuesLabel {
    
    for (NSUInteger i = 0; i < self.iSOValuesArray.count; i++) {
     
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = self.iSOValuesArray[i];
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];
        
    }
    
}

@end
