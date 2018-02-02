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

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#define BACKBUTTON_DISTANCE_TOP                                                0.f
#define BACKBUTTON_DISTANCE_LEFT                                               20.f
#define BACKBUTTON_WIDTH_HEIGHT                                                40.f

#define PHOTOBUTTON_DISTANCE_TOP                                               kScreenHeight - 100
#define PHOTOBUTTON_DISTANCE_LEFT                                              kScreenWidth*1/2.0 - 30
#define PHOTOBUTTON_WIDTH_HEIGHT                                               60.f

#define PHOTOLIBRARYBUTTON_DISTANCE_TOP                                        kScreenHeight - 100
#define PHOTOLIBRARYBUTTON_DISTANCE_LEFT                                       30.f
#define PHOTOLIBRARYBUTTON_WIDTH_HEIGHT                                        60.f

#define CANCELBUTTON_DISTANCE_TOP                                              kScreenHeight - 100
#define CANCELBUTTON_DISTANCE_LEFT                                             kScreenWidth*1/4.0 - 30
#define CANCELBUTTON_WIDTH_HEIGHT                                              60.f

#define EXPOSUREDURATIONTITLELABEL_DISTANCE_TOP                                kScreenHeight - 190
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


#define ISOTITLELABEL_DISTANCE_TOP                                             70.f
#define ISOTITLELABEL_DISTANCE_LEFT                                            20.f
#define ISOTITLELABEL_WIDTH                                                    50.f
#define ISOTITLELABEL_HEIGHT                                                   30.f

#define ISOVALUELABEL_DISTACE_TOP                                              70.f
#define ISOVALUELABEL_DISTACE_LEFT                                             75.f
#define ISOVALUELABEL_WIDTH                                                    100.f
#define ISOVALUELABEL_HEIGHT                                                   30.f

#define ISOSLIDER_DISTANCE_TOP                                                 110.f
#define ISOSLIDER_DISTANCE_LEFT                                                20.f
#define ISOSLIDER_WIDTH                                                        kScreenWidth - 40
#define ISOSLIDER_HEIGHT                                                       30.f

@interface SCameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong) AVCaptureDevice *device;;

@property (nonatomic, strong) AVCaptureSession* session; //AVCapturemSession对象来执行输入设备和输出设备之间的数据传递

@property (nonatomic, strong) AVCaptureStillImageOutput *ImageOutPut;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *photoButton;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *photoLibraryButton;

@property (nonatomic, strong) UILabel *exposureDurationTitleLabel;

@property (nonatomic, strong) UILabel *exposureDurationValueLabel;

@property (nonatomic, strong) UISlider *exposureDurationSlider;

@property (nonatomic, strong) UILabel *isoTitleLabel;

@property (nonatomic, strong) UILabel *isoValueLabel;

@property (nonatomic, strong) UISlider *isoSlider;

@property (nonatomic, assign) CMTime firstDuration;

@property (nonatomic, assign) CMTime currentDuration;

@property (nonatomic, assign) CGFloat firstISO;

@property (nonatomic, assign) CGFloat currentISO;

@property (nonatomic, assign) AVCaptureExposureMode exposureMode;

@property (nonatomic, strong) UIImagePickerController *photoAlbumController;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer; //预览图层

@property (nonatomic, strong) UIView *focusView;

@property (nonatomic, assign) BOOL isHiddenStatus;

@property (nonatomic, strong) UIButton *flashLight; //闪光灯按钮

@property (nonatomic, strong) UIView *flashLightView; //闪光灯选项视图

@property (nonatomic, strong) UIButton *flashLightAuto; //闪光灯自动按钮

@property (nonatomic, strong) UIButton *flashLightON; //闪光灯打开按钮

@property (nonatomic, strong) UIButton *flashLightOff; //闪光灯关闭按钮

@end

@implementation SCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customCamera];
    [self customUI];
    [self getLatestAsset];
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
    self.isHiddenStatus = YES;
    [self getLatestAsset];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)addGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isHiddenStatus;
}

- (void)customCamera{
    self.view.backgroundColor = [UIColor blackColor];
    self.flashLightView.hidden = YES;
    //使用设备初始化输入
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //开始启动
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        self.firstISO = self.device.ISO;
        self.currentISO = self.device.ISO;
        
        self.firstDuration = self.device.exposureDuration;
        self.currentDuration = self.device.exposureDuration;
        [_device unlockForConfiguration];
    }
}

- (void)customUI{
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(BACKBUTTON_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(BACKBUTTON_DISTANCE_LEFT);
        make.width.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.flashLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.backButton.mas_right).offset(20);
        make.height.mas_equalTo(BACKBUTTON_WIDTH_HEIGHT);
        make.width.mas_equalTo(60);
    }];
    
    [self.flashLightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.flashLight.mas_right);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.view);
    }];
    
    [self.flashLightAuto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.flashLightView);
        make.width.mas_equalTo(50);
        make.left.equalTo(self.flashLightView).offset(10);
    }];
    
    [self.flashLightON mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.flashLightView);
        make.width.mas_equalTo(50);
        make.left.equalTo(self.flashLightAuto.mas_right).offset(10);
    }];
    
    [self.flashLightOff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.flashLightView);
        make.width.mas_equalTo(50);
        make.left.equalTo(self.flashLightON.mas_right).offset(10);
    }];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PHOTOBUTTON_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(PHOTOBUTTON_DISTANCE_LEFT);
        make.width.height.mas_equalTo(PHOTOBUTTON_WIDTH_HEIGHT);
    }];
    
    [self.photoLibraryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PHOTOLIBRARYBUTTON_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(PHOTOLIBRARYBUTTON_DISTANCE_LEFT);
        make.width.height.mas_equalTo(PHOTOLIBRARYBUTTON_WIDTH_HEIGHT);
    }];
    
//    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(CANCELBUTTON_DISTANCE_TOP);
//        make.left.equalTo(self.view).offset(CANCELBUTTON_DISTANCE_LEFT);
//        make.width.height.mas_equalTo(CANCELBUTTON_WIDTH_HEIGHT);
//    }];
    
    [self.exposureDurationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(EXPOSUREDURATIONTITLELABEL_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(EXPOSUREDURATIONTITLELABEL_DISTANCE_LEFT);
        make.width.mas_equalTo(EXPOSUREDURATIONTITLELABEL_WIDTH);
        make.height.mas_equalTo(EXPOSUREDURATIONTITLELABEL_HEIGHT);
    }];
    
    [self.exposureDurationValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(EXPOSUREDURATIONVALUELABEL_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(EXPOSUREDURATIONVALUELABEL_DISTANCE_LEFT);
        make.width.mas_equalTo(EXPOSUREDURATIONVALUELABEL_WIDTH);
        make.height.mas_equalTo(EXPOSUREDURATIONVALUELABEL_HEIGHT);
    }];
    
    [self.exposureDurationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(EXPOSUREDURATIONSLIDER_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(EXPOSUREDURATIONSLIDER_DISTANCE_LEFT);
        make.width.mas_equalTo(EXPOSUREDURATIONSLIDER_WIDTH);
        make.height.mas_equalTo(EXPOSUREDURATIONSLIDER_HEIGHT);
    }];
    
    [self.isoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISOTITLELABEL_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(ISOTITLELABEL_DISTANCE_LEFT);
        make.width.mas_equalTo(ISOTITLELABEL_WIDTH);
        make.height.mas_equalTo(ISOTITLELABEL_HEIGHT);
    }];
    
    [self.isoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISOVALUELABEL_DISTACE_TOP);
        make.left.equalTo(self.view).offset(ISOVALUELABEL_DISTACE_LEFT);
        make.width.mas_equalTo(ISOVALUELABEL_WIDTH);
        make.height.mas_equalTo(ISOVALUELABEL_HEIGHT);
    }];
    
    [self.isoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISOSLIDER_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(ISOSLIDER_DISTANCE_LEFT);
        make.width.mas_equalTo(ISOSLIDER_WIDTH);
        make.height.mas_equalTo(ISOSLIDER_HEIGHT);
    }];

    [self.focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.height.width.mas_equalTo(80);
    }];
    
}

#pragma mark - 截取照片
- (void) shutterCamera
{
    UIView *blackView = [[UIView alloc] initWithFrame:self.previewLayer.frame];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:blackView belowSubview:self.photoButton];
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
//    @try {
//
//        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        [device lockForConfiguration:nil];
//        [device setExposureModeCustomWithDuration:self.currentDuration ISO:self.currentISO completionHandler:^(CMTime syncTime)
//         {
//             AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//
//             NSLog(@",%f",device.exposureTargetOffset);
//             [device unlockForConfiguration];
//
//             [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//                 if (imageDataSampleBuffer == NULL) {
//                     return;
//                 }
//                 NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                 self.image = [UIImage imageWithData:imageData];
//                 [self.session stopRunning];
//                 [self saveImageToPhotoAlbum:self.image];
//                 self.imageView = [[UIImageView alloc] initWithFrame:self.previewLayer.frame];
//                 [self.view insertSubview:self.imageView belowSubview:self.photoButton];
//                 self.imageView.layer.masksToBounds = YES;
//                 self.imageView.image = self.image;
//                 NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
//
//             }];
//         }];
//    } @catch (NSException *exception) {
//
//    }
    self.photoLibraryButton.backgroundColor = [UIColor blackColor];
    [self.photoLibraryButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self saveImageToPhotoAlbum:self.image];
        [self.photoLibraryButton setImage:self.image forState:UIControlStateNormal];
        [blackView removeFromSuperview];

    }];
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openFlashLight {
    self.flashLight.selected = !self.flashLight.selected;
    if ([_device lockForConfiguration:nil]) {
        if (_device.focusMode == 1) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
            }
        }
        
        [_device unlockForConfiguration];
    }
}

- (void)seleteFlashLightMode:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.device lockForConfiguration:nil];
    switch (btn.tag) {
        case SCameraFlashLightAuto:
            if (self.flashLightAuto.selected) {
                self.flashLightON.selected = NO;
                self.flashLightOff.selected = NO;
                if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                    [self.device setFlashMode:AVCaptureFlashModeAuto];
                }
            } else {
                self.flashLightAuto.selected = YES;
            }
            self.flashLight.selected = NO;
            self.flashLightView.hidden = YES;
            [_device unlockForConfiguration];
            break;
            case SCameraFlashLightOn:
            if (self.flashLightON.selected) {
                self.flashLightAuto.selected = NO;
                self.flashLightOff.selected = NO;
                self.flashLight.selected = NO;
                self.flashLightView.hidden = YES;
                if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                    [_device setFlashMode:AVCaptureFlashModeOn];
                }
            }
            [_device unlockForConfiguration];
            break;
            case SCameraFlashLightOff:
            if (self.flashLightOff.selected) {
                self.flashLightAuto.selected = NO;
                self.flashLightON.selected = NO;
                self.flashLight.selected = NO;
                self.flashLightView.hidden = YES;
                if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                    [_device setFlashMode:AVCaptureFlashModeOff];
                }
            }
            [_device unlockForConfiguration];
            break;
        default:
            break;
    }
}

- (void)openFlashLightView {
    
    self.flashLight.selected = !self.flashLight.selected;
    
    if (self.flashLight.selected) {
        self.flashLightView.hidden = NO;
    } else {
        self.flashLightView.hidden = YES;
    }
}

- (void)cancle{
    [self.imageView removeFromSuperview];
    [self.session startRunning];
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

#pragma maek - 聚焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
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
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
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

#pragma mark - ISO
- (void)isoChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    self.currentISO = slider.value;
    self.isoValueLabel.text = [NSString stringWithFormat:@"%.4f",self.currentISO];
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
        PHAsset *asset = [result lastObject];
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        *stop = YES;
        UIImage *image = [UIImage imageWithData:[SCameraViewController getImageFromPHAsset:asset]];
        [self.photoLibraryButton setImage:image forState:UIControlStateNormal];
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
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _backButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)flashLight {
    if (!_flashLight) {
        _flashLight = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashLight.titleLabel.textAlignment = NSTextAlignmentCenter;
        _flashLight.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_flashLight setTitle:@"闪光灯" forState:UIControlStateNormal];
        [_flashLight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flashLight setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [_flashLight addTarget:self action:@selector(openFlashLightView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_flashLight];
    }
    return _flashLight;
}

- (UIView *)flashLightView {
    if (!_flashLightView) {
        _flashLightView = [[UIView alloc] initWithFrame:CGRectZero];
        _flashLightView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_flashLightView];
    }
    return _flashLightView;
}

- (UIButton *)flashLightAuto {
    if (!_flashLightAuto) {
        _flashLightAuto = [[UIButton alloc] initWithFrame:CGRectZero];
        _flashLightAuto.titleLabel.textAlignment = NSTextAlignmentCenter;
        _flashLightAuto.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _flashLightAuto.tag = SCameraFlashLightAuto;
        _flashLightAuto.selected = YES;
        [_flashLightAuto setTitle:@"自动" forState:UIControlStateNormal];
        [_flashLightAuto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flashLightAuto setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [_flashLightAuto addTarget:self action:@selector(seleteFlashLightMode:) forControlEvents:UIControlEventTouchUpInside];
        [self.flashLightView addSubview:_flashLightAuto];
    }
    return _flashLightAuto;
}

- (UIButton *)flashLightON {
    if (!_flashLightON) {
        _flashLightON = [[UIButton alloc] initWithFrame:CGRectZero];
        _flashLightON.titleLabel.textAlignment = NSTextAlignmentCenter;
        _flashLightON.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _flashLightON.tag = SCameraFlashLightOn;
        [_flashLightON setTitle:@"打开" forState:UIControlStateNormal];
        [_flashLightON setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flashLightON setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [_flashLightON addTarget:self action:@selector(seleteFlashLightMode:) forControlEvents:UIControlEventTouchUpInside];
        [self.flashLightView addSubview:_flashLightON];
    }
    return _flashLightON;
}

- (UIButton *)flashLightOff {
    if (!_flashLightOff) {
        _flashLightOff = [[UIButton alloc] initWithFrame:CGRectZero];
        _flashLightOff.titleLabel.textAlignment = NSTextAlignmentCenter;
        _flashLightOff.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _flashLightOff.tag = SCameraFlashLightOff;
        [_flashLightOff setTitle:@"关闭" forState:UIControlStateNormal];
        [_flashLightOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flashLightOff setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [_flashLightOff addTarget:self action:@selector(seleteFlashLightMode:) forControlEvents:UIControlEventTouchUpInside];
        [self.flashLightView addSubview:_flashLightOff];
    }
    return _flashLightOff;
}

- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setImage:[UIImage imageNamed:@"photoButtonImage"] forState: UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_photoButton];
    }
    return _photoButton;
}

- (UIButton *)photoLibraryButton {
    if (!_photoLibraryButton) {
        _photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoLibraryButton addTarget:self action:@selector(showPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_photoLibraryButton];
    }
    return _photoLibraryButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UILabel *)exposureDurationTitleLabel {
    if (!_exposureDurationTitleLabel) {
        _exposureDurationTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _exposureDurationTitleLabel.text = @"Shuttle : ";
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

- (UILabel *)isoTitleLabel {
    if (!_isoTitleLabel) {
        _isoTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _isoTitleLabel.text = @"ISO : ";
        [_isoTitleLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_isoTitleLabel];
    }
    return _isoTitleLabel;
}

- (UILabel *)isoValueLabel {
    if (!_isoValueLabel) {
        _isoValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _isoValueLabel.text = [NSString stringWithFormat:@"%.4f",self.device.ISO];
        [_isoValueLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_isoValueLabel];
    }
    return _isoValueLabel;
}

- (UISlider *)isoSlider {
    if (!_isoSlider) {
        _isoSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        [_isoSlider setContinuous:YES];
        [_isoSlider setMinimumValue: self.device.activeFormat.minISO];
        [_isoSlider setMaximumValue: self.device.activeFormat.maxISO];
        [_isoSlider setValue:self.device.ISO];
        [_isoSlider addTarget:self action:@selector(isoChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_isoSlider];
    }
    return _isoSlider;
}

- (UIView *)focusView {
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectZero];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor =[UIColor blueColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_focusView];
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (AVCaptureDevice *)device {
    if (!_device) {
        //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureStillImageOutput *)ImageOutPut {
    if (!_ImageOutPut) {
        _ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    }
    return _ImageOutPut;
}

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
