//
//  LNPhotoBrowserController.h
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/18.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNPhotoAsset.h"

@class LNPhotoBrowserController;

@protocol LNPhotoBrowserDataSource <NSObject>

/**
 *  获取本地所有的照片
 *
 *  @param photoBrowser self
 *
 *  @return
 */
- (NSArray*)numberOfPhotosInPhotoBrowser:(LNPhotoBrowserController*)photoBrowser;

@end

@protocol LNPhotoBrowserDelegate <NSObject>

/**
 *  选择照片回调
 *
 *  @param photoBrowser self
 *  @param photoAsset   当前选择的照片对象
 */
- (void)photoBrowser:(LNPhotoBrowserController*)photoBrowser didSelectedPhotoAsset:(LNPhotoAsset*)photoAsset;

/**
 *  照片选择前回调
 *
 *  @param photoBrowser self
 *  @param count        已选择的照片数量
 *
 *  @return
 */
- (BOOL)photoBrowser:(LNPhotoBrowserController*)photoBrowser shouldSelectPhotoAssets:(NSInteger)count;

/**
 *  取消选择回调
 *
 *  @param photoBrowser self
 *  @param photoAsset   当前取消选择的照片对象
 */
- (void)photoBrowser:(LNPhotoBrowserController*)photoBrowser deSelectedPhotoAsset:(LNPhotoAsset*)photoAsset;

@end

@interface LNPhotoBrowserController : UIViewController

@property (nonatomic, weak) id<LNPhotoBrowserDataSource> dataSource;

@property (nonatomic, weak) id<LNPhotoBrowserDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL isEdit;

@end
