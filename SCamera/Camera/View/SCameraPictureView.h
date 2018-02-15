//
//  SCameraPictureView.h
//  SCamera
//
//  Created by sunny on 2018/2/13.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCameraPictureView : UIView

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIButton *backButton;

- (instancetype)initWithPicture:(UIImage *)image;

@end
