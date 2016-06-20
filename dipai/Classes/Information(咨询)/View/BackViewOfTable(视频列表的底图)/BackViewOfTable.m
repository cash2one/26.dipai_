//
//  BackViewOfTable.m
//  dipai
//
//  Created by 梁森 on 16/6/2.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "BackViewOfTable.h"

@implementation BackViewOfTable

+ (instancetype)showWithRect:(CGRect)rect
{
    BackViewOfTable * backView = [[BackViewOfTable alloc] initWithFrame:rect];
    // 让图片不难看的一个方法😄
    // 拦截点击事件
    [LSKeyWindow addSubview:backView];
    
    return backView;
}
// 隐藏
+ (void)hide
{
    // 从主窗口上一次本视图(图片视图不同于视图，不能直接移除)
    for (UIView * menuView in LSKeyWindow.subviews) {
        if ([menuView isKindOfClass:self]) {
            
            [menuView removeFromSuperview];
        }
    }
    
}

// 设置菜单的内容视图
- (void)setContenView:(UIView *)contentView
{
    [_contenView removeFromSuperview];
    _contenView = contentView;
    _contenView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算内容视图尺寸
    CGFloat y = 0;
    CGFloat margin = 0;
    CGFloat x = margin;
    CGFloat w = self.width - 2 * margin;
    CGFloat h = self.height - y - margin;
    _contenView.backgroundColor = [UIColor clearColor];
    _contenView.frame = CGRectMake(x, y, w, h);
    
}



@end
