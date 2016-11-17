//
//  ImgPickerViewController.h
//  WYZ_ImgPickerc
//
//  Created by 王宇宙 on 16/7/13.
//  Copyright © 2016年 王宇宙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgPickerViewController : UINavigationController

// 已选中的图片个数
@property (nonatomic, assign) NSUInteger selectedPics;

// 选择原图
@property(nonatomic,copy) void(^selectOriginals)(NSArray*Originals);

// 选择压缩图
@property(nonatomic,copy) void(^selectThumbnails)(NSArray*thumbnails);



- (instancetype)initWithSelectedPics:(NSUInteger)pics;

@end
