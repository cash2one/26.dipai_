//
//  LNPhotoAsset.h
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/20.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface LNPhotoAsset : NSObject

@property (nonatomic, readonly, strong) ALAsset *asset;

@property (nonatomic, readonly, strong) UIImage *thumbImage;

@property (nonatomic, readonly, strong) UIImage *screenWidthImage;


- (id)initWithAsset:(ALAsset*)asset;

@end
