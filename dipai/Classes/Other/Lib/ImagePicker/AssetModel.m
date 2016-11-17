//
//  AssetModel.m
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import "AssetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AssetModel
-(void)originalImg:(void (^)(UIImage *))returnImg{
    
    ALAssetsLibrary* lib=[[ALAssetsLibrary alloc ]init];
    [lib assetForURL:_imgUrl resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation* rep=asset.defaultRepresentation;
        CGImageRef imgRef=rep.fullScreenImage;
        UIImage* img=[UIImage imageWithCGImage:imgRef scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
        if (img) {
            returnImg(img);
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

@end
