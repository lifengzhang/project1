//
//  SCameraISOValueScrollView.m
//  SCamera
//
//  Created by Lifeng Zhang on 2018/2/9.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraISOValueScrollView.h"

@implementation SCameraISOValueScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(1000, 50);
    }
    
    return self;
    
}

@end
