//
//  LSPhotoView.m
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "LSPhotoView.h"

#import "UIImageView+WebCache.h"
@interface LSPhotoView()
// 用来装imageView
@property (nonatomic, strong) NSMutableArray * imagesArr;

@end

@implementation LSPhotoView
- (NSMutableArray *)imagesArr{
    if (_imagesArr == nil) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
        
        // 设置子控件
        [self setUpChildControl];
    }
    
    return self;
}
#pragma mark --- 设置子控件
- (void)setUpChildControl{
    // 最多显示三张图片
    for (int i = 0; i < 3; i ++) {
        UIImageView * picView = [[UIImageView alloc] init];
        [self addSubview:picView];
        [self.imagesArr addObject:picView];
    }
}

- (void)setPicArr:(NSArray *)picArr{
    _picArr = picArr;
    
    NSLog(@"传递过来图片的个数:%lu", _picArr.count);
    NSUInteger counts = self.subviews.count;
    for (int i = 0; i < counts; i ++) {
        UIImageView * imageView = self.subviews[i];
        // 9张图片以内显示上传的所有图片
        if (i < _picArr.count) {
            // 显示
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:[UIImage imageNamed:@"123"]];
            
        }else
        {
            // 隐藏
            imageView.hidden = YES;
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 计算显示出来的imageView
    for (int i = 0; i < _picArr.count; i++) {

        if (_picArr.count == 1) {
            UIImageView * image = self.imagesArr[0];
            image.frame = CGRectMake(0, 0, 120 * IPHONE6_W_SCALE, 80 * IPHONE6_W_SCALE);
        } else if (_picArr.count > 1 && _picArr.count <= 3){
            UIImageView *imageV = self.subviews[i];
            imageV.frame = CGRectMake(0+ i * (80 + 5), 0 , 80 * IPHONE6_W_SCALE , 80 * IPHONE6_W_SCALE);
        }
        
    }
    
    
    
//    if (_picArr.count == 1) {
//        UIImageView * image = self.imagesArr[0];
//        image.frame = CGRectMake(0, 0, 120 * IPHONE6_W_SCALE, 80 * IPHONE6_W_SCALE);
//        [image sd_setImageWithURL:[NSURL URLWithString:_picArr[0]] placeholderImage:[UIImage imageNamed:@"123"]];
//    }
//    if (_picArr.count == 2) {
//        for (int i = 0; i < 2; i ++) {
//            UIImageView * image = self.imagesArr[i];
//            image.frame = CGRectMake(0+ i * (80 + 5), 0 , 80 * IPHONE6_W_SCALE , 80 * IPHONE6_W_SCALE);
//            [image sd_setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:[UIImage imageNamed:@"123"]];
//        }
//    }
//    if (_picArr.count >= 3) {
//        for (int i = 0; i < 3; i ++) {
//            UIImageView * image = self.imagesArr[i];
//            image.frame = CGRectMake(0+ i * (80 + 5), 0 , 80 * IPHONE6_W_SCALE , 80 * IPHONE6_W_SCALE);
//            [image sd_setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:[UIImage imageNamed:@"123"]];
//        }
//    }
}

@end
