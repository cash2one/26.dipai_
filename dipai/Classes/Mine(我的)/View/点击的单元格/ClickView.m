//
//  ClickView.m
//  dipai
//
//  Created by 梁森 on 16/5/27.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ClickView.h"

@interface ClickView()

@property (nonatomic, strong) UIView * line;

@end

@implementation ClickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置子控件
        [self setUpChildControl];
//        self.backgroundColor = [UIColor yellowColor];
    }
    
    return self;
}
#pragma mark ---- 设置子控件 
- (void)setUpChildControl{
    // 图片
    UIImageView * pic = [[UIImageView alloc] init];
//    pic.backgroundColor = [UIColor redColor];
    [self addSubview:pic];
    _pic = pic;
    // 标题
    UILabel * textLbl = [[UILabel alloc] init];
//    textLbl.backgroundColor = [UIColor redColor];
    textLbl.font = Font16;
    [self addSubview:textLbl];
    _textLbl = textLbl;
    // accessView
    UIImageView * next = [[UIImageView alloc] init];
    next.image = [UIImage imageNamed:@"qianjin"];
    [self addSubview:next];
    _next = next;
    // 分割线
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = Color238;
    [self addSubview:line];
    _line = line;
    // 点击按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
//    [btn addTarget:self action:@selector(ClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _btn = btn;
    // 评论数
    UILabel * commentNum = [[UILabel alloc] init];
    commentNum.font = Font8;
    commentNum.textColor = [UIColor whiteColor];
    commentNum.backgroundColor = [UIColor redColor];
    commentNum.textAlignment = NSTextAlignmentCenter;
    [self addSubview:commentNum];
    commentNum.hidden = YES;
    _commentNum = commentNum;
}

- (void)setPicName:(NSString *)picName{
    _picName = picName;
    _pic.image = [UIImage imageNamed:picName];
}
- (void)setMessage:(NSString *)message{
    _message = message;
    _textLbl.text = message;
}

- (void)setW:(NSInteger)w{
    
    _w = w;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 图片
    CGFloat picX = Margin20 * IPHONE6_W_SCALE;
    CGFloat picY = Margin32 * IPHONE6_H_SCALE;
    CGFloat picW = Margin34 * IPHONE6_W_SCALE;
    CGFloat picH = picW;
    if (_w > 0) {
        picW = 16 * IPHONE6_W_SCALE;
        picH = 17 * IPHONE6_H_SCALE;
    }
    
#warning 发现Xcode的一个问题
//    _pic.frame = CGRectMake(picX, picY, picW, picH);
    _pic.frame = CGRectMake(picX, 16*IPHONE6_H_SCALE, picW, picH);
    // 标题
    CGFloat textX = CGRectGetMaxY(_pic.frame) + Margin22 * IPHONE6_W_SCALE;
    CGFloat textY = Margin33 * IPHONE6_H_SCALE;
    NSMutableDictionary * textDic = [NSMutableDictionary dictionary];
    textDic[NSFontAttributeName]  = Font16;
    CGSize textSize = [_textLbl.text sizeWithAttributes:textDic];
    _textLbl.frame = (CGRect){{textX, textY}, textSize};
    
    // accessView
    CGFloat nextX = WIDTH - (16+30)/2*IPHONE6_H_SCALE;
    CGFloat nextY = Margin34 * IPHONE6_H_SCALE;
    CGFloat nextW = Margin16 * IPHONE6_W_SCALE;
    CGFloat nextH = Margin30 * IPHONE6_H_SCALE;
    _next.frame = CGRectMake(nextX, nextY, nextW, nextH);
    // 分割线
    CGFloat lineX = 0;
    CGFloat lineY = 98 / 2 * IPHONE6_H_SCALE;
    CGFloat lineW = WIDTH;
    CGFloat lineH = 0.5;
    _line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    // 点击按钮
    _btn.frame = CGRectMake(0, 0, WIDTH, self.height);
    // 评论数
    CGFloat commentX = CGRectGetMaxX(_textLbl.frame) + Margin14 * IPHONE6_W_SCALE;
    CGFloat commentY = Margin33 * IPHONE6_H_SCALE;
    CGFloat commentW = Margin32 * IPHONE6_W_SCALE;
    CGFloat commentH = commentW;
    _commentNum.frame = CGRectMake(commentX, commentY, commentW, commentH);
    
    _commentNum.layer.masksToBounds = YES;
    _commentNum.layer.cornerRadius = commentW / 2;
    
    
}


@end
