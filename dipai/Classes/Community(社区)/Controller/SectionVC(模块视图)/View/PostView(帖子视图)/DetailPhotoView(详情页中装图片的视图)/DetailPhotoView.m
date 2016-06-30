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

- (instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        [self setUpChildControlWithArr:array];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


#pragma mark --- 设置子控件
- (void)setUpChildControlWithArr:(NSArray *)array{
    for (int i = 0; i < array.count; i ++) {
        UIImageView * picView = [[UIImageView alloc] init];
        picView.contentMode = UIViewContentModeScaleAspectFit;
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        picView.userInteractionEnabled = YES;
        [self addSubview:picView];
        [self.imagesArr addObject:picView];
        
        picView.tag = i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [picView addGestureRecognizer:tap];
        picView.userInteractionEnabled = YES;
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    UIImageView *tapView = (UIImageView *)tap.view;
    // CZPhoto -> MJPhoto
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *photo in _picArr) {
        
//        NSLog(@"%@", photo);
        
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
//     NSLog(@"--传递过来的%@", _picArr);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = 0;
    
    
    if (self.imagesArr.count > 0) {
        for (int i = 0; i < _picArr.count; i ++) {
          
            UIImageView * imageV = self.imagesArr[i];
            
            CGSize size = [UIImageView downloadImageSizeWithURL:[NSURL URLWithString:_picArr[i]]];
            CGFloat h = size.height;    // 图片的高度
            
            imageV.frame = CGRectMake(0, 0 + height, WIDTH - 30 * IPHONE6_W_SCALE, h);
            height = height + h + 8;
            [imageV sd_setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:[UIImage imageNamed:@"123"]];
        }
    }
    
    
}

@end
