//
//  ReplyView.m
//  dipai
//
//  Created by 梁森 on 16/6/7.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "ReplyView.h"
#import "CommentsFrame.h"
#import "CommentsModel.h"
@interface ReplyView()

/**
 *  昵称
 */
@property (nonatomic, strong) UILabel *nameView;
/**
 *  正文
 */
@property (nonatomic, strong) UILabel *textView;

@end

@implementation ReplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self setUpChildView];
        self.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1];
//         添加外框线和设置外框线颜色宽度
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor colorWithRed:216 / 255.0 green:216 / 255.0 blue:216 / 255.0 alpha:1] CGColor];
    }
    
    return self;
}
#pragma mark --- 添加子控件
- (void)setUpChildView{
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = Font13;
    [self addSubview:nameView];
    _nameView = nameView;
    
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = Font14;
    textView.numberOfLines = 0;
    [self addSubview:textView];
    _textView = textView;
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
    
//    CommentsModel * commentsModel = _commentsFrame.comments;
    
    // 昵称
    _nameView.frame = _commentsFrame.replyName;
    
    // 正文
    _textView.frame = _commentsFrame.replyContent;
}
#pragma mark --- 设置数据
- (void)setUpData{
    
    CommentsModel * commentsModel = _commentsFrame.comments;
    
    // 昵称
    _nameView.text = commentsModel.reply[@"username"];
    _nameView.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    
    // 正文
    _textView.text = commentsModel.reply[@"content"];
}

@end
