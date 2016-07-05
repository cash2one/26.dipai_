//
//  GroupBotView.m
//  dipai
//
//  Created by 梁森 on 16/7/4.
//  Copyright © 2016年 梁森. All rights reserved.
//

#import "GroupBotView.h"

#import "GroupFrameModel.h"

@interface GroupBotView()

/**
 *  昵称
 */
@property (nonatomic, strong) UILabel *nameView;
/**
 *  正文
 */
@property (nonatomic, strong) UILabel *textView;

@end

@implementation GroupBotView

- (void)setFrameModel:(GroupFrameModel *)frameModel{
    _frameModel = frameModel;
    // 设置frame
    [self setUpFrame];
    // 设置data
    [self setUpData];
}

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



#pragma mark --- 设置frame
- (void)setUpFrame{
    
    // 昵称
    _nameView.frame = _frameModel.replyName;
    
    // 正文
    _textView.frame = _frameModel.replyContent;
}
#pragma mark --- 设置数据
- (void)setUpData{
    
    // 昵称
    _nameView.text = _frameModel.groupModel.reply[@"username"];
    _nameView.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    
    // 正文
    _textView.text = _frameModel.groupModel.reply[@"content"];
}
@end
