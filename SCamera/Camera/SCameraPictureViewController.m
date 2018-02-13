//
//  SCameraPictureViewController.m
//  SCamera
//
//  Created by sunny on 2018/2/13.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraPictureViewController.h"
#import "SCameraPictureView.h"

@interface SCameraPictureViewController ()

@property (nonatomic, strong) SCameraPictureView *pictureView;

@property (nonatomic, strong) UIImage *displayPicture;

@end

@implementation SCameraPictureViewController

- (instancetype)initWithPicture:(UIImage *)Picture {
    if (self = [super init]) {
        self.displayPicture = Picture;
        [self setUpConstraints];
        [self addButtonAction];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)setUpConstraints {
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)addButtonAction {
    [self.pictureView.saveButton addTarget:self action:@selector(savePicture) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pictureView.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)savePicture {
    UIImageWriteToSavedPhotosAlbum(self.displayPicture, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
        [self back];
    }
}

- (SCameraPictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[SCameraPictureView alloc] initWithPicture:self.displayPicture];
        [self.view addSubview:_pictureView];
    }
    return _pictureView;
}

@end
