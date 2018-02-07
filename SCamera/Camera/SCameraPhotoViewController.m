//
//  SCameraPhotoViewController.m
//  SCamera
//
//  Created by sunny on 2018/1/27.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraPhotoViewController.h"
#import <Photos/Photos.h>

#define BACKBUTTON_DISTANCE_TOP                                                         20.f
#define BACKBUTTON_DISTANCE_LEFT                                                        20.f
#define BACKBUTTON_WIDTH                                                                60.f
#define BACKBUTTON_HEIGHT                                                               44.f

#define DELETEBUTTON_DISTANCE_TOP                                                       20.f
#define DELETEBUTTON_WIDTH                                                              60.f
#define DELETEBUTTON_HEIGHT                                                             44.f

@interface SCameraPhotoViewController ()

@property (nonatomic, strong) UIView *photoView;

@property (nonatomic, strong) UIImageView *selectedPhoto;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *deletButton;

@property (nonatomic, strong) NSURL *photoUrl;

@end

@implementation SCameraPhotoViewController

- (instancetype)initWith:(UIImage *)image photoURL:(NSURL *)url {
    
    if (self = [super init]) {
        self.image = image;
        self.photoUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)initSubView{

    [self.selectedPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(BACKBUTTON_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(BACKBUTTON_DISTANCE_LEFT);
        make.width.mas_equalTo(BACKBUTTON_WIDTH);
        make.height.mas_equalTo(BACKBUTTON_HEIGHT);
    }];

    [self.deletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DELETEBUTTON_DISTANCE_TOP);
        make.left.equalTo(self.view).offset(self.view.frame.size.width - 80);
        make.width.mas_equalTo(DELETEBUTTON_WIDTH);
        make.height.mas_equalTo(DELETEBUTTON_HEIGHT);
    }];
}

- (UIImageView *)selectedPhoto {
    
    if (!_selectedPhoto) {
        _selectedPhoto = [[UIImageView alloc] initWithImage:self.image];
        [self.view addSubview:_selectedPhoto];
    }
    
    return _selectedPhoto;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"back" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)deletButton {
    if (!_deletButton) {
        _deletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletButton setTitle:@"delete" forState:UIControlStateNormal];
        [_deletButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _deletButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_deletButton addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deletButton];
    }
    return _deletButton;
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deletePhoto {
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[self.photoUrl] options:nil];
    PHAsset *asset = [result lastObject];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[asset]];
    } completionHandler:^(BOOL success, NSError *error) {
        
    }];
    [self back];
}

@end
