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
#import "Masonry.h"
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
//        picView.contentMode = UIViewContentModeScaleAspectFit;
//        picView.contentMode = UIViewContentModeScaleAspectFill;
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
    NSMutableArray * arr = [NSMutableArray array];
    if (picArr.count >= 9) {
        for (int i = 0; i < 9; i ++) {
            [arr addObject:picArr[i]];
        }
        _picArr = (NSArray *)arr;
    }
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
//    CGFloat width = 0;
    if (_picArr.count > 0) {
        for (int i = 0; i < _picArr.count; i ++) {
          
            UIImageView * imageV = self.subviews[i];
//            UIImageView * imageV = self.imagesArr[i];
//
            CGFloat h;    // 图片的高度
            CGFloat w; // 图片的宽度
//            NSLog(@"%@", _picArr[i]);
            
            CGSize size = [UIImageView downloadImageSizeWithURL:[NSURL URLWithString:_picArr[i]]];
            h = size.height * IPHONE6_W_SCALE;
            w = size.width * IPHONE6_W_SCALE;
            
//            NSLog(@"%f---%f", h, w);
            
            CGFloat scale = 1.0;
            if (w == 0) {   // 如果获取不到图片的大小
                w = WIDTH - 30 * IPHONE6_W_SCALE;
                h = w;
            }else{  // 能够获取图片大小
                if (w > WIDTH - 30 * IPHONE6_W_SCALE) { // 图片宽度大于
                    scale = (WIDTH - 30 * IPHONE6_W_SCALE)/w;
                    h = h * scale;
                }else{  // 图片宽度小于
                    w = size.width * IPHONE6_W_SCALE;
                    h = size.height * IPHONE6_W_SCALE;
                }
            }

            
            if (w >0 && w < WIDTH - 30 * IPHONE6_W_SCALE) { // 图片剧中显示
                imageV.frame = CGRectMake(self.center.x-w/2-10, 0 + height, w, h);
            }else{
//                NSLog(@"图片宽比较大...");
                imageV.frame = CGRectMake(0, 0 + height, WIDTH - 30 * IPHONE6_W_SCALE, h);
            }
            

            height = height + h + 8*IPHONE6_H_SCALE;
//            imageV.backgroundColor = [UIColor redColor];
            [imageV sd_setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:[UIImage imageNamed:@"123"]];
            
        }
    }
    
}

@end
