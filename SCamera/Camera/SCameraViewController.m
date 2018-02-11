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

#import "CameraView.h"

#import "SCameraISOValueScrollView.h"

#import "SCameraShutterTableView.h"

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#define CANCELBUTTON_DISTANCE_TOP                                              kScreenHeight - 100
#define CANCELBUTTON_DISTANCE_LEFT                                             kScreenWidth*1/4.0 - 30
#define CANCELBUTTON_WIDTH_HEIGHT                                              60.f

#define EXPOSUREDURATIONTITLELABEL_DISTANCE_TOP                                kScreenHeight - 175
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

@interface SCameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, SCameraShutterTableViewDelegage>

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

@property (nonatomic, strong) SCameraISOValueScrollView *iSOValueScrollView;

@property (nonatomic, strong) SCameraShutterTableView *shutterTableView;

@property (nonatomic, assign) double shutterTimer;

@property (nonatomic, strong) NSString *shutterStr;

@end

@implementation SCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customCamera];
    [self customUI];
    [self getLatestAsset];
    [self addButtonAction];
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
    [self.cameraView.flashLightButton addTarget:self action:@selector(tapFlashLightbutton) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.timerButton addTarget:self action:@selector(tapTimerButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.exchangeButton addTarget:self action:@selector(tapExchangeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.valueButton addTarget:self action:@selector(tapValueButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView.bluetoothButton addTarget:self action:@selector(tapblueToothButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)customCamera{
    self.view.backgroundColor = [UIColor blackColor];
    //使用设备初始化输入
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
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
        self.currentISO = self.device.ISO;
        
        self.firstDuration = self.device.exposureDuration;
        self.currentDuration = self.device.exposureDuration;
        [_device unlockForConfiguration];
    }
}

- (void)customUI{
    
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.exposureDurationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(EXPOSUREDURATIONTITLELABEL_DISTANCE_TOP);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(ISOTITLELABEL_WIDTH);
        make.height.mas_equalTo(ISOTITLELABEL_HEIGHT);
    }];
    
//    [self.exposureDurationValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(EXPOSUREDURATIONVALUELABEL_DISTANCE_TOP);
//        make.left.equalTo(self.view).offset(EXPOSUREDURATIONVALUELABEL_DISTANCE_LEFT);
//        make.width.mas_equalTo(EXPOSUREDURATIONVALUELABEL_WIDTH);
//        make.height.mas_equalTo(EXPOSUREDURATIONVALUELABEL_HEIGHT);
//    }];
    
//    [self.exposureDurationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(EXPOSUREDURATIONSLIDER_DISTANCE_TOP);
//        make.left.equalTo(self.view).offset(EXPOSUREDURATIONSLIDER_DISTANCE_LEFT);
//        make.width.mas_equalTo(EXPOSUREDURATIONSLIDER_WIDTH);
//        make.height.mas_equalTo(EXPOSUREDURATIONSLIDER_HEIGHT);
//    }];
    
    [self.isoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ISIphoneX ? 87 : 65);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(ISOTITLELABEL_WIDTH);
        make.height.mas_equalTo(ISOTITLELABEL_HEIGHT);
    }];
    
    [self.iSOValueScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isoTitleLabel);
        make.left.equalTo(self.isoTitleLabel.mas_right);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(35);
    }];
    
    self.shutterTableView.frame = CGRectMake(84, kScreenHeight - 175, kScreenWidth - 84, 35);
    
//    [self.isoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(ISOVALUELABEL_DISTACE_TOP);
//        make.left.equalTo(self.view).offset(ISOVALUELABEL_DISTACE_LEFT);
//        make.width.mas_equalTo(ISOVALUELABEL_WIDTH);
//        make.height.mas_equalTo(ISOVALUELABEL_HEIGHT);
//    }];
    
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
        
        AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        [device setExposureModeCustomWithDuration:self.currentDuration ISO:self.currentISO completionHandler:^(CMTime syncTime)
         {
             AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
             // 此只读属性的值表示当前场景的计量曝光水平与目标曝光值之间的差异。
             //        [self.mExposureBias setValue:device.exposureTargetOffset];
             
             //手动模式
             //             device.exposureMode=AVCaptureExposureModeCustom;
             NSLog(@"device.ISO = %f",device.ISO);
             NSLog(@"device.exposureTargetOffset = %f",device.exposureTargetOffset);
             [device unlockForConfiguration];
             self.photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
             [self.photoOutPut capturePhotoWithSettings:self.photoSettings delegate:self];
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
- (void)tapFlashLightbutton {
    
    //修改前必须先锁定
    [self.device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.device hasFlash]) {
        
        if (self.photoSettings.flashMode == AVCaptureFlashModeOff) {
            [self.photoSettings setFlashMode:AVCaptureFlashModeOn];
        } else if (self.photoSettings.flashMode == AVCaptureFlashModeOn) {
            [self.photoSettings setFlashMode:AVCaptureFlashModeOff];
        }
//        if (self.device.flashMode == AVCaptureFlashModeOff) {
//            self.device.flashMode = AVCaptureFlashModeOn;
////            self.device.torchMode = AVCaptureTorchModeOn;
//        } else if (self.device.flashMode == AVCaptureFlashModeOn) {
//            self.device.flashMode = AVCaptureFlashModeOff;
////            self.device.torchMode = AVCaptureTorchModeOff;
//        }
        
    }
    [self.device unlockForConfiguration];
    
}

#pragma mark - 点击定时器
- (void)tapTimerButton {
    
    
}

#pragma mark - 相机转换
- (void)tapExchangeButton {
    
    NSArray *inputs =self.session.inputs;
    for (AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera =nil;
            AVCaptureDeviceInput *newInput =nil;
            
            if (position ==AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            [self.session beginConfiguration];
            [self.session removeInput:input];
            [self.session addInput:newInput];
            [self.session commitConfiguration];
            break;
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}

#pragma mark - 点击调节器
- (void)tapValueButton:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.iSOValueScrollView.hidden = NO;
        self.isoTitleLabel.hidden = NO;
        self.exposureDurationTitleLabel.hidden = NO;
        self.shutterTableView.hidden = NO;
        [self.cameraView showView];
    } else {
        self.iSOValueScrollView.hidden = YES;
        self.isoTitleLabel.hidden = YES;
        self.exposureDurationTitleLabel.hidden = YES;
        self.shutterTableView.hidden = YES;
        [self.cameraView hiddenView];
    }
}

- (void)updateValueData {
    
    self.cameraView.showShutterValue.text = [NSString stringWithFormat:@"Shutter: %@",self.shutterStr];
}

#pragma mark - 点击蓝牙
- (void)tapblueToothButton {
    
    
}

- (void)cancle{
//    [self.imageView removeFromSuperview];
    [self.session startRunning];
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

#pragma mark - SCameraShutterTableViewDelegage
- (void)scameraShutterTableViewDidSelectRowAndSelectedValue:(double)value withString:(NSString *)timeStr {
    
    self.shutterTimer = value;
    self.shutterStr = timeStr;
    [self updateValueData];
}

#pragma mark - -聚焦
- (id)focusAtPoint:(CGPoint)point{

    if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        NSError *error;
        if ([self.device lockForConfiguration:&error]) {
            self.device.focusPointOfInterest = point;
            self.device.focusMode = AVCaptureFocusModeAutoFocus;
            [self.device unlockForConfiguration];
        }
        return error;
    }
    return nil;
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

#pragma mark - ISO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"iSOValue"]) {
        self.currentISO = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    }

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
        _isoTitleLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24];
        _isoTitleLabel.text = @"ISO";
        _isoTitleLabel.hidden = YES;
        _isoTitleLabel.font = [UIFont ChinaBoldFontNameOfSize:14];
        _isoTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_isoTitleLabel setTextColor:[UIColor whiteColor]];
        [self.view addSubview:_isoTitleLabel];
    }
    return _isoTitleLabel;
}

- (SCameraISOValueScrollView *)iSOValueScrollView {
    
    if (! _iSOValueScrollView) {
        _iSOValueScrollView = [[SCameraISOValueScrollView alloc] initWithFrame:CGRectZero];
        _iSOValueScrollView.hidden = YES;
        [self.view addSubview:_iSOValueScrollView];
        [_iSOValueScrollView addObserver:self forKeyPath:@"iSOValue" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _iSOValueScrollView;
    
}

- (SCameraShutterTableView *)shutterTableView {
    if (!_shutterTableView) {
        _shutterTableView = [[SCameraShutterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _shutterTableView.hidden = YES;
        _shutterTableView.scameraShutterTableViewDelegate = self;
        [self.view addSubview:_shutterTableView];
    }
    return _shutterTableView;
}

- (UILabel *)exposureDurationTitleLabel {
    if (!_exposureDurationTitleLabel) {
        _exposureDurationTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _exposureDurationTitleLabel.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.24];
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
