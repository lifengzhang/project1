//
//  UIImage+Additions.m
//  SCamera
//
//  Created by sunny on 2018/3/21.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)


+ (UIImage*)originImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

@end
