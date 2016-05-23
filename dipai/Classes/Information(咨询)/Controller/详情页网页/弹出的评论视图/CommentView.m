//
//  CommentView.m
//  dipai
//
//  Created by 梁森 on 16/5/19.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 设置子控件
        [self setUpChildControl];
        // 对UITextView添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
}


// textView的内容发生变化后进行调用
- (void)textViewChanged
{
    // 如果有内容就隐藏占位符，没有内容就显示占位符
    if (_textView.text.length) {
        _textView.hidePlaceHolder = YES;    // 隐藏占位符
        _sendBtn.userInteractionEnabled = YES;   // 发表按钮可用
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"fabiao_xuanzhong"] forState:UIControlStateNormal];
    } else
    {
        _textView.hidePlaceHolder = NO; // 显示占位符
        _sendBtn.userInteractionEnabled = NO;   // 发表按钮可用
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"fabiao_moren"] forState:UIControlStateNormal];
    }
}

#pragma mark --- 设置子控件
- (void)setUpChildControl
{
    // 评论框
    LSTextView * textView = [[LSTextView alloc] init];
    textView.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
    textView.layer.borderWidth = 0.5;
    textView.placeholder = @"写评论...";
    [textView setFont:Font14];
    textView.placeHolderLabel.textColor = Color153;
    [self addSubview:textView];
    _textView = textView;
    // 发表按钮
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"fabiao_moren"] forState:UIControlStateNormal];
    sendBtn.userInteractionEnabled = NO;
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    _sendBtn = sendBtn;
}

#pragma mark --- 发表按钮的点击事件
- (void)sendMessage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [defaults objectForKey:UserName];
    if (!userName) {
        NSLog(@"请登录后再发表...");
        if ([self.delegate respondsToSelector:@selector(commnetView:sendMessage:)]) {
            [self.delegate commnetView:self sendMessage:nil];
        } else
        {
            NSLog(@"CommentView的代理没有响应...");
        }
    } else
    {
        NSLog(@"可以进行发表");
    }
}

#pragma mark --- 对子控件进行布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 评论框
    CGFloat textX = Margin30 * IPHONE6_W_SCALE;
    CGFloat textY = Margin26 * IPHONE6_H_SCALE;
    CGFloat textW = WIDTH - 2 * textX;
    CGFloat textH = Margin118 * IPHONE6_H_SCALE;
    _textView.frame = CGRectMake(textX, textY, textW, textH);
    // 发表按钮
    CGFloat sendBtnX = WIDTH - (Margin30 + Margin118) * IPHONE6_W_SCALE;
    CGFloat sendBtnY = CGRectGetMaxY(_textView.frame) + Margin20 * IPHONE6_H_SCALE;
    CGFloat sendBtnW = Margin118 * IPHONE6_W_SCALE;
    CGFloat sendBtnH = Margin58 * IPHONE6_H_SCALE;
    _sendBtn.frame = CGRectMake(sendBtnX, sendBtnY, sendBtnW, sendBtnH);
}

@end




