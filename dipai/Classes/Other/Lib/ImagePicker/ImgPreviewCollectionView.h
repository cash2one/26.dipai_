//
//  ImgPreviewCollectionView.h
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import <UIKit/UIKit.h>

// 图片浏览器
@interface ImgPreviewCollectionView : UICollectionView  <UICollectionViewDataSource,UICollectionViewDelegate>


// 选中图片的下标
@property(nonatomic, assign) NSInteger currentIndex;
// 所有的图片模型
@property(nonatomic, strong) NSArray  *assetModels;

@property(nonatomic) CGRect previousFrame;

- (void)show;

@end
