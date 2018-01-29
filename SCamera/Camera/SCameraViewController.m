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

@interface SCameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong) AVCaptureDevice *device;;

/**
 *  AVCapturemSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;

@property (nonatomic, strong) AVCaptureStillImageOutput *ImageOutPut;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *photoButton;

@property (nonatomic, strong) UIButton *backButton;

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

/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@end

@implementation SCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    //    [self startSession];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //    [self stopSession];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customCamera{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
    }
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
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
        
        //        [self.device setExposureModeCustomWithDuration:CMTimeMake(1, 60) ISO:AVCaptureISOCurrent completionHandler:nil];
        
        self.firstISO = self.device.ISO;
        self.currentISO = self.device.ISO;
        
        self.firstDuration = self.device.exposureDuration;
        self.currentDuration = self.device.exposureDuration;
        [_device unlockForConfiguration];
    }
}

- (void)customUI{
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(20, 20, 60, 60);
    [self.backButton setTitle:@"回退" forState:UIControlStateNormal];
    self.backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoButton.frame = CGRectMake(kScreenWidth*1/2.0-30, kScreenHeight-100, 60, 60);
    //    [photoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    //    [photoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    self.photoButton.backgroundColor = [UIColor redColor];
    [self.photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoButton];
    
    self.photoLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoLibraryButton.frame = CGRectMake(30, kScreenHeight-100, 60, 60);
    [self.photoLibraryButton addTarget:self action:@selector(showPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoLibraryButton];
    //    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    //    _focusView.layer.borderWidth = 1.0;
    //    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    //    _focusView.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:_focusView];
    //    _focusView.hidden = YES;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(kScreenWidth*1/4.0-30, kScreenHeight-100, 60, 60);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    self.exposureDurationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kScreenHeight-190, 80, 30)];
    self.exposureDurationTitleLabel.text = @"Shuttle : ";
    [self.exposureDurationTitleLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.exposureDurationTitleLabel];
    
    self.exposureDurationValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, kScreenHeight-190, 100, 30)];
    self.exposureDurationValueLabel.text = [NSString stringWithFormat:@"%.0f",self.device.exposureDuration.value/(1.0f *self.device.exposureDuration.timescale)*1000000];;
    [self.exposureDurationValueLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.exposureDurationValueLabel];
    
    self.exposureDurationSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, kScreenHeight-150, kScreenWidth-40, 30)];
    [self.exposureDurationSlider setContinuous:YES];
    if (self.device) {
        [self.exposureDurationSlider setMinimumValue:self.device.activeFormat.minExposureDuration.value/(1.0f*self.device.activeFormat.minExposureDuration.timescale)];
        [self.exposureDurationSlider setMaximumValue: self.device.activeFormat.maxExposureDuration.value/ (1.0f * self.device.activeFormat.maxExposureDuration.timescale)];
        [self.exposureDurationSlider setValue:self.device.exposureDuration.value/(1.0f *self.device.exposureDuration.timescale)];
    }
    
    [self.exposureDurationSlider addTarget:self action:@selector(exposureDurationChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.exposureDurationSlider];
    
    self.isoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 50, 30)];
    self.isoTitleLabel.text = @"ISO : ";
    [self.isoTitleLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.isoTitleLabel];
    
    self.isoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 70, 100, 30)];
    self.isoValueLabel.text = [NSString stringWithFormat:@"%.4f",self.device.ISO];
    [self.isoValueLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.isoValueLabel];
    
    self.isoSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 110, kScreenWidth-40, 30)];
    [self.isoSlider setContinuous:YES];
    [self.isoSlider setMinimumValue: self.device.activeFormat.minISO];
    [self.isoSlider setMaximumValue: self.device.activeFormat.maxISO];
    [self.isoSlider setValue:self.device.ISO];
    [self.isoSlider addTarget:self action:@selector(isoChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.isoSlider];
    //    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightButton.frame = CGRectMake(kScreenWidth*3/4.0-60, kScreenHeight-100, 60, 60);
    //    [rightButton setTitle:@"切换" forState:UIControlStateNormal];
    //    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    [rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:rightButton];
    //
    //    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _flashButton.frame = CGRectMake(kScreenWidth-80, kScreenHeight-100, 80, 60);
    //    [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
    //    [_flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_flashButton];
    //
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    //    [self.view addGestureRecognizer:tapGesture];
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
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
    //                                                    message:msg
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"确定"
    //                                          otherButtonTitles:nil];
    //    [alert show];
}

#pragma - 获取相册图片

- (void)getLatestAsset {
//    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        *stop = YES;
//        [assets addObject:asset];
        UIImage *image = [UIImage imageWithData:[SCameraViewController getImageFromPHAsset:asset]];
        [self.photoLibraryButton setImage:image forState:UIControlStateNormal];
    }];
//    NSLog(@"%ld",assets.count);
//    return assets;
}

+ (NSData *)getImageFromPHAsset:(PHAsset *)asset {
    __block NSData *data;
//    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
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
//    if (result) {
//        if (data.length <= 0) {
//            result(nil, nil);
//        } else {
//            result(data, resource.originalFilename);
//        }
//    }
}

- (void)dealloc {
    
    
}

@end
