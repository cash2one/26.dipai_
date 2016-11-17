//
//  ImgSelectCollectionViewController.h
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;

@interface ImgSelectCollectionViewController : UICollectionViewController

@property (nonatomic, assign) NSUInteger selectedPics;

// 相册分组的属性
@property(nonatomic,strong) ALAssetsGroup* group;

@end
