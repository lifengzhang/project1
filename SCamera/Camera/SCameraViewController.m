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
#import "SCameraTimerView.h"
#import "SCameraFlashLightStatusView.h"
#import "CameraView.h"

#import "SCameraShutterPickerView.h"

#import "SCameraISOPickerView.h"

#import "SCameraPictureViewController.h"

#define CANCELBUTTON_DISTANCE_TOP                                              Height_Screen - 100
#define CANCELBUTTON_DISTANCE_LEFT                                             Width_Screen*1/4.0 - 30
#define CANCELBUTTON_WIDTH_HEIGHT                                              60.f

#define EXPOSUREDURATIONTITLELABEL_DISTANCE_TOP                                Height_Screen - 176
#define EXPOSUREDURATIONTITLELABEL_DISTANCE_LEFT                               20.f
#define EXPOSUREDURATIONTITLELABEL_WIDTH                                       80.f
#define EXPOSUREDURATIONTITLELABEL_HEIGHT                                      30.f

#define EXPOSUREDURATIONVALUELABEL_DISTANCE_TOP                                Height_Screen - 190
#define EXPOSUREDURATIONVALUELABEL_DISTANCE_LEFT                               100.f
#define EXPOSUREDURATIONVALUELABEL_WIDTH                                       100.f
#define EXPOSUREDURATIONVALUELABEL_HEIGHT                                      30.f

#define EXPOSUREDURATIONSLIDER_DISTANCE_TOP                                    Height_Screen - 150
#define EXPOSUREDURATIONSLIDER_DISTANCE_LEFT                                   20.f
#define EXPOSUREDURATIONSLIDER_WIDTH                                           Width_Screen - 40
#define EXPOSUREDURATIONSLIDER_HEIGHT                                          30.f


#define ISOTITLELABEL_DISTANCE_TOP                                             110.f
#define ISOTITLELABEL_DISTANCE_LEFT                                            20.f
#define ISOTITLELABEL_WIDTH                                                    84.f
#define ISOTITLELABEL_HEIGHT                                                   35.f

@interface SCameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate,AVCaptureFileOutputRecordingDelegate, SCameraShutterPickerViewDelegate, UIGestureRecognizerDelegate, SCameraISOPickerViewDelegate>

@property(nonatomic,strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureSession* session; //AVCapturemSession对象来执行输入设备和输出设备之间的数据传递

//@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutPut;

@property (nonatomic, strong) AVCapturePhotoOutput *photoOutPut; //ios 10

@property (nonatomic, strong) AVCapturePhotoSettings *photoSettings; //ios 10

@property (nonatomic, strong) AVCaptureMovieFileOutput *deviceMovieFileOutput;

@property (nonatomic, assign) BOOL isAnewRecording; //重新录制视频

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *exposureDurationTitleLabel;

@property (nonatomic, strong) UILabel *exposureDurationValueLabel;

//@property (nonatomic, strong) UISlider *exposureDurationSlider;

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

@property (nonatomic, strong) SCameraISOPickerView *isoPickerView;

@property (nonatomic, strong) UIImageView *cameraFocusView;  //聚焦视图

@property (nonatomic, assign) float receivedISOValue;

@property (nonatomic, strong) AVCaptureDeviceInput *input;

@property (nonatomic, assign) AVCaptureDevicePosition position;

@property (nonatomic, assign) float deviceMinISO; //设备最小ISO

@property (nonatomic, assign) float deviceMaxISO; //设备最大ISO

@property (nonatomic, strong) SCameraTimerView *timerView; //定时器选择视图

@property (nonatomic, strong) UIView *backgroundView; //定时器动画背景

@property (nonatomic, assign) ScameraTimer timer;

@property (nonatomic, assign) SCameraFlashLightStatus flashlightStatus;

@property (nonatomic, strong) UIImageView *animationBegin; //起始动画

@property (nonatomic, strong) UIImageView *animationEnd;   //结束动画

@property (nonatomic, strong) SCameraFlashLightStatusView *flashLightStatusView;

@property (nonatomic, strong) NSArray *splitImageArr;    //视频分离照片集

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
    
    [self.timerView.timerBtn addTarget:self action:@selector(tapTimerLogo) forControlEvents:UIControlEventTouchUpInside];
    [self.timerView.closeBtn addTarget:self action:@selector(tapClosebtn) forControlEvents:UIControlEventTouchUpInside];
    [self.timerView.threeSeconds addTarget:self action:@selector(tapSelectedThreeSecond) forControlEvents:UIControlEventTouchUpInside];
    [self.timerView.tenSeconds addTarget:self action:@selector(tapSelectedTen) forControlEvents:UIControlEventTouchUpInside];
    
    [self.flashLightStatusView.flashlightBtn addTarget:self action:@selector(tapFlashlightLogo) forControlEvents:UIControlEventTouchUpInside];
    [self.flashLightStatusView.selectAuto addTarget:self action:@selector(tapFlashlightAuto) forControlEvents:UIControlEventTouchUpInside];
    [self.flashLightStatusView.selectOpen addTarget:self action:@selector(tapFlashlightOpen) forControlEvents:UIControlEventTouchUpInside];
    [self.flashLightStatusView.selectClose addTarget:self action:@selector(tapFlashlightClose) forControlEvents:UIControlEventTouchUpInside];
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
    self.timer = selectedCloseBtn;
    self.flashlightStatus = flashligtClose;
    self.deviceMinISO = self.device.activeFormat.minISO;
    self.deviceMaxISO = self.device.activeFormat.maxISO;
    //使用设备初始化输入
    self.position = AVCaptureDevicePositionBack;
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    //输出视频
    self.deviceMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:self.deviceMovieFileOutput]) {
        [self.session addOutput:self.deviceMovieFileOutput];
    }

////     6. 连接输出与会话
//    if ([self.session canAddOutput:self.photoOutPut]) {
//        [self.session addOutput:self.photoOutPut];
//    }
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, Width_Screen, Height_Screen - 140);
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
    
    [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.mas_equalTo(ISIphoneX ? 88 : 64);
    }];

    [self.flashLightStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.mas_equalTo(ISIphoneX ? 88 : 64);
    }];
    
    self.isoPickerView.frame = CGRectMake(76, ISIphoneX ? 87 : 65, Width_Screen - 152, 35);
    self.shutterPickerView.frame = CGRectMake(76, Height_Screen - 176, Width_Screen - 152, 35);
    
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
        
        CGFloat maxScaleAndCropFactor = [[self.photoOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];

        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
        AVCaptureConnection * videoConnection = [self.photoOutPut connectionWithMediaType:AVMediaTypeVideo];
        [videoConnection setVideoScaleAndCropFactor:self.effectiveScale];
        
    }
    

}

#pragma mark - 截取照片
- (void) shutterCamera
{
    @try {
        [self.device lockForConfiguration:nil];
        
        __weak SCameraViewController *wSelf = self;
        [self.device setExposureModeCustomWithDuration:(self.shutterStr.length == 0) ? CMTimeMake(1,60) : self.currentDuration ISO:self.currentISO == 0 ? self.deviceMinISO : self.currentISO completionHandler:^(CMTime syncTime)
         {

             NSLog(@"device.ISO = %f",wSelf.device.ISO);
             NSLog(@"device.minISO = %f",wSelf.device.activeFormat.minISO);
             NSLog(@"device.maxISO = %f",wSelf.device.activeFormat.maxISO);
             NSLog(@"device.exposureTargetOffset = %f",wSelf.device.exposureTargetOffset);
             [wSelf.device unlockForConfiguration];
             wSelf.photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
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
    self.photoAlbumController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController: self.photoAlbumController animated:NO completion:nil];
}

#pragma mark - 点击关闭按钮
- (void)tapCloseButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击闪光灯按钮
- (void)tapFlashLightbutton:(UIButton *)btn {
    self.backgroundView.hidden = NO;
    self.cameraView.navigationView.hidden = YES;
    
    self.animationBegin = [[UIImageView alloc] initWithFrame:self.cameraView.flashImage.frame];
    if (self.flashlightStatus == flashlighOpen || self.flashLightStatusView.selectOpen.selected) {
        self.animationBegin.image = [UIImage imageNamed:@"Camera_flash_selected_image"];
        self.flashLightStatusView.flashlightLogo.image = [UIImage imageNamed:@"Camera_flash_selected_image"];
    } else {
        self.animationBegin.image = [UIImage imageNamed:@"Camera_flashLight_image"];
        self.flashLightStatusView.flashlightLogo.image = [UIImage imageNamed:@"Camera_flashLight_image"];
    }
    [self.view addSubview:self.animationBegin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"position";
    move.fromValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.flashImage.center.x, self.cameraView.timerImage.center.y, 18, 18)];
    move.toValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.closeImage.center.x, self.cameraView.closeImage.center.y, 18, 18)];
    move.duration = 0.2;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    [self.animationBegin.layer addAnimation:move forKey:nil];
    [self performSelector:@selector(delayUpdateFlashlightStatusView) withObject:nil afterDelay:0.2];
}

- (void)delayUpdateFlashlightStatusView {
    self.flashLightStatusView.hidden = NO;
    self.animationBegin.hidden = YES;
    
}

- (void)tapFlashlightLogo {
    self.flashlightStatus = flashlightLogo;
    [self backFlashlightAnimation];
}

- (void)tapFlashlightAuto {
    self.flashlightStatus = flashligtAuto;
    self.flashLightStatusView.selectAuto.selected = YES;
    self.flashLightStatusView.selectClose.selected = NO;
    self.flashLightStatusView.selectOpen.selected = NO;

    [self.device lockForConfiguration:nil];
    if ([self.device hasTorch]) {
        self.device.torchMode = AVCaptureTorchModeAuto;
    }
    [self.device unlockForConfiguration];
    if ([self.device isTorchActive]) {
        [self.cameraView.flashImage setImage:[UIImage imageNamed:@"Camera_flash_selected_image"]];
    } else {
        [self.cameraView.flashImage setImage:[UIImage imageNamed:@"Camera_flashLight_image"]];
    }
    [self backFlashlightAnimation];
}

- (void)tapFlashlightOpen {
    self.flashlightStatus = flashlighOpen;
    self.flashLightStatusView.selectAuto.selected = NO;
    self.flashLightStatusView.selectClose.selected = NO;
    self.flashLightStatusView.selectOpen.selected = YES;
    [self.cameraView.flashImage setImage:[UIImage imageNamed:@"Camera_flash_selected_image"]];
    
    [self.device lockForConfiguration:nil];
    if ([self.device hasTorch]) {
        self.device.torchMode = AVCaptureTorchModeOn;
    }
    [self.device unlockForConfiguration];
    
    [self backFlashlightAnimation];
}

- (void)tapFlashlightClose {
    self.flashlightStatus = flashligtClose;
    self.flashLightStatusView.selectAuto.selected = NO;
    self.flashLightStatusView.selectClose.selected = YES;
    self.flashLightStatusView.selectOpen.selected = NO;
    [self.cameraView.flashImage setImage:[UIImage imageNamed:@"Camera_flashLight_image"]];
    
    [self.device lockForConfiguration:nil];
    if ([self.device hasTorch]) {
        self.device.torchMode = AVCaptureTorchModeOff;
    }
    [self.device unlockForConfiguration];
    
    [self backFlashlightAnimation];
}

- (void)backFlashlightAnimation {
    
    self.flashLightStatusView.hidden = YES;
    self.animationEnd = [[UIImageView alloc] initWithFrame:self.cameraView.flashImage.frame];
    if (self.flashlightStatus == flashlighOpen) {
        self.animationEnd.image = [UIImage imageNamed:@"Camera_flash_selected_image"];
    } else {
        self.animationEnd.image = [UIImage imageNamed:@"Camera_flashLight_image"];
    }
    [self.view addSubview:self.animationEnd];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"position";
    move.toValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.flashImage.center.x, self.cameraView.timerImage.center.y, 18, 18)];
    move.fromValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.closeImage.center.x, self.cameraView.closeImage.center.y, 18, 18)];
    move.duration = 0.2;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    [self.animationEnd.layer addAnimation:move forKey:nil];
    [self performSelector:@selector(delayBackFlashlightAnimation) withObject:nil afterDelay:0.2];
}

- (void)delayBackFlashlightAnimation {
    self.backgroundView.hidden = YES;
    self.cameraView.navigationView.hidden = NO;
    self.animationEnd.hidden = YES;
}

#pragma mark - 点击定时器
- (void)tapTimerButton {
    self.cameraView.navigationView.hidden = YES;
    self.backgroundView.hidden = NO;
    
    self.animationBegin = [[UIImageView alloc] initWithFrame:self.cameraView.timerImage.frame];
    self.animationBegin.image = [UIImage imageNamed:@"Camera_timer_image"];
    [self.view addSubview:self.animationBegin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"position";
    move.fromValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.timerImage.center.x, self.cameraView.timerImage.center.y, 18, 18)];
    move.toValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.closeImage.center.x, self.cameraView.closeImage.center.y, 18, 18)];
    move.duration = 0.2;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    [self.animationBegin.layer addAnimation:move forKey:nil];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.2];
    
}

- (void)delayMethod {
    self.timerView.hidden = NO;
    self.animationBegin.hidden = YES;
}

- (void)judgeHaveTimerAndShutterCamera {
    static NSInteger num = 0;
    if (self.timer == selectedThree) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            num++;
            self.cameraView.centerTimerLabel.hidden = NO;
            self.cameraView.centerTimerLabel.text = [NSString stringWithFormat:@"%ld",4 - num];
            self.view.userInteractionEnabled = NO;
            if (num == 4) {
                [timer invalidate];
                self.view.userInteractionEnabled = YES;
                self.cameraView.centerTimerLabel.hidden = YES;
//                [self shutterCamera];
                [self shutterVideo];
                num = 0;
            }
        }];
    } else if (self.timer == selectedTen) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            num++;
            self.cameraView.centerTimerLabel.hidden = NO;
            self.cameraView.centerTimerLabel.text = [NSString stringWithFormat:@"%ld",11 - num];
            self.view.userInteractionEnabled = NO;
            if (num == 11) {
                [timer invalidate];
                self.view.userInteractionEnabled = YES;
                self.cameraView.centerTimerLabel.hidden = YES;
//                [self shutterCamera];
                [self shutterVideo];
                num = 0;
            }
        }];
    } else {
//        [self shutterCamera];
        [self shutterVideo];
        
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
        //变化设备要重新获取ISO值
        self.deviceMinISO = self.device.activeFormat.minISO;
        self.deviceMaxISO = self.device.activeFormat.maxISO;
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
        self.cameraView.valueImage.alpha = 0.64;
//        self.iSOValueScrollView.hidden = NO;
        self.isoPickerView.hidden = NO;
        self.isoTitleLabel.hidden = NO;
        self.exposureDurationTitleLabel.hidden = NO;
        self.shutterPickerView.hidden = NO;
        [self.cameraView showView];
    } else {
        self.cameraView.valueImage.alpha = 1.0;
        [self hiddenValueView];
    }
}

- (void)hiddenValueView {
//        self.iSOValueScrollView.hidden = YES;
    self.cameraView.valueImage.alpha = 1.0;
    self.isoPickerView.hidden = YES;
    self.isoTitleLabel.hidden = YES;
    self.exposureDurationTitleLabel.hidden = YES;
    self.shutterPickerView.hidden = YES;
    [self.cameraView hiddenView];
}

- (void)updateValueData {
    if (self.shutterStr.length == 0) {
        self.shutterStr = @"1/60";
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
             NSLog(@",%f",device.exposureTargetOffset);
             [device unlockForConfiguration];
             
         }];
        
    } @catch (NSException *exception) {
        
    }
}

#pragma maek - 关闭定时器
- (void)tapTimerLogo {
    self.timer = selectedTimerLogo;
    [self backAnimation];
}

- (void)tapClosebtn {
    self.timer = selectedCloseBtn;
    self.timerView.closeBtn.selected = YES;
    self.timerView.threeSeconds.selected = NO;
    self.timerView.tenSeconds.selected = NO;
    self.cameraView.timerLabel.hidden = YES;
    [self backAnimation];
}

- (void)tapSelectedThreeSecond {
    self.timer = selectedThree;
    self.timerView.threeSeconds.selected = YES;
    self.timerView.closeBtn.selected = NO;
    self.timerView.tenSeconds.selected = NO;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"3s"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:243.0/255.0 green:194.0/255. blue:0/255.0 alpha:1.0] range:NSMakeRange(0, 2)];
    [string addAttribute:NSFontAttributeName value:[UIFont ChinaDefaultFontNameOfSize:13.f] range:NSMakeRange(0, 1)];
    [string addAttribute:NSFontAttributeName value:[UIFont ChinaDefaultFontNameOfSize:10.0] range:NSMakeRange(1, 1)];
    [self.cameraView.timerLabel setAttributedText:string];
    self.cameraView.timerLabel.hidden = NO;
    [self backAnimation];
}

- (void)tapSelectedTen {
    self.timer = selectedTen;
    self.timerView.tenSeconds.selected = YES;
    self.timerView.threeSeconds.selected = NO;
    self.timerView.closeBtn.selected = NO;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"10s"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:243.0/255.0 green:194.0/255. blue:0/255.0 alpha:1.0] range:NSMakeRange(0, 3)];
    [string addAttribute:NSFontAttributeName value:[UIFont ChinaDefaultFontNameOfSize:13.f] range:NSMakeRange(0, 2)];
    [string addAttribute:NSFontAttributeName value:[UIFont ChinaDefaultFontNameOfSize:10.0] range:NSMakeRange(2, 1)];
    [self.cameraView.timerLabel setAttributedText:string];
    self.cameraView.timerLabel.hidden = NO;
    [self backAnimation];
}

- (void)backAnimation {
    self.timerView.hidden = YES;

    self.animationEnd = [[UIImageView alloc] initWithFrame:self.cameraView.timerImage.frame];
    self.animationEnd.image = [UIImage imageNamed:@"Camera_timer_image"];
    [self.view addSubview:self.animationEnd];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    CABasicAnimation *move = [CABasicAnimation animation];
    move.keyPath = @"position";
    move.toValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.timerImage.center.x, self.cameraView.timerImage.center.y, 18, 18)];
    move.fromValue = [NSValue valueWithCGRect:CGRectMake(self.cameraView.closeImage.center.x, self.cameraView.closeImage.center.y, 18, 18)];
    move.duration = 0.2;
    move.fillMode = kCAFillModeForwards;
    move.removedOnCompletion = NO;
    [self.animationEnd.layer addAnimation:move forKey:nil];
    [self performSelector:@selector(delayMethodBackAnimation) withObject:nil afterDelay:0.2];
    
}

- (void)delayMethodBackAnimation {
    self.backgroundView.hidden = YES;
    self.cameraView.navigationView.hidden = NO;
    self.animationEnd.hidden = YES;
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)output didCapturePhotoForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
    [BTMe SplightFire];
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *imageData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    self.image = [UIImage imageWithData:imageData];
    
    SCameraPictureViewController *vc = [[SCameraPictureViewController alloc] initWithPicture:self.image];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma  mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"完成录制");
    NSLog(@"录制地址outputFileURL = %@",outputFileURL);
    
    //视频存入相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
    }];
    
    //重新录制
    if (self.isAnewRecording) {
        //删除视频文件
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:outputFileURL.absoluteString error:nil];
    }
    //不取消录制
    else{
        //获取视频时长
        AVURLAsset *avUrl = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
        CMTime time = [avUrl duration];
        int seconds = ceil(time.value/time.timescale);
        NSLog(@"录制时间 seconds = %d",seconds);
         //分离视频成图片
        [CameraManager splitVideo:outputFileURL fps:30 splitCompleteBlock:^(BOOL success, NSMutableArray *splitimgs) {
                if (success && splitimgs.count != 0) {
                    NSLog(@"----->> success");
                    NSLog(@"照片总数---> splitimgs个数:%lu",(unsigned long)splitimgs.count);
                    self.splitImageArr = [NSArray arrayWithArray:splitimgs];
                    UIImage *image = splitimgs[1];
                    //照片存入相册
                UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingWithError:contextInfo:),(__bridge void*)self);
                }
        }];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"完成照片存储image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - 视频操作
//开始录制视频
- (void)takePhoto:(NSURL *)fileURL{
    [self.deviceMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}

////结束录制
//- (UIImageView *)finishRecord:(UIView *)view isAnewRecording:(BOOL)anewRecording{
//    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:view.bounds];
//    [view addSubview:gifImageView];
//    self.isAnewRecording = anewRecording; //存储是否重新录制
//    //停止录制(停止录制后做代理方法)
//    [self.deviceMovieFileOutput stopRecording];
//    return gifImageView;
//}

- (void)finishRecordVideo {
    [self.deviceMovieFileOutput stopRecording];
}

- (void)shutterVideo {
    
    [self.device lockForConfiguration:nil];
    
    __weak SCameraViewController *wSelf = self;
    [self.device setExposureModeCustomWithDuration:(self.shutterStr.length == 0) ? CMTimeMake(1,60) : self.currentDuration ISO:self.currentISO == 0 ? self.deviceMinISO : self.currentISO completionHandler:^(CMTime syncTime)
     {
         NSLog(@"device.ISO = %f",wSelf.device.ISO);
         //开始拍摄
         [wSelf takePhoto:[NSURL fileURLWithPath:[wSelf getVideoSaveFilePath]]];
         [wSelf performSelector:@selector(finishRecordVideo) withObject:nil afterDelay:2.0];
     }];
}

//视频储存路径
- (NSString *)getVideoSaveFilePath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"video.mp4"];
    return filePath;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"image info %@",info);
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

    self.receivedISOValue = [value floatValue];
    [self updateValueData];
   NSArray *isoArray = @[@"25",@"32",@"40",@"64",@"80",@"100",@"125",@"160",@"200",@"250",@"320",@"400",@"500",@"640",@"800",@"1000",@"1250",@"1500"];
    //每个isoArray[i]对应的增量
    float increaseISO = (self.deviceMaxISO - self.deviceMinISO)/(isoArray.count - 1);
    for (int i = 0; i < isoArray.count; i++) {
        if (i == 17 && self.receivedISOValue == [isoArray[17] floatValue]) {
            self.currentISO = self.deviceMaxISO;
            return;
        } else {
            if (self.receivedISOValue == [isoArray[i] floatValue]) {
                self.currentISO = self.deviceMinISO + i*increaseISO;
                return;
            }
        }
    }
}

#pragma mark - -聚焦
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
        self.cameraFocusView.center = point;
        self.cameraFocusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.cameraFocusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.cameraFocusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.cameraFocusView.hidden = YES;
            }];
        }];
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
//        UIImage *image = [UIImage imageWithData:[SCameraViewController getImageFromPHAsset:asset]];
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

- (SCameraTimerView *)timerView {
    if (!_timerView) {
        _timerView = [[SCameraTimerView alloc] initWithFrame:CGRectZero];
        _timerView.hidden = YES;
        [self.view addSubview:_timerView];
    }
    return _timerView;
}

- (SCameraFlashLightStatusView *)flashLightStatusView {
    if (!_flashLightStatusView) {
        _flashLightStatusView = [[SCameraFlashLightStatusView alloc] initWithFrame:CGRectZero];
        _flashLightStatusView.hidden = YES;
        [self.view addSubview:_flashLightStatusView];
    }
    return _flashLightStatusView;
}


//动画背景
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, (ISIphoneX ? 88 : 64))];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24];
        _backgroundView.hidden = YES;
        [self.view insertSubview:_backgroundView belowSubview:self.timerView];
    }
    return _backgroundView;
}
- (void)dealloc {
    
}

@end

