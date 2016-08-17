//
//  LSPicturesView.m
//  梁森微博
//
//  Created by 梁森 on 16/5/9.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "LSPicturesView.h"

@interface LSPicturesView()


/**
 *  用来装图片的数组
 */
@property (nonatomic, strong) NSMutableArray * imagesArr;
/**
 *  用来装右上方删除按钮
 */
@property (nonatomic, strong) NSMutableArray * btnArr;

/**
 *  用来装唯一的一个按钮
 */
@property (nonatomic, strong) NSMutableArray * selectBtnArr;
/**
 *  视图上边的横线
 */
@property (nonatomic, strong) UIView * upLine ;

@end

@implementation LSPicturesView

- (NSMutableArray *)selectBtnArr{
    if (_selectBtnArr == nil) {
        _selectBtnArr = [NSMutableArray array];
    }
    return _selectBtnArr;
}
- (NSMutableArray *)imagesArr{
    if (_imagesArr == nil) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

- (NSMutableArray *)btnArr{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
//    [self.selectBtnArr addObject:btn];
    // 为按钮添加事件
    [btn addTarget:self action:@selector(selectPic) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"tianjiatupian"] forState:UIControlStateNormal];
    _selectBtn = btn;
    
    
    UIView * upLine = [[UIView alloc] init];
    [self addSubview:upLine];
    upLine.backgroundColor = Color216;
//    upLine.backgroundColor = [UIColor yellowColor];
    _upLine = upLine;
    
//    self.backgroundColor = [UIColor redColor];
}
// 选择图片
- (void)selectPic{
    
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [imageView addSubview:btn];
    
    [btn addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imagesArr addObject:imageView];
    [self.btnArr addObject:btn];
}

// 删除图片按钮的点击事件
- (void)deletePic:(UIButton *)btn{
    NSLog(@"%lu", btn.tag);
    
    UIImageView * imageView = self.imagesArr[btn.tag];
    [imageView removeFromSuperview];
    
    [self.imagesArr removeObjectAtIndex:btn.tag];
    [self.btnArr removeObjectAtIndex:btn.tag];
    [btn removeFromSuperview];
    
    [self layoutSubviews];
    
    if ([self.delegate respondsToSelector:@selector(deletePicWithIndex:)]) {
        [self.delegate deletePicWithIndex:btn.tag];
    } else{
        NSLog(@"LSPicturesView的代理没有响应...");
    }
}

// 在什么时候调用此方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
     _upLine.frame = CGRectMake(0, 0, WIDTH, 0.5);
    
    for (int i = 0; i < self.imagesArr.count; i ++) {
        
        
        if (i < 9) {   // 最多上传九张图片
            UIImageView *imageView = self.imagesArr[i];
            
            CGFloat imageX = Margin30 * IPHONE6_W_SCALE;
            CGFloat imageY = Margin40 * IPHONE6_H_SCALE;
            CGFloat imageW = 70 * IPHONE6_W_SCALE;
            CGFloat imageH = imageW;
            
            NSInteger j = i % 4;
            NSInteger k = i / 4;
            
            imageView.frame = CGRectMake(imageX + j * (imageW + 37*0.5*IPHONE6_W_SCALE), imageY + k * (imageH + Margin30 * IPHONE6_H_SCALE), imageW, imageH);
            
            imageView.userInteractionEnabled = YES;
            UIButton * btn = self.btnArr[i];
            CGFloat btnX = imageView.frame.size.width - 11 * IPHONE6_W_SCALE;
            CGFloat btnY = -11 * IPHONE6_W_SCALE;
            CGFloat btnW = 22 * IPHONE6_W_SCALE;
            CGFloat btnH = btnW;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            btn.tag = i;
           
            
            
        }
    }
    
    if (self.imagesArr.count < 4 && self.imagesArr.count > 0) {
        UIImageView * imageView = [self.imagesArr lastObject];
        CGFloat btnX = CGRectGetMaxX(imageView.frame) + 37 * 0.5 * IPHONE6_W_SCALE;
        CGFloat btnY = CGRectGetMinY(imageView.frame);
        CGFloat btnW = 70 * IPHONE6_W_SCALE;
        CGFloat btnH = btnW;
        
        _selectBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
    if (self.imagesArr.count == 4 ) {
        UIImageView * imageView = [self.imagesArr firstObject];
        CGFloat btnX = CGRectGetMinX(imageView.frame);
        CGFloat btnY = CGRectGetMaxY(imageView.frame) + Margin30 * IPHONE6_H_SCALE;
        CGFloat btnW = 70 * IPHONE6_W_SCALE;
        CGFloat btnH = btnW;
        
        _selectBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    if (self.imagesArr.count > 4 && self.imagesArr.count < 8) {
        UIImageView * imageView = [self.imagesArr lastObject];
        CGFloat btnX = CGRectGetMaxX(imageView.frame) + 37 * 0.5 * IPHONE6_W_SCALE;
        CGFloat btnY = CGRectGetMinY(imageView.frame);
        CGFloat btnW = 70 * IPHONE6_W_SCALE;
        CGFloat btnH = btnW;
        
        _selectBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    if (self.imagesArr.count == 8 ) {
        UIImageView * imageView = [self.imagesArr objectAtIndex:4];
        CGFloat btnX = CGRectGetMinX(imageView.frame);
        CGFloat btnY = CGRectGetMaxY(imageView.frame) + Margin30 * IPHONE6_H_SCALE;
        CGFloat btnW = 70 * IPHONE6_W_SCALE;
        CGFloat btnH = btnW;
        
        _selectBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    if (self.imagesArr.count == 9) {
        [_selectBtn removeFromSuperview];
    }
    if (self.imagesArr.count == 0) {
        CGFloat imageX = Margin30 * IPHONE6_W_SCALE;
        CGFloat imageY = Margin40 * IPHONE6_H_SCALE;
        CGFloat imageW = 70 * IPHONE6_W_SCALE;
        CGFloat imageH = imageW;
        _selectBtn.frame = CGRectMake(imageX, imageY, imageW, imageH);
    }
    
    
}



@end
