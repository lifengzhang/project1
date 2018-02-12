//
//  SCameraViewController.m
//  SCamera
//
//  Created by Lifeng Zhang on 2017/12/20.
//  Copyright © 2017年 SCamera.com. All rights reserved.
//

#import "SCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "SCameraPhotoViewController.h"
#import "BlueManagerViewController.h"
#import "CameraView.h"

#import "SCameraShutterPickerView.h"

#import "SCameraISOPickerView.h"

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#define CANCELBUTTON_DISTANCE_TOP                                              kScreenHeight - 100
#define CANCELBUTTON_DISTANCE_LEFT                                             kScreenWidth*1/4.0 - 30
#define CANCELBUTTON_WIDTH_HEIGHT                                              60.f

#define EXPOSUREDURATIONTITLELABEL_DISTANCE_TOP                                kScreenHeight - 176
#define EXPOSUREDURATIONTITLELABEL_DISTANCE_LEFT                               20.f
#define EXPOSUREDURATIONTITLELABEL_WIDTH                                       80.f
#define EXPOSUREDURATIONTITLELABEL_HEIGHT                                      30.f

#define EXPOSUREDURATIONVALUELABEL_DISTANCE_TOP                                kScreenHeight - 190
#define EXPOSUREDURATIONVALUELABEL_DISTANCE_LEFT                               100.f
#define EXPOSUREDURATIONVALUELABEL_WIDTH                                       100.f
#define EXPOSUREDURATIONVALUELABEL_HEIGHT                                      30.f

#define EXPOSUREDURATIONSLIDER_DISTANCE_TOP                                    kScreenHeight - 150
#define EXPOSUREDURATIONSLIDER_DISTANCE_LEFT                                   20.f
#define EXPOSUREDURATIONSLIDER_WIDTH                                           kScreenWidth - 40
#define EXPOSUREDURATIONSLIDER_HEIGHT                                          30.f


#define ISOTITLELABEL_DISTANCE_TOP                                             110.f
#define ISOTITLELABEL_DISTANCE_LEFT                                            20.f
#define ISOTITLELABEL_WIDTH                                                    84.f
#define ISOTITLELABEL_HEIGHT                                                   35.f

@interface SCameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, SCameraShutterPickerViewDelegate, UIGestureRecognizerDelegate, SCameraISOPickerViewDelegate>

@property(nonatomic,strong) AVCaptureDevice *device;;

@property (nonatomic, strong) AVCaptureSession* session; //AVCapturemSession对象来执行输入设备和输出设备之间的数据传递

//@property (nonatomic, strong) AVCaptureStillImageOutput *ImageOutPut;

@property (nonatomic, strong) AVCapturePhotoOutput *photoOutPut; //ios 10

@property (nonatomic, strong) AVCapturePhotoSettings *photoSettings; //ios 10

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *exposureDurationTitleLabel;

@property (nonatomic, strong) UILabel *exposureDurationValueLabel;

@property (nonatomic, strong) UISlider *exposureDurationSlider;

@property (nonatomic, strong) UILabel *isoTitleLabel;

@property (nonatomic, assign) CMTime firstDuration;

@property (nonatomic, assign) CMTime currentDuration;

@property (nonatomic, assign) CGFloat firstISO;

@property (nonatomic, assign) CGFloat currentISO;

@property (nonatomic, assign) AVCaptureExposureMode exposureMode;

@property (nonatomic, strong) UIImagePickerController *photoAlbumController;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer; //预览图层

@property (nonatomic ,strong) CameraView *cameraView;

@property (nonatomic, strong) NSString *shutterStr;    //屏幕显示的shutter数值

@property (nonatomic, strong) SCameraShutterPickerView *shutterPickerView;

@property (nonatomic, assign)  NSInteger clickNumber;  //点击定时器的次数

@property (nonatomic, strong) SCameraISOPickerView *isoPickerView;

@property (nonatomic, strong) UIImageView *cameraFocusView;  //聚焦视图

@property (nonatomic, assign) float receivedISOValue;

@property (nonatomic, strong) AVCaptureDeviceInput *input;

@property (nonatomic, assign) AVCaptureFlashMode mode; // 闪光灯模式

@property (nonatomic, assign) AVCaptureDevicePosition position;

/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 * 最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;

@end

@implementation SCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customCamera];
    [self customUI];
    [self getLatestAsset];
    [self addButtonAction];
    [self addGesture];
}

- (void)startSession{
    
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)stopSession{
    
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)addButtonAction {
    [self.cameraView.backButton addTarget:self action:@selector(tapCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.photoLibraryButton addTarget:self action:@selector(showPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.flashLightButton addTarget:self action:@selector(tapFlashLightbutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.timerButton addTarget:self action:@selector(tapTimerButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.exchangeButton addTarget:self action:@selector(tapExchangeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.photoButton addTarget:self action:@selector(judgeHaveTimerAndShutterCamera) forControlEvents:UIControlEventTouchUpInside];

    [self.cameraView.valueButton addTarget:self action:@selector(tapValueButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.bluetoothButton addTarget:self action:@selector(tapblueToothButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    pinchGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:pinchGestureRecognizer];
}

- (void)customCamera{
    self.view.backgroundColor = [UIColor blackColor];
    self.clickNumber = 0;
    //使用设备初始化输入
    self.position = AVCaptureDevicePositionBack;
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    if ([self.session canAddInput:_input]) {
        [self.session addInput:_input];
    }
    
//    if ([self.session canAddOutput:self.ImageOutPut]) {
//        [self.session addOutput:self.ImageOutPut];
//    }
    
    // 6. 连接输出与会话
    if ([self.session canAddOutput:self.photoOutPut]) {
        [self.session addOutput:self.photoOutPut];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 140);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //开始启动
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
//        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
//            [self.device setFlashMode:AVCaptureFlashModeAuto];
//        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        self.firstISO = self.device.ISO;
//        self.currentISO = self.device.ISO;
        
        self.firstDuration = self.device.exposureDuration;
//        self.currentDuration = self.device.exposureDuration;
        [self updateValueData];
        [self.device unlockForConfiguration];

    }
}

- (void)customUI{
    
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.exposureDurationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(EXPOSUREDURATIONTITLELABEL_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(ISOTITLELABEL_HEIGHT);
    }];
    
//    [self.exposureDurationValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(EXPOSUREDURATIONVALUELABEL_DISTANCE_TOP);
//        make.left.equalTo(self.view).offset(EXPOSUREDURATIONVALUELABEL_DISTANCE_LEFT);
//        make.width.mas_equalTo(EXPOSUREDURATIONVALUELABEL_WIDTH);
//        make.height.mas_equalTo(EXPOSUREDURATIONVALUELABEL_HEIGHT);
//    }];
//
//    [self.exposureDurationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(EXPOSUREDURATIONSLIDER_DISTANCE_TOP);
//        make.left.equalTo(self.view).offset(EXPOSUREDURATIONSLIDER_DISTANCE_LEFT);
//        make.width.mas_equalTo(EXPOSUREDURATIONSLIDER_WIDTH);
//        make.height.mas_equalTo(EXPOSUREDURATIONSLIDER_HEIGHT);
//    }];
    
    [self.isoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISIphoneX ? 87 : 65);
        make.left.equalTo(self.view).offset(16.f);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(ISOTITLELABEL_HEIGHT);
    }];
    
    [self.cameraFocusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.height.width.mas_equalTo(80);
    }];
    
//    [self.iSOValueScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.isoTitleLabel);
//        make.left.equalTo(self.isoTitleLabel.mas_right);
//        make.right.equalTo(self.view);
//        make.height.mas_equalTo(35);
//    }];
    
    self.isoPickerView.frame = CGRectMake(76, ISIphoneX ? 87 : 65, kScreenWidth - 152, 35);
    self.shutterPickerView.frame = CGRectMake(76, kScreenHeight - 176, kScreenWidth - 152, 35);
//    [self.isoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(ISOVALUELABEL_DISTACE_TOP);
//        make.left.equalTo(self.view).offset(ISOVALUELABEL_DISTACE_LEFT);
//        make.width.mas_equalTo(ISOVALUELABEL_WIDTH);
//        make.height.mas_equalTo(ISOVALUELABEL_HEIGHT);
//    }];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

- (void)pinchView:(UIPinchGestureRecognizer *)panGestureRecognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [panGestureRecognizer numberOfTouches];
    for (NSUInteger i = 0; i < numTouches; ++i ) {
        CGPoint location = [panGestureRecognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        self.effectiveScale = self.beginGestureScale * panGestureRecognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
//        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,panGestureRecognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.photoOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];

        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
//        NSLog(@"self.previewLayer.frame = %@",NSStringFromCGRect(self.previewLayer.frame));
        [CATransaction commit];
        
        AVCaptureConnection * videoConnection = [self.photoOutPut connectionWithMediaType:AVMediaTypeVideo];
        [videoConnection setVideoScaleAndCropFactor:self.effectiveScale];
        
    }
    

}

#pragma mark - 截取照片
- (void) shutterCamera
{
//    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
//    if (!videoConnection) {
//        NSLog(@"take photo failed!");
//        return;
//    }
    
    @try {
        
//        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [self.device lockForConfiguration:nil];
        
        __weak SCameraViewController *wSelf = self;
        [self.device setExposureModeCustomWithDuration:(self.shutterStr.length == 0) ? self.firstDuration : self.currentDuration ISO:self.currentISO == 0 ? 34 : self.currentISO completionHandler:^(CMTime syncTime)
         {
//             AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
             // 此只读属性的值表示当前场景的计量曝光水平与目标曝光值之间的差异。
             //        [self.mExposureBias setValue:device.exposureTargetOffset];
             
             //手动模式
             //             device.exposureMode=AVCaptureExposureModeCustom;
             NSLog(@"device.ISO = %f",wSelf.device.ISO);
             NSLog(@"device.minISO = %f",wSelf.device.activeFormat.minISO);
             NSLog(@"device.maxISO = %f",wSelf.device.activeFormat.maxISO);
             NSLog(@"device.exposureTargetOffset = %f",wSelf.device.exposureTargetOffset);
             [wSelf.device unlockForConfiguration];
             wSelf.photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
             [wSelf.photoSettings setFlashMode:wSelf.mode];
             [wSelf.photoOutPut capturePhotoWithSettings:wSelf.photoSettings delegate:wSelf];
//             [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//                 if (imageDataSampleBuffer == NULL) {
//                     return;
//                 }
//                 NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                 self.image = [UIImage imageWithData:imageData];
//                 [self.session stopRunning];
//                 [self saveImageToPhotoAlbum:self.image];
////                 self.imageView = [[UIImageView alloc] initWithFrame:self.previewLayer.frame];
////
////                 [self.view insertSubview:self.imageView belowSubview:self.cameraView.photoButton];
////                 self.imageView.layer.masksToBounds = YES;
////                 self.imageView.image = self.image;
////                 NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
//                 [self cancle];
//             }];
         }];
//        [self cancle];
    } @catch (NSException *exception) {
    
    }
}

#pragma mark - 进入相册
- (void)showPhotoAlbum {
    
    self.photoAlbumController = [[UIImagePickerController alloc] init];
    self.photoAlbumController.delegate = self;
    self.photoAlbumController.allowsEditing = NO;
    self.photoAlbumController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.photoAlbumController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController: self.photoAlbumController animated:NO completion:nil];
}

#pragma mark - 点击关闭按钮
- (void)tapCloseButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击闪光灯按钮
- (void)tapFlashLightbutton:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.cameraView.flashImage setImage:[UIImage imageNamed:@"Camera_flash_selected_image"]];
    } else {
        [self.cameraView.flashImage setImage:[UIImage imageNamed:@"Camera_flashLight_image"]];
    }
    if (self.mode == AVCaptureFlashModeOn) {
        [self setMode:AVCaptureFlashModeOff];
    } else {
        [self setMode:AVCaptureFlashModeOn];
    }
}

#pragma mark - 点击定时器
- (void)tapTimerButton {
    self.clickNumber++;
    if (self.clickNumber == 1) {
        self.cameraView.timerLabel.text = @"3";
        self.cameraView.timerLabel.hidden = NO;
    } else if (self.clickNumber == 2) {
        self.cameraView.timerLabel.text = @"10";
        self.cameraView.timerLabel.hidden = NO;
    } else {
        self.clickNumber = 0;
        self.cameraView.timerLabel.hidden = YES;
    }

}

- (void)judgeHaveTimerAndShutterCamera {
    static NSInteger num = 0;
    if (self.clickNumber == 1) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            num++;
            self.cameraView.centerTimerLabel.hidden = NO;
            self.cameraView.centerTimerLabel.text = [NSString stringWithFormat:@"%ld",4 - num];
            self.view.userInteractionEnabled = NO;
            if (num == 4) {
                [timer invalidate];
                self.view.userInteractionEnabled = YES;
                self.cameraView.centerTimerLabel.hidden = YES;
                [self shutterCamera];
                num = 0;
            }
        }];
    } else if (self.clickNumber == 2) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            num++;
            self.cameraView.centerTimerLabel.hidden = NO;
            self.cameraView.centerTimerLabel.text = [NSString stringWithFormat:@"%ld",11 - num];
            self.view.userInteractionEnabled = NO;
            if (num == 11) {
                [timer invalidate];
                self.view.userInteractionEnabled = YES;
                self.cameraView.centerTimerLabel.hidden = YES;
                [self shutterCamera];
                num = 0;
            }
        }];
    } else {
        [self shutterCamera];
    }
}

#pragma mark - 相机转换
- (void)tapExchangeButton {
    
    CATransition *animation = [CATransition animation];
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";

    if (self.position == AVCaptureDevicePositionBack) {
        self.position = AVCaptureDevicePositionFront;
        animation.subtype = kCATransitionFromRight;
    } else {
        self.position = AVCaptureDevicePositionBack;
        animation.subtype = kCATransitionFromLeft;
    }
    [self.previewLayer addAnimation:animation forKey:nil];
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:self.position];
    if (device) {
        self.device = device;
        AVCaptureDeviceInput *input1 = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        [self.session beginConfiguration];
        [self.session removeInput:self.input];
        if ([self.session canAddInput:input1]) {
            [self.session addInput:input1];
            self.input = input1;
            [self.session commitConfiguration];
        }
    }
}

#pragma mark - 点击调节器
- (void)tapValueButton:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
//        self.iSOValueScrollView.hidden = NO;
        self.isoPickerView.hidden = NO;
        self.isoTitleLabel.hidden = NO;
        self.exposureDurationTitleLabel.hidden = NO;
        self.shutterPickerView.hidden = NO;
        [self.cameraView showView];
    } else {
        [self hiddenValueView];
    }
}

- (void)hiddenValueView {
//        self.iSOValueScrollView.hidden = YES;
    self.isoPickerView.hidden = YES;
    self.isoTitleLabel.hidden = YES;
    self.exposureDurationTitleLabel.hidden = YES;
    self.shutterPickerView.hidden = YES;
    [self.cameraView hiddenView];
}

- (void)updateValueData {
    if (self.shutterStr.length == 0) {
        self.shutterStr = @"0";
    }
    self.cameraView.showShutterValue.text = [NSString stringWithFormat:@"Shutter: %@",self.shutterStr];
    self.cameraView.showISOValue.text = [NSString stringWithFormat:@"ISO: %.0f",self.receivedISOValue == 0 ? 25 : self.receivedISOValue];
}

#pragma mark - 点击蓝牙
- (void)tapblueToothButton {
    
    BlueManagerViewController *blueManagerViewController = [[BlueManagerViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:blueManagerViewController animated:YES];
    
}

- (void)cancle{
//    [self.imageView removeFromSuperview];
//    [self.session startRunning];
    @try {
        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        [device setExposureModeCustomWithDuration:self.firstDuration ISO:self.firstISO completionHandler:^(CMTime syncTime)
         {
             AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
             // 此只读属性的值表示当前场景的计量曝光水平与目标曝光值之间的差异。
             //        [self.mExposureBias setValue:device.exposureTargetOffset];
             
             //手动模式
             //             device.exposureMode=AVCaptureExposureModeCustom;
             
             NSLog(@",%f",device.exposureTargetOffset);
             [device unlockForConfiguration];
             
         }];
        
    } @catch (NSException *exception) {
        
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *imageData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    self.image = [UIImage imageWithData:imageData];
    
    [self saveImageToPhotoAlbum:self.image];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    SCameraPhotoViewController *vc = [[SCameraPhotoViewController alloc]  initWith:image photoURL:url];
    [picker presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - SCameraShutterPickerViewDelegate
- (void)scameraShutterPickerViewDidSelectedRowWithValue:(NSString *)value {
    self.shutterStr = value;
    int64_t values;
    int32_t timescale;
    if ([value isEqualToString:@"1/60"]) {
        values = 1;
        timescale = 60;
    } else if ([value isEqualToString:@"1/35"]) {
        values = 1;
        timescale = 35;
    } else if ([value isEqualToString:@"1/30"]) {
        values = 1;
        timescale = 30;
    } else if ([value isEqualToString:@"1/20"]) {
        values = 1;
        timescale = 20;
    } else {
        values = 1;
        timescale = 10;
    }
    self.currentDuration = CMTimeMake(values, timescale);
    [self updateValueData];
}

#pragma mark - SCameraISOPickerViewDelegate
- (void)scameraISOPickerViewDidSelectedRowWithValue:(NSString *)value {
    //ISO  minISO=29, maxISO=464;  需要多等分
     self.receivedISOValue = [value floatValue];
    [self updateValueData];
    if (_receivedISOValue == 25) {
        self.currentISO = 34.f;
        return;
    } else if (_receivedISOValue == 32) {
        self.currentISO = 50.f;
        return;
    } else if (_receivedISOValue == 40) {
        self.currentISO = 70.f;
        return;
    } else if (_receivedISOValue == 64) {
        self.currentISO = 90.f;
        return;
    } else if (_receivedISOValue == 80) {
        self.currentISO = 120.f;
        return;
    } else if (_receivedISOValue == 100) {
        self.currentISO = 130.f;
        return;
    } else if (_receivedISOValue == 125) {
        self.currentISO = 150.f;
        return;
    } else if (_receivedISOValue == 160) {
        self.currentISO = 170.f;
        return;
    } else if (_receivedISOValue == 200) {
        self.currentISO = 190.f;
        return;
    } else if (_receivedISOValue == 250) {
        self.currentISO = 220.f;
        return;
    } else if (_receivedISOValue == 320) {
        self.currentISO = 240.f;
        return;
    } else if (_receivedISOValue == 400) {
        self.currentISO = 270.f;
        return;
    } else if (_receivedISOValue == 500) {
        self.currentISO = 300.f;
        return;
    } else if (_receivedISOValue == 640) {
        self.currentISO = 330.f;
        return;
    } else if (_receivedISOValue == 800) {
        self.currentISO = 360;
        return;
    } else if (_receivedISOValue == 1000) {
        self.currentISO = 390;
        return;
    } else if (_receivedISOValue == 1250) {
        self.currentISO = 420;
        return;
    } else if (_receivedISOValue == 1500) {
        self.currentISO = 464.f;
        return;
    }
}

#pragma mark - -聚焦
//- (id)focusAtPoint:(CGPoint)point{
//
//    if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
//        NSError *error;
//        if ([self.device lockForConfiguration:&error]) {
//            self.device.focusPointOfInterest = point;
//            self.device.focusMode = AVCaptureFocusModeAutoFocus;
//            [self.device unlockForConfiguration];
//        }
//        return error;
//    }
//    return nil;
//}
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    if (self.cameraView.valueButton.selected) {
        if (point.y > (size.height - 175) || point.y < (ISIphoneX ? 121 : 99)) {
            return;
        } else {
            [self hiddenValueView];
            self.cameraView.valueButton.selected = NO;
        }
    } else {
        if (point.y > (size.height - 140) || point.y < (ISIphoneX ? 86 : 64)) {
            return;
        } else {
            
            [self hiddenValueView];
            self.cameraView.valueButton.selected = NO;
        }
    }
    
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _cameraFocusView.center = point;
        _cameraFocusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _cameraFocusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _cameraFocusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _cameraFocusView.hidden = YES;
            }];
        }];
    }
}

#pragma mark - 曝光时长
- (void)exposureDurationChanged:(id)sender{
    
    UISlider *slider = (UISlider *)sender;
    self.currentDuration = CMTimeMakeWithSeconds(slider.value, 1000000);
    self.exposureDurationValueLabel.text = [NSString stringWithFormat:@"%.0f",slider.value*1000000];
}

#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage {
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}

#pragma - 获取相册图片
- (void)getLatestAsset {

    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        *stop = YES;
        UIImage *image = [UIImage imageWithData:[SCameraViewController getImageFromPHAsset:asset]];
//        [self.photoLibraryButton setImage:image forState:UIControlStateNormal];
    }];
}

+ (NSData *)getImageFromPHAsset:(PHAsset *)asset {
    __block NSData *data;
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             data = [NSData dataWithData:imageData];
         }];
    }
    return data;
}

#pragma - mark 懒加载
- (CameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraView alloc] initWithFrame:CGRectZero];
        _cameraView.topWhiteLine.hidden = YES;
        _cameraView.bottomWhiteLine.hidden = YES;
        [self.view addSubview:_cameraView];
    }
    return _cameraView;
}

- (UILabel *)isoTitleLabel {
    if (!_isoTitleLabel) {
        _isoTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _isoTitleLabel.backgroundColor = [UIColor clearColor];
        _isoTitleLabel.text = @"ISO";
        _isoTitleLabel.hidden = YES;
        _isoTitleLabel.font = [UIFont ChinaBoldFontNameOfSize:14];
        _isoTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_isoTitleLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_isoTitleLabel];
    }
    return _isoTitleLabel;
}

//- (SCameraISOValueScrollView *)iSOValueScrollView {
//
//    if (! _iSOValueScrollView) {
//        _iSOValueScrollView = [[SCameraISOValueScrollView alloc] initWithFrame:CGRectZero];
//        _iSOValueScrollView.hidden = YES;
//        [self.view addSubview:_iSOValueScrollView];
//        [_iSOValueScrollView addObserver:self forKeyPath:@"iSOValue" options:NSKeyValueObservingOptionNew context:nil];
//    }
//
//    return _iSOValueScrollView;
//
//}

- (UILabel *)exposureDurationTitleLabel {
    if (!_exposureDurationTitleLabel) {
        _exposureDurationTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _exposureDurationTitleLabel.backgroundColor = [UIColor clearColor];
        _exposureDurationTitleLabel.text = @"Shuttle";
        _exposureDurationTitleLabel.hidden = YES;
        _exposureDurationTitleLabel.textAlignment = NSTextAlignmentCenter;
        _exposureDurationTitleLabel.font = [UIFont ChinaBoldFontNameOfSize:14];
        [_exposureDurationTitleLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_exposureDurationTitleLabel];
    }
    return _exposureDurationTitleLabel;
}

- (UILabel *)exposureDurationValueLabel {
    if (!_exposureDurationValueLabel) {
        _exposureDurationValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _exposureDurationValueLabel.text = [NSString stringWithFormat:@"%.0f",self.device.exposureDuration.value/(1.0f *self.device.exposureDuration.timescale)*1000000];;
        [_exposureDurationValueLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_exposureDurationValueLabel];
    }
    return _exposureDurationValueLabel;
}

- (UISlider *)exposureDurationSlider {
    if (!_exposureDurationSlider) {
        _exposureDurationSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        [_exposureDurationSlider setContinuous:YES];
        if (self.device) {
            [_exposureDurationSlider setMinimumValue:self.device.activeFormat.minExposureDuration.value/(1.0f*self.device.activeFormat.minExposureDuration.timescale)];
            [_exposureDurationSlider setMaximumValue: self.device.activeFormat.maxExposureDuration.value/ (1.0f * self.device.activeFormat.maxExposureDuration.timescale)];
            [_exposureDurationSlider setValue:self.device.exposureDuration.value/(1.0f *self.device.exposureDuration.timescale)];
        }
        [_exposureDurationSlider addTarget:self action:@selector(exposureDurationChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_exposureDurationSlider];
    }
    return _exposureDurationSlider;
}

- (SCameraShutterPickerView *)shutterPickerView {
    if (!_shutterPickerView) {
        _shutterPickerView = [[SCameraShutterPickerView alloc] initWithFrame:CGRectZero];
        _shutterPickerView.hidden = YES;
        _shutterPickerView.scameraShutterPickerViewDelegate = self;
        [self.view addSubview:_shutterPickerView];
    }
    return _shutterPickerView;
}

- (SCameraISOPickerView *)isoPickerView {
    if (!_isoPickerView) {
        _isoPickerView = [[SCameraISOPickerView alloc] initWithFrame:CGRectZero];
        _isoPickerView.hidden = YES;
        _isoPickerView.scameraISOPickerViewDelegate = self;
        [self.view addSubview:_isoPickerView];
    }
    return _isoPickerView;
}

- (UIImageView *)cameraFocusView {
    if (!_cameraFocusView) {
        _cameraFocusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_focus_image"]];
        _cameraFocusView.backgroundColor = [UIColor clearColor];
        _cameraFocusView.hidden = YES;
        [self.view insertSubview:_cameraFocusView belowSubview:self.cameraView];
    }
    return _cameraFocusView;
}

- (AVCaptureDevice *)device {
    if (!_device) {
        //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCapturePhotoOutput *)photoOutPut {
    
    if (! _photoOutPut) {
        _photoOutPut = [[AVCapturePhotoOutput alloc] init];
    }
    return _photoOutPut;
    
}

//- (AVCaptureStillImageOutput *)ImageOutPut {
//    if (!_ImageOutPut) {
//        _ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
//    }
//    return _ImageOutPut;
//}

//生成会话，用来结合输入输出
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (void)dealloc {
    
}

@end

