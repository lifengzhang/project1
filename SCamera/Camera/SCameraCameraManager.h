//
//  SCameraCameraManager.h
//  SCamera
//
//  Created by sunny on 2018/4/12.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CameraManager                       [SCameraCameraManager sharedInstance]

typedef void(^SplitCompleteBlock)(BOOL success, NSMutableArray *splitimgs);

@interface SCameraCameraManager : NSObject

+ (instancetype)sharedInstance;

/**
 * 将视频分解成图片
 *@param fileUrl 视频路径
 *@param fps 帧率
 *@param splitCompleteBlock 分解完成回调
 */
- (void)splitVideo:(NSURL *)fileUrl fps:(float)fps splitCompleteBlock:(SplitCompleteBlock) splitCompleteBlock;

@end
