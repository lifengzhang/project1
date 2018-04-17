//
//  ChannelCellectionView.m
//  SCamera
//
//  Created by sunny on 2018/3/15.
//  Copyright © 2018年 SCamera.com. All rights reserved.
//

#import "SCameraChannelCellectionView.h"
#import "SCameraChannelCell.h"

static NSString *channelCellID = @"channel_Cell_ID";

@interface SCameraChannelCellectionView ()

@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation SCameraChannelCellectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor blackColor];
        self.alwaysBounceVertical = YES;
        [self registCell];
    }
    return self;
}

- (void)registCell {
    [self registerClass:[SCameraChannelCell class] forCellWithReuseIdentifier:channelCellID];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCameraChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:channelCellID forIndexPath:indexPath];
    [cell updateCellTitle:[NSString stringWithFormat:@"%lu",indexPath.row + 1]];
    if (FlashLightManager.channelStr.length == 0) {
        if (indexPath.row == 0) {
            cell.title.backgroundColor = Scamera_CollectionCell_Selected;
        }
    } else {
        if (indexPath == self.indexpath || indexPath.row == FlashLightManager.channelStr.integerValue - 1) {
            cell.title.backgroundColor = Scamera_CollectionCell_Selected;
        } else {
            cell.title.backgroundColor = Scamera_CollectionCell_Normal;
        }
    }
    return cell;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SCameraChannelCell *cell = (SCameraChannelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.indexpath = indexPath;
    [FlashLightManager saveChannel:[NSString stringWithFormat:@"%lu",self.indexpath.row + 1]];
    [self reloadData];
}


@end