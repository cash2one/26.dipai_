//
//  LSPhotoView.m
//  dipai
//
//  Created by 梁森 on 16/6/24.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "LSPhotoView.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface LSPhotoView()
// 用来装imageView
@property (nonatomic, strong) NSMutableArray * imagesArr;
/**
 *  显示图片张数的标签
 */
@property (nonatomic, strong) UILabel * numLbl;

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
//        self.backgroundColor = [UIColor yellowColor];
        
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
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        [self addSubview:picView];
        [self.imagesArr addObject:picView];
    }
    // 添加图片的个数
    UIImageView * imageV = [self.imagesArr lastObject];
    UILabel * numLbl = [[UILabel alloc] init];
    numLbl.textColor = [UIColor whiteColor];
    numLbl.textAlignment = NSTextAlignmentCenter;
    numLbl.font = Font11;
    numLbl.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/ 255.f alpha:0.8];
    [imageV addSubview:numLbl];
    _numLbl = numLbl;
}

- (void)setPicArr:(NSArray *)picArr{
    _picArr = picArr;
    
//    NSLog(@"传递过来图片的个数:%lu", _picArr.count);
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
    for (int i = 0; i < self.imagesArr.count; i++) {

        if (_picArr.count == 1) {
            UIImageView * image = self.imagesArr[0];
            image.frame = CGRectMake(0, 0, 120 * IPHONE6_W_SCALE, 80 * IPHONE6_W_SCALE);
        } else if (_picArr.count > 1 ){
                UIImageView *imageV = self.subviews[i];
                imageV.frame = CGRectMake(0+ i * (80 + 5)*IPHONE6_W_SCALE, 0 , 80 * IPHONE6_W_SCALE , 80 * IPHONE6_W_SCALE);
            if (_picArr.count > 3) {
                
                CGFloat x = (160-70)*0.5*IPHONE6_W_SCALE;
                CGFloat y = (160-32)*0.5*IPHONE6_H_SCALE;
                _numLbl.frame = CGRectMake(x, y, 35*IPHONE6_W_SCALE, 16*IPHONE6_H_SCALE);
                
//                NSLog(@"图片个数%lu", _picArr.count);
                
                _numLbl.text = [NSString stringWithFormat:@"%lu图", _picArr.count];
            }
            
        }
        
    }
}

@end
