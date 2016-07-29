//
//  DetailPhotoView.m
//  dipai
//
//  Created by 梁森 on 16/6/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "DetailPhotoView.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "UIImageView+WebCache.h"
#import "UIImageView+getSize.h"
@interface DetailPhotoView()

// 用来装imageView
@property (nonatomic, strong) NSMutableArray * imagesArr;

@end
@implementation DetailPhotoView
- (NSMutableArray *)imagesArr{
    if (_imagesArr == nil) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setUpChildControl];
        // self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setUpChildControl{
    for (int i = 0; i < 9; i ++) {
        UIImageView * picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        picView.contentMode = UIViewContentModeScaleAspectFit;
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        picView.userInteractionEnabled = YES;
        [self addSubview:picView];
//        picView.backgroundColor = [UIColor redColor];
        [self.imagesArr addObject:picView];
        
        picView.tag = i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [picView addGestureRecognizer:tap];
        picView.userInteractionEnabled = YES;
    }
}


- (void)tapClick:(UITapGestureRecognizer *)tap
{
    
    NSLog(@"/.....");
    
    UIImageView *tapView = (UIImageView *)tap.view;
    // CZPhoto -> MJPhoto
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *photo in _picArr) {
        
        MJPhoto *p = [[MJPhoto alloc] init];
        p.url = [NSURL URLWithString:photo];
        p.index = i;
        p.srcImageView = tapView;
        [arrM addObject:p];
        i++;
    }
    
    
    // 弹出图片浏览器
    // 创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    // MJPhoto
    brower.photos = arrM;
    brower.currentPhotoIndex = tapView.tag;
    [brower show];
}

- (void)setPicArr:(NSArray *)picArr{
    
    _picArr = picArr;
//     [self layoutSubviews];
    NSUInteger counts = self.subviews.count;
    
    for (int i = 0; i < counts; i ++) {
        UIImageView * imageView = self.subviews[i];
        // 9张图片以内显示上传的所有图片
        if (i < _picArr.count) {
            // 显示
            imageView.hidden = NO;

        }else
        {
            // 隐藏
            imageView.hidden = YES;
        }
    }

}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = 0;
    CGFloat width = 0;
    if (_picArr.count > 0) {
        for (int i = 0; i < _picArr.count; i ++) {
          
            UIImageView * imageV = self.subviews[i];
//            UIImageView * imageV = self.imagesArr[i];
            
            CGSize size = [UIImageView downloadImageSizeWithURL:[NSURL URLWithString:_picArr[i]]];
            CGFloat h = size.height;    // 图片的高度
            CGFloat w = size.width; // 图片的宽度
            if (w == 0) {
                w = WIDTH - 30 * IPHONE6_W_SCALE;
            }
            width = w;
            CGFloat scale = 1.0;
            if (size.width<WIDTH-30*IPHONE6_W_SCALE) {
                
//                NSLog(@"scale1---%f", scale);
                
                scale = (WIDTH - 30 * IPHONE6_W_SCALE)/w;
                h = h * scale;
            } else{
                scale = 1.0;
                h = h;
            }
            if (h == 0) {
                h = w;
            }
            
            imageV.frame = CGRectMake(0, 0 + height, WIDTH - 30 * IPHONE6_W_SCALE, h);
            height = height + h + 8;
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:[UIImage imageNamed:@"123"]];
        }
    }
    
}

@end
