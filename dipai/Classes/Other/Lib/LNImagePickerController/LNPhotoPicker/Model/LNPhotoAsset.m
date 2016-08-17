//
//  LNPhotoAsset.m
//  LNImagePickerDemo
//
//  Created by 林洁 on 16/1/20.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNPhotoAsset.h"
#import "UIImage+LNImage.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface LNPhotoAsset ()

@property (nonatomic, readwrite, strong) ALAsset *asset;

@property (nonatomic, readwrite, strong) UIImage *thumbImage;

@property (nonatomic, readwrite, strong) UIImage *screenWidthImage;

@property (nonatomic, assign) NSUInteger tag;

@end

@implementation LNPhotoAsset

- (id)initWithAsset:(ALAsset *)asset{
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (UIImage*)screenWidthImage{
    ALAssetRepresentation *representation = [self.asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
    return [image imageCompressForWidth:SCREEN_WIDTH];
}

- (UIImage*)thumbImage{
    UIImage *image = [UIImage imageWithCGImage:[self.asset thumbnail]];
    return image;
}

@end
