//
//  ImageBrowserView.m
//  dipai
//
//  Created by 梁森 on 16/11/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ImageBrowserView.h"
#import "UIImageView+WebCache.h"
@implementation ImageBrowserView

- (instancetype)initWithImageArr:(NSArray *)imags andTag:(NSInteger)index{
    
    if (self == [super init]) {
        
        [self setUpChildControlWithArr:imags andTag:index];
    }
    return self;
}

- (void)setUpChildControlWithArr:(NSArray *)images andTag:(NSInteger)index{
    
    _imageArr = images;
    // 装滚动视图的滚动视图
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.delegate = self;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    scrollView.contentSize = CGSizeMake( WIDTH * images.count , 0); // 内容视图大小
    scrollView.contentOffset = CGPointMake(WIDTH * (index-1), 0);   // 偏移量
    UILabel * indexLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 30)];
    indexLbl.backgroundColor = [UIColor clearColor];
    indexLbl.textColor = [UIColor whiteColor];
    indexLbl.textAlignment = NSTextAlignmentCenter;
    indexLbl.text = [NSString stringWithFormat:@"%lu/%lu", index, images.count];
    indexLbl.font = Font14;
    [self addSubview:indexLbl];
    _indexLbl = indexLbl;
//    _titleLbl = titleLbl;
    for ( int i = 0 ; i < images.count ; i++ ) {
        UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH , HEIGHT)];
        sc.backgroundColor = [UIColor blackColor];
        sc.maximumZoomScale = 2.0;
        sc.minimumZoomScale = 1.0;
        sc.decelerationRate = 0.2;
        sc.delegate = self;
        sc.tag = 1 + i;
        [scrollView addSubview:sc];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [img sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:[UIImage imageNamed:@"123"]];
        
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPics:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [sc addGestureRecognizer:tap];
        
        UITapGestureRecognizer * twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makePicBigger:)];
        twoTap.numberOfTapsRequired = 2;
        img.userInteractionEnabled = YES;
        [img addGestureRecognizer:twoTap];
        
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.tag = 1000 + i;
        img.userInteractionEnabled = YES;
        [sc addSubview:img];
        sc.contentSize = CGSizeMake( WIDTH , 0);
        //   双击没有识别到的时候识别单击手势
        [tap requireGestureRecognizerToFail:twoTap];
    }
    
}
- (void)hiddenPics:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)makePicBigger:(UITapGestureRecognizer *)tap{
    UIScrollView * sc = (UIScrollView *)[tap.view superview];
    CGFloat zoomScale = sc.zoomScale;
    zoomScale = (zoomScale == 1.0) ? 3.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[tap locationInView:tap.view]];
    [sc zoomToRect:zoomRect animated:YES];
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imgView = [scrollView.subviews firstObject];
    return imgView;
}
- (void)show{
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int x = scrollView.contentOffset.x / WIDTH + 1;
    _indexLbl.text = [NSString stringWithFormat:@"%d/%lu", x,_imageArr.count];
}

@end
