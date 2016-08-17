//
//  CommentsView.m
//  dipai
//
//  Created by 梁森 on 16/6/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CommentsView.h"
#import "CommentsFrame.h"
#import "CommentsModel.h"

#import "UIImageView+WebCache.h"

#import "Masonry.h"
@interface CommentsView()
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *iconView;
/**
 *  昵称
 */
@property (nonatomic, strong) UILabel *nameView;
/**
 *  时间
 */
@property (nonatomic, strong) UILabel *timeView;
/**
 *  正文
 */
@property (nonatomic, strong) UILabel *textView;
/**
 *  点击视图
 */
@property (nonatomic, strong) UIView * clickView;

@end

@implementation CommentsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self setUpChildView];
        
//        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}
#pragma mark --- 添加子控件
- (void)setUpChildView{
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 19 * IPHONE6_W_SCALE;
    iconView.layer.masksToBounds = YES;
    [self addSubview:iconView];
    _iconView = iconView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFace)];
    iconView.userInteractionEnabled = YES;
    [iconView addGestureRecognizer:tap];
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = Font15;
    [self addSubview:nameView];
    _nameView = nameView;

    // 时间
    // 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.font = Font11;
    timeView.textColor = Color153;
    [self addSubview:timeView];
    _timeView = timeView;
    
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = Font16;
    textView.numberOfLines = 0;
    [self addSubview:textView];
    _textView = textView;
    
    // 点击视图
    UIView * clickView = [[UIView alloc] init];
    [self addSubview:clickView];
    _clickView = clickView;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyAction:)];
    clickView.userInteractionEnabled = YES;
    [clickView addGestureRecognizer:tap2];
}

// 点击回复或评论视图
- (void)replyAction:(UITapGestureRecognizer *)tap2{
//    NSLog(@"回复。。。。");
    if ([self.delegate respondsToSelector:@selector(showReplyBtnAndCheckBtn)]) {
        [self.delegate showReplyBtnAndCheckBtn];
    } else{
        NSLog(@"CommentsView的代理没有响应");
    }
}
// 点击头像
- (void)clickFace{
    if ([self.delegate respondsToSelector:@selector(didClickFace)]) {
        [self.delegate didClickFace];
    }else{
        NSLog(@"点击头像时，代理没有响应");
    }
}

- (void)setCommentsFrame:(CommentsFrame *)commentsFrame{
    _commentsFrame = commentsFrame;
    // 设置frame
    [self setUpFrame];
    // 设置data
    [self setUpData];
}

#pragma mark --- 设置frame
- (void)setUpFrame{
    
    CommentsModel * commentsModel = _commentsFrame.comments;
    
    // 头像
    _iconView.frame = _commentsFrame.faceFrame;
    
    // 昵称
    _nameView.frame = _commentsFrame.nameFrame;
    
    // 时间
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + Margin14 * IPHONE6_H_SCALE;
    NSMutableDictionary * timeDic = [NSMutableDictionary dictionary];
    timeDic[NSFontAttributeName] = Font11;
    CGSize timeSize = [commentsModel.addtime sizeWithAttributes:timeDic];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    
    // 正文
    _textView.frame = _commentsFrame.contentsFrame;
    
    [_clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
#pragma mark --- 设置数据
- (void)setUpData{
    
    CommentsModel * commentsModel = _commentsFrame.comments;
    
    // 头像
    NSURL * url = [NSURL URLWithString:commentsModel.face];
//    _iconView.backgroundColor = [UIColor redColor];
    [_iconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];
    
    // 昵称
    _nameView.text = commentsModel.username;
    _nameView.textColor = [UIColor colorWithRed:228 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
    
    // 时间
    _timeView.text = commentsModel.addtime;
    
    // 正文
    _textView.text = commentsModel.content;
}


@end
