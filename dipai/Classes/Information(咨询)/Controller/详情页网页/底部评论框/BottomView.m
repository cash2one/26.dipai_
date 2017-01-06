//
//  BottomView.m
//  dipai
//
//  Created by 梁森 on 16/5/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "BottomView.h"

@interface BottomView()
/**
 *  上横线
 */
@property (nonatomic, strong) UIView * linewView;
/**
 *  评论框
 */
@property (nonatomic, strong) UIButton * commentBtn;
/**
 *  查看评论按钮
 */
@property (nonatomic, strong) UIButton * lookBtn;

/**
 *  分享按钮
 */
@property (nonatomic, strong) UIButton * shareBtn;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置子控件
        [self setUpChildControl];
    }
    
    return self;
}
#pragma mark --- 设置子控件
- (void)setUpChildControl
{
    // 上横线
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = Color216;
    [self addSubview:lineView];
    _linewView = lineView;
    // 评论框
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"xiepinglun"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.tag = 100;
    [self addSubview:commentBtn];
    _commentBtn = commentBtn;
    
    // 查看评论按钮
    UIButton * lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookBtn setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
    [lookBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    lookBtn.tag = 101;
    [self addSubview:lookBtn];
    _lookBtn = lookBtn;
    
    // 评论数标签
    UILabel * commentsLbl = [[UILabel alloc] init];
    commentsLbl.textAlignment = NSTextAlignmentCenter;
    commentsLbl.textColor = [UIColor whiteColor];
    [commentsLbl setFont:Font9];
    commentsLbl.backgroundColor = [UIColor redColor];
    [self addSubview:commentsLbl];
    commentsLbl.hidden = YES;
    _commentsLbl = commentsLbl;
    
    // 收藏按钮
    UIButton * collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionBtn setImage:[UIImage imageNamed:@"shoucang_moren"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"shoucang_xuanzhong"] forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    collectionBtn.tag = 102;
    [self addSubview:collectionBtn];
    _collectionBtn = collectionBtn;
    // 分享按钮
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = 103;
    [self addSubview:shareBtn];
    _shareBtn = shareBtn;
}
#pragma mark －－－ 子控件的点击事件
- (void)clickAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
            // 写评论
            if ([self.delegate respondsToSelector:@selector(commentAction)]) {
                [self.delegate commentAction];
            } else
            {
                NSLog(@"BottomView的代理没有响应...");
            }
            break;
        case 101:
            // 查看评论
            if ([self.delegate respondsToSelector:@selector(lookCommentsAction)]) {
                [self.delegate lookCommentsAction];
            } else
            {
                NSLog(@"BottomView的代理没有响应...");
            }
            break;
        case 102:
            // 收藏
            if ([self.delegate respondsToSelector:@selector(collectionAction)]) {
                [self.delegate collectionAction];
            } else
            {
                NSLog(@"BottomView的代理没有响应...");
            }
            break;
        case 103:
            // 分享
            if ([self.delegate respondsToSelector:@selector(shareAction)]) {
                [self.delegate shareAction];
            } else
            {
                NSLog(@"BottomView的代理没有响应...");
            }
            break;
            
        default:
            break;
    }
}

- (void)SetButtonWithImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    btn.tag = self.subviews.count;
    
    [self addSubview:btn];
}




#pragma mark --- 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 上横线
    CGFloat lineX = 0;
    CGFloat lineY = 0;
    CGFloat lineW = WIDTH;
    CGFloat lineH = 0.5;
    _linewView.frame = CGRectMake(lineX, lineY, lineW, lineH);
    // 评论按钮
    CGFloat commentBtnX = Margin30 * IPHONE6_W_SCALE;
    CGFloat commentBtnY = CGRectGetMaxY(_linewView.frame) + Margin14 * IPHONE6_H_SCALE;
    CGFloat commentBtnW = Margin376 * IPHONE6_W_SCALE;
    CGFloat commentBtnH = Margin64 * IPHONE6_H_SCALE;
    _commentBtn.frame = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    // 查看评论按钮
    CGFloat lookBtnX = CGRectGetMaxX(_commentBtn.frame) + Margin52 * IPHONE6_W_SCALE;
    CGFloat lookBtnY = Margin23 * IPHONE6_H_SCALE;
    CGFloat lookBtnW = Margin46 * IPHONE6_W_SCALE;
    CGFloat lookBtnH = lookBtnW;
    _lookBtn.frame = CGRectMake(lookBtnX, lookBtnY, lookBtnW, lookBtnH);
    // 评论数标签
    CGFloat commentsLblX = lookBtnX + Margin20 * IPHONE6_W_SCALE;
    CGFloat commentsLblY = Margin14 * IPHONE6_H_SCALE;
    CGFloat commentsLblW = Margin40 * IPHONE6_W_SCALE;
    CGFloat commentsLblH = Margin22 * IPHONE6_W_SCALE;
    _commentsLbl.frame = CGRectMake(commentsLblX, commentsLblY, commentsLblW, commentsLblH);
    _commentsLbl.clipsToBounds = YES;
    _commentsLbl.layer.cornerRadius = 5;
    
    // 收藏安妮
    CGFloat collectX = CGRectGetMaxX(_lookBtn.frame) + Margin60 * IPHONE6_W_SCALE;
    CGFloat collectY = lookBtnY;
    CGFloat collectW = lookBtnW;
    CGFloat collectH = lookBtnH;
    _collectionBtn.frame = CGRectMake(collectX, collectY, collectW, collectH);
    // 分享按钮
    CGFloat shareBtnX = CGRectGetMaxX(_collectionBtn.frame) + Margin60 * IPHONE6_W_SCALE;
    CGFloat shareBtnY = Margin27 * IPHONE6_H_SCALE;
    CGFloat shareBtnW = Margin40 * IPHONE6_W_SCALE;
    CGFloat shareBtnH = Margin42 * IPHONE6_W_SCALE;
    _shareBtn.frame = CGRectMake(shareBtnX, shareBtnY, shareBtnW, shareBtnH);
    
}


@end
