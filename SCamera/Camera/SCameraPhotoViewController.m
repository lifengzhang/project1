//
//  SCameraPhotoViewController.m
//  SCamera
//
//  Created by sunny on 2018/1/27.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraPhotoViewController.h"
#import <Photos/Photos.h>

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
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(20, 20, 60, 44);
    [self.backButton setTitle:@"back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.deletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deletButton.frame = CGRectMake(self.view.frame.size.width - 80, 20, 60, 44);
    [self.deletButton setTitle:@"delete" forState:UIControlStateNormal];
    [self.deletButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.deletButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.deletButton addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deletButton];
    
    [self.selectedPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
}

- (UIImageView *)selectedPhoto {
    
    if (!_selectedPhoto) {
        _selectedPhoto = [[UIImageView alloc] initWithImage:self.image];
        [self.view addSubview:_selectedPhoto];
    }
    
    return _selectedPhoto;
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
