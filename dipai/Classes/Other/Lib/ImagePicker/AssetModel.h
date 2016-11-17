//
//  AssetModel.h
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AssetModel : NSObject

@property(nonatomic,strong) UIImage* thumbnail;
@property(nonatomic,strong) NSURL* imgUrl;
@property(nonatomic,assign) BOOL isSelect;

-(void)originalImg:(void (^)(UIImage* img))returnImg;


@end
