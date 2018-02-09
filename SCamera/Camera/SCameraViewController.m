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
#import "SCameraISOValueScrollView.h"

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#define BACKBUTTON_DISTANCE_TOP                                                20.f
#define BACKBUTTON_DISTANCE_LEFT                                               20.f
#define BACKBUTTON_WIDTH_HEIGHT                                                60.f

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

@property (nonatomic, strong) SCameraISOValueScrollView *iSOValueScrollView;

@end

@implementation SCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customCamera];
    [self customUI];
    [self getLatestAsset];
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

- (void)customCamera{
    self.view.backgroundColor = [UIColor whiteColor];

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
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
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
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(CANCELBUTTON_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(CANCELBUTTON_DISTANCE_LEFT);
        make.width.height.mas_equalTo(CANCELBUTTON_WIDTH_HEIGHT);
    }];
    
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
    
    [self.iSOValueScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isoSlider.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
}

#pragma mark - 截取照片
- (void) shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
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
             
             NSLog(@",%f",device.exposureTargetOffset);
             [device unlockForConfiguration];
             
             [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                 if (imageDataSampleBuffer == NULL) {
                     return;
                 }
                 NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                 self.image = [UIImage imageWithData:imageData];
                 [self.session stopRunning];
                 [self saveImageToPhotoAlbum:self.image];
                 self.imageView = [[UIImageView alloc] initWithFrame:self.previewLayer.frame];
                 [self.view insertSubview:self.imageView belowSubview:self.photoButton];
                 self.imageView.layer.masksToBounds = YES;
                 self.imageView.image = self.image;
                 NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
             }];
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
        [_backButton setTitle:@"回退" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.backgroundColor = [UIColor redColor];
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

- (SCameraISOValueScrollView *)iSOValueScrollView {
    
    if (! _iSOValueScrollView) {
        _iSOValueScrollView = [[SCameraISOValueScrollView alloc] initWithFrame:CGRectZero];
        _iSOValueScrollView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_iSOValueScrollView];
    }
    
    return _iSOValueScrollView;
    
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
