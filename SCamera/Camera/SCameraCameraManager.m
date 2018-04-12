//
//  SCameraCameraManager.m
//  SCamera
//
//  Created by sunny on 2018/4/12.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraCameraManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation SCameraCameraManager

static SCameraCameraManager *sharedInstance = nil;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[SCameraCameraManager alloc] init];
        
    });
    return sharedInstance;
}


- (void)splitVideo:(NSURL *)fileUrl fps:(float)fps splitCompleteBlock:(SplitCompleteBlock)splitCompleteBlock {
    if (!fileUrl) {
        return;
    }
    NSMutableArray *splitImages = [NSMutableArray array];
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    NSInteger timesCount = [times count];
    //视频分离成每帧
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        BOOL isSuccess = NO;
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *frameImg = [UIImage imageWithCGImage:image];
                UIImage *image = [frameImg fixOrientation];
                [splitImages addObject:image];
                
                if (requestedTime.value == timesCount) {
                    isSuccess = YES;
                    NSLog(@"completed");
                }
            }
                break;
        }
        if (splitCompleteBlock) {
            splitCompleteBlock(isSuccess,splitImages);
        }
    }];
}

@end
