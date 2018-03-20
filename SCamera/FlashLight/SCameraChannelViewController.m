//
//  SCameraChannelViewController.m
//  SCamera
//
//  Created by sunny on 2018/3/15.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraChannelViewController.h"
#import "SCameraChannelCellectionView.h"

@interface SCameraChannelViewController ()

@property (nonatomic, strong) SCameraChannelCellectionView *channelView;

@end

@implementation SCameraChannelViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setUpConstrains];
        [self updateNavigation];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateNavigation {
    self.title = @"频道";
    UIImage *leftBarButtonImage = [self OriginImage:[UIImage imageNamed:@"navi_back"] scaleToSize:CGSizeMake(22, 22)];
    leftBarButtonImage = [leftBarButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBarButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIImage*)OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (void)back {
    if (self.blockparameter) {
        self.blockparameter();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpConstrains {
    
    [self.channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (SCameraChannelCellectionView *)channelView {
    if (!_channelView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake((Width_Screen - 60)/4, 100 )];
        flowLayout.sectionInset = UIEdgeInsetsMake(13, 14, 20, 14);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _channelView = [[SCameraChannelCellectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_channelView];
    }
    return _channelView;
}

@end
