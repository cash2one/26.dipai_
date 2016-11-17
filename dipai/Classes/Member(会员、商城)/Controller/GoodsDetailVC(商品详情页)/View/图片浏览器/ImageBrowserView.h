//
//  ImageBrowserView.h
//  dipai
//
//  Created by 梁森 on 16/11/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBrowserView : UIView<UIScrollViewDelegate>
// 下标
@property (nonatomic, strong) UILabel * indexLbl;
// 图片数组
@property (nonatomic, strong) NSArray * imageArr;
// 创建图片浏览器
- (instancetype)initWithImageArr:(NSArray *)imags andTag:(NSInteger)index;
// 显示图片浏览器
- (void)show;
@end
